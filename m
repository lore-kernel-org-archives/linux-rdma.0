From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core v3] qedr: Set immediate data sent via EDPM as is
Date: Wed, 21 Jun 2017 10:03:52 +0300
Message-ID: <20170621070352.GC1248@mtr-leonro.local>
References: <1498027772-8315-1-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XMCwj5IQnwKtuyBG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1498027772-8315-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 21, 2017 at 09:49:32AM +0300, Ram Amrani wrote:
> Enhanced Direct Packet Mode doesn't require flipping of bytes as it
> is sent directly to the transmitting HW and isn't processed by the
> FW that requires specific order.
>
> Fixes: c0965e4fe6fe ("libqedr (qelr) verbs")
>
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
>  providers/qedr/qelr_verbs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>

Thanks, applied.

--XMCwj5IQnwKtuyBG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllKGlgACgkQ5GN7iDZy
WKcrzhAAj5YkhsVeTPpSTjlgv/cOU+mUoYLUCye3QNUkv6/iz1n1f2e5jB9Uw0sn
KESkCBcLBCeK0nmbPtzfxCUQ+djuxoJNj5vx/xzVafem0e/CyWbFjAob7FJbIlhW
hXZlaQnimOQKWKvSjtWmtvQoxAAuGZXBRB67OQLCebj/Io940YxWjTgF3TQdtAtr
jsfdGLMOS4/iMt6+9xKxV6VxxLA9I/QxaqDf45K83jW38TxZDfJCKiI5H4WLXlwF
GC1p8UG1fs168Gha4IDst3+HbvNhByrlUGfUty5Pd3ebSCoZVVdJVDs0586OMIVY
flgbVLEpT49Ospl5AXc4g10TBL0WW/bKd9ppxkkZLRaFO0GvSK2HNnjI2615KPSp
tMmOaGQcOjSJU5P3r6kl8cyWSL6C3HkzOM5ZHu0u8HWDqLVFnK8jgU7gM7kcufCq
EagwyYZpZG7qirXbTUP2epgCDuNW0x+eFn1CnZ21r0CYtoWcrl3MArRA6MT7Qsju
8t7tLR9LSt+s2bUqgZC3FSUUOeCWBVK40zKPzKlY97nyyJj/+06HiNpkThmO0jo1
epiMPn3NpulHeqY7RZY9Sd27xKM4I1vBmqvGvxFryVhyvp5jSgYR+z9HdOV0XFHj
ZVaUU7l5RWKdiTKpupDFrclsgNqW1IzCK+wrKfHqyPrXiImBd/g=
=vx4o
-----END PGP SIGNATURE-----

--XMCwj5IQnwKtuyBG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
