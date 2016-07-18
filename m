From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] IB/ipoib: Report SG feature regardless of HW UD CSUM
 capability
Date: Mon, 18 Jul 2016 11:09:50 +0300
Message-ID: <20160718080950.GC20674@leon.nu>
References: <1468827648-17275-1-git-send-email-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZwgA9U+XZDXt4+m+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1468827648-17275-1-git-send-email-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--ZwgA9U+XZDXt4+m+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 18, 2016 at 12:40:48AM -0700, Yuval Shaia wrote:
> Decouple SG support from HW ability to do UD checksum.
> This coupling is for historical reasons and removed with 'commit
> ec5f06156423 ("net: Kill link between CSUM and SG features.")'
>=20
> Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v0 -> v1:
> 	* Fix patch title name
> 	* Move settings to ipoib_setup instead of ipoib_set_dev_features

Thanks.

--ZwgA9U+XZDXt4+m+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXjI7OAAoJEORje4g2clinXXQQAIcp0wWWhMbnUEbcUm+Th1wz
SctvvfO+TR8nocKKTdX7Xn3ZYIfFl7qliJUFU4LquzygTecvU9ZDIXbPlwArqmWP
ImAONJb7o6ZEghLCXCTc1bMkIOvQS0+2qSv5+zk37dOyy7LYFH8jeKe3zNZMT3TS
SxaTZ+UQuxXWNY5MPqj9KH+2lQSQmtmd/r3mk42HShIQCi2vD10YexUjmUxnWRzB
O5JzWoJyAVhkZM8eIGB3UNByrFhiN2k+hVCs3rQv+g2IHBRCxfsOdtWsZfUTCP4U
9IC32eGLGvzYgrGe8qK+mnGHKZmAIH5/gz5KJ1J4QtzFWti/P0em8OK5orjsF6YS
w8vZMpc4GmlEN1+J857+/A23AR6L2QLkcJOFu3IW5OmNUQiRxKDrAoez9I921bhh
8OvJtaMIJ1ls3xcxiFT/k83RDQr3jLLb3C99hS11ARooFJKo57ESwIWYqxKOiCjC
am9OlSMvaENCX36XEMKGWGr7Q0wG7XCsus6tkMZ26iCBcWamiw6ojJ03XaxpUVWp
aXr6DXL9qvyl04WkLASQjWMrOFm2QYtljL83p+y8itTpC0T21P1rK59HcozEdoxt
TXqOpFSmRw5QqrSQprulkbGy2o4lCPXigXzMPFJQgCQ98orghtdCwOf+TWLaj7dV
4iLqPlZ+ugx+HUiMEbwg
=4T31
-----END PGP SIGNATURE-----

--ZwgA9U+XZDXt4+m+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
