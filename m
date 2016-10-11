From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: build failure on linus' latest master branch
Date: Tue, 11 Oct 2016 22:36:33 +0300
Message-ID: <20161011193633.GN9282@leon.nu>
References: <01ca01d2230c$b8ade6f0$2a09b4d0$@opengridcomputing.com>
 <20161011120219.GM9282@leon.nu>
 <004701d223cc$0772cbb0$16586310$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="m8RPluiNA7RIyL8J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <004701d223cc$0772cbb0$16586310$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--m8RPluiNA7RIyL8J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 11, 2016 at 09:30:35AM -0500, Steve Wise wrote:
> > > Is there a fix for this?
> >
> > We investigated a lot this failure and it appears on specific and very
> > old GCC 4.4.
> > http://www.spinics.net/lists/linux-rdma/msg39135.html
> > http://marc.info/?t=147614305200001&r=1&w=2
> >
> > And the fix is http://marc.info/?l=linux-netdev&m=147615976207362&w=2
> >
>
> Thanks.  So was it ever merged?

Not yet, I hope that Dave or Doug will forward that patch to Linus
before -rc1 is released.

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--m8RPluiNA7RIyL8J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX/T9BAAoJEORje4g2clinih0P/RZWHN+cs/Jn5YUyXe0TVoJP
BFJgeFi8QG2b/ZPSq35o8ZWBmoW4zB++yqq+GvjLvA57weaDqsiN9D+gtvFHZzBq
iQ8lAOmzhy8O5BdxYVuZWDPLq9qd2BMELqXozQh4C/Rb2OmyBOJEZcOaRckJxeXY
MHm4IjPo5LCn6hYwYYGbaKek5GmTKQ2LbO8HdSqkWwFBF949wFhW3cGnYTura6WQ
MKKobUvENqnJSZVu2z/Nd+n9PKrJfgwMOSwi5+uCDh2vQ82qI1SnGX0bChTP2j7J
c8lDYANPG655fQQ/+RvQbpwX70LedNcCqAYCDn6ivH6BT9iaE6q+02xh9IJz4hYz
/b9jkYuqQ8/TOjoQWVDRQhNCrkMX2aRUm4w4CuCy0y+iLny1JZGk+tM4ZaykRsCT
E9K7IdaY0cgvc37J2D1dJQVDpOcdZWDCCGKzfSczXz5w6XXou2Bbh4tFHzLNuRSp
TSHWxjdQHoI8ka9Y1ybtlcQvE2SAXD0NIZ9DPNKWeZ68Ll94H85fFeBuENGRjcbK
6iimbCdJd0jsTgTmz2RR9grb+PVXmwFWzw4tWjVWpc8Tsfi7UnktzZhB4A4LyJot
7hLoGpagOpM1GK34m+B/p12fhzBynksMOwUpcrjzIKl0pNjfzdel8z8mFixQluDS
pozq4AyGlkSqsnqp7srV
=v98S
-----END PGP SIGNATURE-----

--m8RPluiNA7RIyL8J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
