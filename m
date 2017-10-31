From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: 4.13 ib_mthca NULL pointer dereference with OpenSM
Date: Tue, 31 Oct 2017 07:11:04 +0200
Message-ID: <20171031051104.GF16127@mtr-leonro.local>
References: <CALpBJjoMLCqzVe5yKp4wCX-X-sH+=zv1QZfMvOWh2Ukh3c2LFg@mail.gmail.com>
 <20171029191114.GO16127@mtr-leonro.local>
 <CALpBJjoJpgR1QB-gzRJLOjGtjK4T2H4EbG1-R+ndodvznWkgwA@mail.gmail.com>
 <20171030071956.GU16127@mtr-leonro.local>
 <CALpBJjqWrXu3b12EG2-AWKwKs9v2q5pTf11rXSy04C-5dGta6A@mail.gmail.com>
 <20171030230156.GA4081@ziepe.ca>
 <VI1PR0502MB300860F7C004ABFB01079F53D15E0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
 <20171031042435.GB7961@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Sz/4MAOlM1c8JZ8/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171031042435.GB7961-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chris Blake <chrisrblake93-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Sz/4MAOlM1c8JZ8/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 30, 2017 at 10:24:35PM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 31, 2017 at 03:16:42AM +0000, Parav Pandit wrote:
>
> > I am yet to review my below patch with Dan as he did most security
> > dev, but I suspect this might be the cause where rmpp list is not
> > initialized and mad processing is continued when security check
> > fails.
>
> This patch sure looks needed to me, ib_free_recv_mad touches
> rmpp_list, so if it needs initializion then it certainly has to be
> done earlier..

Right, it aligns with my analysis too.

>
> Adding the new return sure makes alot of sense as well..
>
> Hal, Ira, would you check this routine too? kernel oops's are bad..
>
> > diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
> > index f8f53bb..cb91245 100644
> > +++ b/drivers/infiniband/core/mad.c
> > @@ -1974,14 +1974,15 @@ static void ib_mad_complete_recv(struct ib_mad_agent_private *mad_agent_priv,
> >         unsigned long flags;
> >         int ret;
> >
> > +       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
> >         ret = ib_mad_enforce_security(mad_agent_priv,
> >                                       mad_recv_wc->wc->pkey_index);
> >         if (ret) {
> >                 ib_free_recv_mad(mad_recv_wc);
> >                 deref_mad_agent(mad_agent_priv);
> > +               return;
> >         }
> >
> > -       INIT_LIST_HEAD(&mad_recv_wc->rmpp_list);
> >         list_add(&mad_recv_wc->recv_buf.list, &mad_recv_wc->rmpp_list);

--Sz/4MAOlM1c8JZ8/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln4BegACgkQ5GN7iDZy
WKeVTBAAoOdaUUnKX2VjrxMz6FlXMVC1YqlYfInkSET81Q8+FwaxmkKvgiWyAMXn
WkI4cvKGIIgpOfSImWRdMZacfP4vjJK6Q4aOh7a/PRthS/wCn7vXCBzRLmNlMfXq
+C/9FfaztM0R1uayu4gbT5vhLafqfcwnyis/NJre4G736CHUh3eOjZWSqT80MIfW
zFpwldjRMaQfairShFz+Ml03DU0L37LRLKVgK1vw/7c6VMppt9Hfgmh3RUBV8Ybd
/5ZEYP1mpWOG3UpsQSYEWn+o9DEiDLt67Qx15M/kJMCdyI+2CTu8hR+reExKBnkj
/75C1nh8LryT5fIcGdw1XTTg87UCaxbe06cQ1xoPLREu5nqYMkas9Crn/Eva5yHM
qhcx4WL7b5yT6f3mhpXEVVIulYmiNcF7Z3qf+z5z1+EdIYWMY7XRkEi5MsIj6H++
BeZrme+3k5Dhvwu9oTgbYmBTjAnp0/3Dvj9Vge4Q2xaflks13vxJkgjTIpuH2MbW
rQIq+ErGybGuZVUfjwwV5HghNFr1fnhqxcTdAyaJHuy8Q7Y/6eAc/9RmwmP0LuSJ
N6pnJVAQ0wzTLOnX4rUOqVonaf/+aopq/YPVwsmxwGXhxNlFvD+RiSwSv35lCWGn
EFd05pLtz4Nap1juHhBPAKpFH10+pxm/Nu7tTA/W1TlPDMUV9YQ=
=PXTG
-----END PGP SIGNATURE-----

--Sz/4MAOlM1c8JZ8/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
