From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libmlx5 V1 6/6] Add always_inline check
Date: Mon, 7 Dec 2015 15:07:42 +0200
Message-ID: <5665849E.4000304@mellanox.com>
References: <1449158571-26228-1-git-send-email-matanb@mellanox.com>
 <1449158571-26228-7-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449158571-26228-7-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/03/2015 06:02 PM, Matan Barak wrote:
> Always inline isn't supported by every compiler. Adding it to
> configure.ac in order to support it only when possible.
> Inline other poll_one data path functions in order to eliminate
> "ifs".
> 
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  configure.ac | 17 +++++++++++++++++
>  src/cq.c     | 42 +++++++++++++++++++++++++++++-------------
>  src/mlx5.h   |  6 ++++++
>  3 files changed, 52 insertions(+), 13 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index fca0b46..50b4f9c 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -65,6 +65,23 @@ AC_CHECK_FUNC(ibv_read_sysfs_file, [],
>      AC_MSG_ERROR([ibv_read_sysfs_file() not found.  libmlx5 requires libibverbs >= 1.0.3.]))
>  AC_CHECK_FUNCS(ibv_dontfork_range ibv_dofork_range ibv_register_driver)
>  
> +AC_MSG_CHECKING("always inline")
Did you consider using an existing script like AX_GCC_FUNC_ATTRIBUTE [1]?

> +CFLAGS_BAK="$CFLAGS"
> +CFLAGS="$CFLAGS -Werror"
> +AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
> +	static inline int f(void)
> +		__attribute__((always_inline));
> +	static inline int f(void)
> +	{
> +		return 1;
> +	}
> +]],[[
> +		int a = f();
> +		a = a;
> +]])], [AC_MSG_RESULT([yes]) AC_DEFINE([HAVE_ALWAYS_INLINE], [1], [Define if __attribute((always_inline)).])]
The description here doesn't look right. How about "Define if
__attribute__((always_inline) is supported"?

Regards,
Haggai

[1] https://www.gnu.org/software/autoconf-archive/ax_gcc_func_attribute.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
