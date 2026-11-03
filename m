Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793711904;
	b=WYkqJ294Gnij6vYEsdJhTWJ7XwAeoPgnu8dN/Wtz26ioHQqP/WS4bOyqACjtQo77u9mw
	 jxpo6AIzospeVF0x0YYwmXA6ECeYjDo1WAhzz+t0y0fRGFSVEfJIMqbNLZjop/Dv26nnl
	 8zy59ZAEOQSon25WQvcBKSVL1RoGuHyoP7KfOOGwURElbg+aRU9B+ZcMBSG01EdZl0B0r
	 32jleP78e7X09AH0xCPtpRnyFU3+UFFiOyumMoM2Me2MF7xmI6FW5tWh0yHsN3b/6LK9M
	 JzHzlrw8qIC26Ao+Db5voXz16DVXnu2YJB55vOzWuwANFar84x/OWYGtn7d2YZ6MfMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793711904;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=M+8QB+YuJQscZ5e11Kfm7HKByeBile3uF5gBl/vc5As=;
	b=qcUzdYdAdG10icIUrWTEoaZOUlxCoq3KNv3NKM635GMCIv/IgVNBtZyeeyjI0q77WC86
	 nPCXEL07s7GUenh+0RLAFuFmqZhs/Y0hY7q+V01o4j7B/PT962Y5uLl6DGr789HN3UGk7
	 WrQFygxv/LjcPMbribBdvcNu2kLgoCNcciejmOYFXemExXQbfrVNy83y3Ktc/TMjD0EAH
	 B1LFrC5U1asUoNUWi60mijXeykyMgBCfNd7/OWHfIHpCcS2kGZtQByU1QFSULsSJ/vQMl
	 tBiUXEbn8fETkRtN/IMVjuv0zOY2wipPu+nPWUczPCrHiWaDZJeb8o5OEr9BNu+v95w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="d/cCONWE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7DB606D83B
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d/cCONWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D8E1F00919;
	Tue,  3 Nov 2026 13:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793711903;
	bh=M+8QB+YuJQscZ5e11Kfm7HKByeBile3uF5gBl/vc5As=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d/cCONWEp3RcSaJfvcmtMXmTFlF8Ba1MsW1IdN9wnXJM4+SOWFsT7bOYgGfSJwZh4
	 RKxsMoA+zaeR6KK8qzc7BRG8Nj3d9Z6h0mwuI5sLufT+pWk3oyY+u+9FANFbChRE+C
	 0w8LpTfyY7m8XK8hJ3LxjFih0Np9/gJ9PiYKHQ5fv6URo9OknrXitl0kbQrOIQMxs8
	 R9qt4PHIhc8lF7t6A5uJVfy+X3dxLEV64a4Q0+zaAxEhYLH56L3emWpSjKVPZjnHpy
	 LNoAm8DeG4h7RHE8jwLZ6kvIZ+fR/LxhjL/cmTwPWNNizZGFzZK3OhHXsZndp/P8Mo
	 JaOIQKBJYBoXw==
Message-ID: <sashiko-outbox-195319@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v9 3/7] RDMA/zrdma: Add internal headers and
 hardware register definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261103125654.2707069-4-zhang.yanze@zte.com.cn>
References: <20261103125654.2707069-1-zhang.yanze@zte.com.cn>
 <20261103125654.2707069-4-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 13:18:22 +0000
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
- [Medium] RDMA/zrdma: private duplication of PF driver auxiliary device st=
ructures
--

commit 41373c3ba84c37bb5af763979de45792b2597a0b
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add internal headers and hardware register definitions

This commit adds internal header files defining driver device structures,
resource allocation helpers, and hardware limits for the ZTE DingHai RDMA
driver.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.h b/drivers/infiniban=
d/hw/zrdma/zrdma_main.h
> new file mode 100644
> index 0000000000000..d65811735e74e
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
> @@ -0,0 +1,177 @@

[ ... ]

> +struct zxdh_pci_f {

[ ... ]

> +	struct zxdh_sc_dev sc_dev;
> +	struct pci_dev *pcidev;
> +	struct zxdh_rdma_core_dev *zdev_info;
> +	struct zxdh_hw hw;
> +
> +	spinlock_t rsrc_lock; /* protects resource allocation arrays */
> +
> +	struct msix_entry *msix_entries;
> +	struct zxdh_gen_ops gen_ops;
> +	struct zxdh_device *zdev;
> +	u16 qp_index;
> +	bool net_irq_cap;
> +	int common_func_num_max;
> +	void *dh_dev;
> +};
> +
> +struct zxdh_device {
> +	struct ib_device ibdev;
> +	struct zxdh_pci_f *rf;
> +	struct net_device *netdev;
> +	struct list_head ah_list;
> +	struct mutex ah_list_lock; /* protects ah_list operations */
> +	u8 ibdev_status;
> +	u8 roce_mode : 1;
> +	enum init_completion_state init_state;
> +	struct zxdh_auxiliary_dev *zxdh_adev;

[ ... ]

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_type.h b/drivers/infiniban=
d/hw/zrdma/zrdma_type.h
> index ded4052453455..c6ad2be17c159 100644
> --- a/drivers/infiniband/hw/zrdma/zrdma_type.h
> +++ b/drivers/infiniband/hw/zrdma/zrdma_type.h
> @@ -21,6 +21,12 @@ enum zxdh_function_type {
>  	ZXDH_FUNCTION_TYPE_VF,
>  };
> =20
> +/*
> + * The structures below describe the auxiliary device of the DingHai PF
> + * driver. Their layout has to match the definition of the PF driver
> + * exactly, because the probe path reads them through the auxiliary devi=
ce
> + * that the PF driver provides.
> + */
>  struct zxdh_rdma_core_dev;

[Severity: Medium]
Should the cross-driver auxiliary device structures (struct
zxdh_auxiliary_dev, struct zxdh_rdma_core_dev, struct zxdh_rdma_core_ops, a=
nd
struct zxdh_rdma_if) be defined in a shared header under include/linux/
rather than privately duplicated in drivers/infiniband/hw/zrdma/zrdma_type.h
and referenced by struct zxdh_pci_f (zdev_info) and struct zxdh_device
(zxdh_adev) in drivers/infiniband/hw/zrdma/zrdma_main.h?

In a subsequent patch in the series, zxdh_probe() in
drivers/infiniband/hw/zrdma/zrdma_main.c casts the auxiliary_device pointer
via container_of(aux_dev, struct zxdh_auxiliary_dev, adev) and dereferences
zxdh_adev->rdma_ops and zxdh_adev->zxdh_info.

However, the in-tree DingHai PF driver under drivers/net/ethernet/zte/dingh=
ai/
(en_pf.c, en_pf.h, dh_queue.h) does not define struct zxdh_auxiliary_dev or
struct zxdh_rdma_core_dev and does not register any auxiliary device. Relyi=
ng
on manual struct layout matching across subsystems with untyped void *
placeholders (such as ops, parent, auxiliary_ops[18], and dh_dev) risks type
confusion and memory corruption if either driver changes.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103125654.2707=
069-1-zhang.yanze@zte.com.cn?part=3D3
