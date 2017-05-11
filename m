From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/IPoIB: Replace netdev_priv with ipoib_priv for
 ipoib_get_link_ksettings
Date: Thu, 11 May 2017 15:40:20 +0300
Message-ID: <20170511124020.GH3616@mtr-leonro.local>
References: <1494504868-17204-1-git-send-email-honli@redhat.com>
 <20170511123109.GC18962@yuval-lap>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="D6IIOQQv2Iwyp54J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170511123109.GC18962@yuval-lap>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Honggang LI <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--D6IIOQQv2Iwyp54J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 11, 2017 at 03:31:10PM +0300, Yuval Shaia wrote:
> On Thu, May 11, 2017 at 08:14:28PM +0800, Honggang LI wrote:
> > From: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> > ipoib_dev_init accesses the private data for IPoIB net_device with
> > ipoib_priv. ipoib_get_link_ksettings should do as ipoib_dev_init.
> > Otherwise kernel panic.
> >
> > [   27.271938] IPv6: ADDRCONF(NETDEV_CHANGE): mlx5_ib0.8006: link becomes ready
> > [   28.156790] BUG: unable to handle kernel NULL pointer dereference at 000000000000067c
> > [   28.166309] IP: ib_query_port+0x30/0x180 [ib_core]
> > [   28.172364] PGD 0
> > [   28.172364] P4D 0
> > [   28.175307]
> > [   28.180595] Oops: 0000 [#1] SMP
> > [   28.184802] Modules linked in: bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx5_ib ib_core intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc aesni_intel ipmi_ssif crypto_simd glue_helper cryptd iTCO_wdt ipmi_si iTCO_vendor_support wmi pcspkr ipmi_devintf dcdbas ipmi_msghandler lpc_ich sg mei_me mei shpchp acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm mlx5_core drm tg3 devlink ahci
  libahci ptp libata
> > [   28.270227]  crc32c_intel i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
> > [   28.279674] CPU: 0 PID: 1766 Comm: libvirtd Not tainted 4.11.0.56868a4.20170510+ #1
> > [   28.289242] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
> > [   28.298628] task: ffff8b4777311680 task.stack: ffffb9ab0f7ac000
> > [   28.306282] RIP: 0010:ib_query_port+0x30/0x180 [ib_core]
> > [   28.313249] RSP: 0018:ffffb9ab0f7afbb0 EFLAGS: 00010246
> > [   28.320128] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> > [   28.329169] RDX: ffffb9ab0f7afc00 RSI: 0000000000000000 RDI: 0000000000000000
> > [   28.338202] RBP: ffffb9ab0f7afbf0 R08: 0000000000000000 R09: 0000000000000000
> > [   28.347246] R10: 0000000000001000 R11: 0000000000000000 R12: 0000000000000000
> > [   28.356284] R13: ffffb9ab0f7afc00 R14: ffffb9ab0f7afef0 R15: ffff8b377eae9b80
> > [   28.365316] FS:  00007f9aed612700(0000) GS:ffff8b377f800000(0000) knlGS:0000000000000000
> > [   28.375431] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [   28.383724] CR2: 000000000000067c CR3: 000000202aa7c000 CR4: 00000000001406f0
> > [   28.393337] Call Trace:
> > [   28.397594]  ipoib_get_link_ksettings+0x66/0xe0 [ib_ipoib]
> > [   28.405274]  __ethtool_get_link_ksettings+0xa0/0x1c0
> > [   28.412353]  speed_show+0x74/0xa0
> > [   28.417503]  dev_attr_show+0x20/0x50
> > [   28.422922]  ? mutex_lock+0x12/0x40
> > [   28.428179]  sysfs_kf_seq_show+0xbf/0x1a0
> > [   28.434002]  kernfs_seq_show+0x21/0x30
> > [   28.439470]  seq_read+0x116/0x3b0
> > [   28.444445]  ? do_filp_open+0xa5/0x100
> > [   28.449774]  kernfs_fop_read+0xff/0x180
> > [   28.455220]  __vfs_read+0x37/0x150
> > [   28.460167]  ? security_file_permission+0x9d/0xc0
> > [   28.466560]  vfs_read+0x8c/0x130
> > [   28.471318]  SyS_read+0x55/0xc0
> > [   28.475950]  do_syscall_64+0x67/0x150
> > [   28.481163]  entry_SYSCALL64_slow_path+0x25/0x25
> > [   28.487425] RIP: 0033:0x7f9b1bf4a70d
> > [   28.492522] RSP: 002b:00007f9aed611a40 EFLAGS: 00000293 ORIG_RAX: 0000000000000000
> > [   28.502097] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f9b1bf4a70d
> > [   28.511178] RDX: 0000000000000401 RSI: 00007f9ae8183650 RDI: 0000000000000017
> > [   28.520261] RBP: 0000000000000401 R08: 0000000000000080 R09: 0000000000002001
> > [   28.529322] R10: 000000000000006b R11: 0000000000000293 R12: 00007f9ae8183650
> > [   28.538368] R13: 0000000000000000 R14: 0000000000000017 R15: 0000000000002001
> > [   28.547432] Code: 55 48 89 e5 41 55 49 89 d5 41 54 44 0f b6 e6 53 48 89 fb 48 83 e4 f0 48 83 ec 20 65 48 8b 04 25 28 00 00 00 48 89 44 24 18 31 c0 <f6> 87 7c 06 00 00 01 75 2d 45 85 e4 0f 85 ca 00 00 00 b8 ea ff
> > [   28.570861] RIP: ib_query_port+0x30/0x180 [ib_core] RSP: ffffb9ab0f7afbb0
> > [   28.579601] CR2: 000000000000067c
> > [   28.584493] ---[ end trace 3549968a4bf0aa5d ]---
> >
> > Fixes:  0d7e2d2166f6 ('IB/ipoib: add get_link_ksettings in ethtool')
> >
> > Signed-off-by: Honggang Li <honli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/infiniband/ulp/ipoib/ipoib_ethtool.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> > index 874b243..7871379 100644
> > --- a/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> > +++ b/drivers/infiniband/ulp/ipoib/ipoib_ethtool.c
> > @@ -178,7 +178,7 @@ static inline int ib_speed_enum_to_int(int speed)
> >  static int ipoib_get_link_ksettings(struct net_device *netdev,
> >  				    struct ethtool_link_ksettings *cmd)
> >  {
> > -	struct ipoib_dev_priv *priv = netdev_priv(netdev);
> > +	struct ipoib_dev_priv *priv = ipoib_priv(netdev);
> >  	struct ib_port_attr attr;
> >  	int ret, speed, width;
> >
>
> Suggesting to remove kernel oops from commit log message, fix is trivial.

Please don't, they are useful.

>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--D6IIOQQv2Iwyp54J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkUW7QACgkQ5GN7iDZy
WKdCMg//Rec9yTepIJpphL76PERTLqkxMoaDJkDM0NuSbz7mvLV0PX9JPm1JOoxA
RVe1Y6kM4Q/eK/OCvLTUgzauFEZqBptb86PWRavxVg2cHdKxaQ/xSFPTmETzIcnR
uYDiJoWV8t0oxF9EAogbNtRcgKkK33zm1CM0Esqd++kmykLpbOn7ydL63atddx0l
y5EWcjtVAaCzyqeCNNbGYDGPi+YRwOGxOG/e+qEtue1YIfqEAQ2MDPCGtpyABAHq
pACbWLK5cHFGkWs1mGHQQDSKi4dMnQCbLLD1Fwt62+Uutm1JueDnI9xC5GnmuvMJ
dTwa8dQKdnBLIx9Qtd3mWRFtHS9mJ090jDHxuBAajbrZyESBAMHSzJh/Xuo2NTGE
XtkQzxYdSe4FEpB/LaSoLg+3Ruv/KAECGjOAg8iVmKk49bj5ynB0b96oaWpmHuSk
utjHAjoE1Qp45IZ1o9w+JsyhedEX8ZOGsgOBsIxv6KKv3Z4p9yc1Rva+cIsCzhtK
WaBOuHLJ6AGGC/fCzTd5ulM3Knp0p+Br9EPv+iM0DdrAhKZauKO213qqGcALltZo
T2rUOoNdql4B6a7vzR51pWiVA5y+W+lnDNmgcs/zokpgrAwi7Z7nbks43DQ+WeRa
CGWBGUP1plLnEdb7rhOo9S+q4gm1tM7WKer7D3yhit6bk+sfq8A=
=qQhN
-----END PGP SIGNATURE-----

--D6IIOQQv2Iwyp54J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
