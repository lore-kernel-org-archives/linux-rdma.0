From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/cxgb3: Shrink .text with compile-time init of handlers arrays
Date: Mon, 03 May 2010 07:37:37 -0700
Message-ID: <ada1vdtvyoe.fsf@roland-alpha.cisco.com>
References: <adaiq7b1jhe.fsf@roland-alpha.cisco.com>
	<4BD88D8B.8050000@opengridcomputing.com>
	<ada7hnr1bwc.fsf@roland-alpha.cisco.com>
	<4BDEDE62.8010905@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BDEDE62.8010905-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Mon, 03 May 2010 09:32:02 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > If you push this into your for-next branch, I'll regression test it.

It should be there... yep, just checked and I see it on git.kernel.org gitweb.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
