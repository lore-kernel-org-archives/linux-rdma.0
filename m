From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 rdma-core 7/7] mlx5: Export mlx5 direct verbs interface
Date: Mon, 13 Feb 2017 20:21:21 +0200
Message-ID: <20170213182121.GD6989@mtr-leonro.local>
References: <1486909012-15064-1-git-send-email-yishaih@mellanox.com>
 <1486909012-15064-8-git-send-email-yishaih@mellanox.com>
 <20170213164944.GB25430@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170213164944.GB25430-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2017 at 09:49:44AM -0700, Jason Gunthorpe wrote:
> On Sun, Feb 12, 2017 at 04:16:52PM +0200, Yishai Hadas wrote:
> > diff --git a/debian/ibverbs-providers.install b/debian/ibverbs-providers.install
> > index 70244ee..7bacc2e 100644
> > +++ b/debian/ibverbs-providers.install
> > @@ -1,8 +1,12 @@
> > +usr/include/infiniband/mlx5dv.h
> >  etc/libibverbs.d/
> >  etc/modprobe.d/truescale.conf
> >  usr/bin/rxe_cfg
> >  usr/lib/*/libibverbs/lib*-rdmav2.so
> > +usr/lib/*/libmlx5.*
> >  usr/lib/truescale-serdes.cmds
> >  usr/share/doc/rdma-core/rxe.md usr/share/doc/ibverbs-providers/
> > +usr/share/man/man3/mlx5dv_*.3
> > +usr/share/man/man7/mlx5dv.7
>
> These need to go in libibverbs-dev, as does the libmlx5*.so.

I'm not sure, at the end libmlx5 is a provider.

>
> Someone needs to figure out if Debian policy requires a dedicated
> package for the now linkable libmlx5

Talat will work on it, meanwhile we will keep it as is.

>
> > diff --git a/redhat/rdma-core.spec b/redhat/rdma-core.spec
> > index 9bdfdff..ade4b4a 100644
> > +++ b/redhat/rdma-core.spec
> > @@ -359,12 +359,15 @@ rm -rf %{buildroot}/%{_initrddir}/
> >  %dir %{_libdir}/libibverbs
> >  %{_libdir}/libibverbs*.so.*
> >  %{_libdir}/libibverbs/*.so
> > +%{_libdir}/libmlx5.so*
> >  %config(noreplace) %{_sysconfdir}/libibverbs.d/*.driver
> >  %doc %{_docdir}/%{name}-%{version}/libibverbs.md
> >  %doc %{_docdir}/%{name}-%{version}/rxe.md
> >  %{_bindir}/rxe_cfg
> >  %{_mandir}/man7/rxe*
> >  %{_mandir}/man8/rxe*
> > +%{_mandir}/man3/mlx5dv*
> > +%{_mandir}/man7/mlx5dv*
>
> Same comment here, the devel items should be in rdma-core-devel for rpm.
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlih+SEACgkQ5GN7iDZy
WKfTzw//UfOq8sa58cbhCxrby1iF1ShtwFjWgStsjGKChaWoTLBxiUo5P+yIP5f5
gxsw+iDo0eeNu5etZUVqncTzm1iPM+wuznXtSN7Vo4KSMyzf9JzwcAL6vTczCprv
6TUszhjAZ6FfaLWvOIxzTS5cBB/m1ox/AivO5AYiOYWvQDd/aTpQt8nRk+u4TVGV
j6MDfResVNATFoetwlYEZ6xF3U48p7DjDnzd57kGPoy9SSdK7SArNGrYGuaou0TO
5Jy+FTMUPMOdr5fNTQ9cV+eBIx1kmWG+9x6DSeFHkiQrHOopBdC9ZZ8DszmSk4br
qq1CYwXZgBWKGJ8Vmu2P6tqffRBbnWMEv1/MQ15xU6iBgc+15FkCaCelHJW+eH7Y
E+bDT4qgkNC0kd0lQTCy98nfEpNqzgLflRNiTYEb6cwxxBIa3SqiKQpTvOube6GH
c2UOyFeSDrFnNmgzOMEKS0ojg45rBHXPG59HTBFJWXzw8zDTl7otfvJ1J3yQjeVD
uRhOCAjvKJztvt9Jd0REmWvSi6qPEaVbMJtYy7o8XfbT4/Ej8EiIEsfaS6iYHo2k
q5ekO/4MrrFayPNCkjcMwLgwPlb16iy0JyqFc5ZKss9eEh4cf/+dFvl+30VK1etC
2ZEoLX+TGicSUcKBz1OBCRDW7L2uQhf8M536umdW5HVvYBWMczw=
=iqDH
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
