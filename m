From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next 05/19] rdma: Move resource PD logic to
 separate file
Date: Sun, 27 Jan 2019 10:29:57 +0200
Message-ID: <20190127082957.GB3604@mtr-leonro.mtl.com>
References: <20190122183125.15920-1-leon@kernel.org>
 <20190122183125.15920-6-leon@kernel.org>
 <0ad0319f-194c-d574-e7f7-eca71c7a008a@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s9pXJW6w71JX4l3T"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0ad0319f-194c-d574-e7f7-eca71c7a008a@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--s9pXJW6w71JX4l3T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2019 at 10:19:22AM -0700, David Ahern wrote:
> On 1/22/19 11:31 AM, Leon Romanovsky wrote:
> > +static const
> > +struct filters pd_valid_filters[MAX_NUMBER_OF_FILTERS] = {
> > +	{ .name = "dev", .is_number = false },
> > +	{ .name = "users", .is_number = true },
> > +	{ .name = "pid", .is_number = true },
> > +	{ .name = "ctxn", .is_number = true },
> > +	{ .name = "pdn", .is_number = true },
> > +	{ .name = "ctxn", .is_number = true }
> > +};
>
> These should not be in a header file. Looks like you have done this in
> other patches as well.

This is the outcome of how we build command line with single struct *rd,
see res_show(). While I refactored the code, I saw your comment is coming,
but decided to proceed anyway to make this series a little bit sane.

I'll definitely continue to refactor it, but for now, there is a need to see
valid_filters structure in RES_FUNC() macro.

Thanks

--s9pXJW6w71JX4l3T
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcTWwFAAoJEORje4g2clin7ZMP/jIC35Z1RGmjXUbCcAOq2vh4
9qaGWt3azDRRIASX/6u308c1lLBra1R8kTnlKwW3GC7hmGGH1mt1I56Rq+gnebt4
oxXS+Z7MrzqK0P61tFz+zf5xORPvDm8+8ht81mI/sfW3tFBdBMNBaPMjD+Zwm6VN
bHxNb17ijJz+X0iGlkfXd0Ih6kNPaB1N8jKJHCLmMT+jFCy4rVTSDfGCqi/XTdrD
fvPekuEO0jtcXsGw79HCt/wYcuHHHvXSW+7P40hA1dfeifiJLj/9r91a/ma4rAT8
Hp2/fXmBaJq/rB9DUQQPHVKbZFFKO/53dOtmISv8hDSyUCCO9WIEngO+CzX0GDio
eVpM3ad7XDXbPGDIpNP+DkBa522ISVVf1yUDGo5sbBh3Np9eR4o814IOKUaLNqmK
wdfFon2Xj36t4BMkfd05E5vS8kwHmEMUPEDl4gNrwkvDjSrorHc4G0ni5Fuuu6aF
kD2AX2KexZ/Hc2Ko33s0bvi1s45bDvVXn6SheYD/4pBp7R7+VTExos8yutKvT1Tr
vZuT2rUQTSOxhvTxxi45erDei+Cz95TDBwmdludwESHLA8WYxe3sAfQjOVMKJ5r9
q4Hpf17yfcEhu3Ji7jzTUszIE/AmcAnHdhdLwR/sU7A65oCJ3XFdd+5tr3/lY4CF
eHY1QC0KGzy5BCSh8f9e
=a+vJ
-----END PGP SIGNATURE-----

--s9pXJW6w71JX4l3T--
