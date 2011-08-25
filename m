From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/20 v2] rdma: Add XRC support
Date: Thu, 25 Aug 2011 23:42:10 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E47C00@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E41B0A@FMSMSX151.amr.corp.intel.com>
 <CAL1RGDWrEN9nT=z5c_H=YXykFqVgOrp0vgBkcSshKodPLq+1mw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E46E88@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E46E88-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The only issue from my viewpoint is whether the change referenced by patch 11
> (ib/cm: Update xrc support based on xrc annex errata) has been approved by the
> IBTA.  I'm waiting on a response on that.

I received confirmation that the errata to the XRC Annex was approved.  Both patch 10 (ib/cm: Update protocol to support XRC) and 11 (ib/cm: Update xrc support based on xrc annex errata) should be merged.  You can either keep them separate, combine them into a single patch, or I can resubmit a combined patch.

Let me know if you see any other issues with the series.

Thanks,
- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
