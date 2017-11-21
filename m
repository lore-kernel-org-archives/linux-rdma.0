From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Tue, 21 Nov 2017 07:53:08 +0200
Message-ID: <20171121055308.GN18825@mtr-leonro.local>
References: <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local>
 <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
 <20171114173516.GZ18825@mtr-leonro.local>
 <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw@mail.gmail.com>
 <20171115052926.GN18825@mtr-leonro.local>
 <CAJ3xEMjrTvY+hq=1Q3tmPk_QiZtpO8dLMmCtrPjJgbtOeiU=6Q@mail.gmail.com>
 <CAJ3xEMjst4EaFYfUVwqiOzsh5pVPj85joPYsGsap8p6tQYUwew@mail.gmail.com>
 <20171120194152.GN29075@ziepe.ca>
 <CAJ3xEMhKEXB3-RJFyEh2dE8dr6OOpQPZ2rJ14MoKQ-2sB0GTXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Xr0h8fiiTMtsWkNx"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhKEXB3-RJFyEh2dE8dr6OOpQPZ2rJ14MoKQ-2sB0GTXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Xr0h8fiiTMtsWkNx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 12:14:01AM +0200, Or Gerlitz wrote:
> On Mon, Nov 20, 2017 at 9:41 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>
> > Well, I would like to know the issues as well, as I've already said I
> > think they should be described in the commit message.
>
> > But also, at the RFC stage the onus is on other people, particularly
> > people that want to keep the feature, to explain where it is being
> > used and why..
>
> we did it to allow user space track rdma-cm connections through the rdma
> subsystem netlink infra-structure, e.g one can come up with netstat like
> reporting of rdma listeners and connections, this is it!

And after 7 years did anyone use it? The answer is no and it is because
this interface was added without any real user space application which
was supposed to use it.

>
> > We need to decide if we drop the RFC and fix the implementation, apply
> > the the RFC, or add a deprecation printk warning, or something..
>
> right. To my opinion, if there are issues in the implementation, lets fix them,
> I don't see why remove this implementation and replace it with a new one
> that does the same thing.

Just looking at the code without deep dive.

1. Lack of extensibility, in case of desire to add new field to
rdma_cm_id_stats, you will need to throw away this struct and add new
netlink attribute.
2. Device list lock for data retrieval - user can prevent device from
recovery (maybe).
3. It doesn't return device ID !!!!!
4. Completely unscalable by sending message per-struct and not using
netlink nested tables.
5. No check of device identifiers -> returns everything.
4. There is no nlmsg_end at the end of message.

Are you going to fix it?

>
> > Please try to be productive here and concentrate on adding information
> > and not nit-picking the process! We all know removing a uapi is a big
> > deal.
>
> Re usage I provided what I know.

It is wishful thinking, I'm interested in real users and real applications.
Do you know about such?

Thanks

--Xr0h8fiiTMtsWkNx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloTv0QACgkQ5GN7iDZy
WKf//Q//bS49teIfFHJ74u+zLrb+hiqPURpj+SJVJ1vQMfN3FrPf9ZxozDHQFk1p
zHl1DGZmiVh/RfzLxuTxJ4IT3Zzx7H20f7P0jlUmCn7YmDInOcnVRHJICzbEs7o6
F9YuCsNqm25fr92GcJzoNgpHyjFDZKJadSlVhDhdCWoT2t4yqT/kh0/zwVBkHlTr
plQnD2806ReSGQOzH61C7y+w0OHlVZenWo9j+ZOswsO0D4q+hubuzgizoXImdwia
argv1TzgKnnsFAuf/u/iB+cElXg96BjgrW05wnokHV3mYNuZ6HuULS7nc9bz9cN6
dZ+cQiVTUtDZu2fTgGuUbg2JrhKabtqt+EttxPPKsnj/7pUOWPMJpbiWbUH4moqd
H6coYnv30Z5Y+xS+Lk21PTkvukEcz0xRA2x/8pmMcPcSNo3xfFcTcbTjHi064a0e
VrS1yfxSABU+BAc05nqr+cQ5fnD6PJe/Gn4gCavCr/yQRxoISdhKckmyhf1RMOx/
Dl4O8G924C8zHc1dMeHTsyKP73dssH7uRwUrXnvs2gKC+bR3AN554zJRCnBjroQ3
Pm5SyHRY8LGFdYb0WJeFUMxyamPgjOtjsilk89e+x76EUPVRPjVdb4h2MsUbppzO
b5nfiVIT3qsCZqW5fYgnL8q2GWe1Jgw03liri+2mLaGh5V1dN7E=
=+N3G
-----END PGP SIGNATURE-----

--Xr0h8fiiTMtsWkNx--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
