From: Jonathan Ferland <jonathan.ferland-IgX6TQnKqXwsA/PxXw9srA@public.gmane.org>
Subject: ofed on xen
Date: Mon, 22 Feb 2010 12:08:28 -0500
Message-ID: <4B82BA0C.70906@rqchp.qc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi All,

I would like to setup a node under xen and use infiniband in it. Here is 
the thing I would like to do :

node :
    07:00.0 InfiniBand: Mellanox Technologies MT26418 [ConnectX IB DDR, 
PCIe 2.0 5GT/s] (rev a0)

    dom0: infiniband acess
       -> domu1: infiniband acess
       -> domu2: infiniband acess
      
 so I would like to share the infiniband connection between a single card.

Is it possible? if yes, how? if not, is there plan to support something 
like that, or what kind of setup virtualisation people are using with 
infiniband?

I installed xen 3.4.2 (kernel  2.6.18.8) under centos 5.3 and ofed 
OFED-1.4-mlnx8. Then the infiniband card worked for dom0, but I found no 
way to make it working on any domu...

I then download OFED-1.5.1-rc1, and compile fine. but when i tried to 
load the modules in dom0, it crashed with the following message :
...
mlx4_ib: Mellanox ConnectX InfiniBand driver v1.0 (April 4, 2008)
PM: Adding info for No Bus:mlx4_0
mlx4_en: Mellanox ConnectX HCA Ethernet driver v1.5.0 (Dec 2009)
ADDRCONF(NETDEV_UP): ib0: link is not ready
ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ> [<ffffffff8025d01e>] softlockup_tick+0xd6/0xeb
 [<ffffffff8020e2b5>] timer_interrupt+0x471/0x4cf
 [<ffffffff8814c70d>] :e1000:e1000_swfw_sync_release+0x2c/0x54
 [<ffffffff8025d318>] handle_IRQ_event+0x4e/0x95
 [<ffffffff8025d418>] __do_IRQ+0xb9/0x11e
 [<ffffffff8020be09>] do_IRQ+0x44/0x50
 [<ffffffff80236b8e>] tasklet_action+0xa8/0x12e
 [<ffffffff8039c289>] evtchn_do_upcall+0x193/0x284
 [<ffffffff80236a59>] __do_softirq+0x8a/0x117
 [<ffffffff80209dee>] do_hypervisor_callback+0x1e/0x2c
 <EOI> [<ffffffff8020522a>] hypercall_page+0x22a/0x1000
 [<ffffffff8020522a>] hypercall_page+0x22a/0x1000
 [<ffffffff803ea398>] pci_conf1_read+0x0/0xca
 [<ffffffff8039b5ca>] force_evtchn_callback+0xa/0xb
 [<ffffffff8032bfb4>] pci_bus_read_config_word+0x6f/0x7e
 [<ffffffff88375012>] :mlx4_en:vpd_read_dword+0x4e/0x7a
 [<ffffffff8837509c>] :mlx4_en:mlx4_en_cache_vpd+0x5e/0x144
 [<ffffffff88370557>] :mlx4_en:mlx4_en_add+0x403/0x53c
 [<ffffffff8810c4ba>] :mlx4_core:mlx4_add_device+0x2e/0xa1
 [<ffffffff8810c6a1>] :mlx4_core:mlx4_register_interface+0x75/0x9a
 [<ffffffff8024fa40>] sys_init_module+0x1872/0x1a42
 [<ffffffff80209812>] tracesys+0xab/0xb5


thanks,

Jonathan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
