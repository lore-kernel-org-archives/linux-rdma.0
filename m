From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add Quality of Service support
Date: Sat, 8 Oct 2016 18:41:39 +0300
Message-ID: <20161008154139.GZ9282@leon.nu>
References: <20161006152128.14940-1-henry.orosco@intel.com>
 <20161006160016.GQ9282@leon.nu>
 <20161006212659.GB6664@horosco-MOBL2.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6ysXqiu0yoUmUNJB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161006212659.GB6664-ZmvEvTIhtuUfyugFOqMDN/ooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--6ysXqiu0yoUmUNJB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 06, 2016 at 04:26:59PM -0500, Henry Orosco wrote:
> On Thu, Oct 06, 2016 at 07:00:16PM +0300, Leon Romanovsky wrote:
> > On Thu, Oct 06, 2016 at 10:21:28AM -0500, Henry Orosco wrote:
> > > Add support for QoS on QPs. Upon device initialization,
> > > a map is created from user priority to queue set
> > > handles. On QP creation, use ToS to look up the queue
> > > set handle for use with the QP.
> > >
> > > Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > ---
> > >  drivers/infiniband/hw/i40iw/i40iw.h       |   9 ++
> > >  drivers/infiniband/hw/i40iw/i40iw_cm.c    |  30 +++++-
> > >  drivers/infiniband/hw/i40iw/i40iw_cm.h    |   2 +-
> > >  drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 151 +++++++++++++++++++++++++++++-
> > >  drivers/infiniband/hw/i40iw/i40iw_d.h     |   2 +
> > >  drivers/infiniband/hw/i40iw/i40iw_hw.c    |  25 ++---
> > >  drivers/infiniband/hw/i40iw/i40iw_main.c  |  64 +++++++++++--
> > >  drivers/infiniband/hw/i40iw/i40iw_osdep.h |   2 +
> > >  drivers/infiniband/hw/i40iw/i40iw_p.h     |   2 +
> > >  drivers/infiniband/hw/i40iw/i40iw_puda.c  |   3 +-
> > >  drivers/infiniband/hw/i40iw/i40iw_type.h  |  18 +++-
> > >  drivers/infiniband/hw/i40iw/i40iw_utils.c |  45 +++++++++
> > >  drivers/infiniband/hw/i40iw/i40iw_verbs.c |   6 +-
> > >  13 files changed, 323 insertions(+), 36 deletions(-)
> >
> > I believe that it can be split to series.
>
> As all this code is a logical unit for QoS support, we thought
> it best to submit as a single patch.

Large logical unit --> patchset
~400 lines of code --> large unit

>
> Doug, what is your preference?
> >
> > >  mode change 100644 => 100755 drivers/infiniband/hw/i40iw/i40iw_cm.c
> > >  mode change 100644 => 100755 drivers/infiniband/hw/i40iw/i40iw_ctrl.c
> >
> > Why did you change file's mode from 644 to 755?
>
> Nice catch! Will send out another version with this fixed.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6ysXqiu0yoUmUNJB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX+ROzAAoJEORje4g2clinzm4QAJ75fyG01fX7/B6FClLip7Ru
BcSFZubMlWmAgD2GfS3mGp7OhbxESuYlTRFpOCirsIaXLZUdEkH3kFsN7mmLcA72
sHG/5UR9bFKQMYaIJBhJXIrtXfW6IuBjmoFqCyk8Z7dqQRX8vCoI/7Fzb236mTVk
ON3kawGdfVAvL9cx5BaeB83xP2dAmCr603oHCYZuOEWAI93QncLzbOeV9ANx3O3Q
5R74WU+XxrQMHKyo0LTDcd2nkV90c62u/8TTJ+ivj0ojlSa3Sx7n04Z1XE3r6ws+
5RvHPb7ADByJSplMnD0PboOKh8m78StkFMsY2xhOqAtPBmvoOwRx/E/LZ+uQNQs8
ifVP36nVg5Fv+295TPoHDXM8QuLcBhstDUG7D9OfSW5sFxEHFx7aT+cFNzer02KM
kLhQcPR9QzitM4ffdY5frRcv9k31Wx5JgPMwft6I4uAR/TmydGo/jyzqD+zaYxu0
8Z+9baDVMwGatuMCgcs3ZnPSV3YGIotwyxvj6eLNe7t9vZl0HfOgsIZMHi0dLftJ
+z9bhlDq6/f/fq58V7P//Nuv54Y1x/aUXPR9nF77E6tOjI44QVpvyI9DfKTk7u1B
I9Z6Wq788FsRzOjwOoIG2EM8QmwGGbZ1sGiqneL5S9KAu/gGkuQIJI/SDEhy7mca
wnt9X03KbwO79SbFxXzi
=49Uc
-----END PGP SIGNATURE-----

--6ysXqiu0yoUmUNJB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
