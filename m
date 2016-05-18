From: shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v3 1/1] IB/mlx4: Unaligned access in send_reply_to_slave
Date: Wed, 18 May 2016 06:18:10 -0400
Message-ID: <1463566690-22881-1-git-send-email-shamir.rabinovitch@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

The problem is that the function 'send_reply_to_slave' get the
'req_sa_mad' as pointer whose address can be unaligned to 8 bytes.
In this case the compiler cannot know in advance what will be the
alignment of the 'data' field.

Sowmini Varadhan pointed to this reply from Dave Miller that say
that memcpy should not be used to solve alignment issues:
https://lkml.org/lkml/2015/10/21/352

Optimization of memcpy to 'ldx' instruction can only happen if the
compiler see that the size of the data we copy is 8 bytes and it
assume it is aligned to 8. If the compiler know the type is not
aligned to 8 it must not optimize the 8 bytes copy. Defining the
data type as aligned to 4 force the compiler to assume it is not
aligned to 8 at all time.

Full credit for the idea goes to Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>.

v3: Change patch according to suggestion by Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

v2: Minor fix in patch headline by Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: shamir rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 99451d8..0550017 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -96,7 +96,7 @@ struct ib_sa_mcmember_data {
 	u8		scope_join_state;
 	u8		proxy_join;
 	u8		reserved[2];
-};
+} __packed __aligned(4);
 
 struct mcast_group {
 	struct ib_sa_mcmember_data rec;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
