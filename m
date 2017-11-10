From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] infiniband: avoid uninitialized variable warning in create_udata
Date: Fri, 10 Nov 2017 23:10:31 +0100
Message-ID: <20171110221053.3549147-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>, Arnd Bergmann <arnd@arndb.de>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Leon Romanovsky <leon@kernel.org>, Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

As Dan pointed out, the rework I did makes it harder for smatch and other
static checkers to figure out what is going on with the uninitialized
pointers.

By open-coding the call in create_udata(), we make it more readable for
both humans and tools.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 12f727721eee ("IB/uverbs: clean up INIT_UDATA_BUF_OR_NULL usage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/core/uverbs_std_types.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index b095bce7f238..c3ee5d9b336d 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -227,27 +227,26 @@ static void create_udata(struct uverbs_attr_bundle *ctx,
 	 * to use uverbs_attr_bundle instead of ib_udata.
 	 * Assume attr == 0 is input and attr == 1 is output.
 	 */
-	void __user *inbuf;
-	size_t inbuf_len = 0;
-	void __user *outbuf;
-	size_t outbuf_len = 0;
 	const struct uverbs_attr *uhw_in =
 		uverbs_attr_get(ctx, UVERBS_UHW_IN);
 	const struct uverbs_attr *uhw_out =
 		uverbs_attr_get(ctx, UVERBS_UHW_OUT);
 
 	if (!IS_ERR(uhw_in)) {
-		inbuf = uhw_in->ptr_attr.ptr;
-		inbuf_len = uhw_in->ptr_attr.len;
+		udata->inbuf = uhw_in->ptr_attr.ptr;
+		udata->inlen = uhw_in->ptr_attr.len;
+	} else {
+		udata->inbuf = NULL;
+		udata->inlen = 0;
 	}
 
 	if (!IS_ERR(uhw_out)) {
-		outbuf = uhw_out->ptr_attr.ptr;
-		outbuf_len = uhw_out->ptr_attr.len;
+		udata->outbuf = uhw_out->ptr_attr.ptr;
+		udata->outlen = uhw_out->ptr_attr.len;
+	} else {
+		udata->outbuf = NULL;
+		udata->outlen = 0;
 	}
-
-	ib_uverbs_init_udata_buf_or_null(udata, inbuf, outbuf, inbuf_len,
-					 outbuf_len);
 }
 
 static int uverbs_create_cq_handler(struct ib_device *ib_dev,
-- 
2.9.0
