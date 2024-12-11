use crate::console;
use core::fmt;

#[doc(hidden)]
pub fn _print(args: fmt::Arguments) {
    use console::interface::Write;

    console::console().write_fmt(args).unwrap();
}

/// print
#[macro_export]
macro_rules! print {
    ($($arg:tt)*) => ($craet::print::_print(format_args!($($arg)*)));
}

/// println
#[macro_export]
macro_rules! println {
    () => ($crate::print!("\n"));
    ($($arg:tt)*) => ({
        $crate::print::_print(format_args_nl!($($arg)*));
    });
}
