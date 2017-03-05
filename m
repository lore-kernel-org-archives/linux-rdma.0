From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: WARNING on drivers/infiniband/core/verbs.c:1975
 __ib_drain_sq+0x182/0x1c0 [ib_core]
Date: Sun, 5 Mar 2017 01:41:08 -0500 (EST)
Message-ID: <1457714996.31424605.1488696068958.JavaMail.zimbra@redhat.com>
References: <530228679.31424535.1488695516036.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530228679.31424535.1488695516036.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi

I get bellow WARNING when trying to connect nvmet with nvmecli.

Steps I used:
On target:
1. Use nvmetcli setup nvmet with below json 
{
  "hosts": [
    {
      "nqn": "hostnqn"
    }
  ], 
  "ports": [
    {
      "addr": {
        "adrfam": "ipv4", 
        "traddr": "172.31.40.4", 
        "treq": "not specified", 
        "trsvcid": "1023", 
        "trtype": "rdma"
      }, 
      "portid": 2, 
      "referrals": [], 
      "subsystems": [
        "testnqn"
      ]
    }
  ], 
  "subsystems": [
    {
      "allowed_hosts": [], 
      "attr": {
        "allow_any_host": "1"
      }, 
      "namespaces": [
        {
          "device": {
            "nguid": "ef90689c-6c46-d44c-89c1-4067801309a8", 
            "path": "/dev/nullb0"
          }, 
          "enable": 1, 
          "nsid": 1
        }
      ], 
      "nqn": "testnqn"
    }
  ]
}
2. Initiator side:
#nvme connect-all -t rdma -a 172.31.40.4 -s 1023

3. check the kernel log on both target/initiator side.

kernel log:
[  242.494533] ocrdma0:Using VLAN with PFC is recommended
[  242.520244] ocrdma0:Using VLAN 0 for this connection
[  242.652599] ocrdma0:Using VLAN with PFC is recommended
[  242.676365] ocrdma0:Using VLAN 0 for this connection
[  242.700476] ocrdma0:Using VLAN with PFC is recommended
[  242.723497] ocrdma0:Using VLAN 0 for this connection
[  242.812331] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.40.4:1023
[  242.854149] ocrdma0:Using VLAN with PFC is recommended
[  242.854149] ocrdma0:Using VLAN 0 for this connection
[  242.854662] ------------[ cut here ]------------
[  242.854671] WARNING: CPU: 2 PID: 158 at drivers/infiniband/core/verbs.c:1975 __ib_drain_sq+0x182/0x1c0 [ib_core]
[  242.854671] failed to drain send queue: -22
[  242.854671] Modules linked in: nvme_rdma nvme_fabrics nvme_core sch_mqprio 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ocrdma ib_core ipmi_ssif intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore ipmi_si ipmi_devintf hpilo hpwdt intel_rapl_perf gpio_ich iTCO_wdt iTCO_vendor_support pcspkr ie31200_edac shpchp sg edac_core acpi_power_meter lpc_ich ipmi_msghandler pcc_cpufreq acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod tg3 ptp mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfill
 rect sysimgblt
