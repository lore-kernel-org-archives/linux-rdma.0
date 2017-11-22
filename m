From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] cxgb4: Add missing null termination of
 hca_table
Date: Wed, 22 Nov 2017 11:43:57 +0200
Message-ID: <20171122094357.GE18825@mtr-leonro.local>
References: <20171121152717.GA18003@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BfpcaheOxHyW4lRg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171121152717.GA18003-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--BfpcaheOxHyW4lRg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 08:27:17AM -0700, Jason Gunthorpe wrote:
> Otherwise there are random crashes during device discovery.
>
> Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  providers/cxgb3/iwch.c | 1 +
>  1 file changed, 1 insertion(+)
>

Thanks, applied

--BfpcaheOxHyW4lRg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloVRtwACgkQ5GN7iDZy
WKfASBAAiD2rndA2xboLDmNX4NX2g3BNCj940mA8dyJ4xYJcDUPFQYa4gsNwM4Ca
wBKRWtRWLUTlVRu2Ly61X0BVE4gQzIBS84DJknv+5hWw3IcoeLmAI5KKjRnwlDSY
DJGOBV+nHUZLb4Kr78jkgeR2+s8h+TRj5Lze+budH6wInvGfyskaelNyJ8hpZYwq
9jKWhHS+O7ZEA/PEp+VaMnNqW3ZMEkzU5TUBjGDAquzB8s2LWCLsllgEzxCdN2bO
DKj0XXJQtl/qY1fxNRp71X3yWtceD3qbIES/QloRdpE37Htu+FiWQm0nOa9Xq2ER
2FmTmck7Hb/Q93X7OHbQY2YK8n2IT1iU137VuuqzGmaoAHlFpVCt7+HigsFl3kNt
hLd2TN18h91t/+7DlWPQGinoWwWekmim8KwZNIZEnwu6TPQFq6zt5Hst00TWYJUB
NZp5GNcZMQowciBRrATZPeCC3ZQ8a6Gaqeu2dN8MmLSCHdympdvL0i0eHOh5wY2R
d9LtKp7yDL8feWfgLInopVnG1NylDgg1C4i8jT8dAjkMHjA92kjmHtSuIChOJ1+M
MCili/9ycVl29EEGXNezLU0B0c7On9RzlGb+uX1rIMkfYgHG8kFWashqw3QL/uRR
NMFWW30MIbVmlXwQ+1mIRrR+GaZwJKpTlRARLQv7zUBzs1k2DPQ=
=GZFm
-----END PGP SIGNATURE-----

--BfpcaheOxHyW4lRg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
