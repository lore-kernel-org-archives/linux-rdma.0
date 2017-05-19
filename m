From: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Replace netdev_priv with ipoib_priv for
 ipoib_get_link_ksettings
Date: Fri, 19 May 2017 10:42:40 +0800
Message-ID: <612c073f-4828-516e-84c5-f6e7dd3bfaea@oracle.com>
References: <1494504868-17204-1-git-send-email-honli@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1494504868-17204-1-git-send-email-honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/5/11 20:14, Honggang LI wrote:
> From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> ipoib_dev_init accesses the private data for IPoIB net_device with
> ipoib_priv. ipoib_get_link_ksettings should do as ipoib_dev_init.
> Otherwise kernel panic.
>
> [   27.271938] IPv6: ADDRCONF(NETDEV_CHANGE): mlx5_ib0.8006: link becomes ready
> [   28.156790] BUG: unable to handle kernel NULL pointer dereference at 000000000000067c
> [   28.166309] IP: ib_query_port+0x30/0x180 [ib_core]
> [   28.172364] PGD 0
> [   28.172364] P4D 0
> [   28.175307]
> [   28.180595] Oops: 0000 [#1] SMP
> [   28.184802] Modules linked in: bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel ipmi_ssif crypto_simd glue_helper cryptd iTCO_wdt ipmi_si iTCO_vendor_support wmi pcspkr ipmi_devintf dcdbas ipmi_msghandler lpc_ich sg mei_me mei shpchp acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core drm tg3 devlink ahci l
 ibahci ptp libata
> [   28.270227]  crc32c_intel i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
> [   28.279674] CPU: 0 PID: 1766 Comm: libvirtd Not tainted 4.11.0.56868a4.20170510+ #1
> [   28.289242] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
> [   28.298628] task: ffff8b4777311680 task.stack: ffffb9ab0f7ac000
> [   28.306282] RIP: 0010:ib_query_port+0x30/0x180 [ib_core]
> [   28.313249] RSP: 0018:ffffb9ab0f7afbb0 EFLAGS: 00010246
> [   28.320128] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [   28.329169] RDX: ffffb9ab0f7afc00 RSI: 0000000000000000 RDI: 0000000000000000
> [   28.338202] RBP: ffffb9ab0f7afbf0 R08: 0000000000000000 R09: 0000000000000000
> [   28.347246] R10: 0000000000001000 R11: 0000000000000000 R12: 0000000000000000
> [   28.356284] R13: ffffb9ab0f7afc00 R14: ffffb9ab0f7afef0 R15: ffff8b377eae9b80
> [   28.365316] FS:  00007f9aed612700(0000) GS:ffff8b377f800000(0000) knlGS:0000000000000000
> [   28.375431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   28.383724] CR2: 000000000000067c CR3: 000000202aa7c000 CR4: 00000000001406f0
> [   28.393337] Call Trace:
> [   28.397594]  ipoib_get_link_ksettings+0x66/0xe0 [ib_ipoib]
> [   28.405274]  __ethtool_get_link_ksettings+0xa0/0x1c0
> [   28.412353]  speed_show+0x74/0xa0
> [   28.417503]  dev_attr_show+0x20/0x50
> [   28.422922]  ? mutex_lock+0x12/0x40
> [   28.428179]  sysfs_kf_seq_show+0xbf/0x1a0
> [   28.434002]  kernfs_seq_show+0x21/0x30
> [   28.439470]  seq_read+0x116/0x3b0
> [   28.444445]  ? do_filp_open+0xa5/0x100
> [   28.449774]  kernfs_fop_read+0xff/0x180
> [   28.455220]  __vfs_read+0x37/0x150
> [   28.460167]  ? security_file_permission+0x9d/0xc0
> [   28.466560]  vfs_read+0x8c/0x130
> [   28.471318]  SyS_read+0x55/0xc0
> [   28.475950]  do_syscall_64+0x67/0x150
> [   28.481163]  entry_SYSCALL64_slow_path+0x25/0x25
> [   28.487425] RIP: 0033:0x7f9b1bf4a70d
> [   28.492522] RSP: 002b:00007f9aed611a40 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
> [   28.502097] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9b1bf4a70d
> [   28.511178] RDX: 0000000000000401 RSI: 00007f9ae8183650 RDI: 0000000000000017
> [   28.520261] RBP: 0000000000000401 R08: 0000000000000080 R09: 0000000000002001
> [   28.529322] R10: 000000000000006b R11: 0000000000000293 R12: 00007f9ae8183650
> [   28.538368] R13: 0000000000000000 R14: 0000000000000017 R15: 0000000000002001
> [   28.547432] Code: 55 48 89 e5 41 55 49 89 d5 41 54 44 0f b6 e6 53 48 89 fb 48 83 e4 f0 48 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 31 c0 <f6> 87 7c 06 00 00 01 75 2d 45 85 e4 0f 85 ca 00 00 00 b8 ea ff
> [   28.570861] RIP: ib_query_port+0x30/0x180 [ib_core] RSP: ffffb9ab0f7afbb0
> [   28.579601] CR2: 000000000000067c
> [   28.584493] ---[ end trace 3549968a4bf0aa5d ]---
>
> Fixes:  0d7e2d2166f6 ('IB/ipoib: add get_link_ksettings in ethtool')
>
> Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> index 874b243..7871379 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> @@ -178,7 +178,7 @@ static inline int ib_speed_enum_to_int(int speed)
>   static int ipoib_get_link_ksettings(struct net_device *netdev,
>   				    struct ethtool_link_ksettings *cmd)
>   {
> -	struct ipoib_dev_priv *priv = netdev_priv(netdev);
> +	struct ipoib_dev_priv *priv = ipoib_priv(netdev);
 From this patch, ipoib_priv is different netdev_priv.

commit cd565b4b51e5fe258d6ce9ddc167ee51f3044ba5
Author: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Mon Apr 10 11:22:30 2017 +0300

     IB/IPoIB: Support acceleration options callbacks

     IPoIB driver now uses the new set of callback functions.

     If the hardware provider supports the new ipoib_options implementation,
     the driver uses the callbacks in its data path flows, otherwise it 
uses the
     driver default implementation for all data flows in its code.

     The default implementation wasn't change and it is exactly as it 
was before
     introduction of acceleration support.

     Signed-off-by: Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
     Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
     Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Zhu Yanjun
>   	struct ib_port_attr attr;
>   	int ret, speed, width;
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
