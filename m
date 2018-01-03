From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 08/28] IB/srpt: Fix kernel-doc warnings in ib_srpt.c
Date: Wed,  3 Jan 2018 13:39:18 -0800
Message-ID: <20180103213938.11664-9-bart.vanassche@wdc.com>
References: <20180103213938.11664-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180103213938.11664-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid that warnings about missing parameter descriptions are reported
when building with W=1.

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 90 ++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 81e8085bc5bb..ebdd5a4f407b 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -119,7 +119,7 @@ static bool srpt_set_ch_state(struct srpt_rdma_ch *ch, enum rdma_ch_state new)
 	return changed;
 }
 
-/**
+/*
  * srpt_event_handler() - Asynchronous IB event callback function.
  *
  * Callback function called by the InfiniBand core when an asynchronous IB
@@ -168,7 +168,7 @@ static void srpt_event_handler(struct ib_event_handler *handler,
 	}
 }
 
-/**
+/*
  * srpt_srq_event() - SRQ event callback function.
  */
 static void srpt_srq_event(struct ib_event *event, void *ctx)
@@ -193,7 +193,7 @@ static const char *get_ch_state_name(enum rdma_ch_state s)
 	return "???";
 }
 
-/**
+/*
  * srpt_qp_event() - QP event callback function.
  */
 static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
