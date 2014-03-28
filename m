From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb4: set error code on kmalloc() failure
Date: Fri, 28 Mar 2014 14:55:34 -0400 (EDT)
Message-ID: <20140328.145534.253801969114061130.davem@davemloft.net>
References: <1395846311-29288-1-git-send-email-ydroneaud@opteya.com>
	<005b01cf4907$9adfa320$d09ee960$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <005b01cf4907$9adfa320$d09ee960$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
Cc: ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Date: Wed, 26 Mar 2014 10:25:22 -0500

> Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> 
> Note: This fix applies only to net-next because the commit that introduced this is still
> pending in net-next:
> 
> commit 05eb23893c2cf9502a9cec0c32e7f1d1ed2895c8
> Author: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Date:   Fri Mar 14 21:52:08 2014 +0530
> 
>     cxgb4/iw_cxgb4: Doorbell Drop Avoidance Bug Fixes
> 
> 
> Dave, can you please merge this?

Done, thanks.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
