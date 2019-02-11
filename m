From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH mlx5-next 2/2] net/mlx5: Factor out HCA capabilities
 functions
Date: Mon, 11 Feb 2019 22:02:07 +0200
Message-ID: <20190211200207.GD21447@mtr-leonro.mtl.com>
References: <20190211115608.22677-1-leon@kernel.org>
 <20190211115608.22677-3-leon@kernel.org>
 <20190211195050.GL24706@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190211195050.GL24706@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Moni Shoua <monis@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 11, 2019 at 07:50:55PM +0000, Jason Gunthorpe wrote:
> On Mon, Feb 11, 2019 at 01:56:08PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Combine all HCA capabilities setters under one function
> > and compile out the ODP related function in case kernel
> > was compiled without ODP support.
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> >  .../net/ethernet/mellanox/mlx5/core/main.c    | 47 +++++++++++++------
> >  1 file changed, 33 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > index 6d45518edbdc..d7145ab6105d 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
> > @@ -459,6 +459,7 @@ static int handle_hca_cap_atomic(struct mlx5_core_dev *dev)
> >  	return err;
> >  }
> >
> > +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> >  static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
> >  {
> >  	void *set_hca_cap;
> > @@ -502,6 +503,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev)
> >  	kfree(set_ctx);
> >  	return err;
> >  }
> > +#endif
> >
> >  static int handle_hca_cap(struct mlx5_core_dev *dev)
> >  {
> > @@ -576,6 +578,35 @@ static int handle_hca_cap(struct mlx5_core_dev *dev)
> >  	return err;
> >  }
> >
> > +static int set_hca_cap(struct mlx5_core_dev *dev)
> > +{
> > +	struct pci_dev *pdev = dev->pdev;
> > +	int err;
> > +
> > +	err = handle_hca_cap(dev);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "handle_hca_cap failed\n");
> > +		goto out;
> > +	}
> > +
> > +	err = handle_hca_cap_atomic(dev);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "handle_hca_cap_atomic failed\n");
> > +		goto out;
> > +	}
> > +
> > +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > +	err = handle_hca_cap_odp(dev);
> > +	if (err) {
> > +		dev_err(&pdev->dev, "handle_hca_cap_odp failed\n");
> > +		goto out;
> > +	}
> > +#endif
>
> Adding
>   if (IS_ENABLED..)
>     return 0;
>
> To the top of handle_hca_cap_odp is alot better.

Saeed gave comment that he prefers code to be compiled-out in case
config is not set. In you suggestion, the code will exist and only
with some optimizations enabled it will be thrown.

Thanks

>
> Jason

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJcYdS/AAoJEORje4g2clinKK4P/jGzbYOKejcsAKGwIN8muTKE
SlR0780sPSajhRpSg3RdspZrL+NRpitF8ryaTEjJVolOHrQ5ZZ30mVRI+mBZTfuz
o49uWtvRRhHFetGcHNh2PV2XOTsy+ECyIAgj3jftYL9UjClqoXkUP9WNObozrLVM
b1yqZRVuQ44Qv5AwqysZYdBFHnLJDDqWiFfofxLn443ifRybYN2ZqUMNHbPpylKE
22n9Cv/2n240Vbv0cVTh0K05RBfFRInJF1+zIYlshL6oqjwsTtO8n99aXuTXti8w
OV9Ba4i+18JA9g51XJ1Kcd3pBJmqZd7hOj4PzZ+STKn3eUg1SR2r+aDxDKQ23qQi
geOQNS926C2z+SDhHOmr5vlb/e51YY9/ou5EHXmgsF8F3LiKiBlXkhqFagkwRr7d
1oYFnbRgAnKAmnEvBQcT+M4Xkb3nkzrQbWC7ZKeBdgS5iVxUjzKKceaHh9KGBYy5
v66tBBYBZKlbSVvIp8ASp1bh8zblnoWS0GR1Flwg1Rpns6RPbPPbnpBzhRnuPIFB
XY+zPzMFlE595U7onzWq3woPxXXgYG12U21iXPZjKkYQIZA2hRZZtWO5zr4hz0ik
X09pVDOejDRFNbuyteVq7F81BhSi21dniDzZNDZCX5DGobZrdn4jCbULwvfyG0tz
vLmvNBriXKU7LKAiB4cF
=8CiD
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
