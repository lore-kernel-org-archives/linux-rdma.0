From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 1/9] IB/mlx4: Alias GUID adding persistency support
Date: Wed,  1 Apr 2015 14:55:49 +0300
Message-ID: <1427889357-16078-2-git-send-email-ogerlitz@mellanox.com>
References: <1427889357-16078-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1427889357-16078-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

If the SM rejects an alias GUID request the PF driver keeps trying to acquire
the specified GUID indefinitely, utilizing an exponential backoff scheme.

Retrying is managed per GUID entry. Each entry that wasn't applied holds its
next retry information. Retry requests to the SM consist of records of 8
consecutive GUIDS. Each record that contains GUIDs requiring retries holds its
next time-to-run based on the retry information of all its GUID entries. The
record having the lowest retry time will run first when that retry time
arrives.

Since the method (SET or DELETE) as sent to the SM applies to all the GUIDs in
the record, we must handle SET requests and DELETE requests in separate SM
messages (one for SETs and the other for DELETEs).

To avoid race conditions where a GUID entry request (set or delete) was
modified after the SM request was sent, we save the method and the requested
indices as part of the callback's context -- thus, only the requested indexes
are evaluated when the response is received.

When an GUID entry is approved we turn off its retry-required bit, this
prevents redundant SM retries from occurring on that record.

The port down event should be sent only when previously it was up. Likewise,
the port up event should be sent only if previously the port was down.

Synchronization was added around the flows that change entries and record state
to prevent race conditions.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c |  314 +++++++++++++++++++++++--------
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |    4 +-
 drivers/infiniband/hw/mlx4/sysfs.c      |   11 +-
 3 files changed, 245 insertions(+), 84 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index a31e031..a968388 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -58,14 +58,19 @@ struct mlx4_alias_guid_work_context {
 	int			query_id;
 	struct list_head	list;
 	int			block_num;
+	ib_sa_comp_mask		guid_indexes;
+	u8			method;
 };
 
 struct mlx4_next_alias_guid_work {
 	u8 port;
 	u8 block_num;
+	u8 method;
 	struct mlx4_sriov_alias_guid_info_rec_det rec_det;
 };
 
+static int get_low_record_time_index(struct mlx4_ib_dev *dev, u8 port,
+				     int *resched_delay_sec);
 
 void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev, int block_num,
 					 u8 port_num, u8 *p_data)
@@ -138,10 +143,15 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 	enum slave_port_state prev_state;
 	__be64 tmp_cur_ag, form_cache_ag;
 	enum slave_port_gen_event gen_event;
+	struct mlx4_sriov_alias_guid_info_rec_det *rec;
+	unsigned long flags;
+	__be64 required_value;
 
 	if (!mlx4_is_master(dev->dev))
 		return;
 
+	rec = &dev->sriov.alias_guid.ports_guid[port_num - 1].
+			all_rec_per_port[block_num];
 	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
 				   ports_guid[port_num - 1].
 				   all_rec_per_port[block_num].guid_indexes);
@@ -166,8 +176,27 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 		 */
 		if (tmp_cur_ag != form_cache_ag)
 			continue;
-		mlx4_gen_guid_change_eqe(dev->dev, slave_id, port_num);
 
+		spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+		required_value = *(__be64 *)&rec->all_recs[i * GUID_REC_SIZE];
+
+		if (required_value == cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL))
+			required_value = 0;
+
+		if (tmp_cur_ag == required_value) {
+			rec->guid_indexes = rec->guid_indexes &
+			       ~mlx4_ib_get_aguid_comp_mask_from_ix(i);
+		} else {
+			/* may notify port down if value is 0 */
+			if (tmp_cur_ag != MLX4_NOT_SET_GUID) {
+				spin_unlock_irqrestore(&dev->sriov.
+					alias_guid.ag_work_lock, flags);
+				continue;
+			}
+		}
+		spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock,
+				       flags);
+		mlx4_gen_guid_change_eqe(dev->dev, slave_id, port_num);
 		/*2 cases: Valid GUID, and Invalid Guid*/
 
 		if (tmp_cur_ag != MLX4_NOT_SET_GUID) { /*valid GUID*/
@@ -188,10 +217,14 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 			set_and_calc_slave_port_state(dev->dev, slave_id, port_num,
 						      MLX4_PORT_STATE_IB_EVENT_GID_INVALID,
 						      &gen_event);
-			pr_debug("sending PORT DOWN event to slave: %d, port: %d\n",
-				 slave_id, port_num);
-			mlx4_gen_port_state_change_eqe(dev->dev, slave_id, port_num,
-						       MLX4_PORT_CHANGE_SUBTYPE_DOWN);
+			if (gen_event == SLAVE_PORT_GEN_EVENT_DOWN) {
+				pr_debug("sending PORT DOWN event to slave: %d, port: %d\n",
+					 slave_id, port_num);
+				mlx4_gen_port_state_change_eqe(dev->dev,
+							       slave_id,
+							       port_num,
+							       MLX4_PORT_CHANGE_SUBTYPE_DOWN);
+			}
 		}
 	}
 }
