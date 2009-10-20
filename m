From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Multicast joins failing on 1.5-rc1?
Date: Tue, 20 Oct 2009 12:34:30 -0600
Message-ID: <20091020183430.GF14520@obsidianresearch.com>
References: <A5E1097A-DFEA-4508-A47F-FF07C34EA525@routingdynamics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <A5E1097A-DFEA-4508-A47F-FF07C34EA525-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: stuarts <stuarts-dK3M3PVJaX4iXRBKUn1UN0EOCMrvLtNR@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 20, 2009 at 01:16:07PM -0500, stuarts wrote:
> When I look through for the code, I found that error code associated  
> with an invalid set of component masks:
> Oct 20 12:40:05 824130 [44240940] 0x01 -> mcmr_rcv_join_mgrp: ERR 1B11: 
> method = SubnAdmSet, scope_state = 0x1, component mask =  
> 0x0000000000010083, expected comp mask = 0x00000000000130c7, MGID:  
> ff12:601b:ffff::16 from port 0x0002c90300032431 (x3 HCA-1)

I thought this was normal, expected behavior?

The IPoIB Send only join process doesn't create multicast groups. If
there is a listening group then it joins it, otherwise nothing.

Basically, you need listeners before you can send.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
