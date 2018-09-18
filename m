From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: [PATCH 4/4] IB/mlx4: move sriov field aside from mlx4_ib_dev
Date: Tue, 18 Sep 2018 16:03:46 +0300
Message-ID: <1537275826-27247-5-git-send-email-jan.dakinevich@virtuozzo.com>
References: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537275826-27247-1-git-send-email-jan.dakinevich@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@mellanox.com>, Leon Romanovsky <leon@kernel.org>, Parav Pandit <parav@mellanox.com>, Mark Bloch <markb@mellanox.com>, Daniel Jurgens <danielj@mellanox.com>, Kees Cook <keescook@chromium.org>, Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Jan Dakinevich <jan.dakinevich@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

This is the 3rd patch of 3 of the work for decreasing size
of mlx4_ib_dev.

The field takes about 6K and could be safely allocated with kvzalloc.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 drivers/infiniband/hw/mlx4/alias_GUID.c | 192 ++++++++++++++++----------------
 drivers/infiniband/hw/mlx4/cm.c         |  32 +++---
 drivers/infiniband/hw/mlx4/mad.c        |  80 ++++++-------
 drivers/infiniband/hw/mlx4/main.c       |  17 ++-
 drivers/infiniband/hw/mlx4/mcg.c        |   4 +-
 drivers/infiniband/hw/mlx4/mlx4_ib.h    |   3 +-
 drivers/infiniband/hw/mlx4/qp.c         |   4 +-
 drivers/infiniband/hw/mlx4/sysfs.c      |  10 +-
 8 files changed, 175 insertions(+), 167 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/alias_GUID.c b/drivers/infiniband/hw/mlx4/alias_GUID.c
index 155b4df..b5f794d 100644
--- a/drivers/infiniband/hw/mlx4/alias_GUID.c
+++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
@@ -83,7 +83,7 @@ void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev, int block_num,
 	if (!mlx4_is_master(dev->dev))
 		return;
 
-	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
+	guid_indexes = be64_to_cpu((__force __be64) dev->sriov->alias_guid.
 				   ports_guid[port_num - 1].
 				   all_rec_per_port[block_num].guid_indexes);
 	pr_debug("port: %d, guid_indexes: 0x%llx\n", port_num, guid_indexes);
@@ -99,7 +99,7 @@ void mlx4_ib_update_cache_on_guid_change(struct mlx4_ib_dev *dev, int block_num,
 			}
 
 			/* cache the guid: */
-			memcpy(&dev->sriov.demux[port_index].guid_cache[slave_id],
+			memcpy(&dev->sriov->demux[port_index].guid_cache[slave_id],
 			       &p_data[i * GUID_REC_SIZE],
 			       GUID_REC_SIZE);
 		} else
@@ -114,7 +114,7 @@ static __be64 get_cached_alias_guid(struct mlx4_ib_dev *dev, int port, int index
 		pr_err("%s: ERROR: asked for index:%d\n", __func__, index);
 		return (__force __be64) -1;
 	}
-	return *(__be64 *)&dev->sriov.demux[port - 1].guid_cache[index];
+	return *(__be64 *)&dev->sriov->demux[port - 1].guid_cache[index];
 }
 
 
@@ -133,12 +133,12 @@ void mlx4_ib_slave_alias_guid_event(struct mlx4_ib_dev *dev, int slave,
 	unsigned long flags;
 	int do_work = 0;
 
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
-	if (dev->sriov.alias_guid.ports_guid[port_index].state_flags &
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags);
+	if (dev->sriov->alias_guid.ports_guid[port_index].state_flags &
 	    GUID_STATE_NEED_PORT_INIT)
 		goto unlock;
 	if (!slave_init) {
-		curr_guid = *(__be64 *)&dev->sriov.
+		curr_guid = *(__be64 *)&dev->sriov->
 			alias_guid.ports_guid[port_index].
 			all_rec_per_port[record_num].
 			all_recs[GUID_REC_SIZE * index];
@@ -151,24 +151,24 @@ void mlx4_ib_slave_alias_guid_event(struct mlx4_ib_dev *dev, int slave,
 		if (required_guid == cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL))
 			goto unlock;
 	}
-	*(__be64 *)&dev->sriov.alias_guid.ports_guid[port_index].
+	*(__be64 *)&dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[record_num].
 		all_recs[GUID_REC_SIZE * index] = required_guid;
-	dev->sriov.alias_guid.ports_guid[port_index].
+	dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[record_num].guid_indexes
 		|= mlx4_ib_get_aguid_comp_mask_from_ix(index);
-	dev->sriov.alias_guid.ports_guid[port_index].
+	dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[record_num].status
 		= MLX4_GUID_INFO_STATUS_IDLE;
 	/* set to run immediately */
-	dev->sriov.alias_guid.ports_guid[port_index].
+	dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[record_num].time_to_run = 0;
-	dev->sriov.alias_guid.ports_guid[port_index].
+	dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[record_num].
 		guids_retry_schedule[index] = 0;
 	do_work = 1;
 unlock:
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags);
 
 	if (do_work)
 		mlx4_ib_init_alias_guid_work(dev, port_index);
@@ -201,9 +201,9 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 	if (!mlx4_is_master(dev->dev))
 		return;
 
-	rec = &dev->sriov.alias_guid.ports_guid[port_num - 1].
+	rec = &dev->sriov->alias_guid.ports_guid[port_num - 1].
 			all_rec_per_port[block_num];
-	guid_indexes = be64_to_cpu((__force __be64) dev->sriov.alias_guid.
+	guid_indexes = be64_to_cpu((__force __be64) dev->sriov->alias_guid.
 				   ports_guid[port_num - 1].
 				   all_rec_per_port[block_num].guid_indexes);
 	pr_debug("port: %d, guid_indexes: 0x%llx\n", port_num, guid_indexes);
@@ -233,7 +233,7 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 		if (tmp_cur_ag != form_cache_ag)
 			continue;
 
-		spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+		spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags);
 		required_value = *(__be64 *)&rec->all_recs[i * GUID_REC_SIZE];
 
 		if (required_value == cpu_to_be64(MLX4_GUID_FOR_DELETE_VAL))
@@ -245,12 +245,12 @@ void mlx4_ib_notify_slaves_on_guid_change(struct mlx4_ib_dev *dev,
 		} else {
 			/* may notify port down if value is 0 */
 			if (tmp_cur_ag != MLX4_NOT_SET_GUID) {
-				spin_unlock_irqrestore(&dev->sriov.
+				spin_unlock_irqrestore(&dev->sriov->
 					alias_guid.ag_work_lock, flags);
 				continue;
 			}
 		}
-		spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock,
+		spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock,
 				       flags);
 		mlx4_gen_guid_change_eqe(dev->dev, slave_id, port_num);
 		/*2 cases: Valid GUID, and Invalid Guid*/
