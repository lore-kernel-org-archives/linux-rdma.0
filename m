From: "Estrin, Alex" <alex.estrin@intel.com>
Subject: RE: [PATCH v2 00/26] IB: Optimize DMA mapping
Date: Fri, 13 Jan 2017 21:08:46 +0000
Message-ID: <F3529576D8E232409F431C309E29399336C5FF78@CRSMSX102.amr.corp.intel.com>
References: <20170112190718.6728-1-bart.vanassche@sandisk.com>
         <F3529576D8E232409F431C309E29399336C5FF0F@CRSMSX102.amr.corp.intel.com>
 <1484338667.2679.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484338667.2679.15.camel@sandisk.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dledford@redhat.com" <dledford@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-Id: linux-rdma@vger.kernel.org


> 
> Hello Alex,
> 
> Sorry for this. Can you check whether the patch below fixes this regression?
> 
> diff --git a/drivers/infiniband/sw/rdmavt/vt.c
> b/drivers/infiniband/sw/rdmavt/vt.c
> index 6a81b179f631..f7fcd015ec09 100644
> --- a/drivers/infiniband/sw/rdmavt/vt.c
> +++ b/drivers/infiniband/sw/rdmavt/vt.c
> @@ -778,8 +778,7 @@ int rvt_register_device(struct rvt_dev_info *rdi)
>  	}
> 
>  	/* DMA Operations */
> -	if (rdi->ibdev.dma_device->dma_ops == NULL)
> -		set_dma_ops(rdi->ibdev.dma_device, &dma_virt_ops);
> +	set_dma_ops(rdi->ibdev.dma_device, &dma_virt_ops);
> 
>  	/* Protection Domain */
>  	spin_lock_init(&rdi->n_pds_lock);
> --
> 2.11.0
> 
> I will make sure that this series applies cleanly on top of v4.10-rc3 when I
> repost it.
> 
> Bart.

Hi Bart,
It didn't fix the failure... Apparently there is an issue with generic mapping itself. 
Thanks,
Alex.
