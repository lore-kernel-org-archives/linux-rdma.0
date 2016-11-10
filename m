From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 0/8] Eliminate most loose COPYING files
Date: Thu, 10 Nov 2016 11:47:32 -0700
Message-ID: <1478803660-27959-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is done by pushing the copyright statement into the files in the
subdirectory without copyright.

https://github.com/linux-rdma/rdma-core/pull/39

Jason Gunthorpe (8):
  ibcm: Delete COPYING file
  iwpmd: Delete COPYING file
  srp_daemon: Push COPYING file into individual files
  umad: Push COPYING file into individual files
  ibverbs: Push COPYING file into individual files
  rdmacm: Push COPYING file into individual files
  ibacm: Push COPYING file into individual files
  mlx4: Push COPYING file into individual files

 ibacm/COPYING                              | 378 -----------------------------
 ibacm/ibacm.init.in                        |   1 +
 ibacm/man/ib_acme.1                        |   1 +
 ibacm/man/ibacm.1                          |   1 +
 ibacm/man/ibacm.7                          |   1 +
 ibacm/man/ibacm_prov.7.in                  |   1 +
 iwpmd/COPYING                              | 372 ----------------------------
 libibcm/COPYING                            | 378 -----------------------------
 libibumad/COPYING                          | 377 ----------------------------
 libibumad/man/umad_addr_dump.3             |   1 +
 libibumad/man/umad_alloc.3                 |   1 +
 libibumad/man/umad_class_str.3             |   1 +
 libibumad/man/umad_close_port.3            |   1 +
 libibumad/man/umad_debug.3                 |   1 +
 libibumad/man/umad_dump.3                  |   1 +
 libibumad/man/umad_free.3                  |   1 +
 libibumad/man/umad_get_ca.3                |   1 +
 libibumad/man/umad_get_ca_portguids.3      |   1 +
 libibumad/man/umad_get_cas_names.3         |   1 +
 libibumad/man/umad_get_fd.3                |   1 +
 libibumad/man/umad_get_issm_path.3         |   1 +
 libibumad/man/umad_get_mad.3               |   1 +
 libibumad/man/umad_get_mad_addr.3          |   1 +
 libibumad/man/umad_get_pkey.3              |   1 +
 libibumad/man/umad_get_port.3              |   1 +
 libibumad/man/umad_init.3                  |   1 +
 libibumad/man/umad_open_port.3             |   1 +
 libibumad/man/umad_poll.3                  |   1 +
 libibumad/man/umad_recv.3                  |   1 +
 libibumad/man/umad_register.3              |   1 +
 libibumad/man/umad_register2.3             |   1 +
 libibumad/man/umad_register_oui.3          |   1 +
 libibumad/man/umad_send.3                  |   1 +
 libibumad/man/umad_set_addr.3              |   1 +
 libibumad/man/umad_set_addr_net.3          |   1 +
 libibumad/man/umad_set_grh.3               |   1 +
 libibumad/man/umad_set_grh_net.3           |   1 +
 libibumad/man/umad_set_pkey.3              |   1 +
 libibumad/man/umad_size.3                  |   1 +
 libibumad/man/umad_status.3                |   1 +
 libibumad/man/umad_unregister.3            |   1 +
 libibverbs/COPYING                         | 378 -----------------------------
 libibverbs/man/ibv_alloc_mw.3              |   1 +
 libibverbs/man/ibv_alloc_pd.3              |   1 +
 libibverbs/man/ibv_asyncwatch.1            |   1 +
 libibverbs/man/ibv_attach_mcast.3          |   1 +
 libibverbs/man/ibv_bind_mw.3               |   1 +
 libibverbs/man/ibv_create_ah.3             |   1 +
 libibverbs/man/ibv_create_ah_from_wc.3     |   1 +
 libibverbs/man/ibv_create_comp_channel.3   |   1 +
 libibverbs/man/ibv_create_cq.3             |   1 +
 libibverbs/man/ibv_create_cq_ex.3          |   1 +
 libibverbs/man/ibv_create_flow.3           |   1 +
 libibverbs/man/ibv_create_qp.3             |   1 +
 libibverbs/man/ibv_create_qp_ex.3          |   1 +
 libibverbs/man/ibv_create_rwq_ind_table.3  |   1 +
 libibverbs/man/ibv_create_srq.3            |   1 +
 libibverbs/man/ibv_create_srq_ex.3         |   1 +
 libibverbs/man/ibv_create_wq.3             |   1 +
 libibverbs/man/ibv_devices.1               |   1 +
 libibverbs/man/ibv_devinfo.1               |   1 +
 libibverbs/man/ibv_event_type_str.3        |   1 +
 libibverbs/man/ibv_fork_init.3             |   1 +
 libibverbs/man/ibv_get_async_event.3       |   1 +
 libibverbs/man/ibv_get_cq_event.3          |   1 +
 libibverbs/man/ibv_get_device_guid.3       |   1 +
 libibverbs/man/ibv_get_device_list.3       |   1 +
 libibverbs/man/ibv_get_device_name.3       |   1 +
 libibverbs/man/ibv_get_srq_num.3           |   1 +
 libibverbs/man/ibv_inc_rkey.3              |   1 +
 libibverbs/man/ibv_modify_qp.3             |   1 +
 libibverbs/man/ibv_modify_srq.3            |   1 +
 libibverbs/man/ibv_modify_wq.3             |   1 +
 libibverbs/man/ibv_open_device.3           |   1 +
 libibverbs/man/ibv_open_qp.3               |   1 +
 libibverbs/man/ibv_open_xrcd.3             |   1 +
 libibverbs/man/ibv_poll_cq.3               |   1 +
 libibverbs/man/ibv_post_recv.3             |   1 +
 libibverbs/man/ibv_post_send.3             |   1 +
 libibverbs/man/ibv_post_srq_recv.3         |   1 +
 libibverbs/man/ibv_query_device.3          |   1 +
 libibverbs/man/ibv_query_device_ex.3       |   1 +
 libibverbs/man/ibv_query_gid.3             |   1 +
 libibverbs/man/ibv_query_pkey.3            |   1 +
 libibverbs/man/ibv_query_port.3            |   1 +
 libibverbs/man/ibv_query_qp.3              |   1 +
 libibverbs/man/ibv_query_rt_values_ex.3    |   1 +
 libibverbs/man/ibv_query_srq.3             |   1 +
 libibverbs/man/ibv_rate_to_mbps.3          |   1 +
 libibverbs/man/ibv_rate_to_mult.3          |   1 +
 libibverbs/man/ibv_rc_pingpong.1           |   1 +
 libibverbs/man/ibv_reg_mr.3                |   1 +
 libibverbs/man/ibv_req_notify_cq.3         |   1 +
 libibverbs/man/ibv_rereg_mr.3              |   1 +
 libibverbs/man/ibv_resize_cq.3             |   1 +
 libibverbs/man/ibv_srq_pingpong.1          |   1 +
 libibverbs/man/ibv_uc_pingpong.1           |   1 +
 libibverbs/man/ibv_ud_pingpong.1           |   1 +
 libibverbs/man/ibv_xsrq_pingpong.1         |   1 +
 libibverbs/neigh.c                         |   2 +
 libibverbs/neigh.h                         |   3 +
 libibverbs/nl1_compat.h                    |   3 +
 librdmacm/COPYING                          | 378 -----------------------------
 librdmacm/docs/rsocket                     |   1 +
 librdmacm/man/mckey.1                      |   1 +
 librdmacm/man/rcopy.1                      |   1 +
 librdmacm/man/rdma_accept.3                |   1 +
 librdmacm/man/rdma_ack_cm_event.3          |   1 +
 librdmacm/man/rdma_bind_addr.3             |   1 +
 librdmacm/man/rdma_client.1                |   1 +
 librdmacm/man/rdma_cm.7                    |   1 +
 librdmacm/man/rdma_connect.3               |   1 +
 librdmacm/man/rdma_create_ep.3             |   1 +
 librdmacm/man/rdma_create_event_channel.3  |   1 +
 librdmacm/man/rdma_create_id.3             |   1 +
 librdmacm/man/rdma_create_qp.3             |   1 +
 librdmacm/man/rdma_create_srq.3            |   1 +
 librdmacm/man/rdma_dereg_mr.3              |   1 +
 librdmacm/man/rdma_destroy_ep.3            |   1 +
 librdmacm/man/rdma_destroy_event_channel.3 |   1 +
 librdmacm/man/rdma_destroy_id.3            |   1 +
 librdmacm/man/rdma_destroy_qp.3            |   1 +
 librdmacm/man/rdma_destroy_srq.3           |   1 +
 librdmacm/man/rdma_disconnect.3            |   1 +
 librdmacm/man/rdma_event_str.3             |   1 +
 librdmacm/man/rdma_free_devices.3          |   1 +
 librdmacm/man/rdma_get_cm_event.3          |   1 +
 librdmacm/man/rdma_get_devices.3           |   1 +
 librdmacm/man/rdma_get_dst_port.3          |   1 +
 librdmacm/man/rdma_get_local_addr.3        |   1 +
 librdmacm/man/rdma_get_peer_addr.3         |   1 +
 librdmacm/man/rdma_get_recv_comp.3         |   1 +
 librdmacm/man/rdma_get_request.3           |   1 +
 librdmacm/man/rdma_get_send_comp.3         |   1 +
 librdmacm/man/rdma_get_src_port.3          |   1 +
 librdmacm/man/rdma_getaddrinfo.3           |   1 +
 librdmacm/man/rdma_join_multicast.3        |   1 +
 librdmacm/man/rdma_leave_multicast.3       |   1 +
 librdmacm/man/rdma_listen.3                |   1 +
 librdmacm/man/rdma_migrate_id.3            |   1 +
 librdmacm/man/rdma_notify.3                |   1 +
 librdmacm/man/rdma_post_read.3             |   1 +
 librdmacm/man/rdma_post_readv.3            |   1 +
 librdmacm/man/rdma_post_recv.3             |   1 +
 librdmacm/man/rdma_post_recvv.3            |   1 +
 librdmacm/man/rdma_post_send.3             |   1 +
 librdmacm/man/rdma_post_sendv.3            |   1 +
 librdmacm/man/rdma_post_ud_send.3          |   1 +
 librdmacm/man/rdma_post_write.3            |   1 +
 librdmacm/man/rdma_post_writev.3           |   1 +
 librdmacm/man/rdma_reg_msgs.3              |   1 +
 librdmacm/man/rdma_reg_read.3              |   1 +
 librdmacm/man/rdma_reg_write.3             |   1 +
 librdmacm/man/rdma_reject.3                |   1 +
 librdmacm/man/rdma_resolve_addr.3          |   1 +
 librdmacm/man/rdma_resolve_route.3         |   1 +
 librdmacm/man/rdma_server.1                |   1 +
 librdmacm/man/rdma_set_option.3            |   1 +
 librdmacm/man/rdma_xclient.1               |   1 +
 librdmacm/man/rdma_xserver.1               |   1 +
 librdmacm/man/riostream.1                  |   1 +
 librdmacm/man/rping.1                      |   1 +
 librdmacm/man/rsocket.7.in                 |   1 +
 librdmacm/man/rstream.1                    |   1 +
 librdmacm/man/ucmatose.1                   |   1 +
 librdmacm/man/udaddy.1                     |   1 +
 providers/mlx4/COPYING                     | 378 -----------------------------
 providers/mlx4/mmio.h                      |   2 +
 srp_daemon/COPYING                         | 376 ----------------------------
 srp_daemon/ibsrpdm.1                       |   1 +
 srp_daemon/srp_daemon.1.in                 |   1 +
 srp_daemon/srpd.in                         |   1 +
 172 files changed, 170 insertions(+), 3015 deletions(-)
 delete mode 100644 ibacm/COPYING
 delete mode 100644 iwpmd/COPYING
 delete mode 100644 libibcm/COPYING
 delete mode 100644 libibumad/COPYING
 delete mode 100644 libibverbs/COPYING
 delete mode 100644 librdmacm/COPYING
 delete mode 100644 providers/mlx4/COPYING
 delete mode 100644 srp_daemon/COPYING

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
