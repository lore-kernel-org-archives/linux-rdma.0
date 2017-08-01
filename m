From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next 01/33] Revert "IB/core: Add flow control to the
 portmapper netlink calls"
Date: Tue, 1 Aug 2017 17:10:23 +0300
Message-ID: <20170801141023.GM13672@mtr-leonro.local>
References: <20170801120536.540-1-leon@kernel.org>
 <20170801120536.540-2-leon@kernel.org>
 <20170801133832.GA11812@ctung-MOBL3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2XUWoe1nmt7t49kG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170801133832.GA11812-TZeIlv3TuzOfrEmaQUPKxl95YUYmaKo1UNDiOz3kqAs@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--2XUWoe1nmt7t49kG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 01, 2017 at 08:38:32AM -0500, Chien Tin Tung wrote:
> On Tue, Aug 01, 2017 at 03:05:04PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > The commit cea05eadded0 ("IB/core: Add flow control to the portmapper netlink calls")
> > changed netlink to be blocked for all RDMA clients. This workaround
> > worked perfectly for portmapper, but is not correct for the whole
> > NETLINK_RDMA family.
>
> Leon,
>
> I've already told you I'm opposed to the revert.  There is a patch that will work
> with your usage of ibnl_unicast() but you chose to abandon that discussion on June 29, 2017
> (RDMA/core: Add wait/retry version of ibnl_unicast).  Either you step up with good sound
> technical evidence to convince me that patch won't work for you or you stop trying to
> break existing functionality with this revert.

Chien,

You never explained us what exactly your original patch fixed and why it
should be fixed in kernel and not in user space. I saw that our
discussion wasn't useful and brought bad blood instead of good will,
so I stepped out in waited for RDMA maintainer (Doug) step in.

I never heard anything from Doug on the matter, so proceeded and
resubmitted it.

Thanks

>
> Chien

--2XUWoe1nmt7t49kG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmAi88ACgkQ5GN7iDZy
WKe8zRAAgojGCPCfGJuFO8idCtWsxXaLPgV6xdczsmijT74TiQWS5mNIK8t4nXZS
7p+IHDgVwn6GluA6uGbUPi0p6abpkjzeOidNfYBgezbKvxFy1ZKrRJ6yVkcVCzer
HWmI5fuhC0Q9/IR+DKwRsI4EZbp6geBrVFSclMfYdvDf65afNFWfHPLmb5ApyP8z
zOyAVG1VhRa9nS6l6Ot27d/s0n40fv4d7qFVeUx4mOT00ZF+1aAoNG+Oza5dc7E/
ECaxc+jXDf+9rcUZSAj3H0+MiGy9v601I8/Jxm5URba8cJ/WVb3UhfjVm9zCR2Ip
WD9WuyGFuegPUOP2InTC+VC7/T4PQP1Vu8QKl6d9hZ18YsGpyJ3tlu6fV34AsV4B
RNp5VsMcmSu0tz3ou52Bc+f1jnhg5czbYtrxETLzqWLVeXpaIklnwuBE7ItbmCpP
jwI6NPzbnSQAoWoSRJ7Hvcd1e/HDGatrCynqI7kjgWDFRNcNL1Ue3U/0Z8JthgRs
e+/G/Wm38hD6jq1msZRiUNPHLDmgsOFe6FFsoKSpFlxNKGx3q733z1bHLCvDVCTL
NqiYim1nOV1pWAZDMW3F4pBPrvvVcQqPCoJaxRhil2I6ENMssmBGbBIVtYfi0rpn
QzG+pcmQFJB8DSuZI4JBu7dY64PZPXgaiuuPJf2kQiohakb0sWA=
=q5B4
-----END PGP SIGNATURE-----

--2XUWoe1nmt7t49kG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
