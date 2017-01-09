From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 01/15] IB/rxe: Suppress sparse warnings
Date: Mon, 9 Jan 2017 15:13:59 +0200
Message-ID: <20170109131359.GB15685@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353409.3592.15.camel@sandisk.com>
 <20170105125955.GB15685@mtr-leonro.local>
 <1483965701.2923.0.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x0Bbm7aQwrWvLJ2v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483965701.2923.0.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--x0Bbm7aQwrWvLJ2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2017 at 12:42:00PM +0000, Bart Van Assche wrote:
> On Thu, 2017-01-05 at 14:59 +0200, Leon Romanovsky wrote:
> > On Mon, Jan 02, 2017 at 10:39:05AM +0000, Bart Van Assche wrote:
> > > Avoid that sparse complains about using 0 as a pointer. Avoid that
> > > sparse complains about missing function declarations. Avoid that
> > > sparse complains about
> > > endianness.
> > >
> > > Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> > > Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > > Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> > > ---
> >
> > Something wrong with commit message.
>
> Hello Leon,
>
> Are you referring to the formatting or to the contents of the commit
> message?

Both, it looks like the message was cut after last about and three
"avoid that sparse complains about ..." in the row was unpleasant to me.

Both these nitpicks don't worth to respin.

Thanks
>
> Bart.

--x0Bbm7aQwrWvLJ2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhzjJcACgkQ5GN7iDZy
WKfbuxAAzao4vbFUj18sGzlqrUYmzRy1FpkALF0IM2lTksHAJOnUz5HwiBmPYomD
hzkj5/mNm+kKJrSp781w0T6b1MrwGYMDGEN6iveTDaUgVt3sGhvfnSuygVvAshSN
MRbWdYjWfLXiSW8sJTcTXhbv9BTsT01uwDN8M+hlgqovZduH2MRAbJLKL1uNzeUH
RqDwHdKX23nk1j+z1d8qEg2mjruus7O/Z/2atIzB5YDLgqh9oOdTr1vLJ4DjIJXV
Hl88sYCXeoz6eTuCF7JLADmEPnZ7Suxe2YUTcD4nQXrSM1Y/pboJHr8TUmHswXq6
vp1rHzHfM4gSUhnGXNQ+ZuZT12HdGu9KJOcvgkY4lOLBGLn1apboVzb9WFyDWG95
PAxtVnK5ihaWyg1gXMaLkcabiZ4PLNkUN11892Bl+oosVqGD8cmhmu2yrKu4NQt4
nQ4TtJ0YXbnd7eFCn7kbuf3MxptqppVprIj0514GU39lQXFN4iddAmjAtRhnWBME
ZX4nEkD9tIVO6lwKcSZ7vZaxCh/LxHSpQJOLooh6e6jgyvMKTFkkBSpnMpWr6P0g
T2wn1AoKtYviWCcKkGkqyPr8GLcfQsCxZexTx6LWBnJuPkv/KnUkMcHNDR0KXhLS
oizvLu3eXy8snlB82AcOLbVfX60zmzjUecEGbLkQ3XvFZ/GI/pU=
=+kZJ
-----END PGP SIGNATURE-----

--x0Bbm7aQwrWvLJ2v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
