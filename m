From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core_15-1_amd64.changes ACCEPTED into unstable
Date: Tue, 14 Nov 2017 13:01:24 +0200
Message-ID: <20171114110123.GW18825@mtr-leonro.local>
References: <E1eENiD-000EaM-BG@fasolo.debian.org>
 <20171114023711.GA22633@ziepe.ca>
 <20171114072056.GP18825@mtr-leonro.local>
 <1510656661.4026.23.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mvWwdhJHqQXOQ5Pq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510656661.4026.23.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mvWwdhJHqQXOQ5Pq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 14, 2017 at 11:51:01AM +0100, Benjamin Drung wrote:
> Am Dienstag, den 14.11.2017, 09:20 +0200 schrieb Leon Romanovsky:
> > On Mon, Nov 13, 2017 at 07:37:11PM -0700, Jason Gunthorpe wrote:
> > > Great news! Good job!
> >
> > Thanks a lot.
>
> Yeah, finally \o/
>
> Now it is also synced to Ubuntu 18.04 (bionic):
> https://launchpad.net/ubuntu/+source/rdma-core
>
> Some builds fail. Reasons:
>
> * Non-Linux architectures: One package is marked as architechture "any"
> instead of "linux-any". Thus the builds are tried on non-Linux archs.
> Expect a patch to come.
>
> * Architecture NOT able to do coherent DMA: Some providers will be
> disabled and the install target fail to install the missing providers.
>
> * valgrind is not available on some archs: Can we drop valgrind for
> those archs?

Yes, it is unlikely that we will port valgrind to those archs.

>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL: https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=E4ftsf=FChrer: Achim Weiss, Matthias Steinberg



--mvWwdhJHqQXOQ5Pq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKzQMACgkQ5GN7iDZy
WKecKQ/9HcthSHfmrtC22IFSFR5kZUXQ+iYaThN7ntsOjlK7txSUwqpc1s1fP2tP
fsc5IW/KzVnjM4mI7WBmcGZdzO50Y4RDku5od+YXR4lJwPPn3rcns8v5/mN9xlKP
P8X0W+mBEk4dwPIAOFSRU9K+8J9wRa3lnu5+kahyJEf1yw7cxxcKG8cU/y/B/NBv
RlgewVwM9G6/UCvYS5bBoSwdDWrFjiAWXNfhGNRia3LOp6chzplZM9e/nM1xXJrx
tQ2nNR4ZxtAMxMdz802Zz5ZKhMA7468tkW3VQ55OclemlSe0CQIxTs/eFpH6vcl0
Mc15SYa4KgmxwWqR06g1vOSu5OymAqMophfo6cLzuo+2ERwJSXDwEfAswioyTfWX
WNO4wwUjfQ/V2sVV1wD1J7B4rr6yKNdznM5K5kUfzXGcZr82xMjGJTiiBdhmgcvK
SQqvxCDJhff2sGPyrPeaUuLiDF765diZv7aWAw4xDoHXuZIX5YBci4599AQBjbvo
0SP8kSNX9gVwFUNHIUT276mySrc8siEkVk69/1obfNWj/PpTb5urxreZ8fQzkkZo
buGGO0sBL6qaYPzTKu+5j/pPIjBlVjexv4inpbJA6Haa7Rp5rUtoTfQpLo8Je4hU
CIbIxuL4kRKsrTADG96Xsxg3IkogIGCFli5mT7igbbi68HZ6bgg=
=/rnc
-----END PGP SIGNATURE-----

--mvWwdhJHqQXOQ5Pq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
