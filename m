From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 0/4] RDMA mlx4/mlx5 fixes
Date: Sat, 13 Jan 2018 22:11:18 +0200
Message-ID: <20180113201118.GQ15760@mtr-leonro.local>
References: <20180112055842.23125-1-leon@kernel.org>
 <20180112170228.GD15974@ziepe.ca>
 <20180112183958.GP15760@mtr-leonro.local>
 <20180113191806.GD32353@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GYaKytDE8aa4+VVK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180113191806.GD32353-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--GYaKytDE8aa4+VVK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 13, 2018 at 12:18:06PM -0700, Jason Gunthorpe wrote:
> On Fri, Jan 12, 2018 at 08:39:58PM +0200, Leon Romanovsky wrote:
> > On Fri, Jan 12, 2018 at 10:02:28AM -0700, Jason Gunthorpe wrote:
> > > On Fri, Jan 12, 2018 at 07:58:38AM +0200, Leon Romanovsky wrote:
> > >
> > > So, my take on the for-rc8-ness, based on the commit messages alone:
> > >
> > > > Bodong Wang (1):
> > > >   IB/core: Fix ib_wc structure size to remain in 64 bytes boundary
> > >
> > > No, performance optimization only, and not a regression in this cycle
> > >
> >
> > Sorry, but it is fix to performance regression, and not optimization.
>
> regression across multiple kernel cycles and not a regression in this
> cycle. So the performance optimization needs to be justified to raise
> to 'important'. There is no performance data in the commit message, so
> I can't judge it as OK for for-rc
>
> > > > Parav Pandit (1):
> > > >   RDMA/core: Fix avoid decoding iWarp port as RoCE
> > >
> > > Unknown, commit message is too short. Parav, please explain more why this
> > > this is worthy of 'CC: stable' ?
> >
> > Parav has nothing to do with "CC: stable@", I'm the person who added it.
> >
> > The rationale behind it that it so basic change so it worth to have in
> > stable. Also, it goes as all our countless fixes to those two series:
> > Fixes: 44c58487d51a ("IB/core: Define 'ib' and 'roce' rdma_ah_attr types")
> > Fixes: 7db20ecd1d97 ("IB/core: Change wc.slid from 16 to 32 bits")
>
> Nevertheless, the commit message does not explain to me or Linus why
> this is *important* - it does not talk about what user visible
> consequnce there is to this bug.

I'm a little bit confused here, when I submitted Fixes to -next, you
asked from em to send such patches to -rc and now you are asking to send
Fixes to -next.

It will be better if you and Doug have more clear definition for -rc
than LOC count and gut feelings.

For example, Dave took this series for -rc7/8, because it fixes the code
and don't add new features.
https://www.spinics.net/lists/netdev/msg477875.html

Thanks

>
> Jason

--GYaKytDE8aa4+VVK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpaZ+YACgkQ5GN7iDZy
WKeBnxAAiri5FZiosSWv5wCm58a9TcPhqJoSm1xloHHAoLXKCFuYdSL/WZQaXTaF
evV/7HgQSNCFsAjpHt/BiF2h5qh61PUKyxInfy3KKEWA4xwXz2V/JuT9oZwkuR6t
Bwyq8hOG1klw7Pp6QQcsXFJ520M9gc0RsoboxIkXj018VShARhCMKH8dhAU/TNif
ipCu+OLkDz6rW9XQzHwP4g6fb4ckWI2q7OZWSn6M2K6A74qR+wa2eEp6snI7vGox
0qbOw1nREW9zva1ZSn38yxbrOv+xIxPp7t4k8Wc9D9kfg95MO9pQMoiW0nHuVk/W
yWl1FVfuIPHLwjFxhzxCYNN1uuPZVtaJ5ltBR0MOit4wsqSGag14rTuzJC26K1Ml
gTsxa/CByydtaRKBQqZosIYJAV8lFB498QxYQz1rqgzMeirzRX+fGr+hT3NuMT4D
xZd7LUVKEDdFFob99UlkULKWg2VyXBZ1j1n3dc0unNYAPSuI2u/nLlqU5Yl9eC6e
q1QgGEhGS1aVy0PBVVoDX7Bd5hBlN/g7osAUOuvLeOtlXMW2y/7JTPlBFWaq/mua
lHKXxJ3AqCDfyzUqaSDxN3Kg0n8vPFuPtErb9W0+Ph4gnXCwaYtov0wWQbr8qe9I
RK4e7wwBc1hjNv6EgWtEoVkcdW++jrOUZywOfNurnS+CBzXlkD8=
=lsFh
-----END PGP SIGNATURE-----

--GYaKytDE8aa4+VVK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
