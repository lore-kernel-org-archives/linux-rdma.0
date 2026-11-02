Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793610043;
	b=hn/noqeABTNDF2byEvaAK4Gxp98mpbf2VTezO4Ikjgw41ezAnmmCTbJb78VsZRcinD3a
	 tuoTkdQuUc0lET6gHWkejlWCRt8XURMq400Qw2XibBzwe/cKk/mUv8KiwmGvpPzI8jOH1
	 jokTzNEXcx97HoBjkJGxWpCd6uMjrerb2sVZy9VtbInL9m9C/9yFtwGJJTkTujkXQiKl/
	 P23VCQ5Oz3xE1gAtdLK2uvwx2O6Fiwd/AK3nSYFZP/w0PehVoUrhdyxu9yjhDEvTXwHXc
	 PgxZWx0vEuoFJm1nkzC0Jhzi5GE9dsLmUlyEDf0NRa+mARQLZ2RB0AiCYq0but4x+iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793610043;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=gGLnaTRpx0YwHYJcyA+n88jpWelqhxWitk2gcx7TvnI=;
	b=j1FETOAHFg6/4LE5gQzMsEfz7C/hpA+PQa24ND938vwKY8/K5Qf7LBEJPPejxOghXPGi
	 YOYbUqaMdXSD6JReI/IPQZKckONk2WT3k9KLlT4mM9SXsiLQijbun9SQUaezt2RKePG9n
	 hNLgmLHQz8znaInWrvmaRXHVIsag20M7C8KdfN5SySOo6YJZkUPqIvzBqNwWFAxoVP8CM
	 Z/fh2tR2rH1XRDfgRhb3dXdW14URo7rqJmD/Oc8RWeG09qWOc2E8PWhikvI6ivOkLCUz7
	 XHT4CpNUoejI43mvvL/s38CgYz3+UT2kc7gsZh2uW+Lhj6D+mIS0I/YC1BxYJtUGb8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nyi4xlS3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0D6606A327
	for <linux-rdma@vger.kernel.org>; Mon,  2 Nov 2026 09:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nyi4xlS3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3461F000C1;
	Mon,  2 Nov 2026 09:00:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793610042;
	bh=gGLnaTRpx0YwHYJcyA+n88jpWelqhxWitk2gcx7TvnI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nyi4xlS37ApiyKgkdzkcuyk86AY4IjiSAZoxLrNxxFBl7A5CVyaS5xlYYT3MN9By1
	 p7Up0kTMx2EaNpo7u1KUkUXu0NdEHZ+0YZA2imqKwJkI2E8Vzyn+xTtMWzYTrixQe3
	 oxpXJebJ0MFFShgbUoeN5+wetY5YaeA91HnGJMCRIk016Vs3tecZa6pNFTst1k0oZS
	 MLG9r2dI5Ndj6UKNDehe5T8nnGeWrWSsVDLWLWK26XgP9gA04Y/y+w97r//sQ5+4si
	 sW4o1IYdd7q0OXW6R6ZXEtDxYzO8teL4dDRePGUUKm9RAsl2QBr7ijUaf9EVuSRyln
	 KKxLqK4RPWHuw==
Message-ID: <sashiko-outbox-193147@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v8 3/7] RDMA/zrdma: Add internal headers and
 hardware register definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261102082026.2645777-4-zhang.yanze@zte.com.cn>
References: <20261102082026.2645777-1-zhang.yanze@zte.com.cn>
 <20261102082026.2645777-4-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 09:00:42 +0000
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
- [Low] RDMA/zrdma: unused declarations and intra-series churn in zrdma_mai=
n.h
--

commit a9658ee0b0f7725e37243f230a2652c3cd0f13de
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add internal headers and hardware register definitions

