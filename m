From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Sun, 29 Oct 2017 12:00:19 -0600
Message-ID: <20171029180019.GE4488@ziepe.ca>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
 <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
 <20171025151734.GA15557@obsidianresearch.com>
 <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
 <20171027155955.GA15922@obsidianresearch.com>
 <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 05:21:20PM +0200, Alex Rosenbaum wrote:
> On Fri, Oct 27, 2017 at 5:59 PM, Jason Gunthorpe
> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > On Fri, Oct 27, 2017 at 03:46:57PM +0000, Guy Shattah wrote:
> >> On Wed, Oct 25, 2017 at 06:17:15PM +0300, Jason Gunthorpe wrote:
> >> >On Wed, Oct 25, 2017 at 05:58:15PM +0300, Yishai Hadas wrote:
> >>
> >> counters are not group in hardware unique but in an intuitive way.
> >
> > I don't think you understand my remark.
> >
> > I do not want to expose the idea of hardware limited groupings of
> > counters to the user at all.
> >
> > If the user needs counters 1,2 then the user should request those
> > counters only. Hardware that needs to sample, say, counter 1,2,3,4 to
> > get those will have to figure that out internally.
>
> Since this is all about measuring verbs objects, it seems sensible for
> us to group the counters by that same verbs sets.

Sure, but each verb may have lots and of different associated
counters, different hardware may have different sets, some hardware
may only be able to act on certain groupings of counters, etc.


> We can keep a flat list describing all available counters for all verbs objects.
> Or maybe you're thinking of some other method for the user to learn
> about available counters and their respectful objects?

Leon suggested an enum.

If the 'add_sampling_point_x' doesn't work then the counter is not
supported by the driver. Simple.

> >> >?counters = ibv_create_counters([..]);
> 
> to clarify, does this create a single counter collection? what is
> referred to as counter_set in the RFC/patches? or multiple counter's'?
> I assume the '[..]' is ibv_context.

This is a grouping of counters that are returned together when the
'read counter' API is called.

It is really unclear to me how this relates to the original proposed
API (still haven't seen the man pages!)

> >> >?ibv_add_sampling_point_flow(counters, 1, NULL, [..])
> 
> so do we really need the flow object handle is this API (the
> 'NULL')?

I had original drafted it with the idea that counters would be added/removed
to pre-existing verbs objects. This would support a fairly usual 'turn
on performance monitoring/turn off performance monitoring' kind of
application flow, when the counters were being used for monitoring.

I think mlx has designed the chip and was thinking of the API for some
other purpose where the counters always exist.

Having the argument allows both use models if hardware comes
along. Can mlx do the 'add counter' for any counter??

> and we need to clear the definition of '[..]'... does user learns what
> inputs are valid from a describe API, or some other method (re the
> above describe API question)?

Leon suggested a global documented enum, perhaps augmented with enum's
from the DV headers? The original series suggested a string?

> > You need to stop looking at the API through a Mellanox only lense.
> 
> In our patches we listed all vendor specific counter types in the
> vendor driver code, and allow access to this set through generic verbs
> in the describe API.
> In our api, any vendor could utilize the same api to expose their
> vendor specific counters.

Yes, but making the counters general is the trivial part of this
excercise. Making the API that creates any hardware objects and
configures the hardware to record these counters not be unduely tied
to a specific implementation is the tricky bit..

> In your suggestion, how do vendors add their specific HW dependent counters?

dv.h

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
