From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git (tag for-linus)
Date: Sun, 9 Oct 2016 17:14:00 -0700
Message-ID: <CA+55aFw5tftp1Da5Hs8ks+=hiodZ_NTCH3Z9efPxDVo7h75RAw@mail.gmail.com>
References: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 7, 2016 at 3:24 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> 1) cxgb4 - keep the head version in your tree, my tree and the common
> ancestor were prior to a refactoring in your tree that moved uld_attach
> from cxgb4_main.c to cxgb4_uld.c

Hmm. As far as I can tell, a proper merge also involves adding the line

        lld->fr_nsmr_tpte_wr_support = adap->params.fr_nsmr_tpte_wr_support;

to uld_init() in cxgb4_uld.c.

I did so, and it all seems to build find for me, but I obviously
cannot do any testing. Somebody with the proper cxgb4 hardware should
verify.

Of course, it only affects the very special IB_WR_REG_MR fastpath
case, so maybe nobody much cares. Adding Steve Wise to the cc, to make
sure somebody actually tests this.

(Side note: current git has what appears to be a use-after-free
netfilter buglet, but it shouldn't trigger problems often enough to
keep people from testing. It kept me from doing my merge window pulls
while I investigated, though).

                     Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
