Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792827918;
	b=d+KLSMQ5JZFr6VZH8jPUKIwvLFX0YiCve2zB6MoorrL6HETB80eacndBpGOp1i+4fHhc
	 ZPd1fJSdyEM0hqa5gl8M7xQ5MuWcENewYEV7XrVleUdi8j+bmOAX0ftlMVAfkiQF5w+Po
	 nER8ssGrKYJYSf5n00otL+7a/3Koa8Zai5dIFzvSC56HheJ3WznzG9IJaygWU971wugRW
	 BILwLPw6ITQ5ohd4SzrFoFHEGxTlVWhNTiQH3o8ZOTWjXMg6DHGafD/yrvLq/KfF2PqKR
	 hISOep/QNyIQxTAC1Z4Ry9YT9LJY2KTnvahwy7QBA2JfJHbX9An3+OCwShVpFI0QaHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792827918;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=RhrvXuEClZvjXg21FyvhESDVsTV+NlHhDVf3EbETNW4=;
	b=lfQzIfcxd2F9Qf4+70jx62UkDG9ERBJIc9LmZAa3qjNUlImaY4ebPwHNNkFVNTGPFcEN
	 WWo7hxo/dTWWZloOvpoVZLXcL9C8fueI8e4m8EUhk1JaBwuOd/WQw7FqF9Lrhwc0HloAX
	 yTEBxb2syiVS2B6gTgKBdQmVe1jvbOicJCkKoupMLTVUuwciUifm9kOFZe92GvE/Ymtj0
	 CYv7Zw+sDK5DTH0APj7zhg2zvPgnKkKMzMPtGzDjXk3bgm775qejml2Vl1Uu3pBcBhdNr
	 aiDMUv4xZCNtUOnyICsvSsEhZv67pfP4zYlUqPcAkxbAgZfFV9j47STxYaaK9CwvWyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="kYnYMf6/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B79C606A31E
	for <linux-rdma@vger.kernel.org>; Sat, 24 Oct 2026 07:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYnYMf6/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095B51F01825;
	Sat, 24 Oct 2026 07:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792827917;
	bh=RhrvXuEClZvjXg21FyvhESDVsTV+NlHhDVf3EbETNW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYnYMf6/Ezvf/7Vpn5sL43IWoFi1a165QPBnEMoAoNR7HnJvCh+FweEkqGd1Tjeq6
	 Lev+RjbR6my+DcOiQiZFmZ6t5I2EYXFpxn09pWLh3yzfEvmu2OljH0fals0Lo0KHnp
	 eiCtcfPIbS8yGON2O6A1lpOcnx8+JDq46ONI3hOU3567pG7rBBd/d6EQB9sfqpKEsU
	 PwavDwHKTMNR1TnPpY/11+De+8VQpQiXMWcDaxs7fnw1u3MmgkC5pt5JshOGZ/1RAu
	 BCaZ0/kX0i2U29452SYcqYV7H9U6s/h252THHCfo11HdGRs7ui9v957l6NKPef0WTv
	 N1h4eDkWOPPqg==
Message-ID: <sashiko-outbox-183592@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/7] RDMA/zrdma: Implement device and port query
 operations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261024071539.2182864-8-zhang.yanze@zte.com.cn>
References: <20261024071539.2182864-1-zhang.yanze@zte.com.cn>
 <20261024071539.2182864-8-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 07:45:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 7 potential issue(=
s) to consider:
- [High] RDMA/zrdma: NULL pointer dereference of udata in zxdh_query_device=
()
- [Medium] RDMA/zrdma: missing max_send_sge and max_recv_sge in zxdh_query_=
device()
- [Medium] RDMA/zrdma: broken rtnl_trylock() fallback in zxdh_get_drvinfo()
- [Medium] RDMA/zrdma: flawed speed query and caching in zxdh_get_eth_netde=
v_speed()
- [Medium] RDMA/zrdma: zxdh_get_dev_fw_str() overwrites N/A fallback on par=
se failure
- [Medium] RDMA/zrdma: memory leak on probe error paths due to late ib_set_=
device_ops()
- [Low] RDMA/zrdma: dead zxdh_query_gid_roce() callback and misplaced build=
 fixes
