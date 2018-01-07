From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v1 3/9] rdma: Add filtering infrastructure
Date: Sun, 7 Jan 2018 09:44:56 +0200
Message-ID: <20180107074455.GA6823@mtr-leonro.local>
References: <20180104070150.15625-1-leon@kernel.org>
 <20180104070150.15625-4-leon@kernel.org>
 <b7ad60c5-a1c5-ff79-113d-d6c57baf1c40@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b7ad60c5-a1c5-ff79-113d-d6c57baf1c40@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 04, 2018 at 08:29:31PM -0700, David Ahern wrote:
> On 1/4/18 12:01 AM, Leon Romanovsky wrote:
> > diff --git a/rdma/utils.c b/rdma/utils.c
> > index af2b374d..446c23da 100644
> > --- a/rdma/utils.c
> > +++ b/rdma/utils.c
> > @@ -114,6 +114,225 @@ static void dev_map_cleanup(struct rd *rd)
> >  	}
> >  }
> >
> > +static int add_filter(struct rd *rd, char *key, char *value,
> > +		      const char * const valid_filters[])
> > +{
> > +	char cset[] = "1234567890,-";
> > +	struct filter_entry *fe;
> > +	bool key_found = false;
> > +	int idx = 0;
> > +	int ret;
> > +
> > +	fe = calloc(1, sizeof(*fe));
> > +	if (!fe)
> > +		return -ENOMEM;
> > +
> > +	while (valid_filters[idx]) {
> > +		if (!strcmpx(key, valid_filters[idx])) {
> > +			key_found = true;
> > +			break;
> > +		}
> > +		idx++;
> > +	}
> > +	if (!key_found) {
> > +		pr_err("Unsupported filter option: %s\n", key);
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	/*
> > +	 * Check the filter validity, not optimal, but works
> > +	 *
> > +	 * Actually, there are three types of filters
> > +	 *  numeric - for example PID or QPN
> > +	 *  string  - for example states, currently only "display"
> > +	 *            is from this type
> > +	 *  link    - user requested to filter on specific link
> > +	 *            e.g. mlx5_1/1, mlx5_1/-, mlx5_1 ...
> > +	 */
> > +	if (strcmpx(key, "link") && strcmpx(key, "display") &&
> > +	    strspn(value, cset) != strlen(value)) {
> > +		pr_err("%s filter accepts \"%s\" characters only\n", key, cset);
> > +		ret = -EINVAL;
> > +		goto err;
> > +	}
> > +
> > +	fe->key = strdup(key);
> > +	fe->value = strdup(value);
> > +
>
> Missed this the other day. 2 more strdup's that should be checked.

Thanks, David,

I'll fix and send new version once the RDMA kernel part will be accepted.

Thanks

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpRz/cACgkQ5GN7iDZy
WKfzzhAArcF6nwXvHUb6s0ACa/AEyTDUZ2xP8H+2m11kMG8dB72/0niGfeY6QnhE
h1GtM0HhvvQRRAXmcblHKydkK6biDKnemxAkQ6vcawqhdT+QMKwxgOdsejBCjh4x
zNbaqxenADimmiS3kEo7ypnYJJcYQhUox+7QIPVMFrDbtzuE9Gk7Wwpl2kgFzWEJ
y95VQnPbHtDyItdVUfPSoDl/6tpeiXRy+IzAxBnC9JQMhdeMgOLDBNsSDpyczoiU
fwKVxaUzRRmFf84pekwvfeIO2Fyq9TEHw25+LmPwocsJmubR2BzUYU/bC1njT8eJ
x1R3ewZH0pxA2xViF3Bm7hi4aMZqg+JmXeZcgQAArzlfP/VNWkW2r+5sJsybGqu0
LvD6PJdfKvEu30eGzhri3TBkjxIRiezuLMqUwoBJQHRkex2zHq4E2rj/Kch5IP/i
visnz0OEyN9UiOq8VTvvkocnjgNm72r87OBYnw836zoT5w+j+09ou/pKqyzHazeU
1qlykwXRj3CH9agr+7zGqpweAuO0VsWVyHI5ErUrPB7Q+M0HxfMzonN9qkxlaUvf
j/fN6FtL4QNBy57ht7K1rbM2HJZkjNFcOX7k3xcHNkgryqoHQmwKhrIsRH+9xZfc
2qs83w/28KzsL8gUsrpXEz+mo+GTb3YSnsSOOiOCPLdeIYK8Dzg=
=f7Ok
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
