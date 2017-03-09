From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Thu, 9 Mar 2017 10:42:45 +0200
Message-ID: <20170309084245.GX14379@mtr-leonro.local>
References: <1908657724.31179983.1488539944957.JavaMail.zimbra@redhat.com>
 <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
 <20170305081206.GI14379@mtr-leonro.local>
 <20170308154815.GB24437@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hOmQO3H5Qmmwdmk8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170308154815.GB24437-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hOmQO3H5Qmmwdmk8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 08, 2017 at 04:48:15PM +0100, Christoph Hellwig wrote:
> Why is that system using swiotlb?  mlx4 really doesn't have any
> weird addressing limits, does it?

As far as we know, there are not.

--hOmQO3H5Qmmwdmk8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljBFYUACgkQ5GN7iDZy
WKcgkQ/+Itq1N1t216O5JxBslXU5EWlx6Ig27BdDLoCDgNA1+NsNSrVsNvbvM4V8
wDSOd5xET3B3qxWY9+iQt3fL9KuzkZHbI3A3AtZaMHCLMHnL+S3KsnfCgjZzUyzH
4PolS1tfMSrIueGqvomHoTPrV+j4BwnfInclWRBsqGQiPwJzW47HgJnihTEM7jh8
gcf7UH45ybjTPc9337e//ekbw565HEfgGFlM/AfQK+PF8ndjwHX2oW7GDlT4Hc84
h2dkSrYY+GHmY85v+Caqw3M4gc9vaSP0FPRNH3VPJsUjrm3Swuk3TDHmx06SQ8JD
/bz5sjvLaMPfXcZdMqYWjG2ewpgs0aAx/Jb/dUddPVom5iV1eGheFkEqG7tOiJpp
NYLIYyQmJ0RokxAaQCO5rt5BqMFPNeJKZ3pihzPi47zKsQdhOr8irt/B7XNl/JhL
dFXmDmYm23Wxw3jOkrZH60YGMMLseORuTlx1PpZnp9X+p+9qIYknludMtpbOZWo3
JIjJpJ0EM14CM3RZ/4bG1msD6n/gLW0XsBYVBHoPQ8y2cWSbp5jTdGAPqQsi5yKr
A89SGAe5RsXwK6OXo9/B7noJQuB8MsjNPPeW1macCOO75mU/LEUFi7dwAdvYaYQH
EEMhB0LHp5w4RYT8Cj7/SV9ndGPt9GRhGOLOUSL0ZwNpz+RCE8k=
=5obz
-----END PGP SIGNATURE-----

--hOmQO3H5Qmmwdmk8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
