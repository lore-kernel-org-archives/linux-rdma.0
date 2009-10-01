From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_helper.c: fix compiler warning
Date: Thu, 1 Oct 2009 19:17:00 +0200
Message-ID: <20091001171700.GU17846@me>
References: <D8E83C9B6A164D48B1F37DFB606CB25A@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D8E83C9B6A164D48B1F37DFB606CB25A-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Stan C. Smith" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Eliminate compiler warning:

osm_helper.c:551: warning: missing braces around initializer
osm_helper.c:551: warning: (near initialization for =E2=80=98ib_zero_gi=
d.raw=E2=80=99)

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_helper.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_helper.c b/opensm/opensm/osm_helper.c
index 35da131..ea9e21f 100644
--- a/opensm/opensm/osm_helper.c
+++ b/opensm/opensm/osm_helper.c
@@ -548,7 +548,7 @@ const char *ib_get_trap_str(ib_net16_t trap_num)
 	return "Unknown";
 }
=20
-const ib_gid_t ib_zero_gid =3D { 0 };
+const ib_gid_t ib_zero_gid =3D { { 0 } };
=20
 /*********************************************************************=
*
  *********************************************************************=
*/
--=20
1.6.5.rc1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