@@ -218,7 +218,7 @@ static void srpt_qp_event(struct ib_event *event, struct srpt_rdma_ch *ch)
 
 /**
  * srpt_set_ioc() - Helper function for initializing an IOUnitInfo structure.
- *
+ * @c_list: I/O controller list.
  * @slot: one-based slot number.
  * @value: four-bit value.
  *
@@ -240,7 +240,7 @@ static void srpt_set_ioc(u8 *c_list, u32 slot, u8 value)
 	}
 }
 
-/**
+/*
  * srpt_get_class_port_info() - Copy ClassPortInfo to a management datagram.
  *
  * See also section 16.3.3.1 ClassPortInfo in the InfiniBand Architecture
@@ -259,7 +259,7 @@ static void srpt_get_class_port_info(struct ib_dm_mad *mad)
 	mad->mad_hdr.status = 0;
 }
 
-/**
+/*
  * srpt_get_iou() - Write IOUnitInfo to a management datagram.
  *
  * See also section 16.3.3.3 IOUnitInfo in the InfiniBand Architecture
@@ -283,7 +283,7 @@ static void srpt_get_iou(struct ib_dm_mad *mad)
 	mad->mad_hdr.status = 0;
 }
 
-/**
+/*
  * srpt_get_ioc() - Write IOControllerprofile to a management datagram.
  *
  * See also section 16.3.3.4 IOControllerProfile in the InfiniBand
@@ -341,7 +341,7 @@ static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 	mad->mad_hdr.status = 0;
 }
 
-/**
+/*
  * srpt_get_svc_entries() - Write ServiceEntries to a management datagram.
  *
  * See also section 16.3.3.5 ServiceEntries in the InfiniBand Architecture
@@ -418,7 +418,7 @@ static void srpt_mgmt_method_get(struct srpt_port *sp, struct ib_mad *rq_mad,
 	}
 }
 
-/**
+/*
  * srpt_mad_send_handler() - Post MAD-send callback function.
  */
 static void srpt_mad_send_handler(struct ib_mad_agent *mad_agent,
@@ -428,7 +428,7 @@ static void srpt_mad_send_handler(struct ib_mad_agent *mad_agent,
 	ib_free_send_mad(mad_wc->send_buf);
 }
 
-/**
+/*
  * srpt_mad_recv_handler() - MAD reception callback function.
  */
 static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
@@ -493,7 +493,7 @@ static void srpt_mad_recv_handler(struct ib_mad_agent *mad_agent,
 	ib_free_recv_mad(mad_wc);
 }
 
-/**
+/*
  * srpt_refresh_port() - Configure a HCA port.
  *
  * Enable InfiniBand management datagram processing, update the cached sm_lid,
@@ -576,7 +576,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	return ret;
 }
 
-/**
+/*
  * srpt_unregister_mad_agent() - Unregister MAD callback functions.
  *
  * Note: It is safe to call this function more than once for the same device.
@@ -601,7 +601,7 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	}
 }
 
-/**
+/*
  * srpt_alloc_ioctx() - Allocate an SRPT I/O context structure.
  */
 static struct srpt_ioctx *srpt_alloc_ioctx(struct srpt_device *sdev,
@@ -632,7 +632,7 @@ static struct srpt_ioctx *srpt_alloc_ioctx(struct srpt_device *sdev,
 	return NULL;
 }
 
-/**
+/*
  * srpt_free_ioctx() - Free an SRPT I/O context structure.
  */
 static void srpt_free_ioctx(struct srpt_device *sdev, struct srpt_ioctx *ioctx,
@@ -684,7 +684,7 @@ static struct srpt_ioctx **srpt_alloc_ioctx_ring(struct srpt_device *sdev,
 	return ring;
 }
 
-/**
+/*
  * srpt_free_ioctx_ring() - Free the ring of SRPT I/O context structures.
  */
 static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
@@ -701,7 +701,7 @@ static void srpt_free_ioctx_ring(struct srpt_ioctx **ioctx_ring,
 	kfree(ioctx_ring);
 }
 
-/**
+/*
  * srpt_get_cmd_state() - Get the state of a SCSI command.
  */
 static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
@@ -717,7 +717,7 @@ static enum srpt_command_state srpt_get_cmd_state(struct srpt_send_ioctx *ioctx)
 	return state;
 }
 
-/**
+/*
  * srpt_set_cmd_state() - Set the state of a SCSI command.
  *
  * Does not modify the state of aborted commands. Returns the previous command
@@ -740,7 +740,7 @@ static enum srpt_command_state srpt_set_cmd_state(struct srpt_send_ioctx *ioctx,
 	return previous;
 }
 
-/**
+/*
  * srpt_test_and_set_cmd_state() - Test and set the state of a command.
  *
  * Returns true if and only if the previous command state was equal to 'old'.
@@ -764,7 +764,7 @@ static bool srpt_test_and_set_cmd_state(struct srpt_send_ioctx *ioctx,
 	return previous == old;
 }
 
-/**
+/*
  * srpt_post_recv() - Post an IB receive request.
  */
 static int srpt_post_recv(struct srpt_device *sdev, struct srpt_rdma_ch *ch,
@@ -790,7 +790,7 @@ static int srpt_post_recv(struct srpt_device *sdev, struct srpt_rdma_ch *ch,
 		return ib_post_recv(ch->qp, &wr, &bad_wr);
 }
 
-/**
+/*
  * srpt_zerolength_write() - Perform a zero-length RDMA write.
  *
  * A quote from the InfiniBand specification: C9-88: For an HCA responder
@@ -933,6 +933,8 @@ static inline void *srpt_get_desc_buf(struct srp_cmd *srp_cmd)
  * @srp_cmd: Pointer to the SRP_CMD request data.
  * @dir: Pointer to the variable to which the transfer direction will be
  *   written.
+ * @sg: [out] Pointer to the sg-list extracted from the SRP command.
+ * @sg_cnt: [out] Number of entries in @sg.
  * @data_len: Pointer to the variable to which the total data length of all
  *   descriptors in the SRP_CMD request will be written.
  *
@@ -997,7 +999,7 @@ static int srpt_get_desc_tbl(struct srpt_send_ioctx *ioctx,
 	}
 }
 
-/**
+/*
  * srpt_init_ch_qp() - Initialize queue pair attributes.
  *
  * Initialized the attributes of queue pair 'qp' by allowing local write,
@@ -1085,7 +1087,7 @@ static int srpt_ch_qp_rts(struct srpt_rdma_ch *ch, struct ib_qp *qp)
 	return ret;
 }
 
-/**
+/*
  * srpt_ch_qp_err() - Set the channel queue pair state to 'error'.
  */
 static int srpt_ch_qp_err(struct srpt_rdma_ch *ch)
@@ -1096,7 +1098,7 @@ static int srpt_ch_qp_err(struct srpt_rdma_ch *ch)
 	return ib_modify_qp(ch->qp, &qp_attr, IB_QP_STATE);
 }
 
-/**
+/*
  * srpt_get_send_ioctx() - Obtain an I/O context for sending to the initiator.
  */
 static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
@@ -1137,7 +1139,6 @@ static struct srpt_send_ioctx *srpt_get_send_ioctx(struct srpt_rdma_ch *ch)
 /**
  * srpt_abort_cmd() - Abort a SCSI command.
  * @ioctx:   I/O context associated with the SCSI command.
- * @context: Preferred execution context.
  */
 static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 {
@@ -1204,7 +1205,7 @@ static int srpt_abort_cmd(struct srpt_send_ioctx *ioctx)
 	return state;
 }
 
-/**
+/*
  * XXX: what is now target_execute_cmd used to be asynchronous, and unmapping
  * the data that has been transferred via IB RDMA had to be postponed until the
  * check_stop_free() callback.  None of this is necessary anymore and needs to
@@ -1343,7 +1344,7 @@ static int srpt_check_stop_free(struct se_cmd *cmd)
 	return target_put_sess_cmd(&ioctx->cmd);
 }
 
-/**
+/*
  * srpt_handle_cmd() - Process SRP_CMD.
  */
 static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
@@ -1425,7 +1426,7 @@ static int srp_tmr_to_tcm(int fn)
 	}
 }
 
-/**
+/*
  * srpt_handle_tsk_mgmt() - Process an SRP_TSK_MGMT information unit.
  *
  * Returns 0 if and only if the request will be processed by the target core.
@@ -1471,7 +1472,8 @@ static void srpt_handle_tsk_mgmt(struct srpt_rdma_ch *ch,
 /**
  * srpt_handle_new_iu() - Process a newly received information unit.
  * @ch:    RDMA channel through which the information unit has been received.
- * @ioctx: SRPT I/O context associated with the information unit.
+ * @recv_ioctx: Receive I/O context associated with the information unit.
+ * @send_ioctx: Send I/O context associated with the information unit.
  */
 static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 			       struct srpt_recv_ioctx *recv_ioctx,
