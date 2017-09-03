From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/5] verbs: Tidy up ibverbs_get_device_list
Date: Sun, 3 Sep 2017 20:25:49 +0300
Message-ID: <20170903172549.GP10539@mtr-leonro.local>
References: <1504212659-9674-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1504212659-9674-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170903140351.GO10539@mtr-leonro.local>
 <20170903144839.GA20230@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NT59pYSnj1ZLVgEN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170903144839.GA20230-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--NT59pYSnj1ZLVgEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 03, 2017 at 08:48:39AM -0600, Jason Gunthorpe wrote:
> On Sun, Sep 03, 2017 at 05:03:51PM +0300, Leon Romanovsky wrote:
> > > +			list_del(&sysfs_dev->entry);
> > > +			// Ownership of sysfs_dev moves into vdev->sysfs
> >
> > Please don't use "//" C++ style in C files.
>
> I thought we were following the C11 rules?

Not in the coding style, to simplify development, it is better to stick
with one known to everyone here style - kernel coding style.

> We use all the other features now and don't support pre C11 compilers. (unlike the kernel)
>
> Jason

--NT59pYSnj1ZLVgEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmsOxQACgkQ5GN7iDZy
WKe+9g//bRygLDHnkFLIQkr7flcYvNKox3mE2SjYLw/zNcdEUbq7E21Q1yWK244X
MA7iRnPvYzoE+7UU8UZFdP6ITdnaPCw8IAUo9f5l8XBh5JtF79tY2sIwUY9Zg81K
wwHK+1mxfNIZBwQntY35ovirZgUcZuw/SmE0eFZYSiNIh/p5VnTJYAw15PwSijwY
9oPvq6O84e2bmIDRvDWGBXAfeFpnAfokcBIHJfBH1B5P16eqPCePuAduFVbCAgdZ
qBp2LNOEaeEnlTFowk2lQ8KrdM466/SsSa47MqVqHwVw6Ugt6wi6aYNypY7WVZ03
ctjEwZu156WOrOj+P4WAE98gZV+7534TWBkDMOpSJ/ptX78pY4z0JRkNn6aqgw8P
5U4JC3g1DTH/uYkhzEph4q+QbazZe67A9vE4hsvPPxrXRZTqLnbOOzIkQ9zQ0FTY
2f8Towlp7tZBRVdafjnW27VgK48KwmLNmoWVvCYUQpofaUBQlwAE7C4RPa8Am7O8
XA4eMuy1tDaWOfR+cgoRItujfImL2YNq7tkrfU7udWSboTLXgYhDWMj7iZAnA9nZ
2veyYaPdNfQjURPS9OJkZTTOHmwX7jimI47z9pukXRV/l6DXyhPdy3h0hLJjaL0y
Ll4FP2sYWQFFo8adNHN4nInjcAaY4J9ikb8Otuia3rECaaUYCbY=
=xI7x
-----END PGP SIGNATURE-----

--NT59pYSnj1ZLVgEN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
