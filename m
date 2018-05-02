From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC iproute2-next 2/2] rdma: print provider resource
 attributes
Date: Wed, 2 May 2018 07:32:16 -0700
Message-ID: <20180502073216.0794a08a@xeon-e3>
References: <cover.1525100473.git.swise@opengridcomputing.com>
        <9dc07757af0a98c444c5a40131a7c54922361e03.1525100473.git.swise@opengridcomputing.com>
        <20180430082524.530eff32@xeon-e3>
        <20180502133852.GK20375@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/P/LadYf8aaYJeG.HL3qFR6P"; protocol="application/pgp-signature"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180502133852.GK20375@mtr-leonro.local>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: Steve Wise <swise@opengridcomputing.com>, dsahern@gmail.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

--Sig_/P/LadYf8aaYJeG.HL3qFR6P
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 May 2018 16:38:52 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Mon, Apr 30, 2018 at 08:25:24AM -0700, Stephen Hemminger wrote:
> > On Mon, 30 Apr 2018 07:36:18 -0700
> > Steve Wise <swise@opengridcomputing.com> wrote:
> > =20
> > > +#define nla_type(attr) ((attr)->nla_type & NLA_TYPE_MASK)
> > > +
> > > +void newline(struct rd *rd)
> > > +{
> > > +	if (rd->json_output)
> > > +		jsonw_end_array(rd->jw);
> > > +	else
> > > +		pr_out("\n");
> > > +}
> > > +
> > > +void newline_indent(struct rd *rd)
> > > +{
> > > +	newline(rd);
> > > +	if (!rd->json_output)
> > > +		pr_out("    ");
> > > +}
> > > +
> > > +static int print_provider_string(struct rd *rd, const char *key_str,
> > > +				 const char *val_str)
> > > +{
> > > +	if (rd->json_output) {
> > > +		jsonw_string_field(rd->jw, key_str, val_str);
> > > +		return 0;
> > > +	} else {
> > > +		return pr_out("%s %s ", key_str, val_str);
> > > +	}
> > > +}
> > > +
> > > +static int print_provider_s32(struct rd *rd, const char *key_str, in=
t32_t val,
> > > +			      enum rdma_nldev_print_type print_type)
> > > +{
> > > +	if (rd->json_output) {
> > > +		jsonw_int_field(rd->jw, key_str, val);
> > > +		return 0;
> > > +	}
> > > +	switch (print_type) {
> > > +	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
> > > +		return pr_out("%s %d ", key_str, val);
> > > +	case RDMA_NLDEV_PRINT_TYPE_HEX:
> > > +		return pr_out("%s 0x%x ", key_str, val);
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +}
> > > + =20
> >
> > This code should get converted to json_print library that handles the
> > different output modes; rather than rolling it's own equivalent functio=
nality. =20
>=20
> Can it be done after this patch is merged? It will simplify review and
> testing because current code is implemented to be in the same format as
> the rest of the tool.
>=20
> Thanks

Sure, I was just encouraging future direction.

--Sig_/P/LadYf8aaYJeG.HL3qFR6P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEn2/DRbBb5+dmuDyPgKd/YJXN5H4FAlrpy/EACgkQgKd/YJXN
5H569BAAoNfe9vL2ReTlja9+0eblxrfRjiLu5qbIwOoLFKCz/BAHBcr6TdVdEEHE
tfoIImupc9urV9ShmElFjRI8FGxm6HCHvXamYGGbuR6+NDGQfZbDqrbgon9ZyGID
uu5dWwuVZ/uIVWChbAhPCXbMDtpTTxiv054r9pFlB9SRZ7hAZzhmc4hmyqbHEFzW
k1Jy6p4lAAfWEq7K88kzDt/+ldim/+4p+6eqm+c7oWgSq9m7FXiB6H5SM4NleVgb
rmnV2n0FxJr84du/yfwg4SzIFgLntTBy1KwOuYa16C/mSaZZWaFd2fUYEA+DdMAR
Jp9F8m4IMG+Su1s20IObP5owAzlFMLsPk2+QjF8cSh6JpLrw3eGmj+MUK84vQp6n
LtH9QLFc0CD3WNPUSeS2UNJ2gSQOwsmqjwI5+b690kca0gBEzbcfYr/7zKGQo9kb
SpL8J3NDQ/+wlLjcvEMjF4pK13rpEBFJuubNOpuFnPjrLnIbEKYpQpVe+Kpo3MrD
sxQ90tp3dK8wM/Oqb4+DQdBs8b36SUYkEIFcEX6pu05LAmFNvzzRdrH9DwOktDPr
wzGjAOdoid78u0qiDiutuEEbhhxQn5PJ1Ua7JAHf0WlAZyNO7pAaD74ECsK/5j7P
DXIqI2TOQdq2V/BiByCMJYWw5lsKS7bkLcSkUQXKcArci3TO1fU=
=xUQv
-----END PGP SIGNATURE-----

--Sig_/P/LadYf8aaYJeG.HL3qFR6P--
