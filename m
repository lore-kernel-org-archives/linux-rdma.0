From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/4] Add packet pacing support for IB verbs
Date: Wed, 9 Nov 2016 08:40:09 +0200
Message-ID: <20161109064009.GE27883@leon.nu>
References: <1477909297-14491-1-git-send-email-leon@kernel.org>
 <1828884A29C6694DAF28B7E6B8A82373AB0A7B31@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0QFb0wBpEddLcDHQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0A7B31-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0QFb0wBpEddLcDHQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 08, 2016 at 05:49:26PM +0000, Hefty, Sean wrote:
> > When sending from a 10G host to a 1G host, it is easy to overrun the
> > receiver,
> > leading to packet loss and traffic backing off. Similar problems occur
> > when
> > a 10G host sends data to a sub-10G virtual circuit, or a 40G host
> > sending
> > to a 10G host. Packet pacing could control packet injection rate and
> > reduces
> > network congestion to maximize throughput & minimize network latency.
>
> Why isn't the path record data and existing mechanisms sufficient to handle this?
>

Packet pacing allows different combinations of traffic shaping: per-CPU,
per-flow and their combinations with better and steady QoS requirements
without involving subnet management.

Thanks

--0QFb0wBpEddLcDHQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYIsTJAAoJEORje4g2clin7BkP/3fgbrQx1CFr+fS6FPCzzYXl
TN32jGnV2WLwKdShSF8BSO4y7vj/YlNIOH5sphmjl+NNoJmLfTVgMH4t34D34zS/
yad8WbSOSzpFuF5FIGq1mt8TTBmkrR+9sG3i4cWkmHEuqsEfkEjM+A7k1j0c5M2v
V4g3UBZK8F4qfI87K/muncIkD0kMGHjtoKtOrgwFsVLgBX8e1yXKL79UPS4Kg8Ge
g4sxkc0QH+hbHomtPiChW+LIwnookLYs3QNXHcvzjvNZhaE5r2iLPuJPMUIvieSZ
KXyJcuvrFC3/D8Z6w60RFy/OZVlnucSiWFmkkMOtycjK2uKfWRrG7UNXbk6cBGrs
0i79mz0vQVnVUr5qhQGyYteo9/d8JehkdE30trxkF54JWqGpZx/nJQ3KTSVoYjxO
w899BojWzyttF9LZCbZAIynjq7Ybig+VbvJYDSpXXAAQ5tVjIo3hQ9AefMn94BWT
hdLEAa98IZgHyZi2yNI9gslMMjDFhp4WLsEpG6DZ5sRhMaZEdPQKL5bSZKNDsjGO
xXCHpmu/O9BfCrD0QbcuC1Z4i7HF7OZC6Ytkt3kYyhkCCrsE/j2Np7kc6NO5IO53
WoTam3MEogLybIibAJE9RvjOu+N4lo6RDewfMJp+5NLjZOQoTr3mRMEeWhTasKd3
a/ENPd6l+U5+NRBLsp6L
=H3Is
-----END PGP SIGNATURE-----

--0QFb0wBpEddLcDHQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
