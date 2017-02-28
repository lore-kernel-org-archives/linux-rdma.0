From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH perftest] Avoid configuring the MRs with 1's
Date: Tue, 28 Feb 2017 22:00:40 +0200
Message-ID: <20170228200040.GD2754@mtr-leonro.local>
References: <1488111691-23620-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7qSK/uQB79J36Y4o"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1488111691-23620-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--7qSK/uQB79J36Y4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 26, 2017 at 02:21:31PM +0200, Ram Amrani wrote:
> Avoid setting the value '1' in the MR. If this happens in a write latency
> test then the server will send two consecutive packets, regardless of the
> client's state. This can cause the application to hang - If the client
> reaches the busy-wait loop after the second write then it'll keep waiting
> for the value of the first write forever.
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  src/perftest_resources.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/src/perftest_resources.c b/src/perftest_resources.c
> index afae5f2..dc768c4 100755
> --- a/src/perftest_resources.c
> +++ b/src/perftest_resources.c
> @@ -1252,7 +1252,11 @@ int create_single_mr(struct pingpong_context *ctx, struct perftest_parameters *u
>  	/* Initialize buffer with random numbers */
>  	srand(time(NULL));
>  	for (i = 0; i < ctx->buff_size; i++) {
> -		((char*)ctx->buf[qp_index])[i] = (char)rand();
> +		/* prevent the value 1 from being written into the buffer so in,
> +		 * e.g., write latency test, the server won't send two packets
> +		 * consecutively without receiving a packet from the client first.
> +		 */
> +		((char*)ctx->buf[qp_index])[i] = 2 + ((char)rand() % 255);
>  	}
>
>  	return 0;

Zohar?

> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--7qSK/uQB79J36Y4o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli11ugACgkQ5GN7iDZy
WKeMGhAAwe127mt2lo6GFCjZBNBJRvZesRUxhg0CLAkaFTRuG+MrnKMfHmSvDUZM
dbFV2PgvlkgPwipJfVHLUuSLNAWyjLlCv+IdyuVL9ir5gssefOIpSkuRcr4z30BL
zsW6N0kmV3t/A0ApJE5y3xTV8FaP3MrLysJQZVicgUqz9dvhmVrSOGLS9SrTnvOK
guK0HVK/sChFLdztRBNsJMAEXOVGV1UnIwuB6CzexYfKwwyWCzVhVyvsNO5a4HEO
v2ZFFIYz7/YdQxSIrzG0wGBMmY8892yNeuHk2yP0aMH895O7w5DM7MH40alWiU9L
L1mWDS7rWUG1XrOOHJsKAEks7LrS1iDzpXpw7TXWdgREnI/f4PQ8xGpURDOXDY0R
fIVx7iTvZIEsAMrOQqf8K2tyoQFn5ToNebRFXMlUzcFpn7PoSYTaQhF1YXjpg6no
PGd49oPoN/8Jx7g3T+Cf65rffGhA5JTee2/xcbzTz+m1NTVg9Wp66CaYloUfVNNl
v/JmVyGRwHs0nROYvnV7B4ADG1Q/go2oOzDksTYLEGPocq28IwugXMPdFyS+6Zhr
HQR37hrljEuoL7O5BJ2bAu76wgLtyUXwF4ybk83JI+THyvqzSTOW9ZnOYbwtfVM9
7UKF57QhzYhXFxI6FaQlfZXMrzW5X6bM/DGEuwuxDGpcXJS5b+4=
=E7oH
-----END PGP SIGNATURE-----

--7qSK/uQB79J36Y4o--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
