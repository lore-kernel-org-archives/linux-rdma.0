From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] vmw_pvrdma: switch to pci_alloc_irq_vectors
Date: Thu, 16 Feb 2017 12:29:49 -0800
Message-ID: <65511366-0aca-880c-23bb-a334b2ff26d2@vmware.com>
References: <20170215074704.2599-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215074704.2599-1-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 15, 2017 at 08:47:04AM +0100, Christoph Hellwig wrote:
> .. and greatly clean up the irq handling boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |   8 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |   6 -
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 162 +++++-----------------
>  3 files changed, 34 insertions(+), 142 deletions(-)

Thanks.

Acked-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
