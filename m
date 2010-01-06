From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] INFINIBAND:  Correct CONFIG_IPv6 to CONFIG_IPV6.
Date: Wed, 06 Jan 2010 13:16:05 -0800
Message-ID: <adad41nszmy.fsf@roland-alpha.cisco.com>
References: <alpine.LFD.2.00.0912281644290.3429@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.00.0912281644290.3429@localhost> (Robert
	P. J. Day's message of "Mon, 28 Dec 2009 16:48:08 -0500 (EST)")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks, applied.

I think I added this error in the first place as part of the

    [ Fix up cma_check_linklocal() for !IPV6 case.  - Roland ]

"work" I did on the original commit d14714df.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
