From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/srp: use IB_CQ_REPORT_MISSED_EVENTS to avoid  missed CQ callbacks
Date: Wed, 31 Mar 2010 11:57:15 -0700
Message-ID: <adask7giak4.fsf@roland-alpha.cisco.com>
References: <20100331175742.24522.17850.stgit@chromite.mv.qlogic.com>
	<20100331175752.24522.66519.stgit@chromite.mv.qlogic.com>
	<y2ie2e108261003311111uec1ec00g746ba0ffe3d98799@mail.gmail.com>
	<adazl1oiccb.fsf@roland-alpha.cisco.com>
	<u2ze2e108261003311136l4bcf1627n9ba4d3414167eef3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <u2ze2e108261003311136l4bcf1627n9ba4d3414167eef3-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Wed, 31 Mar 2010 20:36:12 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Processing the flag IB_CQ_REPORT_MISSED_EVENTS causes several IB
 > drivers to lock and unlock a spinlock. Full-speed SRP I/O can cause
 > this operation to be invoked more than 100.000 times a second, so the
 > flag IB_CQ_REPORT_MISSED_EVENTS will have a small but measurable
 > impact on SRP I/O performance.

It seems the only driver where that happens is ehca.  But on the other
hand, for mthca/mlx4 it avoids doing something like:

  cq event:
    request notify <-- CQ is not empty, another event queued
    drain CQ

  cq event:
    request notify
    drain already empty CQ

ie the overhead saved here looks a lot more.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
