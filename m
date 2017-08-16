From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Wed, 16 Aug 2017 19:26:13 +0300
Message-ID: <20170816162613.GU24282@mtr-leonro.local>
References: <20170815085452.3546-1-leon@kernel.org>
 <20170815085452.3546-8-leon@kernel.org>
 <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <20170816053744.GD24282@mtr-leonro.local>
 <SN1PR0301MB21274177B67EE02B96F14424DE820@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <CANjDDBh=3=5pwYO0_hcZDYVe2H98NMdTT_KrHz7j2Hm74ftDjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="dqsx3Lh6rjXyciUn"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBh=3=5pwYO0_hcZDYVe2H98NMdTT_KrHz7j2Hm74ftDjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--dqsx3Lh6rjXyciUn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 09:33:18PM +0530, Devesh Sharma wrote:
> Hi Leon,
>
> We probably should be okay to retain SWITCH and ROUTER devices, lets say if
> someone wants to port entire linux kernel IB stack on a IB-switch or
> Router. Probably portability was the motivation to add these since the
> birth of kernel IB stack.
>

It was in the happy days of coding of the IBTA spec, in 2017, the
reality is different. I don't want to support people who doesn't
contribute their code back.

Thanks

--dqsx3Lh6rjXyciUn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUciUACgkQ5GN7iDZy
WKeKmRAAzkl9L+O+cW37ZYMhyXtBrtbjlOHUTB1N8e6KoqwwCEymfUU9WqwqkkOq
ZB/v9YGYR3EIftk/SXd6RpLcTVq5PNl0WirkWppzuIMfEqnDVqmITw7Ff1tiiSHE
qeWWoge1m4Yp/5Sri/NVULxEWOOrwlaaNv18iKOEl1VRXKqBCLSg0P8gToe8cYMf
fNzA6PiC3u2rDFNT59cRgfm6ICLkuzGuoJVwXkPS5rY0O1cJvipulyh2R6VtsK6n
91Bc2I+2r2zHV7+oCgZcYwHlVsVM+ePgr598y614JN2VOMoAumIIC03v+pr9+Hzx
hx2M2mAOqiLJ4KivsxfCc6vQ8jIv72C53c7yHAJi+jYpq8yFM/NpPeb/Cud5+1Ow
ERQ3YpBZcQoiIXLDAlK5rBFLHHXaxWmvf4xF9coZxQ+dKg4NuGfuWMFHvI/eZQ8p
ypafXERbPZSn4vmn7Attlca2GJj9MvGr72Mcd4msOU0hNRD4jIikW06AA1Wt1mH9
EXWWL+zXfhgH//jKe/Z/ejdPwXbfKo/a2+eqvnBOsZTkaZ6IaSMKIKK4xgsViUO/
L3UdQoxkGxHniVutcUJvIPl2Cvao2EE75Uw4SlrcsqaxQVVokw6+evcuEkepVnQ1
wvG+VVakZzz9BzSRTrhI5uECTHFg1ukM+8bUHcfgQBDgceUtpsc=
=IYI2
-----END PGP SIGNATURE-----

--dqsx3Lh6rjXyciUn--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
