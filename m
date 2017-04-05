From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Wed, 5 Apr 2017 13:47:01 +0300
Message-ID: <20170405104701.GF20443@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <20170404194750.GC10780@obsidianresearch.com>
 <20170404195720.GA20443@mtr-leonro.local>
 <20170404201408.GA16818@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+mQKy/8VjtYrTtD4"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170404201408.GA16818-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--+mQKy/8VjtYrTtD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 04, 2017 at 02:14:08PM -0600, Jason Gunthorpe wrote:
> On Tue, Apr 04, 2017 at 10:57:20PM +0300, Leon Romanovsky wrote:
> > > It would still have been nicer to isolate the 'default' implementation
> > > so those functions did not touch ipoib_priv, but that is also
> > > something that could be done in a followup..
> >
> > Thanks, Jason
>
> I think before merging it would also be good to see the benchmark
> numbers - we all assume this is making things a lot faster..
>
> Does it now exceed RC performance?

In our tests, prior to submission, It achieved almost line rate (~93-95Gb/sec) with 4 streams.
Erez is supposed to continue his work and optimize it more till full line rate.

Thanks

>
> Jason

--+mQKy/8VjtYrTtD4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljkyyUACgkQ5GN7iDZy
WKd/IQ/+Po9S6Uzw+lkoonyjuZmpTppdnn6Z7XHiRmoRhfQWMJU/syWgliQITdBs
jfVY6DtJ66uqrNNtCZ4GoI8ZkkPbLGAV6F/6jASFnIvYvMuC/XH2myiEokY+Dfml
lHyB7E167Ynbo5DTSk7B4tprj3x/mjfJT270RY/f/oqSCnIkoq/On7Qui3V1IYmK
RXQ6PCtTXWcFnwM/fWSoe1w/1lkE9Gri1D/RkiyXOB8mns67P49yolIQv1ubXIWI
IdtrhO8y6BS18m0a427bHie5k1VnvT7Lh088B/Ji7f60ZtScsd6MZVCIz0zrSys/
Nqoqe/6Jd1yaujPM3zE7fBa7A+l/rDj0V2I9c/+Uk79VU6h3RxyZswocAWPhN7+5
NqHKbreIHBuDJlK2tdSSbCfn6Moqr1pCutcfl+7das6b5X9AZYpBkWrh9Htjvql9
hbOSeFnw4GiEmUMa/pzNP6Fm29MID3eWIeuh5GgbNv5ktOAq4sF/LO7p+UDaKja1
RWHgZQqMPQKBsYSKAyJnlKxU/Ejb/5GumiAipfragNdHIJZPV9pG4g3JM0UaJMl2
fkeYmrX0+d9U/LQFjuV7h+di7zDq4YWDx1Y61p6sWEUkGF+vgi0Il/4LC0cZYWc9
uEPYUQNijmoJGis/NG9GQQnnekhP981bb32400AI3rl+eK0Wozw=
=J0o5
-----END PGP SIGNATURE-----

--+mQKy/8VjtYrTtD4--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
