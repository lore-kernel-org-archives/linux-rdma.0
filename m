From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] cma: resolve to first active IB port
Date: Fri, 9 Dec 2016 17:17:42 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0BCED3@ORSMSX109.amr.corp.intel.com>
References: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg@mail.gmail.com>
 <CAMGffEnBfUnvKFHOKDuzXopa6m63RBOmHRhpeZun-UddXGjzvg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BC8BE@ORSMSX109.amr.corp.intel.com>
 <CAMGffEkGcxdYutV0cZYAzeu_kZOgTmuqTbMNfnPuFbHj+oT+2g@mail.gmail.com>
 <20161209163803.GA31304@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161209163803.GA31304-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > Sure, I updated the v2 patch as attached, is this what you want?
> >
> > Note: in cma_resolve_loopback, it does the same, I leave it like that
> > for now, I can also update this part if you like.
> 
> I feel like we already have a cache for subnet prefix, or maybe
> another patch series added one? Can't remember, sorry.

Yep - see core/cache.c.

Jinpu, port state caching should go here as well.  If you can update the loopback call as well, that would be great.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
