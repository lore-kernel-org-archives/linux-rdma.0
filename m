From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 3/7] RDMA: Annotate create QP callers
Date: Wed, 17 Jan 2018 18:37:45 +0200
Message-ID: <20180117163745.GO13639@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-4-leon@kernel.org>
 <1516203857.3403.255.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="keoAwTxaagou87Dg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1516203857.3403.255.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--keoAwTxaagou87Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 17, 2018 at 10:44:17AM -0500, Doug Ledford wrote:
> On Thu, 2018-01-11 at 17:31 +0200, Leon Romanovsky wrote:
> > --- a/net/smc/smc_ib.c
> > +++ b/net/smc/smc_ib.c
> > @@ -243,6 +243,7 @@ int smc_ib_create_queue_pair(struct smc_link *lnk)
> >                 },
> >                 .sq_sig_type = IB_SIGNAL_REQ_WR,
> >                 .qp_type = IB_QPT_RC,
> > +               .comm = "sec-ib",
>                            ^^^
>                            Typo?  Should it be smc-ib?

Yes, thanks.
After Bart's feedback, I'm working on new version which doesn't require
to annotate QPs.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--keoAwTxaagou87Dg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpfe9kACgkQ5GN7iDZy
WKfz+A/+JZlc1i0iYiad/vjkvzKG3U+8ZMYvit6wBNbkRyrhgc/FcnW9kgck1OEA
lHDHPQlfcarQ+SS0rsrDZPfpbRkg+pB95jpw1numYfR9zbu6q/NyCt4n7ZJTbtD2
Rv9J4+KgAQ/B68NZ6JsV5qh+ohC5MApehZ74kmkAiZyIiKi+N/PAcbQcU1zrMlPc
4I6IuEosLYml/0UnYpgFusDIwB/4glhXkRaKOigPogVApQHMyh6i/WoWEjI2REIO
ZKUKcsr4hOa7lMGSzllXMEXHTkBzKRh2J70LXUkWDgORO2i++KMQKdRKQkH62iRH
nYZc1jeAopbjdQS/XQ5qPhWKnzXyAzmcyAHzGCD/p0yeG1wg+jsQMS2AXehMMhhB
a+8FSv8/JSWWYzIgSVFNsX8PmIeu+KMzikfvjquuV6DIH6wXxAmFfqh4w9Eqhp2K
LL4m5NW8+OQV/zonWIiQDSbgIFwiaEnfsr5crXXb3ebByAWs/nq4GpAxJhBJJPNb
xwsMY2HGuXUWce+r/7eWY8u5roR7p1C9UfAiQEbbiVo82qErfh04XP+doCpapoOy
6ylDNkon4PRr7prB4MX4MYKxRrjNgH4PG9IKzVBrHxth70dMQqp6CH+kZZMp9gdp
Tbp/7dxTBHRJZKVBfrJXLBC4sAr+ucReAlrozp20/JzcV7M10Bk=
=pS9/
-----END PGP SIGNATURE-----

--keoAwTxaagou87Dg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
