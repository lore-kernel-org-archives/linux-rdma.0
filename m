From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma-core: pvrdma init issue
Date: Thu, 19 Jan 2017 16:48:17 +0200
Message-ID: <20170119144817.GU32481@mtr-leonro.local>
References: <b13a0a91-f93a-1072-0e5a-e9841660cf00@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LPPXYCo+p3CMOj8U"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b13a0a91-f93a-1072-0e5a-e9841660cf00-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--LPPXYCo+p3CMOj8U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

And now with correct email address.

On Thu, Jan 19, 2017 at 04:05:36PM +0200, Yishai Hadas wrote:
> Hi Adit,
>
> Working with latest rdma-core stuff that includes the pvrdma provider,
> encountered below issue, would appreciate your input on.
>
> While libibverbs loads the drivers there are few "annoying" warnings that
> are printed from pvrdma per uverbs sysfs entry coming from
> 'pvrdma_driver_init_shared'.
>
> "pvrdma: ABI version 4 of /sys/class/infiniband_verbs/uverbs0 is not
> supported (supported 3)
> pvrdma: ABI version 1 of /sys/class/infiniband_verbs/uverbs1 is not
> supported (supported 3)
> ...
> "
>
> Similar messages basically appear in other drivers after some pre- detection
> that the sysfs entry relates to their driver based on vendor id, device name
> but the ABI is not supported.(see mlx5_driver_init)
>
> In the pvrdma driver you are using the ABI version as the detection and as a
> result print some redundant/annoying messages into stdout when working with
> some other device. (e.g. ibv_rc_pingpong -d mlx5_0).
>
> In addition,
> Can you please explain the detection logic itself ? your code chose the
> value of 3 (i.e. PVRDMA_UVERBS_ABI_VERSION) with some comment as of:
> "We support only a single ABI version for now".
>
> What if some other kernel driver uses that value as well or in the future
> you'll add some value that is already in use ? It might cause that pvrdma
> user driver will be used for that device without a real plan by the
> application.
>
> For example if mlx4_0 will report same ABI version the call will end-up with
> an ib_device having below information:
> "dev_name=uverbs0, drive_name=pvrdma, name=mlx4_0"
>
> Yishai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--LPPXYCo+p3CMOj8U
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliA0bEACgkQ5GN7iDZy
WKfJFQ//a/OXOPPc/kTKHPrleVvgCT6KwDP9hxtVD2pFg8f5py2dili/6vCdCDsA
xPr9n1a7aVIaTtMdyzlUCea0ENoPJYk98JHZ/DDoZkC5Ky7hSCh8PTztAmM/TO3Q
rmp063TUykceOjAwYaBHtdIlEd926n20Ly26ZxKKQKJWR2Xu3IGUV7ivCblzlWKb
x3A3JeouR779jDGGsFEKGGVahgHIEBoZ0dp1+g6j6hq/87/V7FfkzniursKFvTBc
SaJLcXb6ckt3r4SfgKNIs4C+KBjXQzAq1l8PqXmm0auOCpQvU4cQ3w7X6Ml5v0Lt
lNNUYQFvzAyOl9BHd5styZjqn5c+HRpPUW5ZECHQ92ZgYiWJD7Fki/Z65J/2nktR
sSbfhlFvjf29uJPJP7pDtrRidZ+yBH5eu3g1bYi9wlPONMhZGOuK9DPXM0VlndPf
vGR+J3BUUTsbnRQgvHZQ0LijQmJfxfmzGwQcNszdTaarKqMh5xrPiS7NmLlZHSYr
bbdXJzxZCjAgrMq2XvtVaLMDNpI5jYS80y1fvv3TX2zcreknJdLR/wLiGqI/Q/2T
Xbs1XqrnsKtp5uWdyfUugw3kObFihfDBWu/2NSVoxUaUiwHY5KgtwXfxzRwewxzP
5eKYEY7ZqfwrHjlxy7W8hjmbQniDciag4Xc23YcEgVhYJ+nLywY=
=rOqO
-----END PGP SIGNATURE-----

--LPPXYCo+p3CMOj8U--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
