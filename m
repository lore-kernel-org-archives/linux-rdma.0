From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/mlx4: Report checksum offload cap when query
 device
Date: Thu, 17 Sep 2015 22:46:00 -0400
Message-ID: <55FB7AE8.2070304@redhat.com>
References: <cover.1442413048.git.bodong@mellanox.com>
 <68bea4df2c89e5457aaaccf914756bc309d742a7.1442413048.git.bodong@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IA57fU58RP0AgqOuBvops8ljnB6KOkkGa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <68bea4df2c89e5457aaaccf914756bc309d742a7.1442413048.git.bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <wbd2905-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IA57fU58RP0AgqOuBvops8ljnB6KOkkGa
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 11:56 AM, Bodong Wang wrote:
> Signed-off-by: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/=
mlx4/main.c
> index 8be6db8..a70ca6a 100644
> --- a/drivers/infiniband/hw/mlx4/main.c
> +++ b/drivers/infiniband/hw/mlx4/main.c
> @@ -217,6 +217,9 @@ static int mlx4_ib_query_device(struct ib_device *i=
bdev,
>  		props->device_cap_flags |=3D IB_DEVICE_MANAGED_FLOW_STEERING;
>  	}
> =20
> +	props->csum_cap.eth_csum_cap |=3D IB_CSUM_SUPPORT_RAW;
> +	props->csum_cap.ib_csum_cap |=3D IB_CSUM_SUPPORT_UD;
> +
>  	props->vendor_id	   =3D be32_to_cpup((__be32 *) (out_mad->data + 36))=
 &
>  		0xffffff;
>  	props->vendor_part_id	   =3D dev->dev->persist->pdev->device;
>=20

This patch highlights something I didn't think about on the previous
patch.  Why separate eth/ib if you have per QP flags?  The QP denotes
the ib/eth relationship without the need to separate it into two
different caps.  In other words, you can never have an IB qp type on eth
because the only eth QP types we support other than RAW are all RDMA and
not IP.  Really, there's enough spare bits in ib_device_cap_flags that
you could do away with the new caps entirely.  Right now, we support UD
(which we already have a flag for), we can add two flags (for RAW and
RC) and that should cover all of the foreseeable options as that would
allow us to extend IP CSUM support to cover connected mode and cover all
of the current options.  I don't see us doing IP traffic in any other
situation, so I thing that should suffice.  Bits 25 and 26 could be used
for the two new bits.  Then you just need to extend the bits to user spac=
e.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IA57fU58RP0AgqOuBvops8ljnB6KOkkGa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+3roAAoJELgmozMOVy/dCUIQAIxvzvCcOCQRad0nLbKnlBUB
tPe3XIGVQyeK+s2wYIaY956XNAVP+8KIivapswoUTVaYXPxpiMdmV5kQqedRt4oo
0eLZEo/PP36eMFG681AWK0p0POf7rr9IxsKkzXlWSCAhIRimJeL2KwacGh47oHHR
RpXO21usR9ZeKZb3WzB37/0vgFRAFqPXexeNedztGJydldGOV/wPFoj3okZtD0Kt
uQwG+CtbKzrk/aefCv8yW9jljp6EZ29oC6pfyMhNsesJFNNMVf23HIUCZBXEyhBj
WJBs4tMqEL/wz/8Kj3sWh1eL7fVAyhY7a9YYBFCet+TC/CqM8Dv8PWpuyRGYIrQz
G8IwL1yvxwjLaruh9AwAmTpTjoFTrQnaudovfOjutwXR9xXx97uM132PD+AgBtd4
L0JsxKuTZMiFyfJO8ir0XWVjJBD2xKfdW9xSeUtWmKszM5c+9FJb4YYJrdtEN16U
CtjCgzMzv2CpojIyxBp7QCyaWVH1w8nENPPfz/SICLIgxN1x0U+OYLUyhe2vygVJ
pMeHpLEUiVfbnk/vg8r998hN6rjqzTGsUzGB3NuxCDeFufj2X9cx96bSd1qvXH8M
0M/Wo7fkf4OhJ95L4N2U/mvscSUw4LDo5yL/3ZunEkiwM38mzWUyz7WZyhj8qgQ0
3LLXiIqXWp9r7XvQJLhl
=zIB1
-----END PGP SIGNATURE-----

--IA57fU58RP0AgqOuBvops8ljnB6KOkkGa--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
