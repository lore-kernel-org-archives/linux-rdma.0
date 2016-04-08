From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RDMA PATCH 16/16] i40iw: Adding queue drain functions
Date: Fri, 8 Apr 2016 03:46:38 +0300
Message-ID: <20160408004638.GD20252@leon.nu>
References: <1460046664-552-1-git-send-email-mustafa.ismail@intel.com>
 <1460046664-552-17-git-send-email-mustafa.ismail@intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u65IjBhB3TIa72Vp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460046664-552-17-git-send-email-mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--u65IjBhB3TIa72Vp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 07, 2016 at 11:31:04AM -0500, Mustafa Ismail wrote:
> Adding sq and rq drain functions, which block until all
> previously posted wr-s in the specified queue have completed.
> A completion object is signaled to unblock the thread,
> when the last cqe for the corresponding queue is processed.
>=20
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

I want to bring back last conversation about need special function to
drain QPs for iWARP devices.
Come on guys, it is already third place there is the same implementation
is introduced in last 2 months.

--u65IjBhB3TIa72Vp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJXBv9uAAoJEORje4g2clin6f8P+MHIm4sYSU8AGjI+6SnO3aFk
4tnCEUZBcpRKQ/+jlK51pUjAfTCVB4G3jyXYNPqehBc0UDmZxlHl786lD9RPt7UA
GqVzlv7dDE9obfrzGBJ6n+obBVMt2vvD5FiMkCVyXiKiTqeVpMbe7zU80vFHYGvc
+hqeKbwSO1AwQPQQUC4GSW6q3zrxtVLAMoF7AIHkklQlI9QDpFxXstX74CctJqFF
/lZvr0YS1xx9F1HhdWmD9l2ENCYTKuG4cFNBvB0FH3rTw1gECzFiuYSx6AfhlJjy
zzPDRwSAg4M07t2uEBe/Ldue/pVbIpaeo3O1WwXZSjLQlDI9rTL43For8l2DDucd
bID+FC1ZGwyPMbyQviuKyvI94ORqkmYDnxVF8PRlK564FVG0p22dFFPRRYAsA9F8
Ds+9/TGe1g8D9U3YWaHETdAGDi9e39e8bqfDpEsZ4lFFll4+TvTa+3chgfz7pPGq
KiJ4tzWp6RWDIdqBp2//X8YP6emtyr+lTT9sOOQr4DspXazgPvPgjinPBaAng7LE
ECbRT630G/TS2Hu758CiKjOECfr9VkoxjR06fmDZSrmzEac6sw6XEmipK+DNTet3
yzkGjfpBqOQJQeu1fBLnfblGqJW2upOjauXnEEofXhBoxy3L96lOuS5o6wkhRwPR
P7d8U+keUuPEM75x97s=
=Sr/h
-----END PGP SIGNATURE-----

--u65IjBhB3TIa72Vp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
