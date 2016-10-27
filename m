From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ibsim/Makefile: Add install rpath to linker
Date: Thu, 27 Oct 2016 17:38:10 +0300
Message-ID: <20161027143810.GJ3617@leon.nu>
References: <1477576531-29723-1-git-send-email-ilyan@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HSQ3hISbU3Um6hch"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477576531-29723-1-git-send-email-ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ilya Nelkenbaum <ilyan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--HSQ3hISbU3Um6hch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 27, 2016 at 04:55:31PM +0300, Ilya Nelkenbaum wrote:
> From: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  ibsim/Makefile | 2 ++
>  1 file changed, 2 insertions(+)

Against which tree did you base your code?

Thanks.

>
> diff --git a/ibsim/Makefile b/ibsim/Makefile
> index 5d1ac62..ad94651 100644
> --- a/ibsim/Makefile
> +++ b/ibsim/Makefile
> @@ -1,5 +1,7 @@
>  progs:=ibsim
>
> +ibsim_LDFLAGS = "-Wl,-rpath,\$$ORIGIN/../lib"
> +
>  -include ../defs.mk
>
>  all: $(progs)
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--HSQ3hISbU3Um6hch
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYEhFSAAoJEORje4g2clinlWkP+gN8b7WqWGqcF4srPFb3E0vc
/B+LMJvs2tisLRMKzODbfWWU2eDmtfwAhrYNbIwftNUcF7qe/JYuV+nqcCTnWn6B
WQbMef/Sn7IXGn5Co9ZTy64LEm1rdyOJ26LUV1SR+NPgzEI6+IfV5yoGtG/lsQBJ
gHQGH6XP/reC3SWX5/CNzmFmGGMcOY5WuG/Pf2LQGeO4ipXUPdIuUsuqFNtRR9Py
nCrmNeRg2jhuFgIC9SZ0JZH2crj1GGtbrcYBF3Fa+8kNLsXB1emnRSCSWtPAJ1iI
XBPWUjbuDpvjL1t5CL4YFWjTS1rRzojWztI9FiHAo8kknIKS6/bFOxBzmt3lApO6
qYdW1+uiGlq0S0OyYt5epHZugZTY0H95GPa+ImyS/knvsrXZn9YxVQUuliy+RYRA
RFbv1PEBOMad47PaCNblWYnbABE57NqGYaK7gIM54VJmLGoCXvNQ3OPLYe6c1mCU
SF30KQIBMlfQAKEYQfc4i9L+Jv9XejckmdmZX6ZzwFn/d/zuW+tiHW7f52m2E4cE
ylPb4k/BTKVfCikLkJEfq/YRemH/Ba6qZPfsG67rIclSZ80kO3a0t04PscL77So7
FRqD8+WFgnW1v345e1FTCdp6OiNcI7c1h0WnquBSLQ2Vjb7s8sdK2g9e8AJrlSrA
Dvt+pCWvM+ibZfhxn8VI
=f8uZ
-----END PGP SIGNATURE-----

--HSQ3hISbU3Um6hch--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
