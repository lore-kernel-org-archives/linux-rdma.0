From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] ConnectX-4/Connect-IB Port Counters
Date: Thu, 23 Jun 2016 19:44:18 +0300
Message-ID: <20160623164418.GC23995@leon.nu>
References: <1466165456-31857-1-git-send-email-leon@kernel.org>
 <b4dc9bd0-a84c-201a-475a-a9afd9bffb44@redhat.com>
 <20160623161748.GB23995@leon.nu>
 <09e6e3c1-5eba-df8b-7d0f-2c2572ed83c9@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <09e6e3c1-5eba-df8b-7d0f-2c2572ed83c9-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 23, 2016 at 12:21:23PM -0400, Doug Ledford wrote:
> On 06/23/2016 12:17 PM, Leon Romanovsky wrote:
> > On Thu, Jun 23, 2016 at 11:41:11AM -0400, Doug Ledford wrote:
> >> On 06/17/2016 08:10 AM, Leon Romanovsky wrote:
> >>> This is supplementary part of mlx5 driver to generic IB counters infr=
astructure.
> >>>
> >>> Mark Bloch (2):
> >>>   IB/mlx5: Add per port counters
> >>>   IB/mlx5: Add port protocol stats
> >>>
> >>>  drivers/infiniband/hw/mlx5/main.c    | 134 +++++++++++++++++++++++++=
+++++++++-
> >>>  drivers/infiniband/hw/mlx5/mlx5_ib.h |   6 ++
> >>>  drivers/infiniband/hw/mlx5/qp.c      |   9 +++
> >>>  3 files changed, 147 insertions(+), 2 deletions(-)
> >>>
> >>
> >> Took a little work to make it apply, but series applied for 4.8, thank=
s.
> >=20
> > Thanks Doug,
> >=20
> > I'm limited in my ability to predict the order of applies, and for
> > example this patchset applied cleanly for me.
> >=20
> > For your reference, I have reference branch (testing/rdma-next) with all
> > topics in it.
> >=20
> > Do you want to see it organized differently?
>=20
> No, I'm just making you aware of the fact that I had to fix things up so
> that if you want to double check how I did the fix up, you can.  It
> would be bad if I merged something and broke things subtly and no one
> knew until much later.

Excellent, we will do.

Thanks.

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>=20
>=20



--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXbBHiAAoJEORje4g2cliny+kP/3in6khI2T2FHr5qHh6PuSBp
gjqDwa9Wtw59tW4dRgzJLFzuCVGxsuyw4x0CAYeDjU35Ory7TEm/gZI1IvT4YHZy
+X8tyTniDJttQv5Evp0n3rvtYHoOLbXi+rKn8e1deZkrEZKlQ8emg3R6EmLARIkO
H00zbSz/AbqHfW6XbnwgVfvT5nlzLA6PGCUY56JgKXrBBl83TzaWQehCrSjyBBms
kdErL8Z35VLUxL9JubuUuP/kooNZyC1mBy0a89UO06JZXvTFo8XIjwTK6YRXzbVp
V+5S+u5vzCsc0UZkOglcH7e0TMefA3Z/8W3b/LUSrMcyZgj7TmmKxCg1X5S9Wrm5
QBNJwUretN9eX6eer/P1rg2B+qjosQ0o8KhXht88SvQ/wh447gMOA502zfMlr167
j0KmU/s59VMJRZ8yZUH69WTiYteTqyrvEOambk98rTLdXJFF1XWe0ORQoQML0RhZ
D0B9zeRBcFWfChKHnZI47imudHxHwy5zWVH+ED3kY3jXRw8y8YHRzOxokU8GMrnN
I9omKC58MegIfA634xKaKrZzUkme78zc63RJDydxNoXW/wZeIp9jViQwgtxicvrV
5BP16fWfQPqIpxodzbzySymogl1plk1shOQi8GBFud3MxN1LlIdeeWNfgrVmzvLJ
feyXCjli4SIygrKu/MXW
=C5wD
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
