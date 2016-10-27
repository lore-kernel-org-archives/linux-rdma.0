From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] Avoid possible hang on device removal
Date: Thu, 27 Oct 2016 16:56:21 +0300
Message-ID: <20161027135621.GG3617@leon.nu>
References: <1477438557-15884-1-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AGZzQgpsuUlWC1xT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477438557-15884-1-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--AGZzQgpsuUlWC1xT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 25, 2016 at 06:35:57PM -0500, Mustafa Ismail wrote:
> When we get an RDMA_CM_EVENT_DEVICE_REMOVAL the cm_thread will
> exit and because flush errors are ignored the cb->sem may not get signaled.
> So just signal on device removal event.
>
> v1 -> v2: Add Fixes tag
>
> Fixes: 612eae1f6fe3 ("rping: ignore flushed completions")
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Thanks applied,
I changed a little bit commit message, please take a look on it.
https://github.com/linux-rdma/rdma-core/pull/28

> ---
>  librdmacm/examples/rping.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/librdmacm/examples/rping.c b/librdmacm/examples/rping.c
> index ad38f6d..53c1525 100644
> --- a/librdmacm/examples/rping.c
> +++ b/librdmacm/examples/rping.c
> @@ -224,6 +224,8 @@ static int rping_cma_event_handler(struct rdma_cm_id *cma_id,
>
>  	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>  		fprintf(stderr, "cma detected device removal!!!!\n");
> +		cb->state = ERROR;
> +		sem_post(&cb->sem);
>  		ret = -1;
>  		break;
>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--AGZzQgpsuUlWC1xT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEgeFAAoJEORje4g2clinlt4QAJFQHIQnzaXC2smSgAq0JkdE
mgQYgzUOQ9TtQ8LLaZJLnCWTJX6xg17HIdJxzN9rUAO8zTWOx7TwBQLbgQrZaRDE
MIAWQLvzuZ9tXMeV8KYTBWj20fmUOVhqam1PoFuuTbdBje36VCvexDnaMgjZVY5F
AEQ6/68po5xwOCoaitrf1VG0KuZzZoC0MKkYPvqzbVouIN1T+NsMNUPSfKfcY02O
MoYDLSGAagAFFeftTJGko96N1/PB5lamzRgIGD0QTEPpfwmx/Aav3vc7kG2CSGY0
gpj57D7nAVtwxELEwjNyxK2VI9qX/TrxU9C4DlsEclC0jkUIzVcAQ2148oM32UQI
Gl0ZQ9vA0CvY/To2hMHDaHZdH/7/m+tfbhWq0F+rYsT/svh298IOvZ/q3n0t7Rir
L409ZWZ1B3nxjKS5no6SkSO0O5PP7G5VoeUj5xWQzxzeLnBcpMWJr5u43ey5lnhu
5MNYm8k++vogtClakjLUD50G60wLGPeT7ftj3if/xVr6iNOjmBZA1pCesDSexm72
At/zEVLa0LvGf9ldj3Gl5+BfF5vsCZpygEjwAfWsCXmPo/t4Ks/Akk0mTKgUnzgg
77X1qyjDJXh5CK0sz98dNvG0whJWzETVO4FuNpGFEzilEYk18ttcR28NEG/5LF9D
00m+GIPEdeZtUO6nQnfe
=cF+W
-----END PGP SIGNATURE-----

--AGZzQgpsuUlWC1xT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
