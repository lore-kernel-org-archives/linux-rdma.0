From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 1/3] overflow.h: Add arithmetic shift helper
Date: Tue, 31 Jul 2018 20:15:08 -0600
Message-ID: <20180801021508.GB31192@ziepe.ca>
References: <20180801000039.44314-1-keescook@chromium.org>
 <20180801000039.44314-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180801000039.44314-2-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Leon Romanovsky <leonro@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 31, 2018 at 05:00:37PM -0700, Kees Cook wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> Add shift_overflow() helper to assist driver authors in ensuring that
> shift operations don't cause overflows or other odd conditions.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> [kees: tweaked comments and commit log, dropped unneeded assignment]
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/overflow.h | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/include/linux/overflow.h b/include/linux/overflow.h
> index 8712ff70995f..69fc366ce865 100644
> --- a/include/linux/overflow.h
> +++ b/include/linux/overflow.h
> @@ -202,6 +202,37 @@
>  
>  #endif /* COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW */
>  
> +/** check_shift_overflow() - Calculate a left-shifted value and check overflow
> + *
> + * @a: Value to be shifted
> + * @b: How many bits left to shift

The above @b should be @s

> +#define check_shift_overflow(a, s, d) ({				\

Should I run this series through the rdma tree?

Thanks,
Jason
