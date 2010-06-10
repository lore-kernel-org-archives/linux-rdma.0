From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2.6.35 2/3] RDMA/cxgb4: Support variable sized work requests.
Date: Thu, 10 Jun 2010 12:12:37 -0700
Message-ID: <adafx0uln16.fsf@roland-alpha.cisco.com>
References: <20100610190255.18331.20027.stgit@build.ogc.int>
	<20100610190300.18331.39028.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100610190300.18331.39028.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Thu, 10 Jun 2010 14:03:00 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > T4 EQ entries are in multiples of 64B.  Currently the RDMA SQ and RQ
 > use fixed sized entries composed of 4 EQ entries for the SQ and 2 EQ
 > entries for the RQ.  For optimial latency with small IO, we need to
 > change this so the HW only needs to DMA the EQ entries actually used by
 > a given work request.

This seems not to be a fix, just an optimization -- so at this point for
2.6.36 I think.  Or am I wrong?
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
