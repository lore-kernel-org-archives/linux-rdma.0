From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Strange dma map/unmap/memcpy dance in ipoib_cm_handle_rx_wc
Date: Thu, 28 Apr 2016 10:22:42 -0400
Message-ID: <57221CB2.906@redhat.com>
References: <57206ECD.8060007@kyup.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4cxCrgJ1sG6e7hLdxWgo62JPgcfDXxCQ7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57206ECD.8060007-6AxghH7DbtA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4cxCrgJ1sG6e7hLdxWgo62JPgcfDXxCQ7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 04/27/2016 03:48 AM, Nikolay Borisov wrote:
> Hello,
>=20
> I need a bit of help in understanding the logic behind the following
> code sequence in ipoib_cm_handle_rx_wc:
>=20
> newskb =3D ipoib_cm_alloc_rx_skb(dev, rx_ring, wr_id, frags,
>                                        mapping, GFP_ATOMIC);
>=20
> so Here a new skb is being allocated and pages constituting its
> fragments are being dma mapped.

Into the local variable mapping.

> ipoib_cm_dma_unmap_rx(priv, frags, rx_ring[wr_id].mapping);
>=20
> immediately after that the very same mappings are being unmapped.

No, these are the saved mappings of the skb that has the same ring slot
as the one we are going to take.

> And
> finally the resulting dma addresses from ipoib_cm_alloc_rx_skb are bein=
g
> copied via this call to memcpy:
>=20
> memcpy(rx_ring[wr_id].mapping, mapping, (frags + 1) * sizeof *mapping);=


=46rom our local variable to the saved mapping slot for this ring index.

> Can someone explain what's the logic of doing the memcpy after the
> mappings have been destroyed, doesn't that mean the dma addresses store=
d
> in rx_ring[wr_id].mapping are invalid?
>=20
> Regards,
> Nikolay
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4cxCrgJ1sG6e7hLdxWgo62JPgcfDXxCQ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIhyyAAoJELgmozMOVy/d4H8QAL2SwdQf7BFQEzjl7sOre2L7
Bya7y9JsbNhq43FSvxhwE6xWy7Ko6NnBVK+zXNNRq85OFRq4F9n9DAN+rhNBJM7n
+JKGxUSrGrb42yqkRR805y8pIrOoSMNlrmz0tKVyZ1J6rjRbkx1jc7CwKCXrHLlo
etX3stmVcPM/wx5yjEz31quF21stVORLIWKlgn90lZKvJBDyG6LNp0J7GKc+kYmV
Koc11xPIUnOUBIeBMrkxJd56Xs73QakRQoRjBc17iRTzk2Dwc5mEMU4uxrWDCM4D
dwMts1MsW5tllc43o9X2MdIZm7hwn8lOy4yb114E/y1cuGr1Q+cuc5Cc08nDHBAe
r+2cW113tbhMrAptWGKdqTO9WpoJEoNYnayraOtp7Z8VUz9a05qnFI2fc41KXIEX
yU2tSm7Z5y3V+LSkw4GvoHD0uHCoWDxhGX6WCxlMWeOFq6TJresOWYu41khZSf5G
CRhtoDzASPHsAoV2CfQllIJZzNlfL6jBPAyaBLpAPpZPR2NcH/n/XMGcBQxFdDCO
xMesI39ixvexa5fLlW7PH52SHgZRA4GkhtT2DQVJ4WlI0oz7IEb6PdV0o3hVISpR
68yiIwUqcjJm/qHty61TubxnfFkEszGy5UBxBXjZ+nv0zQgkwQXInveADrQv4NJo
Aasb/rqnITWXdk2vEUK1
=ZmBw
-----END PGP SIGNATURE-----

--4cxCrgJ1sG6e7hLdxWgo62JPgcfDXxCQ7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
