From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 01/10] Have check-build confirm that every
 public header is standalone
Date: Sun, 12 Feb 2017 10:48:48 +0200
Message-ID: <20170212084848.GB14015@mtr-leonro.local>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1486677212-3188-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486677212-3188-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2017 at 02:53:23PM -0700, Jason Gunthorpe wrote:
> Public library headers should be includable without requiring other
> headers to be included first. We confirm this by compiling each header
> in a stand alone compilation unit.
>
> Add a few minor missing headers to make the check pass.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  buildlib/check-build     | 55 +++++++++++++++++++++++++++++++++++++++++++++++-
>  librdmacm/ib.h           |  1 +
>  librdmacm/rdma_cma_abi.h |  1 +
>  3 files changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/buildlib/check-build b/buildlib/check-build
> index 45e7cb41c83f39..ddb3383e6a5514 100755
> --- a/buildlib/check-build
> +++ b/buildlib/check-build

It is going to be beast :)

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAligIXAACgkQ5GN7iDZy
WKdTJg/+NepnUP2f8Y2fUucxxbQRexr8bN9wuGkdLwihypX5pek4ZJKLMNG+wUVq
l+ZJxLY5z8mZvbQIcsFnYwS79QrrwTgMpO600AsoOC+Vpud+QsgDd/tJB/4M96y7
28vUMg7icoZy2K+b7qJiZZ2g1iloQVJS4LPci+UAB2EHwA5ZmWfSn/REwqBHgCnf
0NkZHVKejyQFw+2vjyr3tfsw7RdZhp3MFY4uBHohnygjkYdFw9A/OdJvi/pPvFI/
uNc2QppYMUTXNx0ERpIs78o6eOq6e7fbW7LDrv8GwiKtutRiF+RRJjrKdLuf7baw
yMw3ZuyZqpI111ur/waKy2tncdt7AAkklHQRSA1Gk6gzprnRvDzxNSgObcjqM5HK
KK/nZlZtQgCFCUX2y+z2qoz1bPL52LVAmAN5sy9clfEWRBN3GSaTEUIX4Wv/OOmY
naetGe3OqndGmqpYfB2btiVNU4+jBphp9P82ikHQrQCl2jhRnEBBXQdZ01HvkHX5
UMbiziwl66a1a/xVaiUYq/MqJvDzIVA40qGEOWi7AMlIRnEcOnte7AUqOMjgGKuF
eMV10ChtOODTFDkpPcoKOtwKS7ausdbmIjdOmF22IMKF0t6EP4UsA8AaU6vimDAY
MzFpczXLoOPaibl48/kjdjftLvl6veMiRvSEIsl9EKrHMsg8L4Q=
=8Jlf
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
