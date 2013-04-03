From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Ad IB_MTU_1500|9000 enums.
Date: Wed,  3 Apr 2013 06:13:16 -0700
Message-ID: <1364994796-10642-2-git-send-email-jsquyres@cisco.com>
References: <1364994796-10642-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364994796-10642-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow specification of common Ethernet MTUs.

---
 include/rdma/ib_addr.h  | 6 +++++-
 include/rdma/ib_verbs.h | 8 ++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 9996539..1f6fbbc 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -200,10 +200,14 @@ static inline enum ib_mtu iboe_get_mtu(int mtu)
 	 */
 	mtu = mtu - IB_GRH_BYTES - IB_BTH_BYTES - 28;
 
-	if (mtu >= ib_mtu_enum_to_int(IB_MTU_4096))
+	if (mtu >= ib_mtu_enum_to_int(IB_MTU_9000))
+		return IB_MTU_9000;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_4096))
 		return IB_MTU_4096;
 	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_2048))
 		return IB_MTU_2048;
+	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_1500))
+		return IB_MTU_1500;
 	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_1024))
 		return IB_MTU_1024;
 	else if (mtu >= ib_mtu_enum_to_int(IB_MTU_512))
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 8a66758..4670f6f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -174,8 +174,10 @@ enum ib_mtu {
 	IB_MTU_256  = 1,
 	IB_MTU_512  = 2,
 	IB_MTU_1024 = 3,
-	IB_MTU_2048 = 4,
-	IB_MTU_4096 = 5
+	IB_MTU_1500 = 4,
+	IB_MTU_2048 = 5,
+	IB_MTU_4096 = 6,
+	IB_MTU_9000 = 7
 };
 
 static inline int ib_mtu_enum_to_int(enum ib_mtu mtu)
@@ -184,8 +186,10 @@ static inline int ib_mtu_enum_to_int(enum ib_mtu mtu)
 	case IB_MTU_256:  return  256;
 	case IB_MTU_512:  return  512;
 	case IB_MTU_1024: return 1024;
+	case IB_MTU_1500: return 1500;
 	case IB_MTU_2048: return 2048;
 	case IB_MTU_4096: return 4096;
+	case IB_MTU_9000: return 9000;
 	default: 	  return -1;
 	}
 }
-- 
1.8.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
