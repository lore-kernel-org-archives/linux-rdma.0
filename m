From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 03/13] Attach/detach SoftiWarp to/from network and
 RDMA subsystem
Date: Thu, 9 Nov 2017 10:46:10 +0200
Message-ID: <20171109084610.GB18825@mtr-leonro.local>
References: <20171008130342.GV25829@mtr-leonro.local>
 <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-4-bmt@zurich.ibm.com>
 <OF14995472.9A0A4CF8-ON002581D2.005950C6-002581D2.005C2475@notes.na.collabserv.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PVZB3C997XEKXh6G"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF14995472.9A0A4CF8-ON002581D2.005950C6-002581D2.005C2475-8eTO7WVQ4XIsd+ienQ86orlN3bxYEBpz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--PVZB3C997XEKXh6G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 08, 2017 at 04:46:26PM +0000, Bernard Metzler wrote:
> -----Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote: -----
>
> >> + */
> >> +static __init int siw_init_module(void)
> >> +{
> >> +	int rv;
> >> +	int nr_cpu;
> >> +
> >> +	if (SENDPAGE_THRESH < SIW_MAX_INLINE) {
> >> +		pr_info("siw: sendpage threshold too small: %u\n",
> >> +			(int)SENDPAGE_THRESH);
> >> +		rv = EINVAL;
> >> +		goto out;
> >> +	}
> >> +	/*
> >> +	 * The xprtrdma module needs at least some rudimentary bus to set
> >> +	 * some devices path MTU.
> >> +	 */
> >> +	rv = bus_register(&siw_bus);
> >
> >bus register for the driver? no way.
>
> I admit - this looks ugly. And the comment above is incomplete.
> I did this mainly to allow siw to register with loopback devices.
> During device registration, we need to present a real parent device:
> device_add() needs it, as called by ib_device_register_sysfs().
> The loopback device does not have a parent device, nor dma_ops.
> The dma_ops can be satisfied by global dma_virt_ops. But I did not
> find a similar 'virtual parent device' I could present during registration.
> So I 'invented' that one.
>
> I see no other way yet than dropping loopback device support, if this
> approach is not acceptable. But, we found it nice to have, since performance
> for the loopback case improved significantly.
>
> Any suggestion on how to enable loopback support (referencing 127.0.0.x
> addresses during connection management) in a more elegant way would
> be highly appreciated....
>

RXE solved it by relying on loopback from netdevice, see rxe_dma_device call
in rxe_register_device.

Will it work for SIW?

Thanks

--PVZB3C997XEKXh6G
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloEFdIACgkQ5GN7iDZy
WKdKgw//U8JHy0a3KyeYvOAbxNiWBGxiHtIs7EjVOTiv9DWz6jQ9k6fYZgCgBRHG
UAAErIBCMHEBj0pyqNchOmTZaP7erezo/YOE9YfuwmmU/qM10PU38+NADLW0l3lq
vvqOrZDkn/ydsvJWAzatzVMBcKuMjEAjFt/nk/gs7o2/qJAi1tp5cdM/oFIqvipS
1PB4YmzB4YM0bw6+0BLQ+OCJ5Sj5mkyRbPbX4qoq3Ir+5jy2GQxysfqyco4ON2/e
h1PZRjF/9xrOG7qVvfsiO39uvC2pht8OW5cxs64HH3OCnbtG8HcmmGgHJ9R06MDf
ihSeCTSZ+YRMtHwgL3hg84hWZWxzXkmshY5KnH7Rsy+kUIGUk1jXtIcwb3MHnOFf
ru5IdtyvqWhcW5go34JNR6JkrKWDlE7Ev5yDRL648sKNFmREIEwnlx0ij7znn/bl
EjSAyrvGBUDI6GdZTX1RqUUMfO7mBA3LYefSYEbVlQ2Vd47vfB+dMYUiXPFgaPjK
wJ5rIWOTDm2x5Ev3jI33eLh3YGqGMd1BrXkPnZu/js6rkXCFby2M6RUaOtKUXbw3
OoSLHiDcTb7bZNjnnA7tDUN+Y9xSOeWhmVVjuwJvH21IzpDJDO44o1q/l8/OB3C/
vJ7oQ/PWt1rzDZzJw7J90k8rrbRj3XZAp0PkVWfVv8M5XSnNPJg=
=0tSK
-----END PGP SIGNATURE-----

--PVZB3C997XEKXh6G--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
