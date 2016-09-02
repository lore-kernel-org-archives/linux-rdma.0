From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/9] ib_uverbs: Avoid vendor specific masking of
 attributes in query_qp
Date: Fri, 02 Sep 2016 06:45:52 +0200
Message-ID: <1472791552.9410.258.camel@oracle.com>
References: <1472774969-18997-1-git-send-email-knut.omang@oracle.com>
         <1472774969-18997-7-git-send-email-knut.omang@oracle.com>
         <20160902021300.GC30057@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902021300.GC30057-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-09-01 at 20:13 -0600, Jason Gunthorpe wrote:
> On Fri, Sep 02, 2016 at 02:09:26AM +0200, Knut Omang wrote:
> > This commit removes the implementation and use of the modify_qp_mask
> > helper function from the generic OFED implementation and into individual
> > device drivers.
> > 
> > Like with use of the ib_modify_qp_is_ok function it should be up to
> > each device driver how to handle bits set in the attribute masks.
> > 
> > With the modify_qp_mask function applied in the generic code,
> > drivers would not see the bits that the user process actually sets.
> > 
> > The restrictions imposed by the filter are also beyond what
> > is imposed by the Infiniband standard, and would also limit
> > future drivers or hardware from checking for unsupported or
> > invalid settings.
> 
> I'm not excited about this direction. It is not OK for different
> drivers to use different mask algorithms, they must all behave the
> same.

The problem I am solving here is that SIF expects (and requires) some of 
the bits that the user correctly sets, but that Mellanox either ignore or need to
be 0. So when that mask is applied to the user input, the value that reaches
the SIF driver is not correct from SIFs perspective. 
If the values goes through as the ULP sets them, then all is fine.

> What is it you want to do differently, and why shouldn't the mlx
> drivers be updated to match that?

I'd like the hardware specific part to decide which of the user bits that
are interesting and which are not. Currently that information is lost on the way
down to the hardware specific calls.

Knut

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
