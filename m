From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH RFC iproute2-next 2/2] rdma: print provider resource
 attributes
Date: Wed, 2 May 2018 16:38:52 +0300
Message-ID: <20180502133852.GK20375@mtr-leonro.local>
References: <cover.1525100473.git.swise@opengridcomputing.com>
 <9dc07757af0a98c444c5a40131a7c54922361e03.1525100473.git.swise@opengridcomputing.com>
 <20180430082524.530eff32@xeon-e3>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180430082524.530eff32@xeon-e3>
Sender: netdev-owner@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Steve Wise <swise@opengridcomputing.com>, dsahern@gmail.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 30, 2018 at 08:25:24AM -0700, Stephen Hemminger wrote:
> On Mon, 30 Apr 2018 07:36:18 -0700
> Steve Wise <swise@opengridcomputing.com> wrote:
>
> > +#define nla_type(attr) ((attr)->nla_type & NLA_TYPE_MASK)
> > +
> > +void newline(struct rd *rd)
> > +{
> > +	if (rd->json_output)
> > +		jsonw_end_array(rd->jw);
> > +	else
> > +		pr_out("\n");
> > +}
> > +
> > +void newline_indent(struct rd *rd)
> > +{
> > +	newline(rd);
> > +	if (!rd->json_output)
> > +		pr_out("    ");
> > +}
> > +
> > +static int print_provider_string(struct rd *rd, const char *key_str,
> > +				 const char *val_str)
> > +{
> > +	if (rd->json_output) {
> > +		jsonw_string_field(rd->jw, key_str, val_str);
> > +		return 0;
> > +	} else {
> > +		return pr_out("%s %s ", key_str, val_str);
> > +	}
> > +}
> > +
> > +static int print_provider_s32(struct rd *rd, const char *key_str, int32_t val,
> > +			      enum rdma_nldev_print_type print_type)
> > +{
> > +	if (rd->json_output) {
> > +		jsonw_int_field(rd->jw, key_str, val);
> > +		return 0;
> > +	}
> > +	switch (print_type) {
> > +	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
> > +		return pr_out("%s %d ", key_str, val);
> > +	case RDMA_NLDEV_PRINT_TYPE_HEX:
> > +		return pr_out("%s 0x%x ", key_str, val);
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +}
> > +
>
> This code should get converted to json_print library that handles the
> different output modes; rather than rolling it's own equivalent functionality.

Can it be done after this patch is merged? It will simplify review and
testing because current code is implemented to be in the same format as
the rest of the tool.

Thanks

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlrpv2sACgkQ5GN7iDZy
WKd4VxAApgpFRCwNp79V/KeuRP27vKSuQU0oA94Mp67u3LiFNZdcy5IOfiCSet6M
5B3QfV8dKBm62D/JfmRPPwuclFRByEFdIOwld6P9Stctp6gsi6O2WTmiUiUI7MHi
/8ZDf7tYujw1gDuIXhE1tmPdFNF4l1gaZsRql8Ub5XHyu/qLA5aiDAS+DDb13Zh/
6vdsTtzbTW91RifAEY51VdcPpHSVHmCc44Ry1n0wafbN/Wy++DrCezExuQrHLlUE
mJx+IoRNf7cwxsvyEaiJw6YJAHD8Sm+ka+2loRCoNChE8uaPShDG6y/q7LiY3hlw
4725J9RzmibKGvNZIXsJImgGhTWU8KP3fi2G7ToLkcjdkznJ5ewjR/unlMSm+Efr
l4NQuXbehGw/zQ8Hc4k/oSMMtsZXplvC+tYwzhVNMeYrGG7jUDzQxXZF9vwlOyKo
PYhcyGrLtgrtYz74FYEUTlL+PCt2c6X7xBvFzaNthCpewWd8lwgva5gaYFgIe74j
tQxaeECNzzC/sHJJrUxcXY4y/TQ+b3Os5CjbYvCwKCMH/IMJSxo2RenU6LhFghy3
GZFeISCPdDiid74+ilmrLDLwRzKraC36/DNo8yzA5E2KEl3FfucToDXMJShdMopX
LeZl/zpKOMOdvNqn5DRCLzKFqOjEnATXhy1KQ87G4HM9GKoVn5w=
=+rWn
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
