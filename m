From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] [v2] IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage
Date: Wed,  6 Sep 2017 23:34:25 +0200
Message-ID: <20170906213521.1845893-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We get a harmless warning about the fact that we use the result of a
multiplication as a condition:

drivers/infiniband/core/uverbs_main.c: In function 'ib_uverbs_write':
drivers/infiniband/core/uverbs_main.c:787:40: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:787:117: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:790:50: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]
drivers/infiniband/core/uverbs_main.c:790:151: error: '*' in boolean context, suggest '&&' instead [-Werror=int-in-bool-context]

This avoids the problem by using an inline function in place of
the macro.

Fixes: a96e4e2ffe43 ("IB/uverbs: New macro to set pointers to NULL if length is 0 in INIT_UDATA()")
Suggested-by: Christoph Hellwig <hch@infradead.org>
Link: https://patchwork.kernel.org/patch/9940777/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: completely rewrite the patch to a larger cleanup.
---
 drivers/infiniband/core/uverbs.h           | 15 ++++++++-------
 drivers/infiniband/core/uverbs_main.c      | 22 ++++++++++------------
 drivers/infiniband/core/uverbs_std_types.c |  3 ++-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 37c8903e7fd0..a8f104a4a91b 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -55,13 +55,14 @@
 		(udata)->outlen = (olen);				\
 	} while (0)
 
-#define INIT_UDATA_BUF_OR_NULL(udata, ibuf, obuf, ilen, olen)			\
-	do {									\
-		(udata)->inbuf  = (ilen) ? (const void __user *) (ibuf) : NULL;	\
-		(udata)->outbuf = (olen) ? (void __user *) (obuf) : NULL;	\
-		(udata)->inlen  = (ilen);					\
-		(udata)->outlen = (olen);					\
-	} while (0)
+static inline void
+ib_uverbs_init_udata_buf_or_null(struct ib_udata *udata,
+				 const void __user *ibuf,
+				 void __user *obuf,
+				 size_t ilen, size_t olen)
+{
+	INIT_UDATA(udata, ilen ? ibuf : NULL, olen ? obuf : NULL, ilen, olen);
+}
 
 /*
  * Our lifetime rules for these structs are the following:
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index dc2aed6fb21b..b5febfd84ee5 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -763,7 +763,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			}
 
 			if (!access_ok(VERIFY_WRITE,
-				       (void __user *) (unsigned long) ex_hdr.response,
+				       u64_to_user_ptr(ex_hdr.response),
 				       (hdr.out_words + ex_hdr.provider_out_words) * 8)) {
 				ret = -EFAULT;
 				goto out;
@@ -775,19 +775,17 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			}
 		}
 
-		INIT_UDATA_BUF_OR_NULL(&ucore, buf, (unsigned long) ex_hdr.response,
-				       hdr.in_words * 8, hdr.out_words * 8);
+		ib_uverbs_init_udata_buf_or_null(&ucore, buf,
+					u64_to_user_ptr(ex_hdr.response),
+					hdr.in_words * 8, hdr.out_words * 8);
 
-		INIT_UDATA_BUF_OR_NULL(&uhw,
-				       buf + ucore.inlen,
-				       (unsigned long) ex_hdr.response + ucore.outlen,
-				       ex_hdr.provider_in_words * 8,
-				       ex_hdr.provider_out_words * 8);
+		ib_uverbs_init_udata_buf_or_null(&uhw,
+					buf + ucore.inlen,
+					u64_to_user_ptr(ex_hdr.response) + ucore.outlen,
+					ex_hdr.provider_in_words * 8,
+					ex_hdr.provider_out_words * 8);
 
-		ret = uverbs_ex_cmd_table[command](file,
-						   ib_dev,
-						   &ucore,
-						   &uhw);
+		ret = uverbs_ex_cmd_table[command](file, ib_dev, &ucore, &uhw);
 		if (!ret)
 			ret = written_count;
 	} else {
diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index 0a98579700ec..b095bce7f238 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -246,7 +246,8 @@ static void create_udata(struct uverbs_attr_bundle *ctx,
 		outbuf_len = uhw_out->ptr_attr.len;
 	}
 
-	INIT_UDATA_BUF_OR_NULL(udata, inbuf, outbuf, inbuf_len, outbuf_len);
+	ib_uverbs_init_udata_buf_or_null(udata, inbuf, outbuf, inbuf_len,
+					 outbuf_len);
 }
 
 static int uverbs_create_cq_handler(struct ib_device *ib_dev,
-- 
2.9.0
