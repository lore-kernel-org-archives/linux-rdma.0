From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Sun, 28 Aug 2016 21:26:13 +0300
Message-ID: <20160828182613.GP594@leon.nu>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828171758.GA11719@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MWF3YmTHhoLNIVQC"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828171758.GA11719-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--MWF3YmTHhoLNIVQC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 28, 2016 at 11:17:58AM -0600, Jason Gunthorpe wrote:
> On Sun, Aug 28, 2016 at 10:58:32AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > By Mellanox HW design and SW implementation poll_cq never
> > fails and returns errors, so all these prints are to catch ULP bugs.
>
> Eh? How can a ULP cause poll_cq to get errors?
>
> Are you sure these are not driver bugs?
>
> Why can't you just print and discard the broken CQ entry?
>
> What should use ULP do when it get EINVAL? You say poll again is
> not correct, so you suggest a full QP tear down?

See patches 4 and 6, they completely removed these EINVALs.

--MWF3YmTHhoLNIVQC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXwyzFAAoJEORje4g2clinJxMQALX3ALkGVDz+izH6DhvmlSqm
WtxCKY30EwmryJzUINSvfxaio2BsXwTs1YTpuKDkeMciF//J1SGYKq6bte2QOYqS
NpaG1Rbs6SpOCSxpur0WANSBi/aBYurvB6QPiy6kNbN8yFQdMd1A9q6VcIuti1yA
2VbcSwk6C6nw7/+hpP2T4/mrEj6PF6Iya+9kgIkMTmevMcIGBaE1GqZh6ODEayl6
bRS6Fc3xi2RYq9W/BXpHZYSXSPW9eycURq8b9r8yFehuV+bt4Ra1GgLwysLV7YFP
AP9VrWwPOdxTiZO0jepcFHTPq3ScZDWDlr1w28hVL5rVPnYkbYZViIyx3xwajIEV
mitfJiMrVlaPn2q8njhnHctSqySdo8iaa4s2pk7wW7p48UwSw6AADDdBV5VBqULm
cyI7j9Oj6loZfOjT2j5jEHkxTSfyEwzsPLejylAFSgZjt4zIjoECAJbNG4oGT027
MdfqaNsH0X8Pv/MYgyKc7VQt0BbRRJd449MqvWVz8I3Ze05v21roUuVswiE6crOO
Zg9TTOaLmRLfHQgxTgxQkif5kUjJPlibsgcpV5mkN5iRHk3Si5wjNmwSCPGy9MeT
zjW+uxgR81ekhx9wU5ywm1rSReMk0OCwLSlujHLTZEwBAXOndrroNW91xYCyJqhH
RJs8IHrfYjEZ6edKSKox
=ROJS
-----END PGP SIGNATURE-----

--MWF3YmTHhoLNIVQC--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
