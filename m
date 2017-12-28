From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] IB/mlx5: Move locks initialization to the
 corresponding stage
Date: Thu, 28 Dec 2017 07:32:59 +0200
Message-ID: <20171228053259.GP3494@mtr-leonro.local>
References: <20171224124015.31917-1-leon@kernel.org>
 <20171224124015.31917-7-leon@kernel.org>
 <20171228051806.GP25436@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171228051806.GP25436-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--oyqLL/JqMvClXZi1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 27, 2017 at 10:18:06PM -0700, Jason Gunthorpe wrote:
> On Sun, Dec 24, 2017 at 02:40:15PM +0200, Leon Romanovsky wrote:
> > From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > Unconditional locks/list initialization should be done in the INIT stage.
> > Remove those from the CAPS stage and move them to the proper stage.
>
> So why not always initialize the srcu instead of using that wonky
> callback function?

Maybe, but now, it is out of scope for this series, which more or less
moves code from one place to another.

Thanks

>
> Jason

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpEggoACgkQ5GN7iDZy
WKeGrg//dzVxVvvN+HoHNRyqz5bKvckEVrqpRb6ExXH6aOZ54tdoh98hruL9GAUg
GNq1w8w3DG4Fs6o/UPoUIYH1RP8qxci3urKf7pSEs2W+ncsp6CeInxiiqpdyfVQ2
QOqNXc5e4fZav8pKBQGKwvE7j8XGkKf4UP7b8R4VPHOTf24ZuDhNwdL3oCzj/gWo
Vlv8vAyPI6/SwvLwhNTMkEMDxqiXAaAjORPanHhYG73b325r45js4XeGastj3Qq6
vODlaiAKUGCgxLnGRhgaTD6M8axKqfV52vZ16EkRPAk1wXxUrljkuEiLbKVoshMD
XALJyQaZJnautPlr6tRJ3F8xr5kaaXEVFOFBSPIrD7PsQQyfpenQhCWJofMm7ZvO
/cc5Rs3ACDjWVZG40HJkmKFFRWWK+HoKwtSgooNSZBCSQzdb8nGJ5A8u8nCSz1yJ
N+Ps6Ni3GehMRdgB/fOjn+nOoqRO/esnDDlgegi3cXYK/HKiqJN2MelNepjE6+T0
GWe6I9/Xchx/I6SDlo32Cxk/3MyiYFjTPCBlZLm4XTu3ZpiYOmxGQWob80URRFcD
nC6fNQYU/BbKLZH836r6US2+EtR3E5u6IR9uHRsQ0xECBRVIC+8omLB8gJeJraJi
igOjsRVYs4g1/GtlI14kTlFfpkeWefQTTzNth7eYCRGFjRib8cM=
=pDiA
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
