From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH rfc 2/3] RDMA/core: expose cpu affinity based completion vector lookup
Date: Sun,  2 Jul 2017 18:01:33 +0300
Message-ID: <1499007694-7231-3-git-send-email-sagi@grimberg.me>
References: <1499007694-7231-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499007694-7231-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Smart <james.smart-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

A ULP might want to lookup an optimal completion vector based on
a given cpu core affinity. Expose a lookup routine for it iterating
on the device completion vectors searching a vector with affinity
matching the given cpu.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 41 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |  3 +++
 2 files changed, 44 insertions(+)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4792f5209ac2..f0dfb1ca952b 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2099,3 +2099,44 @@ void ib_drain_qp(struct ib_qp *qp)
 		ib_drain_rq(qp);
 }
 EXPORT_SYMBOL(ib_drain_qp);
+
+/**
+ * ib_find_cpu_vector() - Find the first completion vector mapped to a given cpu core
+ * @device:            rdma device
+ * @cpu:               cpu for the corresponding completion vector affinity
+ * @vector:            output target completion vector
+ *
+ * If the device expose vector affinity we will search each of the vectors
+ * and if we find one that gives us the desired cpu core we return true
+ * and assign @vector to the corresponding completion vector. Otherwise
+ * we return false. We stop at the first appropriate completion vector
+ * we find as we don't have any preference for multiple vectors with the
+ * same affinity.
+ */
+bool ib_find_cpu_vector(struct ib_device *device, unsigned int cpu,
+		unsigned int *vector)
+{
+	bool found = false;
+	unsigned int c;
+	int vec;
+
+	for (vec = 0; vec < device->num_comp_vectors; vec++) {
+		const struct cpumask *mask;
+
+		mask = ib_get_vector_affinity(device, vec);
+		if (!mask)
+			goto out;
+
+		for_each_cpu(c, mask) {
+			if (c == cpu) {
+				*vector = vec;
+				found = true;
+				goto out;
+			}
+		}
+	}
+
+out:
+	return found;
+}
+EXPORT_SYMBOL(ib_find_cpu_vector);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 2349143297c9..8af48ef811f8 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3662,4 +3662,7 @@ ib_get_vector_affinity(struct ib_device *device, int comp_vector)
 
 }
 
+bool ib_find_cpu_vector(struct ib_device *device, unsigned int cpu,
+		unsigned int *vector);
+
 #endif /* IB_VERBS_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
