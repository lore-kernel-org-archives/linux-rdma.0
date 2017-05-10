From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Wed, 10 May 2017 18:24:34 +0200
Message-ID: <1494433474.3739.15.camel@profitbricks.com>
References: <20170507064349.GM22833@mtr-leonro.local>
         <1494351789.3752.5.camel@profitbricks.com>
         <20170509180517.GA9715@obsidianresearch.com>
         <1494408947.3739.2.camel@profitbricks.com>
         <20170510155005.GB1007@obsidianresearch.com>
         <20170510160201.GD1839@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-oY4SnlVZV0Gkas1sonq7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170510160201.GD1839-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Spanier <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-oY4SnlVZV0Gkas1sonq7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch, den 10.05.2017, 19:02 +0300 schrieb Leon Romanovsky:
> On Wed, May 10, 2017 at 09:50:05AM -0600, Jason Gunthorpe wrote:
> > On Wed, May 10, 2017 at 11:35:47AM +0200, Benjamin Drung wrote:
> > > Jarod already created a rdma-core package in debian/control in
> > > commit
> > > 8df5873b9. Currently we do not have a rdma-core package in Debian
> > > and
> > > no package with a kernel-boot service file. I know that the
> > > openibd and
> > > =C2=A0mlnx-ofed-kernel-utils packages shipped a openibd service that
> > > does
> > > similar job.
> >=20
> > Yes, pulling something like openibd into rdma-core is the idea
> > here..
> >=20
> > > Do we want to call the binary package that contains the kernel-
> > > boot
> > > service 'rdma-core' or simplify that to 'rdma'? We should use the
> > > same
> > > binary package name across the distributions (unless it's
> > > conflicting
> > > with a naming convention).
> >=20
> > I think rdma-core is fine..
> >=20
> > > Can you come up with a patch set? I will be happy to review it.
> > > Note
> > > that paths like /usr/libexec/rdma-init-kernel (in rdma.service)
> > > needs
> > > to be made configurable. In Debian, we would install these helper
> > > scripts in /usr/lib/$packagename/$filename.
> >=20
> > Maybe Leon's team will try to tackle some of this? It is
> > complicated,
> > the RH scripts do quite a bit stuff :\
>=20
> I would be happy to help, but I'm not sure that I understand what
> should
> be done :(

Move redhat/rdma.service and everything that is required by it to a new
'kernel-boot' directory. Add a CMakeLists.txt file that installs the
service. Make sure that the hard-coded paths are set by cmake. Also
check the moved scripts for old, legacy stuff that might not work
somewhere else.

--=20
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web:=C2=A0https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss.

--=-oY4SnlVZV0Gkas1sonq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJZEz7CAAoJEN2M1aXejH56w9MP/iEgY0WCdWC1ZBKoHiA3N28O
otvF4TWCrym4xf3LOZmqgh/iYRH8+QRVud1awjzM6G+9F9LwuICgGcK89zWXjOT1
9wQlokqwJ4+Mq40/o1UNWx9HSZcFHP0bkLsIf62YpUpTpUYmX3lHt8qB768/ix1o
85ZvLIQ7L54kxRGWfqSubNECzH7KdtXsbDkcqTEXWuH8YlGj8G1Plic5k2vg/mQm
xqjs0BEbwSUOguS8E+CgDWlKFSqUk8vR0IdbzcrDc4BuZ1r4MerJwfTdxk3EqDiW
cXFMuhiQ2DO+bCCfXSZVlu/VH8/YdCsOOsVGb+jCCq7rqa4gdOx/kcrS04hfzjai
fhrygC9ATs5BhJXq91k/eQ64e9j/80Lwtvrz5h5hUMNGzySoIgESmkPP2SG/3/cs
1WkwUbwWiXaMIvDKjRm8xqEpHXWpel33NoiKoZPAJ0vU1haOzgJ/o+xuGgHrN6IH
OvRwRZeyrNJVMOUoK0G6ku6mhsVqFIrcyuyUArZv3HBfVHziqUBt9mJrNYMxfgJ9
Xf6uB435Yk/Bwba7k2cBCumQXLmwLD2paSah6P7YoKz8hTEBrRTpZzFldajM1wQJ
7/X9+Lq0K2L3s0whclV4WxTyiJ3hjb3Pcry1kDn6cGxrsKMNeE11V+6uR62ivn4v
3tYLfHQfYo32MdZ7S2Gs
=VUCX
-----END PGP SIGNATURE-----

--=-oY4SnlVZV0Gkas1sonq7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
