From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Do not block QP attr_masks used by
 older kernels
Date: Mon, 6 Nov 2017 07:20:16 +0200
Message-ID: <20171106052016.GK31774@mtr-leonro.local>
References: <20171102215031.GY18874@ziepe.ca>
 <20171105071029.GC31774@mtr-leonro.local>
 <20171106022818.GE26011@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N8ia4yKhAKKETby7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171106022818.GE26011-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--N8ia4yKhAKKETby7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 05, 2017 at 07:28:18PM -0700, Jason Gunthorpe wrote:
> On Sun, Nov 05, 2017 at 09:10:29AM +0200, Leon Romanovsky wrote:
> > > @@ -909,6 +909,15 @@ enum ibv_qp_attr_mask {
> > >  	IBV_QP_PATH_MIG_STATE		= 1 << 18,
> > >  	IBV_QP_CAP			= 1 << 19,
> > >  	IBV_QP_DEST_QPN			= 1 << 20,
> > > +#if 0
> > > +	/* These bits were supported on older kernels, but never exposed to
> > > +	 * user space:
> > > +	 */
> > > +	_IBV_QP_COMPAT1			= 1 << 21,
> > > +	_IBV_QP_COMPAT2			= 1 << 22,
> > > +	_IBV_QP_COMPAT3			= 1 << 23,
> > > +	_IBV_QP_COMPAT3			= 1 << 24,
> > > +#endif
> >
> > Why do we need "if 0" in production code (global header file)?
>
> It is really a comment. I don't want to introduce new global symbols
> just for this, or loose the obvious formatting structure of the enum.

Comment will be good enough, no need to add extra:

/*
 * .....
 * _IBV_QP_COMPAT1                 = 1 << 21,
 * ......
 */

Thanks

>
> Jason

--N8ia4yKhAKKETby7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln/8RAACgkQ5GN7iDZy
WKeCKxAAjzDRu5mjrgdUlwtGp7wR6h7vBk8NpwZyrwtdofg30YfKgFmk+XHcpGCr
+hCgMjM7OXgT/goZM24VLnCh62Ed5Hnwodol5s+Yzmu+12BueMQiJxzD4626XPwO
ai13cg4mzag4dvK7pLl3DU9ocFQhvo9Yqe1jzFqaNR8kV8ICDqD7LeEkoqevqQb5
Fl1M7fh0gd5+m4nNmvyf0wKph/Gc+f8MyY9O2TyTXi/SghedFnlw9cGm5F4F88Kv
WV/qsJqo5BAjOUMZCpGleh+SQJP2ArvZgZuhthUeNtrIq4ypzpE91OlYT0h7fjMF
y4UjTacNGTUX947aJoD6OOJZQ7F0A1jLMEJsi7+qH519J0TzEh/iLaaN3fdO8keG
zz3dh312J5n3XrlUg7vfR0S2VKAzQ2Gt2WvpuQyfplSbYq4nrzIYf5roAIJLQH/T
gWi4AAYbnE/GnhIv0VRgqS664nQTUoKxfPSC4F9IrZkS8pou/xuW9g1BffptMJog
Uw9xXIW/rMhYLKfZuALCJBYofVrBY3KtO82J+7nC8q4r23xr2VeXnRwYat0x+knZ
i+JLEzuWleilcHSfIFALrVDNwE1Bu69WMUz+vNZfpz6O9FdZhzur46CJtspMgSCe
0r8hil2l8yFIGeHZktdNN99ZTCRlEGFgqGetQoDFxbNrPpbFOkU=
=ZvK0
-----END PGP SIGNATURE-----

--N8ia4yKhAKKETby7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
