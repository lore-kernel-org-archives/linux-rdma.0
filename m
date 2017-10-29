From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next] RDMA/cxgb4: Protect from possible dereference
Date: Sun, 29 Oct 2017 16:29:50 -0500
Message-ID: <001201d350fd$0dd04fa0$2970eee0$@opengridcomputing.com>
References: <20171029193435.314-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029193435.314-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Smatch tool reports the following error:
>   drivers/infiniband/hw/cxgb4/qp.c:1886
> 	c4iw_create_qp() error: we previously assumed 'ucontext'
> 	could be null (see line 1804)
> 
> Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/qp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c
> b/drivers/infiniband/hw/cxgb4/qp.c
> index 57b23e33eb8b..4b3267358dff 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -1843,7 +1843,7 @@ struct ib_qp *c4iw_create_qp(struct ib_pd *pd,
> struct ib_qp_init_attr *attrs,
>  	if (ret)
>  		goto err_destroy_qp;
> 
> -	if (udata) {
> +	if (udata && ucontext) {
>  		sq_key_mm = kmalloc(sizeof(*sq_key_mm), GFP_KERNEL);
>  		if (!sq_key_mm) {
>  			ret = -ENOMEM;


Hey Leon, doesn't udata imply ucontext?   It's not a big deal, though, I
guess.

Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
