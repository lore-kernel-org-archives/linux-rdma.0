From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Thu, 9 Nov 2017 19:47:47 +0200
Message-ID: <20171109174747.GJ18825@mtr-leonro.local>
References: <20171109084610.GB18825@mtr-leonro.local>
 <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF14995472.9A0A4CF8-ON002581D2.005950C6-002581D2.005C2475@notes.na.collabserv.com>
 <OFCB0BDB52.EB9864CE-ON002581D3.004282CC-002581D3.0050E7A2@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pIpim1HsfXagChBe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OFCB0BDB52.EB9864CE-ON002581D3.004282CC-002581D3.0050E7A2-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--pIpim1HsfXagChBe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 09, 2017 at 02:43:41PM +0000, Bernard Metzler wrote:
>
> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
>
> >To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> >From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >Date: 11/09/2017 09:52AM
> >Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network
> >and RDMA subsystem
> >
> >On Wed, Nov 08, 2017 at 04:46:26PM +0000, Bernard Metzler wrote:
> >> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
> >>
> >> >> + */
> >> >> +static __init int siw_init_module(void)
> >> >> +{
> >> >> +	int rv;
> >> >> +	int nr_cpu;
> >> >> +
> >> >> +	if (SENDPAGE_THRESH < SIW_MAX_INLINE) {
> >> >> +		pr_info("siw: sendpage threshold too small: %u\n",
> >> >> +			(int)SENDPAGE_THRESH);
> >> >> +		rv = EINVAL;
> >> >> +		goto out;
> >> >> +	}
> >> >> +	/*
> >> >> +	 * The xprtrdma module needs at least some rudimentary bus to
> >set
> >> >> +	 * some devices path MTU.
> >> >> +	 */
> >> >> +	rv = bus_register(&siw_bus);
> >> >
> >> >bus register for the driver? no way.
> >>
> >> I admit - this looks ugly. And the comment above is incomplete.
> >> I did this mainly to allow siw to register with loopback devices.
> >> During device registration, we need to present a real parent
> >device:
> >> device_add() needs it, as called by ib_device_register_sysfs().
> >> The loopback device does not have a parent device, nor dma_ops.
> >> The dma_ops can be satisfied by global dma_virt_ops. But I did not
> >> find a similar 'virtual parent device' I could present during
> >registration.
> >> So I 'invented' that one.
> >>
> >> I see no other way yet than dropping loopback device support, if
> >this
> >> approach is not acceptable. But, we found it nice to have, since
> >performance
> >> for the loopback case improved significantly.
> >>
> >> Any suggestion on how to enable loopback support (referencing
> >127.0.0.x
> >> addresses during connection management) in a more elegant way would
> >> be highly appreciated....
> >>
> >
> >RXE solved it by relying on loopback from netdevice, see
> >rxe_dma_device call
> >in rxe_register_device.
> >
> >Will it work for SIW?
> >
> >Thanks
> >
>
> Right...this is basically what siw can do as well for all
> other devices it attaches to. But it will not work for the
> real loopback device (addr 127.0.0.1 and friends), since that
> device does not come with a parent device it belongs
> to. Loopback seem to be kind of a 'top level' device.
>
> rxe_dma_device() returns netdev->dev.parent, which is
> NULL for loopback. So there is probably currently no support
> for lo devices within rxe.
>
> I'll take the loopback devices itself as the parent device.
> That seem to work. I'd suggest that for rxe as well.

Feel free to send a patch for RXE.

Thanks

>
> Thank you!
>

--pIpim1HsfXagChBe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloElMMACgkQ5GN7iDZy
WKdcMw/+LYOPUGc4+nYUhEgQAoAoRxlxzhfwMUS+RSe9o2v5ZeaHv+8DqrQ6L5j6
H6ocy0HHyC5YkOqqvEUy7qVOn0j7nb6dlBjPv1qcBNcHVmZf+3SmyTAZn0PssjbS
5LoxGIVU1jytsimTzptH/xn52g9bONQ6qDD8C6Zd2Q0mVoB77lrvBnX6OoCec5GC
HbE9D/j9kyCvBhQhRAf4lBR/c1QVNoKXhZCrVO8UP3jqnPbI1/j0HYWuDeFU7ImA
bFWpxeGDrpnjMkKZlN33Vf83phkxdHnoxw3dvd6xNIykZ0VEKrZ2lEIw5KWFfjpa
grCWkyupohg3Ak4H4bFi4TgL00W8iAtN5KFhpNSMCZDMWLxJVDdW9toyWyCm9ai8
fPwBCd/3IbnxR8Sea9Bir7NG1VXDinGTj1l8T+wdLvXT8nE1bGpiept99YBgCXOu
LwvpIZ0Z1osSF2LeiagVTn2PvEo6+FEDB8P8QmjY8Y+wI3F5eAuhzDY0mrtJkfmq
IX/RBoIQmjEIh6WW1tpFYVQuCezSRTCHcsK68M9Ifr/k283i1JPm8pHEWATtXe4K
Mfr/JpJ80l4k0KjThcJi2Z3IrR2UczzCGZ1S6D9V0atiuMLI6htIvLklG99LSH3i
fd+fbbdBQNu2QxHdqEUI9F2GcAWgPGnH9Kw+x+GyZWS79S1s+UE=
=iizG
-----END PGP SIGNATURE-----

--pIpim1HsfXagChBe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
