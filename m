From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING on drivers/infiniband/core/verbs.c:1975
 __ib_drain_sq+0x182/0x1c0 [ib_core]
Date: Mon, 27 Mar 2017 11:18:54 +0800
Message-ID: <95e6dc2d-310b-77c6-1c21-966f21af04eb@redhat.com>
References: <1457714996.31424605.1488696068958.JavaMail.zimbra@redhat.com>
 <1490406266.2404.34.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490406266.2404.34.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 03/25/2017 09:44 AM, Doug Ledford wrote:
> On Sun, 2017-03-05 at 01:41 -0500, Yi Zhang wrote:
>> Hi
>>
>> I get bellow WARNING when trying to connect nvmet with nvmecli.
>>
>> Steps I used:
>> On target:
>> 1. Use nvmetcli setup nvmet with below json
>> {
>>    "hosts": [
>>      {
>>        "nqn": "hostnqn"
>>      }
>>    ],
>>    "ports": [
>>      {
>>        "addr": {
>>          "adrfam": "ipv4",
>>          "traddr": "172.31.40.4",
> For testing ocrdma, you need to use the 172.31.45.0 network vlan.  For
> testing other RoCE cards in our lab, you can use either the 43 or 45
> vlans, but you shouldn't use the untagged interface for RoCE tests.
>
Hi Doug
Thanks for your reminder.
I've tried .45 network vlan with latest upstream, still can get below 
WARNING.

[  232.040920] nvme nvme0: new ctrl: NQN 
"nqn.2014-08.org.nvmexpress.discovery", addr 172.31.45.4:4420
[  232.088354] ------------[ cut here ]------------
[  232.111557] WARNING: CPU: 1 PID: 156 at 
drivers/infiniband/core/verbs.c:1969 __ib_drain_sq+0x16a/0x1b0 [ib_core]
[  232.157379] failed to drain send queue: -22
[  232.176836] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod 
ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp 
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm 
ib_cm iw_cm ocrdma ib_core intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul 
ipmi_ssif crc32_pclmul gpio_ich hpilo hpwdt iTCO_wdt iTCO_vendor_support 
ghash_clmulni_intel intel_cstate intel_uncore pcc_cpufreq 
intel_rapl_perf ie31200_edac sg shpchp acpi_power_meter acpi_cpufreq 
pcspkr ipmi_si ipmi_devintf edac_core ipmi_msghandler lpc_ich nfsd 
auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod 
mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt 
fb_sys_fops
[  232.511718]  ttm tg3 ahci libahci drm ptp libata crc32c_intel be2net 
i2c_core serio_raw pps_core dm_mirror dm_region_hash dm_log dm_mod
[  232.566744] CPU: 1 PID: 156 Comm: kworker/1:2 Not tainted 4.11.0-rc4 #1
[  232.600307] Hardware name: HP ProLiant DL320e Gen8 v2, BIOS P80 
09/01/2013
[  232.634737] Workqueue: nvme_rdma_wq nvme_rdma_del_ctrl_work [nvme_rdma]
[  232.666109] Call Trace:
[  232.677051]  dump_stack+0x63/0x87
[  232.691930]  __warn+0xd1/0xf0
[  232.705262]  warn_slowpath_fmt+0x5f/0x80
[  232.723238]  ? ocrdma_mbx_modify_qp+0x23b/0x370 [ocrdma]
[  232.747605]  __ib_drain_sq+0x16a/0x1b0 [ib_core]
[  232.768021]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  232.789971]  ib_drain_sq+0x25/0x30 [ib_core]
[  232.809144]  ib_drain_qp+0x12/0x30 [ib_core]
[  232.828273]  nvme_rdma_stop_and_free_queue+0x27/0x40 [nvme_rdma]
[  232.855757]  nvme_rdma_destroy_admin_queue+0x60/0xb0 [nvme_rdma]
[  232.882317]  nvme_rdma_shutdown_ctrl+0xd4/0xe0 [nvme_rdma]
[  232.908993]  __nvme_rdma_remove_ctrl+0x8c/0x90 [nvme_rdma]
[  232.933602]  nvme_rdma_del_ctrl_work+0x1a/0x20 [nvme_rdma]
[  232.958178]  process_one_work+0x165/0x410
[  232.976871]  worker_thread+0x27f/0x4c0
[  232.993930]  kthread+0x101/0x140
[  233.008415]  ? rescuer_thread+0x3b0/0x3b0
[  233.026434]  ? kthread_park+0x90/0x90
[  233.042937]  ret_from_fork+0x2c/0x40
[  233.059136] ---[ end trace 2da8cf1943c3a50f ]---
[  233.105785] ------------[ cut here ]------------
[  233.128911] WARNING: CPU: 1 PID: 156 at 
drivers/infiniband/core/verbs.c:2003 __ib_drain_rq+0x15f/0x1b0 [ib_core]
[  233.178754] failed to drain recv queue: -22
[  233.197710] Modules linked in: nvme_rdma nvme_fabrics nvme_core 
sch_mqprio 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod 
ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp 
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm 
ib_cm iw_cm ocrdma ib_core intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul 
ipmi_ssif crc32_pclmul gpio_ich hpilo hpwdt iTCO_wdt iTCO_vendor_support 
ghash_clmulni_intel intel_cstate intel_uncore pcc_cpufreq 
intel_rapl_perf ie31200_edac sg shpchp acpi_power_meter acpi_cpufreq 
pcspkr ipmi_si ipmi_devintf edac_core ipmi_msghandler lpc_ich nfsd 
auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod 
mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt 
fb_sys_fops
[  233.526083]  ttm tg3 ahci libahci drm ptp libata crc32c_intel be2net 
i2c_core serio_raw pps_core dm_mirror dm_region_hash dm_log dm_mod
[  233.585357] CPU: 1 PID: 156 Comm: kworker/1:2 Tainted: G W       
4.11.0-rc4 #1
[  233.623342] Hardware name: HP ProLiant DL320e Gen8 v2, BIOS P80 
09/01/2013
[  233.658771] Workqueue: nvme_rdma_wq nvme_rdma_del_ctrl_work [nvme_rdma]
[  233.691614] Call Trace:
[  233.704155]  dump_stack+0x63/0x87
[  233.720829]  __warn+0xd1/0xf0
[  233.736661]  warn_slowpath_fmt+0x5f/0x80
[  233.756792]  ? ocrdma_post_recv+0x127/0x140 [ocrdma]
[  233.781768]  ? ocrdma_mbx_modify_qp+0x23b/0x370 [ocrdma]
[  233.806196]  __ib_drain_rq+0x15f/0x1b0 [ib_core]
[  233.827474]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[  233.849871]  ib_drain_rq+0x25/0x30 [ib_core]
[  233.869660]  ib_drain_qp+0x24/0x30 [ib_core]
[  233.889312]  nvme_rdma_stop_and_free_queue+0x27/0x40 [nvme_rdma]
[  233.918097]  nvme_rdma_destroy_admin_queue+0x60/0xb0 [nvme_rdma]
[  233.945818]  nvme_rdma_shutdown_ctrl+0xd4/0xe0 [nvme_rdma]
[  233.970971]  __nvme_rdma_remove_ctrl+0x8c/0x90 [nvme_rdma]
[  233.996145]  nvme_rdma_del_ctrl_work+0x1a/0x20 [nvme_rdma]
[  234.021216]  process_one_work+0x165/0x410
[  234.040244]  worker_thread+0x27f/0x4c0
[  234.057532]  kthread+0x101/0x140
[  234.072476]  ? rescuer_thread+0x3b0/0x3b0
[  234.090911]  ? kthread_park+0x90/0x90
[  234.107890]  ret_from_fork+0x2c/0x40
[  234.124422] ---[ end trace 2da8cf1943c3a510 ]---
[  234.491570] nvme nvme0: creating 8 I/O queues.
[  235.099065] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.45.4:4420


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
