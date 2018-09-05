From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next v1 05/15] net/mlx5: Break encap/decap into two
 separated flow table creation flags
Date: Wed, 5 Sep 2018 21:11:40 +0300
Message-ID: <20180905181140.GV2977@mtr-leonro.mtl.com>
References: <20180828111854.14367-1-leon@kernel.org>
 <20180828111854.14367-6-leon@kernel.org>
 <20180904220242.GA3895@ziepe.ca>
 <20180905051025.GC2977@mtr-leonro.mtl.com>
 <20180905163800.GA21028@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qjSZefE6w0iW6XmQ"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180905163800.GA21028@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--qjSZefE6w0iW6XmQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 05, 2018 at 10:38:00AM -0600, Jason Gunthorpe wrote:
> On Wed, Sep 05, 2018 at 08:10:25AM +0300, Leon Romanovsky wrote:
> > > > -	int en_encap_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN);
> > > > +	int en_encap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_ENCAP);
> > > > +	int en_decap = !!(flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
> > >
> > > Yuk, please don't use !!.
> > >
> > > 	bool en_decap = flags & MLX5_FLOW_TABLE_TUNNEL_EN_DECAP;
> >
> > We need to provide en_encap and en_decap as an input to MLX5_SET(...)
> > which is passed to FW as 0 or 1.
> >
> > Boolean type is declared in C as int and treated as zero for false
> > and any other value for true,
>
> No, that isn't right, the kernel uses C99's _Bool intrinsic type, which
> is guaranteed to only hold 0 or 1 by the compiler.
>
> See types.h:
>
> typedef _Bool                   bool;

Exciting, it took me a while to find C99 standard and relevant 6.3.1.2.
Anyway, this patch didn't change previous functionality, which used "!!"
convention.

Thanks

>
> Jason

--qjSZefE6w0iW6XmQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbkBxbAAoJEORje4g2clinnZQQAIXRMOaw1S9Lz7/az54nwi+B
bc1jNJg/GuzR2JFEIN54N4akcmLCk/F9dvwLuEnGIEmRKzPHtE9yl/NNf8V4G/k/
WffbI0l1Yu0fLw2IopoI5r1OjEESXCegs1iotwGEqRptbn7S0UbMdgAlqZPMAvWv
yZX1LuZfxfiZ7uHHpxQiufzZxwARec4YuDL6Uh0g+cIrHnRefb2hVCoLIBM44Kgh
UiPRV9dBZKInf+bFMqNcXKWgiIGzJ4jmwnQG0pXd01zaEBKpwrTj27ONQ/GvAOMe
4C17TrcGiC+o8MYJPTMFLGhCX7LaiGxHyajcT+0p4gkUeWSqnolA4/czsYk5g1wF
9EaXVLHwpwC9W03Ebz+pTbTBBZrTFW4a2F4WPNSJBnQ95irD1EaqkjumZwf0ddcK
y1TCtzUObxgl18f+ZfZLPv37DSEJ5+grDiRdVLJOX5TXdFJLhBwCp1xX5qxfWzgv
rPWHhct8xZhcDWHZh4vSrXESngQzHRKqd1IMZ/hqtByu7dtWjOZubM0xYe6TlJaw
nWoBU1+z6O6RZgspfMqniReC7nZLyAerlDs2+sGGuMaHgGZFaxqS6bWsQWiybWLT
f1XFIBE4+OYU4EzLZPKTuNs+IOdr5juRSSENsMYMFMBJTR6ZXwq03tLZ4n9/J5JD
tiDzgzXWfRkXU9sGiNP/
=iI/v
-----END PGP SIGNATURE-----

--qjSZefE6w0iW6XmQ--
