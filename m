From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 10:08:10 -0700
Message-ID: <adazl1vxb7p.fsf@roland-alpha.cisco.com>
References: <4BACD985.1070906@opengridcomputing.com>
	<DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>
	<4BACE28A.2080409@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BACE28A.2080409-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Fri, 26 Mar 2010 11:36:26 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > In other words, I think we want the ucma context to stay around until
 > the application destroys it (via explicit means or via exit).   But
 > the rdma_cm_id gets destroyed immediately upon receiving a
 > DEVICE_REMOVE event.

Yes.  The RDMA CM is somewhat easier, but I think the basic idea should
be that ucma internally detaches the userspace context from anything
that is holding a device reference, and marks the context as "dead"
(only valid operation is destroying it).

uverbs is trickier, because a userspace process will typically have some
hardware resources directly mmap'ed.  We need a way to "revoke" that
mmap and have it point at a dummy page until userspace releases it --
and last I looked I wasn't sure how to do that.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
