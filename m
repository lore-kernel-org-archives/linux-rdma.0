From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: SRPt oops with 4.5-rc3-ish
Date: Mon, 11 Apr 2016 16:08:33 -0400
Message-ID: <570C0441.9040905@redhat.com>
References: <56C0A6C3.3010903@redhat.com>
 <1456630639.19657.47.camel@haakon3.risingtidesystems.com>
 <1456647963.19657.135.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="oAbmCl7thUAkjptn7lq8AfCLpdfcOE28f"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456647963.19657.135.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--oAbmCl7thUAkjptn7lq8AfCLpdfcOE28f
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/28/2016 03:26 AM, Nicholas A. Bellinger wrote:

> AFAIK, the oldest last working srpt commit with se_node_acl + se_sessio=
n
> active I/O shutdown is:
>=20
> ib_srpt: Call target_sess_cmd_list_set_waiting during shutdown_session
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/=
drivers/infiniband/ulp/srpt?id=3D1d19f7800d
>=20
> Note this is ~40 upstream commits between then and now in v4.5-rc5.
>=20
> Please confirm when you started triggering this regression during targe=
t
> service restart.

I don't have a clear answer for that, although it just happened again on
a v4.5-rc4 kernel.  It's pretty annoying because the trigger is (as
often as anything else) and yum upgrade process.  And it hangs mid way
through the process.  I don't want to know how corrupted my RPM db or my
filesystem is :-(

Anyway, I have a clearer oops this time that I'll attach here, but this
will be my last one from this kernel as I'm upgrading to the most recent
v4.6-rc kernel.  If the oops still happens on v4.6-rc, I'll update here.

Here's the oops series, machine was useless after this (disk access was
blocked for all processes):

[4752021.950589] ------------[ cut here ]------------
[4752021.955992] WARNING: CPU: 5 PID: 10364 at
drivers/infiniband/ulp/srpt/ib_srpt.c:3251
srpt_close_session+0x12f/0x140 [ib_srpt]()
[4752021.969091] Modules linked in: hfi1(C) 8021q garp mrp
target_core_user uio target_core_pscsi target_core_file
target_core_iblock ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ip_set
nfnetlink ebtable_nat ebtable_filter ebtable_broute bridge stp llc
ebtables ip6table_mangle ip6table_raw nf_defrag_ipv6 ip6table_security
ip6table_filter ip6_tables iptable_mangle iptable_raw nf_defrag_ipv4
nf_conntrack(-) iptable_security ib_isert iscsi_target_mod ib_iser
libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm
ib_cm iw_cm ib_sa ib_mad intel_rapl x86_pkg_temp_thermal coretemp
kvm_intel kvm irqbypass ipmi_ssif crct10dif_pclmul ipmi_devintf iTCO_wdt
crc32_pclmul ghash_clmulni_intel iTCO_vendor_support dcdbas ipmi_si
sb_edac mei_me edac_core
[4752022.049588]  ioatdma mei ipmi_msghandler lpc_ich dca shpchp wmi
acpi_power_meter tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c mlx5_ib raid1 raid0 ib_core ib_addr mgag200 i2c_algo_bit
drm_kms_helper ttm crc32c_intel mlx5_core tg3 drm ptp megaraid_sas
pps_core fjes [last unloaded: nf_conntrack_ipv6]
[4752022.080463] CPU: 5 PID: 10364 Comm: targetctl Tainted: G         CI
    4.5.0-0.rc4.git0.1.fc24.x86_64 #1
