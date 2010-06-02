From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: libibverbs and versions
Date: Wed, 02 Jun 2010 09:46:39 -0700
Message-ID: <adaeigptma8.fsf@roland-alpha.cisco.com>
References: <4C067DE0.8020508@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C067DE0.8020508-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Wed, 02 Jun 2010 10:50:56 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I have this library I'm writing that uses libibverbs.  Somehow it
 > seems to be using the 1.0 version instead of the newer version (I'm
 > guessing).  When I call ibv_create_cq()  I get a seg fault and the
 > stack looks like this:
 > 
 > #0  0x000000319d80871d in pthread_mutex_lock () from /lib64/libpthread.so.0
 > #1  0x00007f60e93fac9a in __ibv_create_cq (context=0x7f60e8597c51, cqe=256,
 >    cq_context=0x0, channel=0x0, comp_vector=0) at src/verbs.c:278
 > #2  0x00007f60e93f727f in __ibv_create_cq_1_0 (context=0x61db30, cqe=256,
 >    cq_context=0x0, channel=0x0, comp_vector=0) at src/compat-1_0.c:649

Code compiled against libibverbs 1.1 shouldn't ever hit the 1.0
compatibility code.  libibverbs is using versioned symbols, so if your
library is built/linked correctly, it should pick up the 1.1 versions.
How are you building your library?

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