[  242.854694]  fb_sys_fops ttm drm ahci libahci libata crc32c_intel be2net fjes serio_raw i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
[  242.854699] CPU: 2 PID: 158 Comm: kworker/2:2 Not tainted 4.10.0 #2
[  242.854699] Hardware name: HP ProLiant DL320e Gen8 v2, BIOS P80 09/01/2013
[  242.854702] Workqueue: nvme_rdma_wq nvme_rdma_del_ctrl_work [nvme_rdma]
[  242.854702] Call Trace:
[  242.854706]  dump_stack+0x63/0x87
[  242.854711]  __warn+0xd1/0xf0
[  242.854712]  warn_slowpath_fmt+0x5f/0x80
[  242.854715]  ? ocrdma_mbx_modify_qp+0x23b/0x370 [ocrdma]
[  242.854718]  __ib_drain_sq+0x182/0x1c0 [ib_core]
[  242.854721]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  242.854724]  ib_drain_sq+0x25/0x30 [ib_core]
[  242.854727]  ib_drain_qp+0x12/0x30 [ib_core]
[  242.854728]  nvme_rdma_stop_and_free_queue+0x27/0x40 [nvme_rdma]
[  242.854729]  nvme_rdma_destroy_admin_queue+0x4d/0xc0 [nvme_rdma]
[  242.854730]  nvme_rdma_shutdown_ctrl+0xd4/0xe0 [nvme_rdma]
[  242.854731]  __nvme_rdma_remove_ctrl+0x84/0x90 [nvme_rdma]
[  242.854732]  nvme_rdma_del_ctrl_work+0x1a/0x20 [nvme_rdma]
[  242.854733]  process_one_work+0x165/0x410
[  242.854734]  worker_thread+0x27f/0x4c0
[  242.854735]  kthread+0x101/0x140
[  242.854736]  ? rescuer_thread+0x3b0/0x3b0
[  242.854737]  ? kthread_park+0x90/0x90
[  242.854751]  ret_from_fork+0x2c/0x40
[  242.854752] ---[ end trace 87cf24af407fe063 ]---
[  242.855216] ------------[ cut here ]------------
[  242.855220] WARNING: CPU: 2 PID: 158 at drivers/infiniband/core/verbs.c:2010 __ib_drain_rq+0x177/0x1c0 [ib_core]
[  242.855220] failed to drain recv queue: -22
[  242.855220] Modules linked in: nvme_rdma nvme_fabrics nvme_core sch_mqprio 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm ocrdma ib_core ipmi_ssif intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore ipmi_si ipmi_devintf hpilo hpwdt intel_rapl_perf gpio_ich iTCO_wdt iTCO_vendor_support pcspkr ie31200_edac shpchp sg edac_core acpi_power_meter lpc_ich ipmi_msghandler pcc_cpufreq acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod tg3 ptp mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfill
 rect sysimgblt
