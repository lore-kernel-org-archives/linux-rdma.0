From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/usnic: Remove unused prototype
Date: Wed, 23 Dec 2015 11:11:44 -0500
Message-ID: <567AC7C0.10804@redhat.com>
References: <1449686389-26896-1-git-send-email-neescoba@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LEhLWqDiNLRW1VexodsOgaQOIBeV01psp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449686389-26896-1-git-send-email-neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LEhLWqDiNLRW1VexodsOgaQOIBeV01psp
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/09/2015 01:39 PM, Nelson Escobar wrote:
> query_protocol() was added in commit 6b90a6d66b17 ("IB/Verbs:
> Implement new callback query_protocol()") and then removed in
> commit f9b22e355d38 ("IB/core: Convert core to use bitfield
> for caps").
>=20
> This left behind an unused prototype.
>=20
> Signed-off-by: Nelson Escobar <neescoba-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/inf=
iniband/hw/usnic/usnic_ib_verbs.h
> index 414eaa5..0d9d2e6a 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> @@ -43,8 +43,6 @@ int usnic_ib_query_device(struct ib_device *ibdev,
>  			  struct ib_udata *uhw);
>  int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
>  				struct ib_port_attr *props);
> -enum rdma_protocol_type
> -usnic_ib_query_protocol(struct ib_device *device, u8 port_num);
>  int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
>  				int qp_attr_mask,
>  				struct ib_qp_init_attr *qp_init_attr);
>=20

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--LEhLWqDiNLRW1VexodsOgaQOIBeV01psp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWesfAAAoJELgmozMOVy/d+5AP/0hSFDzTtGnhhNsHVrpzZPoV
0OzCTjPdE1X5+N7Ppr4i+2ISTM6in0zAawPmQqmjtAR8kZWMJV7hv7R6jtP8KW7b
4C8ctpIF7U2ELvPgn5aABgS3WiNlGlrsdESTWUWTd9iEZ1iUC74dCt4WISBiNQlA
mAW570XEQya7xfkyOZCFMpYRbpJoST16269WGIc3l3pHP0u9fdV0xhvgD1xy8bpy
jiYKXOcvfNPOPlDUQlaK2HKpeRxo7Tl19wqoFPyZe8CndqbgWlsuL36lT69NLiR+
/GPSJ9vAFq6M0j2dYHBYqlHeCmCOfnjVi6x4ApmR24Bx2YompGghGUdOYdm9JZc2
HrkQLdOMVHcsx53DxJ/0LQwu51jpbkzMRM+3L4AjDbktw2co9PC/jE5ZL/JXocIz
oHvKVslYNb7owgcJl2vj1RwYJNoiU2f/BxMyF1kbwy+utXNtLvueNrDWHwZol1vc
fZ8th73/A/87wIVe3YCeryLTZgtOTypXcXkJbgi2u1buLGrm79CqQIm/jrOx/BdE
eI8t+F+Ah+nobcFS2E8CCAeg0ppqARJiHCWq+NP9JfnIJnzfc+wEygz/P53IpYfl
46weQJMZ9/nS3X7jZQz0/0PIHAXL3A/o27aFVvyDLfZ322r8Sofgods+kyu4gYez
lHIcMD0cyxMge+zK9ErP
=z1Yd
-----END PGP SIGNATURE-----

--LEhLWqDiNLRW1VexodsOgaQOIBeV01psp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
