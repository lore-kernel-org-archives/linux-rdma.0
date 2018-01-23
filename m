From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Kernel panic running nfs over qedr with 4.15-rc
Date: Tue, 23 Jan 2018 17:14:39 +0000
Message-ID: <CY1PR0701MB20121CD0E2CD842A21B195D888E30@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,

I'm hitting issues with NFS over qedr (either iWARP / RoCE)=20

I get a kernel panic during mount.=20
Looks like it started with 4.15-rcx
Looking at qedr code it looks like the wr we get may be corrupted/
Below the stack trace and following logs with RCP debug enabled.=20

Can you please advise on how to proceed with debugging ?=20

Thanks,
Michal

[=A0 782.951762] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000040
[=A0 782.952286] IP: __qedr_post_send+0x85/0x127c [qedr]
[=A0 782.952797] PGD 0 P4D 0
[=A0 782.953293] Oops: 0000 [#1] SMP PTI
[=A0 782.953781] Modules linked in: qedr(E) qede qed rpcsec_gss_krb5 nfsv4 =
dns_resolver nfs fscache xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_m=
asquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_i=
pv4 xt_conntrack nf_conntrack libcrc32c ipt_REJECT nf_reject_ipv4 tun bridg=
e stp llc ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter=
 bonding rpcrdma ib_isert iscsi_target_mod ib_iser ib_srpt target_core_mod =
ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_c=
m ib_cm iw_cm ib_core intel_powerclamp coretemp kvm irqbypass crct10dif_pcl=
mul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_help=
er cryptd iTCO_wdt gpio_ich iTCO_vendor_support ipmi_si pcspkr sg lpc_ich i=
2c_i801 ipmi_devintf ipmi_msghandler ioatdma i7core_edac shpchp
[=A0 782.957637]=A0 acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrp=
c ip_tables ext4 mbcache jbd2 sr_mod sd_mod cdrom ata_generic pata_acpi mga=
g200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm i=
gb ata_piix ptp libata pps_core e1000 crc32c_intel dca i2c_algo_bit i2c_cor=
e
[=A0 782.959572] CPU: 7 PID: 3422 Comm: mount.nfs Tainted: G=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0 E=A0=A0=A0 4.15.0-rc9+ #2
[=A0 782.960232] Hardware name: Intel Corporation S5520HC/S5520HC, BIOS S55=
00.86B.01.00.0059.082320111421 08/23/2011
[=A0 782.960901] RIP: 0010:__qedr_post_send+0x85/0x127c [qedr]
[=A0 782.961575] RSP: 0018:ffffab3d8259b6f8 EFLAGS: 00010082
[=A0 782.962244] RAX: 0000000000000025 RBX: 0000000000000028 RCX: 000000000=
0000006
[=A0 782.962907] RDX: 0000000000000000 RSI: 0000000000000092 RDI: ffff9b275=
fd968f0
[=A0 782.963573] RBP: ffffab3d8259b780 R08: 00000000000004cc R09: 000000000=
0000000
[=A0 782.964242] R10: ffff9b2753218540 R11: ffff9b25d9d67400 R12: ffff9b25d=
60aa000
[=A0 782.964894] R13: 0000000000000028 R14: 0000000000000000 R15: ffff9b259=
400e400
[=A0 782.965557] FS:=A0 00007f91dad3a880(0000) GS:ffff9b275fd80000(0000) kn=
lGS:0000000000000000
[=A0 782.966235] CS:=A0 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[=A0 782.966906] CR2: 0000000000000040 CR3: 0000000393dbc003 CR4: 000000000=
00206e0
[=A0 782.967593] Call Trace:
[=A0 782.968271]=A0 qedr_post_send+0x12e/0x180 [qedr]
[=A0 782.968950]=A0 rpcrdma_ep_post+0x83/0xf0 [rpcrdma]
[=A0 782.969637]=A0 xprt_rdma_send_request+0x84/0xe0 [rpcrdma]
[=A0 782.970349]=A0 xprt_transmit+0x6c/0x370 [sunrpc]
[=A0 782.971057]=A0 ? call_decode+0x820/0x820 [sunrpc]
[=A0 782.971759]=A0 ? call_decode+0x820/0x820 [sunrpc]
[=A0 782.972464]=A0 call_transmit+0x194/0x280 [sunrpc]
[=A0 782.973174]=A0 __rpc_execute+0x7e/0x3f0 [sunrpc]
[=A0 782.973867]=A0 rpc_run_task+0x106/0x150 [sunrpc]
[=A0 782.974577]=A0 nfs4_proc_setclientid+0x213/0x380 [nfsv4]
[=A0 782.975279]=A0 nfs40_discover_server_trunking+0x80/0xe0 [nfsv4]
[=A0 782.975982]=A0 nfs4_discover_server_trunking+0x78/0x2b0 [nfsv4]
[=A0 782.976688]=A0 nfs4_init_client+0x11b/0x260 [nfsv4]
[=A0 782.977402] =A0? __rpc_init_priority_wait_queue+0x83/0xb0 [sunrpc]
[=A0 782.978129]=A0 ? nfs4_alloc_client+0x15f/0x200 [nfsv4]
[=A0 782.978853]=A0 ? nfs_get_client+0x2c1/0x360 [nfs]
[=A0 782.979583]=A0 ? pcpu_alloc_area+0xc0/0x130
[=A0 782.980317]=A0 nfs4_set_client+0x9d/0xe0 [nfsv4]


RCP Logs
[=A0 782.948548] RPC:=A0=A0 209 xmit complete
[=A0 782.948549] RPC:=A0=A0 209 sleep_on(queue "xprt_pending" time 42954502=
37)
[=A0 782.948550] RPC:=A0=A0 209 added to queue 000000006f382a4e "xprt_pendi=
ng"
[=A0 782.948550] RPC:=A0=A0 209 setting alarm for 60000 ms
[=A0 782.948552] RPC:=A0=A0 209 sync task going to sleep
[=A0 782.948808] RPC:=A0=A0=A0=A0=A0=A0 rpcrdma_wc_receive: rep 0000000067b=
47231 opcode 'recv', length 52: success
[=A0 782.948811] RPC:=A0=A0=A0=A0=A0=A0 rpcrdma_reply_handler: incoming rep=
 0000000067b47231
[=A0 782.948814] RPC:=A0=A0=A0=A0=A0=A0 rpcrdma_reply_handler: reply 000000=
0067b47231 completes request 0000000096e058c2 (xid 0x4e366e3c)
[=A0 782.948869] RPC:=A0=A0=A0=A0=A0=A0 rpcrdma_inline_fixup: srcp 0x000000=
00a5e2c17f len 24 hdrlen 24
[=A0 782.948871] RPC:=A0=A0=A0=A0=A0=A0 wake_up_first(0000000004dd7309 "xpr=
t_sending")
[=A0 782.948874] RPC:=A0=A0 209 xid 4e366e3c complete (24 bytes received)
[=A0 782.948875] RPC:=A0=A0 209 __rpc_wake_up_task (now 4295450237)
[=A0 782.948876] RPC:=A0=A0 209 disabling timer
[=A0 782.948877] RPC:=A0=A0 209 removed from queue 000000006f382a4e "xprt_p=
ending"
[=A0 782.948881] RPC: =A0=A0=A0=A0=A0=A0__rpc_wake_up_task done
[=A0 782.948916] RPC:=A0=A0 209 sync task resuming
[=A0 782.948918] RPC:=A0=A0 209 call_status (status 24)
[=A0 782.948919] RPC:=A0=A0 209 call_decode (status 24)
[=A0 782.948921] RPC:=A0=A0 209 validating NULL cred 000000000941bc29
[=A0 782.948923] RPC:=A0=A0 209 using AUTH_NULL cred 000000000941bc29 to un=
wrap rpc data
[=A0 782.948925] RPC:=A0=A0 209 call_decode result 0
[=A0 782.948926] RPC:=A0=A0 209 return 0, status 0
[=A0 782.948927] RPC:=A0=A0 209 release task
[=A0 782.948929] RPC:=A0=A0=A0=A0=A0=A0 xprt_rdma_free: called on 0x0000000=
067b47231
[=A0 782.948963] RPC:=A0=A0 209 release request 00000000088290f9
[=A0 782.948964] RPC:=A0=A0=A0=A0=A0=A0 wake_up_first(0000000066fcc180 "xpr=
t_backlog")
[=A0 782.948966] RPC:=A0=A0=A0=A0=A0=A0 rpc_release_client(00000000d13a4ef8=
)
[=A0 782.948968] RPC:=A0=A0 209 freeing task
[=A0 782.949065] svc: svc_destroy(NFSv4 callback, 2)
[=A0 782.949069] RPC:=A0=A0=A0=A0=A0=A0 new task initialized, procpid 3422
[=A0 782.949070] RPC:=A0=A0=A0=A0=A0=A0 allocated task 00000000407c4b9f
[=A0 782.949071] RPC:=A0=A0 210 __rpc_execute flags=3D0x5280
[=A0 782.949072] RPC:=A0=A0 210 call_start nfs4 proc SETCLIENTID (sync)
[=A0 782.949073] RPC:=A0=A0 210 call_reserve (status 0)
[=A0 782.949074] RPC:=A0=A0 210 reserved req 00000000088290f9 xid 4f366e3c
[=A0 782.949076] RPC:=A0=A0 210 call_reserveresult (status 0)
[=A0 782.949077] RPC:=A0=A0 210 call_refresh (status 0)
[=A0 782.949078] RPC:=A0=A0 210 refreshing UNIX cred 000000005a6be29a
[=A0 782.949079] RPC:=A0=A0 210 call_refreshresult (status 0)
[=A0 782.949080] RPC:=A0=A0 210 call_allocate (status 0)
[=A0 782.949081] RPC:=A0=A0 210 xprt_rdma_allocate: send size =3D 1456, rec=
v size =3D 276, req =3D 00000000f056c1ce
[=A0 782.949082] RPC:=A0=A0 210 call_bind (status 0)
[=A0 782.949083] RPC:=A0=A0 210 call_connect xprt 00000000e40824fb is conne=
cted
[=A0 782.949083] RPC:=A0=A0 210 call_transmit (status 0)
[=A0 782.949084] RPC:=A0=A0 210 xprt_prepare_transmit
[=A0 782.949085] RPC:=A0=A0 210 xprt_cwnd_limited cong =3D 0 cwnd =3D 8192
[=A0 782.949085] RPC:=A0=A0 210 rpc_xdr_encode (status 0)
[=A0 782.949086] RPC:=A0=A0 210 marshaling UNIX cred 000000005a6be29a
[=A0 782.949088] RPC:=A0=A0 210 using AUTH_UNIX cred 000000005a6be29a to wr=
ap rpc data
[=A0 782.949090] RPC:=A0=A0 210 xprt_transmit(192)
[=A0 782.949091] RPC:=A0=A0 210 rpcrdma_marshal_req: inline/inline: hdrlen =
28 rpclen
[=A0 782.949093] RPC:=A0=A0=A0=A0=A0=A0 rpcrdma_ep_post: posting 2 s/g entr=
ies

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
