From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch] IB: vmw_pvrdma: info leak in pvrdma_alloc_ucontext()
Date: Wed, 4 Jan 2017 09:40:59 -0800
Message-ID: <ba4d19a7-a5c0-8cf6-30d3-23df3cdb002d@vmware.com>
References: <20170104064110.GA8957@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170104064110.GA8957-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: VMware PV-Drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 04, 2017 at 09:41:11AM +0300, Dan Carpenter wrote:
> We need to clear out the ->reserved member so we don't disclose
> uninitialized stack information.
> 
> Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> There are a bunch of ways to fix this...  I just the most mindless one
> because I can never guess what IB prefers.  Feel free to fix it however
> you feel is appropriate and give me a Reported-by tag.
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> index 54891370d18a..c00c27f48f46 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
> @@ -339,6 +339,7 @@ struct ib_ucontext *pvrdma_alloc_ucontext(struct ib_device *ibdev,
>  	context->ctx_handle = resp->ctx_handle;
>  
>  	/* copy back to user */
> +	memset(&uresp, 0, sizeof(uresp));
>  	uresp.qp_tab_size = vdev->dsr->caps.max_qp;
>  	ret = ib_copy_to_udata(udata, &uresp, sizeof(uresp));
>  	if (ret) {
> 

Thanks Dan! I'll add this to the other fixes to be sent out.

- Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
