From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: libibnetdisc: fix cast in unmarshall16
Date: Mon, 26 Jul 2010 11:40:30 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A8D7F5F5@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofw-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Uri Habusha reported a build error on windows as a result of an
incorrect cast to uint64_t.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 .../libibnetdisc/src/ibnetdisc_cache.c             |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
index 1de42eb..199bf33 100644
--- a/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
+++ b/infiniband-diags/libibnetdisc/src/ibnetdisc_cache.c
@@ -183,8 +183,7 @@ static size_t _unmarshall8(uint8_t * inbuf, uint8_t * num)
 
 static size_t _unmarshall16(uint8_t * inbuf, uint16_t * num)
 {
-	(*num) = (uint64_t) inbuf[0];
-	(*num) |= ((uint16_t) inbuf[1] << 8);
+	(*num) = ((uint16_t) inbuf[1] << 8) | inbuf[0];
 
 	return (sizeof(*num));
 }


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
