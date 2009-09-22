From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: confiugre cache line size
Date: Tue, 22 Sep 2009 10:51:10 -0700
Message-ID: <adaiqfa7trl.fsf@cisco.com>
References: <20090916110302.GA32767@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090916110302.GA32767@mtls03> (Eli Cohen's message of "Wed, 16
	Sep 2009 14:03:03 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: general-list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > +#if defined(cache_line_size)

Why the #if here?  Do we just need to include <linux/cache.h> explicitly
to make sure we get the define?

 > +	*((u8 *) mailbox->buf + INIT_HCA_CACHELINE_SZ_OFFSET) =
 > +		order_base_2(cache_line_size() / 16) << 5;

Trivial but I think it's safe to assume a cacheline is always a power of
2.  And I think it's clearer (and avoids generating a divide) to use
subtraction rather than division... so this could all become:

		(ilog2(cache_line_size()) - 4) << 5;

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