--

commit 5562e1f8054bd9cdd1fa5be99a78d65f32fb0baf
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Implement device and port query operations

This commit implements RDMA device and port query callbacks, including devi=
ce
attributes, port attributes, GID/PKey queries, link layer reporting, firmwa=
re
version extraction, and device registration setup.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.h b/drivers/infiniban=
d/hw/zrdma/zrdma_main.h
> index 060d6f627b0dd..62e52e5a23ee3 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_main.h
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
> @@ -208,7 +208,7 @@ static inline void zxdh_free_rsrc(struct zxdh_pci_f *=
rf,
>  	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
>  }
> =20
> -int zxdh_get_del_rdma_name(const char *sbdf, char *name);
> +int zxdh_get_del_rdma_name(const char *sbdf, char *name, size_t name_len=
);
>  int zxdh_ctrl_init_hw(struct zxdh_pci_f *rf);
>  int zxdh_ib_register_device(struct zxdh_device *zdev);
>  void zxdh_del_handler(struct zxdh_handler *hdl);
> diff --git a/drivers/infiniband/hw/zrdma/zrdma_verbs.c b/drivers/infiniba=
nd/hw/zrdma/zrdma_verbs.c
> index 54b016ea8f5de..a16e00e785353 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_verbs.c
> +++ b/drivers/infiniband/hw/zrdma/zrdma_verbs.c

[ ... ]

> @@ -157,7 +159,7 @@ static int zxdh_alloc_ucontext(struct ib_ucontext *uc=
tx, struct ib_udata *udata)
>  	ucontext->zdev =3D zdev;
>  	ucontext->abi_ver =3D req.userspace_ver;
> =20
> -	uresp.srq_db_bar_off =3D SRQ_DB_OFFSET;
> +	uresp.srq_db_bar_off =3D SRQ_DB_BAR_OFF & ZXDH_PAGE_OFFSET_NUM;
> =20
>  	ucontext->sq_db_mmap_entry =3D
>  		zxdh_user_mmap_entry_insert(ucontext, SQ_DB_BAR_OFF,
> @@ -332,29 +334,327 @@ static int zxdh_mmap(struct ib_ucontext *context, =
struct vm_area_struct *vma)
>  	return ret;
>  }
> =20
> -static void zxdh_init_roce_device(struct zxdh_device *zdev)
> +/* Fetch the driver info for @zdev->netdev, or for its first lower device
> + * when it is a bond. adj_list.lower is rtnl_lock protected, but the core
> + * may call this from a netdev notifier already holding rtnl_lock.
> + */
> +static bool zxdh_get_drvinfo(struct zxdh_device *zdev,
> +			     struct ethtool_drvinfo *info)
>  {
> -	zdev->ibdev.node_type =3D RDMA_NODE_IB_CA;
> -	addrconf_addr_eui48((u8 *)&zdev->ibdev.node_guid,
> -			    zdev->netdev->dev_addr);
> +	struct net_device *slave =3D NULL, *dev;
> +	struct list_head *iter;
> +	bool locked =3D false;
> +	bool ret =3D false;
> +
> +	memset(info, 0, sizeof(*info));
> +
> +	if ((zdev->netdev->priv_flags & IFF_BONDING) && rtnl_trylock()) {
> +		netdev_for_each_lower_dev(zdev->netdev, slave, iter)
> +			break;
> +		locked =3D true;
> +	}
> +
> +	dev =3D slave ? slave : zdev->netdev;
> +	if (dev->ethtool_ops && dev->ethtool_ops->get_drvinfo) {
> +		dev->ethtool_ops->get_drvinfo(dev, info);
> +		ret =3D true;
> +	}
> +
> +	if (locked)
> +		rtnl_unlock();
> +
> +	return ret;
>  }

[Severity: Medium]
What happens in zxdh_get_drvinfo() when zdev->netdev is a bonding device and
rtnl_lock is already held by the current thread or contended by another
thread?

Because rtnl_mutex is not recursive, rtnl_trylock() returns 0 even when the
caller already holds rtnl_lock. In that case, the lower device lookup is
skipped and slave remains NULL, so dev falls back to zdev->netdev (the
bonding master) instead of the lower hardware device.