[4752022.091366] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
1.0.4 08/28/2014
[4752022.100131]  0000000000000286 00000000189b0c8a ffff880de32ffcc0
ffffffff813d3e0f
[4752022.108624]  0000000000000000 ffffffffa04872f0 ffff880de32ffcf8
ffffffff810a4fe2
[4752022.117126]  ffff881fd427a800 ffff88100fcb7000 0000000000000001
ffff88100fcb70e8
[4752022.125629] Call Trace:
[4752022.128565]  [<ffffffff813d3e0f>] dump_stack+0x63/0x84
[4752022.134513]  [<ffffffff810a4fe2>] warn_slowpath_common+0x82/0xc0
[4752022.141431]  [<ffffffff810a512a>] warn_slowpath_null+0x1a/0x20
[4752022.148155]  [<ffffffffa04830bf>] srpt_close_session+0x12f/0x140
[ib_srpt]
[4752022.156055]  [<ffffffffa0639de4>] target_release_session+0x24/0x30
[target_core_mod]
[4752022.164925]  [<ffffffffa063bb3d>] target_put_session+0x1d/0x20
[target_core_mod]
[4752022.173403]  [<ffffffffa06395eb>]
core_tpg_del_initiator_node_acl+0x16b/0x240 [target_core_mod]
[4752022.183343]  [<ffffffffa062d23f>]
target_fabric_nacl_base_release+0x3f/0x50 [target_core_mod]
[4752022.193082]  [<ffffffff812cc133>] config_item_release+0x63/0xd0
[4752022.199902]  [<ffffffff812cc1c2>] config_item_put+0x22/0x30
[4752022.206326]  [<ffffffff812ca676>] configfs_rmdir+0x1d6/0x2e0
[4752022.212857]  [<ffffffff8124ea0c>] vfs_rmdir+0xbc/0x130
[4752022.218803]  [<ffffffff81253c6a>] do_rmdir+0x19a/0x220
[4752022.224750]  [<ffffffff81254a16>] SyS_rmdir+0x16/0x20
[4752022.230598]  [<ffffffff817cd6ae>] entry_SYSCALL_64_fastpath+0x12/0x6=
d
[4752022.238009] ---[ end trace befc2f337e9f56d7 ]---
[4752027.739051] ib_srpt Received IB DREQ ERROR event.
[4752029.794988] ib_srpt Received IB TimeWait exit for cm_id
ffff881ff5d55800.
[4752029.807121] BUG: unable to handle kernel paging request at
0000000000017930
[4752029.815120] IP: [<ffffffff810ee9a5>]
queued_spin_lock_slowpath+0x105/0x190
[4752029.823015] PGD 0
[4752029.825466] Oops: 0002 [#1] SMP
[4752029.829286] Modules linked in: hfi1(C) 8021q garp mrp
target_core_user uio target_core_pscsi target_core_file
target_core_iblock ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ip_set
nfnetlink ebtable_nat ebtable_filter ebtable_broute bridge stp llc
ebtables ip6table_mangle ip6table_raw nf_defrag_ipv6 ip6table_security
ip6table_filter ip6_tables iptable_mangle iptable_raw nf_defrag_ipv4
nf_conntrack(-) iptable_security ib_isert iscsi_target_mod ib_iser
libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm
ib_cm iw_cm ib_sa ib_mad intel_rapl x86_pkg_temp_thermal coretemp
kvm_intel kvm irqbypass ipmi_ssif crct10dif_pclmul ipmi_devintf iTCO_wdt
crc32_pclmul ghash_clmulni_intel iTCO_vendor_support dcdbas ipmi_si
sb_edac mei_me edac_core
[4752029.913124]  ioatdma mei ipmi_msghandler lpc_ich dca shpchp wmi
acpi_power_meter tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c mlx5_ib raid1 raid0 ib_core ib_addr mgag200 i2c_algo_bit
drm_kms_helper ttm crc32c_intel mlx5_core tg3 drm ptp megaraid_sas
pps_core fjes [last unloaded: nf_conntrack_ipv6]
[4752029.946121] CPU: 7 PID: 288828 Comm: kworker/7:0 Tainted: G
WCI     4.5.0-0.rc4.git0.1.fc24.x86_64 #1
[4752029.958057] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
1.0.4 08/28/2014
[4752029.967563] Workqueue: events srpt_release_channel_work [ib_srpt]
[4752029.975315] task: ffff8820352e5b80 ti: ffff881f5da10000 task.ti:
ffff881f5da10000
[4752029.984607] RIP: 0010:[<ffffffff810ee9a5>]  [<ffffffff810ee9a5>]
queued_spin_lock_slowpath+0x105/0x190
[4752029.995941] RSP: 0018:ffff881f5da13da8  EFLAGS: 00010006
[4752030.002790] RAX: 0000000000017930 RBX: 0000000000000286 RCX:
ffff88203d2d7900
[4752030.011668] RDX: 00000000000039eb RSI: 00000000e7b31ae8 RDI:
ffff880de32ffd20
[4752030.020528] RBP: ffff881f5da13da8 R08: 0000000000200000 R09:
0000000000000000
[4752030.029374] R10: 0000000000000000 R11: 000000000001a700 R12:
ffff880de32ffd18
[4752030.038206] R13: ffff881fd2c6b780 R14: ffff881fd427a800 R15:
ffff881fd427a8d0
[4752030.047025] FS:  0000000000000000(0000) GS:ffff88203d2c0000(0000)
knlGS:0000000000000000
[4752030.056913] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[4752030.064174] CR2: 0000000000017930 CR3: 0000000de33db000 CR4:
00000000001406e0
[4752030.072995] Stack:
[4752030.076087]  ffff881f5da13dc0 ffffffff817cd4c7 ffff880de32ffd20
ffff881f5da13de8
[4752030.085236]  ffffffff810e7cfd ffff881fd427a8d0 ffff88100fcb7000
ffff881fd2c6b780
[4752030.094382]  ffff881f5da13e18 ffffffffa0485931 ffff881fc81c60c0
ffff88203d2d65c0
[4752030.103531] Call Trace:
[4752030.107120]  [<ffffffff817cd4c7>] _raw_spin_lock_irqsave+0x37/0x40
[4752030.114886]  [<ffffffff810e7cfd>] complete+0x1d/0x50
[4752030.121291]  [<ffffffffa0485931>]
srpt_release_channel_work+0xe1/0x140 [ib_srpt]
[4752030.130416]  [<ffffffff810bd6fd>] process_one_work+0x1ad/0x400
[4752030.137791]  [<ffffffff810bd99e>] worker_thread+0x4e/0x480
[4752030.144772]  [<ffffffff810bd950>] ? process_one_work+0x400/0x400
[4752030.152327]  [<ffffffff810bd950>] ? process_one_work+0x400/0x400
[4752030.159879]  [<ffffffff810c38e8>] kthread+0xd8/0xf0
[4752030.166170]  [<ffffffff810c3810>] ? kthread_worker_fn+0x180/0x180
[4752030.173823]  [<ffffffff817cd9ff>] ret_from_fork+0x3f/0x70
[4752030.180702]  [<ffffffff810c3810>] ? kthread_worker_fn+0x180/0x180
[4752030.188352] Code: 02 89 c2 45 31 c9 c1 e2 10 85 d2 74 41 c1 ea 12
83 e0 03 83 ea 01 48 c1 e0 04 48 63 d2 48 05 00 79 01 00 48 03 04 d5 00
d5 d3 81 <48> 89 08 8b 41 08 85 c0 75 09 f3 90 8b 41 08 85 c0 74 f7 4c 8b=

[4752030.211521] RIP  [<ffffffff810ee9a5>]
queued_spin_lock_slowpath+0x105/0x190
[4752030.220180]  RSP <ffff881f5da13da8>
[4752030.224954] CR2: 0000000000017930
[4752030.231895] ---[ end trace befc2f337e9f56d8 ]---
[4752030.312493] BUG: unable to handle kernel paging request at
ffffffffffffffd8
[4752030.322906] IP: [<ffffffff810c3f80>] kthread_data+0x10/0x20
[4752030.331299] PGD 1c0d067 PUD 1c0f067 PMD 0
[4752030.337938] Oops: 0000 [#2] SMP
[4752030.343539] Modules linked in: hfi1(C) 8021q garp mrp
target_core_user uio target_core_pscsi target_core_file
target_core_iblock ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ip_set
nfnetlink ebtable_nat ebtable_filter ebtable_broute bridge stp llc
ebtables ip6table_mangle ip6table_raw nf_defrag_ipv6 ip6table_security
ip6table_filter ip6_tables iptable_mangle iptable_raw nf_defrag_ipv4
nf_conntrack(-) iptable_security ib_isert iscsi_target_mod ib_iser
libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm
ib_cm iw_cm ib_sa ib_mad intel_rapl x86_pkg_temp_thermal coretemp
kvm_intel kvm irqbypass ipmi_ssif crct10dif_pclmul ipmi_devintf iTCO_wdt
crc32_pclmul ghash_clmulni_intel iTCO_vendor_support dcdbas ipmi_si
sb_edac mei_me edac_core
[4752030.432786]  ioatdma mei ipmi_msghandler lpc_ich dca shpchp wmi
acpi_power_meter tpm_tis tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc
xfs libcrc32c mlx5_ib raid1 raid0 ib_core ib_addr mgag200 i2c_algo_bit
drm_kms_helper ttm crc32c_intel mlx5_core tg3 drm ptp megaraid_sas
pps_core fjes [last unloaded: nf_conntrack_ipv6]
[4752030.467298] CPU: 7 PID: 288828 Comm: kworker/7:0 Tainted: G      D
WCI     4.5.0-0.rc4.git0.1.fc24.x86_64 #1
[4752030.479665] Hardware name: Dell Inc. PowerEdge R730xd/0599V5, BIOS
1.0.4 08/28/2014
[4752030.489575] task: ffff8820352e5b80 ti: ffff881f5da10000 task.ti:
ffff881f5da10000
[4752030.499244] RIP: 0010:[<ffffffff810c3f80>]  [<ffffffff810c3f80>]
kthread_data+0x10/0x20
[4752030.509511] RSP: 0018:ffff881f5da13a80  EFLAGS: 00010002
[4752030.516747] RAX: 0000000000000000 RBX: 0000000000000007 RCX:
0000000000000007
[4752030.526034] RDX: ffff88103d410000 RSI: 0000000000000007 RDI:
ffff8820352e5b80
[4752030.535318] RBP: ffff881f5da13a80 R08: ffff8820352e5c28 R09:
ffff8820352e5c00
[4752030.544599] R10: 0000000000000000 R11: 000000000000002f R12:
0000000000016dc0
[4752030.553884] R13: ffff8820352e61d8 R14: ffff8820352e5b80 R15:
ffff88203d2d6dc0
[4752030.563161] FS:  0000000000000000(0000) GS:ffff88203d2c0000(0000)
knlGS:0000000000000000
[4752030.573516] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[4752030.581247] CR2: 0000000000000028 CR3: 0000000de33db000 CR4:
00000000001406e0
[4752030.590525] Stack:
[4752030.594064]  ffff881f5da13a98 ffffffff810be581 ffff88203d2d6dc0
ffff881f5da13ae8
[4752030.603691]  ffffffff817c91ba 00ff881f652b6478 ffff881f00000007
ffff8820352e5b80
[4752030.613311]  ffff881f5da10000 0000000000000000 ffff881f5da13b38
ffff881f5da135d0
[4752030.622926] Call Trace:
[4752030.626959]  [<ffffffff810be581>] wq_worker_sleeping+0x11/0x90
[4752030.634789]  [<ffffffff817c91ba>] __schedule+0x62a/0x9b0
[4752030.642030]  [<ffffffff817c957c>] schedule+0x3c/0x90
[4752030.648874]  [<ffffffff810a7f48>] do_exit+0x7a8/0xb30
[4752030.655813]  [<ffffffff8101992a>] oops_end+0x9a/0xd0
[4752030.662650]  [<ffffffff81067e7e>] no_context+0x13e/0x390
[4752030.669886]  [<ffffffff81068150>] __bad_area_nosemaphore+0x80/0x1f0
[4752030.678193]  [<ffffffff810682d3>] bad_area_nosemaphore+0x13/0x20
[4752030.686209]  [<ffffffff81068597>] __do_page_fault+0xb7/0x400
[4752030.693834]  [<ffffffff81068910>] do_page_fault+0x30/0x80
[4752030.701166]  [<ffffffff817cfa48>] page_fault+0x28/0x30
[4752030.708210]  [<ffffffff810ee9a5>] ?
queued_spin_lock_slowpath+0x105/0x190
[4752030.717062]  [<ffffffff817cd4c7>] _raw_spin_lock_irqsave+0x37/0x40
[4752030.725221]  [<ffffffff810e7cfd>] complete+0x1d/0x50
[4752030.731999]  [<ffffffffa0485931>]
srpt_release_channel_work+0xe1/0x140 [ib_srpt]
[4752030.741523]  [<ffffffff810bd6fd>] process_one_work+0x1ad/0x400
[4752030.749298]  [<ffffffff810bd99e>] worker_thread+0x4e/0x480
[4752030.756677]  [<ffffffff810bd950>] ? process_one_work+0x400/0x400
[4752030.764626]  [<ffffffff810bd950>] ? process_one_work+0x400/0x400
[4752030.772558]  [<ffffffff810c38e8>] kthread+0xd8/0xf0
[4752030.779231]  [<ffffffff810c3810>] ? kthread_worker_fn+0x180/0x180
[4752030.787241]  [<ffffffff817cd9ff>] ret_from_fork+0x3f/0x70
[4752030.794438]  [<ffffffff810c3810>] ? kthread_worker_fn+0x180/0x180
[4752030.802395] Code: 97 69 70 00 e9 53 ff ff ff e8 4d 0e fe ff 0f 1f
00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 8b 87 e0 05 00 00 55
48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00=

[4752030.826210] RIP  [<ffffffff810c3f80>] kthread_data+0x10/0x20
[4752030.833669]  RSP <ffff881f5da13a80>
[4752030.838651] CR2: ffffffffffffffd8
[4752030.843418] ---[ end trace befc2f337e9f56d9 ]---
[4752030.933774] Fixing recursive fault but reboot is needed!




--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--oAbmCl7thUAkjptn7lq8AfCLpdfcOE28f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXDARDAAoJELgmozMOVy/dphMP+wb32fD1YDTarBTxfV9trlV+
uwfP+JdJ4mX3KxTnBhzUXHigDbiZxzV8To78GA7ivo4dUwk3u6PIJkPHqVxKFaBu
5QKgLcvIxv4Yw7nKD3jP/Ykj8W6uvWvs2jO4wKwxFj0qn8gy6xX7JS66EOZEYO7X
Btrmxk9HCT81BBEVDyZTGxCw97gtD98mq9sodUuma8yjjfrtXEOvrCCPFpg2WH1v
Ksvv9vhA62mnFIVPMpUziC/nKJ47rSFTw/qPX8nicn71L9kdq+Am5ZkVSUtNWvsV
4tgnxPSTcsgwrOFP2xUb8n6hvx98wRm7zhBWNk8UR5RdIByaseZadaj/CA0sulfK
1DDHYRLkfDzhQLKL/j+IKXmdPut96b6a4zBJ+tq+M8pk4Q7Z4FWn0mZuodsA9m+v
/Bz5/SnIJiwD+w8fNCMp9M6BQfs3n28ocv0LkT0vVGHbfNK9uSZh4CP9Jhbu5EA2
z5NK0hVmqZ7Yo3FWRJpvuzfCIQRe07wi2lG3nlAzW+zzmwqK35mIaerCqkfDRjhD
AWXh/FyMFFa+Se/JCzvxF9f6rn7YHrfmKvCEyIVwCwHSQtbHMn2x9Dr2CI9EfnxA
mk0+4zZOwF5HMK89ATeyeVkHx+FyYF4NY1h9UOojAhXZA4zIhLZ3M4CY29ifuCDd
/n/Dfir+1bHQEPhvGScq
=LIs6
-----END PGP SIGNATURE-----

--oAbmCl7thUAkjptn7lq8AfCLpdfcOE28f--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
