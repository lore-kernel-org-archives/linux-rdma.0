From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v4 2/4] iw_cxgb4: add queue drain functions
Date: Thu, 10 Mar 2016 07:05:58 +0200
Message-ID: <20160310050558.GD1977@leon.nu>
References: <cover.1455741336.git.swise@chelsio.com>
 <162a5429342dfd5e16881f4360c0ef858fd39cbd.1455741336.git.swise@chelsio.com>
 <20160309125349.GA1977@leon.nu>
 <008c01d17a17$b1c02090$154061b0$@opengridcomputing.com>
 <56E0412F.4000602@dev.mellanox.co.il>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56E0412F.4000602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 09, 2016 at 05:28:47PM +0200, Sagi Grimberg wrote:
> 
> >>Hi Steve,
> >>My knowledge is limited in this driver and I have no illusion that
> >>question sounds naive, but why did you add these functions to this
> >>specific driver? Do the other drivers need such update too?
> >>
> >>Thanks
> >
> >Hey Leon,
> >
> >I added these so iSER and other storage protocols that are or will be using the drain logic will work on cxgb4.  IB devices should
> >not need device-specific drain logic since the common core drain works for IB (and I assume RoCE).  iWARP devices, however, require
> >device-specific logic.  Other iwarp drivers are iw_cxgb3 and iw_nes.
> 
> Yes, this is iWARP specific. Steve was kind enough to fix chelsio
> drivers and we need someone to pick up nes so ULPs will be able to run
> reliably over it.

Steve and Sagi,
Thank you for clarification.

I see that nes driver is supported. Is it still relevant?

NETEFFECT IWARP RNIC DRIVER (IW_NES)
M:      Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
L:      linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
W:	http://www.intel.com/Products/Server/Adapters/Server-Cluster/Server-Cluster-overview.htm
S:      Supported
F:      drivers/infiniband/hw/nes/
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
