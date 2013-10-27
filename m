From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Sun, 27 Oct 2013 14:58:31 -0700
Message-ID: <1382911111.30941.2.camel@joe-AO722>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
	 <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382910645.2994.45.camel-nDn/Rdv9kqW9Jme8/bJn5UCKIB8iOfG2tUK59QYPAWc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, 2013-10-27 at 21:50 +0000, Ben Hutchings wrote:
> Physical addresses may be wider than virtual addresses (e.g. on i386
> with PAE) and must not be formatted with %p.

%pa works.  %pa also prefixes with 0x.

> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
[]
> @@ -602,10 +602,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>  	     rdev->lldi.vr->qp.size,
>  	     rdev->lldi.vr->cq.start,
>  	     rdev->lldi.vr->cq.size);
> -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
>  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
>  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> -	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
> +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
>  	     rdev->lldi.db_reg,
>  	     rdev->lldi.gts_reg,
>  	     rdev->qpshift, rdev->qpmask,
> 
> 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
