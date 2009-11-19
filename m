From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 8/9] ib/addr: simplify resolving IPv4 addresses
Date: Thu, 19 Nov 2009 16:52:42 +0200
Message-ID: <4B055BBA.8020505@Voltaire.com>
References: <AD17449F0C4E4FE7B20C32412F077C00@amr.corp.intel.com> <4B024258.7070500@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B024258.7070500-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I reviewed patches 1-6 & 8 and they all look fine, I will give the whole series 
> a try later this week to further validate them

I tested the patch series (V2 for the patches that have it, V1 for the rest) over 2.6.32-rc5
and librdmacm-1.0.8-1.el5 covering AF_INET/PS_TCP unicast and AF_INET/PS_IPOIB multicast and 
bonding (operability and address-change event). I used mckey and rping, all worked fine, 
thanks for driving this change set, Sean. David, I'll be happy to hear how the IPv6 testing went, lets get this going.



Or.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
