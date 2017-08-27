From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] verbs: Encode the private ABI version number
 in verbs_register_driver
Date: Sun, 27 Aug 2017 15:12:37 +0300
Message-ID: <20170827121237.GA12880@mtr-leonro.local>
References: <20170824215601.GA19717@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170824215601.GA19717-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 24, 2017 at 03:56:01PM -0600, Jason Gunthorpe wrote:
> This causes the symbol table to look like:
>
>    208: 000000000000c000   142 FUNC    GLOBAL DEFAULT   13 verbs_register_driver_15@@IBVERBS_PRIVATE_15
>
> Which encodes the expected private ABI version inside the symbol name
> as well as with the symbol version.
>
> This ensures that the ABI version is checked even if the linking
> environment does not include symbol versions, for instance if an
> end user is linking a provider static library to the system dynamic
> libibverbs.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  buildlib/config.h.in         |  1 +
>  libibverbs/driver.h          | 11 +++++++++++
>  libibverbs/libibverbs.map.in |  2 +-
>  3 files changed, 13 insertions(+), 1 deletion(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmitzUACgkQ5GN7iDZy
WKcgaRAAn6o9VclYtDMsF2NH+ZjD1ekLu1QrFzwzHccnYjgWNluCtR8L+RfpkaUF
dNGp3uBj3SCR0V1VgKFbFPuTRcneSu//1YZrBHrwP1ZW/ILpjlcXaovyehqSupdh
BqnwYwCLMlC1mFTNc1RDU2jlH4G4PZZgC9zfxB0kTy92mx5ZBskRc9Q48KZ4QnEm
afpIPv49oHIkN/3+Swdi3Y2C30C1Uw4Y1wfte+kR26fou5Ygoo6IvLOCOlCN1a1/
vUHg/EnH07m41wr6eEtDiJGnG7B1PRNs7QC+ur3yNQSE5imE3JIkuJYmiKySBsoD
paSedzsZA89yfX7rdwW4OMdK4KRCwNCCwlPr1mAIMN+hHbb8Qy+xx3yae7inYaRB
zxANyS5w80WYE3RBsOOhHq9mJmo6Yjy1UABFU7DIRvVdaFFw/UAaHmb4RlyKaxRy
Urpf2IYhniQiuleHKpUMLRRHqbZYd7sH79uEIr6lPt2zXozThkP0gJ8xeaFZyDzE
3KZrsM1iQhjy5+eqHNfUSjTYz0iwfvXtPS+JjuAIjSaeXU8Vtp8GNqbptqiHWnam
XA80/L/A8V04gNvJkEOBizhTn9vkWf/Pr6ozbvcxX89i32leJIEeLDmkOkXC1ckf
hCVIuOgNj1o9Dyh3gSHeCUDpOp13D1QDswGu0Wbn7QMAjm3fUCk=
=M0/6
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
