From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 13:45:27 -0700
Message-ID: <adahbo2yfq0.fsf@roland-alpha.cisco.com>
References: <4BACD985.1070906@opengridcomputing.com>
	<DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>
	<4BACE28A.2080409@opengridcomputing.com>
	<adazl1vxb7p.fsf@roland-alpha.cisco.com>
	<603F8A3875DCE940BA37B49D0A6EA0AE84CFDB38@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <603F8A3875DCE940BA37B49D0A6EA0AE84CFDB38-uLM7Qlg6Mbekrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Chien Tin Tung's message of "Fri, 26 Mar 2010 13:18:35 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > >uverbs is trickier, because a userspace process will typically have some
 > >hardware resources directly mmap'ed.  We need a way to "revoke" that
 > >mmap and have it point at a dummy page until userspace releases it --
 > >and last I looked I wasn't sure how to do that.

 > Isn't "revoking" the mmap enough, why do we need to remap it
 > to a dummy page?  Why not just let the app hang on to the allocated virtual
 > memory until it exits?  I am thinking of registered memory here.

If you revoke the mmap, then presumably the process will seg fault if it
tries to access the page.  So you need to point the map to some real
page to handle accesses until the process actually closes the device.

(And I think what we'll want to do is queue up the "catastrophic error"
async event and then immediately allow the low-level device to reset, so
we need to handle the mmap in a way that doesn't kill the app; otherwise
there's no way for even a well-behaved app to avoid crashing, since it
might be about to do an MMIO to the mmapped registers just as the async
event is created)
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
