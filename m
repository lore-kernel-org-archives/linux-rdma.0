From: bhavinkumar thumar <bhawinkumar.thumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: How to build SDP module
Date: Mon, 25 Apr 2011 13:42:45 +0530
Message-ID: <BANLkTikDGaucXzqN8+uotCbqLE+UFW_Djw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

OFED 1.5.2 has already been installed in my system and now I want to
build and install the sdp module of OFED after making some change in
it.

I tried 'configure' script in /usr/src/ofa_kernel-1.5.2/ and then gave
'make' and 'make install' with required parameters. Then when I am
trying to load the ib_sdp module it gives me following error:

FATAL: Error inserting ib_sdp
(/lib/modules/2.6.18-194.el5/updates/kernel/drivers/infiniband/ulp/sdp/ib_sdp.ko):
Unknown symbol in module, or unknown parameter (see dmesg)

I checked dmesg, it shows:

ib_sdp: disagrees about version of symbol ib_unregister_client
ib_sdp: Unknown symbol ib_unregister_client
ib_sdp: disagrees about version of symbol ib_fmr_pool_unmap
ib_sdp: Unknown symbol ib_fmr_pool_unmap
ib_sdp: disagrees about version of symbol ib_create_cq
ib_sdp: Unknown symbol ib_create_cq
ib_sdp: disagrees about version of symbol rdma_resolve_addr
ib_sdp: Unknown symbol rdma_resolve_addr
ib_sdp: disagrees about version of symbol ib_create_fmr_pool
ib_sdp: Unknown symbol ib_create_fmr_pool
ib_sdp: disagrees about version of symbol ib_dereg_mr
ib_sdp: Unknown symbol ib_dereg_mr
ib_sdp: disagrees about version of symbol rdma_reject
ib_sdp: Unknown symbol rdma_reject
ib_sdp: disagrees about version of symbol rdma_disconnect
ib_sdp: Unknown symbol rdma_disconnect
ib_sdp: disagrees about version of symbol rdma_resolve_route
ib_sdp: Unknown symbol rdma_resolve_route
ib_sdp: disagrees about version of symbol rdma_bind_addr
ib_sdp: Unknown symbol rdma_bind_addr
ib_sdp: disagrees about version of symbol ib_register_client
ib_sdp: Unknown symbol ib_register_client
ib_sdp: disagrees about version of symbol rdma_create_qp
ib_sdp: Unknown symbol rdma_create_qp
ib_sdp: disagrees about version of symbol ib_destroy_cq
ib_sdp: Unknown symbol ib_destroy_cq
ib_sdp: disagrees about version of symbol rdma_create_id
ib_sdp: Unknown symbol rdma_create_id
ib_sdp: disagrees about version of symbol ib_set_client_data
ib_sdp: Unknown symbol ib_set_client_data
ib_sdp: disagrees about version of symbol rdma_notify
ib_sdp: Unknown symbol rdma_notify
ib_sdp: disagrees about version of symbol ib_get_client_data
ib_sdp: Unknown symbol ib_get_client_data
ib_sdp: disagrees about version of symbol rdma_listen
ib_sdp: Unknown symbol rdma_listen
ib_sdp: disagrees about version of symbol ib_query_device
ib_sdp: Unknown symbol ib_query_device
ib_sdp: disagrees about version of symbol ib_get_dma_mr
ib_sdp: Unknown symbol ib_get_dma_mr
ib_sdp: disagrees about version of symbol ib_alloc_pd
ib_sdp: Unknown symbol ib_alloc_pd
ib_sdp: disagrees about version of symbol rdma_connect
ib_sdp: Unknown symbol rdma_connect
ib_sdp: disagrees about version of symbol ib_modify_cq
ib_sdp: Unknown symbol ib_modify_cq
ib_sdp: disagrees about version of symbol rdma_destroy_id
ib_sdp: Unknown symbol rdma_destroy_id
ib_sdp: disagrees about version of symbol rdma_accept
ib_sdp: Unknown symbol rdma_accept
ib_sdp: disagrees about version of symbol ib_destroy_qp
ib_sdp: Unknown symbol ib_destroy_qp
ib_sdp: disagrees about version of symbol rdma_port_get_link_layer
ib_sdp: Unknown symbol rdma_port_get_link_layer
ib_sdp: disagrees about version of symbol ib_dealloc_pd
ib_sdp: Unknown symbol ib_dealloc_pd
ib_sdp: disagrees about version of symbol ib_unregister_client
ib_sdp: Unknown symbol ib_unregister_client
ib_sdp: disagrees about version of symbol ib_fmr_pool_unmap
ib_sdp: Unknown symbol ib_fmr_pool_unmap
ib_sdp: disagrees about version of symbol ib_create_cq
ib_sdp: Unknown symbol ib_create_cq
ib_sdp: disagrees about version of symbol rdma_resolve_addr
ib_sdp: Unknown symbol rdma_resolve_addr
ib_sdp: disagrees about version of symbol ib_create_fmr_pool
ib_sdp: Unknown symbol ib_create_fmr_pool
ib_sdp: disagrees about version of symbol ib_dereg_mr
ib_sdp: Unknown symbol ib_dereg_mr
ib_sdp: disagrees about version of symbol rdma_reject
ib_sdp: Unknown symbol rdma_reject
ib_sdp: disagrees about version of symbol rdma_disconnect
ib_sdp: Unknown symbol rdma_disconnect
ib_sdp: disagrees about version of symbol rdma_resolve_route
ib_sdp: Unknown symbol rdma_resolve_route
ib_sdp: disagrees about version of symbol rdma_bind_addr
ib_sdp: Unknown symbol rdma_bind_addr
ib_sdp: disagrees about version of symbol ib_register_client
ib_sdp: Unknown symbol ib_register_client
ib_sdp: disagrees about version of symbol rdma_create_qp
ib_sdp: Unknown symbol rdma_create_qp
ib_sdp: disagrees about version of symbol ib_destroy_cq
ib_sdp: Unknown symbol ib_destroy_cq
ib_sdp: disagrees about version of symbol rdma_create_id
ib_sdp: Unknown symbol rdma_create_id
ib_sdp: disagrees about version of symbol ib_set_client_data
ib_sdp: Unknown symbol ib_set_client_data
ib_sdp: disagrees about version of symbol rdma_notify
ib_sdp: Unknown symbol rdma_notify
ib_sdp: disagrees about version of symbol ib_get_client_data
ib_sdp: Unknown symbol ib_get_client_data
ib_sdp: disagrees about version of symbol rdma_listen
ib_sdp: Unknown symbol rdma_listen
ib_sdp: disagrees about version of symbol ib_query_device
ib_sdp: Unknown symbol ib_query_device
ib_sdp: disagrees about version of symbol ib_get_dma_mr
ib_sdp: Unknown symbol ib_get_dma_mr
ib_sdp: disagrees about version of symbol ib_alloc_pd
ib_sdp: Unknown symbol ib_alloc_pd
ib_sdp: disagrees about version of symbol rdma_connect
ib_sdp: Unknown symbol rdma_connect
.................


Can somebody tell me what's wrong?

Please Help.


Thanks,
Bhavin
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
