From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 2/8] IB/hfi1: Document phys port state bits not
 used in IB
Date: Mon, 14 Aug 2017 07:56:02 +0300
Message-ID: <20170814045602.GB24282@mtr-leonro.local>
References: <20170813150659.23208.66243.stgit@scvm10.sc.intel.com>
 <20170813150827.23208.83131.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VgNP6wxEowREGVu+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170813150827.23208.83131.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brent Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VgNP6wxEowREGVu+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 13, 2017 at 08:08:28AM -0700, Dennis Dalessandro wrote:
> A couple bits are used by OPA for link physical state that are not present
> as part of InfiniBand. Add a short blurb what those states mean and removed
> an unused state.
>
> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Todd Rimmer <todd.rimmer-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Brent Rothermel <brent.r.rothermel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/opa_compat.h |   21 +++++++++++++++++++--
>  1 files changed, 19 insertions(+), 2 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--VgNP6wxEowREGVu+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmRLWIACgkQ5GN7iDZy
WKelyw/+KfrYTemfmvLAp9ZSgzH6jraQ+fMsdDvUF78r6Qm8VFcejCNpcxQYoZSH
cdTe61tgkRUOfQiDcFIAvP+mIaIKu2bdrV3JfK+gYksENKgpocBcBxYRKLYZQXkl
wv/I0RK5YXyOs/cpYE0eZIIx4i0UQdzhjPN4OjABuPcHMhBuByknuzGTXUwbs/+E
g7pbKnAmIat29FSs3PMEaydbH49Thi5IhyTbMz5goaWWmIQ3jQa+/xYbbVDEkpbA
1KRf7ug0g4xtU4FDksW9SfCXuEVXV9uSv8lL5hsKo74u4NrwYIWzIQSijUKAoX9c
UaBchL7tBA/e1tJo8SP7lQj85Jbxr2ySk7B9zTmAVI00XInz4cdlyOA79oq72hoX
sNPudaptl8Tfv4r8n29RvThWrhxYOHr2F2OnygPV3j1zYgkb1CkNk5KyR9dXUb1P
wYaTLAjEMeco5fu7Ncs0Bfxcl92A3lbJrbGye39NkAzsLZO99j36nAu7RKiTnhuF
DYdey/WrOZaTQI1Y3xpBu99qi1cgv2IAA2uZVaai04UoE+w5768J2IYoOKmOYkWV
SjkfmJ7VlYOevsG/9qdVYr9MaCEBlxfiEk4D38Oxfp8+YFghCci5PMWdYHX3Kw+M
qeNBODgRTZfA5zE0P36mqsVYtjFIbUqWCQnJN8aY6/oiX0lGwyo=
=Qmm8
-----END PGP SIGNATURE-----

--VgNP6wxEowREGVu+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
