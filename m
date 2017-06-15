From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 4/5] IB/rxe: Use __func__ to print function's
 name
Date: Thu, 15 Jun 2017 12:09:31 +0300
Message-ID: <20170615090931.GG17846@mtr-leonro.local>
References: <20170615082907.5658-1-leon@kernel.org>
 <20170615082907.5658-5-leon@kernel.org>
 <20170615085117.GA3066@yuvallap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Wtrm9ATX0sn6fFKv"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170615085117.GA3066@yuvallap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Wtrm9ATX0sn6fFKv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 15, 2017 at 11:51:17AM +0300, Yuval Shaia wrote:
> On Thu, Jun 15, 2017 at 11:29:06AM +0300, Leon Romanovsky wrote:
> > From: Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >
> > Its better to use __func__ to print functions name instead of writing
> > the name in the print statement.
> >
> > Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/sw/rxe/rxe_task.c  | 4 ++--
> >  drivers/infiniband/sw/rxe/rxe_verbs.c | 6 +++---
> >  2 files changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/infiniband/sw/rxe/rxe_task.c b/drivers/infiniband/sw/rxe/rxe_task.c
> > index d2a14a1bdc7f..ea3810b29273 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_task.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_task.c
> > @@ -78,7 +78,7 @@ void rxe_do_task(unsigned long data)
> >
> >  	default:
> >  		spin_unlock_irqrestore(&task->state_lock, flags);
> > -		pr_warn("bad state = %d in rxe_do_task\n", task->state);
> > +		pr_warn("%s failed with bad state %d\n", __func__, task->state);
> >  		return;
> >  	}
> >
> > @@ -105,7 +105,7 @@ void rxe_do_task(unsigned long data)
> >  			break;
> >
> >  		default:
> > -			pr_warn("bad state = %d in rxe_do_task\n",
> > +			pr_warn("%s failed with bad state %d\n", __func__,
> >  				task->state);
> >  		}
> >  		spin_unlock_irqrestore(&task->state_lock, flags);
> > diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> > index 92156025db73..a65a330b15b6 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> > @@ -1336,15 +1336,15 @@ int rxe_register_device(struct rxe_dev *rxe)
> >
> >  	err = ib_register_device(dev, NULL);
> >  	if (err) {
> > -		pr_warn("rxe_register_device failed, err = %d\n", err);
> > +		pr_warn("%s failed with error %d\n", __func__, err);
> >  		goto err1;
> >  	}
> >
> >  	for (i = 0; i < ARRAY_SIZE(rxe_dev_attributes); ++i) {
> >  		err = device_create_file(&dev->dev, rxe_dev_attributes[i]);
> >  		if (err) {
> > -			pr_warn("device_create_file failed, i = %d, err = %d\n",
> > -				i, err);
> > +			pr_warn("%s failed with error %d for attr number %d\n",
> > +				__func__, err, i);
>
> Before this fix the warn shows the call which fails (device_create_file)
> and now it will show the caller (rxe_register_device).
> Hope it is still fine with you.

This warning is unique to this function, so it will be much easier to
find the root cause. Instead of unknown place for "device_create_file failed", the user
can go directly to rxe_register_device) and see the reason of the failure.

So, it is fine and it is intentionally :)

Thanks

>
> >  			goto err2;
> >  		}
> >  	}
> > --
> > 2.12.2
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Wtrm9ATX0sn6fFKv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllCTssACgkQ5GN7iDZy
WKehqQ/7BbkyQ0QklbPLhR2O7sWNrVz6z3qyLfbUy1HQbQ5NFaBBTjWdrC6U8AKm
5L/X+OxRZwDlM9YVo8gfHiTAYSvn05Sr3d+MN9MCALIqz3NC5umui6fMNSjnmw1B
h+iygzuyHXfvy3Uv15VYEoKe/E6B0zaC6BnIm/xBU6h+dgXbA+KU/nFjJnK56URg
/MpXldUlPo9cNnS2vt08Ik8gWJK0AipfzKbk5gjxNfeiBOnYfvTGQ3yEw5knYi9l
qNjkLOLZZMuhy7HRZlGE1HLct+93Vh4ZBu3nV61LeKHmm0yVM6X6hLWbeMrq3nIn
6lAL+ghmuohNC+BtX3vEaoxAoWw4VIWV7pVcqaTxISuVfxiddriy0WCPjiyyqcrB
5VaKLqmts9uy5gl5e2LB5zbnvjT9NpPi1iJSeldu/d/HpbYsMM3plCPN8i7a1huR
x5ACkZlkIHgGoT1xEfpC/DKdH/HhhcSMPAHX/jYZWYIFQHvB8OwZYyDagxEgvXeR
QS0CVxn7/UmfJZcY3PrCEpUD+1Kf2E9VUzTf1r7dX3R7uZFGWr9pWWK+EUUyI4Sn
+bKix3/iAdegQWtGl8l4S2bwfVohPlKJalOZqHPxlGBhCCe1o4juo3IpRk+yhQ6o
33aLcJSthRWpwG5o2tmICp5M1B6Y1J9M693xqoFdQSEMxBkq108=
=fgvz
-----END PGP SIGNATURE-----

--Wtrm9ATX0sn6fFKv--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
