From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] RDMA/nes: add support for KR device id 0x0110
Date: Thu, 25 Feb 2010 10:09:30 -0800
Message-ID: <ada635lxk4l.fsf@roland-alpha.cisco.com>
References: <20100223175210.GA6240@ctung-MOBL>
	<adavddmxnqf.fsf@roland-alpha.cisco.com>
	<603F8A3875DCE940BA37B49D0A6EA0AE842C0E89@azsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <603F8A3875DCE940BA37B49D0A6EA0AE842C0E89-uLM7Qlg6Mbekrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Chien Tin Tung's message of "Thu, 25 Feb 2010 08:20:41 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Iris is an XFP card.  NetEffect didn't make that many and maybe a few
 > were given out as evals.  The biggest reason for removing the support
 > is I don't have a card to test code changes.  There are other cards that
 > I am supporting even though we no longer make them as Intel.  I will
 > keep those around as long as I have cards, in a secret hiding place. :-)

OK, if you're comfortable that no one is still using such cards then
it's fine with me to remove the support.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
