From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/nes: add support for KR device id 0x0110
Date: Thu, 25 Feb 2010 08:20:41 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE842C0E89@azsmsx501.amr.corp.intel.com>
References: <20100223175210.GA6240@ctung-MOBL>
 <adavddmxnqf.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adavddmxnqf.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>By "deprecate NES_PHY_TYPE_IRIS" it seems you mean remove all support
>for this PHY type?

yes, see below.

>Were cards of this type sold?  Because I think it's way too early to
>drop support for any PHY variant (it's not like these are some 10BASE2
>cards from decades ago -- these are 10 gigabit NICs at most only a few
>years old) unless it is something like an experimental card that never
>escaped from your labs.

Iris is an XFP card.  NetEffect didn't make that many and maybe a few
were given out as evals.  The biggest reason for removing the support
is I don't have a card to test code changes.  There are other cards that
I am supporting even though we no longer make them as Intel.  I will
keep those around as long as I have cards, in a secret hiding place. :-)

Chien



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
