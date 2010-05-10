From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/7] CQ overflow detection giving false positives
Date: Mon, 10 May 2010 08:42:43 -0700
Message-ID: <ada1vdjzrt8.fsf@roland-alpha.cisco.com>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
	<20100506230652.25362.18848.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230652.25362.18848.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Thu, 06 May 2010 18:06:52 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

All look fine... I rolled them up into the patch adding iw_cxgb4 (might
as well have the initial driver merge have all know fixes).
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
