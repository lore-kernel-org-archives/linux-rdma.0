From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 0/7] RDMA resource tracking
Date: Tue, 9 Jan 2018 09:53:44 +0200
Message-ID: <20180109075344.GD6823@mtr-leonro.local>
References: <20180102081832.5264-1-leon@kernel.org>
 <0bdd01d388c2$c1d79380$4586ba80$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0bdd01d388c2$c1d79380$4586ba80$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 08, 2018 at 02:53:38PM -0600, Steve Wise wrote:
> >
> > Changelog:
> > v1->v2:
> >  * Rebased on latest rdma/for-next
> >  * Replaced mutex lock which protect linked lists to be RW semaphore.
> >    It has no impact on current implementation, because there is only one
> >    reader (nldev) and it is serialized. However better to be prepared
> >    for multiple readers from the beginning.
> >  * Added reinitialization next QP entry logic to ensure that it exists
> >    and didn't vanish during fill_req_qp() work.
> > v0->v1:
> >  * Dropped RFC
> >  * Separated to thre series, one for for-rc, and two for-next.
>
> Hey Leon,
>
> This series looks good to me.
>
> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>

Thanks a lot.>

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpUdQgACgkQ5GN7iDZy
WKdgmhAAka/GYRzfAf4UYQTJ7J2AHpXtmF01ezn2p81Mjkbd/zZiUYDdc1zWv/6v
VrkLqNnsixwLpQpFyFlODYNQ3qE/3DO5ceFZrbTLBSCq7hi5G4k5LZoXJ4yfPiZm
IgmHxsG3omxwg0f7xWlB16JulR7dtPUTyNPNiOQFuKAM52pM9/3gxRg0Bk7FgWLs
Crb26TND5SBgswuBpiSLfNDcB3gVs+MzHmKNdqVUk4FkBLQnBDWXH5w6u0lwOuWn
/L+YGLgfIE8rFFcKte8Q+q1+AY2xg0TGB+qvML6vwFeh09etne/uSS5hWJUL0lGS
hfpbD+lGf7gA8zo8H13kbl6DT1Gz/jiftzhcjrGVPuzHnghczqHMK0Gkowbl2eky
WmB23Gb8Om8SHaxoaU+WW4nxblA2WpwT6qoS81KIyx1cHD+71Am+yaq64ZEUrslH
PcO/57JOpMCf4htbZh1ET5Z81fRV46gukDJIWapkeCZLQX6zISTMw9bXDmqxpRtj
qQBwvG8cpfrCFhnGOqSU2dbyEzffJCE7N4fjqZaPc4VABNEVq/EpxLwKScPvsOTv
LSojjJhXBox4krHYNxSdqNlyufOCOOKNOhwNVbqHAhuiZCZKXOOm7muCDmemV3aE
g93Ys1Nz9bxCo9VgzsT3qN2NVFlRB3CyURksW/CnFPVpG0ug14M=
=rFux
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
