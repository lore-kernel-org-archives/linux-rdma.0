Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793609713;
	b=Ub3fU9eg7aNMHrBmlF0H29Dk0JhH/HNTDfUYtBeDaNIVbKoYfbgedvmXC1OdrrYPMMyE
	 kNyAcUVzc/ErTRgV52mZjgrXxewoPpvNw7JL/mjH+yIM/7FNc/TLYJmXQqSC0u416uwk+
	 tEiw6mFDBfO6gWQVP6IXa5AkFBrx9lyUqQePUzP8A9svJETCVHMFD5HS5mvBKNdt6qymn
	 yfl6C/RE/gmdiVJ3tuR+zYmBXm1xXCb4gpSyZ9kugaYFXjCyVLDpwyVXojPQOLTMEi7rG
	 qm09r7fECyM9DAuobAHab2z9Abn6/hU2qJpCFud1ogETGfP2033mmCYuLvWqOgA0mBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793609713;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=nssa5NPr2BP4A+uknfAVciu/0FccJaC44xNIsk5S368=;
	b=E8r2RWsjo+uJgR7zIUpzhckO/uwRQHvBPCKr154K9two4AEYwnhVCuCM5dznfIInuMYK
	 jXTTJDJ9hdnVxJrkU7u7waXV8Fg6DxNqZvyLXFLxFnrEtyv+x8bMjKkxfotUbmpzXpjtg
	 a8SyhPOZzmAttqeTOqdq0nywh+fat7BAf2pGrRDK4Jhe0ceNDReNQMoQEXxOGD1SOrPkt
	 qqBrD0+iuT14v8bVGWBxnDy6WtBFfpCWp6KTZc1KKqPkPvc4F7ubX0PWqOGdfQhuJ4qT/
	 u6CXgmeNtTQcVp4v8X86QBPUU/l1dXjS4ij5nxUsdy/CX9wBuLu3OqFBtTTbVnYGRsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9730606A333
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 08:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB251F00919;
	Mon,  2 Nov 2026 08:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793609707;
	bh=nssa5NPr2BP4A+uknfAVciu/0FccJaC44xNIsk5S368=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jtd4nUJ1//3yyArFGPbCzFbZqODDilbrV+UBQxbZtW9gsJr4qsSM1LHMLSpkHgT9E
	 3Bg6K7eN66t6GNbYFtpDz4aTa8LoPuYZn9eF4E6Zngu0L+c6h69Up5pxi3uCEgxEXf
	 5wuo22J3p9NkJml1eXrrN1YfrMW52rGIuZr13vUdO3ZN2XgZuRZhMVbCCaTebLS0Rb
	 vWb33KzeXEjNDyW7rnal5zyG8Bup3XozLSR4KB3qV7RbTiWd8SDZuVETXL9vaolGne
	 ADexnjSOuceyCVNs/0dR+Iq34PUmNc6OlpJio3Rf3K49fjj1PucBfW93MHXjUdgzPs
	 ySp8tsNb2IW0Q==
Message-ID: <sashiko-outbox-193142@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 2/7] RDMA/zrdma: Add core data structures and
 ABI definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-3-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-3-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 08:55:06 +0000
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

commit 8cc318d7731f01390658d794db981381eb4bcc2c
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add core data structures and ABI definitions

This commit adds core data structures, hardware control definitions, and the
userspace ABI header for the ZTE DingHai RDMA driver.

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
Should struct zxdh_auxiliary_dev, struct zxdh_rdma_core_dev,
struct zxdh_rdma_core_ops, and struct zxdh_rdma_if be defined with full
concrete types in a shared header under include/linux/ that both the parent
PCI PF driver and this RDMA auxiliary driver include, rather than in a
driver-private RDMA header?

In the subsequent patch "RDMA/zrdma: Add device probe and remove logic",
zxdh_probe() binds to the dinghai10e.rdma_aux auxiliary device, converts
struct auxiliary_device *aux_dev via container_of(aux_dev,
struct zxdh_auxiliary_dev, adev), and calls
zxdh_adev->rdma_ops->get_rdma_netdev(zxdh_adev->parent) and
zxdh_adev->zxdh_info->ops->zxdh_common_func().

Because drivers/infiniband/hw/zrdma/zrdma_type.h defines a private copy of
these structures padded with opaque placeholders such as void *ops,
void *parent, void *auxiliary_ops[18], void *dh_dev,
void *(*get_rdma_netdev)(void *dh_dev) (instead of returning
struct net_device *), and int (*zxdh_common_func)(void *in_param,
void *out_param, u32 opcode), the compiler cannot verify that the struct
layout or callback signatures match the parent PF driver. In addition, the
in-tree driver under drivers/net/ethernet/zte/dinghai/ does not appear to
define or register this auxiliary device yet.

Could this private definition cause memory corruption or invalid function
pointer calls during zxdh_probe() if the parent driver layout or signatures
diverge?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D2
