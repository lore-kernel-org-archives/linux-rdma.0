From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/7] IB/hfi1: Eliminate allocation while atomic
Date: Mon, 9 Oct 2017 22:57:03 +0300
Message-ID: <20171009195703.GG1252@mtr-leonro.local>
References: <20171009161736.6965.75352.stgit@scvm10.sc.intel.com>
 <20171009193817.6965.44567.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="7lMq7vMTJT4tNk0a"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171009193817.6965.44567.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--7lMq7vMTJT4tNk0a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 09, 2017 at 12:38:19PM -0700, Dennis Dalessandro wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> The PIO trailing buffer was being dynamically allocated
> but the kcalloc return value was not being checked. Further,
> the GFP_KERNEL was being used even though the send engine
> might be called with interrupts disabled.
>
> Since the maximum size of the trailing buffer is only 12
> bytes (CRC = 4, LT = 1, Pad = 0 to 7 bytes) just statically
> allocate the buffer, remove the alloc entirely and share it
> with the SDMA engine by making it global.
>
> Reported-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Fixes: 566d53a82644 ("IB/hfi1: Enhance PIO/SDMA send for 16B")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/common.h |    1 +
>  drivers/infiniband/hw/hfi1/verbs.c  |   22 ++++++++--------------
>  2 files changed, 9 insertions(+), 14 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

--7lMq7vMTJT4tNk0a
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnb1I8ACgkQ5GN7iDZy
WKduhQ//QIOJxDGkGlz7I6HdcJ9Nw4oEPV3RZVt8JH4Xn2uXVpVB/bXSrM0Fmv1C
lE0ZAuwDHf3UKzN7DCl0UUJ/4Ra4zrezuhu2i6A3PVr2O8FGXdr0i6+XRH6F0BPn
sCJX4hzYkzyTJ/waaZ1D3falKSk9jI9PpqhBiCA+NEwn3DLahoGk+mbBUEBUH3gF
WE3paexnFNaiGO51kRjYR2Ak0EoRMT3h13/FUEF424OlqlMP3oDfTuYpXr34YW31
HWctEc6qXptpfNIrnZ2Hjy8If/V3bCggQDK2ZadTdLP3RbBYbyfmhY/exPUBW2l2
tIzsAAGYoeHaHpD8+Y839Ck/ik36ECfGwDJ1BVpaaiC5h5RhwT1NEqvlTXPgOJs1
o/UwXxZTD5+ejT/K2oVLC266KM+zTLbDoSr4DzM6/PnMtM5+JEWKg9vAZtKLStwP
8R4LzGpLGpXyvYFuEArYz4raJWJqYmJsbrPJMIFsXLOd2h6I1CaDD/I3iR1NYO3l
eKPQJ24tazMkx+VakYNWJ+9ENqHy+uWUC39u2rrVm7KDhOJ/Pg0eM8Y+p03+gLMw
0E2rGzwkPOAMVMB1O7qDUMkkAoGsglspYX/EncyA4AN+BMLM7Ypi3RQlG9Wq3R3D
e6PHWC+3Glogdu7i3xWLRKvsAdszpzly/Z+fH/2MSRFCKycG6Vs=
=z9AW
-----END PGP SIGNATURE-----

--7lMq7vMTJT4tNk0a--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
