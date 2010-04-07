From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/10] iw_cxgb4: Add memory management functions.
Date: Wed, 07 Apr 2010 14:40:26 -0700
Message-ID: <ada4ojn0wmt.fsf@roland-alpha.cisco.com>
References: <20100402192346.14117.92767.stgit@build.ogc.int>
	<20100402192419.14117.40759.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100402192419.14117.40759.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Fri, 02 Apr 2010 14:24:19 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +			req->wr.wr_lo = (u64)&wr_wait;

wr_lo is __be64.  The cast should be to __force __be64 here I think.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
