From: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx5: Fix device context allocation
Date: Tue, 28 Mar 2017 10:47:55 +0300
Message-ID: <959ef3f8-4e94-c1ca-366e-cbd35aef1c44@dev.mellanox.co.il>
References: <1490618609-16931-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490618609-16931-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/27/2017 3:43 PM, Yishai Hadas wrote:
> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Use calloc to allocate device context so the unset bytes are zero.
> When building a *non* release mode (i.e. without DCMAKE_BUILD_TYPE=Release)
> the below assert is applicable and might raise:
> assert(dev->_ops._dummy1).
>
> Fix below commit to use calloc instead of malloc for mlx5 as well.
>
> Fixes: 85c449528709 ("providers: Make every provider allocate a
> verbs_device")
> Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>
> Pull request was sent:
> https://github.com/linux-rdma/rdma-core/pull/109
>
>  providers/mlx5/mlx5.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
> index edb6d35..30f165b 100644
> --- a/providers/mlx5/mlx5.c
> +++ b/providers/mlx5/mlx5.c
> @@ -1006,7 +1006,7 @@ found:
>  		return NULL;
>  	}
>
> -	dev = malloc(sizeof *dev);
> +	dev = calloc(1, sizeof *dev);
>  	if (!dev) {
>  		fprintf(stderr, PFX "Fatal: couldn't allocate device for %s\n",
>  			uverbs_sys_path);
>

Merged.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
