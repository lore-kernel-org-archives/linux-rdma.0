From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: assertion failed in osm_switch_get_lft_block() function
Date: Fri, 19 Dec 2014 21:46:47 +0100
Message-ID: <54948EB7.1020706@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="92GjALXTVTRP0h6wHMKQWv4u6oQqpsgHF"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--92GjALXTVTRP0h6wHMKQWv4u6oQqpsgHF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

When I use LIDs from the top LFT block (0xbfc0-0xbfff), I get an
assertion error from the function osm_switch_get_lft_block() which is
implemented in osm_switch.c.

The line is this one:
CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <=3D IB_LID_UCAST_END_HO);

In the topmost LFT block, the base_lid_ho has the value 49088 and the
IB_SMP_DATA_SIZE is 64. Together they add up to 49152 but the assertion
checks if they are less than 0xbfff (49151).

Shouldn't this line be something like the following?

CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE - 1 <=3D IB_LID_UCAST_END_HO);

or

CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <=3D IB_LID_UCAST_END_HO + 1);

Cheers,
Vangelis


--92GjALXTVTRP0h6wHMKQWv4u6oQqpsgHF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUlI63AAoJEEuGx9KTo03qU10IAIVSybOOTIXepZcKOFGTvr7S
IPSiavCDF2b0ZQAgzGjf7VJNYi8tzcKn9Opc6eUGoeJv4vpLLr2W9bDomKxq6bd9
6zz500YgQC3FGmi9WlisP9D0wTc52RhCwbgO/Xrk+3a68odyeOQNBKvkK7k5C+RQ
XAKaZ6ojV6NdF3jnwSbxxTjlNBTJQdBP9wy9kpHeXw4SnTIxLDTZL7xD1X7Kw/tg
tmF856GwW287ht2yohcMeEh4zN+lUPSPmUi1RsJLJXRl1qI2E2x9flMyn3EXceiA
kaseK0V075JqQEo8KMfyTnQxIzF/nBna3TSStFhiT6UGGNgoY32BuOuJdU495CI=
=H+f6
-----END PGP SIGNATURE-----

--92GjALXTVTRP0h6wHMKQWv4u6oQqpsgHF--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
