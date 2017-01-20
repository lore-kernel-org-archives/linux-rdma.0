From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 28/37] IB/vmw_pvrdma: Switch from dma_device to
 dev.parent
Date: Fri, 20 Jan 2017 13:54:08 -0800
Message-ID: <439a8a3f-c3bf-485c-a870-53b5a02653e3@vmware.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
 <20170120210437.26389-29-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170120210437.26389-29-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, VMware PV-Drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jan 20, 2017 at 1:04:28PM -0800, Bart Van Assche wrote:
> Prepare for removal of ib_device.dma_device.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> Cc: VMware PV-Drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> index 231a1ce1f4be..214793d51409 100644
> --- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> +++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
> @@ -172,7 +172,7 @@ static int pvrdma_register_device(struct pvrdma_dev *dev)
>  	dev->flags = 0;
>  	dev->ib_dev.owner = THIS_MODULE;
>  	dev->ib_dev.num_comp_vectors = 1;
> -	dev->ib_dev.dma_device = &dev->pdev->dev;
> +	dev->ib_dev.dev.parent = &dev->pdev->dev;
>  	dev->ib_dev.uverbs_abi_ver = PVRDMA_UVERBS_ABI_VERSION;
>  	dev->ib_dev.uverbs_cmd_mask =
>  		(1ull << IB_USER_VERBS_CMD_GET_CONTEXT)		|

Acked-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

Thanks,
Adit

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
