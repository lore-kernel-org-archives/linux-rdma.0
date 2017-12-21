From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH rdma-next 02/14] RDMA/core: Enforce requirement to
 hold lists_rwsem semaphore
Date: Thu, 21 Dec 2017 21:57:54 +0200
Message-ID: <20171221195754.GO2942@mtr-leonro.local>
References: <20171221181748.17126-1-leon@kernel.org>
 <20171221181748.17126-3-leon@kernel.org>
 <20171221191200.GE20015@ziepe.ca>
 <20171221195134.GM2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vDpvzslK0qRw06MN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171221195134.GM2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--vDpvzslK0qRw06MN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 21, 2017 at 09:51:34PM +0200, Leon Romanovsky wrote:
> On Thu, Dec 21, 2017 at 12:12:00PM -0700, Jason Gunthorpe wrote:
> > On Thu, Dec 21, 2017 at 08:17:36PM +0200, Leon Romanovsky wrote:
> > > @@ -526,8 +531,8 @@ int ib_register_device(struct ib_device *device,
> > >  		if (!add_client_context(device, client) && client->add)
> > >  			client->add(device);
> > >
> > > -	device->index = __dev_new_index();
> > >  	down_write(&lists_rwsem);
> > > +	device->index = __dev_new_index();
> >
> > Isn't this hunk a for-rc bugfix??
>
> Whole patch can go to for-rc.
>

But you should remember that it will create dependency on for-rc for
whole series.

> This for-rc/for-next thing is new for me. In RDMA, we didn't bother ourselves too
> much and sent everything to for-next.
>
> Thanks
>
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--vDpvzslK0qRw06MN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo8EkIACgkQ5GN7iDZy
WKekXRAAxWdBMuRd+/eZnQj8VZnOjqmuDgvTCsW2pBf+YzVglBJuZGtGy91l6W0k
Wg0kdqt1RB2j2R3tWIjigFjBhfypnPpTrTuJQfENkA6ed3SKYb4Qfq0CkzvXUi0M
aAeIscfzAyMWU2y6QDwio00RhG0Eix0G7icR/gzcuFCcLActYTIQ5f0QMxAK4dim
qUYyvS+n0o7RN9dPCWexECLEnK4gb0pcFdy41B5rE3YzlKn6IwpMtBGcz/y0h65I
4w206psEBM977TDfPQjG+/WyIOE7p9NBF9nDBymh6Si30NNrPalGRrLFpf+5S9uW
WoDFJFZ2mmk5uENaFNiwd1f+au3ZwkHZ5DT/9lSlzB3eU/twm9YwuSsbxhuKP3D0
9lz7o4biLasYkCPZ5nHpcN9iSCUV0WgMp5Cj/xaMaVLRoUMQ8lX4M21/2tpSME7Y
2vMnEvz9YDcvvq17JKgqSzHE/6vhykgQlV2Gf4JwHcvbD/yiaYBuaTns9bNnUPfR
tFP85epTEw4pZ8l3kq9/uI5KL3FnyEDQ4zANuOvPe0uvTZ5b1RkEPP7sE5D3onDE
U+zXHtp67Ur0SSrhgYNqS+NpA9AyAJ8CLhu07MAd/YUTECFT7L0iq8r4NHeYz0ez
xNa8SmmvxaFR4LYwSMP3D/DqFOsHTXBfXxpmtYMrhUcfc8d8088=
=TfLY
-----END PGP SIGNATURE-----

--vDpvzslK0qRw06MN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
