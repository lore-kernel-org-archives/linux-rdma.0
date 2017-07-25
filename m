From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Autoloading for RDMA netlink modules
Date: Tue, 25 Jul 2017 21:19:51 +0300
Message-ID: <20170725181951.GT3259@mtr-leonro.local>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170725063236.GQ3259@mtr-leonro.local>
 <20170725143420.GA434@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PETIzWh8d1Msfd+P"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170725143420.GA434-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PETIzWh8d1Msfd+P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 25, 2017 at 08:34:20AM -0600, Jason Gunthorpe wrote:
> On Tue, Jul 25, 2017 at 09:32:36AM +0300, Leon Romanovsky wrote:
>
> > First, it interferes badly with my RDMA netlink series posted here in
> > previous cycle and I'm expecting to see it in, so I can move forward
> > with RDMAtool implementation.
>
> I'm sure we can fix a few conflicts...

It is more than a couple of conflicts, the implementation will be
slightly different.

Let's wait till Doug creates for-next with RDMA netlink patches, because
I assume that 2 out of 3 patches will be completely different.

>
> > Second, from brief review, it is unclear to me, how do you protect
> > autoload caused by regular user who sends netlink message to ib_core.
>
> You don't, that isn't how kernel auto loading works. Any user can
> attempt to create any kind of socket and the core kernel code will
> load the correct module to support that socket. That is the standard
> way kernel autoloading works, particularly for net families.

Ok, I'll take a look on it.

>
> > Third, it is ib_core who should autoload modules by default, and not some
> > random daemon in user space.
>
> Kernel autoloading of userspace facing kernel services is always
> triggered by a user process attempting to use the service, so this
> comment makes no sense to me.

My concern that "regular" user will trigger "admin" operation without
any checks.

>
> Jason

--PETIzWh8d1Msfd+P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll3i8cACgkQ5GN7iDZy
WKcbJw/+M2PKkwvuheEbT2EKOPs6AuP6MabUwgTPAt78Mj+oviJDVkiMDVQZH909
dRjs+Co1srZPak0idYfsIKMfAksDF20AwS6YjZTkT1WlNiWjr2K7/ExhSiKAW5qW
cVrCsFS+cs79TW+DlFwDJ3O/xhQmgGhhaKMDmWWNgYz9kEpWxY3F8Ktw0takjeSw
AaT7Lu8lMVy8zNtzZuh8jfxS2g/uX8puPOJgi9r0RdxvfwOkzpjChPMLoP0JAZcZ
M4SeyhG68IJTjrgPgFZ/cD1jKN0BmLPleagzg0tTcdJiNhy2DiGczTeQXqT686VS
BuRGhyYqBV4NTI/5fetGDOBboMJICpLEjpR8ve0tjFL+8VvNAWMqbIE3Lc6UFFSk
RQfCj6gSFSecURlUR6sVmjoduPobp+fR85T9nNxMLWkLYo1mV8TXW3yIbbBEam20
vJNBEXN1HoyUcGfPxH3LOgzh2P2LJmkR+8Ypjly1mpfHvpNrux1bNLIHeKu5Rdg7
/v/UFNlUz7CE369DQBdMfqttvjB8oaLePKLXB4QbGzHrU7t6mcNMRDxmpgv5GfZE
oyja8RYGVOlLlwSQN+bRFQwoxqB8kZxknUhjj/Q7B9afJVBWx6nDGcZEEnhCRcZG
pWmAw9shwLFEFzqSstA3HJKaYYtjE36zeoN0wNcf7WVfzX6PDfw=
=Hgt0
-----END PGP SIGNATURE-----

--PETIzWh8d1Msfd+P--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