@@ -206,6 +239,9 @@ static void aliasguid_query_handler(int status,
 	int i;
 	struct mlx4_sriov_alias_guid_info_rec_det *rec;
 	unsigned long flags, flags1;
+	ib_sa_comp_mask declined_guid_indexes = 0;
+	ib_sa_comp_mask applied_guid_indexes = 0;
+	unsigned int resched_delay_sec = 0;
 
 	if (!context)
 		return;
@@ -216,9 +252,9 @@ static void aliasguid_query_handler(int status,
 		all_rec_per_port[cb_ctx->block_num];
 
 	if (status) {
-		rec->status = MLX4_GUID_INFO_STATUS_IDLE;
 		pr_debug("(port: %d) failed: status = %d\n",
 			 cb_ctx->port, status);
+		rec->time_to_run = ktime_get_real_ns() + 1 * NSEC_PER_SEC;
 		goto out;
 	}
 
@@ -235,57 +271,97 @@ static void aliasguid_query_handler(int status,
 	rec = &dev->sriov.alias_guid.ports_guid[port_index].
 		all_rec_per_port[guid_rec->block_num];
 
-	rec->status = MLX4_GUID_INFO_STATUS_SET;
-	rec->method = MLX4_GUID_INFO_RECORD_SET;
-
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
 	for (i = 0 ; i < NUM_ALIAS_GUID_IN_REC; i++) {
-		__be64 tmp_cur_ag;
-		tmp_cur_ag = *(__be64 *)&guid_rec->guid_info_list[i * GUID_REC_SIZE];
+		__be64 sm_response, required_val;
+
+		if (!(cb_ctx->guid_indexes &
+			mlx4_ib_get_aguid_comp_mask_from_ix(i)))
+			continue;
+		sm_response = *(__be64 *)&guid_rec->guid_info_list
+				[i * GUID_REC_SIZE];
+		required_val = *(__be64 *)&rec->all_recs[i * GUID_REC_SIZE];
+		if (cb_ctx->method == MLX4_GUID_INFO_RECORD_DELETE) {
+			if (required_val ==
+			    cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL))
+				goto next_entry;
+
+			/* A new value was set till we got the response */
+			pr_debug("need to set new value %llx, record num %d, block_num:%d\n",
+				 be64_to_cpu(required_val),
+				 i, guid_rec->block_num);
+			goto entry_declined;
+		}
+
 		/* check if the SM didn't assign one of the records.
-		 * if it didn't, if it was not sysadmin request:
-		 * ask the SM to give a new GUID, (instead of the driver request).
+		 * if it didn't, re-ask for.
 		 */
-		if (tmp_cur_ag == MLX4_NOT_SET_GUID) {
-			mlx4_ib_warn(&dev->ib_dev, "%s:Record num %d in "
-				     "block_num: %d was declined by SM, "
-				     "ownership by %d (0 = driver, 1=sysAdmin,"
-				     " 2=None)\n", __func__, i,
-				     guid_rec->block_num, rec->ownership);
-			if (rec->ownership == MLX4_GUID_DRIVER_ASSIGN) {
-				/* if it is driver assign, asks for new GUID from SM*/
-				*(__be64 *)&rec->all_recs[i * GUID_REC_SIZE] =
-					MLX4_NOT_SET_GUID;
-
-				/* Mark the record as not assigned, and let it
-				 * be sent again in the next work sched.*/
-				rec->status = MLX4_GUID_INFO_STATUS_IDLE;
-				rec->guid_indexes |= mlx4_ib_get_aguid_comp_mask_from_ix(i);
-			}
+		if (sm_response == MLX4_NOT_SET_GUID) {
+			if (rec->guids_retry_schedule[i] == 0)
+				mlx4_ib_warn(&dev->ib_dev, "%s:Record num %d in "
+					     "block_num: %d was declined by SM, "
+					     "ownership by %d (0 = driver, 1=sysAdmin,"
+					     " 2=None)\n", __func__, i,
+					     guid_rec->block_num,
+					     rec->ownership);
+			goto entry_declined;
 		} else {
 		       /* properly assigned record. */
 		       /* We save the GUID we just got from the SM in the
 			* admin_guid in order to be persistent, and in the
 			* request from the sm the process will ask for the same GUID */
 			if (rec->ownership == MLX4_GUID_SYSADMIN_ASSIGN &&
-			    tmp_cur_ag != *(__be64 *)&rec->all_recs[i * GUID_REC_SIZE]) {
-				/* the sysadmin assignment failed.*/
-				mlx4_ib_warn(&dev->ib_dev, "%s: Failed to set"
-					     " admin guid after SysAdmin "
-					     "configuration. "
-					     "Record num %d in block_num:%d "
-					     "was declined by SM, "
-					     "new val(0x%llx) was kept\n",
-					      __func__, i,
-					     guid_rec->block_num,
-					     be64_to_cpu(*(__be64 *) &
-							 rec->all_recs[i * GUID_REC_SIZE]));
+			    sm_response != required_val) {
+				/* Warn only on first retry */
+				if (rec->guids_retry_schedule[i] == 0)
+					mlx4_ib_warn(&dev->ib_dev, "%s: Failed to set"
+						     " admin guid after SysAdmin "
+						     "configuration. "
+						     "Record num %d in block_num:%d "
+						     "was declined by SM, "
+						     "new val(0x%llx) was kept, SM returned (0x%llx)\n",
+						      __func__, i,
+						     guid_rec->block_num,
+						     be64_to_cpu(required_val),
+						     be64_to_cpu(sm_response));
+				goto entry_declined;
 			} else {
-				memcpy(&rec->all_recs[i * GUID_REC_SIZE],
-				       &guid_rec->guid_info_list[i * GUID_REC_SIZE],
-				       GUID_REC_SIZE);
+				*(__be64 *)&rec->all_recs[i * GUID_REC_SIZE] =
+					sm_response;
+				goto next_entry;
 			}
 		}
+entry_declined:
+		declined_guid_indexes |= mlx4_ib_get_aguid_comp_mask_from_ix(i);
+		rec->guids_retry_schedule[i] =
+			(rec->guids_retry_schedule[i] == 0) ?  1 :
+			min((unsigned int)60,
+			    rec->guids_retry_schedule[i] * 2);
+		/* using the minimum value among all entries in that record */
+		resched_delay_sec = (resched_delay_sec == 0) ?
+				rec->guids_retry_schedule[i] :
+				min(resched_delay_sec,
+				    rec->guids_retry_schedule[i]);
+		continue;
+
+next_entry:
+		rec->guids_retry_schedule[i] = 0;
+	}
+
+	applied_guid_indexes =  cb_ctx->guid_indexes & ~declined_guid_indexes;
+	if (declined_guid_indexes ||
+	    rec->guid_indexes & ~(applied_guid_indexes)) {
+		pr_debug("record=%d wasn't fully set, guid_indexes=0x%llx applied_indexes=0x%llx, declined_indexes=0x%llx\n",
+			 guid_rec->block_num,
+			 be64_to_cpu((__force __be64)rec->guid_indexes),
+			 be64_to_cpu((__force __be64)applied_guid_indexes),
+			 be64_to_cpu((__force __be64)declined_guid_indexes));
+		rec->time_to_run = ktime_get_real_ns() +
+			resched_delay_sec * NSEC_PER_SEC;
+	} else {
+		rec->status = MLX4_GUID_INFO_STATUS_SET;
 	}
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
 	/*
 	The func is call here to close the cases when the
 	sm doesn't send smp, so in the sa response the driver
@@ -297,10 +373,13 @@ static void aliasguid_query_handler(int status,
 out:
 	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
 	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	if (!dev->sriov.is_going_down)
+	if (!dev->sriov.is_going_down) {
+		get_low_record_time_index(dev, port_index, &resched_delay_sec);
 		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port_index].wq,
 				   &dev->sriov.alias_guid.ports_guid[port_index].
-				   alias_guid_work, 0);
+				   alias_guid_work,
+				   msecs_to_jiffies(resched_delay_sec * 1000));
+	}
 	if (cb_ctx->sa_query) {
 		list_del(&cb_ctx->list);
 		kfree(cb_ctx);
@@ -317,9 +396,7 @@ static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
 	ib_sa_comp_mask comp_mask = 0;
 
 	dev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[index].status
-		= MLX4_GUID_INFO_STATUS_IDLE;
-	dev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[index].method
-		= MLX4_GUID_INFO_RECORD_SET;
+		= MLX4_GUID_INFO_STATUS_SET;
 
 	/* calculate the comp_mask for that record.*/
 	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
@@ -340,12 +417,16 @@ static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
 		comp_mask |= mlx4_ib_get_aguid_comp_mask_from_ix(i);
 	}
 	dev->sriov.alias_guid.ports_guid[port - 1].
-		all_rec_per_port[index].guid_indexes = comp_mask;
+		all_rec_per_port[index].guid_indexes |= comp_mask;
+	if (dev->sriov.alias_guid.ports_guid[port - 1].
+	    all_rec_per_port[index].guid_indexes)
+		dev->sriov.alias_guid.ports_guid[port - 1].
+		all_rec_per_port[index].status = MLX4_GUID_INFO_STATUS_IDLE;
+
 }
 
 static int set_guid_rec(struct ib_device *ibdev,
-			u8 port, int index,
-			struct mlx4_sriov_alias_guid_info_rec_det *rec_det)
+			struct mlx4_next_alias_guid_work *rec)
 {
 	int err;
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
@@ -354,6 +435,9 @@ static int set_guid_rec(struct ib_device *ibdev,
 	struct ib_port_attr attr;
 	struct mlx4_alias_guid_work_context *callback_context;
 	unsigned long resched_delay, flags, flags1;
+	u8 port = rec->port + 1;
+	int index = rec->block_num;
+	struct mlx4_sriov_alias_guid_info_rec_det *rec_det = &rec->rec_det;
 	struct list_head *head =
 		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
 
@@ -380,6 +464,8 @@ static int set_guid_rec(struct ib_device *ibdev,
 	callback_context->port = port;
 	callback_context->dev = dev;
 	callback_context->block_num = index;
+	callback_context->guid_indexes = rec_det->guid_indexes;
+	callback_context->method = rec->method;
 
 	memset(&guid_info_rec, 0, sizeof (struct ib_sa_guidinfo_rec));
 
@@ -399,7 +485,7 @@ static int set_guid_rec(struct ib_device *ibdev,
 	callback_context->query_id =
 		ib_sa_guid_info_rec_query(dev->sriov.alias_guid.sa_client,
 					  ibdev, port, &guid_info_rec,
-					  comp_mask, rec_det->method, 1000,
+					  comp_mask, rec->method, 1000,
 					  GFP_KERNEL, aliasguid_query_handler,
 					  callback_context,
 					  &callback_context->sa_query);
@@ -462,31 +548,107 @@ void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port)
 	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
 }
 
+static void set_required_record(struct mlx4_ib_dev *dev, u8 port,
+				struct mlx4_next_alias_guid_work *next_rec,
+				int record_index)
+{
+	int i;
+	int lowset_time_entry = -1;
+	int lowest_time = 0;
+	ib_sa_comp_mask delete_guid_indexes = 0;
+	ib_sa_comp_mask set_guid_indexes = 0;
+	struct mlx4_sriov_alias_guid_info_rec_det *rec =
+			&dev->sriov.alias_guid.ports_guid[port].
+			all_rec_per_port[record_index];
+
+	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
+		if (!(rec->guid_indexes &
+			mlx4_ib_get_aguid_comp_mask_from_ix(i)))
+			continue;
+
+		if (*(__be64 *)&rec->all_recs[i * GUID_REC_SIZE] ==
+				cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL))
+			delete_guid_indexes |=
+				mlx4_ib_get_aguid_comp_mask_from_ix(i);
+		else
+			set_guid_indexes |=
+				mlx4_ib_get_aguid_comp_mask_from_ix(i);
+
+		if (lowset_time_entry == -1 || rec->guids_retry_schedule[i] <=
+			lowest_time) {
+			lowset_time_entry = i;
+			lowest_time = rec->guids_retry_schedule[i];
+		}
+	}
+
+	memcpy(&next_rec->rec_det, rec, sizeof(*rec));
+	next_rec->port = port;
+	next_rec->block_num = record_index;
+
+	if (*(__be64 *)&rec->all_recs[lowset_time_entry * GUID_REC_SIZE] ==
+				cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL)) {
+		next_rec->rec_det.guid_indexes = delete_guid_indexes;
+		next_rec->method = MLX4_GUID_INFO_RECORD_DELETE;
+	} else {
+		next_rec->rec_det.guid_indexes = set_guid_indexes;
+		next_rec->method = MLX4_GUID_INFO_RECORD_SET;
+	}
+}
+
+/* return index of record that should be updated based on lowest
+ * rescheduled time
+ */
+static int get_low_record_time_index(struct mlx4_ib_dev *dev, u8 port,
+				     int *resched_delay_sec)
+{
+	int record_index = -1;
+	u64 low_record_time = 0;
+	struct mlx4_sriov_alias_guid_info_rec_det rec;
+	int j;
+
+	for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
+		rec = dev->sriov.alias_guid.ports_guid[port].
+			all_rec_per_port[j];
+		if (rec.status == MLX4_GUID_INFO_STATUS_IDLE &&
+		    rec.guid_indexes) {
+			if (record_index == -1 ||
+			    rec.time_to_run < low_record_time) {
+				record_index = j;
+				low_record_time = rec.time_to_run;
+			}
+		}
+	}
+	if (resched_delay_sec) {
+		u64 curr_time = ktime_get_real_ns();
+
+		*resched_delay_sec = (low_record_time < curr_time) ? 0 :
+			div_u64((low_record_time - curr_time), NSEC_PER_SEC);
+	}
+
+	return record_index;
+}
+
 /* The function returns the next record that was
  * not configured (or failed to be configured) */
 static int get_next_record_to_update(struct mlx4_ib_dev *dev, u8 port,
 				     struct mlx4_next_alias_guid_work *rec)
 {
-	int j;
 	unsigned long flags;
+	int record_index;
+	int ret = 0;
 
-	for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
-		spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
-		if (dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[j].status ==
-		    MLX4_GUID_INFO_STATUS_IDLE) {
-			memcpy(&rec->rec_det,
-			       &dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[j],
-			       sizeof (struct mlx4_sriov_alias_guid_info_rec_det));
-			rec->port = port;
-			rec->block_num = j;
-			dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[j].status =
-				MLX4_GUID_INFO_STATUS_PENDING;
-			spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
-			return 0;
-		}
-		spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+	record_index = get_low_record_time_index(dev, port, NULL);
+
+	if (record_index < 0) {
+		ret = -ENOENT;
+		goto out;
 	}
-	return -ENOENT;
+
+	set_required_record(dev, port, rec, record_index);
+out:
+	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+	return ret;
 }
 
 static void set_administratively_guid_record(struct mlx4_ib_dev *dev, int port,
@@ -497,8 +659,6 @@ static void set_administratively_guid_record(struct mlx4_ib_dev *dev, int port,
 		rec_det->guid_indexes;
 	memcpy(dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].all_recs,
 	       rec_det->all_recs, NUM_ALIAS_GUID_IN_REC * GUID_REC_SIZE);
-	dev->sriov.alias_guid.ports_guid[port].all_rec_per_port[rec_index].status =
-		rec_det->status;
 }
 
 static void set_all_slaves_guids(struct mlx4_ib_dev *dev, int port)
