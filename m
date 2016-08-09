From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: New krping location
Date: Tue, 9 Aug 2016 08:47:25 -0500
Message-ID: <006701d1f244$8f99e320$aecda960$@opengridcomputing.com>
References: <01b301d1f1ac$c603c5e0$520b51a0$@opengridcomputing.com> <20160809072024.GA10141@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160809072024.GA10141-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> 
> Is there any good reason why we don't have a version of krping in
> the kernel tree?

The current code needs refactoring to be acceptable in the kernel.  For example,
it abuses procfs as the interface to control krping connections from user space.
There are hacked up latency and bandwidth tests that need to be fixed up or
removed (they current don't work at all).  There have been comments that the
code flow needs to be cleaned up.  So currently it is just a bare-bones test
tool.  

I welcome anyone who wants to take on the task of pushing this into the kernel.
I know there are a few folks out there using it for rdma driver bring up...

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
