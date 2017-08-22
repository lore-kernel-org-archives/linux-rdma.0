From: Leon Romanovsky <leon@kernel.org>
Subject: Re: Possible rdma-core header conflict
Date: Tue, 22 Aug 2017 09:47:04 +0300
Message-ID: <20170822064704.GR1724@mtr-leonro.local>
References: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
 <20170821120310.GL1724@mtr-leonro.local>
 <20170821155729.GC4401@obsidianresearch.com>
 <CACTTzNar-qBRxkeWHL-gt4C9A6yTbY+GbkTT6tWKvJcnpK=J_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="magLDk5D4XGaUXcd"
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACTTzNar-qBRxkeWHL-gt4C9A6yTbY+GbkTT6tWKvJcnpK=J_g@mail.gmail.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Yigal Korman <yigal@plexistor.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, mmarek@suse.com, linux-kbuild@vger.kernel.org, dhowells@redhat.com, Linux RDMA Mailing List <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--magLDk5D4XGaUXcd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 22, 2017 at 09:08:56AM +0300, Yigal Korman wrote:
> On Mon, Aug 21, 2017 at 6:57 PM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
> > On Mon, Aug 21, 2017 at 03:03:10PM +0300, Leon Romanovsky wrote:
> >> On Mon, Aug 21, 2017 at 12:24:14PM +0300, Yigal Korman wrote:
> >> > Hi,
> >> > Has anyone noticed that installing rdma-core (or older
> >> > librdmacm-devel) package and then installing kernel headers manually
> >> > (make headers_install) removes the librdmacm headers?
> >> > I actually see it in the make output:
> >> >
> >> > make INSTALL_HDR_PATH=3D/usr headers_install
> >> >   CHK     include/generated/uapi/linux/version.h
> >> >   REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h
> >> >
> >> > Am I doing something wrong?
> >> > Sounds like the kernel rdma headers and librdmacm headers shouldn't
> >> > sit in the same directory...
> >>
> >> It looks like this behavior (removal of header files) was from the beg=
inning of git era.
> >> =E2=9E=9C  linux-rdma git:(rdma-next) =E2=9C=97 git co -b tmp v2.6.34.8
> >> =E2=9E=9C  linux-rdma git:(tmp) =E2=9C=97 cp ~/src/rdma-core/librdmacm=
/rdma_verbs.h /tmp/h/include/rdma/ && make INSTALL_HDR_PATH=3D/tmp/h header=
s_install | grep REMOVE
> >>   REMOVE  rdma_verbs.h
> >
> > The user space files have also been sharing the directory with the
> > kernel files since the start.. Not sure why, but I don't think we can
> > change it now.
> >
> > Maybe someone can patch the kernel to exempt rdma/ from the removal
> > process?
>
> Yeah, that would be a good possible fix for this.
> I had a quick look at the kernel headers install scripts and didn't
> see any mechanism for this, but I might've missed it.

It is in scripts/Makefile.headersinst
The change should be in the ...
 66 # Work out what needs to be removed
 67 oldheaders    :=3D $(patsubst $(installdir)/%,%,$(wildcard $(installdir=
)/*.h))
 68 unwanted      :=3D $(filter-out $(all-files),$(oldheaders))

And we should filter out very specific headers, because it is a good thing
to remove all other files to ensure that older headers are removed.

> I'm adding linux-kbuild mailing list here, maybe someone there can help?
>
> Thanks
>
> >
> > Jason

--magLDk5D4XGaUXcd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmb02cACgkQ5GN7iDZy
WKes/g//TxyqD7yjJSn0xkU8V1Uo8vrmtvlr5OR4nHfGDv2qRn3pDCmPrWt+O+CU
BfTO9e19c29WRGyHxghX/0hN0s4XR/HQVn9xqPsuHkRrkXmMd0HFbPPPs8RysO6z
ppKUIPQZzJ8xmY1qo9iXH3pYXdRsOD8G7X5fvNcLIUXr+++pE9tZV7iv3jKGIO/t
arjLEllUmxu5TQtuFR5kGssP29efTq4ww9Ov0CEubaSdqlEOqDxhSW+SVOnEy9l3
MjGMOrVwFuiYapIJ6oCgMrj+LbDzJVIzkoGqfsYbEq4Ir/Z7IB8UI6Wno/fqnx1h
kxIITyPZ67uqaX4wE1eekMtTowIfk3hAThKRndtOt7eLmN9I6x6uyLbBk+lprn4y
0WECWUaEQmPKxgCBSqADHB7aFH05udraSWyyBb2YX6dnhWeO+jBcGXs4JY7xQXYG
NYVJP+oag1wtWFt+8/A0eSTWQafBLJpm0yc/Y6ZO9IjngG314z5fooORA4E1R2m8
r9SUjY4jZQgQm7/fKHdOj/j40hNrv+UVgIoFBU1TKOX3ueOfstaM19u9EvYcV8pB
RD6JPsqCmnr2X/1ZVnnD1ULaEDh/iDraGJA1Q4c84LYTk5Q3DXPOrCkxurHhOUr+
SGsfbLteY9n/MVvvSoq1G60gmC3J+HkDMi0JBUo0YqeL8OmuXmw=
=sxGZ
-----END PGP SIGNATURE-----

--magLDk5D4XGaUXcd--
