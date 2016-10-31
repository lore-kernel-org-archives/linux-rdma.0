From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 perftest] Support for Chelsio T6 devices
Date: Tue, 1 Nov 2016 01:11:24 +0200
Message-ID: <20161031231124.GA3617@leon.nu>
References: <20160920141917.AFE07E0BC1@smtp.ogc.us>
 <HE1PR05MB116148CCC01568CAFC9BAAC4B5CD0@HE1PR05MB1161.eurprd05.prod.outlook.com>
 <01db01d22407$38da0930$aa8e1b90$@opengridcomputing.com>
 <00c501d22ecc$aca8dec0$05fa9c40$@opengridcomputing.com>
 <20161027075439.GE3617@leon.nu>
 <010701d2305d$27a9fff0$76fdffd0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AX2clmtSw6ieHBMM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <010701d2305d$27a9fff0$76fdffd0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Gil Rockah' <gilr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Zohar Ben Aharon' <zoharb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AX2clmtSw6ieHBMM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2016 at 09:19:40AM -0500, Steve Wise wrote:
> > > Hey guys,
> > >
> > > Has this patch been integrated yet?  Also, where is the official upstream
> > > perftest git repo now?
> >
> > Hi Steve,
> >
> > Sorry for the late response, due to the holidays our responses are
> > delaying a little bit.
> >
> > We moved perftest repo to be under github's linux-rdma organization [1]
> > and it is now [2].
> >
> > I'll remind to Zohar to take it.
> >
> > [1] https://github.com/linux-rdma/
> > [2] https://github.com/linux-rdma/perftest
>
>
> Thanks for the update!

Hi Steve,
I merged both of your patches
https://patchwork.kernel.org/patch/9341763/
https://patchwork.kernel.org/patch/9219151/
https://github.com/linux-rdma/perftest/pull/1

Sorry for the delay.

>
> Steve.
>
>

--AX2clmtSw6ieHBMM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYF8+cAAoJEORje4g2clinhFcP/Ro2+aY4ll4mytAr6imark2J
ptqjK3kQG+Pv05cfJPX3rAl6LU1D/REi8sKwwV9F/6DNCeX3V44vcrBNCoGjvO6f
SU5AZ8e3ygO+nAxf8+B3XbjE6ptjKokGbS/NazEzsv8PV88asByykPPsefPwNht9
UhqCu6/UxqIWjSC+9Sjg9NOqDBSOiRQ38+AaosucT1Z+dOcKSfXlgzy2pfzyao+D
zT5TbpaxHoJqf8JK0yGO5girj2a0wbwtW9C1IO+P4FG+PuDpAWqq1DSle3IN1jT2
GUqYTYLsXbjc0170S2bvouc9NVA1WBwNw6Ss3y8WHYC0iw90r5R4Yks16glq18YB
4HSijZOHpRBHFlKdbExvJqZy6W8jfOS0OFc+18CgEfU4JtWxi6wjp3vtW0AOGQf6
m7tBu1BpKUd/myi7n8OMQF3TEGHvQKHOK6yd1hciaSOF7631DMQWs06GeVbUC52t
sT5+ztJhIQLbG2ClNQ2dp4f2yuF8PiRRwdsnJMDV+LPIl6WX74KqIbG61DwIxsHc
xagQYJbtmiM6DFoXHrJR5iiKTAoqKEYIVd+bviMRbvBDavKzOYRX1Iw5QsFUFI+o
LNbWnkjePw51I/EoSlxtf+7vLaghU9mw4LJXMmVzXZ7wqS80AFUwdrAKhbkU1uM1
k9UqtBpube/t7vLDqp8E
=0hhq
-----END PGP SIGNATURE-----

--AX2clmtSw6ieHBMM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
