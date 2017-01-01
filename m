From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 5/9] IB/ipoib: rtnl_unlock can not come
 after free_netdev
Date: Sun, 1 Jan 2017 08:39:45 +0200
Message-ID: <20170101063945.GP26885@mtr-leonro.local>
References: <20161228124728.26619-1-leon@kernel.org>
 <20161228124728.26619-6-leon@kernel.org>
 <CAJ3xEMg+UuvUqqaFrBXa+S+S2qLg_FowZLrwvhYzaB7JTkn=pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9pS2hy4/DrI8BQlq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMg+UuvUqqaFrBXa+S+S2qLg_FowZLrwvhYzaB7JTkn=pQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--9pS2hy4/DrI8BQlq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 29, 2016 at 10:55:34PM +0200, Or Gerlitz wrote:
> On Wed, Dec 28, 2016 at 2:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The ipoib_vlan_add function calls rtnl_unlock after free_netdev,
> > rtnl_unlock not only releases the lock, but also calls netdev_run_todo.
> > The latter function browses the net_todo_list array and completes the
> > unregistration of all its net_device instances. If we call free_netdev
> > before rtnl_unlock, then netdev_run_todo call over the freed device causes
> > panic.
>
>
> RU claiming that we are crashing 100.0% here? since when? ever?

According to our internal bugtracker (see #131352), this bug was
literaly forever (4 years old), and it was fixed internaly in
MOFED 2.0.

>
> > To fix, move rtnl_unlock call before free_netdev call.
> >
> > Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
> > Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> > index 9682183..d9dab4a 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_vlan.c
> > @@ -168,11 +168,11 @@ int ipoib_vlan_add(struct net_device *pdev, unsigned short pkey)
> >  out:
> >         up_write(&ppriv->vlan_rwsem);
> >
> > +       rtnl_unlock();
> > +
> >         if (result)
> >                 free_netdev(priv->dev);
> >
> > -       rtnl_unlock();
> > -
> >         return result;
> >  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--9pS2hy4/DrI8BQlq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhopDAACgkQ5GN7iDZy
WKfCzA/+PhAoAx//6GQRC6zsEZZB4OPE/rfsF+Y43wnZosnjaIZLWfzHQawJ7+hk
jrT/1S8pdUqnZsZ1WUoz4SDDvOLoABYFieM2IpEFjbBuDqgg0K7n4yXK4k1ungN/
usnhmAE2e5ImiHs9gpA8+S/LqctAp3lqly7HtbeSgv2NoRLviLwNfBIoKNMLJtHI
/euHluhhlBU7WcEQA4yG4UuStZO6Qqhj57NJwl6iwZjccKORejUp4vqM10r3DfSw
Vti7azAMn+TxrGA11Z11Sd0toh1ZGw7ZVVGsTl5en/huT3JtGr4Y7yxIVCWlaM9f
i8NPYwCbHlcRHiLnbK1MwwdM6PJG2B07/8GyTRXqBZRpAI4qwRXsuKhUqiGLwDKy
f693uJSGyvzP/So9vdig01I2Nq0971fTmKgkAPPvcDbgOSMvDk625QZNR9geA1uU
8EvfWRyCRwAt0Rg/cNsLeFWxFv9GCVY9z4Km1Mqq2FxUfQF0x2o/niqKpH2f4qxy
FviJrxrRBLDnUDqGUMIAeEFvdZzZgRs+0LynJGM+q0e3WqA/UwY4PhKs1lCh7TPb
e+JeZwBcCp/y46uOpiUilhTJCzKKA/uCcu69mqkfUs8v9W8VXwPQgDUxzs057JYa
iPb0szOzW1dALe7BBYJyikI/yTfazcxqclpMKZeHlvm0mAYRuOA=
=RBc2
-----END PGP SIGNATURE-----

--9pS2hy4/DrI8BQlq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
