From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: qedr and vmw_pvrdma are not packaged in rdma-core
Date: Thu, 2 Feb 2017 11:39:33 +0200
Message-ID: <20170202093933.GA6005@mtr-leonro.local>
References: <20170202062628.GZ6005@mtr-leonro.local>
 <20170202081311.GA10429@infradead.org>
 <1486027076.4257.30.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zHuqcmpxcmc4O8tc"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486027076.4257.30.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ram Amrani <ram.amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zHuqcmpxcmc4O8tc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 02, 2017 at 10:17:56AM +0100, Benjamin Drung wrote:
> Am Donnerstag, den 02.02.2017, 00:13 -0800 schrieb Christoph Hellwig:
> > On Thu, Feb 02, 2017 at 08:26:28AM +0200, Leon Romanovsky wrote:
> > > Hi Ram and Adit,
> > >
> > > I want to bring to your attention that qedr and vmw_pvrdma drivers
> > > are
> > > missing from various package files available in rdma-core.
> > >
> > > Can you please send the patches which add your drivers to rdma-core
> > > packages (Redhat and Debian)?
> >
> > Even better: can we find a way so that providers (old and new) get
> > added automatically?
>
> debian/ibverbs-providers.install specifies:
> usr/lib/*/libibverbs/lib*-rdmav2.so
>
> So if CMake installs the provider, the package will automatically pick
> it up.

RedHat has different scheme with explicit declaration, from redhat/rdma-cor=
e.spec
 98 Provides: librxe =3D %{version}-%{release}
 99 Obsoletes: librxe < %{version}-%{release}

But it is not installation only.
for example debian/copyright doesn't have information about
providers/vmw_pvrdma.

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
> URL:  http://www.profitbricks.com
>
> Sitz der Gesellschaft: Berlin.
> Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
> Gesch=E4ftsf=FChrer: Andreas Gauger, Achim Weiss.

--zHuqcmpxcmc4O8tc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliS/lUACgkQ5GN7iDZy
WKdhOA/+IGuDaHZh/e1QU+XK9CGw62FrB+o+xu+xCFNZwNx49lIj8IL0RW0b61YD
zoAKOtOqXSYHV0euN6n4kLPmN5gAQ3fL1TXXhPg0wKMudnlZIelmo5mw+Hf1bEZI
MD+8vsbWa0XlDtnY9Vd55toKUNWnmY3d/pNfRO1wCfBQZtXMluE4NZs8ZBb8RONB
vmdo6hb7CaeSIDURoVho8DB39osHcptW8fz+6K6sV1T9dN7hJQpOC+pU8i8bi20G
6H5jI9y/aIpUMr+kXKCgEvGzNpGPr3aKVkh9Fs6nlfwqqTqffAfq37EcN5ykU6eh
m/PvToBw9QloOzWJuCKZW7Bpc4MkkLQvRqX/8aSaF9iX5b94BT4/Aidj2Ti4pyfd
uajCpSpeKmrJEv8erXMLpy7zq1cuLCkID/rkWjm3kFe5+aXAVh98X+ajkzV3WA0K
u0FkIKFiTJzFk78FGyT7BX+88tCG5U6vn0Vz0GPntCXTYbSLwNbrEX6RjX87mr5A
fWTbB+WS65pZcS1sSqnFQiQzWfDOf8ks2BfM7kBwdV1jaBDs91rZ6p1Bd40LjYF5
Qnvt38deiPkS+Q+JQTMK+N23GQ72Vbzx2UghYExkP58d/72Iz9Qa3TYfeZRwIC/u
GfeNBTV0wXZ9yH1j++6Xe5HSspYoYdZ5Taqjk4e5QeaC7QrBHkQ=
=Qhzh
-----END PGP SIGNATURE-----

--zHuqcmpxcmc4O8tc--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
