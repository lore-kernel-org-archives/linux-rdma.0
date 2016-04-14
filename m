From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: Software IB switch/router
Date: Thu, 14 Apr 2016 08:10:38 +0300
Message-ID: <20160414051038.GA10689@leon.nu>
References: <CAANLjFqg7mCp+-4efWjZyUNULfiR0+gJ12-V9UZiLCKD+kLPZw@mail.gmail.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAANLjFqg7mCp+-4efWjZyUNULfiR0+gJ12-V9UZiLCKD+kLPZw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: "users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <users-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 13, 2016 at 05:09:36PM -0600, Robert LeBlanc wrote:
> If I wanted to do something stupid and create a white-box Infiniband
> switch/router, is there some software that does that? Is it even
> possible?

As Kevin pointed below, Mellanox presented IB router [1] at the OFA16.
The product is totally open-source and the code will be posted on
linux-rdma list in the near future.

[1]
https://www.openfabrics.org/images/eventpresos/2016presentations/314IBRouterPrem.pdf

Thanks.


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXDyZOAAoJEORje4g2clincJkP/3oVlSowvdL347X0jJxGoKyV
GidQZAgsUPrGgbao/mbSil8s75afW9fj5lH74ypHS2Ppaqaf3HHAMU0g2yRw5yuT
7oUkqNs4+AV7ADm4519TdbZLMzF2nMTbqlhLpunauj8wLFSR4cIfqsn1E3rH94P/
u0O4Gg1zntsiENplOn0S8Ls+0ensv+nJV0XQGa4I0oVRwS7T9wDeG6uKGGPSNSJk
B32JBa47jP8lLkIq6kWtWk9XAvLOw4mE8DLwZQYHfNyJBGV8IoN5zrw/ZlpN9wI2
0PbJwnvy2FzdtK51sBqZFUH8NiX+ExP+PqXoMmbk/yf5rWffQq9HYOYQUicuo/KJ
TThGYGQLrjNM8xDFwGfbMg7kz68AeChcCx2HKvlwy5HJ9vWT+i/0QByd2mMbuQRL
d3+2wrjrPOaiGO/FQWeV8b/MBMpTHC4RJMGBxpTj4Hz8PJbGXssvEeD5v2MZsJq2
nu1AguD+isRw95afGCuX/zZ0sYImTwCaY1cnkOdTC71Nz8+WhhN/FiKnn5zbM+Qc
OgKTjwMogKWqQQ9Kx2LpJ+CsM89llGvU8ySGoZ9hwPWOQtQSKSXRYtle+3PWGqZk
W9Sv2bUauv1wA0I4U3KV2onzcDDfrhkcnYknQyqV05Fe1Mw6BtHYKtKD2o+UAQUK
IHyyL3nQhwL7Mpawactx
=6wge
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
