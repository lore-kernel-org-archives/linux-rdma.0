From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_srp: Let compiler ignore the useless debug code
Date: Sun, 5 Mar 2017 10:22:35 +0200
Message-ID: <20170305082235.GK14379@mtr-leonro.local>
References: <20170224084451.42117-1-mnghuan@gmail.com>
 <1487952911.2575.1.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2fjX3cMESU3XgGmZ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487952911.2575.1.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "mnghuan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mnghuan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2fjX3cMESU3XgGmZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2017 at 04:16:31PM +0000, Bart Van Assche wrote:
> On Fri, 2017-02-24 at 16:44 +0800, Minfei Huang wrote:
> > "if (0)" is used to make this block of debug code not be executed. There
> > is a more elegant way to let compiler ignore this code, using
> > "#if 0 .. #endif" instead.
> >
> > Although it may be optimised by some compilers with specified parameter,
> > just for readable.
>
> #if 0 / #endif prevents the compiler from checking the syntax of the code.
> Such code tends to grow syntax errors. So I'm not sure this patch is an
> improvement.

Agree and especially without support of bloat-o-meter, all these talks
about dumb compiler are not informative.

>
> Bart.

--2fjX3cMESU3XgGmZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli7yssACgkQ5GN7iDZy
WKclkg//apbsWJUFFCqgQnOjBkhejY4xjIumHOAQ+F2qVlcBRYBoML4qfmFtQfqN
PT4KcJbGZ1poYT5ajdAHAudcwG5+moHTT/SZSzYxCmJeYBUS859uO2s42qZJBvHJ
bax48tEdKBB9jKi2aTCpgNKS0tSGoS/+RQmF2ZCYmm3M/NrckWCq7dAaMFph5ljI
Y0rF/AAeebE0r1MdFrZiVcUVtzYWl2VclUEWVLQiSINz9N3desZR+JmrOda1htZ8
OydKYsVWcoRF3RdoUVfeg3Qp81dzIGHJ4L+sR0V+lD4EIj+l2AJLqYiKwLnvW2k6
tU4rCtHlSIW/JYOJxSxc2mFXcukZ3uZ9El9NFdT7gp36OSobjA/QTGWkHvPMpF8f
u+rcoymnPhx1tHpJl68aKm46JXzztGEsk0bkW1N5oayUTr62hTwrS83bO27zMaPx
XucG34tjoviXfLrDvoYplmodPql4MPFd9yge/sxibyk1wi598TEMszBtU4NA4hSo
npQ/NjAOaetXQuZSaHruGpLvqYw+ZqR8F2Wk7MJ8ENm/UVg/vtSAal/O0CLBfCqE
HVbs7XHQU3GC1PA+PtixK+TpPsZ4pXIHFfbpJycflUuW1pwCqoTKjIFlesLAXTbf
08QUfghNAXkisfGFZlASRUn68qf1H4h1XrMx8NBOFPyFdyhEeTM=
=ukok
-----END PGP SIGNATURE-----

--2fjX3cMESU3XgGmZ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
