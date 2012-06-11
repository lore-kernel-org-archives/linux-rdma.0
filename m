From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 22/29] {NET,IB}/mlx4: Add alias_guid mechanism
Date: Mon, 11 Jun 2012 13:46:03 +0300
Message-ID: <1339411570-4689-23-git-send-email-jackm@dev.mellanox.co.il>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1339411570-4689-1-git-send-email-jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For IB ports, we paravirtualize the GUID at index 0 on slaves.
The GUID at index 0 seen by a slave is the actual GUID occupying
the GUID table at the slave-id index.

The driver, by default, request at startup time that subnet manager
populate its entire guid table with GUIDs. These guids are then
mapped (paravirtualized) to the slaves, and appear for each slave
as its GUID at index 0.

Until each slave has such a guid, its port status is DOWN.

Note: this patch may still require some cleanup.

Originally developed by Erez Shitrit of Mellanox.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/Makefile      |    2 +-
 drivers/infiniband/hw/mlx4/alias_GUID.c  |  790 ++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mad.c         |   31 +-
 drivers/infiniband/hw/mlx4/main.c        |    9 +
 drivers/infiniband/hw/mlx4/mlx4_ib.h     |   78 +++
 drivers/net/ethernet/mellanox/mlx4/cmd.c |    6 +-
 6 files changed, 909 insertions(+), 7 deletions(-)
 create mode 100644 drivers/infiniband/hw/mlx4/alias_GUID.c

diff --git a/drivers/infiniband/hw/mlx4/Makefile b/drivers/infiniband/hw/mlx4/Makefile
index bf0aa90..31d4c8a 100644
--- a/drivers/infiniband/hw/mlx4/Makefile
+++ b/drivers/infiniband/hw/mlx4/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_MLX4_INFINIBAND)	+= mlx4_ib.o
 
