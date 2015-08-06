From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum
 offload capabilities report
Date: Wed, 5 Aug 2015 18:00:42 -0600
Message-ID: <20150806000042.GC2483@obsidianresearch.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
 <1438788867-18332-2-git-send-email-amirv@mellanox.com>
 <20150805171634.GA12274@obsidianresearch.com>
 <CAJ3xEMgFCx3Xaan2WYL53HRnhdvnoDsS2TriYbENQizpnV31dw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgFCx3Xaan2WYL53HRnhdvnoDsS2TriYbENQizpnV31dw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 06, 2015 at 01:16:17AM +0300, Or Gerlitz wrote:
> So -- shit happens, I am trying to figure out if an internal review
> has been done, b/c we do have some folks who terribly master the
> extended uverbs framework, right...?

You and Matan had no problem doing the timestamp stuff properly in
this area, so I assume so..

I would *strongly* encourage either of you to publicly do the proper
review and explain why the above patches are wrong. Then there is some
record someone in future can find to discuss all this..

> to the upstream rdma stack and we should encourage more people to
> participate... so you sent him back home to do HW, let's see what
> this will yield.

The participating we are sorely lacking right now is on the review
side, which is like most of the kernel, unfortunately.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
