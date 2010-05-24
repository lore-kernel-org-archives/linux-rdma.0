From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv8 05/11] ib_core: IBoE UD packet packing support
Date: Mon, 24 May 2010 08:27:14 +0300
Message-ID: <20100524052714.GA15867@mtldesk030.lab.mtl.com>
References: <20100218172411.GF12286@mtls03>
	<adask5wuboz.fsf@roland-alpha.cisco.com>
	<20100513082718.GD16073@mtldesk030.lab.mtl.com>
	<adad3wzsnz8.fsf@roland-alpha.cisco.com>
	<20100517123004.GC663@mtldesk030.lab.mtl.com>
	<adamxvyo61d.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adamxvyo61d.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 17, 2010 at 09:18:54AM -0700, Roland Dreier wrote:
>  > I thought you were referring to the changes made by this patch
>  > 920d706.  Should I re-send this patch?
> 
> Yes, please work out what changes are still required and send a new patch.

OK. I am sending a series of three patches. The first one contains the
original changes. The following two are for mlx4 and mthca to sync
with the API changes. The patches are made agianst the iboe branch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