This commit adds internal header files (zrdma_hw.h and zrdma_main.h) and
updates zrdma_type.h to define structures, enums, and constants for the ZTE
DingHai RDMA driver.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_main.h b/drivers/infiniban=
d/hw/zrdma/zrdma_main.h
> new file mode 100644
> index 0000000000000..31679b4eccb2c
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
[ ... ]
> +#define PCI_SBDF_SAFE_LEN 64
> +#define ZXDH_RST_TIMEOUT_HZ 4
> +
> +#define ZXDH_RDMA_COMMON_FUNC_CAP 1
> +#define ZXDH_RDMA_COMM_FUNC BIT_ULL(24)
> +
> +extern struct list_head zxdh_handlers;
> +extern spinlock_t zxdh_handler_lock;
> +extern const struct ib_device_ops zxdh_dev_ops;
> +
> +struct zxdh_pci_f;
> +
> +struct zxdh_rdma_node {
> +	char name[IB_DEVICE_NAME_MAX];
> +	char sbdf[PCI_SBDF_SAFE_LEN];
> +	struct list_head list;
> +};
> +
> +enum zxdh_func_type {
> +	ZXDH_FUNC_NUM_REQUIRE =3D 0,
> +	ZXDH_FUNC_NP_MAC =3D 1,
> +	ZXDH_FUNC_IRQ_REQUEST =3D 2,
> +	ZXDH_FUNC_IRQ_FREE =3D 3,
> +	ZXDH_FUNC_PMTU_INFO_ADD =3D 4,
> +	ZXDH_FUNC_PMTU_INFO_DEL =3D 5,
> +	ZXDH_FUNC_QP_INFO_DEL_WX =3D 6,
> +	ZXDH_FUNC_NETDEV_SPEED_GET =3D 7,
> +	ZXDH_FUNC_SEARCH_MAC_FROM_FW =3D 8,
> +	ZXDH_COMM_FUNC_GET_TRUST_TYPE =3D 9,
> +	ZXDH_FUNC_VF_VLAN_GET =3D 10,
> +	ZXDH_FUNC_NUM_MAX,
> +};
> +
> +enum init_completion_state {
> +	INVALID_STATE =3D 0,
> +	INITIAL_STATE,
> +	CQP_CREATED,
> +	SMMU_PAGETABLE_INITIALIZED,
> +	DATA_CAP_CREATED,
> +	HMC_OBJS_CREATED,
> +	HW_RSRC_INITIALIZED,
> +	CQP_QP_CREATED,
> +	AEQ_CREATED,
> +	CCQ_CREATED,
> +	CEQ0_CREATED,
> +	CEQS_CREATED,
> +	PBLE_CHUNK_MEM,
> +};
> +
> +enum zxdh_rdma_vers {
> +	ZXDH_GEN_RSVD,
> +	ZXDH_GEN_1,
> +	ZXDH_GEN_2,
> +};
> +
> +struct zxdh_handler {
> +	struct list_head list;
> +	struct zxdh_device *zdev;
> +};
[ ... ]
> +struct zxdh_pci_f {
[ ... ]
> +	spinlock_t rsrc_lock; /* protects resource allocation arrays */
> +	spinlock_t qptable_lock; /* protects qp_table access */
> +	spinlock_t cqtable_lock; /* protects cq_table access */
> +	struct zxdh_qp **qp_table;
> +	struct zxdh_cq **cq_table;
> +	spinlock_t srqtable_lock; /* protects srq_table access */
> +	struct zxdh_srq **srq_table;
> +
> +	struct msix_entry *msix_entries;
> +	struct zxdh_gen_ops gen_ops;
> +	struct zxdh_device *zdev;
> +	u16 qp_index;
> +	u32 srq_mem_size;
> +	bool net_irq_cap;
> +	int common_func_num_max;
> +	void *dh_dev;
> +};
> +
> +struct zxdh_device {
> +	struct ib_device ibdev;
> +	struct zxdh_pci_f *rf;
> +	struct net_device *netdev;
> +	struct net_device *source_netdev;
> +	struct zxdh_handler *hdl;
[ ... ]
> +int zxdh_get_del_rdma_name(const char *sbdf, char *name, size_t name_len=
);
> +int zxdh_ctrl_init_hw(struct zxdh_pci_f *rf);
> +int zxdh_ib_register_device(struct zxdh_device *zdev);
> +void zxdh_del_handler(struct zxdh_handler *hdl);

[Severity: Low]
As reported by Leon Romanovsky on v2 [1], unused defines and functions
should be removed from the driver and the patches should be split cleanly to
simplify review.

This patch adds PCI_SBDF_SAFE_LEN, zxdh_handlers, zxdh_handler_lock,
struct zxdh_rdma_node, struct zxdh_handler, struct zxdh_device::hdl,
zxdh_get_del_rdma_name(), and zxdh_del_handler() in
drivers/infiniband/hw/zrdma/zrdma_main.h, which are never defined or used
and are then deleted in the subsequent patch "RDMA/zrdma: Add device probe
and remove logic".

In addition, even at the end of the series ("RDMA/zrdma: Implement context,
PD, and mmap operations"), zrdma_main.h still contains declarations that are
never used anywhere in the series:
- srq_mem_size in struct zxdh_pci_f and source_netdev in struct zxdh_device
  are never read or written.
- struct zxdh_qp, struct zxdh_cq, and struct zxdh_srq are never defined, and
  their corresponding tables in struct zxdh_pci_f are allocated but never
  populated or read.
- CQP_CREATED through PBLE_CHUNK_MEM in enum init_completion_state, along
  with unused values in enum zxdh_func_type and enum zxdh_rdma_vers, are
  never referenced.

Could these unused declarations and the intra-series churn be dropped from
zrdma_main.h?

[1] https://lore.kernel.org/r/20260705112915.GB15188@unreal

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102082026.2645=
777-1-zhang.yanze@zte.com.cn?part=3D3
