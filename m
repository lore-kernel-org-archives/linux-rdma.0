From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] iwpmd: Suppress expected kernel message
Date: Tue, 25 Jul 2017 16:30:30 +0300
Message-ID: <20170725133030.GR3259@mtr-leonro.local>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1500935204-6505-4-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g+nE7Lp8ucACtfsu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500935204-6505-4-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--g+nE7Lp8ucACtfsu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 24, 2017 at 04:26:44PM -0600, Jason Gunthorpe wrote:
> RMDA_NL_RSVD was obsoleted a long time ago, but user space still
> uses it to support old kernels. Avoid logging:
>
>  ib_core:ibnl_rcv_msg: Index 3 wasn't found in client list
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  drivers/infiniband/core/iwcm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>

This print should be removed, on my system (Debian), it prints without
any relation to iwpmd.

Thanks,

--g+nE7Lp8ucACtfsu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll3R/YACgkQ5GN7iDZy
WKeVMQ//VPK+joLDM6zRDakl5LWBBc3EgjxYc1UFEapIL2UPuf77CPjcqM0m3SfI
AiqsOPm40suayQeVZLTycSuzX/c/ri9NSFChtbKYspVSUSRcPZHlFlh31Kuu5Z1W
Sbzv9BAiYYjUa1oVe/4eYLAU9aiYFvsYhTavdZFGwvgejH/Bc2E85LxuNB0c/JtK
KfAwxOpCPcXfJbmvSIoM0HExkAhcQltJLAzGlVP8I6Y8R5h/u2wyE42JJYw0MnsO
wETd4KYB9VCmGDAUaZd0Tm+zweSXRjqeF6j5/JXqdiVm5rSXAcmA+3y7YmPoyCdg
RgyXMAbXtofWAgXtpfOkFDIEZjfEGfdkNOotBU7frqoT5aYu4oEnaqKmDGU7n5AF
eFUCLUAqn1cLYA/XysVkN11XlvFJA77qS+62sOOWgHP93JHp9+Vhvuy3+fqpyPEY
s2bHiLHW+Q1BuKvRRm5xN5NQ2fcHXfTbLo08ffPOafpUom0Egm85xhfK5/B4yzbd
04wZm3tUMAhd10sLC8ccYevdB0qHdiIkG7xYkgrJhDkHQ70DjRpf9TjS+igODV/2
53jDjW4XeABqR7gTyJ3ll/5YNpRmUqBHof1jDrBs6MPZ1CIkFFQqHz+8TBd+omkd
s9t4rkQBxybNH5MWhJomSVXnymTJr8wtDK7e5iLYMyetYi02wWo=
=8jzh
-----END PGP SIGNATURE-----

--g+nE7Lp8ucACtfsu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
