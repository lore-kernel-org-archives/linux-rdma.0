From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2 0/5] Support for generalized use of make C={1,2} via a
 wrapper program
Date: Mon, 18 Dec 2017 21:24:36 +0200
Message-ID: <20171218192436.GF18894@mtr-leonro.local>
References: <cover.630ac8faeeda67bf7a778c158174422042942d08.1513430008.git-series.knut.omang@oracle.com>
 <20171216094745.5e41ac51@xeon-e3>
 <1513476850.31439.108.camel@oracle.com>
 <20171218050043.GA1307@ziepe.ca>
 <1513576817.31581.58.camel@perches.com>
 <20171218174604.GA19056@ziepe.ca>
 <1513619815.2798.2.camel@wdc.com>
 <1513622390.31439.239.camel@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ytoMbUMiTKPMT3hY"
Return-path: <linux-kbuild-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1513622390.31439.239.camel@oracle.com>
Sender: linux-kbuild-owner@vger.kernel.org
To: Knut Omang <knut.omang@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "joe@perches.com" <joe@perches.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "corbet@lwn.net" <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "keescook@chromium.org" <keescook@chromium.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>, "nicolas.palix@imag.fr" <nicolas.palix@imag.fr>, "asmund.ostvold@oracle.com" <asmund.ostvold@oracle.com>, "john.haxby@oracle.com" <john.haxby@oracle.com>, "alexander.levin@verizon.com" <alexander.levin@verizon.com>, "mchehab@kernel.org" <mchehab@kernel.org>, "haakon.bugge@oracle.com" <haakon.bugge@oracle.com>, "michal.lkml@markovi.net" <michal.lkml@markovi.net>
List-Id: linux-rdma@vger.kernel.org


--ytoMbUMiTKPMT3hY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 07:39:50PM +0100, Knut Omang wrote:
> On Mon, 2017-12-18 at 17:56 +0000, Bart Van Assche wrote:
> > On Mon, 2017-12-18 at 10:46 -0700, Jason Gunthorpe wrote:
> > > On Sun, Dec 17, 2017 at 10:00:17PM -0800, Joe Perches wrote:
> > >
> > > > > Today when we run checkers we get so many warnings it is too hard to
> > > > > make any sense of it.
> > > >
> > > > Here is a list of the checkpatch messages for drivers/infiniband
> > > > sorted by type.
> > > >
> > > > Many of these might be corrected by using
> > > >
> > > > $ ./scripts/checkpatch.pl -f --fix-inplace --types=<TYPE> \
> > > >   $(git ls-files drivers/infiniband/)
> > >
> > > How many of these do you think it is worth to fix?
> > >
> > > We do get a steady trickle of changes in this topic every cycle.
> > >
> > > Is it better to just do a big number of them all at once? Do you have
> > > an idea how disruptive this kind of work is to the whole patch flow
> > > eg new patches no longer applying to for-next, backports no longer
> > > applying, merge conflicts?
> >
> > In my opinion patches that only change the coding style and do not change any
> > functionality are annoying. Before posting a patch that fixes a bug the change
> > history (git log -p) has to be cheched to figure out which patch introduced
> > the bug. Patches that only change coding style pollute the change history.
>
> I agree with you - the problem is that style issues should not have existed.
> But when they do it becomes a problem to remove them and a problem to
> keep them - for instance us who try to be compliant by having style helpers
> in our editor, we end up having to manually revert old style mistakes back in
> to avoid making unrelated whitespace changes or similar.

If the checkpatch.pl complains about coding style for the new patch in
newly added code, I'm asking from the author to prepare cleanup patch so
it will be applied before actual patch.

In case, complains are for code which patch are not touching, I'm
submitting it as is.

Thanks

--ytoMbUMiTKPMT3hY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo4FfMACgkQ5GN7iDZy
WKeZbA/+M78g8C0fiVZcdr0khjWthv6ReuG6QjJ8sc81w9zj16tXO2yJa/6A+R+7
VeneSLf7FfsAAOKaJQf85QW7tv9uzSZ5Zdf599xGZcm7RcRAC5BAqjRoVnRYUa0W
s+dFbJzzBlGZqT2WTOIi7qpx5WxLuoZq5dVtnMzM9/ITCM/q446ZR6Bj8fviFrFA
iYf125p+zG6Vdi0qcT91KnsXaWPNMPOsM4iHu+1T2uhiWtuAog/HkN1Xhgzhz1Pi
VxCYSznadcoHIGa4FcoeJOk2Z3FMgsWKhUVgPwJU3toITCSKOupNfY2p4Lacw1eI
WUaRBVGRp3iWleHVkxr6LqxwBGM1XD6Cw4pRibFKjej2QIpCr5Mc/MEJY4U3JdSU
M/OKJ2CQp9oeDE/1VFfDSiRhTGurIQKrG7eglnbYqjQZlw1gqd1WcrPgK8BCNHq0
5Q5R60fTWYx8RxM3JwLI73kbKK22S0D7F7aaE3EN67OVwxD0PViqFNOyII/sBM4N
7vy2M3mWy2epM0afZM2mSNXHfY2YrlgX5t+mOaBXG1NxEtX7S047Ra8XULOhngCC
PzXNPDoSZ0EAIgWb7JDkdUoO4E2p290A4TGFcMJLVfwgmpuWb59aD0TZyizJWfVt
GZSFAp4XU8M818l/GQQfIAZPu7oBNq+muZVchDgBvcuYN2NMxyc=
=mfcT
-----END PGP SIGNATURE-----

--ytoMbUMiTKPMT3hY--
