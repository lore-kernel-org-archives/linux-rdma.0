From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/10] Hardware tag matching support
Date: Fri, 14 Oct 2016 07:19:58 +0300
Message-ID: <20161014041958.GD9282@leon.nu>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
 <20161007145620.GV9282@leon.nu>
 <1828884A29C6694DAF28B7E6B8A82373AB093986@ORSMSX109.amr.corp.intel.com>
 <6259953b-27fe-77c9-ea90-af744f188671@redhat.com>
 <1828884A29C6694DAF28B7E6B8A82373AB095429@ORSMSX109.amr.corp.intel.com>
 <20161013170641.GA9094@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373AB095647@ORSMSX109.amr.corp.intel.com>
 <20161013195605.GA8077@obsidianresearch.com>
 <20161013200208.GA8998@infradead.org>
 <a3495685-69c7-26a7-ba97-9761848535a8@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Jm4NjHtWXfjOIegD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <a3495685-69c7-26a7-ba97-9761848535a8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Jm4NjHtWXfjOIegD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 13, 2016 at 04:30:10PM -0400, Doug Ledford wrote:
> On 10/13/2016 4:02 PM, Christoph Hellwig wrote:
> > On Thu, Oct 13, 2016 at 01:56:05PM -0600, Jason Gunthorpe wrote:
> >> A bigger objection I have is that much of this new stuff is not
> >> adaquately documented.
> >>
> >> Tag matching is a great example. It looks like this introduces many new
> >> headers into the on-wire protocol. Where are these headers documented?
> >> Where is the spec for the on-wire format? Where is the implementation
> >> for rxe?
> >
> > Agreed on that part.  For pon the wire changes we need the hardware
> > standards organization to act.  IBTA for IB and RoCE and IETF for iWarp,
> > although not even having an active WG for iWarp there is a major problem
> > at the moment.
> >
>
> I think there are some fundamental questions here about what this is.
> As I understand it (and Mellanox can chime in if I'm wrong), tag
> matching already exists on the wire, it's just implemented above the
> level of the link layer transmissions.  This enables a hardware
> accelerator for something that is already done at an upper layer, so the
> implementation is mostly defined by the defacto existing use in upper
> layer applications, not by the IBTA.  I believe this could roughly be
> considered analogous to a network driver enabling a layer3 or layer4
> accelerator.  It's not a layer1 thing, so the IBTA is not appropriate to
> review it.

Yes, you are right. It is in use by most if not all major HPC players
and in this patch set, we are providing possibility to configure it and
expose supported flavours of tag matching, so they will be able to run
RHEL out of the box. There are no HW limitations on how other vendors
(let's pretend that they exist) will implement such feature.

As Sean mentioned in the other email, PSM has it and libfabric natively
supports this functionality through MXM provider.

Regarding documentation, we are in continuous process of improvements
for our submissions and will definitely put our attention to that point.

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--Jm4NjHtWXfjOIegD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYAFzuAAoJEORje4g2clin2EsP/R9ziiK+YL4Soak/08zkupma
zQuKMI9rFDFbiJKvvMl9ZTQwaip9LTNxDYOs/245RQPqS4dpvoZ6ywgLRtQj/hY5
ctNkXYN8dX9To9I/HY8rZCT/Ib0sSnG0lAUtQdXynxZBv34cNbCFv8jUktjhiuhw
FV2tB9VO21SiSRgCGvIVVpqT8O8iJyLY1ZITEGKh1t4O6LlCCoXR1+fDG+0SHhXx
rJWqOpqQKGxFx1tCqF919ZvnurDPPmdjYLUpIJpwO5unLxWaxL0WIRYB4tCNorDm
Z86sQuT3HUcsu4ubQGFX/AmrwJBW7sIO5pX1tUF/TtTNQ8JOocpDUq3ogyqxwLJ+
R/nY2GpMWsh1RcG+aWTvvrM2W4VCzYy3+szNVSbG8pOjVCyPHk1HsI3qzlw7PGjb
C8M3cP33rp9QvBwvOXwv654prqeiTuEx2tf2mCNT1ErzGlqXcxerkeVVFfUg09h4
4t5jOQkNuWNM9iK45sGUdkNZFNL4PyJbsNVDgX6H1a2qa1XqPRrPHjFoN+vMI12i
Qv7iUfhaOhUlqdT14vwsx0PyBkdyIyWIAk6UYi+YqBGtF8h36KaitVVMI+AaV0vu
ZdZnWan3+IK8k6BzkH+HwKwTT96oPfXGqMQlwXex/g2/U7f+8AGaLaw7SQ+w5W2I
MICa6lKpDDcf9MU6Qjcc
=0+X5
-----END PGP SIGNATURE-----

--Jm4NjHtWXfjOIegD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
