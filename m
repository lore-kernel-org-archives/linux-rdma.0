From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: mxl4 and rpcrdma: connection to 192.168.0.100:20049 on mlx4_0, memreg 5 slots 32 ird 16
Date: Thu, 18 Nov 2010 11:22:58 -0800
Message-ID: <aday68qh1wt.fsf@cisco.com>
References: <AANLkTi=d6d2vydtcK+ux22e-QR5xqrkenMoeM8AzHBVq@mail.gmail.com>
	<4CE41458.7020202@opengridcomputing.com> <ada62vvigdx.fsf@cisco.com>
	<4CE5640F.6040005@opengridcomputing.com>
	<4CE56538.3040700@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE56538.3040700-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Thu, 18 Nov 2010 11:41:12 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Stephen Cousins <steve.cousins-e7X0jjDqjFGHXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > However, maybe these two printk's should just be dprintks...

Seems reasonable... a KERN_INFO print for something so common seems a
bit annoying.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
