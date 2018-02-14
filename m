From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma resource warning on 4.16-rc1 when unloading qedr after NFS
 mount
Date: Wed, 14 Feb 2018 18:34:17 +0200
Message-ID: <20180214163417.GA2197@mtr-leonro.local>
References: <CY1PR0701MB2012C221846562FA89D401AA88F50@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <364A82D1-F2D0-40C0-9310-4B9C778B3C59@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VnOTrGv5LmZxna7m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <364A82D1-F2D0-40C0-9310-4B9C778B3C59-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Le, Thong" <Thong.Le-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--VnOTrGv5LmZxna7m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 14, 2018 at 11:20:39AM -0500, Chuck Lever wrote:
>
>
> > On Feb 14, 2018, at 11:00 AM, Kalderon, Michal <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> >
> > Hi Leon, Chuck,
> >
> > We ran nfs mount over qedr using 4.16-rc1
> > When unloading qedr we get a WARNING from the resource tracker ( pasted below)
> >
> > Can you please advise on the best way to debug this? How can we get more info on the resource not being freed?
>
> I haven't seen this kind of report before, so I can't directly answer
> your questions. But can you tell us more about reproducing it:

It is resource tracking which was entered in last merge window.

>
> - Is there a workload running on the NFS mount point when the module
> is unloaded?
>
> - Is the issue 100% reproducible, or intermittent?
>
> - Have you tried bisecting?

It will be one of three patches:
9d5f8c209b3f RDMA/core: Add resource tracking for create and destroy PDs
08f294a1524b RDMA/core: Add resource tracking for create and destroy CQs
78a0cd648a80 RDMA/core: Add resource tracking for create and destroy QPs

>
> - iWARP, RoCE, or both?
>
> - Have you tried reproducing with a different model of device?

I doubt that it is related to device, it looks like a resource leak
while removing rpcrdma.

We definitely need to add more information to this warning to understand
which one of three available resources wasn't freed.

>
>
> > Thanks,
> > Michal
> >
> > GAD17990 login: [  300.480137] ib_srpt srpt_remove_one(qedr0): nothing to do.
> > [  300.515527] ib_srpt srpt_remove_one(qedr1): nothing to do.
> > [  300.542182] rpcrdma: removing device qedr1 for 192.168.110.146:20049
> > [  300.573789] WARNING: CPU: 12 PID: 3545 at drivers/infiniband/core/restrack.c:20 rdma_restrack_clean+0x25/0x30 [ib_core]
> > [  300.625985] Modules linked in: rpcsec_gss_krb5 nfsv4 dns_resolver nfs fscache rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm 8021q garp mrp qedr(-) ib_core xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun bridge stp llc ebtable_filter ebtables fuse ip6table_filter ip6_tables iptable_filter dm_mirror dm_region_hash dm_log dm_mod vfat fat dax intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd glue_he
 lper cryptd ipmi_si
