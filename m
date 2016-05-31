From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: Fix different types mix in ib_device_cap_flags
 structure values
Date: Tue, 31 May 2016 21:54:32 +0300
Message-ID: <20160531185432.GF7477@leon.nu>
References: <1464602994-21226-1-git-send-email-maxg@mellanox.com>
 <08df9022-e575-da0d-c76d-a28185c9db2d@sandisk.com>
 <20160531171306.GA6618@obsidianresearch.com>
 <20160531173033.GC7477@leon.nu>
 <13f16fdf-e1d2-0baa-abe1-6423d2196b72@sandisk.com>
 <20160531181223.GE7477@leon.nu>
 <20160531182100.GC21834@obsidianresearch.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160531182100.GC21834-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 31, 2016 at 12:21:00PM -0600, Jason Gunthorpe wrote:
> On Tue, May 31, 2016 at 09:12:23PM +0300, Leon Romanovsky wrote:
>=20
> > I understand from the description/standards that first enum declares
> > type.
>=20
> No, you quoted the relevant standard:
>=20
> .. but shall be capable of representing the values of all the members
>   of the enumeration. ..
>=20
> Truncation is not allowed.

I'm not convinced that it talks about truncation.

=46rom the same document:
"The expression that defines the value of an enumeration constant shall
be an integer constant expression that has a value representable as an
int."

>=20
> Jason

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXTd3oAAoJEORje4g2clinYssP/iElO1Jpaiom2N7PaSGto5zf
5kqwaFQewU7jAQTN/SBlGLd1Jj2T4niEoCth6+K8W0twYhD6kxaeWpcootLjPQTn
fE9OVILuuGxyVHYq/Z9snkIaVyjcN33COUCamufK6YsP8M5TO9udLeb4QPEwr7Ba
Eg+BX/2XnV5hRKSv+V0ccwsfUzhlrTvkTGGd7C1fudDnoShAsUb9+AXlQCxA+Zgv
GFpyPY1Z3EcsdcSFq/FoziE4NDLSFF6gVayjXgFi3PhyzzcpyYAL5e02CljzKWqH
ehp1x9eQY6JTfqqdhpoWzYzjDH77DZqro5HIVHZX+pNhQuPI+IbuSTHNJb/9o5yN
CLpZ/S2zlEv51j0ctBniDocf7fZvKzZZhOUGR1mZvadeYuFq4BJpLuM8FH2vobXn
AbW05xktqYXpmWSHfifMNB0zuWORHfmLokHPGRIuqrMF4ZGATAwk350Txto5AxEy
noumZ+fBevFndoGCFhiOdpz7RmTx0cRFt4uH7gd8JwrRNZTL4wvLvu2Dq42mLLzO
axw+Kn0otRB7BOS/cP7CKVfrz7KU6AKU802JqT9RNKLDG+ebhHSd/Nw3OMrXOhHO
JH7qmoWv/RkJQKzCssAp3/4zDN84zNNneTw94XfWEqb855btgHZABlvDvce0lDfw
PszDc31fUA4/dd9iW1U5
=gT7B
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
