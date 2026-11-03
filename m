Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711959;
	b=TTJhwuGOsbg+G6+Z/M01V4SltNVMvNPzeY4w1mnxVyJA2rkaebkrFUcFF1gCyX7eoL+/
	 txlkhB+RNP4pK8uiURLSZleyiCFN/dtsSV6NYFG4UN9QyjwHjq0cjEMmQjU1nBXTq8zeH
	 20R/lN07Mdh99KBVXiH18WdMoXiG7VnAjH0lArspVR8xHq4LcrV9RiZmB9ndwMT6wAQ1n
	 I2rd/RMQaD3ufxItsFb70CBMYQSUdl2lg+1nDML2LSyylP9Al7RbzVy9Pv59Hkah1VJJs
	 ScSCbyyVFzcN5hN9qM9t8wVIGxkjVhYzJMCdz1Znc4SSbfeJLQBKdTQvigvHM/PTk/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711959;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kGHvf9IIEYUp3OjflwFh6P1yneKQPccJmYbaodl2X80=;
	b=IcH00uL+G4o9jcxFEFWlRkTTb67ikm7P5ooQcS05ScGEqNl2Y6Ze8uT1b35/uklS3hTG
	 9W64dqzGCaI1E2NvwGjM6sUkZH3Kk68+Xo5o7U1CFItWLaXs17LCI4fYml3Tt/jAl6aMt
	 TZ1SesLKxHTotdqtC2BxFU5f4plunoBum9m3hxUbUq2yJr3q0ndW+q8mwNNkCfSy82Qbo
	 sSoFc4IgXcdfADSnmiokF712fOxSOEgIjYIQWguZHK5YOr/UDB8znSXrogTfqemmkfwgn
	 VN1dswyu0JE/1YN91WW8dAhOv2BOuMPY9h+RVeCXKdxbiA46JNci4gaDtRsmt9h1m7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oo1PKHL3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F27C606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Oo1PKHL3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF431F00919;
	Tue,  3 Nov 2026 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711959;
	bh=kGHvf9IIEYUp3OjflwFh6P1yneKQPccJmYbaodl2X80=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Oo1PKHL3OtVFQMJHgqS9XqRapSQXHCN/t30n/UhMlnW74XXkHXqsgk6n8gNX5+8nz
	 H9gK0sGREKNZLMoqY+aMBxxvz0xm7qEi++ythkI5K4u2vD8Ft2s2Kaf+GVk8tc8Oy4
	 6yEGw0VHwesbFDszoob/6Uf+hpKvqQTTWKvXFFtScsMk/aqDZPuRRWmApg/d3UqCiq
	 sUm/V53l+xOtsjfTIaEV6oizLiogkHJZ4tu68aulzlxEgsuZL7+6kENk/5NA6nRcaw
	 P2Sc6EVHqMK7aWZI38ukt2vvDzTebyBrfLv89Z94ISOWJdbVSbJ8NbGjK/sGh9iT1a
	 GccayvuoRjE5A==
Message-ID: <sashiko-outbox-195322@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 2/7] RDMA/zrdma: Add core data structures and
 ABI definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-3-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-3-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:19:18 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] RDMA/zrdma: private untyped auxiliary device contract in zrdma_t=
ype.h
--

commit 32205a1a2a82a76eef58bea731ed3f41780dc2c9
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add core data structures and ABI definitions

This commit adds core data structures, hardware control structures, and
user-space ABI definitions for the ZTE DingHai RDMA driver.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_type.h b/drivers/infiniban=
d/hw/zrdma/zrdma_type.h
> new file mode 100644
> index 0000000000000..ded4052453455
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_type.h
> @@ -0,0 +1,86 @@
[ ... ]
> +struct zxdh_rdma_core_dev;
> +
> +struct zxdh_rdma_core_ops {
> +	int (*request_reset)(struct zxdh_rdma_core_dev *cdev,
> +			     enum zxdh_rdma_reset_type reset_type);
> +	int (*zxdh_common_func)(void *in_param, void *out_param, u32 opcode);
> +};
[ ... ]
> +struct zxdh_rdma_core_dev {
> +	struct pci_dev *pdev;
> +	struct auxiliary_device *adev;
> +	u8 __iomem *hw_addr;
> +	int zdev_info_id;
> +	struct zxdh_rdma_ver_info ver;
> +	void *auxiliary_priv;
> +	enum zxdh_function_type ftype;
> +	u16 vport_id;
> +	u16 slot_id;
> +	enum zxdh_rdma_protocol rdma_protocol;
> +
> +	struct zxdh_qos_params qos_info;
> +	struct msix_entry *msix_entries;
> +	u16 msix_count;
> +	const struct zxdh_rdma_core_ops *ops;
> +	void *dh_dev;
> +};
> +
> +struct zxdh_rdma_if {
> +	void *(*get_rdma_netdev)(void *dh_dev);
> +};
> +
> +struct zxdh_auxiliary_dev {
> +	struct auxiliary_device adev;
> +	struct zxdh_rdma_core_dev *zxdh_info;
> +	struct zxdh_rdma_if *rdma_ops;
> +	void *ops;
> +	void *parent;
> +	s32 aux_id;
> +	void *auxiliary_ops[18];
> +};

[Severity: Medium]
As reported by Sashiko on v8 [1], defining the cross-driver auxiliary bus
structures (struct zxdh_auxiliary_dev, struct zxdh_rdma_core_dev, struct
zxdh_rdma_core_ops, and struct zxdh_rdma_if) in the driver-private header
drivers/infiniband/hw/zrdma/zrdma_type.h with untyped void * placeholder
fields bypasses compiler type and struct-layout verification between the
parent PCI PF driver and the RDMA auxiliary driver.

In commit 019e9ef26336 ("RDMA/zrdma: Add device probe and remove logic"),
zxdh_probe() binds to the dinghai10e.rdma_aux auxiliary device, converts
struct auxiliary_device *aux_dev via container_of(aux_dev, struct
zxdh_auxiliary_dev, adev) using this private definition, and invokes
zxdh_adev->rdma_ops->get_rdma_netdev(zxdh_adev->parent) and
zxdh_adev->zxdh_info->ops->zxdh_common_func(). Additionally, commit
41373c3ba84c ("RDMA/zrdma: Add internal headers and hardware register
definitions") notes that the struct layout must manually match the PF driver
definition, while the in-tree Ethernet driver under
drivers/net/ethernet/zte/dinghai/ does not define or register this auxiliary
device.

As documented in include/linux/auxiliary_bus.h, the container structure
embedding struct auxiliary_device and any shared interface structures must =
be
defined in a shared header under include/linux/ included by both the
registering PF driver and the consuming auxiliary driver. If the parent PF
driver and zrdma ever diverge in struct layout or callback signatures, could
container_of() or the untyped void * callbacks in zxdh_probe() corrupt memo=
ry
or call invalid function pointers?

Should these shared structures be moved to a common header under
include/linux/ with proper types (such as struct net_device * for
get_rdma_netdev() and typed parameters instead of void *ops, void *parent,
void *auxiliary_ops[18], void *dh_dev, and zxdh_common_func()), alongside t=
he
corresponding auxiliary device registration in the in-tree parent driver?

[1] https://lore.kernel.org/r/20261102082026.2645777-3-zhang.yanze@zte.com.=
cn

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D2
