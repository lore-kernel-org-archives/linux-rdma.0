From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 1/2] IB/rxe: Fix resid update
Date: Tue, 7 Feb 2017 19:02:36 +0200
Message-ID: <20170207170236.GP6005@mtr-leonro.local>
References: <8892e1d1-84ba-489b-d118-3599b9b50b0f@redhat.com>
 <20170207134305.GJ11103@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="trRLnZT3leHHTjS+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170207134305.GJ11103@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, security-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--trRLnZT3leHHTjS+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2017 at 04:43:05PM +0300, Dan Carpenter wrote:
> From: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Update the response's resid field when larger than MTU, instead of only
> updating the local resid variable.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Eyal Itkin <eyal.itkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--trRLnZT3leHHTjS+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliZ/aoACgkQ5GN7iDZy
WKfKYA/8DTl89Che4TXvf8ZApZlJJusxBdIuTLBsYtHLeIsP9WcHOJo0rlvOtylU
24QJ8cZRgBb5PSDLLghWBpegwutOR0l7v+bpPzlKV6EQQ04Gcs3lHztLMCTVK7yU
lN9mNMwRFNwwX1cE+hhbjSAm2O6u2sMB7ilZkabiKMsDyuHSA3t4NKuD4iZKt7fP
xu/y+2boBShUEuPgL8pPmFMfAQ8bhtsXcJafuLPZ9dYHtuhRz3XBWWXLav6eGVT0
N7qS/NPL/KGzxEwNFyRGP5Q509UlGwGI/W+5/OwL6xcsWAeLBHEpBcHWh4w3PyFY
i2OM2jCnU12yeYLp3qmr2vOBGXULp5o9SWlbhShzij2NAI23PW2BLhSkFCbD5IJE
qBl0zSI2dpTE+QWgCewRm5dyicjW+ALDqzb8U0wJFs+uAorVJoTLI0KNelNBvI60
JfgQKwtUvfVG67iw4gaNVHrvLtMZ+TB/BcRGJ45MQek6wF0ukWQkPhx2PLSYWW5Y
NHKXqJSdwcWXjr/g3TPmrQMzlnEZ5nTH8vg0s85R8ieFCt2GrwJUiA5eBJtnWSkq
m8QQ1c7uyn14xRbvhsE1muoQsRnvE+XVWYOnMch7xoklpr5o7fzX8cqQwV7ye7Ej
q3ff15yzH0uz61p7TmZ7AfTad4HNNGvqDnLqlIflHxwOh1jHOD0=
=hLKA
-----END PGP SIGNATURE-----

--trRLnZT3leHHTjS+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
