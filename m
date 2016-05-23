From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Mon, 23 May 2016 11:58:09 +0300
Message-ID: <20160523085809.GF25500@leon.nu>
References: <eea7049c-5a27-1498-8e8b-674d69468fbb@redhat.com>
 <VI1PR05MB13910C6D09E0B6B9D477B1EAD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <d54c2884-c2e9-8952-75f8-43147943640c@redhat.com>
 <VI1PR05MB1391C3E551DDAEA3ABFE71FFD2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <0558d12b-2646-63b4-89f8-9bf4aba689db@redhat.com>
 <20160518171536.GB15170@obsidianresearch.com>
 <fe88d9cc-3d03-030d-c4c9-360ef0ce7067@redhat.com>
 <VI1PR05MB1391B1C6DFE620C31A6474A0D2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <561a675d-89d2-e675-cf83-e86ecb7519b6@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22EDE332@CRSMSX101.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7cm2iqirTL37Ot+N"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E22EDE332-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7cm2iqirTL37Ot+N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 18, 2016 at 07:36:03PM +0000, Weiny, Ira wrote:
> > On 05/18/2016 02:28 PM, Mark Bloch wrote:
> > >
> > >
> > >> -----Original Message-----
> > >> From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > >> Sent: Wednesday, May 18, 2016 8:59 PM
> > >> To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > >> Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-
> > >> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >> Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> > >> resolution module into core
> > >>
> > >> On 05/18/2016 01:15 PM, Jason Gunthorpe wrote:
> > >>> On Wed, May 18, 2016 at 10:51:02AM -0400, Doug Ledford wrote:
> > >>>> moves it into the ib_core and also keep the new ib_netlink stuff in
> > >>>> ib_core.  So, fewer modules, not more.
> > >>>
> > >>> What about getting rid of ib_sa as well so we can avoid that dynamic
> > >>> netlink registration patch too?
> > >>
> > >> That's fine too.
> > > Integrating ib_sa into ib_core also means to do the same for ib_mad.
> > > If you agree with it (ib_sa & ib_mad becoming part of ib_core), I'll =
create
> > the patches.
> >=20
> > Ira, Hal?
> >=20
>=20
> I don't see a problem with that.

Doug,

Will it be acceptable to you if Mark base his patches on this assumption?

Thanks.

>=20
> Ira
>=20

--7cm2iqirTL37Ot+N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXQsYhAAoJEORje4g2clinQ9sQAJlKvP4jkXdWLb5jGmVasmrg
5nKm8Ztfiebqh89Y514pVuRQZ94cWI5Eylvk45Zz3xZvrNi2yuBPXQ+C5QSrXRtf
N4k5mxMymzQARibjW7DOkJ0jsnzjsHpPU/KKXGrZSDfl1U7w6DXs/gEcI21vgjq3
SLUs6YbGnoPHMtE5Qs53T45tZ1mNWJb823IH+AJzzHkCUpqxSNcVsB5XzDw2cVrU
/FOwiaH3/EjJZVrx+OYieptRnDPztckYcJtYzcDP/UgT7uOXa+0cB+m+jMlG866f
Ry05v5cYMsyCDj3RQjSGvQ7/cxffDSog3ygtGI707vu2ioF+IPFIkSwFpLhEiFW+
tzAQbJbwRnTtJ78jOV22Ft0AT4dVWetVNMMsAfgqqEzjL8pcRp0nqz/41je33F+p
it2805gPuU2iSIKKsvJeAfYYGdcOjeKVseU50k5TaoE26S6P5vTll9GXCjA65t/+
43W9F/bbaK0XAkDM/RZ9nHtKyXgPBIAFpSC95gvTJQjONecydBJe4bfirmo4c2Tq
wRZrPEnDk3OwroPe6s5UUBkVYHXXhdp7iHHMirc+J6o851/F17mFOPvfij9xmTfq
ZB8RbY6hVsRGwjf0vnMqjYPsEGhjosJglpDUs10IG7h5wg6SCbvQXsKy+QIbY238
mtrUh7Dve8mJf4Ee3OM8
=vVyV
-----END PGP SIGNATURE-----

--7cm2iqirTL37Ot+N--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
