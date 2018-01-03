From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 06/28] IB/srpt: Fix ACL lookup during login
Date: Wed,  3 Jan 2018 13:39:16 -0800
Message-ID: <20180103213938.11664-7-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Make sure that the initiator port GUID is stored in ch->ini_guid.
Note: when initiating a connection sgid and dgid members in struct
sa_path_rec represent the source and destination GIDs. When accepting
a connection however sgid represents the destination GID and dgid the
source GID.

Fixes: commit 2bce1a6d2209 ("IB/srpt: Accept GUIDs as port names")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: <stable@vger.kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 7c4249038004..bfa576aa9f03 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2077,7 +2077,7 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto destroy_ib;
 	}
 
-	guid = (__be16 *)&param->primary_path->sgid.global.interface_id;
+	guid = (__be16 *)&param->primary_path->dgid.global.interface_id;
 	snprintf(ch->ini_guid, sizeof(ch->ini_guid), "%04x:%04x:%04x:%04x",
 		 be16_to_cpu(guid[0]), be16_to_cpu(guid[1]),
 		 be16_to_cpu(guid[2]), be16_to_cpu(guid[3]));
-- 
2.15.1
