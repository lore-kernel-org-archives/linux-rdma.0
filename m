From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ib umem: bug: put pid back before return from error path
Date: Thu, 22 Dec 2016 13:03:15 +0200
Message-ID: <fdb6cae7-a914-fb10-1eab-6f77f2a32cba@mellanox.com>
References: <1482390692-147946-1-git-send-email-liguozhu@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482390692-147946-1-git-send-email-liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: robin.murphy-5wv7dgnIgG8@public.gmane.org, jroedel-l3A5Bk7waGM@public.gmane.org, egtvedt-BrfabpQBY5qlHtIdYg32fQ@public.gmane.org, vgupta-HKixBCOQz3hWk0Htik3J/w@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Kovalyov Artemy <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/22/2016 9:11 AM, Kenneth Lee wrote:
> I catched this bug when reading the code. I'm sorry I have no hardware to test
> it. But it is abviously a bug.
> 
> Signed-off-by: Kenneth Lee <liguozhu-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>
> ---
>  drivers/infiniband/core/umem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 1e62a5f..4609b92 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -134,6 +134,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  		 IB_ACCESS_REMOTE_ATOMIC | IB_ACCESS_MW_BIND));
>  
>  	if (access & IB_ACCESS_ON_DEMAND) {
> +		put_pid(umem->pid);
>  		ret = ib_umem_odp_get(context, umem);
>  		if (ret) {
>  			kfree(umem);
> @@ -149,6 +150,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
>  
>  	page_list = (struct page **) __get_free_page(GFP_KERNEL);
>  	if (!page_list) {
> +		put_pid(umem->pid);
>  		kfree(umem);
>  		return ERR_PTR(-ENOMEM);
>  	}
> 

Looks good to me. Thanks!

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
