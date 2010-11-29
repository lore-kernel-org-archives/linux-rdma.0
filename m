From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib/core: remove some dead code added by the IBoE
 patches
Date: Mon, 29 Nov 2010 09:48:18 +0200
Message-ID: <20101129074818.GA16673@mtldesk30>
References: <Pine.LNX.4.64.1011290913560.29567@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1011290913560.29567-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 29, 2010 at 09:20:50AM +0200, Or Gerlitz wrote:
> 
> Eli, I see also the following which relates to commit 4c3eb3ca13966508bcb64f39
> "Add VLAN support for IBoE", and wasn't sure if/how to fix that, can you have a look?
> 
> CC [M]  drivers/infiniband/hw/mlx4/qp.o
> drivers/infiniband/hw/mlx4/qp.c: In function mlx4_ib_post_send:
> drivers/infiniband/hw/mlx4/qp.c:1304: warning: vlan may be used uninitialized in this function
> 
As far as I can see it's a false warning. vlan is initialized only if
is_eth it true but it is also used only when is_eth is true.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
