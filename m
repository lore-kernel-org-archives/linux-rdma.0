From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core]bnxt_re bug fix
Date: Mon, 11 Sep 2017 16:00:34 +0300
Message-ID: <20170911130034.GJ3405@mtr-leonro.local>
References: <1504893687-6101-1-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="k4f25fnPtRuIRUb3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1504893687-6101-1-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--k4f25fnPtRuIRUb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 08, 2017 at 02:01:26PM -0400, Devesh Sharma wrote:
> A quick fix to add new PCI IDs to libbnxt_re
>
> Devesh Sharma (1):
>   bnxt_re:update and sort pci device id table

Thanks, I reworked the commit message and applied.
Please take a look.

>
>  providers/bnxt_re/main.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--k4f25fnPtRuIRUb3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm2iPEACgkQ5GN7iDZy
WKcdUg/+PwSuodisaQjgSlo2KAfJKP3F9XY1aKKG+TYzL32mY/51dKNfsR/yKlDh
KeLzPFDiP20umSAcsAg/o4mSJ7NbUdEhhnOkHLDUxY2Lcc5q06phmHeczjR9maTX
tlGc23SZv+6dJqsApPdcVijQ+R9yRjy/Ve0lW53XUIWi4zpeppOqNO3XntRJxWW4
c7Ih0+RcwXkEL1nn/Rk9+F+Wuc8peD+XzuTMnHDQ5xgbRcohyr67BNVPCxf0VGvY
eZrHl8aIqJWy1OjlelUf/SSo2qeea5Ai+8DARYkq1Ar2Y437o80AX88EYY78KGMR
bjfmBvddiphhWQL4lMbZ3eTl+GmYu++K03z6GyHZq4Fmvt90gPFkimKXooT/j1kR
Dsxkjo8SVGTofNx4k1TPMjSvNicm0U7RXft7A0HDGpN/uohAm34lVV/HKBLBNA42
192MOg8VQUAl3s0YG6Z7qceqk/edGhgbuxjE/WgTHYASAVgqxKFUz0tP9k27GzI2
zB7UgAbmKMrskDftXyauYQL4JMKssv9w68LKmXx0s+x1vtUzxm5kpOchmoiQiZWa
sD21x8CGD4qKrztzL9syivuCNiTm1/LQTbx5FKgNjSQ/LkCngTJ02k20CoNZIaW+
cE6XYKfww72sZ32l/nSXTv6uAwCOwtgJ0iEbN0UwiOnuAkmsq+o=
=weMK
-----END PGP SIGNATURE-----

--k4f25fnPtRuIRUb3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
