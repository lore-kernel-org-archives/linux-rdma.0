From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Wed, 2 Aug 2017 19:29:38 +0300
Message-ID: <20170802162938.GC13672@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
 <20170801141023.GM13672@mtr-leonro.local>
 <20170801141842.GA1808@ctung-MOBL3.amr.corp.intel.com>
 <alpine.DEB.2.20.1708010921490.16491@nuc-kabylake>
 <20170801151511.GA13376@ctung-MOBL3.amr.corp.intel.com>
 <20170801195840.GC31205@obsidianresearch.com>
 <20170802034438.GV13672@mtr-leonro.local>
 <20170802155856.GA21208@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1VhaNAE4Hwu38Ubd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170802155856.GA21208-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--1VhaNAE4Hwu38Ubd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 02, 2017 at 09:58:56AM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 02, 2017 at 06:44:38AM +0300, Leon Romanovsky wrote:
> > On Tue, Aug 01, 2017 at 01:58:40PM -0600, Jason Gunthorpe wrote:
> > >
> > > I'm not sure why there is so much noise about this - yes, iwpmd is
> > > really weird, but it is a UAPI, we can't change it and we can't demand
> > > they change.
> >
> > If you claim that it is UAPI change, we MUST revert this patch, because
> > reverted patch CHANGED UAPI.
>
> That is not how I read it.. The UAPI was intended to be lossless and
> there was a kernel bug that made it more lossy than expected, that is
> what that original patch was addressing.

The catch 22 here is in the fact that there is no kernel bug. I assume
and according to Bart's questions (but better to ask him) he thinks the same,
that the bug is in protocol layer and/or user space part. There is no
visible kernel bug.

This is exactly what we are asking from Chien to provide the details.

Thanks

>
> Jason

--1VhaNAE4Hwu38Ubd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmB/fIACgkQ5GN7iDZy
WKe6Iw//eWXDm2dCnCQUzC2V0thtfcwobpXwxoEgoNgTaqcjrHOi8ESIge/8w4Wv
ETcgBuMPTUuwW8iheMih2IfcmrrKwsuoEgx9hBMDK9IHnPCfIyIUyQtmyi6Ng4u5
gLvrS6vX3vs1nT1WsJsp7FtVnusNvmFSOIfNWvP3IqFjMZRu/v93SRZvYruEnSJx
OEZDOFePgOL20Mnb0cj+Wb3Rnl9fjJUxOnWE472bUKe2spF1214LgNQ/pMbl/5Z5
E+6wg5HRkWL0R4PwbQKqCRIGKcSkEOIO7xhXXnekUMI6A3blHEl18GiLCqwHR6yG
cvZkyc95Zu/zP+Q7/Xnt0qpH/1H3PJmFmhmvv6h5AG4zvdBmFKYd1SO+baLPeSex
UgsI5odc7jcrLFdgMxJ/CMCJSLxxqNYgfQj/uKTCAhS1Ns5m8ud5xzMygxEndyyK
iWQhs9yecNiuxFQSW0HJyjzOqEmfBAdZFww/hZPZZlNGUyIK66V33TTjTonpl6B8
xB9AYPna7Ub4pRnQqvG+ds+iPQwQ8On9li+N359BtUyFoTwv5AZxLm1r4lKIz1Nl
eANt2f4/qZK4A37ObOwE6qn0hEBUNSDOYNRsE3awEG73QKBrgOB4Ea9iRyNYIoO7
wqscuTSbifO0E5RP+h0+nH+6fnM4sh6AGA2erwPhS0t6nHemzCc=
=fOBO
-----END PGP SIGNATURE-----

--1VhaNAE4Hwu38Ubd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
