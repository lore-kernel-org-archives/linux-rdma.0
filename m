From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/4] Add IBV_MTU_1500|9000 enums.
Date: Wed,  3 Apr 2013 06:06:53 -0700
Message-ID: <1364994415-8330-2-git-send-email-jsquyres@cisco.com>
References: <1364994415-8330-1-git-send-email-jsquyres@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1364994415-8330-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow specification of common Ethernet MTUs.

---
 examples/devinfo.c         | 2 ++
 examples/pingpong.c        | 2 ++
 include/infiniband/verbs.h | 6 ++++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/examples/devinfo.c b/examples/devinfo.c
index 98a6b4b..6700882 100644
--- a/examples/devinfo.c
+++ b/examples/devinfo.c
@@ -118,8 +118,10 @@ static const char *mtu_str(enum ibv_mtu max_mtu)
 	case IBV_MTU_256:  return "256";
 	case IBV_MTU_512:  return "512";
 	case IBV_MTU_1024: return "1024";
+	case IBV_MTU_1500: return "1500";
 	case IBV_MTU_2048: return "2048";
 	case IBV_MTU_4096: return "4096";
+	case IBV_MTU_9000: return "9000";
 	default:           return "invalid MTU";
 	}
 }
diff --git a/examples/pingpong.c b/examples/pingpong.c
index 90732ef..d7443a8 100644
--- a/examples/pingpong.c
+++ b/examples/pingpong.c
@@ -42,8 +42,10 @@ enum ibv_mtu pp_mtu_to_enum(int mtu)
 	case 256:  return IBV_MTU_256;
 	case 512:  return IBV_MTU_512;
 	case 1024: return IBV_MTU_1024;
+	case 1500: return IBV_MTU_1500;
 	case 2048: return IBV_MTU_2048;
 	case 4096: return IBV_MTU_4096;
+	case 9000: return IBV_MTU_9000;
 	default:   return -1;
 	}
 }
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 6a6944c..1583c34 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -150,8 +150,10 @@ enum ibv_mtu {
 	IBV_MTU_256  = 1,
 	IBV_MTU_512  = 2,
 	IBV_MTU_1024 = 3,
-	IBV_MTU_2048 = 4,
-	IBV_MTU_4096 = 5
+	IBV_MTU_1500 = 4,
+	IBV_MTU_2048 = 5,
+	IBV_MTU_4096 = 6,
+	IBV_MTU_9000 = 7
 };
 
 enum ibv_port_state {
-- 
1.8.1.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