-mlx4_ib-y :=	ah.o cq.o doorbell.o mad.o main.o mr.o qp.o srq.o mcg.o cm.o
+mlx4_ib-y :=	ah.o cq.o doorbell.o mad.o main.o mr.o qp.o srq.o mcg.o cm.o alias_GUID.o
diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
new file mode 100644
index 0000000..66427c7
--- /dev/null
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -0,0 +1,790 @@
+/*
+ * Copyright (c) 2012 Mellanox Technologies. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+ /***********************************************************/
+/*This file support the handling of the Alias GUID feature. */
+/***********************************************************/
+#include <rdma/ib_mad.h>
+#include <rdma/ib_smi.h>
+#include <rdma/ib_cache.h>
+#include <rdma/ib_sa.h>
+#include <rdma/ib_pack.h>
+#include <linux/mlx4/cmd.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <rdma/ib_user_verbs.h>
+#include <linux/delay.h>
+#include "mlx4_ib.h"
+
+/*
+The driver keeps the current state of all guids, as they are in the HW.
+Whenever we receive an smp mad GUIDInfo record, the data will be cached.
+*/
+
+struct mlx4_alias_guid_work_context {
+	u8 port;
+	struct mlx4_ib_dev     *dev ;
+	struct ib_sa_query     *sa_query;
+	struct completion	done;
+	int			query_id;
+	struct list_head	list;
+	int			block_num;
+};
+
+struct mlx4_next_alias_guid_work {
+	u8 port;
+	u8 block_num;
+	struct mlx4_sriov_alias_guid_info_rec_det rec_det;
+};
+
+
+void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev, int block_num,
+					 u8 port_num, u8 *p_data)
+{
+	int i;
+	u64 guid_indexes;
+	int slave_id;
+	int port_index = port_num - 1;
+
+	if (!mlx4_is_master(dev->dev))
+		return;
+
+	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
+				   ports_guid[port_num - 1].
+				   all_rec_per_port[block_num].guid_indexes);
+	mlx4_ib_dbg("port:%d, guid_indexes: 0x%llx\n", port_num, guid_indexes);
+
+	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
+		/* The location of the specific index starts from bit number 4
+		 * until bit num 11 */
+		if (test_bit(i + 4, (unsigned long *)&guid_indexes)) {
+			slave_id = (block_num * NUM_ALIAS_GUID_IN_REC) + i ;
+			if (slave_id >= dev->dev->num_slaves) {
+				mlx4_ib_dbg("The last slave: %d\n", slave_id);
+				goto out;
+			}
+
+			/* cache the guid: */
+			memcpy(&dev->sriov.demux[port_index].guid_cache[slave_id],
+			       &p_data[i * GUID_REC_SIZE],
+			       GUID_REC_SIZE);
+		} else
+			mlx4_ib_dbg("Guid number :%d in block :%d"
+				    " was not updated\n",
+				    i, block_num);
+	}
+out:
+	return;
+
+}
+
+static __be64 get_cached_alias_guid(struct mlx4_ib_dev *dev, int port, int index)
+{
+	__be64 cur_admin_val;
+
+	if (index >= NUM_ALIAS_GUID_PER_PORT) {
+		pr_err("%s: BUG: asked for index:%d\n", __func__, index);
+		return  (__force __be64) ((u64) 0xFFFFFFFFFFFFFFFFUL);
+	}
+	cur_admin_val = *(__be64 *)&dev->sriov.demux[port - 1].guid_cache[index];
+	return cur_admin_val;
+}
+
+
+static ib_sa_comp_mask get_alias_guid_comp_mask_from_index(int index)
+{
+		return IB_SA_COMP_MASK(4 + index);
+}
+
+/*
+ * Whenever new GUID is set/unset (guid table change) create event and
+ * notify the relevant slave (master also should be notified).
+ * If the GUID value is not as we have in the cache the slave will not be
+ * updated; in this case it waits for the smp_snoop to call the function
+ * and to update the slave.
+ * block_number - the index of the block (16 blocks available)
+ * port_number - 1 or 2
+ */
+void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
+					  int block_num, u8 port_num,
+					  u8 *p_data)
+{
+	int i;
+	u64 guid_indexes;
+	int slave_id;
+	enum slave_port_state new_state;
+	enum slave_port_state prev_state;
+	__be64 tmp_cur_ag, form_cache_ag;
+	enum slave_port_gen_event gen_event;
+
+	if (!mlx4_is_master(dev->dev))
+		return;
+
+	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
+				   ports_guid[port_num - 1].
+				   all_rec_per_port[block_num].guid_indexes);
+	mlx4_ib_dbg("port:%d, guid_indexes: 0x%llx\n", port_num, guid_indexes);
+
+	/*calculate the slaves and notify them*/
+	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
+		/* the location of the specific index starts from
+		 * bit number 4 till bit num 11*/
+		if (test_bit(i + 4, (unsigned long *)&guid_indexes)) {
+			slave_id = (block_num * NUM_ALIAS_GUID_IN_REC) + i ;
+			if (slave_id >= dev->dev->num_slaves) {
+				mlx4_ib_dbg("The last slave: %d\n",
+					     slave_id);
+				goto out;
+			}
+			tmp_cur_ag = *(__be64 *)&p_data[i * GUID_REC_SIZE];
+			form_cache_ag =
+				get_cached_alias_guid(dev, port_num,
+						      (NUM_ALIAS_GUID_IN_REC * block_num) + i);
+			/*
+			 * Check if guid is not the same as in the cache,
+			 * waits for the snoop_smp
+			 * to updates the slave on its state change
+			 */
+			if (tmp_cur_ag != form_cache_ag) {
+				mlx4_ib_dbg("(tmp_cur_ag: 0x%llx, "
+					    "form_cache_ag: 0x%llx)nothing to "
+					    "update now, "
+					    "the snoop_smp will updated.\n",
+					    tmp_cur_ag, form_cache_ag);
+				continue;
+			}
+			mlx4_gen_guid_change_eqe(dev->dev, slave_id, port_num);
+
+			/*2 cases: Valid GUID, and Invalid Guid*/
+
+			if (tmp_cur_ag != MLX4_NOT_SET_GUID) { /*valid GUID*/
+				prev_state =
+					mlx4_get_slave_port_state(dev->dev, slave_id, port_num);
+				new_state =
+					set_and_calc_slave_port_state(dev->dev, slave_id, port_num,
+								      MLX4_PORT_STATE_IB_PORT_STATE_EVENT_GID_VALID,
+								      &gen_event);
+				mlx4_ib_dbg("slave: %d, port:%d prev_port_state: %d,"
+					    " new_port_state: %d, gen_event :%d\n",
+					    slave_id, port_num, prev_state,
+					    new_state, gen_event);
+				if (gen_event == SLAVE_PORT_GEN_EVENT_UP) {
+					mlx4_ib_dbg("sending PORT_UP event "
+						    "to slave: %d, port:%d\n",
+						    slave_id, port_num);
+					mlx4_gen_port_state_change_eqe(dev->dev, slave_id,
+								       port_num,
+								       MLX4_PORT_CHANGE_SUBTYPE_ACTIVE);
+				} else {
+					mlx4_ib_dbg("GOT: %d event to slave: %d, port:%d\n",
+						    gen_event, slave_id, port_num);
+				}
+			} else { /*Invalidate GUID*/
+				set_and_calc_slave_port_state(dev->dev,
+							      slave_id,
+							      port_num,
+							      MLX4_PORT_STATE_IB_EVENT_GID_INVALID,
+							      &gen_event);
+				mlx4_ib_dbg("sending MLX4_PORT_STATE_IB_EVENT_GID_INVALID"
+					    " event to slave: %d, port:%d [got gen_event: %d]\n",
+					    slave_id, port_num, gen_event);
+				mlx4_gen_port_state_change_eqe(dev->dev, slave_id,
+							       port_num,
+							       MLX4_PORT_CHANGE_SUBTYPE_DOWN);
+			}
+		} else
+			mlx4_ib_dbg("Guid number :%d in block :%d"
+				    " was not updated\n",
+				    i, block_num);
+	}
+out:
+	return;
+
+}
+/****************************************************************************
+* aliasguid_query_handler : callback function whenever we have success/failure/timeout
+******************************************************************************/
+static void aliasguid_query_handler(int status,
+				    struct ib_sa_guidinfo_rec *guid_rec,
+				    void *context)
+{
+	struct mlx4_ib_dev *dev;
+	struct mlx4_alias_guid_work_context *cb_ctx = context;
+	u8 port_index ;
+	int i;
+	struct mlx4_sriov_alias_guid_info_rec_det *rec;
+	/*ib_sa_comp_mask comp_mask = 0;*/
+	unsigned long flags, flags1;
+
+	if (!context) {
+		pr_err("alias_guid: context is null.\n");
+		return;
+	}
+
+	dev = cb_ctx->dev;
+	port_index = cb_ctx->port - 1;
+	rec = &dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[cb_ctx->block_num];
+
+	if (status) {
+		rec->status = MLX4_GUID_INFO_STATUS_IDLE;
+		mlx4_ib_dbg("(port: %d) failed: status = %d\n",
+		       cb_ctx->port, status);
+		goto out;
+	}
+
+	if (guid_rec->block_num != cb_ctx->block_num) {
+		pr_err("block num mismatch: %d != %d",
+		       cb_ctx->block_num, guid_rec->block_num);
+		goto out;
+	}
+
+	mlx4_ib_dbg("lid/port: %d/%d, block_num: %d",
+		    be16_to_cpu(guid_rec->lid), cb_ctx->port,
+		    guid_rec->block_num);
+
+	rec = &dev->sriov.alias_guid.ports_guid[port_index].
+		all_rec_per_port[guid_rec->block_num];
+
+	rec->status = MLX4_GUID_INFO_STATUS_SET;
+	rec->method = MLX4_GUID_INFO_RECORD_SET;
+
+	for (i = 0 ; i < NUM_ALIAS_GUID_IN_REC; i++) {
+		__be64 tmp_cur_ag;
+		tmp_cur_ag = *(__be64 *)&guid_rec->guid_info_list[i * GUID_REC_SIZE];
+		/* check if the SM didn't assign one of the records.
+		 * if it didn't, if it was not sysadmin request:
+		 * ask the SM to give a new GUID, (instead of the driver request).
+		 */
+		if (tmp_cur_ag == MLX4_NOT_SET_GUID) {
+			mlx4_ib_warn(&dev->ib_dev, "%s:Record num %d in "
+				     "block_num:%d was declined by SM, "
+				     "ownership by %d (0 = driver, 1=sysAdmin,"
+				     " 2=None)\n", __func__, i,
+				     guid_rec->block_num, rec->ownership);
+			if (rec->ownership == MLX4_GUID_DRIVER_ASSIGN) {
+				/* if it is driver assign,
+				 * asks for new GUID from SM*/
+				*(__be64 *)&rec->all_recs[i * GUID_REC_SIZE] =
+					MLX4_NOT_SET_GUID;
+
+				/* Mark the record as not assigned, and let it
+				 * be sent again in the next work sched.*/
+				rec->status = MLX4_GUID_INFO_STATUS_IDLE;
+				rec->guid_indexes =
+					rec->guid_indexes |
+					get_alias_guid_comp_mask_from_index(i);
+			}
+		} else {
+		       /* properly assigned record. */
+		       /* We save the GUID we just got from the SM in the
+			* admin_guid in order to be persistent, and in the
+			* request from the sm the process will ask for the same GUID */
+			if (rec->ownership == MLX4_GUID_SYSADMIN_ASSIGN &&
+			    tmp_cur_ag != *(__be64 *)&rec->all_recs[i * GUID_REC_SIZE]) {
+				/*the case the sysadmin assignment failed.*/
+				mlx4_ib_warn(&dev->ib_dev, "%s: Failed to set"
+					     " admin guid after SysAdmin "
+					     "configuration. "
+					     "Record num %d in block_num:%d "
+					     "was declined by SM, "
+					     "new val(0x%llx) was kept\n",
+					      __func__, i,
+					     guid_rec->block_num,
+					     be64_to_cpu(*(__be64 *) &
+							 rec->all_recs[i * GUID_REC_SIZE]));
+			} else {
+				memcpy(&rec->all_recs[i * GUID_REC_SIZE],
+				       &guid_rec->guid_info_list[i * GUID_REC_SIZE],
+				       GUID_REC_SIZE);
+			}
+		}
+	}
+	/*
+	The func is call here to close the cases when the
+	sm doesn't send smp, so in the sa response the driver
+	notifies the slave.
+	*/
+	mlx4_ib_notify_slaves_on_guid_change(dev, guid_rec->block_num,
+					     cb_ctx->port,
+					     guid_rec->guid_info_list);
+out:
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	if (!dev->sriov.is_going_down)
+		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port_index].wq,
+				   &dev->sriov.alias_guid.ports_guid[port_index].
+				   alias_guid_work, 0);
+	if (cb_ctx->sa_query) {
+		list_del(&cb_ctx->list);
+		kfree(cb_ctx);
+	} else
+		complete(&cb_ctx->done);
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+}
+
+static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
+{
+	int i;
+	u64 cur_admin_val;
+	int is_first_rec = 0;  /* The first guid in the first rec is RO */
+	ib_sa_comp_mask comp_mask = 0;
+
+	if (0 == index)
+		is_first_rec = 1;
+
+	dev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[index].status
+		= MLX4_GUID_INFO_STATUS_IDLE;
+	dev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[index].method
+		= MLX4_GUID_INFO_RECORD_SET;
+
+	/* calculate the comp_mask for that record.*/
+	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
+		cur_admin_val =
+			*(u64 *)&dev->sriov.alias_guid.ports_guid[port - 1].
+			all_rec_per_port[index].all_recs[GUID_REC_SIZE * i];
+		/*
+		check the admin value: if it for delete (~00LL) or
+		we are in the first guid (hw guid)dont put it for assigment or
+		the records isnot in ownership of he sysadmin and the sm doesn't
+		need to assign GUIDs.
+		*/
+		if (MLX4_GUID_FOR_DELETE_VAL == cur_admin_val ||
+		    (is_first_rec && 0 == i) ||
+		    MLX4_GUID_NONE_ASSIGN == dev->sriov.alias_guid.
+		    ports_guid[port - 1].all_rec_per_port[index].ownership) {
+			continue;
+		}
+		comp_mask = comp_mask | get_alias_guid_comp_mask_from_index(i);
+	}
+	dev->sriov.alias_guid.ports_guid[port - 1].
+		all_rec_per_port[index].guid_indexes = comp_mask;
+}
+
+static int set_guid_rec(struct ib_device *ibdev,
+			u8 port, int index,
+			struct mlx4_sriov_alias_guid_info_rec_det *rec_det)
+{
+	int err;
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+	struct ib_sa_guidinfo_rec guid_info_rec;
+	ib_sa_comp_mask comp_mask;
+	struct ib_port_attr attr;
+	struct mlx4_alias_guid_work_context *callback_context;
+	unsigned long resched_delay, flags, flags1;
+	struct list_head *head =
+		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
+
+	err = __mlx4_ib_query_port(ibdev, port, &attr, 1);
+	if (err) {
+		mlx4_ib_dbg("failed to mlx4_ib_query_port (err:%d), port:%d\n",
+			 err, port);
+		return err;
+	}
+	/*check the port was configured by the sm, otherwise no need to send */
+	if (attr.state != IB_PORT_ACTIVE) {
+		mlx4_ib_dbg("port: %d not active...rescheduling", port);
+		resched_delay = 5 * HZ;
+		err = -EAGAIN;
+		goto new_schedule;
+	}
+
+	callback_context = kmalloc(sizeof *callback_context, GFP_KERNEL);
+	if (!callback_context) {
+		err = -ENOMEM;
+		mlx4_ib_dbg("set_guid_rec: no Mem\n");
+		resched_delay = HZ * 5;
+		goto new_schedule;
+	}
+	callback_context->port = port;
+	callback_context->dev = dev;
+	callback_context->block_num = index;
+
+	memset(&guid_info_rec, 0, sizeof(struct ib_sa_guidinfo_rec));
+
+	guid_info_rec.lid = cpu_to_be16(attr.lid);
+	guid_info_rec.block_num = index;
+
+	memcpy(guid_info_rec.guid_info_list, rec_det->all_recs,
+	       GUID_REC_SIZE * NUM_ALIAS_GUID_IN_REC);
+	comp_mask = IB_SA_GUIDINFO_REC_LID | IB_SA_GUIDINFO_REC_BLOCK_NUM |
+		rec_det->guid_indexes;
+
+	init_completion(&callback_context->done);
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	list_add_tail(&callback_context->list, head);
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+
+	callback_context->query_id =
+		ib_sa_guid_info_rec_query(dev->sriov.alias_guid.sa_client,
+					  ibdev, port, &guid_info_rec,
+					  comp_mask, rec_det->method, 1000,
+					  GFP_KERNEL, aliasguid_query_handler,
+					  callback_context,
+					  &callback_context->sa_query);
+	if (callback_context->query_id < 0) {
+		mlx4_ib_dbg("set_guid_rec: failed to "
+			    "ib_sa_guid_info_rec_query, query_id: "
+			    "%d will reschedule to the next 1 sec.\n",
+			    callback_context->query_id);
+		spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+		list_del(&callback_context->list);
+		kfree(callback_context);
+		spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+		resched_delay = 1 * HZ;
+		err = -EAGAIN;
+		goto new_schedule;
+	}
+	err = 0;
+	goto out;
+
+new_schedule:
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	invalidate_guid_record(dev, port, index);
+	if (!dev->sriov.is_going_down) {
+		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port - 1].wq,
+				   &dev->sriov.alias_guid.ports_guid[port - 1].alias_guid_work,
+				   resched_delay);
+	}
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+
+out:
+	return err;
+}
+
+void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port)
+{
+	int i;
+	unsigned long flags, flags1;
+
+	mlx4_ib_dbg("%s: port %d", __func__, port);
+
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	for (i = 0; i < NUM_ALIAS_GUID_REC_IN_PORT; i++)
+		invalidate_guid_record(dev, port, i);
+
+	if (!mlx4_is_master(dev->dev))
+		goto out;
+	if (!dev->sriov.is_going_down) {
+		/*
+		make sure no work waits in the queue, if the work is already queued(not on the timer)
+		the cancel will faild, it is not a problem because that is excactly what we want,
+		the work started..
+		*/
+		__cancel_delayed_work(&dev->sriov.alias_guid.
+				      ports_guid[port - 1].alias_guid_work);
+		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port - 1].wq,
+				   &dev->sriov.alias_guid.ports_guid[port - 1].alias_guid_work,
+				   0);
+	}
+out:
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+}
+/* The function returns the next record that was
+ * not configured (or failed to be configured) */
+static int get_next_record_to_update(struct mlx4_ib_dev *dev, u8 port,
+				     struct mlx4_next_alias_guid_work *rec)
+{
+	int j;
+	unsigned long flags;
+
+	for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
+		spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+		if (dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[j].status ==
+		    MLX4_GUID_INFO_STATUS_IDLE) {
+			memcpy(&rec->rec_det,
+			       &dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[j],
+			       sizeof(struct mlx4_sriov_alias_guid_info_rec_det));
+			rec->port = port;
+			rec->block_num = j;
+			dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[j].status =
+				MLX4_GUID_INFO_STATUS_PENDING;
+			spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+			return 0;
+		}
+		spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+	}
+	mlx4_ib_dbg("no more work to do");
+	return -ENOENT;
+}
+
+static void set_administratively_guid_record(struct mlx4_ib_dev *dev, int port,
+					     int rec_index,
+					     struct mlx4_sriov_alias_guid_info_rec_det *rec_det)
+{
+	dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].guid_indexes =
+		rec_det->guid_indexes;
+	memcpy(dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].all_recs,
+	       rec_det->all_recs,
+	       NUM_ALIAS_GUID_IN_REC * GUID_REC_SIZE);
+	dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].status =
+		rec_det->status;
+}
+
+static int set_all_slaves_guids(struct mlx4_ib_dev *dev, int port)
+{
+	int j;
+	int is_first_rec = 1;  /* The first guid in the first rec is RO */
+	struct mlx4_sriov_alias_guid_info_rec_det rec_det ;
+
+	for (j = 0 ; j < NUM_ALIAS_GUID_REC_IN_PORT ; j++) {
+		memset(rec_det.all_recs, 0, NUM_ALIAS_GUID_IN_REC * GUID_REC_SIZE);
+		rec_det.guid_indexes = (is_first_rec ? 0 : IB_SA_GUIDINFO_REC_GID0) |
+			IB_SA_GUIDINFO_REC_GID1 | IB_SA_GUIDINFO_REC_GID2 |
+			IB_SA_GUIDINFO_REC_GID3 | IB_SA_GUIDINFO_REC_GID4 |
+			IB_SA_GUIDINFO_REC_GID5 | IB_SA_GUIDINFO_REC_GID6 |
+			IB_SA_GUIDINFO_REC_GID7;
+		rec_det.status = MLX4_GUID_INFO_STATUS_IDLE;
+		is_first_rec = 0;
+		set_administratively_guid_record(dev, port, j, &rec_det);
+	}
+	is_first_rec = 1;
+	return 0;
+}
+
+static void alias_guid_work(struct work_struct *work)
+{
+	struct delayed_work *delay = to_delayed_work(work);
+	int ret = 0;
+	struct mlx4_next_alias_guid_work *rec;
+	struct mlx4_sriov_alias_guid_port_rec_det *sriov_alias_port =
+		container_of(delay, struct mlx4_sriov_alias_guid_port_rec_det,
+			     alias_guid_work);
+	struct mlx4_sriov_alias_guid *sriov_alias_guid = sriov_alias_port->parent;
+	struct mlx4_ib_sriov *ib_sriov = container_of(sriov_alias_guid,
+						struct mlx4_ib_sriov,
+						alias_guid);
+	struct mlx4_ib_dev *dev = container_of(ib_sriov, struct mlx4_ib_dev, sriov);
+
+	rec = kzalloc(sizeof *rec, GFP_KERNEL);
+	if (!rec) {
+		pr_err("alias_guid_work: No Memory\n");
+		return;
+	}
+
+	mlx4_ib_dbg("starting [port: %d]...", sriov_alias_port->port + 1);
+	ret = get_next_record_to_update(dev, sriov_alias_port->port, rec);
+	if (ret) {
+		mlx4_ib_dbg("No more records to update.");
+		goto out;
+	}
+
+	set_guid_rec(&dev->ib_dev, rec->port + 1, rec->block_num,
+		     &rec->rec_det);
+
+out:
+	kfree(rec);
+}
+
+
+int mlx4_ib_init_alias_guid_work(struct mlx4_ib_dev *dev, int port)
+{
+	unsigned long flags, flags1;
+	if (!mlx4_is_master(dev->dev))
+		return 0;
+	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	if (!dev->sriov.is_going_down) {
+		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port].wq,
+			   &dev->sriov.alias_guid.ports_guid[port].alias_guid_work, 0);
+	}
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	mlx4_ib_dbg("queue work for port: %d", port);
+	return 0;
+}
+
+void mlx4_ib_clear_alias_guid_work(struct mlx4_ib_dev *dev)
+{
+	int i;
+	struct mlx4_ib_sriov *sriov = &dev->sriov;
+	struct mlx4_alias_guid_work_context *cb_ctx;
+	struct mlx4_sriov_alias_guid_port_rec_det *det;
+	struct ib_sa_query *sa_query;
+	unsigned long flags;
+
+	for (i = 0 ; i < MLX4_MAX_PORTS; i++) {
+		cancel_delayed_work(&dev->sriov.alias_guid.ports_guid[i].alias_guid_work);
+		det = &sriov->alias_guid.ports_guid[i];
+		spin_lock_irqsave(&sriov->alias_guid.ag_work_lock, flags);
+		while (!list_empty(&det->cb_list)) {
+			cb_ctx = list_entry(det->cb_list.next,
+					    struct mlx4_alias_guid_work_context,
+					    list);
+			sa_query = cb_ctx->sa_query;
+			cb_ctx->sa_query = NULL;
+			list_del(&cb_ctx->list);
+			spin_unlock_irqrestore(&sriov->alias_guid.ag_work_lock, flags);
+			ib_sa_cancel_query(cb_ctx->query_id, sa_query);
+			wait_for_completion(&cb_ctx->done);
+			kfree(cb_ctx);
+			spin_lock_irqsave(&sriov->alias_guid.ag_work_lock, flags);
+		}
+		spin_unlock_irqrestore(&sriov->alias_guid.ag_work_lock, flags);
+	}
+	for (i = 0 ; i < MLX4_MAX_PORTS; i++) {
+		/*force flush anyway.*/
+		flush_workqueue(dev->sriov.alias_guid.ports_guid[i].wq);
+		destroy_workqueue(dev->sriov.alias_guid.ports_guid[i].wq);
+	}
+	ib_sa_unregister_client(dev->sriov.alias_guid.sa_client);
+	kfree(dev->sriov.alias_guid.sa_client);
+}
+
+int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
+{
+	char alias_wq_name[15];
+	int ret = 0;
+	int i, j, k;
+	union ib_gid gid;
+
+	if (!mlx4_is_master(dev->dev))
+		return 0;
+	dev->sriov.alias_guid.sa_client =
+		kzalloc(sizeof *dev->sriov.alias_guid.sa_client, GFP_KERNEL);
+	if (!dev->sriov.alias_guid.sa_client) {
+		mlx4_ib_dbg("%s:No Memory for sa_client\n", __func__);
+		return -ENOMEM;
+	}
+	ib_sa_register_client(dev->sriov.alias_guid.sa_client);
+
+	spin_lock_init(&dev->sriov.alias_guid.ag_work_lock);
+
+	for (i = 1; i <= dev->num_ports; ++i) {
+		if (dev->ib_dev.query_gid(&dev->ib_dev , i, 0, &gid)) {
+			ret = -EFAULT;
+			goto err;
+		}
+	}
+
+	for (i = 0 ; i < MLX4_MAX_PORTS; i++) {
+		memset(&dev->sriov.alias_guid.ports_guid[i], 0,
+		       sizeof(struct mlx4_sriov_alias_guid_port_rec_det));
+		/*Check if the SM doesn't need to assign the GUIDs*/
+		for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
+			if (mlx4_ib_sm_guid_assign) {
+				dev->sriov.alias_guid.ports_guid[i].
+					all_rec_per_port[j].
+					ownership = MLX4_GUID_DRIVER_ASSIGN;
+			} else {
+				dev->sriov.alias_guid.ports_guid[i].
+					all_rec_per_port[j].
+					ownership = MLX4_GUID_NONE_ASSIGN;
+				/*mark each val as it was deleted,
+				  till the sysAdmin will give it valid val*/
+				for (k = 0; k < NUM_ALIAS_GUID_IN_REC; k++) {
+					*(__be64 *)&dev->sriov.alias_guid.ports_guid[i].
+						all_rec_per_port[j].
+						all_recs[GUID_REC_SIZE * k] =
+						cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL);
+				}
+			}
+		}
+		INIT_LIST_HEAD(&dev->sriov.alias_guid.ports_guid[i].cb_list);
+		/*prepare the records, set them to be allocated by sm*/
+		for (j = 0 ; j < NUM_ALIAS_GUID_REC_IN_PORT; j++)
+			invalidate_guid_record(dev, i + 1, j);
+
+		dev->sriov.alias_guid.ports_guid[i].parent = &dev->sriov.alias_guid;
+		dev->sriov.alias_guid.ports_guid[i].port  = i;
+		if (mlx4_ib_sm_guid_assign)
+			set_all_slaves_guids(dev, i);
+
+		snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
+		dev->sriov.alias_guid.ports_guid[i].wq =
+			create_singlethread_workqueue(alias_wq_name);
+		if (!dev->sriov.alias_guid.ports_guid[i].wq) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		INIT_DELAYED_WORK(&dev->sriov.alias_guid.ports_guid[i].alias_guid_work,
+			  alias_guid_work);
+	}
+	return 0;
+err:
+	pr_err("init_alias_guid_service: Failed. (ret:%d)\n", ret);
+	return ret;
+}
+
+static void init_query_mad(struct ib_smp *mad)
+{
+	mad->base_version  = 1;
+	mad->mgmt_class    = IB_MGMT_CLASS_SUBN_LID_ROUTED;
+	mad->class_version = 1;
+	mad->method	   = IB_MGMT_METHOD_GET;
+}
+
+int mlx4_ib_get_indexed_gid(struct ib_device *ibdev, u8 port, int index,
+			       union ib_gid *gid)
+{
+	struct ib_smp *in_mad  = NULL;
+	struct ib_smp *out_mad = NULL;
+	int err = -ENOMEM;
+	struct mlx4_ib_dev *dev = to_mdev(ibdev);
+
+	in_mad  = kzalloc(sizeof *in_mad, GFP_KERNEL);
+	out_mad = kmalloc(sizeof *out_mad, GFP_KERNEL);
+	if (!in_mad || !out_mad)
+		goto out;
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_PORT_INFO;
+	in_mad->attr_mod = cpu_to_be32(port);
+
+	err = mlx4_MAD_IFC(dev,
+			   MLX4_MAD_IFC_IGNORE_KEYS | MLX4_MAD_IFC_NET_VIEW,
+			   port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+
+	memcpy(gid->raw, out_mad->data + 8, 8);
+
+	init_query_mad(in_mad);
+	in_mad->attr_id  = IB_SMP_ATTR_GUID_INFO;
+	in_mad->attr_mod = cpu_to_be32(index / 8);
+
+	err = mlx4_MAD_IFC(dev,
+			   MLX4_MAD_IFC_IGNORE_KEYS | MLX4_MAD_IFC_NET_VIEW,
+			   port, NULL, NULL, in_mad, out_mad);
+	if (err)
+		goto out;
+	memcpy(gid->raw + 8, out_mad->data + (index % 8) * 8, 8);
+out:
+	kfree(in_mad);
+	kfree(out_mad);
+	return err;
+}
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index f49f16c..5f2bd05 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -229,10 +229,15 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, struct ib_mad *mad,
 			break;
 
 		case IB_SMP_ATTR_GUID_INFO:
-			event.device	       = ibdev;
-			event.event	       = IB_EVENT_GID_CHANGE;
-			event.element.port_num = port_num;
-			ib_dispatch_event(&event);
+			/* paravirtualized master does not receive GID_CHG events.
+			 * The master has the GUID at index 0, which never changes.
+			 */
+			if (!mlx4_is_master(dev->dev)) {
+				event.device	       = ibdev;
+				event.event	       = IB_EVENT_GID_CHANGE;
+				event.element.port_num = port_num;
+				ib_dispatch_event(&event);
+			}
 			break;
 		default:
 			break;
@@ -781,6 +786,14 @@ static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num)
 	event.device		= &dev->ib_dev;
 	event.element.port_num	= port_num;
 	event.event		= IB_EVENT_CLIENT_REREGISTER;
