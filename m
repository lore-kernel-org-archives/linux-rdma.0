From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v2 00/19] Export object IDs to users
Date: Sun, 24 Feb 2019 19:23:18 +0200
Message-ID: <20190224172318.GE11231@mtr-leonro.mtl.com>
References: <20190223091528.8509-1-leon@kernel.org>
 <c5995a79-e0d6-c88d-44d4-52d5477f2662@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c5995a79-e0d6-c88d-44d4-52d5477f2662@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Steve Wise <swise@opengridcomputing.com>
List-Id: linux-rdma@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 24, 2019 at 10:16:37AM -0500, David Ahern wrote:
> On 2/23/19 4:15 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Changelog:
> > v1->v2:
> >  * Fixed commit messages
> >  * Added Steve's ROB
> > v0->v1:
> >  * Rebased to latest iproute2-next
> >  * Added latest rdma_netlink.h and updated commit message to point
> >    to kernel SHA commit.
> >
> > This series adds ability to present and query all known to rdmatool
> > object by their respective, unique IDs (e.g. pdn. mrn, cqn e.t.c).
> > All objects which have "parent" object has this information too.
> >
>
> applied to iproute2-next. Thanks, Leon.

Thanks, a lot.

>
>

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcctMGAAoJEORje4g2clink3IP/2lxBzTms3xEL6/PP8TP9285
yds+GIkeCcGI1FF6gDrQNWWhbF895+z5E65f3ZargMEm7ub514XzraCgJLAyUjBn
2VQhn+h/fCsGiS6pEtj22sKTut0Z/3XbvXBg7WBY7w2aeGo1E+5vOVby18SY73ZR
6wve+2OSRKifCmj1cVB8WO2XU52jhN/WVKzdjfqCr4EIiNIvzp5pNhnCXq5/lO9M
99U09Y1Bj6pbsaAe4mK9PnZlKVpmrx0hvEozu8c8b6GumArdedcMf/zZNjXc3Ymn
6zQYUkp9T35KCzjFd/0PJCNE69OcJbVtJsq0v4vhdbQm7Ec71s0pzfmNy7CT+jVz
qAWy8DNaDa9VbSFn/v9FqSU/MkfRj9Me6ompjdGyp/LRn2WxXYSlSAwyWCJQDo7e
wIdXAaV0CZbHV2wmJnPxvOJFt9Dtz5/NPXazpt4pGjxtebzcvLJWwjc9ogZmtUjd
VwrKQ+Yg/hGvw1td/cmjgUhIyCO/upeqxDhEfKKxzHi9fBvgSS4ndYYiZ6PP4Rvj
1OaWIiN9P+yeC5z+Rr+sjt8f8Wcin8OtRtFIFsoPTEZ21G6L0JjJpuDMSAs2cdXT
pfqdTQxTVdiNevn0Ht2E53RLrzzSW5bzb1oO4eHJE3UBFKz1kHlWki+97/EiAQaI
TR0RLffrbhnzQjIiA2y+
=8miz
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
