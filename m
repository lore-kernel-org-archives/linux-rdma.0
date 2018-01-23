From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel panic over qedr with
Date: Tue, 23 Jan 2018 09:13:38 -0800
Message-ID: <E8FC6C01-6EEB-49B7-A707-6C823CC2C659@oracle.com>
References: <CY1PR0701MB20126FB6BEB198CEE3CEED6D88E30@CY1PR0701MB2012.namprd07.prod.outlook.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR0701MB20126FB6BEB198CEE3CEED6D88E30-UpKza+2NMNLHMJvQ0dyT705OhdzP3rhOnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> On Jan 23, 2018, at 9:05 AM, Kalderon, Michal =
<Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>=20
> Hi Chuck,
> =20
> I=E2=80=99m hitting issues with NFS over qedr (either iWARP / RoCE)
> =20
> I get a kernel panic during mount.
> Looks like it started with 4.15-rcx
> Looking at qedr code it looks like the wr we get may be corrupted/
> Below the stack trace and following logs with RCP debug enabled=E2=80=A6=

> =20
> Can you please advise on how to proceed with debugging ?

I don't see anything distinctive in the log output.
I would start with a git bisect if your reproducer
hits the oops every time.


> Thanks,
> Michal
> =20
> [  782.951762] BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000040
> [  782.952286] IP: __qedr_post_send+0x85/0x127c [qedr]
> [  782.952797] PGD 0 P4D 0
> [  782.953293] Oops: 0000 [#1] SMP PTI
> [  782.953781] Modules linked in: qedr(E) qede qed rpcsec_gss_krb5 =
nfsv4 dns_resolver nfs fscache xt_CHECKSUM iptable_mangle ipt_MASQUERADE =
nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 =
nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c ipt_REJECT =
nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables =
ip6table_filter ip6_tables iptable_filter bonding rpcrdma ib_isert =
iscsi_target_mod ib_iser ib_srpt target_core_mod ib_srp =
scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm =
ib_cm iw_cm ib_core intel_powerclamp coretemp kvm irqbypass =
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel =
crypto_simd glue_helper cryptd iTCO_wdt gpio_ich iTCO_vendor_support =
ipmi_si pcspkr sg lpc_ich i2c_i801 ipmi_devintf ipmi_msghandler ioatdma =
i7core_edac shpchp
> [  782.957637]  acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace =
sunrpc ip_tables ext4 mbcache jbd2 sr_mod sd_mod cdrom ata_generic =
pata_acpi mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt =
fb_sys_fops ttm drm igb ata_piix ptp libata pps_core e1000 crc32c_intel =
dca i2c_algo_bit i2c_core
> [  782.959572] CPU: 7 PID: 3422 Comm: mount.nfs Tainted: G            =
E    4.15.0-rc9+ #2
> [  782.960232] Hardware name: Intel Corporation S5520HC/S5520HC, BIOS =
S5500.86B.01.00.0059.082320111421 08/23/2011
> [  782.960901] RIP: 0010:__qedr_post_send+0x85/0x127c [qedr]
> [  782.961575] RSP: 0018:ffffab3d8259b6f8 EFLAGS: 00010082
> [  782.962244] RAX: 0000000000000025 RBX: 0000000000000028 RCX: =
0000000000000006
> [  782.962907] RDX: 0000000000000000 RSI: 0000000000000092 RDI: =
ffff9b275fd968f0
> [  782.963573] RBP: ffffab3d8259b780 R08: 00000000000004cc R09: =
0000000000000000
> [  782.964242] R10: ffff9b2753218540 R11: ffff9b25d9d67400 R12: =
ffff9b25d60aa000
> [  782.964894] R13: 0000000000000028 R14: 0000000000000000 R15: =
ffff9b259400e400
> [  782.965557] FS:  00007f91dad3a880(0000) GS:ffff9b275fd80000(0000) =
knlGS:0000000000000000
> [  782.966235] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  782.966906] CR2: 0000000000000040 CR3: 0000000393dbc003 CR4: =
00000000000206e0
> [  782.967593] Call Trace:
> [  782.968271]  qedr_post_send+0x12e/0x180 [qedr]
> [  782.968950]  rpcrdma_ep_post+0x83/0xf0 [rpcrdma]
> [  782.969637]  xprt_rdma_send_request+0x84/0xe0 [rpcrdma]
> [  782.970349]  xprt_transmit+0x6c/0x370 [sunrpc]
> [  782.971057]  ? call_decode+0x820/0x820 [sunrpc]
> [  782.971759]  ? call_decode+0x820/0x820 [sunrpc]
> [  782.972464]  call_transmit+0x194/0x280 [sunrpc]
> [  782.973174]  __rpc_execute+0x7e/0x3f0 [sunrpc]
> [  782.973867]  rpc_run_task+0x106/0x150 [sunrpc]
> [  782.974577]  nfs4_proc_setclientid+0x213/0x380 [nfsv4]
> [  782.975279]  nfs40_discover_server_trunking+0x80/0xe0 [nfsv4]
> [  782.975982]  nfs4_discover_server_trunking+0x78/0x2b0 [nfsv4]
> [  782.976688]  nfs4_init_client+0x11b/0x260 [nfsv4]
> [  782.977402]  ? __rpc_init_priority_wait_queue+0x83/0xb0 [sunrpc]
> [  782.978129]  ? nfs4_alloc_client+0x15f/0x200 [nfsv4]
> [  782.978853]  ? nfs_get_client+0x2c1/0x360 [nfs]
> [  782.979583]  ? pcpu_alloc_area+0xc0/0x130
> [  782.980317]  nfs4_set_client+0x9d/0xe0 [nfsv4]
> =20
> =20
> RCP Logs
> [  782.948548] RPC:   209 xmit complete
> [  782.948549] RPC:   209 sleep_on(queue "xprt_pending" time =
4295450237)
> [  782.948550] RPC:   209 added to queue 000000006f382a4e =
"xprt_pending"
> [  782.948550] RPC:   209 setting alarm for 60000 ms
> [  782.948552] RPC:   209 sync task going to sleep
> [  782.948808] RPC:       rpcrdma_wc_receive: rep 0000000067b47231 =
opcode 'recv', length 52: success
> [  782.948811] RPC:       rpcrdma_reply_handler: incoming rep =
0000000067b47231
> [  782.948814] RPC:       rpcrdma_reply_handler: reply =
0000000067b47231 completes request 0000000096e058c2 (xid 0x4e366e3c)
> [  782.948869] RPC:       rpcrdma_inline_fixup: srcp =
0x00000000a5e2c17f len 24 hdrlen 24
> [  782.948871] RPC:       wake_up_first(0000000004dd7309 =
"xprt_sending")
> [  782.948874] RPC:   209 xid 4e366e3c complete (24 bytes received)
> [  782.948875] RPC:   209 __rpc_wake_up_task (now 4295450237)
> [  782.948876] RPC:   209 disabling timer
> [  782.948877] RPC:   209 removed from queue 000000006f382a4e =
"xprt_pending"
> [  782.948881] RPC:       __rpc_wake_up_task done
> [  782.948916] RPC:   209 sync task resuming
> [  782.948918] RPC:   209 call_status (status 24)
> [  782.948919] RPC:   209 call_decode (status 24)
> [  782.948921] RPC:   209 validating NULL cred 000000000941bc29
> [  782.948923] RPC:   209 using AUTH_NULL cred 000000000941bc29 to =
unwrap rpc data
> [  782.948925] RPC:   209 call_decode result 0
> [  782.948926] RPC:   209 return 0, status 0
> [  782.948927] RPC:   209 release task
> [  782.948929] RPC:       xprt_rdma_free: called on 0x0000000067b47231
> [  782.948963] RPC:   209 release request 00000000088290f9
> [  782.948964] RPC:       wake_up_first(0000000066fcc180 =
"xprt_backlog")
> [  782.948966] RPC:       rpc_release_client(00000000d13a4ef8)
> [  782.948968] RPC:   209 freeing task
> [  782.949065] svc: svc_destroy(NFSv4 callback, 2)
> [  782.949069] RPC:       new task initialized, procpid 3422
> [  782.949070] RPC:       allocated task 00000000407c4b9f
> [  782.949071] RPC:   210 __rpc_execute flags=3D0x5280
> [  782.949072] RPC:   210 call_start nfs4 proc SETCLIENTID (sync)
> [  782.949073] RPC:   210 call_reserve (status 0)
> [  782.949074] RPC:   210 reserved req 00000000088290f9 xid 4f366e3c
> [  782.949076] RPC:   210 call_reserveresult (status 0)
> [  782.949077] RPC:   210 call_refresh (status 0)
> [  782.949078] RPC:   210 refreshing UNIX cred 000000005a6be29a
> [  782.949079] RPC:   210 call_refreshresult (status 0)
> [  782.949080] RPC:   210 call_allocate (status 0)
> [  782.949081] RPC:   210 xprt_rdma_allocate: send size =3D 1456, recv =
size =3D 276, req =3D 00000000f056c1ce
> [  782.949082] RPC:   210 call_bind (status 0)
> [  782.949083] RPC:   210 call_connect xprt 00000000e40824fb is =
connected
> [  782.949083] RPC:   210 call_transmit (status 0)
> [  782.949084] RPC:   210 xprt_prepare_transmit
> [  782.949085] RPC:   210 xprt_cwnd_limited cong =3D 0 cwnd =3D 8192
> [  782.949085] RPC:   210 rpc_xdr_encode (status 0)
> [  782.949086] RPC:   210 marshaling UNIX cred 000000005a6be29a
> [  782.949088] RPC:   210 using AUTH_UNIX cred 000000005a6be29a to =
wrap rpc data
> [  782.949090] RPC:   210 xprt_transmit(192)
> [  782.949091] RPC:   210 rpcrdma_marshal_req: inline/inline: hdrlen =
28 rpclen
> [  782.949093] RPC:       rpcrdma_ep_post: posting 2 s/g entries

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
