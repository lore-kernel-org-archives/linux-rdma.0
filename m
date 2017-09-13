From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] mlx4: Add inline-receive support
Date: Wed, 13 Sep 2017 15:35:29 +0300
Message-ID: <20170913123529.GS3405@mtr-leonro.local>
References: <1505036749-12297-1-git-send-email-yishaih@mellanox.com>
 <20170911160508.GA32117@obsidianresearch.com>
 <5c3ce114-af4b-16c4-af7e-17305faaff0f@dev.mellanox.co.il>
 <20170911162339.GC32117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Yia77v5a8fyVHJSl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170911162339.GC32117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Yia77v5a8fyVHJSl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 11, 2017 at 10:23:39AM -0600, Jason Gunthorpe wrote:
> On Mon, Sep 11, 2017 at 07:09:27PM +0300, Yishai Hadas wrote:
> 1;2802;0c> On 9/11/2017 7:05 PM, Jason Gunthorpe wrote:
> > >On Sun, Sep 10, 2017 at 12:45:49PM +0300, Yishai Hadas wrote:
> > >
> > >>diff --git a/providers/mlx4/libmlx4.map b/providers/mlx4/libmlx4.map
> > >>index 0e53f83..6de4348 100644
> > >>+++ b/providers/mlx4/libmlx4.map
> > >>@@ -3,5 +3,7 @@
> > >> MLX4_1.0 {
> > >> 	global:
> > >> 		mlx4dv_init_obj;
> > >>+		mlx4dv_query_device;
> > >>+		mlx4dv_create_qp;
> > >
> > >NAK please read Documentation/versioning.md and do this properly.
> > >
> >
> > RDMA core V15 first introduced the MLX4_1.0 and its initial mlx4dv_init_obj
> > API, as those APIs go to this version it should be fine.
>
> My bad, I thought we'd cut v15 already..

I'm waiting for 4.14-rc1.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Yia77v5a8fyVHJSl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlm5JhAACgkQ5GN7iDZy
WKc+IBAAoALWQb9LlZOUF4V5/WSNHbKDL0u0QtlxAFYyH2nPfHPFZmOvMOZ9ubKu
6qVF2GNMJ98CYezH6RtTqidMzsmqbEEXZBVsW4urQR5+qVjYfeOdRT1ryLYNj2DY
Y14UXgIyv4cXKhz9K3MXYMlS+mxxNkKBGZV9ytZ5p5lz3P4z739RcDFU/kYR7E8w
c/aHSmHlOHGF1IdEOIPGgG0XJeXFf+5+u6tnXvkd06egdmWpoGvYhXr38PREfwuH
ET+yRWLWtrm7AuN75ZrAmsdN4MvUFF5GvhOX+5kuLbIfuRhsibj61Pu28MsYRMog
IySyVZO6mTmPLIFbFLofEVPoByGNyQatMBhkxN/9MwLYqNHot0N/tcDk1ZlVRLZx
odY3+3LAiv5LjGCxtiS7PCX5LOQvktqXtbzT/GKNh03S3Zk6OSpDgnfN2quaYjiA
y43ZnHhvEpEiUETCtpust8bNZ19buatRclayAHH4YIS5DK0WTJETx77yQ4O1BfrC
Hy+LvPD/MwzNYovD6UA6R1BryybF1ZLBg+6Xmo0fLOIB9aqXmi+zLcj/9qFfaerO
01iEaucANojtIK1Kgw3hNTe6mYmJNp4TIjWPyrjS3zozTKqI1E3tU9yZjBpABKDR
1qhk4/39YHIFsNt44K0Var9/I5m6DGkvjbltD9nshx1T9DwuJk4=
=zK4V
-----END PGP SIGNATURE-----

--Yia77v5a8fyVHJSl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
