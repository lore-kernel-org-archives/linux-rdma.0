From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH][TRIVIAL] opensm/ib_types.h: Commentary and cosmetic formatting
 change
Date: Tue, 18 Sep 2012 14:53:28 -0400
Message-ID: <5058C328.1010004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index c8d51ca..698418d 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -7765,10 +7765,10 @@ ib_notice_is_generic(IN const ib_mad_notice_attr_t * p_ntc)
 /*
 * PARAMETERS
 *	p_ntc
-*		[in] Pointer to  the notice MAD attribute
+*		[in] Pointer to the notice MAD attribute
 *
 * RETURN VALUES
-*	TRUE if mad is generic
+*	TRUE if notice MAD is generic
 *
 * SEE ALSO
 *	ib_mad_notice_attr_t
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
