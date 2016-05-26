From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] rdma/uverbs: Sketch for an ioctl framework
Date: Thu, 26 May 2016 12:43:48 -0600
Message-ID: <20160526184348.GA22174@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A82373AB04FB7F@ORSMSX109.amr.corp.intel.com>
 <HE1PR05MB141819B27F9AAA360DCB420FB14F0@HE1PR05MB1418.eurprd05.prod.outlook.com>
 <11b6d9c1-0b20-f929-c896-ca084fe18192@redhat.com>
 <20160524214137.GA6760@obsidianresearch.com>
 <5745E9AE.6020700@redhat.com>
 <20160525190039.GA5525@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB050907@ORSMSX109.amr.corp.intel.com>
 <20160525205156.GB5525@obsidianresearch.com>
 <HE1PR05MB1418B4396F696F763D67A893B1410@HE1PR05MB1418.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB1418B4396F696F763D67A893B1410-eBadYZ65MZ87O8BmmlM1zNqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2016 at 06:07:02PM +0000, Liran Liss wrote:

> However, I think that processing object locking before validation is not secure.
> A malicious user could easily cause a deadlock due to ordering.

Hum, interesting point. I wonder if we already have bugs there today?

I'd say that is actually more likely to happen if it is open
coded. Nested object locking like that requires consistent ordering to
avoid deadlock..

It would be easier for the core code to enforce consistent nested lock
acquire ordering than to try and do that scattered across all the
code. You are right, the core code cannot just iterate over the
provided object list and grab the locks.

One very simple option is for the core to enforce a sort order on the
object list as it grabs the locks and fail&unwind for unordered lists.

Parameter validation doesn't really factor into this problem....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
