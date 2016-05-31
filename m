From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/hfi1: Avoid large frame size warning
Date: Tue, 31 May 2016 10:54:36 +0300
Message-ID: <1464681276-6494-1-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=46rom: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When CONFIG_FRAME_WARN is set to 1024 bytes, which is useful to find
stack consumers, we get a warning in hfi1 driver.

drivers/infiniband/hw/hfi1/affinity.c: In function
=E2=80=98hfi1_get_proc_affinity=E2=80=99:
drivers/infiniband/hw/hfi1/affinity.c:415:1: warning: the frame size of
1056 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

This change removes unneeded buf[1024] declaration and usage.

=46ixes: f48ad614c100 ("IB/hfi1: Move driver out of staging")
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/affinity.c | 31 ++++++++++++++-------------=
----
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/affinity.c b/drivers/infiniband=
/hw/hfi1/affinity.c
index 6e7050a..14d7eeb 100644
--- a/drivers/infiniband/hw/hfi1/affinity.c
+++ b/drivers/infiniband/hw/hfi1/affinity.c
@@ -300,16 +300,15 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *d=
d, int node)
 	const struct cpumask *node_mask,
 		*proc_mask =3D tsk_cpus_allowed(current);
 	struct cpu_mask_set *set =3D &dd->affinity->proc;
-	char buf[1024];
=20
 	/*
 	 * check whether process/context affinity has already
 	 * been set
 	 */
 	if (cpumask_weight(proc_mask) =3D=3D 1) {
-		scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(proc_mask));
-		hfi1_cdbg(PROC, "PID %u %s affinity set to CPU %s",
-			  current->pid, current->comm, buf);
+		hfi1_cdbg(PROC, "PID %u %s affinity set to CPU %*pbl",
+			  current->pid, current->comm,
+			  cpumask_pr_args(proc_mask));
 		/*
 		 * Mark the pre-set CPU as used. This is atomic so we don't
 		 * need the lock
@@ -318,9 +317,9 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd,=
 int node)
 		cpumask_set_cpu(cpu, &set->used);
 		goto done;
 	} else if (cpumask_weight(proc_mask) < cpumask_weight(&set->mask)) {
-		scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(proc_mask));
-		hfi1_cdbg(PROC, "PID %u %s affinity set to CPU set(s) %s",
-			  current->pid, current->comm, buf);
+		hfi1_cdbg(PROC, "PID %u %s affinity set to CPU set(s) %*pbl",
+			  current->pid, current->comm,
+			  cpumask_pr_args(proc_mask));
 		goto done;
 	}
=20
@@ -356,8 +355,8 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd,=
 int node)
 	cpumask_or(intrs, intrs, (dd->affinity->rcv_intr.gen ?
 				  &dd->affinity->rcv_intr.mask :
 				  &dd->affinity->rcv_intr.used));
-	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(intrs));
-	hfi1_cdbg(PROC, "CPUs used by interrupts: %s", buf);
+	hfi1_cdbg(PROC, "CPUs used by interrupts: %*pbl",
+		  cpumask_pr_args(intrs));
=20
 	/*
 	 * If we don't have a NUMA node requested, preference is towards
@@ -366,18 +365,16 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *d=
d, int node)
 	if (node =3D=3D -1)
 		node =3D dd->node;
 	node_mask =3D cpumask_of_node(node);
-	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(node_mask));
-	hfi1_cdbg(PROC, "device on NUMA %u, CPUs %s", node, buf);
+	hfi1_cdbg(PROC, "device on NUMA %u, CPUs %*pbl", node,
+		  cpumask_pr_args(node_mask));
=20
 	/* diff will hold all unused cpus */
 	cpumask_andnot(diff, &set->mask, &set->used);
-	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(diff));
-	hfi1_cdbg(PROC, "unused CPUs (all) %s", buf);
+	hfi1_cdbg(PROC, "unused CPUs (all) %*pbl", cpumask_pr_args(diff));
=20
 	/* get cpumask of available CPUs on preferred NUMA */
 	cpumask_and(mask, diff, node_mask);
-	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(mask));
-	hfi1_cdbg(PROC, "available cpus on NUMA %s", buf);
+	hfi1_cdbg(PROC, "available cpus on NUMA %*pbl", cpumask_pr_args(mask)=
);
=20
 	/*
 	 * At first, we don't want to place processes on the same
@@ -395,8 +392,8 @@ int hfi1_get_proc_affinity(struct hfi1_devdata *dd,=
 int node)
 		cpumask_andnot(diff, &set->mask, &set->used);
 		cpumask_andnot(mask, diff, node_mask);
 	}
-	scnprintf(buf, 1024, "%*pbl", cpumask_pr_args(mask));
-	hfi1_cdbg(PROC, "possible CPUs for process %s", buf);
+	hfi1_cdbg(PROC, "possible CPUs for process %*pbl",
+		  cpumask_pr_args(mask));
=20
 	cpu =3D cpumask_first(mask);
 	if (cpu >=3D nr_cpu_ids) /* empty */
--=20
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
