From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ibsim/sim_cmd: Add command to set perf. counters.
Date: Thu, 11 Oct 2012 14:49:28 +0200
Message-ID: <20121011124928.GH6448@calypso>
References: <5844B6EB-4D27-4D4A-9277-284220531169@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5844B6EB-4D27-4D4A-9277-284220531169-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Huang, Perry" <huang32-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Chu, Al" <chu11-i2BcT+NCU+M@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>, "Foraker, Jim" <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Perry,

On 12:02 Wed 22 Aug     , Huang, Perry wrote:
> This patch requires:
> 	[PATCH 1/2] ibsim/sim.h: Add support for optional performance attributes.
> 	[PATCH 2/2] ibsim/sim_mad.c: Add read/reset functions for optional performance attributes.
> 
> Use:
> PerformanceSet "nodeid"[port] [attribute].[field]=[value]
> eg.
> sim> PerformanceSet "S-0002c9020040fec8"[4] PortCounters.PortXmitPkts=125512
> PortCounters.PortXmitPkts has been set to 125512
> 
> Add PerformanceSet command to enable setting performance counters (both required and optional fields).
> 
> Signed-off-by: Perry Huang <huang32-i2BcT+NCU+M@public.gmane.org>
> ---

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
