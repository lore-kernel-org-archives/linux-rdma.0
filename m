From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/nldev: Provide detailed QP
 information
Date: Thu, 11 Jan 2018 17:47:18 +0200
Message-ID: <20180111154718.GC15760@mtr-leonro.local>
References: <20180102081832.5264-1-leon@kernel.org>
 <20180102081832.5264-8-leon@kernel.org>
 <20180109200917.GF4518@ziepe.ca>
 <20180110071722.GF7368@mtr-leonro.local>
 <20180110225622.GQ4518@ziepe.ca>
 <016201d38a6a$ca49d880$5edd8980$@opengridcomputing.com>
 <20180111054141.GM7368@mtr-leonro.local>
 <00d901d38aef$5b993360$12cb9a20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00d901d38aef$5b993360$12cb9a20$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Mark Bloch' <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 11, 2018 at 09:17:56AM -0600, Steve Wise wrote:
> > > >
> > > > > I personally have no plans to fix CMA netlink code and for my
> opinion it
> > > > > should be removed, instead of beating that dead horse.
> > > >
> > > > What is so wrong with it you can't use it anyhow?
> > > >
> > >
> > > We certainly need to be able to get detailed cm_id information.  At
> least
> > > cm_id bound device, cm_id state, port num, qp-id associated with this
> cm_id,
> > > and src/dst ipaddrs/ports.  However, it could be fetched and added to qp
> > > attributes.  Ala iw_cxgb4's debugfs "qps" file:
> > >
> > > [root@stevo3 stevo]# cat /sys/kernel/debug/iw_cxgb4/0000\:04\:00.4/qps
> > > rc qp sq id 1136 rq id 1137 state 1 onchip 0 ep tid 12028 state 7
> > > 172.16.4.3:58725/58725->172.16.4.4:7174/7174
> > >
> > > ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >
> > It can be one option, another is to add new RDMA_RESTRACK_CMA object and
> > expose all relevant information with rdmatool, e.g. "rdma resoruce cma
> link
> > cxgb4/1".
> >
>
> I like the idea of RDMA_RESTRACK_CMA.  I think cm_id's are important objects
> like qps, cqs, pds, and mrs.

Now, it is clear why I want to kill current CMA netlink code :)

>
> Steve.
>

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpXhwUACgkQ5GN7iDZy
WKeK5w/9FA1gptp+d10NY0bdXmIR6MaY4ovOEGhvagEtq59UVm/XFNFogKiBCOS3
dVDqhc1tPDVMbuesrSJ7xpbgy2/hO3A+pJrYmvIDC5KBYFABTARgo0DpkqK7/UCl
bGcKfRd/fztQFSTO/MBK+yjtrSQHBeyU/n8VQ+U9JLkXQtDmF9uqSZbCg3gieYoW
jiOYsfL0thM8+avRAoFAKA0rYzVa6wb5aRo/fezFXr8dMZRJlDCzeJtidafmB+LU
F0wBj4cB0F0jox+8AY6ezvhcBRyC9BCi25wYmvVJfhtt+m8VTZDW582t7G8aO4ZZ
sF7LH6sxNyVcY+sPRm6dPAcpYW0PePjAUWvXmyNJvPJuGN65Cctu7n5OHCG3elAJ
dPkqvNG6f/VWJOrRQ6AlSprus3/dGPo22wz3NuOt1ofBDiGEuC8o7cpxXpDANI/M
440Rw1iLyl9g5Uqjn35WZhvRcq/bF4FzU96zyzd1Yu4dMp9nRdRjmFbb10yxsDep
H/+28abbPiCljVNcaErrWYgK9HopdXRQJSEIylAoJKAM8qLn+RHhNoSanbj+ut8c
vJcEpg/ghvpMeobsRsmpMzhd+3+sE7yUXqxWimQyGJdRHJV9gAhCS3/+GPcS+8Qu
cg710zU1Ja8CPmgbiCOTgXKT49XtszTR3VKvcFv+FCAEWaYpbtY=
=TeCr
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
