From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Fri, 24 Jul 2015 16:44:01 -0600
Message-ID: <20150724224401.GB29064@obsidianresearch.com>
References: <20150723163124.GD25174@obsidianresearch.com>
 <55B11D84.102@dev.mellanox.co.il>
 <20150723185334.GB31346@obsidianresearch.com>
 <DE0226A1-A7FC-4618-91F1-FE34347C252A@oracle.com>
 <20150724162657.GA21473@obsidianresearch.com>
 <903CDFB5-04FE-47B6-B044-E960E8A8BC4C@oracle.com>
 <20150724191003.GA26225@obsidianresearch.com>
 <A1A0BF6E-992A-4B34-8D24-EA8AA8D6983B@oracle.com>
 <20150724202445.GA28033@obsidianresearch.com>
 <00f001d0c65d$fdf27d50$f9d777f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00f001d0c65d$fdf27d50$f9d777f0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Sagi Grimberg' <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Liran Liss' <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Oren Duer' <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I am unclear what happens sever side if the server starts issuing
> > SEND_WITH_INVALIDATE to a client that doesn't expect it. The net
> > result is a MR would be invalidated twice. I don't know if this is OK
> > or not.
> 
> It is ok to invalidate an already-invalid MR.

Nice, ah but I forgot about the last issue..

A server must not send the SEND_WITH_INVALIDATE OP to a client HCA
that does not support it in HW. At least on IB the operation code is
different, so it will break..

So negotiation is needed..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
