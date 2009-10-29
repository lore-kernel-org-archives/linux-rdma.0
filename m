From: Gheorghe Ardelean <ardelean-3fy81iOio07EklRYOP+eR4QuADTiUCJX@public.gmane.org>
Subject: OpenSuSE 11.1 and OFED-1.5-rc1
Date: Thu, 29 Oct 2009 12:10:03 +0100 (CET)
Message-ID: <alpine.LNX.2.00.0910291208420.18599@servww6.ww.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


Dear All,

I must say first that I am new to Infiniband so maybe I am just making some 
stupid mistakes. I have installed OFED-1.5-rc1 on OpenSUSE 11.1 (we need 
gcc4.3). The installer expects libstdc++4.2 but it is libstdc++4.3
on the system, so after changing this in the installer everything goes smooth.
All the pakages are build and no errors displayed.

After reboot I see that some modules could not be loaded, namely:

ib_ipath: disagrees about version of symbol ib_umem_release
ib_ipath: Unknown symbol ib_umem_release
ib_ipath: disagrees about version of symbol ib_modify_qp_is_ok
ib_ipath: Unknown symbol ib_modify_qp_is_ok
ib_ipath: disagrees about version of symbol ib_unregister_device
ib_ipath: Unknown symbol ib_unregister_device
ib_ipath: disagrees about version of symbol ib_register_device
ib_ipath: Unknown symbol ib_register_device
ib_ipath: disagrees about version of symbol ib_dispatch_event
ib_ipath: Unknown symbol ib_dispatch_event
ib_ipath: disagrees about version of symbol ib_umem_get
ib_ipath: Unknown symbol ib_umem_get
ib_ipath: disagrees about version of symbol ib_dealloc_device
ib_ipath: Unknown symbol ib_dealloc_device
ib_ipath: disagrees about version of symbol ib_alloc_device
ib_ipath: Unknown symbol ib_alloc_device

Loading iSCSI transport class v2.0-870.
iscsi: registered transport (tcp)
ib_iser: disagrees about version of symbol ib_fmr_pool_unmap
ib_iser: Unknown symbol ib_fmr_pool_unmap
ib_iser: disagrees about version of symbol ib_create_cq
ib_iser: Unknown symbol ib_create_cq
ib_iser: disagrees about version of symbol rdma_resolve_addr
ib_iser: Unknown symbol rdma_resolve_addr
ib_iser: disagrees about version of symbol ib_create_fmr_pool
ib_iser: Unknown symbol ib_create_fmr_pool
ib_iser: disagrees about version of symbol ib_dereg_mr
ib_iser: Unknown symbol ib_dereg_mr
ib_iser: disagrees about version of symbol rdma_disconnect
ib_iser: Unknown symbol rdma_disconnect
ib_iser: disagrees about version of symbol rdma_resolve_route
ib_iser: Unknown symbol rdma_resolve_route
ib_iser: disagrees about version of symbol rdma_create_qp
ib_iser: Unknown symbol rdma_create_qp
ib_iser: disagrees about version of symbol ib_destroy_cq
ib_iser: Unknown symbol ib_destroy_cq
ib_iser: disagrees about version of symbol rdma_create_id
ib_iser: Unknown symbol rdma_create_id
ib_iser: disagrees about version of symbol rdma_destroy_qp
ib_iser: Unknown symbol rdma_destroy_qp
ib_iser: disagrees about version of symbol ib_get_dma_mr
ib_iser: Unknown symbol ib_get_dma_mr
ib_iser: disagrees about version of symbol ib_alloc_pd
ib_iser: Unknown symbol ib_alloc_pd
ib_iser: disagrees about version of symbol rdma_connect
ib_iser: Unknown symbol rdma_connect
ib_iser: disagrees about version of symbol rdma_destroy_id
ib_iser: Unknown symbol rdma_destroy_id
ib_iser: disagrees about version of symbol ib_dealloc_pd
ib_iser: Unknown symbol ib_dealloc_pd
ib_iser: disagrees about version of symbol ib_fmr_pool_map_phys
ib_iser: Unknown symbol ib_fmr_pool_map_phys

The kernel version is:

Linux rx330 2.6.27.29-0.1-default #1 SMP 2009-08-15 17:53:59 +0200 x86_64 
x86_64 x86_64 GNU/Linux

The release is:

rx330:~/OFED-1.5-rc1 # cat /etc/SuSE-release
openSUSE 11.1 (x86_64)
VERSION = 11.1

The IB HCA is an QLogic QLE7240:

rx330:~/OFED-1.5-rc1 # ifconfig ib0
ib0       Link encap:UNSPEC  HWaddr 
80-00-00-02-FE-80-00-00-00-00-00-00-00-00-00-00
           BROADCAST MULTICAST  MTU:65520  Metric:1
           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:256
           RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)

Checking the 
/lib/modules/2.6.27.29-0.1-default/updates/kernel/drivers/infiniband/hw I see 
that no ib_ipath module has been built. The same for ib_iser in 
/lib/modules/2.6.27.29-0.1-default/updates/kernel/drivers/infiniband/ulp
so the "OpenSUSE distribution" modules has been loaded.

Is there a way to make OFED to build them? How can I fix this.

Thank you very much!

Best regards,

Gheorghe Ardelean.

P.S. I subscribed to the list but until now I have no feedback so please
      reply also to my address! :)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
