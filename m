From: "Jim Schutt" <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Subject: [PATCH] opensm/osm_qos.c: Make offset of VL in VLarb block
 element match IBA spec
Date: Tue,  2 Nov 2010 15:08:15 -0600
Message-ID: <1288732095-32199-1-git-send-email-jaschut@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

According to IBA 1.2.1, Table 152, page 845, the VL in a VLArbitration Table
Block Element has length 4 bits, starting at offset 4 in the 16 bit
Block Element.

Currently, the data being sent to the switches has the VL starting at
offset 0 in the 16 bit Block Element.

Fix things up to match the spec.

Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 opensm/opensm/osm_qos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_qos.c b/opensm/opensm/osm_qos.c
index c90073e..cc38151 100644
--- a/opensm/opensm/osm_qos.c
+++ b/opensm/opensm/osm_qos.c
@@ -365,7 +365,7 @@ static int parse_vlarb_entry(char *str, ib_vl_arb_element_t * e)
 	unsigned val;
 	char *p = str;
 	p += parse_one_unsigned(p, ':', &val);
-	e->vl = val % 15;
+	e->vl = (val % 15) << 4;
 	p += parse_one_unsigned(p, ',', &val);
 	e->weight = (uint8_t) val;
 	return (int)(p - str);
-- 
1.6.2.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
