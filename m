From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: ibacm cleanups
Date: Tue, 18 Oct 2016 19:25:43 +0300
Message-ID: <20161018162543.GG25013@leon.nu>
References: <1476731482-26491-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476731482-26491-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 17, 2016 at 09:11:09PM +0200, Christoph Hellwig wrote:
> This series fixed various sparse issues in ibacm, makes it use
> the common list helpers and removes various cruft.

Thanks, applied
https://github.com/linux-rdma/rdma-core/pull/21

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYBk0HAAoJEORje4g2clinilUQAJJRqkmnQ9DvHqsb8+bAL2wM
p7ef15qId6yn4aWSygX1WtE5UbovEd/nueufbnkOJUQaTRokc4ZToW5dFrH3TCnU
9O/91Cn/xSTBCzZrgKqFvqxqswrk0XJOySsSYi6dl01MSo9MwnhyuBKF05huBz96
Xywgun7mET92NJT3p/tUxlcWsq/s1r3kTMoX3SZ5OzU1qVvSFwY3Gt+jiwPrnF5e
KCIJ/ODDPieT0lPyeGAcR1hvISsau3WEasVvnqFuCvEnlC/fZ9+x3c7bFbvLaQBg
nTbVyyYeBJpWbgh2dtWlmQAnZA4yeiLHpC/OrUc8uPOLVc9KahZIPk22Rn8I9/se
A7hdBhKN1DpDtCuS5OrP9Dn8lsUd49+8Vs3CQdh6sCqgyrImT8RsJDgAVCnWvm4F
rDsZ5gawYfbniv3k7zkKynxWZAxm1a+r537xRCiGOcGvOeN81u5YEt+GdkVb4bAL
ZVJ2T5Qkj4NDK2/Wd8ibIT1IhirNXbVEDL87USS5xbY25N8Gjfz5eP+9kgaiHDpz
x9M6z7GzQqWYrsR1YSHf3V508eHTOeRGaHXv32PiuQQunU+3aaq9PqJYmhbvkkHX
hLJwnpV3vCucpHAi9Zsgbcl0kXXRL3D/8HWhrkqrpivSPcULEaJCGfO3XGylXcrk
vYYbMm7JADicOVVlC0DL
=H2Vp
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