Calling dev->ethtool_ops->get_drvinfo(dev, info) on the bonding master invo=
kes
bond_ethtool_get_drvinfo(), which fills info->fw_version with BOND_ABI_VERS=
ION
("2") and causes zxdh_get_drvinfo() to return true. When extract_version()
parses that string, it fails and outputs an empty string, resulting in
zxdh_query_device() setting props->fw_ver =3D 0 and zxdh_get_dev_fw_str()
overwriting "N/A" with "".

In addition, when zdev->netdev is not a bond or when rtnl_trylock() fails,
dev->ethtool_ops->get_drvinfo() is invoked without holding rtnl_lock or the
netdev ops lock.

> =20
> -static int zxdh_init_rdma_device(struct zxdh_device *zdev)
> +static void extract_version(const char *input, char *output)
>  {
> +	const char *v_start, *p;
> +	int dots =3D 0;
> +
> +	if (!output || !input)
> +		goto fail;
> +
> +	if (strstr(input, " (")) {
> +		v_start =3D input;
> +		for (p =3D v_start; *p && *p !=3D ' '; p++) {
> +			if (*p =3D=3D '.' && ++dots =3D=3D 4)
> +				break;
> +			*output++ =3D *p;
> +		}
> +	} else {
> +		/* Format: "E310-V25.30.103.01" - find 'V' after last '-' */
> +		const char *last_dash =3D strrchr(input, '-');
> +
> +		if (!last_dash)
> +			goto fail;
> +		v_start =3D strstr(last_dash, "V");
> +		if (!v_start)
> +			goto fail;
> +		v_start++;  /* skip 'V' */
> +
> +		for (p =3D v_start; *p && dots < 4; p++) {
> +			if (*p =3D=3D '.' && ++dots =3D=3D 4)
> +				break;
> +			*output++ =3D *p;
> +		}
> +	}
> +
> +fail:
> +	if (output)
> +		*output =3D '\0';
> +}
> +
> +static int zxdh_query_device(struct ib_device *ibdev,
> +			     struct ib_device_attr *props,
> +			     struct ib_udata *udata)
> +{
> +	struct zxdh_device *zdev =3D to_zdev(ibdev);
>  	struct pci_dev *pcidev =3D zdev->rf->pcidev;
> +	int major, sub_major, minor, sub_minor;
> +	struct ethtool_drvinfo info;
> +	char extracted_version[32];
> +
> +	if (zxdh_get_drvinfo(zdev, &info)) {
> +		extract_version(info.fw_version, extracted_version);
> +		if (sscanf(extracted_version, "%d.%d.%d.%d", &major,
> +			   &sub_major, &minor, &sub_minor) !=3D 4) {
> +			major =3D 0;
> +			sub_major =3D 0;
> +			minor =3D 0;
> +			sub_minor =3D 0;
> +		}
> +	} else {
> +		major =3D sub_major =3D minor =3D sub_minor =3D 0;
> +	}
> =20
> -	if (zdev->roce_mode)
> -		zxdh_init_roce_device(zdev);
> +	if (udata->inlen || udata->outlen)
> +		return -EINVAL;

[Severity: High]
Won't dereferencing udata without a NULL check in zxdh_query_device() cause=
 a
NULL pointer dereference during device registration?

When zxdh_ib_register_device() calls ib_register_device(), setup_device() in
drivers/infiniband/core/device.c queries the device attributes with udata s=
et
to NULL:

drivers/infiniband/core/device.c:setup_device() {
	...
	memset(&device->attrs, 0, sizeof(device->attrs));
	ret =3D device->ops.query_device(device, &device->attrs, NULL);
	...
}

Should this check for a non-NULL udata pointer first, for example
if (udata && (udata->inlen || udata->outlen))?

> +
> +	memset(props, 0, sizeof(*props));
> +	addrconf_addr_eui48((u8 *)&props->sys_image_guid,
> +			    zdev->netdev->dev_addr);
> +	props->fw_ver =3D ((u64)major << 48 | (u64)sub_major << 32 |
> +			 (u64)minor << 16 | sub_minor);
> +	props->device_cap_flags =3D
> +		IB_DEVICE_MEM_WINDOW | IB_DEVICE_MEM_MGT_EXTENSIONS |
> +		IB_DEVICE_BAD_QKEY_CNTR | IB_DEVICE_SYS_IMAGE_GUID |
> +		IB_DEVICE_RC_RNR_NAK_GEN | IB_DEVICE_N_NOTIFY_CQ;
> +	props->vendor_id =3D pcidev->vendor;
> +	props->vendor_part_id =3D pcidev->device;
> +	props->hw_ver =3D pcidev->revision;
> +	props->page_size_cap =3D SZ_4K | SZ_2M | SZ_1G;
> +	props->max_mr_size =3D MAX_MR_SIZE;
> +	props->max_qp =3D MAX_QP;
> +	props->max_qp_wr =3D MAX_QP_WR;
> +	props->max_cq =3D MAX_CQ;
> +	props->max_cqe =3D MAX_CQE;
> +	props->max_mr =3D MAX_MR;
> +	props->max_mw =3D MAX_MW;
> +	props->max_pd =3D MAX_PD;
> +	props->max_sge_rd =3D MAX_SGE_RD;

[Severity: Medium]
Should zxdh_query_device() also populate props->max_send_sge and
props->max_recv_sge here?

Because props is zeroed with memset() and neither field is assigned,
device->attrs.max_send_sge and device->attrs.max_recv_sge remain 0 after
setup_device() runs.

When userspace queries the device through ib_uverbs_query_device(),
copy_query_dev_fields() in drivers/infiniband/core/uverbs_cmd.c computes:

	resp->max_sge =3D min(attr->max_send_sge, attr->max_recv_sge);

which reports max_sge as 0 to userspace and leaves kernel ULPs seeing 0
supported SGEs in device->attrs.

[ ... ]

> +static u32 zxdh_get_eth_netdev_speed(struct zxdh_device *zdev, u32 port_=
num)
> +{
> +	struct ethtool_link_ksettings lksettings;
> +	u32 netdev_speed =3D (u32)SPEED_UNKNOWN;
> +	struct zxdh_pci_f *rf =3D zdev->rf;
> +	int rc;
> +
> +	if (rdma_port_get_link_layer(&zdev->ibdev, port_num) !=3D
> +	    IB_LINK_LAYER_ETHERNET)
> +		return -EINVAL;
> +
> +	if (zdev->netdev_speed !=3D (u32)SPEED_UNKNOWN)
> +		return zdev->netdev_speed;
> +
> +	if (rf->drv_np_cap =3D=3D ZXDH_RDMA_COMMON_FUNC_CAP &&
> +	    rf->common_func_num_max > ZXDH_FUNC_NETDEV_SPEED_GET) {
> +		rc =3D rf->gen_ops.zxdh_common_func(zdev->zxdh_adev->parent,
> +						  &netdev_speed,
> +						  ZXDH_FUNC_NETDEV_SPEED_GET);
> +
> +		if (rc || netdev_speed =3D=3D (u32)SPEED_UNKNOWN)
> +			netdev_speed =3D SPEED_1000;
> +		else
> +			zdev->netdev_speed =3D netdev_speed;
> +	} else {
> +		if (!rtnl_trylock())
> +			return SPEED_1000;
> +
> +		rc =3D __ethtool_get_link_ksettings(zdev->netdev, &lksettings);
> +		rtnl_unlock();
> +
> +		if (!rc &&
> +		    lksettings.base.speed !=3D (u32)SPEED_UNKNOWN) {
> +			netdev_speed =3D lksettings.base.speed;
> +			zdev->netdev_speed =3D netdev_speed;
> +		} else {
> +			netdev_speed =3D SPEED_1000;
> +		}
> +	}
> +
> +	return netdev_speed;
> +}
> +
> +static int zxdh_get_eth_speed(struct ib_device *dev, struct net_device *=
netdev,
> +			      u32 port_num, u16 *speed, u8 *width)
> +{
> +	struct zxdh_device *zdev =3D to_zdev(dev);
> +	u32 netdev_speed;
> +
> +	if (zdev)
> +		netdev_speed =3D zxdh_get_eth_netdev_speed(zdev, port_num);
>  	else
> -		return -EPFNOSUPPORT;
> +		netdev_speed =3D SPEED_1000;
> +
> +	if (netdev_speed <=3D SPEED_1000) {
> +		*width =3D IB_WIDTH_1X;
> +		*speed =3D IB_SPEED_SDR;
> +	} else if (netdev_speed <=3D SPEED_10000) {
> +		*width =3D IB_WIDTH_1X;
> +		*speed =3D IB_SPEED_FDR10;
> +	} else if (netdev_speed <=3D SPEED_20000) {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_DDR;
> +	} else if (netdev_speed <=3D SPEED_25000) {
> +		*width =3D IB_WIDTH_1X;
> +		*speed =3D IB_SPEED_EDR;
> +	} else if (netdev_speed <=3D SPEED_40000) {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_FDR10;
> +	} else if (netdev_speed <=3D SPEED_100000) {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_EDR;
> +	} else {
> +		*width =3D IB_WIDTH_4X;
> +		*speed =3D IB_SPEED_HDR;
> +	}
> =20
> -	zdev->ibdev.phys_port_cnt =3D 1;
> -	zdev->ibdev.num_comp_vectors =3D zdev->rf->ceqs_count;
> -	zdev->ibdev.dev.parent =3D &pcidev->dev;
> +	return 0;
> +}

[Severity: Medium]
Can zxdh_get_eth_netdev_speed() and zxdh_get_eth_speed() report stale or
bogus link speeds in zxdh_query_port()?

First, once zxdh_get_eth_netdev_speed() writes a speed into
zdev->netdev_speed, every subsequent call returns the cached
zdev->netdev_speed immediately. Nothing in the driver ever invalidates or
updates zdev->netdev_speed when the link speed changes, and concurrent reads
and writes to zdev->netdev_speed are unsynchronized.

Second, when querying via __ethtool_get_link_ksettings(), if rtnl_trylock()
fails because rtnl_mutex is held or contended while zdev->netdev_speed is
still SPEED_UNKNOWN, zxdh_get_eth_netdev_speed() returns a fabricated
SPEED_1000 (which maps to IB_WIDTH_1X and IB_SPEED_SDR).

Third, zxdh_get_eth_netdev_speed() returns u32, so returning -EINVAL conver=
ts
to 0xffffffea, which zxdh_get_eth_speed() treats as an unsigned speed great=
er
than SPEED_100000 and maps to IB_WIDTH_4X and IB_SPEED_HDR. Could
ib_get_eth_speed() be used instead, or the speed queried without permanent
caching and signed-to-unsigned conversion?

[ ... ]

> +static int zxdh_query_gid_roce(struct ib_device *ibdev, u32 port, int in=
dex,
> +			       union ib_gid *gid)
> +{
> +	int ret;
> +
> +	ret =3D rdma_query_gid(ibdev, port, index, gid);
> +	if (ret =3D=3D -EAGAIN) {
> +		memcpy(gid, &zgid, sizeof(*gid));
> +		return 0;
> +	}
> +
> +	return ret;
> +}

[Severity: Low]
Is zxdh_query_gid_roce() ever called by the RDMA core?

For RoCE ports, the RDMA core manages the GID cache via roce_gid_mgmt, and
ib_cache_update() in drivers/infiniband/core/cache.c only calls
device->ops.query_gid via config_non_roce_gid_cache() when
!rdma_protocol_roce(device, port). Even if invoked, rdma_query_gid() only
returns 0, -EINVAL, or -ENOENT, so the ret =3D=3D -EAGAIN branch cannot be
reached.

Also, the two changes earlier in this patch to the zxdh_get_del_rdma_name()
prototype in drivers/infiniband/hw/zrdma/zrdma_main.h and uresp.srq_db_bar_=
off
in zxdh_alloc_ucontext() appear to fix build errors introduced in earlier
commits in the series ("RDMA/zrdma: Add device probe and remove logic" and
"RDMA/zrdma: Implement context, PD, and mmap operations"). Should those fix=
es
be folded into the earlier commits to preserve bisectability?

[ ... ]

> +static void zxdh_get_dev_fw_str(struct ib_device *dev, char *str)
> +{
> +	struct zxdh_device *zdev =3D to_zdev(dev);
> +	struct ethtool_drvinfo info;
> +	char extracted_version[32];
> +
> +	strscpy(str, "N/A", IB_FW_VERSION_NAME_MAX);
> +
> +	if (!zxdh_get_drvinfo(zdev, &info))
> +		return;
> +
> +	extract_version(info.fw_version, extracted_version);
> +	strscpy(str, extracted_version, IB_FW_VERSION_NAME_MAX);
> +}

[Severity: Medium]
If extract_version() fails to match the version format in info.fw_version (=
for
example, when info.fw_version is empty or does not contain " (" or "-...V"),
it jumps to fail and sets extracted_version[0] =3D '\0'. Won't the uncondit=
ional
strscpy(str, extracted_version, IB_FW_VERSION_NAME_MAX) in
zxdh_get_dev_fw_str() overwrite the "N/A" fallback with an empty string?

Also, in zxdh_query_device(), major, sub_major, minor, and sub_minor are
parsed as signed int values with "%d.%d.%d.%d" and combined via:

	props->fw_ver =3D ((u64)major << 48 | (u64)sub_major << 32 |
			 (u64)minor << 16 | sub_minor);

Should extracted_version[0] be checked before overwriting str in
zxdh_get_dev_fw_str(), and should the version components in
zxdh_query_device() be parsed as unsigned 16-bit values (or masked to 0xfff=
f)
so negative or oversized values cannot corrupt upper bits of props->fw_ver?

[ ... ]

> +static int zxdh_init_rdma_device(struct zxdh_device *zdev)
> +{
> +	struct pci_dev *pcidev =3D zdev->rf->pcidev;
> +
> +	if (zdev->roce_mode)
> +		zxdh_init_roce_device(zdev);
> +	else
> +		return -EPFNOSUPPORT;
> +
> +	zdev->ibdev.phys_port_cnt =3D 1;
> +	zdev->ibdev.num_comp_vectors =3D zdev->rf->ceqs_count;
> +	zdev->ibdev.dev.parent =3D &pcidev->dev;
> +
> +	ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops);
> +
> +	return 0;
> +}

