From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [bug report] IB/mlx5: Respect mlx5_core reserved GIDs
Date: Thu, 6 Jul 2017 15:04:07 +0300
Message-ID: <20170706120407.GA1528@mtr-leonro.local>
References: <20170706093923.4azhres5ymy4vefp@mwanda>
 <20170706103811.GY1528@mtr-leonro.local>
 <20170706111057.vdhnx7agww7j3pcv@mwanda>
 <AM4PR0501MB194030AAB6D5D15585C416AADBD50@AM4PR0501MB1940.eurprd05.prod.outlook.com>
 <20170706114459.tvbzopzpn634r7gv@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eHmdSDY+kY2au76U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170706114459.tvbzopzpn634r7gv@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ilan Tayari <ilant-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 06, 2017 at 02:44:59PM +0300, Dan Carpenter wrote:
> Ah...  You're right, of course.  I've been meaning to fix those false
> positives for a while.
>
> The only problem is that how would I still catch the bug if ->raw wasn't
> the first member...  I need to think about that some more...

I think that you should report all those cases without relation
to first/not first member.

>
> regards,
> dan carpenter
>

--eHmdSDY+kY2au76U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlleJzcACgkQ5GN7iDZy
WKeVdBAAv+wQ4pHvFpA+X5wchyhSOmqe/0zIPFyeyzlWcjNI76DKPBgBBoldGXhc
n9MJgJeDg/6SX0EM2YVoScwpx7R/o2zVEUBbprNfCJ71UTiZLzBmMLSt/oO7ZHQJ
Wx4g9rJp2azWNDo0NUhK0+4QuDlFjU2MkV+pWDbP3DDYC2sKYyaNdFokA/EoH/hu
btBHLCxklInOfxyAcSQ0MAmfSpF3vdPyTsx6JzI5OKjYNoqZKUsAnG+dqW6poDfI
O/72ffsK+ur7N4wPHYV5HxnHofdk1qfnxWJNl8aumvzOi2cDDHzLyKF7v6fNE16U
iB+rDl7slP4ft6U44y2j8BFes6IGe4xZ/pesfyi1nKiCjk5M+LJnGjhcnUrRJOhK
5P3nup850a5WduVAs2XOwBQ9LmWwc6r/HQYpeiFda/HJ7v0SHZRh2t7gT4FLZg2i
NNgRfmL+Ir1Hh2LsISjqYT0vuOHFyxyT+Hn2ThOWGLw/YbqGkvU1Z9k4Z2fgAipc
oFSSkTZr4TikLP1LpbIrPfqZYZr1oFKcIl4Rt7YnK4qNCOFs31KUzdgx1Kh2hnMY
14V7sIJm3GC6cRBMh9oPnXqGBIbqYlljnx1vsw7x8sbU1cDEt5a0wcJZaCF/j3ly
bQfUWPwfj26QZceM2Dgve8XGOkW49wzyN/9pgY5K/I8OYM5pJKs=
=Vk3S
-----END PGP SIGNATURE-----

--eHmdSDY+kY2au76U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
