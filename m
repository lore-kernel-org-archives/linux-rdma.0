From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH] IB/core: Make device counter infrastructure
 dynamic
Date: Fri, 20 May 2016 14:53:09 +0300
Message-ID: <20160520115309.GA25500@leon.nu>
References: <fb1272e0-8c87-e51a-2220-5fdde598311f@redhat.com>
 <490a5365-ce89-f4a5-3547-32c37757da1d@redhat.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <490a5365-ce89-f4a5-3547-32c37757da1d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 19, 2016 at 11:15:45PM -0400, Doug Ledford wrote:
> Reply-all didn't include the list for some reason :-/
>=20
>=20
> -------- Forwarded Message --------
> Subject: Re: [PATCH] IB/core: Make device counter infrastructure dynamic
> Date: Thu, 19 May 2016 18:13:22 -0400
> From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Organization: Red Hat, Inc.
> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Mark
> Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> On 05/19/2016 05:50 PM, Jason Gunthorpe wrote:
> > On Thu, May 19, 2016 at 05:35:13PM -0400, Doug Ledford wrote:
> >=20
> >> +	return sprintf(buf, "%d msecs (rounded from jiffies), 0-10000 allowe=
d "
> >> +		       "range\n", msecs);
> >=20
> > sysfs files should not have usage commentary like that, just use the
> > %d
>=20
> I had that originally, and I'll pull this out when the stuff is
> documented somewhere else (either in the code or Documentation).

There is Documentation/infiniband/sysfs.txt [1], which looks as a good
candidate for this.

[1] http://lxr.free-electrons.com/source/Documentation/infiniband/sysfs.txt

>=20
> >> +char *names[] =3D {
> >=20
> > static const char * const names[] =3D {
> >=20
> > For Kees
>=20
> Fixed (in all places)
>=20
> >> +	[NR_COUNTERS] =3D NULL
> >=20
> > Don't really need this, just use ARRAY_SIZE(names) in place of
> > NR_COUTNERS
>=20
> The original code required a NULL terminated array.  Given that the attr
> array requires a NULL terminated array, and these are used to set that
> up, I'm not sure I mind burning an extra NULL for the semantic match,
> even though it's no longer necessary.

I disagree with your statement that removing BUILD_BUG_ON() checks is
a positive thing. In this case, we are talking about constant array
which is not going to be changed till new code will be added and compiled
again.

The questions which can be asked, do we need so much BUILD_BUG_ON checks?
Can we minimize the number of them?

>=20
> > Trailing comments are not the kdoc standard for structure members,
> > IIRC.
>=20
> That falls in the same category as the lifespan sysfs file.  I tend to
> document things in place while I'm writing, and then erase the
> documentation when the final version is complete and the real docs are
> in place.

In such case, it is better to send as RFC to present that this patch is
not in its final stage yet.

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXPvqlAAoJEORje4g2clinCs0P/iG2elxf/ThPnCQT/k2A3Utx
iriUH5eL2fbYr1XImUXDAOZdrOXgmK6+ssazY0HM8n2BBuE/AGI6NDcAE4vzVNRM
pYOaBiwdopjDtJRVnD3udr5TWffd3K35mJf2D1KdwG9AgW2QMYdTm0xL5mFyOcZ9
vR+6rWbxEiO8tj7rFM3daTxVqjpjng5qJD3y3zjJN01E5vERvedfztvVi3A6bNfT
i0gy+xi3Ulr0VjVhY0opkTJBGxNtDL5UnQQVGz0HOqqjRPZUkgTP9QluBrWSBte4
Iys0PKJOIGWZS3Rkr0oNOPGqwlVLfmOG7PcDr3x6fI5Q0Sl3NMaLWdx5Kd24MzTa
3DKPy3NUEZ0DqyplkTgpRC/dIaFKVVUf72JnNvDLzH6zd42p9FVSOuIZ7tM5+3Jb
L5kS45mH7vT/q//CNfsOxll3k2KKiz8DCQjRkoJSzfXtylGKoqyWiONZ8t/tsEwu
WmHAuO+KiRE875f8zhhpLj5K2bPRdyX74Ze/T6Q3G2Yd6RHxbefxB+Qf9SqQi2SF
yN1QvQs22YKOJdpBapVLNtds2ufRYz6Kq6rx64Yyk86VmPgNzKJ7SejJC7BosMpf
KReuzljnoniQA3QYSRf51bAYo0+e5+3BBs1mLDUx7fzTOSaZAGXAfSXtiS/eNyW0
qtWyfAYsXWubb5UDWGWG
=QjV1
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