[Severity: Medium]
Does calling ib_set_device_ops(&zdev->ibdev, &zxdh_dev_ops) here at the end=
 of
zxdh_init_rdma_device() leak zdev->rf, zdev->hdl, rf->qp_cnt_8k_idxs, and
rf->mem_rsrc if an earlier error path is taken in zxdh_probe()?

In drivers/infiniband/hw/zrdma/zrdma_main.c:zxdh_probe(), after allocating
zdev with ib_alloc_device(), the driver allocates zdev->rf, initializes
zdev->ah_list_lock in zxdh_fill_device_info(), allocates zdev->hdl, and
allocates rf->qp_cnt_8k_idxs and rf->mem_rsrc in zxdh_ctrl_init_hw():

drivers/infiniband/hw/zrdma/zrdma_main.c:zxdh_probe() {
	...
	hdl =3D kzalloc_obj(*hdl);
	if (!hdl) {
		ib_dealloc_device(&zdev->ibdev);
		return -ENOMEM;
	}
	...
	err =3D zxdh_ctrl_init_hw(rf);
	if (err)
		goto err_ctrl_init;

	err =3D zxdh_ib_register_device(zdev);
	if (err)
		goto err_ib_reg;
	...
err_ib_reg:
err_ctrl_init:
	ib_dealloc_device(&zdev->ibdev);

	return err;
}

All of those failure paths (as well as the !zdev->roce_mode return path in
zxdh_init_rdma_device()) rely on ib_dealloc_device(&zdev->ibdev) invoking
zxdh_ib_dealloc_device() via zdev->ibdev.ops.dealloc_driver, which is Not s=
et
until ib_set_device_ops() runs. Should ib_set_device_ops() be called
immediately after ib_alloc_device() in zxdh_probe() (or at the start of dev=
ice
initialization) so dealloc_driver is always registered before any error path
calls ib_dealloc_device()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261024071539.2182=
864-1-zhang.yanze@zte.com.cn?part=3D7
