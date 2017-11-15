From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Wed, 15 Nov 2017 07:29:26 +0200
Message-ID: <20171115052926.GN18825@mtr-leonro.local>
References: <20171113144024.26655-1-leon@kernel.org>
 <20171113192432.GL6918@ziepe.ca>
 <20171114080550.GR18825@mtr-leonro.local>
 <CAJ3xEMhfdXz8zQFetjQPfe7HZiCi+N0z6r9XSucuTzQo1--PBg@mail.gmail.com>
 <20171114095605.GU18825@mtr-leonro.local>
 <CAJ3xEMhM0xfNxRU+37oWKq_w=MGtE3sUXy38bARgX5-3G9zhvw@mail.gmail.com>
 <20171114173516.GZ18825@mtr-leonro.local>
 <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="syFoTkIPJOUHjbp1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgJJX0FXMK9Rj=kGmNGkF14tBe03zfwzKHnEEp=cEDVxw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--syFoTkIPJOUHjbp1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 11:05:51PM +0200, Or Gerlitz wrote:
> On Tue, Nov 14, 2017 at 7:35 PM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
> > Can you help me to find an answer to my initial question?
> > Are you using this CMA netlink interface?
> > Do you know anyone who is using this interface?
>
> The rdma netlink code existed way before you got there and it has
> various UAPIs that were/are used by multiple vendors..
>
> AFAIK we had @ Voltaire some management/provisioning SW that used these
> CMA UAPIs and I am not sure where did it go after the V-acquisition

I got my answers, you are not using this CMA netlink part and don't know
anyone real with real code who uses.

Thanks


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--syFoTkIPJOUHjbp1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL0LYACgkQ5GN7iDZy
WKd4JQ//X4zscd2xgBE19FJJvJiKH2KPkvR8NMV2aqtmgePayb87a6/81+OuJfh2
M3eZD70K4a9NebK3fgiV3JlQxLfq0iWFEIkBSFfjY4rynb+TTNw/1eYLp78/PgZ4
Mat1gL6D3ecjMznErJM9p4Cbq9XIXKk8nJBqgQcfYOswu+NF8dIPHUkIU4+04YQG
jigo05Ud0ibKdn6nchzKvj+vvRFbpS2zjRDHHG4tX4F5j/bCvJFt+C8H82AEvB1V
Z4fviC7AKzqEMXrmhFFcVN9MWj24tJZQXgMVtJp5vxPCMhZ40ex66xHHQwWU0wIE
CA+ub/HXX24a3C2UDV1OYs5/HUgS+7YBZpa2R1PsCx6XLdeBTKYlS3zzz6lNai/0
5kjDf+i+N0KS38rFjCfmlaSDu12iNSKbYNhNYaHxjUtQiRJ5urmsj8ge8zR9YJan
dLgprxSTBeojzcV8ki78ZzN0INMCeZUMP02FeP8yqGM0vLBtaLq6fu8qisX+SzNF
Tt+Y3LhdJFnFpiFii9AMk6Rf7+UkNMJ8Rwzs2Acxsqxs8UJMbJ2DHR3giW4H5QoL
k3j4jGWdBFdDTfePSySiIv8JEORRXESBofEK7Sk5kf/XHV80Cbs6QbwRQ1te/Tgx
bfjNQHZ3CRk0agHfCtk7aXBnrLtzSByvTEbAzSDgaBzHPMQXOgU=
=ERb9
-----END PGP SIGNATURE-----

--syFoTkIPJOUHjbp1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
