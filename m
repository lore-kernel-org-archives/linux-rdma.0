From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/37] librdmacm: add support for sockaddr_ib length
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <564CA3FFD7F2468A8AE5F0EB8F801B36@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enhance ucma_addrlen to return the correct address size
for AF_IB.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index c57d166..e85ef2d 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -470,6 +470,8 @@ static int ucma_addrlen(struct sockaddr *addr)
 		return sizeof(struct sockaddr_in);
 	case PF_INET6:
 		return sizeof(struct sockaddr_in6);
+	case PF_IB:
+		return sizeof(struct sockaddr_ib);
 	default:
 		return 0;
 	}



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
