From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: message size, was Re: merge struct ib_device_attr into struct ib_device
Date: Wed, 23 Sep 2015 09:20:46 -0500
Message-ID: <000001d0f60b$0a70c460$1f524d20$@opengridcomputing.com>
References: <013f01d0f57a$85b12a20$91137e60$@opengridcomputing.com>	<20150922215514.GA13252@lst.de>	<014101d0f584$286573d0$79305b70$@opengridcomputing.com> <20150922.160804.1527367213542384317.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150922.160804.1527367213542384317.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'David Miller' <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: hch-jcswGhMUV9g@public.gmane.org, postmaster-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: David Miller [mailto:davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org]
> Sent: Tuesday, September 22, 2015 6:08 PM
> 
> > How do we change the message size limits?  Reviewing w/o it being
> > inline is painful for the (many) reviewers...
> 
> I've increased it.

Thanks!

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
