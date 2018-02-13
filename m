From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 09/15] IB/uverbs: Fix possible oops with duplicate ioctl attributes
Date: Tue, 13 Feb 2018 12:18:35 +0200
Message-ID: <20180213101841.20101-10-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If the same attribute is listed twice by the user in the ioctl attribute
list then error unwind can cause the kernel to deref garbage.

This happens when an object with WRITE access is sent twice. The second
parse properly fails but corrupts the state required for the error unwind
it triggers.

Fixing this by making duplicates in the attribute list invalid. This is
not something we need to support.

The ioctl interface is currently recommended to be disabled in kConfig.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index d96dc1d17be1..339b85145044 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -59,6 +59,9 @@ static int uverbs_process_attr(struct ib_device *ibdev,
 			return 0;
 	}
 
+	if (test_bit(attr_id, attr_bundle_h->valid_bitmap))
+		return -EINVAL;
+
 	spec = &attr_spec_bucket->attrs[attr_id];
 	e = &elements[attr_id];
 	e->uattr = uattr_ptr;
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
