From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: dumping queue state
Date: Thu, 21 Dec 2017 07:15:10 +0200
Message-ID: <20171221051510.GE2942@mtr-leonro.local>
References: <00a701d379aa$b098ee10$11caca30$@opengridcomputing.com>
 <20171220163655.GW2942@mtr-leonro.local>
 <010e01d379b4$0ae59a90$20b0cfb0$@opengridcomputing.com>
 <20171220171146.GX2942@mtr-leonro.local>
 <019d01d379b9$e42cd390$ac867ab0$@opengridcomputing.com>
 <20171220180549.GY2942@mtr-leonro.local>
 <020801d379c4$eaaa0c00$bffe2400$@opengridcomputing.com>
 <20171220200115.GC2942@mtr-leonro.local>
 <029d01d379db$7f2c3a40$7d84aec0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="b9dEYEwnDXkv9lSy"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <029d01d379db$7f2c3a40$7d84aec0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--b9dEYEwnDXkv9lSy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 20, 2017 at 03:42:56PM -0600, Steve Wise wrote:
> > > > Check filters options too, to filters by numbers and display columns.
> > >
> > > [root@stevo1 ~]# /root/stevo/iproute2/rdma/rdma res show qp link
> > cxgb4_0/-
> > > display lqpn,type,state,pid lqpn 1000-1030
> > > DEV/PORT  LQPN       TYPE  STATE  PID
> > > cxgb4_0/- 1027       RC    RTS    0
> > > [root@stevo1 ~]# /root/stevo/iproute2/rdma/rdma res show qp link
> > cxgb4_0/-
> > > display lqpn,type,state,pid lqpn 1000-1033
> > > DEV/PORT  LQPN       TYPE  STATE  PID
> > > cxgb4_0/- 1027       RC    RTS    0
> > > cxgb4_0/- 1033       RC    RTS    0
> > > [root@stevo1 ~]#
> > >
> > > Working!
> >
> > Thanks,
> > It supports various combinations with "," and "-", like
> > 990,1000-1030,1031-1032,1033
>
> While the rdma tool easily allows poking around various resources, it would
> be sort of painful to do a full state dump.  Perhaps a fastpath command like
> 'rdma dumpall' to just dump everything in detail?

It can be an option after we add more objects, right now, I added only
QP and this one object is "full state" for now. To dump all QPs in detailed
format simply run "rdma res show qp -d" and add "-j" to output it in JSON format.

Thanks

>
>
>

--b9dEYEwnDXkv9lSy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo7Q14ACgkQ5GN7iDZy
WKew4BAAz59i9v+HXha2rfO6H5MWjKqG8jl2b5H+arjFnVpcSEX96L617AFJwakI
aSclveMjgDbPbiVdTRWQ9UoO3+hr6Zy+HPR/i36riqsGzJMEVxBXm3nTR3vqUUop
ajRjEeRWMLOheam6wI5dodhFx10+0rex28tmEcjDjdXAtRH7kq4cWcwI3ltkY7ou
wWFXPYA3UdFHxrxHsk8wgyVnaIR2rFWqUFefZw2nRck84sp4pAtFgjn21uUYMopa
KD6/1+gL/Af3kdneMr6jYvUzeYxSjGfJJo8Rtd3b8oMISNQzMo6LQuvnrlp8GGR1
+TC7qWz+Cc6DbTdPF+n1eY0V3eFYuiwUj+B7X5NXVVPRHhbRX+sZ7BZ5jEiox9g2
STlajEEuhwu2zD43xMDA++7Md4cO4dBWs084hN0o41xWLbq0TneDPhAizzorpJUa
cdnc+Mo48tC4nCztXzASgYxqlRL+z9cf/jJMk9uKF0qjc0d7B9XiaIFnNveTpOpV
1Pl4VjaUMyrEoD125hcIcFV0pztGASG2pvCxWLkSw0Z3Ja7+QEariWH1hsnxsRuQ
TTl8ys/MiJLuRG9p4hm6DhFw21dQhd2ussdW4NmhGdA+pUtZAHiH0oiqe4t8g6Is
b7DdhMAdpdjL6b1SF9Otll/H4/dru2tSdA4pYRFroVAGEl5V+PU=
=k+WI
-----END PGP SIGNATURE-----

--b9dEYEwnDXkv9lSy--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
