From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] IB/rdmavt: restore IRQs on error path in rvt_create_ah()
Date: Thu, 27 Apr 2017 12:25:56 +0300
Message-ID: <20170427092556.GF14088@mtr-leonro.local>
References: <20170427091420.j7kl5tmzqnyami4s@mwanda>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="1lE8Wy7Exphh2Vpg"
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170427091420.j7kl5tmzqnyami4s@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Dennis Dalessandro <dennis.dalessandro@intel.com>, Kamal Heib <kamalh@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--1lE8Wy7Exphh2Vpg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 27, 2017 at 12:14:20PM +0300, Dan Carpenter wrote:
> We need to call spin_unlock_irqrestore() instead of vanilla
> spin_unlock() on this error path.
>
> Fixes: 119a8e708d16 ("IB/rdmavt: Add AH to rdmavt")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
> index 16c446142c2a..b0f09fb45c72 100644
> --- a/drivers/infiniband/sw/rdmavt/ah.c
> +++ b/drivers/infiniband/sw/rdmavt/ah.c
> @@ -119,7 +119,7 @@ struct ib_ah *rvt_create_ah(struct ib_pd *pd,
>
>  	spin_lock_irqsave(&dev->n_ahs_lock, flags);
>  	if (dev->n_ahs_allocated == dev->dparms.props.max_ah) {
> -		spin_unlock(&dev->n_ahs_lock);
> +		spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
>  		kfree(ah);
>  		return ERR_PTR(-ENOMEM);
>  	}

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--1lE8Wy7Exphh2Vpg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkBuSQACgkQ5GN7iDZy
WKftoQ//Vy8W64Db7+dm8DCytsolgnY0Z8pJ78x6e+OBELDE9QM1Qyh8kOU+IPzK
d3F0XQdXyRZLBElRjdjx9z6kIoInc7YpEdbtufSZgr/+2xzl9rXQfJ/nZ1oohgUW
ehZK7QJ5LmyUAy7j0Cug+okCrIvGvvmWMWDbyKDOqPGyrq9mN45G4l/KqUXWR473
Q9ViSTslaFnDxUFUEkXVowQN/TQyEhwbMgWcN/CEAvoZsgyyuZ0M7fYKCiu+vg8J
vSXvIw+g9rU6Is3xyGj2WNdM1ydd2QEkdH9x6k4hSiYwyNcRzGs9X98pnUh8/CjI
2WRhBMs4Ec5wEAVgHxMy/yC0SVOxmQ29HBFG5OheHQAqkinqF6Z6tPkE8thKJMeD
HWoMU27v/BLEGqcPc0POSdbMt3rQinLdOyx8gvKiFl1MXuYiAxnnFvfs/2uMu5Af
GFerNZsFS1gmpBTfuKMzGBMRAt0r9lPwIvupoFAQEq40/q7fITc+2ahqDv+ulMBD
Qyj541gwaeX7rdIE+GrgH0K1pEWYPVpFwe5DYHdxi0a0GGgCqamDmZ8qmOMrNBOt
pYzAWvW9d3++u+0mToQWYIayWmUEHyp+5HBqm6v1af0NS8bPAD3TW7dSmEhrDkw1
U3NNTdfvzLXtGzavcwtCAR+h2LrEk7ADvrYDPYwhxWEVhDhg46I=
=mI5W
-----END PGP SIGNATURE-----

--1lE8Wy7Exphh2Vpg--
