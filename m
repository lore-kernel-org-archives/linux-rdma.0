From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 2/4] IB/core: Support rate limit for packet
 pacing
Date: Fri, 2 Dec 2016 16:39:57 +0200
Message-ID: <20161202143957.GF4497@leon.nu>
References: <1480592596-20126-1-git-send-email-leon@kernel.org>
 <1480592596-20126-3-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0BA789@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0BA789-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Rony Efraim <ronye-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 01, 2016 at 07:40:44PM +0000, Hefty, Sean wrote:
> >  enum ib_qp_state {
> > @@ -1151,6 +1152,7 @@ struct ib_qp_attr {
> >  	u8			rnr_retry;
> >  	u8			alt_port_num;
> >  	u8			alt_timeout;
> > +	u32			rate_limit;
> >  };
>
> And I still disagree with this approach, as there is already an existing field in the API that limits rate.

Hi Sean,

We would like to elaborate more on the subject, and we need your help
here. Our cover letter [1] has description why the existing field is
not enough. Can you write a little bit more why you didn't like
the proposed approach to an existing and real problem?

Thanks

[1] https://www.spinics.net/lists/linux-rdma/msg43585.html

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYQYe9AAoJEORje4g2clinELYP/jH8150k3sokEWPQOI0Ra6kK
kD+EfYvRkkxXjsrh9IBNy4NgNbSBUwyVZjmESp3s1FvY8CfrOgZQe45S0/pcIWEw
aSVV/w8CW3Y5a2Fa+WaT/Uo4ZokMZ633KNrgWuL5pZ5WeupVqOX1E66QithidfCW
cjRQ/qPrpXeW3rlExUQfz1kTQoKNJz4jmQh1mAqPN+R1+xqEjU09MR/KEVTWs+1R
apQ6rH5x2Lil5TMXuDnuN6ycw/PoCynAmz5M7DPhwBTk6lT767NfOZBWEnz1T6LY
IZIUT+ByM61oIqzpO5bErWJlsfyyE3aEySSP79Qviqf5i85Fr7pHnr+mUoVKgkfP
nz9ax1qH/HmUdU0osHLHqnqSrysaolJtaTb9dbQjNsZK7rpjZxDm3sdS8gOkNcNE
vCsD6KnrvaRMH5ik0Borwnd1+UwMGyFk2ln41omHULSiX8LnOUwHJTIlx9nl/Vcj
Amm9gX0qrxX5Jz9ywHi/ephXby+LQahXzl/p4mw70tv2Ih4Si4lKSuEsvNaKaCgG
D6csXMe1g3JoMy7jIJhD04QqNLQXcjoU55GjMOyEjZTQP60yS0ua9bOw0J1WwOQv
T64XRQt8MOizjclkqNWx1F4nq2EVoCi8X403XpWY/yB3o/R3Lvd1OSvXs77a9tGE
Hw2/f3mr7uNC1h6tjf3n
=JxwP
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
