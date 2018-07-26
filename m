From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next v2 0/8] Support mlx5 flow steering with RAW data
Date: Thu, 26 Jul 2018 07:35:49 +0300
Message-ID: <20180726043549.GZ3189@mtr-leonro.mtl.com>
References: <20180723122512.20967-1-leon@kernel.org>
 <20180724024236.GA16958@ziepe.ca>
 <20180724055609.GG3189@mtr-leonro.mtl.com>
 <20180724201300.GQ532@ziepe.ca>
 <20180725053703.GK3189@mtr-leonro.mtl.com>
 <20180725143517.GU532@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E0IhBwMLbrMClE+H"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180725143517.GU532@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--E0IhBwMLbrMClE+H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 25, 2018 at 08:35:17AM -0600, Jason Gunthorpe wrote:
> On Wed, Jul 25, 2018 at 08:37:03AM +0300, Leon Romanovsky wrote:
>
> > > Also, I would like to keep the specs consistently formatted according
> > > to clang-format with 'BinPackParameters: true', so I reflowed them as
> > > well.
> >
> > I'm using default VIM clang-format.py without anything in .clang-format.
> > Do you have an extra definitions there, except BinPackParameters?
>
> These days Linux includes a top level .clang-format that does a
> pretty good job.
>
> I have to manually switch BinPackParameters on when working with these
> specs to get the right indenting.. A pain, but maybe there is a better
> way someday..

I don't think that it is feasible to ask from people to change some
defaults only for patches that touch those specs. Any change in this
area will change formatting back.

Jason, bottom line, I won't use BinPackParameters for my patches.

Thanks

>
> Jason

--E0IhBwMLbrMClE+H
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbWU+lAAoJEORje4g2clinn5AQANF+RdK2tPXkA02cN9dxwfet
cjW0mFwK76v9B54Nq8+iRzR/B7YYkruzwzLjYBANOUPGhwewL1wjP9k2Ra1R6W24
bxZcT1dLemMjk59LoFdOCdGVbDnQzqJDA+Zp5jaBBV9iVl1EA7BFss7zJLT2c9Y1
qHZAduxymHJQdtlqxZqFu5+gd6jJuqChBTu5/1KYFtUmbzLfHZ+skwCtemnvm+xM
wewe6ys/K4CFDrR/Vp8DgiGCHU7v5m8kWFHpKOPo1RimAvFv9a/3FwCzonYl7Kwr
QUWjg5DigRm3LW8ozy5QrScyIFWrZ5BZuuFlEdbVyiwEqTaJNj2N8mVbasGszZMs
4iuCMgvMGWsv2kfefEo7T+fjS82lBx0ZOSqW3ehj3Z1aH9cCtM6eExEJQrTRNd63
2fht5Dy0W39i6AkKL5YQWNhT2/Jq2Rzv/+YbMh7bdou9WPEG6DLL09bJUSKBg/tO
tM/+eqwiLjoE0P3U7SvZILkP7C9K6IEHoPkj5lD0mA/d6rlNS1q/coKig7kf1E7+
HxKzSTPzZhF1e/mLLUSmbW1VJSRtzpsUzBT4IKhadctm7AF15Iamq5cX2qIZWB2c
CDr16Db2YuqGkSloo8ZldrU1BfScJWOtyjbXFaxRJMLLYJQbMGG+OYBOl7GHpl9d
gqrtnxbgG7nTnFnxNowV
=XlVw
-----END PGP SIGNATURE-----

--E0IhBwMLbrMClE+H--