> > [  300.972993]  iTCO_wdt ipmi_devintf sg pcspkr iTCO_vendor_support hpwdt hpilo lpc_ich ipmi_msghandler pcc_cpufreq ioatdma i2c_i801 mfd_core wmi shpchp dca acpi_power_meter i2c_core nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod qede qed crc32c_intel tg3 hpsa scsi_transport_sas crc8
> > [  301.109036] CPU: 12 PID: 3545 Comm: rmmod Not tainted 4.16.0-rc1 #1
> > [  301.139518] Hardware name: HP ProLiant DL380 Gen9/ProLiant DL380 Gen9, BIOS P89 02/17/2017
> > [  301.180411] RIP: 0010:rdma_restrack_clean+0x25/0x30 [ib_core]
> > [  301.208350] RSP: 0018:ffffb1820478fe88 EFLAGS: 00010286
> > [  301.233241] RAX: 0000000000000000 RBX: ffffa099ed1b4070 RCX: ffffdf02a193c800
> > [  301.268001] RDX: ffffa095ed12d7a0 RSI: 0000000000025900 RDI: ffffa099ed1b47d0
> > [  301.302530] RBP: ffffa099ed1b4070 R08: ffffa095de9dd000 R09: 0000000180080007
> > [  301.337245] R10: 0000000000000001 R11: ffffa095de9dd000 R12: ffffa099ed1b4000
> > [  301.372151] R13: ffffa099ed1b405c R14: 0000000000e231c0 R15: 0000000000e23010
> > [  301.407384] FS:  00007f2b0c854740(0000) GS:ffffa099ff700000(0000) knlGS:0000000000000000
> > [  301.447026] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  301.475409] CR2: 0000000000e2caf8 CR3: 0000000865c0d006 CR4: 00000000001606e0
> > [  301.510892] Call Trace:
> > [  301.522715]  ib_unregister_device+0xf5/0x190 [ib_core]
> > [  301.547966]  qedr_remove+0x37/0x60 [qedr]
> > [  301.568393]  qede_rdma_unregister_driver+0x4b/0x90 [qede]
> > [  301.594980]  SyS_delete_module+0x168/0x240
> > [  301.615057]  do_syscall_64+0x6f/0x1a0
> > [  301.633588]  entry_SYSCALL_64_after_hwframe+0x21/0x86
> > [  301.658657] RIP: 0033:0x7f2b0bd33707
> > [  301.676005] RSP: 002b:00007ffdefa29d98 EFLAGS: 00000202 ORIG_RAX: 00000000000000b0
> > [  301.713324] RAX: ffffffffffffffda RBX: 0000000000e231c0 RCX: 00007f2b0bd33707
> > [  301.748186] RDX: 00007f2b0bda3a80 RSI: 0000000000000800 RDI: 0000000000e23228
> > [  301.782960] RBP: 0000000000000000 R08: 00007f2b0bff8060 R09: 00007f2b0bda3a80
> > [  301.818142] R10: 00007ffdefa29b20 R11: 0000000000000202 R12: 00007ffdefa2b70d
> > [  301.853290] R13: 0000000000000000 R14: 0000000000e231c0 R15: 0000000000e23010
> > [  301.888138] Code: 84 00 00 00 00 00 0f 1f 44 00 00 48 83 c7 28 31 c0 eb 0c 48 83 c0 08 48 3d 00 08 00 00 74 0f 48 8d 14 07 48 8b 12 48 85 d2 74 e8 <0f> ff c3 f3 c3 66 0f 1f 44 00 00 0f 1f 44 00 00 53 48 8b 47 28
> > [  301.981140] ---[ end trace 28dec8f15205789a ]---
>
> --
> Chuck Lever
>
>
>

--VnOTrGv5LmZxna7m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqEZQkACgkQ5GN7iDZy
WKe9iw//X2zEJ/FG+yz+9+pS4SHSbs48W/oLGCwkDIltrnxkHrVWHOJGMYVQFX+3
SfBF+ufWr9LFXlFPdTvKqn/u8O+0Zp0tWD8U+5JOt/b2ZjncIUKRJkMrT+VuIHuK
RCJacsaDBNc+XLGOTexrB4znfhkECEz6Kirime1MUDlRprINFy5PvKIUMU258m4T
SDZvjCk3sUclAkCxHyromHthnvxEfFkgJCVFlfUNMGvH6kUjfr28BynigBvqx937
mJVFnK/eX1aXeAYyNI4sNz/Ojo2AodkWsRk2qaM+aFP7DRHBYv13d1dai/viR6NP
mWH6NEc4+Ub2REzrjzcNRqzrLpPQTBZGAzIOkiqrJKc3GVTmPksx+qO4iRu0AAes
rBQ6AvCR4eC7kldbBGToyleUJ6ISX9yZyTJbef8AjC/j95HK59cLK8w8IqP3i5HA
/DPazexMqUN5p+sgCE3AmqPY5em9JLPikRIeFQYNqTczBEr3ZAeFXatN89cJfyCo
l4O/hU7eYr4Mt9KyJWzTwZddKxzHfYH+Wfj0+COupCLRxuHp0J/jEMS95oEMRz77
tP0GozZBJy6Gf+Bx7CLqYzyK6IIHOndZvkBB3+ubKyD5NgyvgUKriNdbVGQWTL2d
/J0X6Xj2yav1oKfFzboXtsAAEE0AD09lQYhH/CoyCw4HCu4CnEw=
=Xcvw
-----END PGP SIGNATURE-----

--VnOTrGv5LmZxna7m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