+
+	/*also re-configure the alias-guid and mcg's */
+	if (mlx4_is_master(dev->dev)) {
+		mlx4_ib_invalidate_all_guid_record(dev, port_num);
+
+		if (!dev->sriov.is_going_down)
+			mlx4_ib_mcg_port_cleanup(&dev->sriov.demux[port_num - 1], 0);
+	}
 	ib_dispatch_event(&event);
 }
 
@@ -1814,6 +1827,12 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 	if (!mlx4_is_master(dev->dev))
 		mlx4_ib_warn(&dev->ib_dev, "operating in qp1 tunnel mode\n");
 	else {
+		err = mlx4_ib_init_alias_guid_service(dev);
+		if (err) {
+			mlx4_ib_warn(&dev->ib_dev, "Failed init alias guid process.\n");
+			goto paravirt_err;
+		}
+
 		mlx4_ib_warn(&dev->ib_dev, "initializing demux service for %d qp1 clients\n",
 			     dev->dev->caps.sqp_demux);
 		for (i = 0; i < dev->num_ports; i++) {
@@ -1835,6 +1854,9 @@ demux_err:
 		mlx4_ib_free_demux_ctx(&dev->sriov.demux[i]);
 		--i;
 	}
+	mlx4_ib_clear_alias_guid_work(dev);
+
+paravirt_err:
 	mlx4_ib_cm_paravirt_clean(dev, -1);
 
 	return err;
@@ -1861,5 +1883,6 @@ void mlx4_ib_close_sriov(struct mlx4_ib_dev *dev)
 		}
 
 		mlx4_ib_cm_paravirt_clean(dev, -1);
