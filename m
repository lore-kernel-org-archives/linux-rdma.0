From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next 2/2] rdma: Print net device name and index
 for RDMA device
Date: Mon, 26 Mar 2018 18:09:33 +0300
Message-ID: <20180326150933.GI1877@mtr-leonro.local>
References: <20180326082829.21214-1-leon@kernel.org>
 <20180326082829.21214-3-leon@kernel.org>
 <7b6f0370-4749-5327-5701-6567587d2044@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="O8XZ+2Hy8Kj8wLPZ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7b6f0370-4749-5327-5701-6567587d2044@gmail.com>
Sender: netdev-owner@vger.kernel.org
To: David Ahern <dsahern@gmail.com>
Cc: netdev <netdev@vger.kernel.org>, RDMA mailing list <linux-rdma@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--O8XZ+2Hy8Kj8wLPZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 26, 2018 at 08:06:52AM -0600, David Ahern wrote:
> On 3/26/18 2:28 AM, Leon Romanovsky wrote:
> > diff --git a/rdma/include/uapi/rdma/rdma_netlink.h b/rdma/include/uapi/rdma/rdma_netlink.h
> > index 9446a721..45474f13 100644
> > --- a/rdma/include/uapi/rdma/rdma_netlink.h
> > +++ b/rdma/include/uapi/rdma/rdma_netlink.h
> > @@ -388,6 +388,10 @@ enum rdma_nldev_attr {
> >  	RDMA_NLDEV_ATTR_RES_LOCAL_DMA_LKEY,	/* u32 */
> >  	RDMA_NLDEV_ATTR_RES_UNSAFE_GLOBAL_RKEY,	/* u32 */
> >
> > +	/* Netdev information for relevant protocols, like RoCE and iWARP */
> > +	RDMA_NLDEV_ATTR_NDEV_INDEX,		/* u32 */
> > +	RDMA_NLDEV_ATTR_NDEV_NAME,		/* string */
> > +
> >  	RDMA_NLDEV_ATTR_MAX
> >  };
> >  #endif /* _RDMA_NETLINK_H */
>
> Why wasn't the above included in patch 1 as part of the header file update?
>
>

Kernel part is not accepted yet, this is why I separated them.

Thanks

--O8XZ+2Hy8Kj8wLPZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlq5DS0ACgkQ5GN7iDZy
WKfeOQ/9FnyXPjmBq4SLMpksf9DQGPYj5atduQNfdvna7rS7dDB284G1WAqi0p0x
O6spwlJaOz/ydE5+1ZGJEY7CtWVsgUpWj8ckmGWKhHxogjSXRi6aP5pIP1Yj6K1U
XRB8WnrVzCTc4WCmy5/3oyPHUIyUfi15posrnR9s+Y2OTZPfA9zU0/wfhctj+41y
/LLhBRoTjTwNN488xVGTwPtJFkBdx+p/u2jS/90yP1ixMHknxMmKoWWYU+dTshnU
++z+hCxL+hfEzu6/gJYG/ETJxFniG1NMH3cpFUwHWJQP74b9QoZe22L6vBR0/JO+
W+c8pTNxktjezkh9G66tyda2ValUxiyYcl+3RZ/IhYa3IjvLMWTABmXpU1HpiCvY
sZY6T3nX5MxZg9Ai2BkkIM+nMMvEU0SplUu81j8b9Fv9VNmqWnkYhPYSecfo2O+F
xSJn+vDXKxEttzWCfDpopH5itD547DpcRsDGrbBWvravAiry1CDWEm2yPY2j3eJh
ptseY/4XkKnkGl7ADzGYr8M3mkZB6h1vr94HHMT8YBS9x6438HYBM0bB7P4OgIO+
tqX3qIqUJvh2lOezHQnIK8sk+wi9SYMWEv8e2+HFMq0+fzdG1TC60W85bYxuTMBu
e/LSd/vt3PE2my6C9nrANWt4423KI2RSgo13WsXiCM3L3Wwug40=
=y+B1
-----END PGP SIGNATURE-----

--O8XZ+2Hy8Kj8wLPZ--
