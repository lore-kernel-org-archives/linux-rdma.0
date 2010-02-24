From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: add support for KR device id 0x0110
Date: Wed, 24 Feb 2010 14:39:20 -0800
Message-ID: <adavddmxnqf.fsf@roland-alpha.cisco.com>
References: <20100223175210.GA6240@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100223175210.GA6240@ctung-MOBL> (Chien Tung's message of "Tue,
	23 Feb 2010 11:52:10 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Add support for KR device id 0x0110.  While at it, cleanup
 > nes_init_phy() by splitting it into nes_init_1g_phy() and
 > nes_init_2025_phy().  Deprecate NES_PHY_TYPE_IRIS which is
 > no longer being manufactured.

By "deprecate NES_PHY_TYPE_IRIS" it seems you mean remove all support
for this PHY type?

Were cards of this type sold?  Because I think it's way too early to
drop support for any PHY variant (it's not like these are some 10BASE2
cards from decades ago -- these are 10 gigabit NICs at most only a few
years old) unless it is something like an experimental card that never
escaped from your labs.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
