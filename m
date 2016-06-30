From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Oops with mlx5/NFSoRDMA client with 4.7-rc5ish
Date: Thu, 30 Jun 2016 18:11:03 -0400
Message-ID: <2771797c-a7e5-61c6-4ad6-79322d04b5a5@redhat.com>
References: <730f57aa-b1f6-c6da-4936-bebba1954ca7@redhat.com>
 <94C521BC-7BB0-46B7-8597-F1BE10C8CB04@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="sP8itkn0UqG9KbBaRuRhD1hPufUKhg5O1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <94C521BC-7BB0-46B7-8597-F1BE10C8CB04-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--sP8itkn0UqG9KbBaRuRhD1hPufUKhg5O1
Content-Type: multipart/mixed; boundary="9avcWuDI7ddHJW36sOLaxV97CsLuVKLVn"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <2771797c-a7e5-61c6-4ad6-79322d04b5a5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Oops with mlx5/NFSoRDMA client with 4.7-rc5ish
References: <730f57aa-b1f6-c6da-4936-bebba1954ca7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <94C521BC-7BB0-46B7-8597-F1BE10C8CB04-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <94C521BC-7BB0-46B7-8597-F1BE10C8CB04-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--9avcWuDI7ddHJW36sOLaxV97CsLuVKLVn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 6/30/2016 2:44 PM, Chuck Lever wrote:
>=20
>> On Jun 30, 2016, at 2:31 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:=

>>
>> This could easily be an mlx5 issue given that it starts with a DMAR
>> error, but I would also hope that NFSoRDMA can manage to survive the
>> DMAR error.
>=20
> I'm afraid I don't know what a DMAR error is.

When you have your IOMMU enabled (by default it isn't, and even if you
have it enabled, if you are running as a bare metal install, it might
not be used either if your default iommu setting is passthrough),
attempts by the card to DMA to areas that are not currently mapped
trigger DMA errors.  In this case DMAR is DMA Read.  It is usually a
sign that something is wrong in the drivers memory registration
routines, or that there is a race somewhere with the card.  I copied you
because it showed up in NFSoRDMA, but the DMAR error points it to being
more likely an mlx5 issue.

> Those are happening in the forward path (send) and the
> GPF happens on receive. Can you give me an idea what
> the source code looks like around
>=20
>   rpcrdma_reply_handler+0x18e/0xce0 ?

I didn't have this kernel compiled with debug info, so that's a bitch to
work out.  I'll rebuild, reinstall, and see if I get the oops again.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--9avcWuDI7ddHJW36sOLaxV97CsLuVKLVn--

--sP8itkn0UqG9KbBaRuRhD1hPufUKhg5O1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXdZj3AAoJELgmozMOVy/djHUP/0vO+bmXVl5v4XXInoG4bUNj
Xf/2Zet+9+Tg+2re998sGTpJIsU+2LfybxFHP0mqTjR5nyIGqz/RkAL9jqKw2jbN
RmpPlb8isZTDwMNdiVTxatnxon9JKYvlTb6/YGGdPaZEehVtALTs0QcYHg1dcHTt
UCyX0eU9p3rYMCjpLAVuQJ2nqFofs0TUJAlVz4fLYKr9i49DjlrK9XBuGYi9LujG
kJtYGcyu/vMQICZpZQ4M7MVz5Dba78sAEJBlhoUAnWLTqGWrKePDBFGBO/4AdryL
u/kHr11aHS3dlbOCM72p+1tKqDqHkzcdCRI9SmASSfWoiDy+F5nqd3yWup94e7+r
/TxlNrZrQR8kOhnaJ2cJjz2E2TZ3oOug0tb9QRLbz1LALSJ1398uxbgqRwcgDRD1
NVdgIggbmXn5nNy3jim8IRKS0Oc1f4dcvTUoY68+756WXZ4wMLwl9sAh7Epaqzzg
rWIXz9idHW1l0+zlV3B2bK5+u6d1yXxxKiowuM5uYpU9M6pqXF4DR9HXIWLuC7Lm
7FHaJ3w/OUOPRcS5ZGYsM8IuK+aW9KS4Hhg2sWvIjpeCm77V8NVdiPQxtS07sVW/
t6kPc/WWGBk1fwAWlUzSh/b/Us/2RTlD4sQgB1qxp+WnjcjfTP7EP56GLxjwn2DT
oUwgChp5C264Dd4HqmfZ
=rtwH
-----END PGP SIGNATURE-----

--sP8itkn0UqG9KbBaRuRhD1hPufUKhg5O1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
