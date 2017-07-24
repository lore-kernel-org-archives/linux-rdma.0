From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: CFP: RDMA Microconference - Call for presentations
Date: Mon, 24 Jul 2017 10:00:42 +0300
Message-ID: <20170724070042.GM3259@mtr-leonro.local>
References: <20170615050305.GF17846@mtr-leonro.local>
 <20170720040739.GU3259@mtr-leonro.local>
 <ddcc4ea0-1df4-f954-973c-43f8e65b324b@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="te9Bkl2b4W0C+FfQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ddcc4ea0-1df4-f954-973c-43f8e65b324b-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--te9Bkl2b4W0C+FfQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 20, 2017 at 05:59:02PM +0300, Sagi Grimberg wrote:
> Hey All,
>
> > REMINDER !!!!!!!
>
> I won't be able to attend, but I'd be very happy if a group
> of smart people can discuss some random topics I had in mind:
>
> 1. Adding NUMA hints to *all* rdma resources. Right now
> there is no way to ask the core to allocate a queue-pair on
> a specific numa-node. Some drivers use the device home node
> for memory allocation but application locality will usually be
> much much better (sq/rq/cq spinlock cost *a lot* more if accessed
> across numa nodes for example).
>
> Applications that don't care can simply skip the hint (or pass
> NUMA_NO_NODE) and then drivers can do whatever they want.
>
> In just about any kernel driver, resource setup and IO path run on different
> contexts, so numa locality is pretty much always wrong
> (or right by accident). Its also true for a lot of user-space
> applications.
>
> I also wander what is the least intrusive way to add it.
>
>
> 2. SRQ sizing. No one knows what is a correct SRQ size. This leads
> to magic random numbers for SRQ sizes (often copied) pretty much
> anywhere used (usually crazy deep). Can the drivers hint applications
> what is a "reasonable" size? Can it know? What if I want SRQ per core
> or per numa-node?
>
>
> 3. Adaptive interrupt moderation. In order to effectively use irq-poll
> (or any other napi-like functionality), interrupt moderation is
> important, but its pretty useless if its not adaptive (always too early or
> too late). IMO It would be very useful to have, But before drivers
> can start implementing it, we need a good core framework in place.
> Does anyone think this is useful to have?
>
>
> 4. I wander if there is any interest to have a striding receive queue
> core API? It would be *very* useful to just about any existing kernel
> ULP. Who wouldn't like to reduce the frequency of post receive
> operations.

Thanks Sagi,

The topics look interesting, but it is unclear to me if ULP developers
plan to attend LPC, due to SNIA timing. It is hard to discuss those
hardcore topics without people who will actually use it.

>
>
> Cheers,
> Sagi.

--te9Bkl2b4W0C+FfQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll1mxoACgkQ5GN7iDZy
WKc0GA/+JHIVhz2zgz+Ivhh2O29FmjgzVZPL3+hWNovxNN4AAPDzOzpdr5gDifIC
8s3qKJ2+31uedYcdEFXwZXsmkvq7LRrBLinLcR2mCQo/M9rM848gBiF3+BoBpbtA
lLiWAZ3izqd6QUkDxtpOUW9NVDY77DLOIJli6hLXw4l+DzLb/zaw6v3tQkxil1Bn
odVkVbPiwstA4JjiALWKiN6MEUwGMc+m+tmlaZVFgvPGbMx6MyGk0Yo2Mq+LhUBP
Mu6mgy5LivJ11aNqnQc7J/BFj9Jz+wNvjX4fkMqM7x8Lk/jZ0NWlsTiDhoX+Nwn0
fylmQjN+gzwee9NzMhvyzH5/fhExj6vu/G5y6fBZA3ZXndeJUUT+UXCVIJr8zM/K
j3IGOndeFlgZ3FprAo8fP1hkHBbqdaPCtFmVaBznaW7U9lbsqz4bPnp6wn3LGn+h
aCqgif3GIQylaMFmZozqDVvEsb5xNWObxp8jMvhdsmPwDC4yI+wqJdzS6C+QIa9M
SSlbr9E277MoITPZnddkosFeIDtetya1fFuLF/jT34lLHrsPb19kHjgndTk3mY1d
fAbuE6DWEqu8sKOGGpnbJX0QeApOmW0111UsgkC8W3KHN9gH8gbWzq5OBj7m8wYJ
9yTjmkrpHWJaaiDY2XfxjTQlEqMcdJE2GaXUB9G/iGPOiiNMPCY=
=nlyN
-----END PGP SIGNATURE-----

--te9Bkl2b4W0C+FfQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
