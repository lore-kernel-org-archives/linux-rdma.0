From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] cma: resolve to first active IB port
Date: Fri, 9 Dec 2016 09:38:03 -0700
Message-ID: <20161209163803.GA31304@obsidianresearch.com>
References: <CAMGffE=mSpm+zuG9wo-GV0HT4-ewg34uvOKCUrPRC61ATjxyVg@mail.gmail.com>
 <CAMGffEnBfUnvKFHOKDuzXopa6m63RBOmHRhpeZun-UddXGjzvg@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0BC8BE@ORSMSX109.amr.corp.intel.com>
 <CAMGffEkGcxdYutV0cZYAzeu_kZOgTmuqTbMNfnPuFbHj+oT+2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAMGffEkGcxdYutV0cZYAzeu_kZOgTmuqTbMNfnPuFbHj+oT+2g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jinpu Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Dec 09, 2016 at 10:31:00AM +0100, Jinpu Wang wrote:

> > I do have a concern about accessing non-cached port data as part
> > of this call.  Can we cache the port state and use that instead?
> 
> Thanks for review.
> 
> Sure, I updated the v2 patch as attached, is this what you want?
> 
> Note: in cma_resolve_loopback, it does the same, I leave it like that
> for now, I can also update this part if you like.

I feel like we already have a cache for subnet prefix, or maybe
another patch series added one? Can't remember, sorry.

In any event, this caching should probably live in the core code not
the cma....

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
