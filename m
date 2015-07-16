From: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 06/41] IB/hfi1: add char device instantiation code
Date: Thu, 16 Jul 2015 19:23:42 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC257630C4@fmsmsx120.amr.corp.intel.com>
References: <20150611230710.16479.62955.stgit@phlsvslse11.ph.intel.com>
 <20150611230901.16479.18231.stgit@phlsvslse11.ph.intel.com>
 <CAJ3xEMjRPdqWSGSwaEvyhmMQOFqaEi9ZzD5oKzmOhJyERLz4-w@mail.gmail.com>
 <20150615173423.GA528@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FF5828@ORSMSX109.amr.corp.intel.com>
 <20150615181348.GC1089@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC2574E174@fmsmsx120.amr.corp.intel.com>
 <32E1700B9017364D9B60AED9960492BC2575144C@fmsmsx120.amr.corp.intel.com>
 <20150617163140.GA22242@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617163140.GA22242-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> But personally, I hate seeing write() used to emulate ioctl() because 'ioctl is
> bad'. ie if you are 'writing' a struct that contains user pointers and you
> expect the kernel to read/write to user memory, then use ioctl. (and that is
> the 'badness' of ioctl, so pretending it is write doesn't help anything)
> 

So you are ok with ioctl? Based on the statement above, it appears that you are.

mike
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
