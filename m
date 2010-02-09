From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] [for-2.6.33] rdma/cm: revert associating an RDMA device
 when binding to loopback
Date: Tue, 09 Feb 2010 09:29:33 -0600
Message-ID: <4B717F5D.8020403@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com>	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>	<4B6D9948.6040007@opengridcomputing.com>	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>	<79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>	<4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com> <adawrynwtz9.fsf@roland-alpha.cisco.com> <421D3D6710E847C5B7CAC00EB73117C4@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <421D3D6710E847C5B7CAC00EB73117C4-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch works.  It also backports cleanly to ofed-1.5.1/RH5.3.

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Steve.


Sean Hefty wrote:
> Revert the following change from commit
> 6f8372b69c3198e06cecb1df2cb9682d0c55e657:
>
>    The defined behavior of rdma_bind_addr is to associate an RDMA
>    device with an rdma_cm_id, as long as the user specified a non-
>    zero address.  (ie they weren't just trying to reserve a port)
>    Currently, if the loopback address is passed to rdma_bind_addr,
>    no device is associated with the rdma_cm_id.  Fix this.
>
> It turns out that openmpi depends on rdma_bind_addr NOT associating
> any RDMA device when binding to a loopback address.  Openmpi is
> being updated to correct this, but until a new openmpi release is
> available, maintain the previous behavior: allow rdma_bind_addr to
> succeed, but do not bind to a device.
>
> Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
> I believe this patch comes the closest to matching the behavior of
> rdma_bind_addr from 2.6.32 and before without completely reverting
> all support for loopback connections.  Loopback connections will
> work, but rdma_bind_addr will not automatically select an RDMA
> device if given a loopback address.
>
> Steve, can you test this with iwarp and openmpi, and ack it if it
> works for you?
>
>  drivers/infiniband/core/cma.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> index cc9b594..875e34e 100644
> --- a/drivers/infiniband/core/cma.c
> +++ b/drivers/infiniband/core/cma.c
> @@ -2115,9 +2115,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
>  	if (ret)
>  		goto err1;
>  
> -	if (cma_loopback_addr(addr)) {
> -		ret = cma_bind_loopback(id_priv);
> -	} else if (!cma_zero_addr(addr)) {
> +	if (!cma_any_addr(addr)) {
>  		ret = rdma_translate_ip(addr, &id->route.addr.dev_addr);
>  		if (ret)
>  			goto err1;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
