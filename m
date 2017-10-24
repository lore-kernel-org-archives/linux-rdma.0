From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/netlink: OOPs in rdma_nl_rcv_msg() from
 misinterpreted flag
Date: Tue, 24 Oct 2017 17:41:52 +0300
Message-ID: <20171024144152.GH16127@mtr-leonro.local>
References: <20171024123957.32207.70888.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jRdC2OsRnuV8iIl8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171024123957.32207.70888.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--jRdC2OsRnuV8iIl8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2017 at 08:41:01AM -0400, Michael J. Ruhl wrote:
> From: Michael J. Ruhl <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> rdma_nl_rcv_msg() checks to see if it should use the .dump() callback
> or the .doit() callback.  The check is done with this check:
>
> if (flags & NLM_F_DUMP) ...
>
> The NLM_F_DUMP flag is two bits (NLM_F_ROOT | NLM_F_MATCH).
>
> When an RDMA_NL_LS message (response) is received, the bit used for
> indicating an error is the same bit as NLM_F_ROOT.
>
> NLM_F_ROOT == (0x100) == RDMA_NL_LS_F_ERR.
>
> ibacm sends a response with the RDMA_NL_LS_F_ERR bit set if an error
> occurs in the service.  The current code then misinterprets the
> NLM_F_DUMP bit and trys to call the .dump() callback.
>
> If the .dump() callback for the specified request is not available
> (which is true for the RDMA_NL_LS messages) the following Oops occurs:
>
> [ 4555.960256] BUG: unable to handle kernel NULL pointer dereference at
>    (null)
> [ 4555.969046] IP:           (null)
> [ 4555.972664] PGD 10543f1067 P4D 10543f1067 PUD 1033f93067 PMD 0
> [ 4555.979287] Oops: 0010 [#1] SMP
> [ 4555.982809] Modules linked in: rpcrdma ib_isert iscsi_target_mod
> target_core_mod ib_iser libiscsi scsi_transport_iscsi ib_ipoib rdma_ucm ib_ucm
> ib_uverbs ib_umad rdma_cm ib_cm iw_cm dm_mirror dm_region_hash dm_log dm_mod
> dax sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass
> crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel crypto_simd
> glue_helper cryptd hfi1 rdmavt iTCO_wdt iTCO_vendor_support ib_core mei_me
> lpc_ich pcspkr mei ioatdma sg shpchp i2c_i801 mfd_core wmi ipmi_si ipmi_devintf
> ipmi_msghandler acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace
> sunrpc ip_tables ext4 mbcache jbd2 sd_mod mgag200 drm_kms_helper syscopyarea
> sysfillrect sysimgblt fb_sys_fops ttm igb ahci crc32c_intel ptp libahci
> pps_core drm dca libata i2c_algo_bit i2c_core
> [ 4556.061190] CPU: 54 PID: 9841 Comm: ibacm Tainted: G          I
> 4.14.0-rc2+ #6
> [ 4556.069667] Hardware name: Intel Corporation S2600WT2/S2600WT2, BIOS
> SE5C610.86B.01.01.0008.021120151325 02/11/2015
> [ 4556.081339] task: ffff880855f42d00 task.stack: ffffc900246b4000
> [ 4556.087967] RIP: 0010:          (null)
> [ 4556.092166] RSP: 0018:ffffc900246b7bc8 EFLAGS: 00010246
> [ 4556.098018] RAX: ffffffff81dbe9e0 RBX: ffff881058bb1000 RCX:
> 0000000000000000
> [ 4556.105997] RDX: 0000000000001100 RSI: ffff881058bb1320 RDI:
> ffff881056362000
> [ 4556.113984] RBP: ffffc900246b7bf8 R08: 0000000000000ec0 R09:
> 0000000000001100
> [ 4556.121971] R10: ffff8810573a5000 R11: 0000000000000000 R12:
> ffff881056362000
> [ 4556.129957] R13: 0000000000000ec0 R14: ffff881058bb1320 R15:
> 0000000000000ec0
> [ 4556.137945] FS:  00007fe0ba5a38c0(0000) GS:ffff88105f080000(0000)
> knlGS:0000000000000000
> [ 4556.147000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 4556.153433] CR2: 0000000000000000 CR3: 0000001056f5d003 CR4:
> 00000000001606e0
> [ 4556.161419] Call Trace:
> [ 4556.164167]  ? netlink_dump+0x12c/0x290
> [ 4556.168468]  __netlink_dump_start+0x186/0x1f0
> [ 4556.173357]  rdma_nl_rcv_msg+0x193/0x1b0 [ib_core]
> [ 4556.178724]  rdma_nl_rcv+0xdc/0x130 [ib_core]
> [ 4556.183604]  netlink_unicast+0x181/0x240
> [ 4556.187998]  netlink_sendmsg+0x2c2/0x3b0
> [ 4556.192392]  sock_sendmsg+0x38/0x50
> [ 4556.196299]  SYSC_sendto+0x102/0x190
> [ 4556.200308]  ? __audit_syscall_entry+0xaf/0x100
> [ 4556.205387]  ? syscall_trace_enter+0x1d0/0x2b0
> [ 4556.210366]  ? __audit_syscall_exit+0x209/0x290
> [ 4556.215442]  SyS_sendto+0xe/0x10
> [ 4556.219060]  do_syscall_64+0x67/0x1b0
> [ 4556.223165]  entry_SYSCALL64_slow_path+0x25/0x25
> [ 4556.228328] RIP: 0033:0x7fe0b9db2a63
> [ 4556.232333] RSP: 002b:00007ffc55edc260 EFLAGS: 00000293 ORIG_RAX:
> 000000000000002c
> [ 4556.240808] RAX: ffffffffffffffda RBX: 0000000000000010 RCX:
> 00007fe0b9db2a63
> [ 4556.248796] RDX: 0000000000000010 RSI: 00007ffc55edc280 RDI:
> 000000000000000d
> [ 4556.256782] RBP: 00007ffc55edc670 R08: 00007ffc55edc270 R09:
> 000000000000000c
> [ 4556.265321] R10: 0000000000000000 R11: 0000000000000293 R12:
> 00007ffc55edc280
> [ 4556.273846] R13: 000000000260b400 R14: 000000000000000d R15:
> 0000000000000001
> [ 4556.282368] Code:  Bad RIP value.
> [ 4556.286629] RIP:           (null) RSP: ffffc900246b7bc8
> [ 4556.293013] CR2: 0000000000000000
> [ 4556.297292] ---[ end trace 8d67abcfd10ec209 ]---
> [ 4556.305465] Kernel panic - not syncing: Fatal exception
> [ 4556.313786] Kernel Offset: disabled
> [ 4556.321563] ---[ end Kernel panic - not syncing: Fatal exception
> [ 4556.328960] ------------[ cut here ]------------
>
> Special case RDMA_NL_LS response messages to call the appropriate
> callback.
>
> Additionally, make sure that the .dump() callback is not NULL
> before calling it.

Please don't add them here, it is dead code in wrong place.
First it is unachievable paths, and second they need to be checked
in is_nl_valid() function.

Thanks.

--jRdC2OsRnuV8iIl8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnvUTAACgkQ5GN7iDZy
WKdWCQ/+KRu31+8e5h+6mZlfa1JNBlf01N2A8+m453aSx2NAf1JyG4pwAWkdUGa7
IGORh89Dia8ch8CIAQDpYkeg8GgV09LnFSONyFf4TYLp1rHnLCEaP2B5zZMPCTUl
KY4zrN2Mmn0BaiNdzpR6yKCULmXIFtV1Jni1vagwanj910MGm7RvOv0eTgUPB9vx
trfp4qnvIhgEP6ohe3m1PEEgVPO09nJ6TRiJ1ppuHYJzeu/dHmqz1GfvHEPDcltO
mCvyPEe5FlK7bh6lgLcpU1UYHqnqrscu/3SOFpsb90y+LwYlaCgR8qjGYcVJ0ESW
TrhW9jVQFss74ZFPsMI+TG0BWfccO+WO3SQkADTRkk95CeGEr9rVkqWYsz8QHiJ1
0RUmJp2ovxZzV8OsDpxRs894SNLADBY36v0QDvRcRbZ6GdYMuLLg8FJS8D0hOKdD
jnUUh3kP6KmFdEazv2iEkQdVaFa4U4FciLmOXVTcLCaB0PUB33ka3sYZbAB/TOV3
GJ55eN0g/VzfPsjVFPXA0SQxbhwMXHyhTKO9trqxlUO4JrJDD6RrsiPuOG62Oiy/
pNhYkxoHsR5NFg0vs+xaqb6Blu3We84Plf8PSnClTpMMjRIclIkWuGXBPkBSkH7Q
pe1eywj5/E6x/P5kyextvLbUHQiH5W8thSowJIdjIVMDgbKWRqA=
=fOyP
-----END PGP SIGNATURE-----

--jRdC2OsRnuV8iIl8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
