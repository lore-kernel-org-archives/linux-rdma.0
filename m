From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/9] Introduce per-device completion queue pools
Date: Thu, 9 Nov 2017 20:52:39 +0200
Message-ID: <20171109185239.GL18825@mtr-leonro.local>
References: <20171108095742.25365-1-sagi@grimberg.me>
 <1510245771.2608.6.camel@wdc.com>
 <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZaJdQhC3kSAeqBrs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d5820b65-b428-7cd1-f7f1-7d8d89d21cf5-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZaJdQhC3kSAeqBrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 09, 2017 at 07:22:58PM +0200, Sagi Grimberg wrote:
>
>
> > Additionally, on many setups each
> > RDMA port only runs a single ULP. I think that's another argument to let the
> > ULP allocate CQ pool(s) instead of having one such pool per HCA.
>
> I think that most modern HCAs are exposing device-per-port and will
> probably continue to do so, But yes, mlx4 is dual-ported HCA.

I have patches in my queue for -next cycle which introduce similar
functionality for mlx5 too - one mlx5_ib device with two ports.

Thanks

--ZaJdQhC3kSAeqBrs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloEo/cACgkQ5GN7iDZy
WKdfjg/+ItsgE8HqyMa0oC4fuwafg7WFF6CZS99kSl/fGKH7yJUBnc1d3iAx8904
JeKcD8S8RBntITirH0HHnM8RxodauwUzbLQAcxhTHaAXs5GKU5J+1j/oEJD/bAuN
7bHOrWc2ygT/gwwWh87qa2QsrH+U54+0pXf5MdAC6zh+AI5UJCnTOPipcwFtfFzJ
STJPTIjD6t4CuYY2EOAX3BbO5qAIQAVzaCQGgMecCuPfTFXTBqLmXdWOH7oFz+Sz
TtJ2IPtj3cy4xFpCBNl41J/gWXmVyhmO4EVnnhEcfEqq9c9a3YDr2v/JjX6o3ooH
DUvawhTB9MxmToFpmsiCH8kW6HNWUl9BiLk/nUgyaxI3yR0+mJNDc9J50OgicXGd
/aaLhs/fmtGjH7G/2kJRBdhhdHuRZramUPBUX/rkkE2mKBGeBRx2bnoTadNkBIHK
brQb8EEVJ6Z/892cTOSLjGaL1wlGEPeLzhREf3/giuRl12knu7p2uN7gWycwcF+n
dyz6WRMHzsMToNQ0wVG/2dzqRZ09dfc5S5WJSVae+JZsLB4fFsUaS+mY1VYtnF6a
Tuy7yvE6khhfaRIbeXIpr9zLwOOjO+xOw1SjUoAMATS6WqHZX8X5ZiSfir+o2Viw
LZROU1php58SUfX9T0uKKPNFeHYOEq8vo7Me7Je+iaFvgu2zJn8=
=xmg8
-----END PGP SIGNATURE-----

--ZaJdQhC3kSAeqBrs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
