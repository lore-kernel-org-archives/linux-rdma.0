From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] Eliminate BEGIN_C_DECLS and END_C_DECLS macros
 in libibverbs and libibumad headers
Date: Tue, 21 Nov 2017 20:15:04 +0200
Message-ID: <20171121181504.GZ18825@mtr-leonro.local>
References: <774ff06e-2274-13e3-00c0-97ccba78b1a6@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KWaDWegkxD8vyHxu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <774ff06e-2274-13e3-00c0-97ccba78b1a6-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--KWaDWegkxD8vyHxu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 20, 2017 at 09:42:50PM -0500, Hal Rosenstock wrote:
>
> to reduce symbol pollution
>
> Replace these macros with open coding
>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibumad/umad.h       | 14 +++++---------
>  libibumad/umad_cm.h    | 14 +++++---------
>  libibumad/umad_sa.h    | 14 +++++---------
>  libibumad/umad_sm.h    | 14 +++++---------
>  libibumad/umad_str.h   | 14 +++++---------
>  libibumad/umad_types.h | 14 +++++---------
>  libibverbs/driver.h    |  8 --------
>  libibverbs/marshall.h  | 14 +++++---------
>  libibverbs/tm_types.h  | 14 +++++---------
>  libibverbs/verbs.h     | 17 +++++++----------
>  10 files changed, 47 insertions(+), 90 deletions(-)
>

Thanks, applied.

--KWaDWegkxD8vyHxu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloUbSgACgkQ5GN7iDZy
WKdhFQ//QvqprtCJHG5PwktOCTB5oufDTfy5O2A3A6a6dNzVDLzbgDhZELevsNlA
p2QygAymk/aRgfJA97l8/NscQXYJtWX+sHQj6bYHmnLdNkTEPahYGzriTPdtJk5c
SZB8rLMqFWbNNOa7p85TcEbdGYinr50u7dlhAHtJp4ptvqDhTL2aBguum/jpSpqU
B8gTsRGR84bnzF4uu7KGkY5IfC0STqs2+hsSimtBGqWLh6S8YO13RuvZ8xuvjHOp
n9VpPEwF4N4THMrujTUZAuPzp0h4+zuib57nK4XcPpsZJ23H2yQKyd6KSvrUCVjY
HdJXXclvu7vh/XafULYr24CFJr/9DXyJfO8cLUq2aN84vJIe1JkXqkLB2wWRi1av
hG3srdtNwvZqO2OmkynO9Fa8iMYb+svN+r4vy9IRq5zQbJHFfN+DtR30mIaox7Xi
2J/ioWkyyZTm9uv8fLOuiTOcbNGBsBil+m10V1C+STDTu72jwmqqocTA5plqFaV2
YFV9sFTM0Whi8uyPPHRN449SPajC0QwcpDRhJJ3VCcK5s3CEFfd+seZL7LS3L0nB
gzDsWJlmxfHwpC5LUtH+SMQ/um7qPNiJOoTJoMmVUodWYvyQp0sd2nfMPKBnLeHf
YdGmxcLBjIWrnPdvqpdYOFr7gvYeAY136VbWmut8vXx9F6xR6iM=
=OeCH
-----END PGP SIGNATURE-----

--KWaDWegkxD8vyHxu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