@@ -1576,7 +1578,7 @@ static void srpt_process_wait_list(struct srpt_rdma_ch *ch)
 	}
 }
 
-/**
+/*
  * Note: Although this has not yet been observed during tests, at least in
  * theory it is possible that the srpt_get_send_ioctx() call invoked by
  * srpt_handle_new_iu() fails. This is possible because the req_lim_delta
@@ -1617,7 +1619,7 @@ static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc)
 	srpt_process_wait_list(ch);
 }
 
-/**
+/*
  * srpt_create_ch_ib() - Create receive and send completion queues.
  */
 static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
@@ -1716,7 +1718,7 @@ static void srpt_destroy_ch_ib(struct srpt_rdma_ch *ch)
 	ib_free_cq(ch->cq);
 }
 
-/**
+/*
  * srpt_close_ch() - Close an RDMA channel.
  *
  * Make sure all resources associated with the channel will be deallocated at
@@ -1899,7 +1901,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 	kref_put(&ch->kref, srpt_free_ch);
 }
 
-/**
+/*
  * srpt_cm_req_recv() - Process the event IB_CM_REQ_RECEIVED.
  *
  * Ownership of the cm_id is transferred to the target session if this
@@ -2204,7 +2206,7 @@ static void srpt_cm_rej_recv(struct srpt_rdma_ch *ch,
 	kfree(priv);
 }
 
-/**
+/*
  * srpt_cm_rtu_recv() - Process an IB_CM_RTU_RECEIVED or USER_ESTABLISHED event.
  *
  * An IB_CM_RTU_RECEIVED message indicates that the connection is established
@@ -2227,7 +2229,7 @@ static void srpt_cm_rtu_recv(struct srpt_rdma_ch *ch)
 	}
 }
 
-/**
+/*
  * srpt_cm_handler() - IB connection manager callback function.
  *
  * A non-zero return value will cause the caller destroy the CM ID.
@@ -2353,7 +2355,7 @@ static u8 tcm_to_srp_tsk_mgmt_status(const int tcm_mgmt_status)
 	return SRP_TSK_MGMT_FAILED;
 }
 
-/**
+/*
  * srpt_queue_response() - Transmits the response to a SCSI command.
  *
  * Callback function called by the TCM core. Must not block since it can be
@@ -2493,7 +2495,7 @@ static void srpt_refresh_port_work(struct work_struct *work)
 	srpt_refresh_port(sport);
 }
 
-/**
+/*
  * srpt_release_sdev() - Free the channel resources associated with a target.
  */
 static int srpt_release_sdev(struct srpt_device *sdev)
@@ -2621,7 +2623,7 @@ static int srpt_use_srq(struct srpt_device *sdev, bool use_srq)
 	return ret;
 }
 
-/**
+/*
  * srpt_add_one() - Infiniband device addition callback function.
  */
 static void srpt_add_one(struct ib_device *device)
@@ -2719,7 +2721,7 @@ static void srpt_add_one(struct ib_device *device)
 	goto out;
 }
 
-/**
+/*
  * srpt_remove_one() - InfiniBand device removal callback function.
  */
 static void srpt_remove_one(struct ib_device *device, void *client_data)
@@ -2825,7 +2827,7 @@ static void srpt_release_cmd(struct se_cmd *se_cmd)
 	spin_unlock_irqrestore(&ch->spinlock, flags);
 }
 
-/**
+/*
  * srpt_close_session() - Forcibly close a session.
  *
  * Callback function invoked by the TCM core to clean up sessions associated
@@ -2842,7 +2844,7 @@ static void srpt_close_session(struct se_session *se_sess)
 	mutex_unlock(&sdev->mutex);
 }
 
-/**
+/*
  * srpt_sess_get_index() - Return the value of scsiAttIntrPortIndex (SCSI-MIB).
  *
  * A quote from RFC 4455 (SCSI-MIB) about this MIB object:
@@ -3132,7 +3134,7 @@ static struct configfs_attribute *srpt_tpg_attrs[] = {
 	NULL,
 };
 
-/**
+/*
  * configfs callback invoked for
  * mkdir /sys/kernel/config/target/$driver/$port/$tpg
  */
@@ -3155,7 +3157,7 @@ static struct se_portal_group *srpt_make_tpg(struct se_wwn *wwn,
 	return tpg;
 }
 
-/**
+/*
  * configfs callback invoked for
  * rmdir /sys/kernel/config/target/$driver/$port/$tpg
  */
@@ -3167,7 +3169,7 @@ static void srpt_drop_tpg(struct se_portal_group *tpg)
 	core_tpg_deregister(tpg);
 }
 
-/**
+/*
  * configfs callback invoked for
  * mkdir /sys/kernel/config/target/$driver/$port
  */
@@ -3178,7 +3180,7 @@ static struct se_wwn *srpt_make_tport(struct target_fabric_configfs *tf,
 	return srpt_lookup_wwn(name) ? : ERR_PTR(-EINVAL);
 }
 
-/**
+/*
  * configfs callback invoked for
  * rmdir /sys/kernel/config/target/$driver/$port
  */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
