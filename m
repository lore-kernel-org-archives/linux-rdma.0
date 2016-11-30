From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 01/10] IB/core: Add raw packet protocol
Date: Wed, 30 Nov 2016 09:36:21 -0700
Message-ID: <20161130163621.GB24639@obsidianresearch.com>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
 <1480258296-27032-2-git-send-email-leon@kernel.org>
 <20161128170056.GC28381@obsidianresearch.com>
 <05bd01d2499a$1c75f750$5561e5f0$@opengridcomputing.com>
 <cfdf28c6-4715-28d4-7da6-453fb6794c29@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfdf28c6-4715-28d4-7da6-453fb6794c29-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Mike Marciniszyn' <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "'Wei Hu(Xavier)'" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Faisal Latif' <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Yishai Hadas' <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Devesh Sharma' <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Mitesh Ahuja' <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, 'Christian Benvenuti' <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Dave Goodell' <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 29, 2016 at 09:07:52PM -0500, Doug Ledford wrote:
> On 11/28/2016 12:08 PM, Steve Wise wrote:
> >>
> >> On Sun, Nov 27, 2016 at 04:51:27PM +0200, Leon Romanovsky wrote:
> >>
> >>> +static inline bool rdma_protocol_raw_packet(const struct ib_device *device,
> > u8
> >> port_num)
> >>> +{
> >>> +	return device->port_immutable[port_num].core_cap_flags &
> >> RDMA_CORE_CAP_PROT_RAW_PACKET;
> >>> +}
> >>
> >> Does the mlx drivers really register ports with different capabilities
> >> as the same ib_device? I'm not sure that should be allowed.
> >>
> >> I keep talking about how we need to get rid of the port_num in these
> >> sorts of places because it makes no sense...
> >>
> > 
> > I agree.   Requiring the port number has implications that ripple up into the
> > rdma-rw api as well...
> >  
> > 
> 
> In all fairness, there is no requirement that any two ports on the same
> device be the same link layer, or if the link layer is Ethernet, there
> is no requirement that they can't support both iWARP and RoCE.

There actually is a requirement. The RDMA CM hard requires all ports
be iWARP or !iWARP at least. I'm sure there are other subtle things
floating around.

There are also things that become very confusing for user space, and
we don't have the infrastructure to support, if ports can switch
configurations on the fly.

The simplest, approach, most in line with how verbs was designed, is
to require each ib_device to have a single kind of AH.

> The idea that the parent device defined the supported protocols for
> all ports of a device became wrong with the first mlx4 device that

Arguably it was sort of OK for roceev1, is less OK for v2, but
shouldn't have been done anyhow.

The uapi question here is do we want to double down and try and make
this work (and what does that even *mean*) or admit mlx4 was an error
and stop doing that going forward..

Or do something else? eg Specifying the AH type when creating the PD
could potentially solve some of the problems...

> could do both IB and Ethernet.  And I think I've heard rumblings of
> a combined RoCE/iWARP device possibly in the future from someone
> else.

Two struct ib_devices for the same port then... Certainly ugly.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
