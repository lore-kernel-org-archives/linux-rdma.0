From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Why SR-IOV Shared Port and not vSwitch?
Date: Wed, 28 Jan 2015 01:14:08 +0100
Message-ID: <54C829D0.5050106@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="L4juxJfnSvq39q2FwXk2Vf5Rflh0sLKEK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--L4juxJfnSvq39q2FwXk2Vf5Rflh0sLKEK
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I was looking into the InfiniBand SR-IOV implementation and as I see here=
:
https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg11956.html
the shared port model has been implemented in the drivers.

In an ~5 years old presentation from Liran Liss
(https://www.openfabrics.org/index.php/ofa-documents/doc_view/255-infinib=
and-and-rocee-virtualization-with-sr-iov.html),
the virtual switch model is briefly mentioned as well.

The disadvantage of the virtual switch model (that is mentioned in the
presentation as well) is the bloated LID space. Is there any other good
reason (or great disadvantage of the the vSwitch model) that the
shared-port has been chosen in favor of the vSwitch?

Vangelis


--L4juxJfnSvq39q2FwXk2Vf5Rflh0sLKEK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUyCnVAAoJEEuGx9KTo03qyJwH/jnNHvamvw5uUelToj2qmHgS
oY8vpHsQSjh/W6QlFx0UurQwVDiSKdaNYEEhhtYa1EWDfmpv4neN5vEMVUboTaih
qb98DEbDDHkDacIxKe1qeLiTAgqV2aj0mGpBLZzEFYZk5q1ONfsd/hnmd/zSlzqI
mDjXN5mnNpPphZ+OJlEDRjITmRN8yuTijjNVhYgp2o8cLn6HC1ecOSHK4hAIR5i8
92ePeGB3Wzkn90PWBD/AJhcHYD+elcnm1R/q17S1ND6GTnuzgKP4hwsVwCcN1EuD
+fG8yFaA6NCSeuZ6nEj8iIHf4Gu7At6GmDVNLk0KWK2ThIzZE64GhoqORUB6r6A=
=DmVn
-----END PGP SIGNATURE-----

--L4juxJfnSvq39q2FwXk2Vf5Rflh0sLKEK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
