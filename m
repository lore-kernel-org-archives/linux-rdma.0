From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 7/8] IB/core: Do not warn on lid conversions for
 OPA
Date: Tue, 3 Oct 2017 09:24:48 +0300
Message-ID: <20171003062448.GB13648@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180446.31117.56786.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9zSXsLTf0vkW971A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171002180446.31117.56786.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--9zSXsLTf0vkW971A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 02, 2017 at 11:04:48AM -0700, Dennis Dalessandro wrote:
> From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> On OPA devices the user_mad recv_handler can receive 32Bit LIDs
> (e.g. OPA_PERMISSIVE_LID) and it is okay to lose the upper 16 bits
> of the LID as this information is obtained elsewhere. Do not issue
> a warning when calling ib_lid_be16() in this case by masking out
> the upper 16Bits.
>
> [75667.310846] ------------[ cut here ]------------
> [75667.316447] WARNING: CPU: 0 PID: 1718 at ./include/rdma/ib_verbs.h:3799 recv_handler+0x15a/0x170 [ib_umad]
> [75667.327640] Modules linked in: ib_ipoib hfi1(E) rdmavt(E) rdma_ucm(E) ib_ucm(E) rdma_cm(E) ib_cm(E) iw_cm(E) ib_umad(E) ib_uverbs(E) ib_core(E) libiscsi scsi_transport_iscsi dm_mirror dm_region_hash dm_log dm_mod dax x86_pkg_temp_thermal intel_powerclamp coretemp kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel mei_me ipmi_si iTCO_wdt iTCO_vendor_support crypto_simd ipmi_devintf pcspkr mei sg i2c_i801 glue_helper lpc_ich shpchp ioatdma mfd_core wmi ipmi_msghandler cryptd acpi_power_meter acpi_pad nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb ptp ahci libahci pps_core crc32c_intel libata dca i2c_algo_bit i2c_core [last unloaded: ib_core]
> [75667.407704] CPU: 0 PID: 1718 Comm: kworker/0:1H Tainted: G        W I E   4.13.0-rc7+ #1
> [75667.417310] Hardware name: Intel Corporation S2600WT2/S2600WT2, BIOS SE5C610.86B.01.01.0008.021120151325 02/11/2015
> [75667.429555] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [75667.436360] task: ffff88084a718000 task.stack: ffffc9000a424000
> [75667.443549] RIP: 0010:recv_handler+0x15a/0x170 [ib_umad]
> [75667.450090] RSP: 0018:ffffc9000a427ce8 EFLAGS: 00010286
> [75667.456508] RAX: 00000000ffffffff RBX: ffff88085159ce80 RCX: 0000000000000000
> [75667.465094] RDX: ffff88085a47b068 RSI: 0000000000000000 RDI: ffff88085159cf00
> [75667.473668] RBP: ffffc9000a427d38 R08: 000000000001efc0 R09: ffff88085159ce80
> [75667.482228] R10: ffff88085f007480 R11: ffff88084acf20e8 R12: ffff88085a47b020
> [75667.490824] R13: ffff881056842e10 R14: ffff881056840200 R15: ffff88104c8d0800
> [75667.499390] FS:  0000000000000000(0000) GS:ffff88085f400000(0000) knlGS:0000000000000000
> [75667.509028] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [75667.516080] CR2: 00007f9e4b3d9000 CR3: 0000000001c09000 CR4: 00000000001406f0
> [75667.524664] Call Trace:
> [75667.528044]  ? find_mad_agent+0x7c/0x1b0 [ib_core]
> [75667.534031]  ? ib_mark_mad_done+0x73/0xa0 [ib_core]
> [75667.540142]  ib_mad_recv_done+0x423/0x9b0 [ib_core]
> [75667.546215]  __ib_process_cq+0x5d/0xb0 [ib_core]
> [75667.552007]  ib_cq_poll_work+0x20/0x60 [ib_core]
> [75667.557766]  process_one_work+0x149/0x360
> [75667.562844]  worker_thread+0x4d/0x3c0
> [75667.567529]  kthread+0x109/0x140
> [75667.571713]  ? rescuer_thread+0x380/0x380
> [75667.576775]  ? kthread_park+0x60/0x60
> [75667.581447]  ret_from_fork+0x25/0x30
> [75667.586014] Code: 43 4a 0f b6 45 c6 88 43 4b 48 8b 45 b0 48 89 43 4c 48 8b 45 b8 48 89 43 54 8b 45 c0 0f c8 89 43 5c e9 79 ff ff ff e8 16 4e fa e0 <0f> ff e9 42 ff ff ff 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00
> [75667.608323] ---[ end trace cf26df27c9597264 ]---
>
> Fixes: 62ede7779904 ("Add OPA extended LID support")
> Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/core/user_mad.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--9zSXsLTf0vkW971A
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTLTAACgkQ5GN7iDZy
WKdn5A//aWCbI3UOnw4VhgGIy8r+hJXi9o6elXwrv3OqRPYFPg3N4LKQoJ6n1osh
x7vLpY4axZcleMKbQknLlSpMzOis+bQOUbM5yEHeWoAlBSAO2qqAS3OmlJeFRpPl
v0bT5pXuW0pze2AMb2EL5F30ylghFzKOOaTrPGfZ7ZqqknGMeq7Mm55fJx+bpEp5
wiLvjNuMWdmkSvoVWgIHJOgZelMeW4J66zx3jnIJkaNPEdLD/MnisSfN3duJoBG7
qP06mGVYFMTZ7mwkjsaP/pMOAjnDMnHQWRDEJ89XD6yLGyBv3p3VVCYVTPbIDf+3
RegtrJIBP/tY7P66ytf1iBgfRUP3J0PMChYkYAre3mTRuRcEPqSZ4kWGas49mPLE
3LShWMfMLXtiZ9lQPcXQRYQl2PoRxOgFAULN7Dxt1Mb+PxG3fSwPWbla0zfs97wo
2EGwLRKJlsyB74L6MlhLXe3zoCWzqOuXJ26c3qvOFyLEiVmuw9C7jeMn08tjj4Nz
6q+jSQZbhkZQr7vJnjoqBR89tn/Qs0viCQgQlkZxRmTnOQxs0Sv4udvVNgmKR+s0
ev8t5euTXUEsE7VgqVD8ihWmADIYvRzdvU3LVd9tM5dt8WyAT1bX3YbXHxJ4gfT3
6fZ+0tPeA+yr8Q04CQxpYh14AOdwssN6K89Zgyct6C4dF+6IE8E=
=2Sg/
-----END PGP SIGNATURE-----

--9zSXsLTf0vkW971A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
