From: Arseny Maslennikov <ar@cs.msu.ru>
Subject: Re: [PATCH v3 3/3] IB/ipoib: Log sysfs 'dev_id' accesses from
 userspace
Date: Thu, 6 Sep 2018 10:26:56 +0300
Message-ID: <20180906072656.GB13034@cello>
References: <20180903161316.25121-1-ar@cs.msu.ru>
 <20180903161316.25121-4-ar@cs.msu.ru>
 <20180905164727.3108bce6@shemminger-XPS-13-9360>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905164727.3108bce6@shemminger-XPS-13-9360>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-rdma@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 05, 2018 at 04:47:27PM +0100, Stephen Hemminger wrote:
> On Mon,  3 Sep 2018 19:13:16 +0300
> Arseny Maslennikov <ar@cs.msu.ru> wrote:
>=20
> > +	if (ndev->dev_id =3D=3D ndev->dev_port) {
> > +		netdev_info_once(ndev,
> > +			"\"%s\" wants to know my dev_id. "
> > +			"Should it look at dev_port instead?\n",
> > +			current->comm);
> > +		netdev_info_once(ndev,
> > +			"See Documentation/ABI/testing/sysfs-class-net for more info.\n");
> > +	}
>=20
> Single line message is sufficient.
> Also don't break strings in messages.
>=20

OK, will fix in v4.


(Sorry if the following is too off-topic here)
Multi-line messages in separate printk calls can be racy, I get that.
But I'd like to hear some reasoning behind the style decision to not
break a long string into many string literals. (I'll most certainly not
be alone in this, Documentation/process/ does not mention reasons, only
the requirements themselves)

The only drawback I currently see is that breaking a long message into
multiple string literals makes it impossible to git grep the kernel tree
for the whole message text.
However, splitting a long line this way allows us to nicely wrap the
code at 80 columns, which is a readability boon.

Are there any other reasons to avoid that? Except maybe matters of taste. :)

> > +	}
> > +
> > +	ret =3D sprintf(buf, "%#x\n", ndev->dev_id);
> > +
> > +	return ret;
>=20
> Why not?
> 	return sprintf...

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE56JD3UKTLEu/ddrm9dQjyAYL01AFAluQ1rcACgkQ9dQjyAYL
01Dm9A//eAlA4Nm1sg16BY/m3rq3KYzQv6tz3uVBRl8b9FmHVo3i5b/SvcV9Ny1X
sv452vmpcJdRXSwKpOWUkuKa8GIiKW2wv45nDDKGrKPaAcXNk8xexE8G1kYHcHiI
S6VkLcYuDs3NqBfMnkLPt2XwAgFl2SItF4NeID0s+90ISVs1IMHEMXnTiXnbwnmk
xIFElgYblj95/sgLO286NgbCzuf3lyYe9a7EQweXr3l/5+E961ch+uF2lww9tNIz
b+5qjrtSKiVZApaP/05RjPt74r3Csb5c3wvOREkJobI5Me0Tn0cf0bK7om9m8GdJ
iJvihcT1qLUDRBfnCXu6qX2FxFGtztOHsph3OD8y/BOICzYis5+brAABTAO5MLqd
AvrxZ1OQTbNCQHZb2GVvfnAt19KAul43Iwg/LsEnsgNsu06a90bnHAUcnvJpK3az
pThQ3tJ0a6MCb5CF81t+b4kFiqnRdnRpo8CB7dcy0ZNGsqA3aICIqc7cA+Tr109o
zZXJ5dQwCAxN0lo1Ozonoc2PYgKetewpSU9hTA0GBlk2R9zN9t7JOxfHfN09huWc
NRAF7mjF0Nqn1K3/HbSxAr21QtEOkuUWOMgqRTFPFG8hRglEitpxpPKZl7fESHez
JQiukq1Bf/nhG772uXv3Rz0DeuXKu+9LQL1R7xcJ26hSBWaCXXE=
=dR8A
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
