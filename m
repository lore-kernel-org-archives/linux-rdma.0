From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v1 13/22] RDMA/hns: Remove empty functions
Date: Mon, 21 Aug 2017 08:16:02 +0300
Message-ID: <20170821051602.GE1724@mtr-leonro.local>
References: <20170813101816.3120-1-leon@kernel.org>
 <20170813101816.3120-14-leon@kernel.org>
 <CA+sbYW2ZJj2SdchU8M4dZz-KOGSxw2EPX-9oGJhMf3LSzMtA2A@mail.gmail.com>
 <20170818154045.GL23648@mtr-leonro.local>
 <CA+sbYW3LHT3CHX-UmQ_up3VexxoHdaa_Gs3ukanDnApEwPk4Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZRyEpB+iJ+qUx0kp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW3LHT3CHX-UmQ_up3VexxoHdaa_Gs3ukanDnApEwPk4Fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ZRyEpB+iJ+qUx0kp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 21, 2017 at 10:09:10AM +0530, Selvin Xavier wrote:
> On Fri, Aug 18, 2017 at 9:10 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> >>
> >> The following patch helps. But it is like a workaround to solve the problem.
> >>
> >> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
> >> index d5ca101..59911dd 100644
> >> --- a/drivers/infiniband/core/cm.c
> >> +++ b/drivers/infiniband/core/cm.c
> >> @@ -4189,7 +4189,7 @@ static void cm_add_one(struct ib_device *ib_device)
> >>                         goto error2;
> >>
> >>                 ret = ib_modify_port(ib_device, i, 0, &port_modify);
> >> -               if (ret)
> >> +               if (ret && ret != -ENOSYS)
> >>                         goto error3;
> >>
> >>                 count++;
> >>
> >> Or should we have the modify_port hook with some basic checks?
> >
> > I think that your proposal is right thing to do. The driver should
> > properly return the status of its callbacks (-ENOSYS) and it is
> > responsibility of the caller to decide what to do in such case.
> >
>
> > The dummy function (return 0) hides the fact that modify_port do
> > nothing and it can be wrong for some callers.
> >
> I am bit confused. You support the proposal to have a modify_port with
> some basic check.. right?

Sorry for not being clear,

Yes, I fully support your suggestion to improve modify_port function.

At least that common modify_port function should check the type of port
and return success for RoCE (see mlx4_ib_modify_port), but need to check
that mlx5_ib_modify_port won't break after that.

Thanks

> > Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ZRyEpB+iJ+qUx0kp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmabJIACgkQ5GN7iDZy
WKdgCBAAgAagw1TcrouNSbr2NqlAoLI3UQZjdAmsW5YefQKotkBxB75QY/sC1slf
FEw6LECE+Pr6qXbKNKUKcqli1/LHynAayg3gHrtNXxyKSxZgHDD8XLEy7f/Cuza7
Vs2m054UYgxQKO6AEMoPG4zWyL4/+9qpvtrK+ECYC7SWrfviV8vzfUfg5rgPZjBa
+V/vT+MDM0JIG4bqiBoWwMnswgT+MM2E0QtqjGw5nbsNsgqmgIQq5kEL+1jt0Dcm
DjBE2g7zuxxWsiwrMFOhKT1umjcTf87gtBbHrbKKgxIYURkybSem3woz9uOwkGFW
FfJFBaDZQp7YQBlDXZZmpn+5kLCmNoMRuQoXS34C2WOVxizi/4c2w1maAaY+uVF2
LIwU9d91Z4J1vA+y+aaYbFyAwyelMfagZyOp7fCGnX0Eu6s6mIQzqb7rNLmU84sq
Krk0eXclCq0HrUIgpJiDuZBbbFhMOplzj3gpgeduh+Ouq3QOLcFT44P4EtyRTCTj
H+3+lvNY5uJTr1RGH+T0yrKZBvUAuR8DCsj0uJ1JYWn+WLY3gcopLVTqEddufGVr
IvnTUdNM/Fz/XZeIwjUcp2MtlseWnYvNMrJ5sQHBnyKNpXGW6GE7T4Qu9KdSoEuB
quw3Fz9g4nRwYL/1Ucu6UDwfe2yVn2Jis2unjuEh9loc8xr9Z2Y=
=5DeY
-----END PGP SIGNATURE-----

--ZRyEpB+iJ+qUx0kp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
