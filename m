From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/11 v2] RDMA/cxgb4: Support on-chip SQs.
Date: Tue, 28 Sep 2010 20:41:24 -0700
Message-ID: <adatyl943ob.fsf@cisco.com>
References: <20100913162357.20948.28267.stgit@build.ogc.int>
	<adad3rx699s.fsf@cisco.com> <4CA22E84.404@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CA22E84.404-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Tue, 28 Sep 2010 13:05:56 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > We would remove it I guess.   I see that mlx4 assumes
 > pgprot_writecombine() exists and works correctly across all platforms.
 > See mlx4_ib_mmap().

It might be more accurate to say that mlx4 assumes pgprot_writecombine()
is defined on all platforms.  Any platform that hasn't defined it (or
where the concept of write combining doesn't make sense) just falls back
to defining it as pgprot_noncached().

>From a quick grep it seems that /arch/powerpc has no definition of
pgprot_writecombine() but your code seems to say that one could be
given.

 > If all platforms support pgprot_writecombine() correctly, then we
 > don't need ocqp_supported().

As I said, it's a bit tricky.  All platforms get some definition of
pgprot_writecombine(), but some platforms might define it as just giving
a non-cached mapping, which might lead to dire performance (perhaps
worse than just putting the SQ in host memory).  I'm not sure what the
best way to handle it is -- I suppose if you wanted to get fancy you
could do a quick benchmark on startup (if such a thing is possible).

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
