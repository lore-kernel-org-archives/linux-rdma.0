From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v3 04/14] IB/core: Introduce counters object and its create/destroy
Date: Thu, 31 May 2018 16:43:31 +0300
Message-ID: <20180531134341.18441-5-leon@kernel.org>
References: <20180531134341.18441-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180531134341.18441-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, "Michael J . Ruhl" <michael.j.ruhl@intel.com>, Or Gerlitz <ogerlitz@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

A verbs application may need to get statistics and info on various
aspects of a verb object (e.g. Flow, QP, ...), in general case the
application will state which object's counters its interested in
(we refer to this action as attach), bind this new counters object
to the appropriate verb object and on later stage read their values
using the counters object.

This series introduces a general API for counters object that may
accumulate any ib object counters type, bound and read on demand.

Counters instance is allocated on an IB context and belongs to
that context.
Upon successful creation the counters can be bound to a verbs
object so that hardware counter instances can be created and read.

Downstream patches in this series will introduce the attach, bind
and the read functionality.

Counters instance can be de-allocated, upon successful
destruction the related hardware resources are released.

Prior to destroy call the user must first make sure that the counters
is not being used by any IB object, e.g. not attached to any of its
counted type otherwise an EBUSY error is invoked.

Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/rdma/ib_verbs.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 406c98d7a09a..90c548437c8a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2212,6 +2212,13 @@ struct ib_port_pkey_list {
 	struct list_head              pkey_list;
 };
 
+struct ib_counters {
+	struct ib_device	*device;
+	struct ib_uobject	*uobject;
+	/* num of objects attached */
+	atomic_t	usecnt;
+};
+
 struct uverbs_attr_bundle;
 
 struct ib_device {
@@ -2483,6 +2490,10 @@ struct ib_device {
 	struct ib_mr *             (*reg_dm_mr)(struct ib_pd *pd, struct ib_dm *dm,
 						struct ib_dm_mr_attr *attr,
 						struct uverbs_attr_bundle *attrs);
+	struct ib_counters *	(*create_counters)(struct ib_device *device,
+						   struct uverbs_attr_bundle *attrs);
+	int	(*destroy_counters)(struct ib_counters	*counters);
+
 	/**
 	 * rdma netdev operation
 	 *
-- 
2.14.3
