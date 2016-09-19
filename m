From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH libibverbs v2 1/3] Add new call ibv_cmd_create_ah_ex
 which supports extra parameters
Date: Mon, 19 Sep 2016 06:03:44 +0200
Message-ID: <1474257824.20134.108.camel@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
         <5cc0157c0f05701d8cb1334e6ee11e1e7be6fa24.1474063039.git-series.knut.omang@oracle.com>
         <20160919030122.GA23152@obsidianresearch.com>
         <1474257063.20134.103.camel@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474257063.20134.103.camel-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2016-09-19 at 05:51 +0200, Knut Omang wrote:
> On Sun, 2016-09-18 at 21:01 -0600, Jason Gunthorpe wrote:
> > On Sat, Sep 17, 2016 at 05:59:11AM +0200, Knut Omang wrote:
> > > @@ -118,5 +118,9 @@ IBVERBS_1.1 {
> > >  		ibv_cmd_create_qp_ex2;
> > >  		ibv_cmd_open_qp;
> > >  		ibv_cmd_rereg_mr;
> > > +};
> > >  
> > > +IBVERBS_1.3 {
> > > +	global:
> > > +		ibv_cmd_create_ah_ex;
> > >  } IBVERBS_1.0;
> > 
> > This will probably end up being 1.4, and the 'tree' structure is
> > wrong, do not move this line:
> > 
> > >  } IBVERBS_1.0;
> 
> I was a bit concerned about the "structure", but ultimately decided to
> follow the pattern since I could not find any documentation with this syntax
> (which is probably because it is not supported?)

Without digging into the details of the ld map parser, my hunch is that 
a version symbol optionally accepts the {}, and that the ; terminates it so
as far as ld is concerned, basically the final IBVERBS_1.0 
just provides an empty list of additional symbols for IBVERBS_1.0

> As far as I can see, the final IBVERBS_1.0 does not have any effect at all, 
> the symbol output seems identical, so it should probably be removed, but
> maybe as a separate patch, with explanation?
> 
> Knut
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
