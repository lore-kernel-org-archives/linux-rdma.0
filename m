From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: rdma: 3.1.0-rc9 breaks UD
Date: Fri, 14 Oct 2011 21:38:30 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6B1FE@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.00.1110140852210.6411@router.home>
 <1828884A29C6694DAF28B7E6B8A8237316E6AF8E@ORSMSX101.amr.corp.intel.com>
 <alpine.DEB.2.00.1110141131150.6411@router.home>
 <1828884A29C6694DAF28B7E6B8A8237316E6AFC1@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXTQTwBBt+Lzo2o795giBbt28qW0-omXQVvOGtbmbMHRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXTQTwBBt+Lzo2o795giBbt28qW0-omXQVvOGtbmbMHRw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> I wonder how important wire compatibilty of the ibv_xx_pingpong
> examples is... should I worry about this?

I know that for some of the larger clusters, they may not be able to upgrade the software on all systems during a scheduled downtime.  This is about the only reason I can think of why you might even care.  It doesn't look that important to me, and DAPL seems to break its connection wire protocol just about every release without any complaints yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
