From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] ib/iser: enhance disconnection logic for
	multi-pathing
Date: Wed, 12 May 2010 01:12:15 +0300
Message-ID: <AANLkTin2z7MkpMtDqUwfcGA0RgJ7Nrsn9FSh6pXxWyGF@mail.gmail.com>
References: <Pine.LNX.4.64.1005051726110.29957@zuben.voltaire.com>
	 <Pine.LNX.4.64.1005051730450.29957@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1005051730450.29957-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:
>  [...] with this patch, multipath fail-over time is about 30 seconds, which is seen here,
> when a DD over the multi-path device is done before/during/after the fail-over [...] without
 > this patch, multipath fail-over time is about 130 seconds

Hi Roland, as we're @ -rc7 now, I wanted to check with you if there's
any issue merging this patch series for 2.6.35. If you have any
question or anything need to be addressed/fixed, I'd like to do that
sooner rather then later.

Or
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
