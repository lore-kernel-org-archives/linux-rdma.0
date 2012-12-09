From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/3] Avoid linker error with clang 3.0
Date: Sun, 09 Dec 2012 14:23:37 +0100
Message-ID: <50C490D9.1000301@acm.org>
References: <alpine.BSF.2.00.1212090306300.64779@toaster.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.BSF.2.00.1212090306300.64779-Fqwm7F1mg36Nj9Bq2fkWzw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/09/12 12:07, Garrett Cooper wrote:
> It seems that there's a bug when linking inlined functions with clang; this
> issue will need to be upstreamed and reverified with clang 3.2.
> 
> Signed-off-by: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>   osmtest/osmtest.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/osmtest/osmtest.c b/osmtest/osmtest.c
> index 68b0e40..4f56106 100644
> --- a/osmtest/osmtest.c
> +++ b/osmtest/osmtest.c
> @@ -3068,7 +3068,7 @@ Exit:
>       return (status);
>   }
> 
> -inline uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
> +static uint32_t osmtest_path_rec_key_get(IN const ib_path_rec_t * const p_rec)
>   {
>       return (p_rec->dlid << 16 | p_rec->slid);
>   }

Why was the "inline" keyword dropped ? You didn't explain that in the patch description.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
