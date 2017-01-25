From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/5] IB: Query port through the core instead of
 directly calling the driver handler
Date: Wed, 25 Jan 2017 20:27:14 +0200
Message-ID: <20170125182714.GS6005@mtr-leonro.local>
References: <20170119054102.20135-1-leon@kernel.org>
 <20170119054102.20135-6-leon@kernel.org>
 <20170124205938.GA5524@ssaleem-MOBL4.amr.corp.intel.com>
 <20170125123920.GO6005@mtr-leonro.local>
 <CAJ3xEMjfxPs85OQP2v2MvYzU9ajUELs7_3r0nA-=TTa-tp-hSQ@mail.gmail.com>
 <20170125180551.GA8964@ssaleem-MOBL4.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tV/+6PImfyFtriLg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170125180551.GA8964-GOXS9JX10wfOxmVO0tvppfooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--tV/+6PImfyFtriLg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 25, 2017 at 12:05:51PM -0600, Shiraz Saleem wrote:
> On Wed, Jan 25, 2017 at 04:29:55PM +0200, Or Gerlitz wrote:
> > On Wed, Jan 25, 2017 at 2:39 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Tue, Jan 24, 2017 at 02:59:38PM -0600, Shiraz Saleem wrote:
> > >
> > >
> > > > > --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
> > > > > +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
> > > > > @@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
> > > > >     struct list_head *head =
> > > > >             &dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
> > > > >
> > > > > +   memset(&attr, 0, sizeof(struct ib_port_attr));
> > > > >     err = __mlx4_ib_query_port(ibdev, port, &attr, 1);
> > > >
> > > > So why not call ib_query_port here as opposed to driver handler? As stated in your subject line.
> > >
> > > This is call to mlx4 internal implementation of ib_query_port. This
> > > implementation takes an additional parameter. In this case it is "1",
> > > while call to ib_query_port will call to this function with "0".
> >
> > The mlx4 IB driver is used all of native, SRIOV PF and SRIOV VF instances.
> >
> > Under SRIOV, the port has network view and host view. This internal query port
> > call (and the other one you commented on) is done in a network view by the PF.
> >
> > The calls that come from the IB core are done with host view.
> >
> > As such I had to retain these two internal calls.
>
> Ok. Understand it better now. BTW this parameter 'netw_view' doesnt appear to
> be used in one of the functions eth_link_query_port called from mlx4 query port
> implementation.

Thanks for pointing it.
I sent cleanup patch to ML.


> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--tV/+6PImfyFtriLg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliI7gIACgkQ5GN7iDZy
WKehXBAAlxEYn3oWWNvgVKgo4FRV5c+rzfJVZtymVdyyMyqt8ZGe8yyG2/770pD2
7dxwacYPWk4cZ9YObx1CxhGddjvQVIVHmUDS2vKYT5ktpr3xAtepi4eqYDCQrQWe
73EOlTw+8fjRbkeYSzK6U44KqeGD/z9XbBusATFLnUn/WMi0zGvrUwrJhxMFT7Ei
+pvIJcp22R+sYthJSIZeiAOmHzHG6vKA78nTRvQzWa0EMLhBQEnmmHDV6XkpHeNW
bzWk1dPgd/Kiw8D4hpSAqv6Gg8ExPan5bhvNP0E7dupxrqFCZxy6Si+uSjuFULsl
Q95KXmk5Bs73+6/JQAtJSMC0PQxht237WgtLAqNDuLd8YBBzSiPM1JKP97oJYbJi
cZi8b0k/J6p86wMVrz54AmTK3Jgw5tkvdjQew5tPX9L0puD6p7fJlucCduT0roce
/hs4TXSQNSR35SOdtyxg2fypCqDG/ExpUSfEQGwS0Gu6JkNO9XZJFgHhcGNoURXe
J2j8C/o5FCjEstSPSpYYk9gK9fxep2M42fXnbjBfS+cgEyjG2HbYgfVK5oPIxY9y
gl3+on66bk1TozO5nzYtFuUpD8FcrCA2l6R380Qm/oNkiLHst+QAq7H2IOvkCD8D
6dt/LDX1DCRTyH1vLD/LExpXbirbr4oEQc+i4WOt5++IIwt0vcA=
=aDta
-----END PGP SIGNATURE-----

--tV/+6PImfyFtriLg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
