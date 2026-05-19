Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A99E369D67;
	Tue, 19 May 2026 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779222994; cv=none; b=PGj56cb4s0xgVvxqDA6hthJS+jWOtaRZUBeuGKLQieFUCVNA3no56za5m2EXTkxQlAMiUVQTeRzqnuih38e7ReYKgEk7/xlNd50dmXWiZmGCSBLO75sZWEi+bI5HTG6r6kbF1ZgW7c2kam41m2EUx0imxKrGacl3jJW8gB2sZOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779222994; c=relaxed/simple;
	bh=vsKtwqWCG5Ukg8+cZJaPxya/4H9iiGmXwFobdQh/xTo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=SABo0+WpGJNq3vBxhWWnXmLyFMeOnp+j6cv8316dEhaDVjYEjDb1lMNaYf5/y33fojb1dR7oZU4CcKmMqT8XWHAnEkijAZitduAxWgORGlS8ou73Go/fIPB3b16dMf5AjOQhqA2kV9qJyPVDqHt7re+nMEYGgF0Uhefh2ap2SQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQausR/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQausR/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47D51F000E9;
	Tue, 19 May 2026 20:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779222993;
	bh=FshgCHALJ59wH4BX/ju+9EHKFKhiTABveFuIYMGlgCE=;
	h=From:To:Cc:Subject:Date;
	b=iQausR/MgzVLB/eoKBIPGbgsF2pZAqL8Lk3Lj8IKPqbU9rH7Gic1XnkMamYJ/8SDk
	 kVddw3pT4LOCVbEoS9VYRcSbrRv2WyxrzlG30YUubZTHgd8Xk5QcJ13gwop16RFLw/
	 a+WtYi9xU+wvBe2ScGh5ZQErWUUPamzxojy9NXo5HlXrRxj5I6Z02mQgjMZSq/b0FA
	 P+mLcN68eIDWFMJDuzrq2hia6g6k0z+UoUqAHuRZK8Adot4KJzZNXsiDgeS/+DH9nT
	 rHl1JJMOZ9PKt0y7/uE5rXq+EuvXHRU/1PP2MIHdfnKnCOksOzqhWIJI0vOTxAzOAL
	 DoReK+fvlr1bQ==
From: Arnd Bergmann <arnd@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] RDMA/core: remove extraneous dummy helper functions
Date: Tue, 19 May 2026 22:36:22 +0200
Message-Id: <20260519203629.1341667-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The _ib_copy_validate_udata_in() and _ib_respond_udata() functions
are now defined unconditionally, but there is still a dummy helper
definition for them when CONFIG_INFINIBAND_USER_ACCESS is disabled,
leading to a build failure:

drivers/infiniband/core/ib_core_uverbs.c:433:5: error: redefinition of '_ib_copy_validate_udata_in'
  433 | int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from include/rdma/uverbs_std_types.h:10,
                 from drivers/infiniband/core/uverbs.h:49,
                 from drivers/infiniband/core/ib_core_uverbs.c:10:
include/rdma/uverbs_ioctl.h:961:19: note: previous definition of '_ib_copy_validate_udata_in' with type 'int(struct ib_udata *, void *, size_t,  size_t)' {aka 'int(struct ib_udata *, void *, long unsigned int,  long unsigned int)'}
  961 | static inline int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/core/ib_core_uverbs.c:483:5: error: redefinition of '_ib_respond_udata'
  483 | int _ib_respond_udata(struct ib_udata *udata, const void *src, size_t len)
      |     ^~~~~~~~~~~~~~~~~
include/rdma/uverbs_ioctl.h:968:19: note: previous definition of '_ib_respond_udata' with type 'int(struct ib_udata *, const void *, size_t)' {aka 'int(struct ib_udata *, const void *, long unsigned int)'}
  968 | static inline int _ib_respond_udata(struct ib_udata *udata, const void *src,
      |                   ^~~~~~~~~~~~~~~~~

Remove the now incorrect dummy helpers and move the declarations
out of the #ifdef block.

Fixes: 65b044cee9fb ("RDMA/core: Move the _ib_copy_validate_udata* functions to ib_core_uverbs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/rdma/uverbs_ioctl.h | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index e2af17da3e32..bcca58ee0171 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -856,6 +856,10 @@ ib_uverbs_get_ucontext(const struct uverbs_attr_bundle *attrs)
 	return ib_uverbs_get_ucontext_file(attrs->ufile);
 }
 
+int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
+			       size_t kernel_size, size_t minimum_size);
+int _ib_respond_udata(struct ib_udata *udata, const void *src, size_t len);
+
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 int uverbs_get_flags64(u64 *to, const struct uverbs_attr_bundle *attrs_bundle,
 		       size_t idx, u64 allowed_bits);
@@ -898,9 +902,6 @@ int _uverbs_get_const_unsigned(u64 *to,
 int uverbs_copy_to_struct_or_zero(const struct uverbs_attr_bundle *bundle,
 				  size_t idx, const void *from, size_t size);
 
-int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
-			       size_t kernel_size, size_t minimum_size);
-int _ib_respond_udata(struct ib_udata *udata, const void *src, size_t len);
 #else
 static inline int
 uverbs_get_flags64(u64 *to, const struct uverbs_attr_bundle *attrs_bundle,
@@ -957,19 +958,6 @@ _uverbs_get_const_unsigned(u64 *to,
 {
 	return -EINVAL;
 }
-
-static inline int _ib_copy_validate_udata_in(struct ib_udata *udata, void *req,
-					     size_t kernel_size,
-					     size_t minimum_size)
-{
-	return -EINVAL;
-}
-
-static inline int _ib_respond_udata(struct ib_udata *udata, const void *src,
-				    size_t len)
-{
-	return -EINVAL;
-}
 #endif
 
 #define uverbs_get_const_signed(_to, _attrs_bundle, _idx)                      \
-- 
2.39.5

