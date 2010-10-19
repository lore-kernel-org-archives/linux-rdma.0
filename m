From: "Suresh Shelvapille" <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: Opensm crash with OFED 1.5
Date: Tue, 19 Oct 2010 18:17:11 -0400
Message-ID: <7E754FDB97BF4D9DAF66CC3CCA8E34B5@md.baymicrosystems.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11D@orsmsx501.amr.corp.intel.com> <20101012203528.GP24268@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA2A6@orsmsx501.amr.corp.intel.com> <20101012211052.GT24268@obsidianresearch.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA46E@orsmsx501.amr.corp.intel.com> <091262BDA0A846A0B62CB3BEDB366DBC@md.baymicrosystems.com> <EC5B6AE4937B444290B7D4D10BC489A5@md.baymicrosystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EC5B6AE4937B444290B7D4D10BC489A5-+IkoAhRkys/CbFgIbBqbbjGjJy/sRE9J@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Linux RDMA list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Tziporet Koren' <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Just want to let you all know that OpenSM seems to work fine with Centos5.5 on the same HW.

Thanks,
Suri

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Suresh
> Shelvapille
> Sent: Wednesday, October 13, 2010 3:07 PM
> To: 'Linux RDMA list'; 'Tziporet Koren'
> Subject: RE: Opensm crash with OFED 1.5
> 
> 
> I tried 1.5.2 and that did not help, same kernel oops.....
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of
> Suresh
> > Shelvapille
> > Sent: Tuesday, October 12, 2010 7:22 PM
> > To: 'Linux RDMA list'
> > Subject: Opensm crash with OFED 1.5
> >
> >
> > Folks:
> >
> > I have a multi-processor machine, running FedoraCore 12. I have installed OFED 1.5. Everything
> seems
> > to come up ok, I
> > can look at the ibstat and it shows that the Mellanox card stats etc...
> >
> > As soon as I start opensm, I get the following kernel oops and the machine locks up.
> >
> > Any ideas....
> >
> > Thanks,
> > Suri
> >
> > --------------------------------------------------------------------------------------------------
> >
> > Oct 12 17:19:38 localhost OpenSM[2617]: OpenSM 3.3.5#012
> >
> > Oct 12 17:19:38 localhost OpenSM[2617]: Entering DISCOVERING state#012
> >
> > Oct 12 17:20:20 localhost kernel: ib0: ib_query_gid() failed
> >
> > Oct 12 17:20:30 localhost kernel: ib0: ib_query_port failed
> >
> > Oct 12 17:20:52 localhost kernel: BUG: soft lockup - CPU#15 stuck for 61s! [opensm:2637]
> >
> > Oct 12 17:20:52 localhost kernel: Modules linked in: fuse sunrpc ip6t_REJECT nf_conntrack_ipv6
> > ip6table_filter
> > ip6_tables cpufreq_ondemand acpi_cpufreq freq_table rdma_ucm ib_sdp rdma_cm iw_cm ib_addr ib_ipoib
> > ib_cm ib_sa ipv6
> > ib_uverbs ib_umad iw_nes libcrc32c iw_cxgb3 cxgb3 mlx4_en mlx4_ib ib_mthca ib_mad ib_core
> > dm_multipath uinput mlx4_core
> > igb i2c_i801 joydev dca i2c_core iTCO_wdt iTCO_vendor_support mpt2sas scsi_transport_sas [last
> > unloaded: microcode]
> >
> > Oct 12 17:20:52 localhost kernel: CPU 15:
> >
> > Oct 12 17:20:52 localhost kernel: Modules linked in: fuse sunrpc ip6t_REJECT nf_conntrack_ipv6
> > ip6table_filter
> > ip6_tables cpufreq_ondemand acpi_cpufreq freq_table rdma_ucm ib_sdp rdma_cm iw_cm ib_addr ib_ipoib
> > ib_cm ib_sa ipv6
> > ib_uverbs ib_umad iw_nes libcrc32c iw_cxgb3 cxgb3 mlx4_en mlx4_ib ib_mthca ib_mad ib_core
> > dm_multipath uinput mlx4_core
> > igb i2c_i801 joydev dca i2c_core iTCO_wdt iTCO_vendor_support mpt2sas scsi_transport_sas [last
> > unloaded: microcode]
> >
> > Oct 12 17:20:52 localhost kernel: Pid: 2637, comm: opensm Not tainted 2.6.31.5-127.fc12.x86_64 #1
> > X8DTH-i/6/iF/6F
> >
> > Oct 12 17:20:52 localhost kernel: RIP: 0010:[<ffffffff81203558>]  [<ffffffff81203558>]
> > __bitmap_empty+0x0/0x64
> >
> > Oct 12 17:20:52 localhost kernel: RSP: 0018:ffff880c174bbd90  EFLAGS: 00000246
> >
> > Oct 12 17:20:52 localhost kernel: RAX: 0000000000000000 RBX: ffff880c174bbdd8 RCX: 0000000000000001
> >
> > Oct 12 17:20:52 localhost kernel: RDX: ffffffff818ba920 RSI: 0000000000000100 RDI: ffffffff818ba918
> >
> > Oct 12 17:20:52 localhost kernel: RBP: ffffffff8101286e R08: 0000000000000000 R09: 0000000000000004
> >
> > Oct 12 17:20:52 localhost kernel: R10: 0000000000000004 R11: 0000000000000206 R12: ffff880c174bbdd8
> >
> > Oct 12 17:20:52 localhost kernel: R13: ffffffff8101286e R14: ffffffff810dc920 R15: ffff880c174bbcf8
> >
> > Oct 12 17:20:52 localhost kernel: FS:  00007ff2d02e7710(0000) GS:ffffc90001e00000(0000)
> > knlGS:0000000000000000
> >
> > Oct 12 17:20:52 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >
> > Oct 12 17:20:52 localhost kernel: CR2: 000000000041f0c0 CR3: 0000000c19074000 CR4: 00000000000006e0
> >
> > Oct 12 17:20:52 localhost kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >
> > Oct 12 17:20:52 localhost kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >
> > Oct 12 17:20:52 localhost kernel: Call Trace:
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff810383f2>] ? native_flush_tlb_others+0xc3/0xf2
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff8103859d>] ? flush_tlb_mm+0x6f/0x76
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff810debbc>] ? mprotect_fixup+0x480/0x611
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff810da81d>] ? free_pgtables+0xa9/0xcc
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff810f185d>] ? virt_to_head_page+0xe/0x2f
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff810deee9>] ? sys_mprotect+0x19c/0x227
> >
> > Oct 12 17:20:52 localhost kernel: [<ffffffff81011cf2>] ? system_call_fastpath+0x16/0x1b
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
