From: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: mlx4: IB_EVENT_PATH_MIG not generated on path migration
Date: Mon, 16 Feb 2015 12:48:27 +0100
Message-ID: <20150216114827.GD16899@fholler.de>
References: <20150210155643.GB13690@fholler.de>
 <20150210180039.GD7427@obsidianresearch.com>
 <20150211092136.GB492@fholler.de>
 <20150211173837.GA20243@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150211173837.GA20243-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Jason,

On Wed, Feb 11, 2015 at 10:38:38AM -0700, Jason Gunthorpe wrote:
> On Wed, Feb 11, 2015 at 10:21:36AM +0100, Fabian Holler wrote:
> > On Tue, Feb 10, 2015 at 11:00:39AM -0700, Jason Gunthorpe wrote:
> > > On Tue, Feb 10, 2015 at 04:56:43PM +0100, Fabian Holler wrote:
> > >=20
> > > > Does anybody have an idea what could be wrong?
> > > > Are the PATH_MIG* notifications with mlx4 drivers are working for s=
omebody?
[..]
> > The event handler specified in the struct ib_qp_init_attr * parameter of
> > rdma_create_qp() is registered as QP event handler.
> > rdma_create_qp() calls ib_create_qp() and sets qp->event_handler to
> > ib_qp_init_attr->event_handler.
>=20
> Okay, right, I was thinking of something else.
>=20
> We had exactly this working a few months ago for a demo, in kernel
> using Lustre and RDMA CM. I checked the patches we made and yes, the
> event_handler was being properly called with IB_EVENT_PATH_MIG on
> mlx4 and qib cards.

are your patches for APM support with RDMA CM available somewhere?
We would be glad to test them :-)


regards

Fabian

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJU4dkLAAoJEKFglfj27o3IyEYP/2pFtSqp5xELmX5wmipziyP1
f3Hxy1ePxaiO7uVNW4YpHiRHBSMQAKMVIEW94ZV288oNpfbk0fdr2oHSkGVdjCNr
/aox0EvXLNAJZYX8smRmB2Xus5/5RhF/R2M5EKypqbu5OV1k23wDhm9m8qHnBI1S
AmcmAYYivQD8ty267RS8gdSvCDI0KUM8JrIgQ2Ict4rzrA1G2knYf/bw4NO27/vm
7QrVQsTUIrDDnTcy7W8ni0bDI4W2986NjEYYWpYOzrW2Io5k/Saf8we9Bih72mDJ
XJOltF8gNxddOP0+Zn24kldN7nenLrIOA+NM7jpVMwlMa6wrWSSy4GYUu4TAyL1b
HtgSLHeY5rPFvZ8EfMNLSf/PogyBsN2/JUQPYZYBNJE5yWZAcRRjq4h3ExE2LNsL
WxXn6N0PModqWlcVP6tPIXnwKqCQzmq5ZkTsorboZa2nDZ8RtBxLKirCasX0QQjs
WTi9K/DPslW4ZGVr3N53Ruobu/PoQ/QLkLmMbDxcpaW6hNbDVq6YQmbb0dDR1sOT
GgoFaXSMreC7use0Qgo/TGPZwjQ+7GkhqKWswS45mrVshdgaxt4oKXQEN0LYGB1X
q5I5vQ/MhXRJ4/TxobJ5FsbIXlhRG+/WA0kT8eEDimGOJL+NYpUyEoVtbe6s64rm
6f14IF+2T5gXNSHxh8NM
=gbQI
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