@@ -545,9 +705,7 @@ static void alias_guid_work(struct work_struct *work)
 		goto out;
 	}
 
-	set_guid_rec(&dev->ib_dev, rec->port + 1, rec->block_num,
-		     &rec->rec_det);
-
+	set_guid_rec(&dev->ib_dev, rec);
 out:
 	kfree(rec);
 }
@@ -562,6 +720,12 @@ void mlx4_ib_init_alias_guid_work(struct mlx4_ib_dev *dev, int port)
 	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
 	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
 	if (!dev->sriov.is_going_down) {
+		/* If there is pending one should cancell then run, otherwise
+		  * won't run till previous one is ended as same work
+		  * struct is used.
+		  */
+		cancel_delayed_work(&dev->sriov.alias_guid.ports_guid[port].
+				    alias_guid_work);
 		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port].wq,
 			   &dev->sriov.alias_guid.ports_guid[port].alias_guid_work, 0);
 	}
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index f829fd9..1cfc2bb 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -342,7 +342,6 @@ struct mlx4_ib_ah {
 enum mlx4_guid_alias_rec_status {
 	MLX4_GUID_INFO_STATUS_IDLE,
 	MLX4_GUID_INFO_STATUS_SET,
-	MLX4_GUID_INFO_STATUS_PENDING,
 };
 
 enum mlx4_guid_alias_rec_ownership {
@@ -360,8 +359,9 @@ struct mlx4_sriov_alias_guid_info_rec_det {
 	u8 all_recs[GUID_REC_SIZE * NUM_ALIAS_GUID_IN_REC];
 	ib_sa_comp_mask guid_indexes; /*indicates what from the 8 records are valid*/
 	enum mlx4_guid_alias_rec_status status; /*indicates the administraively status of the record.*/
-	u8 method; /*set or delete*/
 	enum mlx4_guid_alias_rec_ownership ownership; /*indicates who assign that alias_guid record*/
+	unsigned int guids_retry_schedule[NUM_ALIAS_GUID_IN_REC];
+	u64 time_to_run;
 };
 
 struct mlx4_sriov_alias_guid_port_rec_det {
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index d10c2b8..7423d7e 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -80,6 +80,7 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 	struct mlx4_ib_iov_port *port = mlx4_ib_iov_dentry->ctx;
 	struct mlx4_ib_dev *mdev = port->dev;
 	u64 sysadmin_ag_val;
+	unsigned long flags;
 
 	record_num = mlx4_ib_iov_dentry->entry_num / 8;
 	guid_index_in_rec = mlx4_ib_iov_dentry->entry_num % 8;
@@ -87,6 +88,7 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 		pr_err("GUID 0 block 0 is RO\n");
 		return count;
 	}
+	spin_lock_irqsave(&mdev->sriov.alias_guid.ag_work_lock, flags);
 	sscanf(buf, "%llx", &sysadmin_ag_val);
 	*(__be64 *)&mdev->sriov.alias_guid.ports_guid[port->num - 1].
 		all_rec_per_port[record_num].
@@ -96,14 +98,8 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 	/* Change the state to be pending for update */
 	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].status
 		= MLX4_GUID_INFO_STATUS_IDLE ;
-
-	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].method
-		= MLX4_GUID_INFO_RECORD_SET;
-
 	switch (sysadmin_ag_val) {
 	case MLX4_GUID_FOR_DELETE_VAL:
-		mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].method
-			= MLX4_GUID_INFO_RECORD_DELETE;
 		mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].ownership
 			= MLX4_GUID_SYSADMIN_ASSIGN;
 		break;
@@ -121,8 +117,9 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 
 	/* set the record index */
 	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].guid_indexes
-		= mlx4_ib_get_aguid_comp_mask_from_ix(guid_index_in_rec);
+		|= mlx4_ib_get_aguid_comp_mask_from_ix(guid_index_in_rec);
 
+	spin_unlock_irqrestore(&mdev->sriov.alias_guid.ag_work_lock, flags);
 	mlx4_ib_init_alias_guid_work(mdev, port->num - 1);
 
 	return count;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
