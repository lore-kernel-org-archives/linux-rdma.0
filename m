From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/3] overflow.h: Add arithmetic shift helper
Date: Tue, 31 Jul 2018 18:59:42 -0700
Message-ID: <6ce83c62-ef7a-7548-b61f-825a28bffb95@infradead.org>
References: <20180801000039.44314-1-keescook@chromium.org>
 <20180801000039.44314-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180801000039.44314-2-keescook@chromium.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Doug Ledford <dledford@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 07/31/2018 05:00 PM, Kees Cook wrote:
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
> + * @d: Pointer to where to store the result
> + *
> + * Computes *@d = (@a << @s)

                            @b)

> + *
> + * Returns true if '*d' cannot hold the result or when 'a << s' doesn't
> + * make sense. Example conditions:
> + * - 'a << s' causes bits to be lost when stored in *d.
> + * - 's' is garbage (e.g. negative) or so large that the result of
> + *   'a << s' is guaranteed to be 0.
> + * - 'a' is negative.
> + * - 'a << s' sets the sign bit, if any, in '*d'.
> + *
> + * '*d' will hold the results of the attempted shift, but is not
> + * considered "safe for use" if false is returned.
> + */
> +#define check_shift_overflow(a, s, d) ({				\
> +	typeof(a) _a = a;						\
> +	typeof(s) _s = s;						\
> +	typeof(d) _d = d;						\
> +	u64 _a_full = _a;						\
> +	unsigned int _to_shift =					\
> +		_s >= 0 && _s < 8 * sizeof(*d) ? _s : 0;		\
> +	*_d = (_a_full << _to_shift);					\
> +	(_to_shift != _s || *_d < 0 || _a < 0 ||			\
> +		(*_d >> _to_shift) != _a);				\
> +})
> +
>  /**
>   * array_size() - Calculate size of 2-dimensional array.
>   *
> 


-- 
~Randy
