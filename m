From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] i40iw: Add Quality of Service support
Date: Thu, 6 Oct 2016 19:00:16 +0300
Message-ID: <20161006160016.GQ9282@leon.nu>
References: <20161006152128.14940-1-henry.orosco@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mpb+VUhBqKoEsre9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161006152128.14940-1-henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--mpb+VUhBqKoEsre9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 06, 2016 at 10:21:28AM -0500, Henry Orosco wrote:
> Add support for QoS on QPs. Upon device initialization,
> a map is created from user priority to queue set
> handles. On QP creation, use ToS to look up the queue
> set handle for use with the QP.
>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Henry Orosco <henry.orosco-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/i40iw/i40iw.h       |   9 ++
>  drivers/infiniband/hw/i40iw/i40iw_cm.c    |  30 +++++-
>  drivers/infiniband/hw/i40iw/i40iw_cm.h    |   2 +-
>  drivers/infiniband/hw/i40iw/i40iw_ctrl.c  | 151 +++++++++++++++++++++++++++++-
>  drivers/infiniband/hw/i40iw/i40iw_d.h     |   2 +
>  drivers/infiniband/hw/i40iw/i40iw_hw.c    |  25 ++---
>  drivers/infiniband/hw/i40iw/i40iw_main.c  |  64 +++++++++++--
>  drivers/infiniband/hw/i40iw/i40iw_osdep.h |   2 +
>  drivers/infiniband/hw/i40iw/i40iw_p.h     |   2 +
>  drivers/infiniband/hw/i40iw/i40iw_puda.c  |   3 +-
>  drivers/infiniband/hw/i40iw/i40iw_type.h  |  18 +++-
>  drivers/infiniband/hw/i40iw/i40iw_utils.c |  45 +++++++++
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c |   6 +-
>  13 files changed, 323 insertions(+), 36 deletions(-)

I believe that it can be split to series.

>  mode change 100644 => 100755 drivers/infiniband/hw/i40iw/i40iw_cm.c
>  mode change 100644 => 100755 drivers/infiniband/hw/i40iw/i40iw_ctrl.c

Why did you change file's mode from 644 to 755?

--mpb+VUhBqKoEsre9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX9nUQAAoJEORje4g2clin2kQP/jm/glKMk3TQ5P8yqzBInq0t
A761e/sr8ec21OemunWFodN7+5lN6yjOuo1lOa5VVg9i077ZQIsn3MKOuBFiPL1A
ujVBlO+F0Kbh4AsHeO6NMXPMXKL4YdUaG8HU5OqqW8PFFnIk+FlXzUhYAyL6Bt70
G6Z7T3L15UcgY5ZIGTmtzH2/P0rJsv6/mZnwcIKOZ7SnC0Tuw75IEZl1BvMJ+n0P
/x2laOaHU4A0NUSJggfHOuwEyxHL5XoWLFR1sqM0plVyuIlVkK43jJaGfQBPEz5B
6FuaqZRiuaeaELLFgCjScPNJYAkyVt+0Z+nk7nwMslYsj+3wAc3O5lL9IHsW3wRa
Zstj3V4uUauSiAeKh7tYj6eJYQ2/7CpW4sDstDLHaODxYN3oiT2kg7xmQrDahPFw
jLDy3tsQXfW4qIGzDMeZVrYW+dbBDZx+juYsKWOO66uh+1aYnhFJo+imfWpe0jwC
RJagzxxG+pk7rhqtzsw0p3Q7SUImxuCMejPW/Aei4x1qVoO3SIe3aSChBvPtGIjz
qmCEfpDogf30gBjdc9f1Z5ZfvL657hV90QNiQzGGN1/Oq9fafKNTv2Sh5RztS2D8
+S0T4gL8nbMbjUD2Joxc/nVxEASWT6aWRd9ii/dsqC/+0yVIuUJuhKPHSGNQ/o26
a0yAGGI+a5+vzlPGnWOe
=VSg5
-----END PGP SIGNATURE-----

--mpb+VUhBqKoEsre9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
