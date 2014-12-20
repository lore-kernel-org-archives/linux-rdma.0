From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_block()
Date: Sat, 20 Dec 2014 19:22:24 +0100
Message-ID: <5495BE60.50301@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Wd98JS1lQB615oTbO2ApWXN1el2CttW4l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Wd98JS1lQB615oTbO2ApWXN1el2CttW4l
Content-Type: multipart/mixed;
 boundary="------------060601020800050208060302"

This is a multi-part message in MIME format.
--------------060601020800050208060302
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

=46rom a399cd7398a86b72541c628588365c252882cd80 Mon Sep 17 00:00:00 2001
From: Vangelis Tasoulas <vangelis-e629+x1LERvk1uMJSBkQmQ@public.gmane.org>
Date: Sat, 20 Dec 2014 19:10:33 +0100
Subject: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_block=
()
 when LIDs from the top LFT block (0xbfc0-0xbfff) are used.

---
 opensm/osm_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 11efd54..a28ec28 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -168,7 +168,7 @@ boolean_t osm_switch_get_lft_block(IN const
osm_switch_t * p_sw,
        if (base_lid_ho > p_sw->max_lid_ho)
                return FALSE;

-       CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <=3D IB_LID_UCAST_END_HO=
);
+       CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE - 1 <=3D
IB_LID_UCAST_END_HO);
        memcpy(p_block, &(p_sw->lft[base_lid_ho]), IB_SMP_DATA_SIZE);
        return TRUE;
 }
--=20
1.9.1

--------------060601020800050208060302
Content-Type: text/x-patch;
 name="0001-Fixes-wrong-assertion-failed-in-osm_switch_get_lft_b.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-Fixes-wrong-assertion-failed-in-osm_switch_get_lft_b.pa";
 filename*1="tch"

=46rom a399cd7398a86b72541c628588365c252882cd80 Mon Sep 17 00:00:00 2001
From: Vangelis Tasoulas <vangelis-e629+x1LERvk1uMJSBkQmQ@public.gmane.org>
Date: Sat, 20 Dec 2014 19:10:33 +0100
Subject: [PATCH] Fixes wrong assertion failed in osm_switch_get_lft_block=
()
 when LIDs from the top LFT block (0xbfc0-0xbfff) are used.

---
 opensm/osm_switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index 11efd54..a28ec28 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -168,7 +168,7 @@ boolean_t osm_switch_get_lft_block(IN const osm_switc=
h_t * p_sw,
 	if (base_lid_ho > p_sw->max_lid_ho)
 		return FALSE;
=20
-	CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE <=3D IB_LID_UCAST_END_HO);
+	CL_ASSERT(base_lid_ho + IB_SMP_DATA_SIZE - 1 <=3D IB_LID_UCAST_END_HO);=

 	memcpy(p_block, &(p_sw->lft[base_lid_ho]), IB_SMP_DATA_SIZE);
 	return TRUE;
 }
--=20
1.9.1


--------------060601020800050208060302--

--Wd98JS1lQB615oTbO2ApWXN1el2CttW4l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUlb5lAAoJEEuGx9KTo03qReYIAKthfL36zWnmbsscUZDF1iJs
VVnc+7XOgZzDThfUsZ5ZJFHqiOg0E8Xg8r4PkaJmeDNi1j5t5I4iJtZPmb6J01Mc
Wq0WnNI4IUXOcHST4WXvzTCTbLs0P4s8pkHBgigxYzsqNmkFEKK7n8O2XsYIGedh
C/Q4rSvko22GFj5AJEmdT8HXlNSXLB6wOIJinoUDSjwq5Mb3cGXfI0SHR5LwNb7o
aA66pKi/Rq+cbP5pW2+N50RKVEQY79NXT/LOXKRMQWAkbjFpW8mi4iF7Sfg3DfnW
x2ST33/8Jbzd7potITqZ/KE1a9c0HzDq/cMMzW1ZbaYgrKhT32RMuk40DyUcMTQ=
=oRG3
-----END PGP SIGNATURE-----

--Wd98JS1lQB615oTbO2ApWXN1el2CttW4l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
