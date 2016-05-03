From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Tue, 3 May 2016 09:35:15 +0300
Message-ID: <20160503063515.GA29160@leon.nu>
References: <CAANLjFq+6qu7kD75yOmVuztvE-6cbvhfjFOmGAy9i_43Cfdz7A@mail.gmail.com>
 <5721F149.1090004@grimberg.me>
 <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com>
 <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
 <20160429205434.GA11286@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0481A1@ORSMSX109.amr.corp.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0481A1-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 02, 2016 at 06:29:38PM +0000, Hefty, Sean wrote:
> > During the Collab summit I thought we reached a rough consensus that
> > these sorts of uAPI changes to the common multi-vendor API would go
> > through a more rigorous process and those who are proposing them would
> > actively seek a multi-vendor sign off instead of simply dumping them
> > on the list.
>=20
> I agree that this is the right approach to follow.  A Linux maintainer sh=
ould not be in the position of having to decide on which features merit a u=
API change.

In this specific case, all guides were followed.

>=20
> > Further, I also thought we reached a rough consensus that we'd shunt
> > some of this stuff to the driver specific uAPI channel to reduce this
> > continual churn on the common multi-vendor API for currently
> > driver-specific features. Drivers can implement their unique features
> > and sanely export them through the kernel without so much pain. The
> > uAPI 2.0 concepts from all parties have been heavily influenced by
> > this idea.
> >=20
> > Certainly, if patches cannot attract any review or interest from the
> > community as part of the core API then I'd say that is an excellent
> > sign they should be shunted to a driver specific channel.
>=20
> This is an excellent point.  The lack of interest is likely a very good s=
ign that this is a driver specific feature.

I don't agree with that point, the lack of discussion doesn't mean that
this is driver specific feature. In linux-rdma community, there is a small
amount of developers focused on their products and maintainer who doesn't
express his opinion.

There is general agreement that Mellanox is a leading provider of IB soluti=
ons
and as a leader it's expected from the company to propose new exciting
features which are valuable for the community (general API) and for the
customers.

In this particular case (RSS), we followed **all** possible guidelines of
presenting, discussing and adjusting. It was done in **all** available
forums (linux-rdma, OFA and OFVWG).

We did it openly without any hiding under "proprietary umbrella", as
other companies did during review feedback.

>=20
> I'm not sure why there seems to be objection to calling out driver specif=
ic features as driver specific and exposing them as such.  It seems like th=
e quickest way to get features into the hands of prospective users.

We want it beneficial to all participants without proprietary stuff.
We don't want to see vendor interfaces proposed and implemented without
any review as it was for several drivers in RDMA world.

>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKEajAAoJEORje4g2clinu7gP/RoHKOPNFlT1HsxS40G4sD83
xJq8jzYlS7CHEGBHPO6M6Ecc5K0EPd1YkdYbji45w3Yp5SFz6DZVEnTI7HIwRdH7
ZT25Iv7Zuz8ONoB8WXyzExgC8qjbtY2P2QRaTMwqRRT1+Z2qrOnRWwNXOk1alHF7
pY7TsJBPkU14xd8DwqmmpSryDXQvjZ7DPWWiXD4fLdoVEiMBHA0vatO0Lv7WYUsj
KcQzhPWkYSZtnpKAd1qnMKUgMkG/8xEeIKpDXqVHGYHEyqcNfrY3liRhzhVvD11a
CGQBY/GmA6FsL4SjYoJaVM/AUxcYMLN151m0ulybXJeWg2mJIzhb6NVM4vlM5z8L
JQo6Ky3Uez8E/bGG79IPrCFZm61/Qc3yg+GFWAOjRunrLG5Mhsw0JBZb4b53/dlN
lcvjIOfFGI5eEHU8ju7audwIyKshIlxV67Z/0zwa1hQCT97YXIbkKsqE76nVz3Qy
vuBcTPBXxJ/3d9LzFQb6GExMBGRceGhR3jAaZA/cSKP/OUqSVGgPijn32RsOQE3E
vPc0TsNxgzlCkbm0RGsoH24Rbiev9VKalpC2iVpRcgn0g0cXTOU2LLRhx72V10LT
s9NR4EOVZmSqklVZx/dn6O+OwmnA0TuoCZL829nrdaTdmE8jXuIzprsPF6RMsIsg
fUehk9wAngJuHjbi/2Yn
=tGAr
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
