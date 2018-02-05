From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next 08/10] rdma: Add QP resource tracking
 information
Date: Mon, 5 Feb 2018 15:22:31 +0200
Message-ID: <20180205132231.GD2567@mtr-leonro.local>
References: <20180131081156.19607-1-leon@kernel.org>
 <20180131081156.19607-9-leon@kernel.org>
 <017501d39b97$f5931360$e0b93a20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KN5l+BnMqAQyZLvT"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <017501d39b97$f5931360$e0b93a20$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'David Ahern' <dsahern@gmail.com>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'netdev' <netdev@vger.kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--KN5l+BnMqAQyZLvT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 01, 2018 at 02:05:08PM -0600, Steve Wise wrote:
> Hey Leon,

<...>

>
> > +static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
> > +{

<...>

> > +
> > +	mnl_attr_for_each_nested(nla_entry, nla_table) {
> > +		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
> > +		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
> > +		uint8_t type, state, path_mig_state = 0;
> > +		uint32_t port = 0, pid = 0;
> > +		char *comm = NULL;

<...>

> > +
> > +		if (rd_check_is_filtered(rd, "pid", pid))
> > +			continue;
>
> Is comm leaked here when ATTR_RES_PID is present?
>
>
> > +
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
> > +			/* discard const from mnl_attr_get_str */
> > +			comm = (char
> > *)mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
>
> And also here if the kernel ever passes up both PID and KERN_NAME (which it
> isn't supposed to).

Yes, you are right, and the bad thing that I prepared everything to call
free() unconditionally by setting comm to be NULL.

Thanks

>
>
> Steve.
>

--KN5l+BnMqAQyZLvT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp4WpcACgkQ5GN7iDZy
WKcdAxAAtcrktqJFIIDWjdQIF6YPcJ7lv9I+egarbSMiylKAJ2v7gHy8io9qm2p/
8ySro1/BeQaICtwQsmm271fDMl3YpHydS6dxfs6VBB8tzBKHKydQ/NOXf6FOBiat
rPK1/kCu4flAMAzvI8FmI3dLsGM67vLqfqBhY01wA1fBkDjOhIabznS4XGu1ctBw
jGyrIJ4dVI5B0NoHCVMXxNpGQBSXEWGdnDget7QrA6LYpolSyZJWF2fYYLPxmGj3
B+CUjRCo2HuT8SDfgtQm0Z6nAacdpJLFq50BU/A8hBL1QK9xL3Eeb4rvhJ8IbvM0
ONMHTWykmLaqESNhf4lU1xNdKlPfDNcKFdHq6nZIAKEhPuYvSNjnYna3xpbXx08P
+/ak1wMz7lG8emuy5kTzGed76VxsMqE8wCEnZzXejbCjGhMXHML/yUat2uY0ykHv
JP2QmxsouI3itGTwom9O5vVaFPW+Mr93x/7Ev2lqIiM6ZWTp5FDwO8jetkDIxkEZ
0PhhwHjRM8VcLr63moJD+eTKgIJAubPdvWxrt3HEO6agbF7/fkR3JoGsuV+wc/93
V8/nfb+uM4u2tnIRjWvftIWT1MQ90BhMFq2Po0b5JLQoCo59qKwSXp3V52Wds0sm
8y5B+fJ9f1R8dZl6fMShd/sKOnwIqQzJxkLoqZCXg2DNstglzX4=
=6rjG
-----END PGP SIGNATURE-----

--KN5l+BnMqAQyZLvT--
