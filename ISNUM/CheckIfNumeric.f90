!*********************************************************************
! Program: isnum
! Unix-style numeric validator (coreutils-style CLI)
!
! Exit codes:
!   0 = valid number
!   1 = invalid number
!   2 = usage error
!*********************************************************************

module Utilities
    implicit none
contains

    logical function is_numeric(str)
        character(len=*), intent(in) :: str
        integer :: ios
        real :: x

        read(str, *, iostat=ios) x
        is_numeric = (ios == 0)

    end function is_numeric

end module Utilities


program isnum
    use Utilities
    implicit none

    character(len=256) :: arg, line
    logical :: ok, quiet, help
    integer :: i, argc

    quiet = .false.
    help = .false.
    argc = command_argument_count()

    ! -----------------------------
    ! PARSE ARGUMENTS
    ! -----------------------------
    do i = 1, argc
        call get_command_argument(i, arg)

        select case (trim(arg))

        case ("-q", "--quiet")
            quiet = .true.

        case ("-h", "--help")
            help = .true.

        end select
    end do

    ! -----------------------------
    ! HELP OUTPUT
    ! -----------------------------
    if (help) then
        write(*,*) "Usage: isnum [-q] <string>|stdin"
        write(*,*) "       isnum -h | --help"
        write(*,*) ""
        write(*,*) "Checks whether input is numeric."
        write(*,*) ""
        write(*,*) "Exit codes:"
        write(*,*) "  0 = valid number"
        write(*,*) "  1 = invalid number"
        write(*,*) "  2 = usage error"
        call exit(0)
    end if

    ! -----------------------------
    ! USAGE CHECK
    ! -----------------------------
    if (argc == 0) then
        write(0,*) "Usage: isnum [-q] <string>|stdin"
        call exit(2)
    end if

    ! -----------------------------
    ! INVALID CASE: -q alone
    ! -----------------------------
    if (quiet .and. argc == 1) then
        call exit(2)
    end if

    ! -----------------------------
    ! SINGLE ARG MODE
    ! -----------------------------
    if (argc == 1 .and. .not. quiet) then
        call get_command_argument(1, arg)

        ok = is_numeric(trim(arg))

        if (ok) then
            write(*,'(A,1X,A)') trim(arg), "valid"
            call exit(0)
        else
            write(*,'(A,1X,A)') trim(arg), "invalid"
            call exit(1)
        end if
    end if

    ! -----------------------------
    ! STDIN MODE (PIPE SUPPORT)
    ! -----------------------------
    if (argc == 1 .and. quiet) then
        do
            read(*,'(A)', end=100) line

            ok = is_numeric(trim(line))

            if (.not. quiet) then
                if (ok) then
                    write(*,'(A,1X,A)') trim(line), "valid"
                else
                    write(*,'(A,1X,A)') trim(line), "invalid"
                end if
            end if
        end do

100     call exit(0)
    end if

    ! -----------------------------
    ! MULTI-ARG MODE
    ! -----------------------------
    do i = 1, argc
        call get_command_argument(i, arg)

        if (trim(arg) == "-q" .or. trim(arg) == "--quiet") cycle
        if (trim(arg) == "-h" .or. trim(arg) == "--help") cycle

        ok = is_numeric(trim(arg))

        if (.not. quiet) then
            if (ok) then
                write(*,'(A,1X,A)') trim(arg), "valid"
            else
                write(*,'(A,1X,A)') trim(arg), "invalid"
            end if
        end if

        if (.not. ok) then
            call exit(1)
        end if
    end do

    call exit(0)

end program isnum
