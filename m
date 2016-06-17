From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Properly initialize GRH TClass and FlowLabel in
 AHs
Date: Fri, 17 Jun 2016 19:41:38 -0400
Message-ID: <8aa210ca-6d29-b400-9260-d2453ce6f6c8@redhat.com>
References: <20160608232829.GA27363@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="coExpuftloP7OMDOdHj6eALCVlvdAUu8f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160608232829.GA27363-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--coExpuftloP7OMDOdHj6eALCVlvdAUu8f
Content-Type: multipart/mixed; boundary="BEgdAmTKMbOQ5M42OWU1EmKL7ciSEmVTL"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Message-ID: <8aa210ca-6d29-b400-9260-d2453ce6f6c8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Properly initialize GRH TClass and FlowLabel in
 AHs
References: <20160608232829.GA27363-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
In-Reply-To: <20160608232829.GA27363-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

--BEgdAmTKMbOQ5M42OWU1EmKL7ciSEmVTL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/8/2016 7:28 PM, Jason Gunthorpe wrote:
> When this code was reworked for IBoE support the order of assignments
> for the sl_tclass_flowlabel got flipped around resulting in
> TClass & FlowLabel being permanently set to 0 in the packet headers.
>=20
> This breaks IB routers that rely on these headers, but only affects
> kernel users - libmlx4 does this properly for user space.
>=20
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Fixes: fa417f7b520e ("IB/mlx4: Add support for IBoE")
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--BEgdAmTKMbOQ5M42OWU1EmKL7ciSEmVTL--

--coExpuftloP7OMDOdHj6eALCVlvdAUu8f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXZIqzAAoJELgmozMOVy/dGzAP/2skKGTBPopZgHMNp+QJf7ba
L6SXYzQFnzb57yjoEvIEy85cFfD2el/Uxb4zBgnAhboeuY30TbQaMN8MEjUiD6qj
GBerPH4hjwDyekGijc+NyAtQiWqh7iSaR5lxIJnFeInM750Z1LSfQ0INROb0sh4s
FejwCtMF8QTxh0uQy1OIshfpExXzmiwBInFuvJWzbsEsP8Vn7o84ykiQUkscD+ic
Sz6GFE/3uDpOzg+vV/N4kfYT0BhmP4ouUUBCHRQWYV34eMWtLJudn3PTLlp6tacD
D8wsJkNJeY6vwOJqE3XMZ/voZUJwLKm5akv9A2eQ/sSp9z+OMzgTu2rIHE4TIgnh
iMzIzf19u7veU5boxIRiDBQ4vqRIEh3EknKT4ll5Zh8A+GbguO433axKPCpkb8iI
44u8sojBAErpQZoX1VKKyH7RswwMGiSbFhckbC4QkfdYpJbJAWK1jZ9Ms7sVNy8N
wy2/X3SEOQh9SUBWqIdlSnJM1fUMd+Y8Gd9zJLPfErTnZFoYYvUmBQnmblsN+5CF
38JFvc7qa2VYDsWat9GVPLSqbx4bjttK4S6U97qAcLMGVQBCsehJdsYikbA/SJsp
r9GmbQzlAIy3vEgmUBtIYwgpbNNfzlQohCOcRJ13TDLzSEVrAQlUJX68Lmkn9XlY
w7HQBCG9BmW3P5rvxkEy
=dDPx
-----END PGP SIGNATURE-----

--coExpuftloP7OMDOdHj6eALCVlvdAUu8f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