@@ -304,7 +304,7 @@ static void aliasguid_query_handler(int status,
 
 	dev = cb_ctx->dev;
 	port_index = cb_ctx->port - 1;
-	rec = &dev->sriov.alias_guid.ports_guid[port_index].
+	rec = &dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[cb_ctx->block_num];
 
 	if (status) {
@@ -324,10 +324,10 @@ static void aliasguid_query_handler(int status,
 		 be16_to_cpu(guid_rec->lid), cb_ctx->port,
 		 guid_rec->block_num);
 
-	rec = &dev->sriov.alias_guid.ports_guid[port_index].
+	rec = &dev->sriov->alias_guid.ports_guid[port_index].
 		all_rec_per_port[guid_rec->block_num];
 
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags);
 	for (i = 0 ; i < NUM_ALIAS_GUID_IN_REC; i++) {
 		__be64 sm_response, required_val;
 
@@ -421,7 +421,7 @@ static void aliasguid_query_handler(int status,
 	} else {
 		rec->status = MLX4_GUID_INFO_STATUS_SET;
 	}
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags);
 	/*
 	The func is call here to close the cases when the
 	sm doesn't send smp, so in the sa response the driver
@@ -431,12 +431,12 @@ static void aliasguid_query_handler(int status,
 					     cb_ctx->port,
 					     guid_rec->guid_info_list);
 out:
-	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	if (!dev->sriov.is_going_down) {
+	spin_lock_irqsave(&dev->sriov->going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags1);
+	if (!dev->sriov->is_going_down) {
 		get_low_record_time_index(dev, port_index, &resched_delay_sec);
-		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port_index].wq,
-				   &dev->sriov.alias_guid.ports_guid[port_index].
+		queue_delayed_work(dev->sriov->alias_guid.ports_guid[port_index].wq,
+				   &dev->sriov->alias_guid.ports_guid[port_index].
 				   alias_guid_work,
 				   msecs_to_jiffies(resched_delay_sec * 1000));
 	}
@@ -445,8 +445,8 @@ static void aliasguid_query_handler(int status,
 		kfree(cb_ctx);
 	} else
 		complete(&cb_ctx->done);
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov->going_down_lock, flags);
 }
 
 static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
@@ -455,13 +455,13 @@ static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
 	u64 cur_admin_val;
 	ib_sa_comp_mask comp_mask = 0;
 
-	dev->sriov.alias_guid.ports_guid[port - 1].all_rec_per_port[index].status
+	dev->sriov->alias_guid.ports_guid[port - 1].all_rec_per_port[index].status
 		= MLX4_GUID_INFO_STATUS_SET;
 
 	/* calculate the comp_mask for that record.*/
 	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
 		cur_admin_val =
-			*(u64 *)&dev->sriov.alias_guid.ports_guid[port - 1].
+			*(u64 *)&dev->sriov->alias_guid.ports_guid[port - 1].
 			all_rec_per_port[index].all_recs[GUID_REC_SIZE * i];
 		/*
 		check the admin value: if it's for delete (~00LL) or
@@ -474,11 +474,11 @@ static void invalidate_guid_record(struct mlx4_ib_dev *dev, u8 port, int index)
 			continue;
 		comp_mask |= mlx4_ib_get_aguid_comp_mask_from_ix(i);
 	}
-	dev->sriov.alias_guid.ports_guid[port - 1].
+	dev->sriov->alias_guid.ports_guid[port - 1].
 		all_rec_per_port[index].guid_indexes |= comp_mask;
-	if (dev->sriov.alias_guid.ports_guid[port - 1].
+	if (dev->sriov->alias_guid.ports_guid[port - 1].
 	    all_rec_per_port[index].guid_indexes)
-		dev->sriov.alias_guid.ports_guid[port - 1].
+		dev->sriov->alias_guid.ports_guid[port - 1].
 		all_rec_per_port[index].status = MLX4_GUID_INFO_STATUS_IDLE;
 
 }
@@ -497,7 +497,7 @@ static int set_guid_rec(struct ib_device *ibdev,
 	int index = rec->block_num;
 	struct mlx4_sriov_alias_guid_info_rec_det *rec_det = &rec->rec_det;
 	struct list_head *head =
-		&dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
+		&dev->sriov->alias_guid.ports_guid[port - 1].cb_list;
 
 	memset(&attr, 0, sizeof(attr));
 	err = __mlx4_ib_query_port(ibdev, port, &attr, 1);
@@ -537,12 +537,12 @@ static int set_guid_rec(struct ib_device *ibdev,
 		rec_det->guid_indexes;
 
 	init_completion(&callback_context->done);
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags1);
 	list_add_tail(&callback_context->list, head);
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags1);
 
 	callback_context->query_id =
-		ib_sa_guid_info_rec_query(dev->sriov.alias_guid.sa_client,
+		ib_sa_guid_info_rec_query(dev->sriov->alias_guid.sa_client,
 					  ibdev, port, &guid_info_rec,
 					  comp_mask, rec->method, 1000,
 					  GFP_KERNEL, aliasguid_query_handler,
@@ -552,10 +552,10 @@ static int set_guid_rec(struct ib_device *ibdev,
 		pr_debug("ib_sa_guid_info_rec_query failed, query_id: "
 			 "%d. will reschedule to the next 1 sec.\n",
 			 callback_context->query_id);
-		spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+		spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags1);
 		list_del(&callback_context->list);
 		kfree(callback_context);
-		spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
+		spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags1);
 		resched_delay = 1 * HZ;
 		err = -EAGAIN;
 		goto new_schedule;
@@ -564,16 +564,16 @@ static int set_guid_rec(struct ib_device *ibdev,
 	goto out;
 
 new_schedule:
-	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_lock_irqsave(&dev->sriov->going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags1);
 	invalidate_guid_record(dev, port, index);
-	if (!dev->sriov.is_going_down) {
-		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port - 1].wq,
-				   &dev->sriov.alias_guid.ports_guid[port - 1].alias_guid_work,
+	if (!dev->sriov->is_going_down) {
+		queue_delayed_work(dev->sriov->alias_guid.ports_guid[port - 1].wq,
+				   &dev->sriov->alias_guid.ports_guid[port - 1].alias_guid_work,
 				   resched_delay);
 	}
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov->going_down_lock, flags);
 
 out:
 	return err;
@@ -593,7 +593,7 @@ static void mlx4_ib_guid_port_init(struct mlx4_ib_dev *dev, int port)
 			    !mlx4_is_slave_active(dev->dev, entry))
 				continue;
 			guid = mlx4_get_admin_guid(dev->dev, entry, port);
-			*(__be64 *)&dev->sriov.alias_guid.ports_guid[port - 1].
+			*(__be64 *)&dev->sriov->alias_guid.ports_guid[port - 1].
 				all_rec_per_port[j].all_recs
 				[GUID_REC_SIZE * k] = guid;
 			pr_debug("guid was set, entry=%d, val=0x%llx, port=%d\n",
@@ -610,32 +610,32 @@ void mlx4_ib_invalidate_all_guid_record(struct mlx4_ib_dev *dev, int port)
 
 	pr_debug("port %d\n", port);
 
-	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
+	spin_lock_irqsave(&dev->sriov->going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags1);
 
-	if (dev->sriov.alias_guid.ports_guid[port - 1].state_flags &
+	if (dev->sriov->alias_guid.ports_guid[port - 1].state_flags &
 		GUID_STATE_NEED_PORT_INIT) {
 		mlx4_ib_guid_port_init(dev, port);
-		dev->sriov.alias_guid.ports_guid[port - 1].state_flags &=
+		dev->sriov->alias_guid.ports_guid[port - 1].state_flags &=
 			(~GUID_STATE_NEED_PORT_INIT);
 	}
 	for (i = 0; i < NUM_ALIAS_GUID_REC_IN_PORT; i++)
 		invalidate_guid_record(dev, port, i);
 
-	if (mlx4_is_master(dev->dev) && !dev->sriov.is_going_down) {
+	if (mlx4_is_master(dev->dev) && !dev->sriov->is_going_down) {
 		/*
 		make sure no work waits in the queue, if the work is already
 		queued(not on the timer) the cancel will fail. That is not a problem
 		because we just want the work started.
 		*/
-		cancel_delayed_work(&dev->sriov.alias_guid.
+		cancel_delayed_work(&dev->sriov->alias_guid.
 				      ports_guid[port - 1].alias_guid_work);
-		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port - 1].wq,
-				   &dev->sriov.alias_guid.ports_guid[port - 1].alias_guid_work,
+		queue_delayed_work(dev->sriov->alias_guid.ports_guid[port - 1].wq,
+				   &dev->sriov->alias_guid.ports_guid[port - 1].alias_guid_work,
 				   0);
 	}
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov->going_down_lock, flags);
 }
 
 static void set_required_record(struct mlx4_ib_dev *dev, u8 port,
@@ -648,7 +648,7 @@ static void set_required_record(struct mlx4_ib_dev *dev, u8 port,
 	ib_sa_comp_mask delete_guid_indexes = 0;
 	ib_sa_comp_mask set_guid_indexes = 0;
 	struct mlx4_sriov_alias_guid_info_rec_det *rec =
-			&dev->sriov.alias_guid.ports_guid[port].
+			&dev->sriov->alias_guid.ports_guid[port].
 			all_rec_per_port[record_index];
 
 	for (i = 0; i < NUM_ALIAS_GUID_IN_REC; i++) {
@@ -697,7 +697,7 @@ static int get_low_record_time_index(struct mlx4_ib_dev *dev, u8 port,
 	int j;
 
 	for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
-		rec = dev->sriov.alias_guid.ports_guid[port].
+		rec = dev->sriov->alias_guid.ports_guid[port].
 			all_rec_per_port[j];
 		if (rec.status == MLX4_GUID_INFO_STATUS_IDLE &&
 		    rec.guid_indexes) {
@@ -727,7 +727,7 @@ static int get_next_record_to_update(struct mlx4_ib_dev *dev, u8 port,
 	int record_index;
 	int ret = 0;
 
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags);
 	record_index = get_low_record_time_index(dev, port, NULL);
 
 	if (record_index < 0) {
@@ -737,7 +737,7 @@ static int get_next_record_to_update(struct mlx4_ib_dev *dev, u8 port,
 
 	set_required_record(dev, port, rec, record_index);
 out:
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags);
 	return ret;
 }
 
@@ -753,7 +753,7 @@ static void alias_guid_work(struct work_struct *work)
 	struct mlx4_ib_sriov *ib_sriov = container_of(sriov_alias_guid,
 						struct mlx4_ib_sriov,
 						alias_guid);
-	struct mlx4_ib_dev *dev = container_of(ib_sriov, struct mlx4_ib_dev, sriov);
+	struct mlx4_ib_dev *dev = ib_sriov->parent;
 
 	rec = kzalloc(sizeof *rec, GFP_KERNEL);
 	if (!rec)
@@ -778,33 +778,33 @@ void mlx4_ib_init_alias_guid_work(struct mlx4_ib_dev *dev, int port)
 
 	if (!mlx4_is_master(dev->dev))
 		return;
-	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
-	spin_lock_irqsave(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	if (!dev->sriov.is_going_down) {
+	spin_lock_irqsave(&dev->sriov->going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov->alias_guid.ag_work_lock, flags1);
+	if (!dev->sriov->is_going_down) {
 		/* If there is pending one should cancel then run, otherwise
 		  * won't run till previous one is ended as same work
 		  * struct is used.
 		  */
-		cancel_delayed_work(&dev->sriov.alias_guid.ports_guid[port].
+		cancel_delayed_work(&dev->sriov->alias_guid.ports_guid[port].
 				    alias_guid_work);
-		queue_delayed_work(dev->sriov.alias_guid.ports_guid[port].wq,
-			   &dev->sriov.alias_guid.ports_guid[port].alias_guid_work, 0);
+		queue_delayed_work(dev->sriov->alias_guid.ports_guid[port].wq,
+			   &dev->sriov->alias_guid.ports_guid[port].alias_guid_work, 0);
 	}
-	spin_unlock_irqrestore(&dev->sriov.alias_guid.ag_work_lock, flags1);
-	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->alias_guid.ag_work_lock, flags1);
+	spin_unlock_irqrestore(&dev->sriov->going_down_lock, flags);
 }
 
 void mlx4_ib_destroy_alias_guid_service(struct mlx4_ib_dev *dev)
 {
 	int i;
-	struct mlx4_ib_sriov *sriov = &dev->sriov;
+	struct mlx4_ib_sriov *sriov = dev->sriov;
 	struct mlx4_alias_guid_work_context *cb_ctx;
 	struct mlx4_sriov_alias_guid_port_rec_det *det;
 	struct ib_sa_query *sa_query;
 	unsigned long flags;
 
 	for (i = 0 ; i < dev->num_ports; i++) {
-		cancel_delayed_work(&dev->sriov.alias_guid.ports_guid[i].alias_guid_work);
+		cancel_delayed_work(&dev->sriov->alias_guid.ports_guid[i].alias_guid_work);
 		det = &sriov->alias_guid.ports_guid[i];
 		spin_lock_irqsave(&sriov->alias_guid.ag_work_lock, flags);
 		while (!list_empty(&det->cb_list)) {
@@ -823,11 +823,11 @@ void mlx4_ib_destroy_alias_guid_service(struct mlx4_ib_dev *dev)
 		spin_unlock_irqrestore(&sriov->alias_guid.ag_work_lock, flags);
 	}
 	for (i = 0 ; i < dev->num_ports; i++) {
-		flush_workqueue(dev->sriov.alias_guid.ports_guid[i].wq);
-		destroy_workqueue(dev->sriov.alias_guid.ports_guid[i].wq);
+		flush_workqueue(dev->sriov->alias_guid.ports_guid[i].wq);
+		destroy_workqueue(dev->sriov->alias_guid.ports_guid[i].wq);
 	}
-	ib_sa_unregister_client(dev->sriov.alias_guid.sa_client);
-	kfree(dev->sriov.alias_guid.sa_client);
+	ib_sa_unregister_client(dev->sriov->alias_guid.sa_client);
+	kfree(dev->sriov->alias_guid.sa_client);
 }
 
 int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
@@ -839,14 +839,14 @@ int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 
 	if (!mlx4_is_master(dev->dev))
 		return 0;
-	dev->sriov.alias_guid.sa_client =
-		kzalloc(sizeof *dev->sriov.alias_guid.sa_client, GFP_KERNEL);
-	if (!dev->sriov.alias_guid.sa_client)
+	dev->sriov->alias_guid.sa_client =
+		kzalloc(sizeof *dev->sriov->alias_guid.sa_client, GFP_KERNEL);
+	if (!dev->sriov->alias_guid.sa_client)
 		return -ENOMEM;
 
-	ib_sa_register_client(dev->sriov.alias_guid.sa_client);
+	ib_sa_register_client(dev->sriov->alias_guid.sa_client);
 
-	spin_lock_init(&dev->sriov.alias_guid.ag_work_lock);
+	spin_lock_init(&dev->sriov->alias_guid.ag_work_lock);
 
 	for (i = 1; i <= dev->num_ports; ++i) {
 		if (dev->ib_dev.query_gid(&dev->ib_dev , i, 0, &gid)) {
@@ -856,18 +856,18 @@ int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 	}
 
 	for (i = 0 ; i < dev->num_ports; i++) {
-		memset(&dev->sriov.alias_guid.ports_guid[i], 0,
+		memset(&dev->sriov->alias_guid.ports_guid[i], 0,
 		       sizeof (struct mlx4_sriov_alias_guid_port_rec_det));
-		dev->sriov.alias_guid.ports_guid[i].state_flags |=
+		dev->sriov->alias_guid.ports_guid[i].state_flags |=
 				GUID_STATE_NEED_PORT_INIT;
 		for (j = 0; j < NUM_ALIAS_GUID_REC_IN_PORT; j++) {
 			/* mark each val as it was deleted */
-			memset(dev->sriov.alias_guid.ports_guid[i].
+			memset(dev->sriov->alias_guid.ports_guid[i].
 				all_rec_per_port[j].all_recs, 0xFF,
-				sizeof(dev->sriov.alias_guid.ports_guid[i].
+				sizeof(dev->sriov->alias_guid.ports_guid[i].
 				all_rec_per_port[j].all_recs));
 		}
-		INIT_LIST_HEAD(&dev->sriov.alias_guid.ports_guid[i].cb_list);
+		INIT_LIST_HEAD(&dev->sriov->alias_guid.ports_guid[i].cb_list);
 		/*prepare the records, set them to be allocated by sm*/
 		if (mlx4_ib_sm_guid_assign)
 			for (j = 1; j < NUM_ALIAS_GUID_PER_PORT; j++)
@@ -875,31 +875,31 @@ int mlx4_ib_init_alias_guid_service(struct mlx4_ib_dev *dev)
 		for (j = 0 ; j < NUM_ALIAS_GUID_REC_IN_PORT; j++)
 			invalidate_guid_record(dev, i + 1, j);
 
-		dev->sriov.alias_guid.ports_guid[i].parent = &dev->sriov.alias_guid;
-		dev->sriov.alias_guid.ports_guid[i].port  = i;
+		dev->sriov->alias_guid.ports_guid[i].parent = &dev->sriov->alias_guid;
+		dev->sriov->alias_guid.ports_guid[i].port  = i;
 
 		snprintf(alias_wq_name, sizeof alias_wq_name, "alias_guid%d", i);
-		dev->sriov.alias_guid.ports_guid[i].wq =
+		dev->sriov->alias_guid.ports_guid[i].wq =
 			alloc_ordered_workqueue(alias_wq_name, WQ_MEM_RECLAIM);
-		if (!dev->sriov.alias_guid.ports_guid[i].wq) {
+		if (!dev->sriov->alias_guid.ports_guid[i].wq) {
 			ret = -ENOMEM;
 			goto err_thread;
 		}
-		INIT_DELAYED_WORK(&dev->sriov.alias_guid.ports_guid[i].alias_guid_work,
+		INIT_DELAYED_WORK(&dev->sriov->alias_guid.ports_guid[i].alias_guid_work,
 			  alias_guid_work);
 	}
 	return 0;
 
 err_thread:
 	for (--i; i >= 0; i--) {
-		destroy_workqueue(dev->sriov.alias_guid.ports_guid[i].wq);
-		dev->sriov.alias_guid.ports_guid[i].wq = NULL;
+		destroy_workqueue(dev->sriov->alias_guid.ports_guid[i].wq);
+		dev->sriov->alias_guid.ports_guid[i].wq = NULL;
 	}
 
 err_unregister:
-	ib_sa_unregister_client(dev->sriov.alias_guid.sa_client);
-	kfree(dev->sriov.alias_guid.sa_client);
-	dev->sriov.alias_guid.sa_client = NULL;
+	ib_sa_unregister_client(dev->sriov->alias_guid.sa_client);
+	kfree(dev->sriov->alias_guid.sa_client);
+	dev->sriov->alias_guid.sa_client = NULL;
 	pr_err("init_alias_guid_service: Failed. (ret:%d)\n", ret);
 	return ret;
 }
diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index fedaf82..3712109 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -143,7 +143,7 @@ static union ib_gid gid_from_req_msg(struct ib_device *ibdev, struct ib_mad *mad
 static struct id_map_entry *
 id_map_find_by_sl_id(struct ib_device *ibdev, u32 slave_id, u32 sl_cm_id)
 {
-	struct rb_root *sl_id_map = &to_mdev(ibdev)->sriov.sl_id_map;
+	struct rb_root *sl_id_map = &to_mdev(ibdev)->sriov->sl_id_map;
 	struct rb_node *node = sl_id_map->rb_node;
 
 	while (node) {
@@ -170,7 +170,7 @@ static void id_map_ent_timeout(struct work_struct *work)
 	struct id_map_entry *ent = container_of(delay, struct id_map_entry, timeout);
 	struct id_map_entry *db_ent, *found_ent;
 	struct mlx4_ib_dev *dev = ent->dev;
-	struct mlx4_ib_sriov *sriov = &dev->sriov;
+	struct mlx4_ib_sriov *sriov = dev->sriov;
 	struct rb_root *sl_id_map = &sriov->sl_id_map;
 	int pv_id = (int) ent->pv_cm_id;
 
@@ -191,7 +191,7 @@ static void id_map_ent_timeout(struct work_struct *work)
 
 static void id_map_find_del(struct ib_device *ibdev, int pv_cm_id)
 {
-	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
+	struct mlx4_ib_sriov *sriov = to_mdev(ibdev)->sriov;
 	struct rb_root *sl_id_map = &sriov->sl_id_map;
 	struct id_map_entry *ent, *found_ent;
 
@@ -209,7 +209,7 @@ static void id_map_find_del(struct ib_device *ibdev, int pv_cm_id)
 
 static void sl_id_map_add(struct ib_device *ibdev, struct id_map_entry *new)
 {
-	struct rb_root *sl_id_map = &to_mdev(ibdev)->sriov.sl_id_map;
+	struct rb_root *sl_id_map = &to_mdev(ibdev)->sriov->sl_id_map;
 	struct rb_node **link = &sl_id_map->rb_node, *parent = NULL;
 	struct id_map_entry *ent;
 	int slave_id = new->slave_id;
@@ -244,7 +244,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 {
 	int ret;
 	struct id_map_entry *ent;
-	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
+	struct mlx4_ib_sriov *sriov = to_mdev(ibdev)->sriov;
 
 	ent = kmalloc(sizeof (struct id_map_entry), GFP_KERNEL);
 	if (!ent)
@@ -257,7 +257,7 @@ id_map_alloc(struct ib_device *ibdev, int slave_id, u32 sl_cm_id)
 	INIT_DELAYED_WORK(&ent->timeout, id_map_ent_timeout);
 
 	idr_preload(GFP_KERNEL);
-	spin_lock(&to_mdev(ibdev)->sriov.id_map_lock);
+	spin_lock(&to_mdev(ibdev)->sriov->id_map_lock);
 
 	ret = idr_alloc_cyclic(&sriov->pv_id_table, ent, 0, 0, GFP_NOWAIT);
 	if (ret >= 0) {
@@ -282,7 +282,7 @@ static struct id_map_entry *
 id_map_get(struct ib_device *ibdev, int *pv_cm_id, int slave_id, int sl_cm_id)
 {
 	struct id_map_entry *ent;
-	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
+	struct mlx4_ib_sriov *sriov = to_mdev(ibdev)->sriov;
 
 	spin_lock(&sriov->id_map_lock);
 	if (*pv_cm_id == -1) {
@@ -298,7 +298,7 @@ id_map_get(struct ib_device *ibdev, int *pv_cm_id, int slave_id, int sl_cm_id)
 
 static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id)
 {
-	struct mlx4_ib_sriov *sriov = &to_mdev(ibdev)->sriov;
+	struct mlx4_ib_sriov *sriov = to_mdev(ibdev)->sriov;
 	unsigned long flags;
 
 	spin_lock(&sriov->id_map_lock);
@@ -404,17 +404,17 @@ int mlx4_ib_demux_cm_handler(struct ib_device *ibdev, int port, int *slave,
 
 void mlx4_ib_cm_paravirt_init(struct mlx4_ib_dev *dev)
 {
-	spin_lock_init(&dev->sriov.id_map_lock);
-	INIT_LIST_HEAD(&dev->sriov.cm_list);
-	dev->sriov.sl_id_map = RB_ROOT;
-	idr_init(&dev->sriov.pv_id_table);
+	spin_lock_init(&dev->sriov->id_map_lock);
+	INIT_LIST_HEAD(&dev->sriov->cm_list);
+	dev->sriov->sl_id_map = RB_ROOT;
+	idr_init(&dev->sriov->pv_id_table);
 }
 
 /* slave = -1 ==> all slaves */
 /* TBD -- call paravirt clean for single slave.  Need for slave RESET event */
 void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 {
-	struct mlx4_ib_sriov *sriov = &dev->sriov;
+	struct mlx4_ib_sriov *sriov = dev->sriov;
 	struct rb_root *sl_id_map = &sriov->sl_id_map;
 	struct list_head lh;
 	struct rb_node *nd;
@@ -423,7 +423,7 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 	/* cancel all delayed work queue entries */
 	INIT_LIST_HEAD(&lh);
 	spin_lock(&sriov->id_map_lock);
-	list_for_each_entry_safe(map, tmp_map, &dev->sriov.cm_list, list) {
+	list_for_each_entry_safe(map, tmp_map, &dev->sriov->cm_list, list) {
 		if (slave < 0 || slave == map->slave_id) {
 			if (map->scheduled_delete)
 				need_flush |= !cancel_delayed_work(&map->timeout);
@@ -446,7 +446,7 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 			rb_erase(&ent->node, sl_id_map);
 			idr_remove(&sriov->pv_id_table, (int) ent->pv_cm_id);
 		}
-		list_splice_init(&dev->sriov.cm_list, &lh);
+		list_splice_init(&dev->sriov->cm_list, &lh);
 	} else {
 		/* first, move nodes belonging to slave to db remove list */
 		nd = rb_first(sl_id_map);
@@ -464,7 +464,7 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 		}
 
 		/* add remaining nodes from cm_list */
-		list_for_each_entry_safe(map, tmp_map, &dev->sriov.cm_list, list) {
+		list_for_each_entry_safe(map, tmp_map, &dev->sriov->cm_list, list) {
 			if (slave == map->slave_id)
 				list_move_tail(&map->list, &lh);
 		}
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 3eceb46..88fe6cd 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -281,7 +281,7 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, const struct ib_mad
 			if (pkey_change_bitmap) {
 				mlx4_ib_dispatch_event(dev, port_num,
 						       IB_EVENT_PKEY_CHANGE);
-				if (!dev->sriov.is_going_down)
+				if (!dev->sriov->is_going_down)
 					__propagate_pkey_ev(dev, port_num, bn,
 							    pkey_change_bitmap);
 			}
@@ -296,7 +296,7 @@ static void smp_snoop(struct ib_device *ibdev, u8 port_num, const struct ib_mad
 						       IB_EVENT_GID_CHANGE);
 			/*if master, notify relevant slaves*/
 			if (mlx4_is_master(dev->dev) &&
-			    !dev->sriov.is_going_down) {
+			    !dev->sriov->is_going_down) {
 				bn = be32_to_cpu(((struct ib_smp *)mad)->attr_mod);
 				mlx4_ib_update_cache_on_guid_change(dev, bn, port_num,
 								    (u8 *)(&((struct ib_smp *)mad)->data));
@@ -435,7 +435,7 @@ int mlx4_ib_find_real_gid(struct ib_device *ibdev, u8 port, __be64 guid)
 	int i;
 
 	for (i = 0; i < dev->dev->caps.sqp_demux; i++) {
-		if (dev->sriov.demux[port - 1].guid_cache[i] == guid)
+		if (dev->sriov->demux[port - 1].guid_cache[i] == guid)
 			return i;
 	}
 	return -1;
@@ -523,7 +523,7 @@ int mlx4_ib_send_to_slave(struct mlx4_ib_dev *dev, int slave, u8 port,
 	if (dest_qpt > IB_QPT_GSI)
 		return -EINVAL;
 
-	tun_ctx = dev->sriov.demux[port-1].tun[slave];
+	tun_ctx = dev->sriov->demux[port-1].tun[slave];
 
 	/* check if proxy qp created */
 	if (!tun_ctx || tun_ctx->state != DEMUX_PV_STATE_ACTIVE)
@@ -736,7 +736,7 @@ static int mlx4_ib_demux_mad(struct ib_device *ibdev, u8 port,
 		if (grh->dgid.global.interface_id ==
 			cpu_to_be64(IB_SA_WELL_KNOWN_GUID) &&
 		    grh->dgid.global.subnet_prefix == cpu_to_be64(
-			atomic64_read(&dev->sriov.demux[port - 1].subnet_prefix))) {
+			atomic64_read(&dev->sriov->demux[port - 1].subnet_prefix))) {
 			slave = 0;
 		} else {
 			slave = mlx4_ib_find_real_gid(ibdev, port,
@@ -1085,7 +1085,7 @@ static void handle_lid_change_event(struct mlx4_ib_dev *dev, u8 port_num)
 {
 	mlx4_ib_dispatch_event(dev, port_num, IB_EVENT_LID_CHANGE);
 
-	if (mlx4_is_master(dev->dev) && !dev->sriov.is_going_down)
+	if (mlx4_is_master(dev->dev) && !dev->sriov->is_going_down)
 		mlx4_gen_slaves_port_mgt_ev(dev->dev, port_num,
 					    MLX4_EQ_PORT_INFO_LID_CHANGE_MASK);
 }
@@ -1096,8 +1096,8 @@ static void handle_client_rereg_event(struct mlx4_ib_dev *dev, u8 port_num)
 	if (mlx4_is_master(dev->dev)) {
 		mlx4_ib_invalidate_all_guid_record(dev, port_num);
 
-		if (!dev->sriov.is_going_down) {
-			mlx4_ib_mcg_port_cleanup(&dev->sriov.demux[port_num - 1], 0);
+		if (!dev->sriov->is_going_down) {
+			mlx4_ib_mcg_port_cleanup(&dev->sriov->demux[port_num - 1], 0);
 			mlx4_gen_slaves_port_mgt_ev(dev->dev, port_num,
 						    MLX4_EQ_PORT_INFO_CLIENT_REREG_MASK);
 		}
@@ -1223,9 +1223,9 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 				} else {
 					pr_debug("Changing QP1 subnet prefix for port %d. old=0x%llx. new=0x%llx\n",
 						 port,
-						 (u64)atomic64_read(&dev->sriov.demux[port - 1].subnet_prefix),
+						 (u64)atomic64_read(&dev->sriov->demux[port - 1].subnet_prefix),
 						 be64_to_cpu(gid.global.subnet_prefix));
-					atomic64_set(&dev->sriov.demux[port - 1].subnet_prefix,
+					atomic64_set(&dev->sriov->demux[port - 1].subnet_prefix,
 						     be64_to_cpu(gid.global.subnet_prefix));
 				}
 			}
@@ -1242,7 +1242,7 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 
 	case MLX4_DEV_PMC_SUBTYPE_PKEY_TABLE:
 		mlx4_ib_dispatch_event(dev, port, IB_EVENT_PKEY_CHANGE);
-		if (mlx4_is_master(dev->dev) && !dev->sriov.is_going_down)
+		if (mlx4_is_master(dev->dev) && !dev->sriov->is_going_down)
 			propagate_pkey_ev(dev, port, eqe);
 		break;
 	case MLX4_DEV_PMC_SUBTYPE_GUID_INFO:
@@ -1250,7 +1250,7 @@ void handle_port_mgmt_change_event(struct work_struct *work)
 		if (!mlx4_is_master(dev->dev))
 			mlx4_ib_dispatch_event(dev, port, IB_EVENT_GID_CHANGE);
 		/*if master, notify relevant slaves*/
-		else if (!dev->sriov.is_going_down) {
+		else if (!dev->sriov->is_going_down) {
 			tbl_block = GET_BLK_PTR_FROM_EQE(eqe);
 			change_bitmap = GET_MASK_FROM_EQE(eqe);
 			handle_slaves_guid_change(dev, port, tbl_block, change_bitmap);
@@ -1299,10 +1299,10 @@ static void mlx4_ib_tunnel_comp_handler(struct ib_cq *cq, void *arg)
 	unsigned long flags;
 	struct mlx4_ib_demux_pv_ctx *ctx = cq->cq_context;
 	struct mlx4_ib_dev *dev = to_mdev(ctx->ib_dev);
-	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
-	if (!dev->sriov.is_going_down && ctx->state == DEMUX_PV_STATE_ACTIVE)
+	spin_lock_irqsave(&dev->sriov->going_down_lock, flags);
+	if (!dev->sriov->is_going_down && ctx->state == DEMUX_PV_STATE_ACTIVE)
 		queue_work(ctx->wq, &ctx->work);
-	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	spin_unlock_irqrestore(&dev->sriov->going_down_lock, flags);
 }
 
 static int mlx4_ib_post_pv_qp_buf(struct mlx4_ib_demux_pv_ctx *ctx,
@@ -1373,7 +1373,7 @@ int mlx4_ib_send_to_wire(struct mlx4_ib_dev *dev, int slave, u8 port,
 	u16 wire_pkey_ix;
 	int src_qpnum;
 
-	sqp_ctx = dev->sriov.sqps[port-1];
+	sqp_ctx = dev->sriov->sqps[port-1];
 
 	/* check if proxy qp created */
 	if (!sqp_ctx || sqp_ctx->state != DEMUX_PV_STATE_ACTIVE)
@@ -1960,9 +1960,9 @@ static int alloc_pv_object(struct mlx4_ib_dev *dev, int slave, int port,
 
 static void free_pv_object(struct mlx4_ib_dev *dev, int slave, int port)
 {
-	if (dev->sriov.demux[port - 1].tun[slave]) {
-		kfree(dev->sriov.demux[port - 1].tun[slave]);
-		dev->sriov.demux[port - 1].tun[slave] = NULL;
+	if (dev->sriov->demux[port - 1].tun[slave]) {
+		kfree(dev->sriov->demux[port - 1].tun[slave]);
+		dev->sriov->demux[port - 1].tun[slave] = NULL;
 	}
 }
 
@@ -2036,7 +2036,7 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 	else
 		INIT_WORK(&ctx->work, mlx4_ib_sqp_comp_worker);
 
-	ctx->wq = to_mdev(ibdev)->sriov.demux[port - 1].wq;
+	ctx->wq = to_mdev(ibdev)->sriov->demux[port - 1].wq;
 
 	ret = ib_req_notify_cq(ctx->cq, IB_CQ_NEXT_COMP);
 	if (ret) {
@@ -2107,25 +2107,25 @@ static int mlx4_ib_tunnels_update(struct mlx4_ib_dev *dev, int slave,
 	int ret = 0;
 
 	if (!do_init) {
-		clean_vf_mcast(&dev->sriov.demux[port - 1], slave);
+		clean_vf_mcast(&dev->sriov->demux[port - 1], slave);
 		/* for master, destroy real sqp resources */
 		if (slave == mlx4_master_func_num(dev->dev))
 			destroy_pv_resources(dev, slave, port,
-					     dev->sriov.sqps[port - 1], 1);
+					     dev->sriov->sqps[port - 1], 1);
 		/* destroy the tunnel qp resources */
 		destroy_pv_resources(dev, slave, port,
-				     dev->sriov.demux[port - 1].tun[slave], 1);
+				     dev->sriov->demux[port - 1].tun[slave], 1);
 		return 0;
 	}
 
 	/* create the tunnel qp resources */
 	ret = create_pv_resources(&dev->ib_dev, slave, port, 1,
-				  dev->sriov.demux[port - 1].tun[slave]);
+				  dev->sriov->demux[port - 1].tun[slave]);
 
 	/* for master, create the real sqp resources */
 	if (!ret && slave == mlx4_master_func_num(dev->dev))
 		ret = create_pv_resources(&dev->ib_dev, slave, port, 0,
-					  dev->sriov.sqps[port - 1]);
+					  dev->sriov->sqps[port - 1]);
 	return ret;
 }
 
@@ -2276,8 +2276,8 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 	if (!mlx4_is_mfunc(dev->dev))
 		return 0;
 
-	dev->sriov.is_going_down = 0;
-	spin_lock_init(&dev->sriov.going_down_lock);
+	dev->sriov->is_going_down = 0;
+	spin_lock_init(&dev->sriov->going_down_lock);
 	mlx4_ib_cm_paravirt_init(dev);
 
 	mlx4_ib_warn(&dev->ib_dev, "multi-function enabled\n");
@@ -2312,14 +2312,14 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 		err = __mlx4_ib_query_gid(&dev->ib_dev, i + 1, 0, &gid, 1);
 		if (err)
 			goto demux_err;
-		dev->sriov.demux[i].guid_cache[0] = gid.global.interface_id;
-		atomic64_set(&dev->sriov.demux[i].subnet_prefix,
+		dev->sriov->demux[i].guid_cache[0] = gid.global.interface_id;
+		atomic64_set(&dev->sriov->demux[i].subnet_prefix,
 			     be64_to_cpu(gid.global.subnet_prefix));
 		err = alloc_pv_object(dev, mlx4_master_func_num(dev->dev), i + 1,
-				      &dev->sriov.sqps[i]);
+				      &dev->sriov->sqps[i]);
 		if (err)
 			goto demux_err;
-		err = mlx4_ib_alloc_demux_ctx(dev, &dev->sriov.demux[i], i + 1);
+		err = mlx4_ib_alloc_demux_ctx(dev, &dev->sriov->demux[i], i + 1);
 		if (err)
 			goto free_pv;
 	}
@@ -2331,7 +2331,7 @@ int mlx4_ib_init_sriov(struct mlx4_ib_dev *dev)
 demux_err:
 	while (--i >= 0) {
 		free_pv_object(dev, mlx4_master_func_num(dev->dev), i + 1);
-		mlx4_ib_free_demux_ctx(&dev->sriov.demux[i]);
+		mlx4_ib_free_demux_ctx(&dev->sriov->demux[i]);
 	}
 	mlx4_ib_device_unregister_sysfs(dev);
 
@@ -2352,16 +2352,16 @@ void mlx4_ib_close_sriov(struct mlx4_ib_dev *dev)
 	if (!mlx4_is_mfunc(dev->dev))
 		return;
 
-	spin_lock_irqsave(&dev->sriov.going_down_lock, flags);
-	dev->sriov.is_going_down = 1;
-	spin_unlock_irqrestore(&dev->sriov.going_down_lock, flags);
+	spin_lock_irqsave(&dev->sriov->going_down_lock, flags);
+	dev->sriov->is_going_down = 1;
+	spin_unlock_irqrestore(&dev->sriov->going_down_lock, flags);
 	if (mlx4_is_master(dev->dev)) {
 		for (i = 0; i < dev->num_ports; i++) {
-			flush_workqueue(dev->sriov.demux[i].ud_wq);
-			mlx4_ib_free_sqp_ctx(dev->sriov.sqps[i]);
-			kfree(dev->sriov.sqps[i]);
-			dev->sriov.sqps[i] = NULL;
-			mlx4_ib_free_demux_ctx(&dev->sriov.demux[i]);
+			flush_workqueue(dev->sriov->demux[i].ud_wq);
+			mlx4_ib_free_sqp_ctx(dev->sriov->sqps[i]);
+			kfree(dev->sriov->sqps[i]);
+			dev->sriov->sqps[i] = NULL;
+			mlx4_ib_free_demux_ctx(&dev->sriov->demux[i]);
 		}
 
 		mlx4_ib_cm_paravirt_clean(dev, -1);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8ba0103..6d1483d 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2596,6 +2596,7 @@ static void mlx4_ib_release(struct ib_device *device)
 
 	kvfree(ibdev->iboe);
 	kvfree(ibdev->pkeys);
+	kvfree(ibdev->sriov);
 }
 
 static void *mlx4_ib_add(struct mlx4_dev *dev)
@@ -2641,6 +2642,12 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	if (!ibdev->pkeys)
 		goto err_dealloc;
 
+	ibdev->sriov = kvzalloc(sizeof(struct mlx4_ib_sriov), GFP_KERNEL);
+	if (!ibdev->sriov)
+		goto err_dealloc;
+
+	ibdev->sriov->parent = ibdev;
+
 	if (mlx4_pd_alloc(dev, &ibdev->priv_pdn))
 		goto err_dealloc;
 
@@ -3152,13 +3159,13 @@ static void do_slave_init(struct mlx4_ib_dev *ibdev, int slave, int do_init)
 		dm[i]->dev = ibdev;
 	}
 	/* initialize or tear down tunnel QPs for the slave */
-	spin_lock_irqsave(&ibdev->sriov.going_down_lock, flags);
-	if (!ibdev->sriov.is_going_down) {
+	spin_lock_irqsave(&ibdev->sriov->going_down_lock, flags);
+	if (!ibdev->sriov->is_going_down) {
 		for (i = 0; i < ports; i++)
-			queue_work(ibdev->sriov.demux[i].ud_wq, &dm[i]->work);
-		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
+			queue_work(ibdev->sriov->demux[i].ud_wq, &dm[i]->work);
+		spin_unlock_irqrestore(&ibdev->sriov->going_down_lock, flags);
 	} else {
-		spin_unlock_irqrestore(&ibdev->sriov.going_down_lock, flags);
+		spin_unlock_irqrestore(&ibdev->sriov->going_down_lock, flags);
 		for (i = 0; i < ports; i++)
 			kfree(dm[i]);
 	}
diff --git a/drivers/infiniband/hw/mlx4/mcg.c b/drivers/infiniband/hw/mlx4/mcg.c
index 81ffc00..6415326 100644
--- a/drivers/infiniband/hw/mlx4/mcg.c
+++ b/drivers/infiniband/hw/mlx4/mcg.c
@@ -884,7 +884,7 @@ int mlx4_ib_mcg_demux_handler(struct ib_device *ibdev, int port, int slave,
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct ib_sa_mcmember_data *rec = (struct ib_sa_mcmember_data *)mad->data;
-	struct mlx4_ib_demux_ctx *ctx = &dev->sriov.demux[port - 1];
+	struct mlx4_ib_demux_ctx *ctx = &dev->sriov->demux[port - 1];
 	struct mcast_group *group;
 
 	switch (mad->mad_hdr.method) {
@@ -933,7 +933,7 @@ int mlx4_ib_mcg_multiplex_handler(struct ib_device *ibdev, int port,
 {
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct ib_sa_mcmember_data *rec = (struct ib_sa_mcmember_data *)sa_mad->data;
-	struct mlx4_ib_demux_ctx *ctx = &dev->sriov.demux[port - 1];
+	struct mlx4_ib_demux_ctx *ctx = &dev->sriov->demux[port - 1];
 	struct mcast_group *group;
 	struct mcast_req *req;
 	int may_create = 0;
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 2b5a9b2..dfe3a5c 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -501,6 +501,7 @@ struct mlx4_ib_sriov {
 	spinlock_t id_map_lock;
 	struct rb_root sl_id_map;
 	struct idr pv_id_table;
+	struct mlx4_ib_dev *parent;
 };
 
 struct gid_cache_context {
@@ -597,7 +598,7 @@ struct mlx4_ib_dev {
 	struct ib_ah	       *sm_ah[MLX4_MAX_PORTS];
 	spinlock_t		sm_lock;
 	atomic64_t		sl2vl[MLX4_MAX_PORTS];
-	struct mlx4_ib_sriov	sriov;
+	struct mlx4_ib_sriov   *sriov;
 
 	struct mutex		cap_mask_mutex;
 	bool			ib_active;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 853ef6f..f001e2f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -3031,11 +3031,11 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, const struct ib_ud_wr *wr,
 				 * we must use our own cache
 				 */
 				sqp->ud_header.grh.source_gid.global.subnet_prefix =
-					cpu_to_be64(atomic64_read(&(to_mdev(ib_dev)->sriov.
+					cpu_to_be64(atomic64_read(&(to_mdev(ib_dev)->sriov->
 								    demux[sqp->qp.port - 1].
 								    subnet_prefix)));
 				sqp->ud_header.grh.source_gid.global.interface_id =
-					to_mdev(ib_dev)->sriov.demux[sqp->qp.port - 1].
+					to_mdev(ib_dev)->sriov->demux[sqp->qp.port - 1].
 						       guid_cache[ah->av.ib.gid_index];
 			} else {
 				sqp->ud_header.grh.source_gid =
diff --git a/drivers/infiniband/hw/mlx4/sysfs.c b/drivers/infiniband/hw/mlx4/sysfs.c
index a5b4592a..15f7c38 100644
--- a/drivers/infiniband/hw/mlx4/sysfs.c
+++ b/drivers/infiniband/hw/mlx4/sysfs.c
@@ -84,25 +84,25 @@ static ssize_t store_admin_alias_guid(struct device *dev,
 		pr_err("GUID 0 block 0 is RO\n");
 		return count;
 	}
-	spin_lock_irqsave(&mdev->sriov.alias_guid.ag_work_lock, flags);
+	spin_lock_irqsave(&mdev->sriov->alias_guid.ag_work_lock, flags);
 	sscanf(buf, "%llx", &sysadmin_ag_val);
-	*(__be64 *)&mdev->sriov.alias_guid.ports_guid[port->num - 1].
+	*(__be64 *)&mdev->sriov->alias_guid.ports_guid[port->num - 1].
 		all_rec_per_port[record_num].
 		all_recs[GUID_REC_SIZE * guid_index_in_rec] =
 			cpu_to_be64(sysadmin_ag_val);
 
 	/* Change the state to be pending for update */
-	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].status
+	mdev->sriov->alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].status
 		= MLX4_GUID_INFO_STATUS_IDLE ;
 	mlx4_set_admin_guid(mdev->dev, cpu_to_be64(sysadmin_ag_val),
 			    mlx4_ib_iov_dentry->entry_num,
 			    port->num);
 
 	/* set the record index */
-	mdev->sriov.alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].guid_indexes
+	mdev->sriov->alias_guid.ports_guid[port->num - 1].all_rec_per_port[record_num].guid_indexes
 		|= mlx4_ib_get_aguid_comp_mask_from_ix(guid_index_in_rec);
 
-	spin_unlock_irqrestore(&mdev->sriov.alias_guid.ag_work_lock, flags);
+	spin_unlock_irqrestore(&mdev->sriov->alias_guid.ag_work_lock, flags);
 	mlx4_ib_init_alias_guid_work(mdev, port->num - 1);
 
 	return count;
-- 
2.1.4
