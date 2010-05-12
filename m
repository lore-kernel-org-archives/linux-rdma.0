From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Wed, 12 May 2010 13:14:33 -0700
Message-ID: <adaocgkubbq.fsf@roland-alpha.cisco.com>
References: <20100218172403.GE12286@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100218172403.GE12286@mtls03> (Eli Cohen's message of "Thu, 18
	Feb 2010 19:24:03 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Multicast GIDs are always mapped to multicast MACs
 > as is done in IPv6. Some helper functions are added to ib_addr.h.  IPv4
 > multicast is enabled by translating IPv4 multicast addresses to IPv6 multicast
 > as described in
 > http://www.mail-archive.com/ipng-Va8kgSFw1KyzQ7sTrsxvMkEOCMrvLtNR@public.gmane.org/msg02134.html.

I guess it's a bit unfortunate that the RoCE annex completely ignored
how to map multicast GIDs to ethernet addresses (I suppose as part of
the larger decision to ignore address resolution entirely).  Anyway,
looking at the email message you reference, it seems to be someone
asking what the right way to map IPv4 multicast addresses to IPv6
addresses is.  Is there a more definitive document you can point to?

It seems that unfortunately the way the layering of addresses is done,
there's no way to just use the standard mapping of IPv4 multicast
addresses to Ethernet addresses (since IBoE is does addressing via
the CMA mapping to GIDs followed by an unspecified mapping from GIDs to
Ethernet addresses).

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
