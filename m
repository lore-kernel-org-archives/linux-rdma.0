From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next, 01/31] IB/core: Fix do not add RoCEv2 default GID
 when IPv6 is disabled
Date: Tue, 19 Dec 2017 15:11:44 +0200
Message-ID: <20171219131144.GE2942@mtr-leonro.local>
References: <20171114125218.20477-2-leon@kernel.org>
 <20171218204818.GA18725@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ey/N+yb7u/X9mFhi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171218204818.GA18725-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ey/N+yb7u/X9mFhi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 18, 2017 at 01:48:18PM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 14, 2017 at 02:51:48PM +0200, Leon Romanovsky wrote:
> > Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> BTW, Leon when you send these patches please make sure the Reviewer's
> are CC'd as they should see and have a chance to respond to review
> comments.. I added Eli manually in this case..

I will try to pay more attention to it.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ey/N+yb7u/X9mFhi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo5EBAACgkQ5GN7iDZy
WKfo/g/9FUeCnwMDJeJUyxZZuvIGnJWtoyXKltyeEicv5t5cy9G6CWS9fFNrDvl9
ldYNFcdriQKU9IWsmwZVeYlYgU/AM0zSdzTHlQc/5XRNKK3wBMLtpxYjuqMMOQQG
v+jJLgDVLdvo1f6YLs7Xov5coNfprkvsd48rOIkC9Vky3vV8ymuWc5FemnDN7o9m
My8sL1IVXI1dWKOuDFZJHIlnnPLwMGRt/nYfvpwmZnkqP+QN0Y2ppkpgNpFuv3kT
cZoerAvRa72hdgZxG3pZt6T1JEyAmZXu/xgOKEtGsXQ3kcmhBXrXk1ZsV/caHM5/
Bqy2yP9q0q/+FoNRxCbFHhw0JufgeFdMq2SOSK5LHE9CeZlh+oUEk5mHxloqyk7l
T3Kjijtsx1zcn0/Zto3yTIVLv5YkAozGIM9vFbFv+SThOQRMmU6JgqX/1OK323j6
bloK4WvNVIZ+dfTwP9i4OUtzbeChdVnC6oy6U6Shm0TpkfM4In9so9gaC5Vk4scP
sYkhoQ55uFedX9Y5qCpjR5dZtemQZpnwOqnvhxWhX0MHzhG/6fz0sstkAmNEscga
6sas+tO1Dbt3795Oo+AXG9whc+8byziBZHRHnngasORaTuAIoQ7QsBX1kmLkN5bE
+YBvsXTtNsvOE52BiaoCsiYGKT0HLIYxY3t6ZJWfHesgUBlTLmQ=
=mk72
-----END PGP SIGNATURE-----

--ey/N+yb7u/X9mFhi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