[  242.855232]  fb_sys_fops ttm drm ahci libahci libata crc32c_intel be2net fjes serio_raw i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
[  242.855235] CPU: 2 PID: 158 Comm: kworker/2:2 Tainted: G        W       4.10.0 #2
[  242.855235] Hardware name: HP ProLiant DL320e Gen8 v2, BIOS P80 09/01/2013
[  242.855237] Workqueue: nvme_rdma_wq nvme_rdma_del_ctrl_work [nvme_rdma]
[  242.855237] Call Trace:
[  242.855238]  dump_stack+0x63/0x87
[  242.855239]  __warn+0xd1/0xf0
[  242.855240]  warn_slowpath_fmt+0x5f/0x80
[  242.855242]  ? ocrdma_post_recv+0x127/0x140 [ocrdma]
[  242.855243]  ? ocrdma_mbx_modify_qp+0x23b/0x370 [ocrdma]
[  242.855246]  __ib_drain_rq+0x177/0x1c0 [ib_core]
[  242.855268]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  242.855271]  ib_drain_rq+0x25/0x30 [ib_core]
[  242.855273]  ib_drain_qp+0x24/0x30 [ib_core]
[  242.855274]  nvme_rdma_stop_and_free_queue+0x27/0x40 [nvme_rdma]
[  242.855275]  nvme_rdma_destroy_admin_queue+0x4d/0xc0 [nvme_rdma]
[  242.855276]  nvme_rdma_shutdown_ctrl+0xd4/0xe0 [nvme_rdma]
[  242.855277]  __nvme_rdma_remove_ctrl+0x84/0x90 [nvme_rdma]
[  242.855278]  nvme_rdma_del_ctrl_work+0x1a/0x20 [nvme_rdma]
[  242.855279]  process_one_work+0x165/0x410
[  242.855280]  worker_thread+0x27f/0x4c0
[  242.855282]  kthread+0x101/0x140
[  242.855283]  ? rescuer_thread+0x3b0/0x3b0
[  242.855283]  ? kthread_park+0x90/0x90
[  242.855284]  ret_from_fork+0x2c/0x40
[  242.855285] ---[ end trace 87cf24af407fe064 ]---
[  244.970302] ocrdma0:Using VLAN with PFC is recommended
[  244.970302] ocrdma0:Using VLAN 0 for this connection
[  245.074424] ocrdma0:Using VLAN with PFC is recommended
[  245.098195] ocrdma0:Using VLAN 0 for this connection
[  245.122976] ocrdma0:Using VLAN with PFC is recommended
[  245.147078] ocrdma0:Using VLAN 0 for this connection
[  245.183682] nvme nvme0: creating 8 I/O queues.
[  245.242477] ocrdma0:Using VLAN with PFC is recommended
[  245.266737] ocrdma0:Using VLAN 0 for this connection
[  245.388146] ocrdma0:Using VLAN with PFC is recommended
[  245.411813] ocrdma0:Using VLAN 0 for this connection
[  245.436101] ocrdma0:Using VLAN with PFC is recommended
[  245.459634] ocrdma0:Using VLAN 0 for this connection
[  245.485689] ocrdma0:Using VLAN with PFC is recommended
[  245.512216] ocrdma0:Using VLAN 0 for this connection
[  245.662331] ocrdma0:Using VLAN with PFC is recommended
[  245.687422] ocrdma0:Using VLAN 0 for this connection
[  245.713057] ocrdma0:Using VLAN with PFC is recommended
[  245.738019] ocrdma0:Using VLAN 0 for this connection
[  245.766147] ocrdma0:Using VLAN with PFC is recommended
[  245.791930] ocrdma0:Using VLAN 0 for this connection
[  245.824506] ocrdma0:Using VLAN with PFC is recommended
[  245.849968] ocrdma0:Using VLAN 0 for this connection
[  245.876203] ocrdma0:Using VLAN with PFC is recommended
[  245.900670] ocrdma0:Using VLAN 0 for this connection
[  245.926549] ocrdma0:Using VLAN with PFC is recommended
[  245.949892] ocrdma0:Using VLAN 0 for this connection
[  246.102218] ocrdma0:Using VLAN with PFC is recommended
[  246.125597] ocrdma0:Using VLAN 0 for this connection
[  246.150668] ocrdma0:Using VLAN with PFC is recommended
[  246.174000] ocrdma0:Using VLAN 0 for this connection
[  246.199945] ocrdma0:Using VLAN with PFC is recommended
[  246.223247] ocrdma0:Using VLAN 0 for this connection
[  246.253534] ocrdma0:Using VLAN with PFC is recommended
[  246.278590] ocrdma0:Using VLAN 0 for this connection
[  246.303311] ocrdma0:Using VLAN with PFC is recommended
[  246.329326] ocrdma0:Using VLAN 0 for this connection
[  246.358014] ocrdma0:Using VLAN with PFC is recommended
[  246.382120] ocrdma0:Using VLAN 0 for this connection
[  246.537506] ocrdma0:Using VLAN with PFC is recommended
[  246.560855] ocrdma0:Using VLAN 0 for this connection
[  246.585018] ocrdma0:Using VLAN with PFC is recommended
[  246.608393] ocrdma0:Using VLAN 0 for this connection
[  246.634275] ocrdma0:Using VLAN with PFC is recommended
[  246.658760] ocrdma0:Using VLAN 0 for this connection
[  246.779071] ocrdma0:Using VLAN with PFC is recommended
[  246.803813] ocrdma0:Using VLAN 0 for this connection
[  246.829115] ocrdma0:Using VLAN with PFC is recommended
[  246.853383] ocrdma0:Using VLAN 0 for this connection
[  246.880570] ocrdma0:Using VLAN with PFC is recommended
[  246.905561] ocrdma0:Using VLAN 0 for this connection
[  247.033429] ocrdma0:Using VLAN with PFC is recommended
[  247.060779] ocrdma0:Using VLAN 0 for this connection
[  247.087520] ocrdma0:Using VLAN with PFC is recommended
[  247.111723] ocrdma0:Using VLAN 0 for this connection
[  247.701156] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.40.4:1023


Best Regards,
  Yi Zhang


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
