From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Tue, 20 Sep 2016 06:42:15 +0200
Message-ID: <1474346535.20134.133.camel@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
         <5cc0157c0f05701d8cb1334e6ee11e1e7be6fa24.1474063039.git-series.knut.omang@oracle.com>
         <20160919030122.GA23152@obsidianresearch.com>
         <1474257063.20134.103.camel@oracle.com>
         <20160919040854.GA28241@obsidianresearch.com>
         <1474259364.20134.114.camel@oracle.com>
         <1474259792.20134.117.camel@oracle.com>
         <20160919165942.GB11836@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919165942.GB11836-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-09-19 at 10:59 -0600, Jason Gunthorpe wrote:
> On Mon, Sep 19, 2016 at 06:36:32AM +0200, Knut Omang wrote:
> > diff --git a/src/libibverbs.map b/src/libibverbs.map
> > index 5134bd9..979980d 100644
> > +++ b/src/libibverbs.map
> > @@ -118,5 +118,15 @@ IBVERBS_1.1 {
> >                 ibv_cmd_create_qp_ex2;
> >                 ibv_cmd_open_qp;
> >                 ibv_cmd_rereg_mr;
> >  } IBVERBS_1.0;
> > 
> > +IBVERBS_1.2 {
> > +} IBVERBS_1.1;
> 
> This is the right idea, but we won't be going back to fix the bad tags
> from 1.2 and other releases so this can be dropped.
> 
> > +IBVERBS_1.3 {
> > +} IBVERBS_1.2;
> 
> If you pull from Doug's tree right now you'll get a populated version
> of this stanza
> 
> > +IBVERBS_1.4 {
> > + global:
> > +         ibv_cmd_create_ah_ex;
> > +} IBVERBS_1.3;
> 
> Right. Doug will have to figure out a process for these, eg if he
> hasn't released 1.3 yet then this can be folded into 1.3.
> 
> It is critical that once a release is made that the existing stanza's
> not be changed.

Ok, fine - I see no 1.3.x tag yet so will post av v3 with this fix now.

Thanks,
Knut
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