+		mlx4_ib_clear_alias_guid_work(dev);
 	}
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 9d65ac6..074b475 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -67,6 +67,10 @@ MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0");
 
 #endif /* CONFIG_MLX4_DEBUG */
 
+int mlx4_ib_sm_guid_assign = 1;
+module_param_named(sm_guid_assign, mlx4_ib_sm_guid_assign, int, 0444);
+MODULE_PARM_DESC(sm_guid_assign, "Enable SM alias_GUID assignment if sm_guid_assign > 0 (Default: 1)");
+
 static const char mlx4_ib_version[] =
 	DRV_NAME ": Mellanox ConnectX InfiniBand driver v"
 	DRV_VERSION " (" DRV_RELDATE ")\n";
@@ -1528,6 +1532,11 @@ static void mlx4_ib_event(struct mlx4_dev *dev, void *ibdev_ptr,
 	case MLX4_DEV_EVENT_PORT_UP:
 		if (p > ibdev->num_ports)
 			return;
+		if (mlx4_is_master(dev) &&
+		    rdma_port_get_link_layer(&ibdev->ib_dev, p) ==
+			IB_LINK_LAYER_INFINIBAND) {
+			mlx4_ib_invalidate_all_guid_record(ibdev, p);
+		}
 		ibev.event = IB_EVENT_PORT_ACTIVE;
 		break;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index b9ed846..b600e27 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -42,6 +42,7 @@
 #include <rdma/ib_verbs.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_mad.h>
+#include <rdma/ib_sa.h>
 
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
@@ -75,6 +76,9 @@ enum {
 #define MLX4_IB_SQ_HEADROOM(shift)	((MLX4_IB_MAX_HEADROOM >> (shift)) + 1)
 #define MLX4_IB_SQ_MAX_SPARE		(MLX4_IB_SQ_HEADROOM(MLX4_IB_SQ_MIN_WQE_SHIFT))
 
+/*module param to indicate if SM assigns the alias_GUID*/
+extern int mlx4_ib_sm_guid_assign;
+
 struct mlx4_ib_ucontext {
 	struct ib_ucontext	ibucontext;
 	struct mlx4_uar		uar;
@@ -279,6 +283,57 @@ struct mlx4_ib_ah {
 	union mlx4_ext_av       av;
 };
 
+/****************************************/
+/* alias guid support */
+/****************************************/
+#define NUM_PORT_ALIAS_GUID		2
+#define NUM_ALIAS_GUID_IN_REC		8
+#define NUM_ALIAS_GUID_REC_IN_PORT	16
+#define GUID_REC_SIZE			8
+#define NUM_ALIAS_GUID_PER_PORT		128
+#define MLX4_NOT_SET_GUID		(0x00LL)
+#define MLX4_GUID_FOR_DELETE_VAL	(~(0x00LL))
+
+enum mlx4_guid_alias_rec_status {
+	MLX4_GUID_INFO_STATUS_IDLE,
+	MLX4_GUID_INFO_STATUS_SET,
+	MLX4_GUID_INFO_STATUS_PENDING,
+};
+
+enum mlx4_guid_alias_rec_ownership {
+	MLX4_GUID_DRIVER_ASSIGN,
+	MLX4_GUID_SYSADMIN_ASSIGN,
+	MLX4_GUID_NONE_ASSIGN, /*init state of each record*/
+};
+
+enum mlx4_guid_alias_rec_method {
+	MLX4_GUID_INFO_RECORD_SET	= IB_MGMT_METHOD_SET,
+	MLX4_GUID_INFO_RECORD_DELETE	= IB_SA_METHOD_DELETE,
+};
+
+struct mlx4_sriov_alias_guid_info_rec_det {
+	u8 all_recs[GUID_REC_SIZE * NUM_ALIAS_GUID_IN_REC];
+	ib_sa_comp_mask guid_indexes; /*indicates what from the 8 records are valid*/
+	enum mlx4_guid_alias_rec_status status; /*indicates the administraively status of the record.*/
+	u8 method; /*set or delete*/
+	enum mlx4_guid_alias_rec_ownership ownership; /*indicates who assign that alias_guid record*/
+};
+
+struct mlx4_sriov_alias_guid_port_rec_det {
+	struct mlx4_sriov_alias_guid_info_rec_det all_rec_per_port[NUM_ALIAS_GUID_REC_IN_PORT];
+	struct workqueue_struct *wq;
+	struct delayed_work alias_guid_work;
+	u8 port;
+	struct mlx4_sriov_alias_guid *parent;
+	struct list_head cb_list;
+};
+
+struct mlx4_sriov_alias_guid {
+	struct mlx4_sriov_alias_guid_port_rec_det ports_guid[MLX4_MAX_PORTS];
+	spinlock_t ag_work_lock;
+	struct ib_sa_client *sa_client;
+};
+
 struct mlx4_ib_demux_work {
 	struct work_struct	work;
 	struct mlx4_ib_dev     *dev;
@@ -346,6 +401,7 @@ struct mlx4_ib_demux_ctx {
 struct mlx4_ib_sriov {
 	struct mlx4_ib_demux_ctx demux[MLX4_MAX_PORTS];
 	u16 local_lid[MLX4_MAX_PORTS];
+	struct mlx4_sriov_alias_guid alias_guid;
 	struct list_head cm_list;
 	spinlock_t id_map_lock;
 	struct rb_root sl_id_map;
@@ -609,4 +665,26 @@ int mlx4_ib_multiplex_cm_handler(struct ib_device *ibdev, int port, int slave_id
 void mlx4_ib_cm_paravirt_init(struct mlx4_ib_dev *dev);
 void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave_id);
 
+/* alias guid support */
+/*init work for port, send the (port_num - 1) for port number*/
+int mlx4_ib_init_alias_guid_work(struct mlx4_ib_dev *dev, int port);
+void mlx4_ib_clear_alias_guid_work(struct mlx4_ib_dev *dev);
+
+int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev);
+
+/*When ever you want all the record to be assign*/
+void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port);
+
+/*sysfs function:*/
+int mlx4_ib_get_indexed_gid(struct ib_device *ibdev, u8 port, int index,
+			       union ib_gid *gid);
+
+void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
+					  int block_num,
+					  u8 port_num, u8 *p_data);
+
+void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev,
+					 int block_num, u8 port_num,
+					 u8 *p_data);
+
 #endif /* MLX4_IB_H */
diff --git a/drivers/net/ethernet/mellanox/mlx4/cmd.c b/drivers/net/ethernet/mellanox/mlx4/cmd.c
index 1a7eec4..27fa6c0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cmd.c
@@ -629,8 +629,10 @@ static int get_full_pkey_table(struct mlx4_dev *dev, u8 port, u16 *table,
 
 static enum ib_port_state vf_port_state(struct mlx4_dev *dev, int port, int vf)
 {
-	/* will be modified when add alias_guid feature */
-	return IB_PORT_DOWN;
+	if (mlx4_get_slave_port_state(dev, vf, port) == SLAVE_PORT_UP)
+		return IB_PORT_ACTIVE;
+	else
+		return IB_PORT_DOWN;
 }
 
 static int mlx4_MAD_IFC_wrapper(struct mlx4_dev *dev, int slave,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
