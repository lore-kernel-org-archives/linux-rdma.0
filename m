From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 5/5] RDMA/nldev: Allow IB device rename through RDMA netlink
Date: Thu, 20 Sep 2018 14:22:02 +0300
Message-ID: <20180920112202.9181-6-leon@kernel.org>
References: <20180920112202.9181-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180920112202.9181-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, linux-s390@vger.kernel.org, Ursula Braun <ubraun@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org, Selvin Xavier <selvin.xavier@broadcom.com>, Steve Wise <swise@chelsio.com>, Lijun Ou <oulijun@huawei.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Ariel Elior <Ariel.Elior@cavium.com>, Christian Benvenuti <benve@cisco.com>, Adit Ranadive <aditr@vmware.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Provide an option to rename IB device name through RDMA netlink and
limit it to users with ADMIN capability only.

Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/nldev.c  | 33 +++++++++++++++++++++++++++++++++
 include/uapi/rdma/rdma_netlink.h |  3 ++-
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 0385ab438320..64e1d12e9678 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -645,6 +645,35 @@ static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }

+static int nldev_set_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct ib_device *device;
+	u32 index;
+	int err;
+
+	err = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1, nldev_policy,
+			  extack);
+	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(index);
+	if (!device)
+		return -EINVAL;
+
+	if (tb[RDMA_NLDEV_ATTR_DEV_NAME]) {
+		char name[IB_DEVICE_NAME_MAX] = {};
+
+		nla_strlcpy(name, tb[RDMA_NLDEV_ATTR_DEV_NAME],
+			    IB_DEVICE_NAME_MAX);
+		return ib_device_rename(device, name);
+	}
+
+	return 0;
+}
+
 static int _nldev_get_dumpit(struct ib_device *device,
 			     struct sk_buff *skb,
 			     struct netlink_callback *cb,
@@ -1077,6 +1106,10 @@ static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 		.doit = nldev_get_doit,
 		.dump = nldev_get_dumpit,
 	},
+	[RDMA_NLDEV_CMD_SET] = {
+		.doit = nldev_set_doit,
+		.flags = RDMA_NL_ADMIN_PERM,
+	},
 	[RDMA_NLDEV_CMD_PORT_GET] = {
 		.doit = nldev_port_get_doit,
 		.dump = nldev_port_get_dumpit,
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index edba6351ac13..f9c41bf59efc 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -227,8 +227,9 @@ enum rdma_nldev_command {
 	RDMA_NLDEV_CMD_UNSPEC,

 	RDMA_NLDEV_CMD_GET, /* can dump */
+	RDMA_NLDEV_CMD_SET,

-	/* 2 - 4 are free to use */
+	/* 3 - 4 are free to use */

 	RDMA_NLDEV_CMD_PORT_GET = 5, /* can dump */
