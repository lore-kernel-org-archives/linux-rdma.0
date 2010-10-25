From: Jonathan Rosser <jonathan.rosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
Subject: Re: [PATCH] librdmacm: fix compiler warning of void* arithmetic
Date: Mon, 25 Oct 2010 10:52:44 +0100
Message-ID: <ia3k1c$930$2@dough.gmane.org>
References: <i9rnbn$f9o$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <i9rnbn$f9o$1@dough.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Arithmetic on void* pointers generates a compiler warning, and projects
that include rdma/rdma_verbs.h and compile with  -Werror -Wall will fail
to build.

Signed-off-by: Jonathan Rosser <jrosser-gjMux1o1B1/QXOPxS62xeg@public.gmane.org>
---
  include/rdma/rdma_verbs.h |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdma_verbs.h b/include/rdma/rdma_verbs.h
index d75d906..853ef9b 100644
--- a/include/rdma/rdma_verbs.h
+++ b/include/rdma/rdma_verbs.h
@@ -160,7 +160,7 @@ rdma_post_recv(struct rdma_cm_id *id, void *context, 
void *addr,
  {
         struct ibv_sge sge;

-       assert((addr >= mr->addr) && ((addr + length) <= (mr->addr + 
mr->length)));
+       assert((addr >= mr->addr) && (((uint8_t*)addr + length) <= 
((uint8_t*)mr->addr + mr->length)));
         sge.addr = (uint64_t) (uintptr_t) addr;
         sge.length = (uint32_t) length;
         sge.lkey = mr->lkey;
-- 
1.7.0.4



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
