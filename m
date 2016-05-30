From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
 resolution module into core
Date: Mon, 30 May 2016 09:33:49 +0300
Message-ID: <20160530063349.GA7477@leon.nu>
References: <0558d12b-2646-63b4-89f8-9bf4aba689db@redhat.com>
 <20160518171536.GB15170@obsidianresearch.com>
 <fe88d9cc-3d03-030d-c4c9-360ef0ce7067@redhat.com>
 <VI1PR05MB1391B1C6DFE620C31A6474A0D2490@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <561a675d-89d2-e675-cf83-e86ecb7519b6@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E22EDE332@CRSMSX101.amr.corp.intel.com>
 <20160523085809.GF25500@leon.nu>
 <57430E34.3090501@redhat.com>
 <VI1PR05MB13910E30E227D4DCDBC19033D24E0@VI1PR05MB1391.eurprd05.prod.outlook.com>
 <1464586394.13055.426.camel@ifi.uio.no>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1464586394.13055.426.camel-6miFZF/5cTBuMpJDpNschA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Knut Omang <knuto-6miFZF/5cTBuMpJDpNschA@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 30, 2016 at 07:33:14AM +0200, Knut Omang wrote:
> On Mon, 2016-05-23 at 14:09 +0000, Mark Bloch wrote:
> >=20
> > > -----Original Message-----
> > > From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > > Sent: Monday, May 23, 2016 5:06 PM
> > > To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Weiny, Ira <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; Jason Gunthorpe
> > > <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > > Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate IB address
> > > resolution module into core
> > >=20
> > > On 5/23/2016 4:58 AM, Leon Romanovsky wrote:
> > > > On Wed, May 18, 2016 at 07:36:03PM +0000, Weiny, Ira wrote:
> > > > > > On 05/18/2016 02:28 PM, Mark Bloch wrote:
> > > > > > >=20
> > > > > > >=20
> > > > > > > > -----Original Message-----
> > > > > > > > From: Doug Ledford [mailto:dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
> > > > > > > > Sent: Wednesday, May 18, 2016 8:59 PM
> > > > > > > > To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> > > > > > > > Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>; leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > > > > > > > linux-
> > > > > > > > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > > > > > Subject: Re: [PATCH rdma-next V2 5/5] IB/core: Integrate
> > > > > > > > IB address
> > > > > > > > resolution module into core
> > > > > > > >=20
> > > > > > > > On 05/18/2016 01:15 PM, Jason Gunthorpe wrote:
> > > > > > > > > On Wed, May 18, 2016 at 10:51:02AM -0400, Doug Ledford
> > > > > > > > > wrote:
> > > > > > > > > > moves it into the ib_core and also keep the new
> > > > > > > > > > ib_netlink stuff in
> > > > > > > > > > ib_core.  So, fewer modules, not more.
> > > > > > > > >=20
> > > > > > > > > What about getting rid of ib_sa as well so we can avoid
> > > > > > > > > that dynamic
> > > > > > > > > netlink registration patch too?
> > > > > > > >=20
> > > > > > > > That's fine too.
> > > > > > > Integrating ib_sa into ib_core also means to do the same
> > > > > > > for ib_mad.
> > > > > > > If you agree with it (ib_sa & ib_mad becoming part of
> > > > > > > ib_core), I'll
> > > create
> > > > > > the patches.
> > > > > >=20
> > > > > > Ira, Hal?
> > > > > >=20
>=20
> Having just been through a development of a new HCA from scratch, I
> found it very useful to have the separation between the core IB
> functionality and what I perceive as clients of that core
> infrastructure (ib_mad and ib_sa in particular).=20
>=20
> The separation feels natural, and it allows a more piecemeal approach -
> a device can be loaded and tested with one WR at a time. Once ib_mad
> gets loaded, a lot of "traffic" is created and just about the whole HCA
> under development needs to work to support it.

Adding new device to IB is not an easy task and we clearly need to improve =
in
that area, however these merges are targeted to the end-user of IB stack wh=
ich
constantly needs to load all these modules.

For the easy development, you can simply revert them in your tree.
Hope it helps.

>=20
> IMHO, if these "clients" gets joined with ib_core, the path for
> newcomers will be (even) steeper. I would appreciate if that particular
> separation can be kept. I am fine with the other merges, and it might
> as well be a good idea to join ib_mad and ib_sa,
>=20
> Thanks,
> Knut Omang
> (lead developer of Oracle's new IB HCA, soon to appear here..:-) )

Terrific,
We are eager to see it.

>=20
> > > > > I don't see a problem with that.
> > > >=20
> > > > Doug,
> > > >=20
> > > > Will it be acceptable to you if Mark base his patches on this
> > > > assumption?
> > >=20
> > > Yes.
> > >=20
> >=20
> > Actually the new series is already posted,=20
> > http://marc.info/?l=3Dlinux-rdma&m=3D146366717406108&w=3D2
> > if you can have a look at it'll be great.
> >=20
> > Mark
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> > in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXS97NAAoJEORje4g2clin1U4P/09pGYsSLHIHcjCRIPilur9b
5v4fFVnEsGkRxzkHlk4K/IVOjY15tHiQV/lxWbxAAeQIXUs/Dq3Nnuxw3Muxn4FO
EtWxqJf0ezciYNaVL65AjFdoTozS3vEZu/oNGMYh6BEnz4OlDxyRSighBNSYqkEu
gbtVlBkEUJjEOCIv51iNlypw/jy+2En7Ws9OJQuEGrN1HRxr8De69rA7z73a6OL2
MZJfy+DgMh5p9LaTCuuXhSPfXiYQy8GCBuW48vKPzZCqL+ngSgn4lvtWV9CAcKHz
zvfop1AVRnjA2MUSLsc1M+3SH80HEki8VJ5TAV8h/JKy6clKMVjUWIvKV6Y8C1NC
BBCLg4ihQ6ccTmHKmdHBoqnhBtvJekd8G+7jkcPTbJ/lq1SME3OsfmBOg6bH+MhA
8vQx2gUnv41UNPYTfFunSVC17gsiTDMtXMolxA8FcIU3Vd0WLwG4phw0rPFfbCLF
ADLSt8GrR/R46amvKppR94IvgTMQMmhWawMy8K3d3/8sAiYrYYytgtrtrN7daNlG
ZSWjWwGp7NtJ4tx6ZEZt3M0eJ4P/avbo343FgselmJeqrKuSrwIXWwoX77qFhY5z
sfC+hyBlYHRaPmkv1vRk6MaoeUgEhpRwZ8Cn+az4PlzDuDytOiF5Kbwg3DHnlUqG
9YvyNB/SmlaoQkOFiMJD
=kx9B
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
