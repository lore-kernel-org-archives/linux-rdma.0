From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 05/10] iw_cxgb4: Add connection management functions.
Date: Wed, 07 Apr 2010 14:55:49 -0700
Message-ID: <adawrwjylju.fsf@roland-alpha.cisco.com>
References: <20100402192346.14117.92767.stgit@build.ogc.int>
	<20100402192413.14117.56138.stgit@build.ogc.int>
	<adaljcz0x0g.fsf@roland-alpha.cisco.com>
	<4BBCFDF9.70306@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BBCFDF9.70306-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Wed, 07 Apr 2010 16:49:45 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Both iw_cxgb3 and iw_cxgb4 load ok concurrently when compiled as modules.

Oh, right.  The peer2peer symbol isn't exported so the clash is only if
you try to build them both into the kernel (as I often do as part of my
quick build tests).
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
