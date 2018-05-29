From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 05/13] IB/core: Introduce counters read verb
Date: Tue, 29 May 2018 16:09:09 +0300
Message-ID: <20180529130917.13592-6-leon@kernel.org>
References: <20180529130917.13592-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180529130917.13592-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Matan Barak <matanb@mellanox.com>, Raed Salem <raeds@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The user supplies counters instance and a reference to an output
array of uint64_t.
The driver reads the hardware counters values and writes them to
the output index location in the user supplied array.
All counters values are represented as uint64_t types.

To be able to successfully read the data the counters must be
first bound to an IB object.

Downstream patches will present binding method for
flow counters.

Tested-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/rdma/ib_verbs.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ce3d39725966..f6bd3b97b971 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2219,6 +2219,17 @@ struct ib_counters {
 	atomic_t	usecnt;
 };

+enum ib_read_counters_flags {
+	/* prefer read values from driver cache */
+	IB_READ_COUNTERS_ATTR_PREFER_CACHED = 1 << 0,
+};
+
+struct ib_counters_read_attr {
+	u64	*counters_buff;
+	u32	ncounters;
+	u32	flags; /* use enum ib_read_counters_flags */
+};
+
 struct uverbs_attr_bundle;

 struct ib_device {
@@ -2493,6 +2504,9 @@ struct ib_device {
 	struct ib_counters *	(*create_counters)(struct ib_device *device,
 						   struct uverbs_attr_bundle *attrs);
 	int	(*destroy_counters)(struct ib_counters	*counters);
+	int	(*read_counters)(struct ib_counters *counters,
+				 struct ib_counters_read_attr *counters_read_attr,
+				 struct uverbs_attr_bundle *attrs);

 	/**
 	 * rdma netdev operation
