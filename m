From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/10] iw_cxgb4: Add connection management functions.
Date: Wed, 07 Apr 2010 14:32:15 -0700
Message-ID: <adaljcz0x0g.fsf@roland-alpha.cisco.com>
References: <20100402192346.14117.92767.stgit@build.ogc.int>
	<20100402192413.14117.56138.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100402192413.14117.56138.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org> (Steve Wise's
	message of "Fri, 02 Apr 2010 14:24:14 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > +int peer2peer = 0;
 > +module_param(peer2peer, int, 0644);
 > +MODULE_PARM_DESC(peer2peer, "Support peer2peer ULPs (default=0)");

If you build iw_cxgb3 and iw_cxgb4 into the kernel, the peer2peer symbol
names clash.  (Same problem occurs if you try to load cxgb3 and cxgb4
modules at the same time, I think).  We can fix it here in cxgb4 by just
making peer2peer static (and deleting the extern declaration).

However peer2peer is not that great of a name for a global symbol; might
be good to add a patch to cxgb3 to rename peer2peer to something like
iwch_peer2peer and using module_param_named()... 
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
