From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PULL REQUEST] Please pull rdma.git (tag for-linus)
Date: Mon, 10 Oct 2016 14:23:25 -0500
Message-ID: <02b801d2232b$c5d4cff0$517e6fd0$@opengridcomputing.com>
References: <00af6acf-ec90-ea0e-68d6-f9e962c89bd3@redhat.com> <CA+55aFw5tftp1Da5Hs8ks+=hiodZ_NTCH3Z9efPxDVo7h75RAw@mail.gmail.com> <00f101d22304$4d874e00$e895ea00$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <00f101d22304$4d874e00$e895ea00$@opengridcomputing.com>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Linus Torvalds' <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'linux-rdma' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > 1) cxgb4 - keep the head version in your tree, my tree and the common
> > > ancestor were prior to a refactoring in your tree that moved uld_attach
> > > from cxgb4_main.c to cxgb4_uld.c
> >
> > Hmm. As far as I can tell, a proper merge also involves adding the line
> >
> >         lld->fr_nsmr_tpte_wr_support =
> > adap->params.fr_nsmr_tpte_wr_support;
> >
> > to uld_init() in cxgb4_uld.c.
> >
> > I did so, and it all seems to build find for me, but I obviously
> > cannot do any testing. Somebody with the proper cxgb4 hardware should
> > verify.
> >
> > Of course, it only affects the very special IB_WR_REG_MR fastpath
> > case, so maybe nobody much cares. Adding Steve Wise to the cc, to make
> > sure somebody actually tests this.
> >
> 
> I will test/verify this today.

Hey Linus,

The commits in your master branch check out ok.

Thanks!

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
