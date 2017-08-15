From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] rdma: Allow demand loading of NETLINK_RDMA
Date: Tue, 15 Aug 2017 12:20:01 +0300
Message-ID: <20170815092001.GP24282@mtr-leonro.local>
References: <1502744259-16966-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1502744259-16966-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9Dz7ZkHOyZKsJidB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502744259-16966-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9Dz7ZkHOyZKsJidB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 14, 2017 at 02:57:38PM -0600, Jason Gunthorpe wrote:
> Provide a module alias so that if userspace opens a netlink
> socket for RDMA the kernel support is loaded automatically.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/core/netlink.c | 3 +++
>  1 file changed, 3 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--9Dz7ZkHOyZKsJidB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmSvMEACgkQ5GN7iDZy
WKfObxAAy7AnGbZ0wYdUlyvC6TW0000fDrNZ11vajFguyTRRgKV4z0c2bYGT4ASV
RRjg4w0vegbDyt50gycaxGybk1SCe8AddHtFdb+iIbH6kguI7uGSymMQ5stkMcfy
wLEUkLIfkNRzARmwGcvnONiAc2nSp/mfnuVmxj/lHcrwOtpug8n6DB1Uky0JQQJU
7qDLZpgVL8FpERS+pnedA1anAXrAhWbJCngSJ88vTFyRXg9MWSKP6djMp6svHGOY
eefbFeykpKm5tgPeuqmOKqbCPohVlZ+B4RtLjakdrYI/vEvEUujVJzZIjFCxMOuD
1C+vOgKk54OwB11hPo7TkJGLzDjHmzA5dxErLZUc8ZtWeUDwqPJ2A3FCEHpk0j04
ik9kabw85Xm3r057UnSRwrSPeV0LOjzA4RFG+9WbsnYjOcabesVq72pD4GJBDKeF
Fc5wQ5hnnaGIXB5SBPh7NNos/3ytWmuAIfHjsYPjq2YZONUPi4seDz9xnwDBM1kt
iQ1CGsNWfLVZJwsLLV6vsGMeC1AKSt7Y8YpVGPnV6sp4Pe6zCJOc0V6rwY7l2ACV
niuWomyKpglOIWmzM0yRuvVp2TGAn3kT7DXaH3M/SFTIlTFDE0u9O705SbpW8T3K
SuKi8sYx8EIjn2S+R63heKaIy2reIHxxHQak2iK3qZyTyzE8o/U=
=ZC/T
-----END PGP SIGNATURE-----

--9Dz7ZkHOyZKsJidB--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
