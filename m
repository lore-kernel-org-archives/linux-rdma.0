From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libmlx5 2/6] fix coverity buffer overrun warning
Date: Wed, 27 Jul 2016 15:17:23 -0400
Message-ID: <1469647047-7544-3-git-send-email-jarod@redhat.com>
References: <1469647047-7544-1-git-send-email-jarod@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469647047-7544-1-git-send-email-jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In set_umr_data_seg, there's a union between a 16-byte struct and a
64-byte array, named data. The code then makes a memset() call on the
struct that is sizeof(array) - sizeof(struct) long, which results in
writing 48 bytes to a 16 byte container. Technically, we know this is
actually fine, because of the union, but to silence the warning, we can
just do the memset on the array instead. Same address, same result, but no
warning spew from coverity.

CC: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/qp.c b/src/qp.c
index 51e1176..8bb66be 100644
--- a/src/qp.c
+++ b/src/qp.c
@@ -426,7 +426,7 @@ static void set_umr_data_seg(struct mlx5_qp *qp, enum ibv_mw_type type,
 	data->klm.mkey = htonl(bind_info->mr->lkey);
 	data->klm.address = htonll(bind_info->addr);
 
-	memset(&data->klm + 1, 0, sizeof(data->reserved) -
+	memset(&data->reserved + 1, 0, sizeof(data->reserved) -
 	       sizeof(data->klm));
 
 	*seg += sizeof(*data);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
