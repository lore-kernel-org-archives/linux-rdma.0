From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] rdma_rxe: Fix kernel crash when IPV6 disabled.
Date: Sun, 25 Sep 2016 07:36:48 +0300
Message-ID: <20160925043648.GT4088@leon.nu>
References: <1474730674-4017-1-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pd495SECmvzXpBRb"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474730674-4017-1-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--pd495SECmvzXpBRb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 24, 2016 at 03:24:34PM +0000, Parav Pandit wrote:
> This patch fixes below kernel crash when CONFIG_IPV6 is disabled by
> avoiding ip6 socket initialization.
>
> Additionally it has below minor related cleanup around recv_sockets elements.
>
> 1. Avoid extern for structure which is locally used in file
> 2. Define recv_sockets as static as its used by single file
> 3. Follow reverse deallocation order than allocation order for
> recv_sockets elements

Thanks Parav,
This crash was already fixed upstream.
https://git.kernel.org/cgit/linux/kernel/git/dledford/rdma.git/commit/drivers/infiniband/sw/rxe?id=dfdd6158ca2c8838313470c5ab79243d04da70b2

--pd495SECmvzXpBRb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX51RgAAoJEORje4g2clinlEcQALLkajy4U+b4Y13KSES05m6I
Cu7jyiqDA6oLSm49Dkd/uhmVst4Krd2b8jEqUGExJ4AKem6tpf2QhYmPrQPfSgM/
JtdbRQ1dBVtLV4IVXn1kcfZRESGulImMkSkzcmUlD+XFeoMXzH1xDK11U3hwydhI
DauBMl2KbM76w1oZefR9yVLM13nGys9cO08omcNYZOpgjBHqxO5R/Y4x48giqz1i
Gfww/8368VaA6SroIWK2mgSbRTpbeCvXKKkEbu4CkKBz9beLl/PxeFmLjNwXPrUN
qRpMg1PM8eyXa1hvOcjRRsePlIwzJgk1xFHtKKtD8Qa6/b/kiyMKRnrdEusEDsbT
GCghQL2NiO3K2692vrFnq8+dO5dzqs5DqC3wGEWBYv6SHdthicYWpaLVmf274mvI
xdOMlZNn7bJjYzMvCNwrEvnL0FPdTQgWoEwitYcQ8o1j+H1dUw93myYSV6ADso1A
d2ksDZKWwhnt+unF4jTFJaKFBwD/jEZ1ZQgoMm/OeyQnRmsDnz5MViLnbnnZV6g1
Z8+vGmbtO9KAkc/PH8UEkU4+AmnSCdBHdtaKt20kXwaFL2hmQwcOKlDTBSED7SuW
hIh4pBVzwz+7YlFZl/uhQyPV+V7K6mghhWyL3esBVTKG5kD/Pdyndx/tEG6wM6p7
ErETXMiS8wKxVJ4Sn/6I
=Wtl6
-----END PGP SIGNATURE-----

--pd495SECmvzXpBRb--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
