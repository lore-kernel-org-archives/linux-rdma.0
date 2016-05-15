From: shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Subject: [PATCH v1 1/1] mlx4/mad: unalign access in send_reply_to_slave
Date: Sun, 15 May 2016 03:27:24 -0400
Message-ID: <1463297244-3837-1-git-send-email-shamir.rabinovitch@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

The problem is that the function 'send_reply_to_slave' get the
'req_sa_mad' as pointer whose address can be unaligned to 8 bytes.
In this case the compiler cannot know in advance what will be the
alignment of the 'data' field.

Sowmini Varadhan pointed to this reply from Dave Miller that say
that memcpy should not be used to solve alignment issues:
https://lkml.org/lkml/2015/10/21/352

The reason why memcpy works here is because we memcpy someting that
is bigger then 8 bytes and so the compiler cannot optimize this to
'ldx' instruction.

Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/mcg.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 99451d8..180f76b 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -319,8 +319,9 @@ static int send_reply_to_slave(int slave, struct mcast_group *group,
 		struct ib_sa_mad *req_sa_mad, u16 status)
 {
 	struct ib_sa_mad mad;
+	struct ib_sa_mcmember_data req_data;
 	struct ib_sa_mcmember_data *sa_data = (struct ib_sa_mcmember_data *)&mad.data;
-	struct ib_sa_mcmember_data *req_sa_data = (struct ib_sa_mcmember_data *)&req_sa_mad->data;
+	struct ib_sa_mcmember_data *req_sa_data = &req_data;
 	int ret;
 
 	memset(&mad, 0, sizeof mad);
@@ -343,6 +344,11 @@ static int send_reply_to_slave(int slave, struct mcast_group *group,
 	/* reconstruct VF's requested join_state and port_gid */
 	sa_data->scope_join_state &= 0xf0;
 	sa_data->scope_join_state |= (group->func[slave].join_state & 0x0f);
+	BUILD_BUG_ON(sizeof(req_sa_mad->data) < sizeof(req_data));
+	/* req_sa_mad is packed structure whose start address is not
+	 * aligned to 8
+	 */
+	memcpy(&req_data, &req_sa_mad->data, sizeof(req_data));
 	memcpy(&sa_data->port_gid, &req_sa_data->port_gid, sizeof req_sa_data->port_gid);
 
 	ret = send_mad_to_slave(slave, group->demux, (struct ib_mad *)&mad);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
