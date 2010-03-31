From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/rds: use IB_CQ_REPORT_MISSED_EVENTS to avoid missed CQ callbacks
Date: Wed, 31 Mar 2010 14:59:25 -0700
Message-ID: <ada4ojwi24i.fsf@roland-alpha.cisco.com>
References: <1269987841.4192.228.camel@chromite.mv.qlogic.com>
	<adaeij1v14z.fsf@roland-alpha.cisco.com>
	<1269993053.4192.235.camel@chromite.mv.qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1269993053.4192.235.camel-/vjeY7uYZjrPXfVEPVhPGq6RkeBMCJyt@public.gmane.org> (Ralph
	Campbell's message of "Tue, 30 Mar 2010 16:50:53 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Andy Grover <andy.grover-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Out of curiousity have you measured an improvement?
 > 
 > It is a great improvement over a bunch of printks and then
 > hitting BUG_ON() in __rds_ib_ring_used().

I think it would be better to understand that problem, since this patch
is not really fixing anything, just changing timing.  So at best you're
hiding the problem until it pops up again.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
