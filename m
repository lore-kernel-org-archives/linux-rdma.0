From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
Date: Tue, 20 Dec 2011 18:35:50 -0800
Message-ID: <1324434950.14214.3.camel@joe2Laptop>
References: <1324430940.2844.144.camel@deadeye>
	 <1324431127.2844.146.camel@deadeye>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1324431127.2844.146.camel@deadeye>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2011-12-21 at 01:32 +0000, Ben Hutchings wrote:
> Physical addresses may be wider than virtual addresses (e.g. on i386
> with PAE) and must not be formatted with %p.
[]
> The resource could alternately be formatted with %Pr.
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
[]
> @@ -318,10 +318,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>  	     rdev->lldi.vr->qp.size,
>  	     rdev->lldi.vr->cq.start,
>  	     rdev->lldi.vr->cq.size);
> -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
>  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
>  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> -	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
> +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),

Probably should be unsigned long long


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
