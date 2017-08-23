From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [for-next 0/3] Add congestion control capability
Date: Wed, 23 Aug 2017 19:26:01 +0300
Message-ID: <20170823162601.GR1724@mtr-leonro.local>
References: <1503402587-24669-1-git-send-email-devesh.sharma@broadcom.com>
 <20170822123246.GX1724@mtr-leonro.local>
 <20170822151143.GB1201@obsidianresearch.com>
 <CANjDDBhGoMRZr5vptGRoKZetjNawomXeuHM5XorCu0XG+RzYAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H/P/fp31Su+ob3Cg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CANjDDBhGoMRZr5vptGRoKZetjNawomXeuHM5XorCu0XG+RzYAg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--H/P/fp31Su+ob3Cg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 23, 2017 at 09:15:24PM +0530, Devesh Sharma wrote:
> Hi Leon and Jason,
>
> Sure we can definitely use this tool now or in the near-future for
> controlling most of the device tuneable parameters etc. I am still
> catching up on the older discussion related to this topic.
>
> In the meanwhile I wanted to ask about the availability of this tool
> in the upcoming standard OS distributions like SLES/RHEL etc. Do we
> have any timeline for the availability, in which version should we
> push/avail this tool?

It is part of iproute2 package and will be available in all OSes once
they will upgrade it. I'm pretty confident that it will be available at
the same time as this kernel version, because these tools are aligned
with kernels.

Exactly as your feature is not going to be back ported by distros, they
won't bring new iproute2 package to the old kernel.

Thanks

--H/P/fp31Su+ob3Cg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdrJkACgkQ5GN7iDZy
WKdFxg/9EJyjRhh9Gis0pZjLr4xL6I0UGdTG/xD/3vbnlfCMXH6GK3asDfCF/AT9
y3mLGZaa8Abu23XLcxUdCu5FM2Jv1lblhhvQ7TCWgRqTASHIv3tQ3NU9OE4m9LsS
DPF31MnZjR898RL+OZXzsPZycIJJgb/xVzgDNwgW8EdsiIuZ8i8i/Ngop5x7oAWA
US2qKESgioVqLBsQr4imav1L+JOXhwfIg9EF+Hdp8H4BUDSdjSeOvB5hzE4LaPgf
C8z1ovB3aYXO4BxI1sx0RcGpM7zPz8/yUexqyZDG3xUjG+zerh810f1efMs0QAE2
iATcSPqywDYLoU6gdU6CkU5IapgnSp/FV8Rdf61Qvero7ENf3VX3//BW7Dtko4xA
DZDW+uSwpikhcXQA0KrQjAW0rQvGjZvREWzmKzd3iAziOa26TeVJ+45Mavmf7yi7
lYLAARVmcfv42Vh0nVGiPdoSX8ptFLRAgD+YttxiVxCBoDvMQfI4blcbnRtDdNod
PCTCJYwssCGlNj3XSJbAH2gRAXMb7HpiGSUGmfJZ/YXr0uKXtDydrJZCyeaU7AW1
cSHH9Ase3jU/ULVbXjQCXrz+6uzH8Z5ior3WjS9wuSP1zHcBUFvg3uAxwvFss2//
xCyCqSwmhVqf8/FfNcQuCaNzmQFixNwVjFknofsLKGcIFfML25c=
=AIRj
-----END PGP SIGNATURE-----

--H/P/fp31Su+ob3Cg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
