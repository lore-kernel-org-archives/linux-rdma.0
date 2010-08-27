From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv10 05/12] mthca: Adapt to API changes in the core for UD packing
Date: Thu, 26 Aug 2010 23:17:11 -0700
Message-ID: <adar5hk37h4.fsf@cisco.com>
References: <20100826141823.GF8795@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100826141823.GF8795@mtldesk30> (Eli Cohen's message of "Thu,
	26 Aug 2010 17:18:23 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In the future, please don't have patches that break compilation.  If you
change an API, then change all users of that API in the same patch.
It's really annoying for someone who is trying to bisect something
(possibly something completely unrelated) to land at a point in history
that doesn't even build.

So if there's another spin of this patchset, please fold all the "adapt
to new API" patches into the main "change API" patches.  You don't have
to resend just for that though, I can handle it if I apply these.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
