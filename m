From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Seeing WARN_ON in ib_dealloc_pd from ipoib in kernel
 4.3-rc1-debug
Date: Wed, 7 Oct 2015 12:11:25 -0400
Message-ID: <5615442D.2020007@redhat.com>
References: <56153F71.2010801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KKrrloT3NJ677Pwq21OkNvuu4AVBJCJR8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56153F71.2010801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KKrrloT3NJ677Pwq21OkNvuu4AVBJCJR8
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/07/2015 11:51 AM, Sagi Grimberg wrote:
> This started popping up (not sure if it's new to 4.3-rc1).
>=20
> Happens when unloading the provider driver (mlx4/mlx5 in my case).
>=20
> Has anyone seen this?
>=20
> kernel: ------------[ cut here ]------------
> kernel: WARNING: CPU: 2 PID: 6012 at drivers/infiniband/core/verbs.c:28=
3
> ib_dealloc_pd+0x5b/0xa0 [ib_core]()
> kernel: Modules linked in: rpcrdma ib_srp scsi_transport_srp ib_iser
> rdma_cm iw_cm libiscsi scsi_transport_iscsi ib_umad ib_uverbs ib_ipoib
> ib_cm mlx4_ib ib_sa ib_mad mlx4_core mlx5_ib(-) mlx5_core ib_core
> ib_addr mst_pciconf(O) mst_pci(O) nfsv3 nfs af_packet coretemp
> x86_pkg_temp_thermal crct10dif_pclmul crc32c_intel aesni_intel
> aes_x86_64 glue_helper lrw gf128mul ablk_helper cryptd microcode
> ipmi_ssif pcspkr lpc_ich i2c_i801 mfd_core ioatdma wmi ipmi_si
> ipmi_msghandler processor button nfsd auth_rpcgss oid_registry nfs_acl
> lockd grace sunrpc ip_tables x_tables ext4 crc16 mbcache jbd2 sd_mod
> hid_generic usbhid hid ahci libahci libata igb ehci_pci hwmon ehci_hcd
> ptp usbcore pps_core scsi_mod i2c_algo_bit usb_common i2c_core dca
> autofs4 [last unloaded: mlx4_core]
> kernel: CPU: 2 PID: 6012 Comm: modprobe Tainted: G           O L
> 4.3.0-rc3-debug+ #67
> kernel: Hardware name: Supermicro SYS-1027R-WRF/X9DRW, BIOS 3.0a 08/08/=
2013
> kernel:  000000000000011b ffff8807a99afbe8 ffffffff8129915b
> 0000000000000009
> kernel:  0000000000000000 ffff8807a99afc28 ffffffff810752b5
> ffff880827d7c2a0
> kernel:  ffff8807b0d03260 ffff880827d7c2a0 ffff880827d7cc60
> 0000000000000000
> kernel: Call Trace:
> kernel:  [<ffffffff8129915b>] dump_stack+0x4f/0x74
> kernel:  [<ffffffff810752b5>] warn_slowpath_common+0x95/0xe0
> kernel:  [<ffffffff8107531a>] warn_slowpath_null+0x1a/0x20
> kernel:  [<ffffffffa001bd4b>] ib_dealloc_pd+0x5b/0xa0 [ib_core]
> kernel:  [<ffffffffa047adce>] ipoib_transport_dev_cleanup+0x9e/0xf0
> [ib_ipoib]
> kernel:  [<ffffffffa047712e>] ipoib_ib_dev_cleanup+0x5e/0x80 [ib_ipoib]=

> kernel:  [<ffffffffa0473984>] ipoib_dev_cleanup+0x2a4/0x3b0 [ib_ipoib]
> kernel:  [<ffffffff8107a11d>] ? __local_bh_enable_ip+0x6d/0xd0
> kernel:  [<ffffffffa0473a9e>] ipoib_uninit+0xe/0x10 [ib_ipoib]
> kernel:  [<ffffffff8141ba17>] rollback_registered_many+0x1a7/0x2c0
> kernel:  [<ffffffff8141bbd1>] rollback_registered+0x31/0x40
> kernel:  [<ffffffff8141bc38>] unregister_netdevice_queue+0x58/0xb0
> kernel:  [<ffffffff8141be00>] unregister_netdev+0x20/0x30
> kernel:  [<ffffffffa04721a1>] ipoib_remove_one+0xa1/0xe0 [ib_ipoib]
> kernel:  [<ffffffffa001e0d1>] ib_unregister_device+0xc1/0x160 [ib_core]=

> kernel:  [<ffffffffa05231f9>] mlx5_ib_remove+0x19/0x50 [mlx5_ib]
> kernel:  [<ffffffffa04e5068>] mlx5_remove_device+0x68/0x80 [mlx5_core]
> kernel:  [<ffffffffa04e50be>] mlx5_unregister_interface+0x3e/0x70
> [mlx5_core]
> kernel:  [<ffffffffa053397c>] mlx5_ib_cleanup+0x10/0x694 [mlx5_ib]
> kernel:  [<ffffffff810f67aa>] SyS_delete_module+0x17a/0x1c0
> kernel:  [<ffffffff81003017>] ? trace_hardirqs_on_thunk+0x17/0x19
> kernel:  [<ffffffff811e80b0>] ? generic_show_options+0x180/0x180
> kernel:  [<ffffffff8151a1f2>] entry_SYSCALL_64_fastpath+0x12/0x76
> kernel: ---[ end trace 31339c7283574ccb ]---

Yes.  I'm seeing this too.  The last time this popped up I fixed it by
adding the code for reaping ahs.  I suspect that the new code to timeout
sendonly multicast joins combined with us now creating and joining what
used to be sendonly groups is the likely culprit here.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--KKrrloT3NJ677Pwq21OkNvuu4AVBJCJR8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWFUQtAAoJELgmozMOVy/dmMQP/R24TADUG7KolZyfIeOqaI/9
HUgGjuHLJnTtJubwUXoMGc08oAn8VtrR/oebxszP7Z/G8aa72nnmsdJZq7rfAZ7r
ZSSIJhcOOe9G/G8DcLpUtPn7uCbcNUZH7Mx36rAL3jZ7m2C2Z+rh306L8EGo8gKU
/P4278Cg4b7ViglcWZjkR+wv6Q1hhEPB2SJG6UIawAMp4xcr3NSKZmLMRiDIlILG
xEIRy6zPil62JBfK7435AvVjbKNy92W9dDO7Uj/pVSIKE1RXhAQyhyGfWO5FepUf
QsQClJRmOAk24+iUUnUtBtBuHBz/aE3wGyc+UdzAFh3oaAOLjDEuFQyzVKio9xdf
DWkt/qlWG03gW/Ro9DjgT3tYwJ1SRHdB+wutc2enMEb4GXiWN1gf6PGLRdJVZyVw
8xPn+gmjHBXNZiujXjjPor7au82j5UONaY2JQKah0JHxZfksEXpaBPC1ck5V3sRW
pFaKVIXSd0Ob8O+NCf/1U9iPfIoW1csIJG86N398FanyObgyGOnZ+q0cIKswZRJ0
DleFTKMPb1emC3vaj2Ak+Js7qx++OzKgNTnACWAhn9EJThB/jEUihX/+G6g/+Twl
6Zdypxh9e4Ddgeo5Qw/fHNcqtH2I3EkJNcUEETOfl0JEvMITEQNACj2gFtxB48z3
Oaj7GuxDwZoTR2VegPfc
=L6wt
-----END PGP SIGNATURE-----

--KKrrloT3NJ677Pwq21OkNvuu4AVBJCJR8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
