/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_printf.c                                        :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mtarza13 <mtarza13@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025-03-22 03:18:51 by mtarza13          #+#    #+#             */
/*   Updated: 2025-03-22 03:18:51 by mtarza13         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <stdarg.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>

static int	ft_putchar(char c)
{
	return (write(1, &c, 1));
}

static int	ft_putstr(char *str)
{
	int	i;

	i = 0;
	if (!
		str = "(null)";
	while (str[i])
		i++;
	return (write(1, str, i));
}


	count = 0;
	if (n < 0)
	{
		count += write(1, "-", 1);
		n = -n;
	}
	if (n >= base)
		count += ft_putnbr_base(n / base, base, digits);
	count += write(1, &digits[n % base], 1);
	return (count);
}

static int	ft_putptr(uintptr_t ptr)
{
	int		count;
	char	*digits;

	digits = "0123456789abcdef";
	count = 0;
	if (ptr == 0)
		return (write(1, "(nil)", 5));
	count += write(1, "0x", 2);
	if (ptr >= 16)
		count += ft_putptr(ptr / 16);
	count += write(1, &digits[ptr % 16], 1);
	return (count);
}

static int	ft_handle_format(const char format, va_list args)
{
	if (format == 'c')
		return (ft_putchar(va_arg(args, int)));
	else if (format == 's')
		return (ft_putstr(va_arg(args, char *)));
	else if (format == 'd' || format == 'i')
		return (ft_putnbr_base(va_arg(args, int), 10, "0123456789"));
	else if (format == 'u')
		return (ft_putnbr_base(va_arg(args, unsigned int), 10, "0123456789"));
	else if (format == 'x')
		return (ft_putnbr_base(va_arg(args, unsigned int), 16, "0123456789abcdef"));
	else if (format == 'X')
		return (ft_putnbr_base(va_arg(args, unsigned int), 16, "0123456789ABCDEF"));
	else if (format == 'p')
		return (ft_putptr((uintptr_t)va_arg(args, void *)));
	else if (format == '%')
		return (ft_putchar('%'));
	return (0);
}

int	ft_printf(const char *format, ...)
{
	int		count;
	va_list	args;

	count = 0;
	va_start(args, format);
	while (*format)
	{
		if (*format == '%' && *(format + 1))
		{
			format++;
			count += ft_handle_format(*format, args);
		}
		else if (*format != '%')
			count += ft_putchar(*format);
		format++;
	}
	va_end(args);
	return (count);
}