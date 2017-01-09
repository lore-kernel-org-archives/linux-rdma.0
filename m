From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-core] redhat: Remove non-existed infiniband modules
Date: Mon, 9 Jan 2017 19:40:25 +0200
Message-ID: <20170109174025.GB7218@mtr-leonro.local>
References: <20170109085429.32598-1-leonro@mellanox.com>
 <20170109154302.GC29687@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170109154302.GC29687-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2017 at 08:43:02AM -0700, Jason Gunthorpe wrote:
> On Mon, Jan 09, 2017 at 10:54:29AM +0200, Leon Romanovsky wrote:
> > The modules ib_addr.ko, ib_mad.ko and ib_sa.ko were integrated
> > into ib_core.ko in following kernel commits:
> >  * c2e49c92326f ("IB/SA: Integrate ib_sa module into ib_core module")
> >  * 4c2cb4220431 ("IB/MAD: Integrate ib_mad module into ib_core module")
> >  * e3f20f02864f ("IB/core: Integrate IB address resolution module into core")
> >
> > Fixes: 39fa824dd80e ("redhat: add udev/systemd/etc infrastructure bits")
> > Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >  redhat/rdma.kernel-init | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Make sense to me, but if we are saying the redhat scripts only work
> with a certain newish kernel then it would be great to also purge all
> that crufty compat stuff (mttrs, pci tuning, etc) so we can better
> understand what is still actually needed..

Other stuff doesn't crash our verification runs of upstream rdma-core
vs. upstream kernel :)

In our previous discussions, we agreed to have master branch to be in
sync with Linus's tree and proposed to distributions to manage special
(backported) branches for specific releases.

And I agree with you and  would like to see compat stuff removed.

Doug, Jarod
What do you think? Can you do it?

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhzywkACgkQ5GN7iDZy
WKfO7RAAyoa2hMy75bYG63Q0boQ1neVPmtz7TG8+yWnbUFBmZksN1Ir5uLrfK5G4
ZswOdgpEzd7kqjlO6BTKubkjhXSvQlM8ywPg6PqQXQ9GuifL0aw2AgKZigomcNjM
y5B5ZiVOooaCoX59nwr0P58RaY1JX3vHN7vpnJiifchoeClPiTxHJR+xpNm1QHHX
h4eTw+ctW47LHFVgMxf0nqutNS6T1hMGsDGFbYNzbDjm3Ipy07PH1qfTlOE3o3hf
O1ff4QUtOiHnKn20e7wrt2YOCu6310Q1S1pVurdi4UYnLCh3Q4BX3rLUWOjb0ZgQ
EIDNL+E604WwHYlvp9btEhCs3F0vGtJdHVx44t9Sd0I/5vDFkPDUQifZ/8SVphOW
H3f+hSAnIVNl91FyCImBulHyZhY76ecKv2ZCH22Aju42y4TkjE3ZdKYRB3eFkbrB
0y3h9opy5zPNyXycQJldaGokkk3E6guDDwYX2j9eCaNo6eK2Gr3oS8wKybZgZY+2
DV4UmZ300EywXhjvKBd6XYNHEqWHoMzbyC+m7Br3ze840g425hfbhSmURDTGahgy
lbmzYbb+6dGMx5+IO4XIg0VCFdYW16WII2W0OgPENg4QqGGu6uQLxD6zKDKK5Fqr
n9d4EpQ1jGFXTIv0GNh5s+Rr2qWpyQsfFyH4W06G76vGK0fnnJU=
=T8AA
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
