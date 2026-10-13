Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A114EFFDF
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891976; cv=none; b=UiNcguifzGFqMndH0R/wWV13kJrfM1bxFFAVzpIpHWEMiH6+ttbgjkiMXrEIN5MHdW6MzhlJQ99MLKLuR90YYZbSIa+KBMt01hzjRCfuScQPYjizv6oeIk/8goJ3W090Oue05WZUVvBp8a08A35AS0zs4AL21VykiU1s28a8o5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891976; c=relaxed/simple;
	bh=65oOXRKEkocaA8dOchZqwMcC+RgUscgRd9boP1VvMYs=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=m8E3QIKXPlackDK3MavnYjaiBJWt0HfDYKLOACZJVcFZzjJlYh7Y+7rKF0BrfTeXqjSUat+fZShnYchm2YQLJ1bvRP26PnZmgL/nV5VYl0kHIUi89/jaK2DxJqmMRWvcDnrIAup+nZEvwd1YSh8cY40r8Ag4p5uCIMQJj/w4XL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLjw8zFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLjw8zFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C87C1F00899;
	Tue, 13 Oct 2026 11:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891974;
	bh=t84gkbhe77sTJPIyFCNrGGvdaO5kKZk2HA7/KACJDio=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FLjw8zFQ2C7cGWomDCo62IZgQYcNEN0n5MLfNLruij373OoXdcGr0Gu/pjP2F6dZu
	 eLemTk29u/tj7vTh0fE8bW430qUV1Ag3AhMiM7H8ZAvzh9UkISMFEmpYQnW66+ha6f
	 PNQ0blhPDuDv3ZozGOvRhxo1cPbbHxsKAFXiq0HMqyRmfjcdLbRo15EjmCgPVZDfjD
	 JuQnJilpq8LkUYCSb2zDOJrKg8y01Wetm2YJ5u6ZWHWTXb0TIgEqfuOkj7duLhIgXZ
	 HQt4sORtDhPkCIEQTRqwu2kAMc/nJ+mRVWetHu1Jk4A1GgnEzm3awvM6pdQH99l01t
	 I8OZHhqv7R7jA==
Message-ID: <sashiko-outbox-169650@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/15] yunsilicon: add the register HAL
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114354.2471317-3-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114354.2471317-3-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:13 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] net: xsc_get_db_addr returns hardcoded physical address instea=
d of PCI BAR
- [High] net: global state corruption via shared static xsc_hw_reg structur=
es
- [High] net: endianness breakage from C bitfields mapped to hardware descr=
iptors
- [High] net: hardcoded 0xf clear of W1C interrupt register causes interrup=
t storm
- [High] net: silent fallback to 1GB page size for unhandled page shifts
- [Medium] net: uninitialized stack padding leaked to hardware doorbell MMI=
O registers
- [Medium] net: stale in_line bit retained in recycled DMA data segments
- [Medium] net: integer overflow in xsc_get_max_mr_size on 32-bit architect=
ures
--

commit ab5e7ef7c47a715df12f926749f1e49fe112c55d
Author: Xin Tian <tianx@yunsilicon.com>
yunsilicon: add the register HAL

This commit adds the register access layer and per-device register map for
doorbells, interrupts, and command queues. The implementation provides
register offsets and configurations for the Andes device.

diff --git a/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c b/dri=
vers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
new file mode 100644
index 0000000000000..46fc045f92c02
--- /dev/null
+++ b/drivers/net/ethernet/yunsilicon/xsc/pci/hal/andes_impl.c
@@ -0,0 +1,708 @@
[ ... ]
> +static void andes_ring_rx_doorbell(struct xsc_hw_reg *regs,
> +				   void __iomem *bar, u32 rqn, u32 next_pid)
> +{
> +	union xsc_recv_doorbell {
> +		struct{
> +			u32  next_pid : 13;
> +			u32 qp_id : 15;
> +		};
> +		u32 raw;
> +	} db;
> +
> +	db.next_pid =3D next_pid;
> +	db.qp_id =3D rqn;
> +
> +	/* Make sure that descriptors are written before
> +	 * updating doorbell record and ringing the doorbell
> +	 */
> +	wmb();
> +
> +	writel(db.raw, REG_ADDR(bar, regs->rx_db));

[Severity: Medium]
Does this leak uninitialized kernel stack memory to the hardware? The union
instantiated on the stack is not fully zero-initialized before its raw 32-b=
it
value is written to MMIO, leaving padding bits uninitialized.

[ ... ]
> +static void andes_set_eq_ci(struct xsc_hw_reg *regs,
> +			    void __iomem *bar, u32 eqn, u32 next_cid,
> +			    u8 arm)
> +{
> +	union andes_eq_doorbell {
> +		struct{
> +			u32 eq_next_cid : 11;
> +			u32 eq_id : 11;
> +			u32 arm : 1;
> +		};
> +		u32 val;
> +	} db;
> +
> +	db.eq_next_cid =3D next_cid;
> +	db.eq_id =3D eqn;
> +	db.arm =3D !!arm;
> +
> +	/* make sure val write to memory done */
> +	wmb();
> +	writel(db.val, REG_ADDR(bar, regs->event_db));

[Severity: Medium]
Could this leak uninitialized stack memory to the event doorbell register,
similar to the rx doorbell above?

[ ... ]
> +static u8 andes_get_mr_page_mode(u8 page_shift)
> +{
> +enum {
> +	XSC_PAGE_SHIFT_4K	=3D 12,
> +	XSC_PAGE_SHIFT_64K	=3D 16,
> +	XSC_PAGE_SHIFT_2M	=3D 21,
> +	XSC_PAGE_SHIFT_1G	=3D 30,
> +};
> +
> +enum {
> +	XSC_PAGE_MODE_4K	=3D 0,
> +	XSC_PAGE_MODE_64K	=3D 1,
> +	XSC_PAGE_MODE_2M	=3D 2,
> +	XSC_PAGE_MODE_1G	=3D 3,
> +};
> +
> +	return (page_shift =3D=3D XSC_PAGE_SHIFT_4K ? XSC_PAGE_MODE_4K :
> +		(page_shift =3D=3D XSC_PAGE_SHIFT_64K ? XSC_PAGE_MODE_64K :
> +		(page_shift =3D=3D XSC_PAGE_SHIFT_2M ? XSC_PAGE_MODE_2M : XSC_PAGE_MOD=
E_1G)));

[Severity: High]
Does this silently fall back to XSC_PAGE_MODE_1G for unhandled page shifts
(such as 8K or 16K)? Could this cause out-of-bounds DMA accesses if the
hardware incorrectly maps 8K/16K buffers as 1GB pages?

[ ... ]
> +struct andes_cqe {
> +	union {
> +		u8		msg_opcode;
> +		struct {
> +			u8		error_code:7;
> +			u8		is_error:1;
> +		};
> +	};
> +	__le32		qp_id:15;
> +	u8		rsv1:1;
> +	u8		se:1;
> +	u8		has_pph:1;
> +	u8		type:1;
> +	u8		with_immdt:1;
> +	u8		csum_err:4;
> +	__le32		imm_data;
> +	__le32		msg_len;
> +	__le32		vni;
> +	__le64		ts:48;
> +	__le16		wqe_id;
> +	__le16		rsv[3];
> +	__le16		rsv2:15;
> +	u8		owner:1;
> +};
> +
> +static int andes_get_cqe_wqe_id(void *cqe)
> +{
> +	return ((struct andes_cqe *)cqe)->wqe_id;

[Severity: High]
Does mapping C bitfields directly to hardware descriptors break on big-endi=
an
systems? The compiler layout of bitfields is implementation-defined, which
frequently results in reversed bit packing.

Also, shouldn't le16_to_cpu() be used here when returning the __le16 wqe_id
as a native integer to avoid returning out-of-bounds indices on big-endian
architectures?

[ ... ]
> +static void andes_set_data_seg(void *data_seg, u32 length, u32 key, u64 =
addr)
> +{
> +	struct andes_data_seg *seg =3D data_seg;
> +
> +	seg->length =3D length;
> +	seg->key =3D key;
> +	seg->addr =3D addr;

[Severity: Medium]
If a data segment descriptor is recycled from a ring buffer, does failing to
explicitly clear the in_line bitfield here cause the hardware to misinterpr=
et
the address and key as inline data?

[ ... ]
> +struct andes_send_wqe_ctrl_seg {
> +	__le32		msg_opcode:8;
> +	__le32		with_immdt:1;
> +	__le32		csum_en:2;
> +	__le32		ds_data_num:5;
> +	__le32		wqe_id:16;
> +	__le32		msg_len;
[ ... ]
> +static void andes_set_wqe_id(void *cseg, u32 wqe_id)
> +{
> +	u16 _wqe_id =3D wqe_id;
> +
> +	((struct andes_send_wqe_ctrl_seg *)cseg)->wqe_id =3D cpu_to_le16(_wqe_i=
d);

[Severity: High]
Is it safe to assign an explicitly byte-swapped value directly to a bitfiel=
d?
This could doubly corrupt the data on big-endian systems.

[ ... ]
> +static struct xsc_hw_reg andes_pf_regs =3D {
> +	.req_pid_addr =3D HIF_CMDQM_HOST_REQ_PID_MEM_ADDR - 0xa0000000,
> +	.req_cid_addr =3D HIF_CMDQM_HOST_REQ_CID_MEM_ADDR - 0xa0000000,
[ ... ]
> +static struct xsc_hw_reg andes_compressed_regs =3D {
> +	.tx_db =3D TX_DB_FUNC_MEM_ADDR,
> +	.rx_db =3D RX_DB_FUNC_MEM_ADDR,
[ ... ]
> +void xsc_init_hal(struct xsc_core_device *xdev, u32 device_id)
> +{
> +	switch (device_id) {
> +	case XSC_MC_VF_DEV_ID:
> +	case XSC_MF_HOST_VF_DEV_ID:
> +	case XSC_MS_VF_DEV_ID:
> +	case XSC_MV_HOST_VF_DEV_ID:
> +		/* VFs expose the same BAR-relative window as a bar-compressed PF */
> +		xdev->hal_regs =3D &andes_compressed_regs;
> +		break;
> +	default:
> +		if (is_pf_bar_compressed(xdev))
> +			xdev->hal_regs =3D &andes_compressed_regs;
> +		else
> +			xdev->hal_regs =3D &andes_pf_regs;

[Severity: High]
Could multiple devices probed at the same time overwrite each other's hardw=
are
capability offsets? It appears xdev->hal_regs is assigned to a globally sha=
red
static structure rather than allocating a separate configuration per-device.

[ ... ]
> +void xsc_set_mtt_info(struct xsc_core_device *xdev)
> +{
> +	struct xsc_hw_reg *regs =3D xdev->hal_regs;
> +
> +	regs->mpt_tbl_addr =3D xdev->caps.mpt_tbl_addr - 0xa0000000;
> +	regs->mpt_tbl_depth =3D xdev->caps.mpt_tbl_depth;
> +	regs->mpt_tbl_width =3D xdev->caps.mpt_tbl_width;
> +	regs->mtt_inst_base_addr =3D xdev->caps.mtt_inst_base_addr - 0xa0000000;

[Severity: High]
Does this mutate the global shared static structure assigned during
xsc_init_hal() with device-specific values?

[ ... ]
> +void xsc_get_db_addr(struct xsc_core_device *xdev,
> +		     u64 *tx_db, u64 *rx_db, u64 *cq_db, u64 *cq_reg, u64 *eq_db)
> +{
> +	struct xsc_hw_reg *regs =3D xdev->hal_regs;
> +
> +	if (!xsc_core_is_pf(xdev) || is_pf_bar_compressed(xdev)) {
[ ... ]
> +	} else {
> +		if (tx_db)
> +			*tx_db =3D regs->tx_db + 0xa0000000;
> +		if (rx_db)
> +			*rx_db =3D regs->rx_db + 0xa0000000;
> +		if (cq_db)
> +			*cq_db =3D regs->complete_db + 0xa0000000;
> +		if (cq_reg)
> +			*cq_reg =3D regs->complete_reg + 0xa0000000;
> +		if (eq_db)
> +			*eq_db =3D regs->event_db + 0xa0000000;
> +	}

[Severity: Critical]
Does adding a hardcoded offset of 0xa0000000 to the doorbell register offse=
ts
yield a valid physical address? PCI device BAR physical addresses are typic=
ally
dynamically assigned and should be retrieved via pci_resource_start().
Returning a hardcoded physical address to upper layers could map arbitrary
physical memory.

[ ... ]
> +int xsc_handle_cmdq_interrupt(struct xsc_core_device *xdev)
> +{
> +	union interrupt_stat {
> +		struct {
> +			u32	hw_read_req_err:1;
> +			u32	hw_write_req_err:1;
> +			u32	req_pid_err:1;
> +			u32	rsp_cid_err:1;
> +		};
> +		u32	raw;
> +	} stat;
> +
> +	int err =3D 0;
> +	int retry =3D 0;
> +
> +	xsc_read32(xdev->bar, xdev->hal_regs->interrupt_stat_addr, &stat.raw,
> +		   sizeof(stat.raw));
> +	while (stat.raw !=3D 0) {
> +		err++;
> +		if (stat.hw_read_req_err) {
[ ... ]
> +		} else {
> +			stat.raw =3D 0;
> +			pci_err(xdev->pdev, "ignore unknown interrupt!\n");
> +		}
> +	}
> +
> +	if (retry) {
> +		if (xdev->cmd.retry_cnt >=3D XSC_CMD_MAX_RETRY_CNT) {
> +			pci_warn(xdev->pdev, "err handler have retried for %d times, stop ret=
ry\n",
> +				 xdev->cmd.retry_cnt);
> +			goto clear_err_int;
> +		}
> +		xsc_write32(xdev->bar, xdev->hal_regs->req_pid_addr,
> +			    &xdev->cmd.cmd_pid);
> +		xdev->cmd.retry_cnt++;
> +	}
> +
> +clear_err_int:
> +	if (err) {
> +		stat.raw =3D 0xf;
> +		xsc_write32(xdev->bar, xdev->hal_regs->interrupt_stat_addr, &stat.raw);

[Severity: High]
Will writing a hardcoded 0xf back to the hardware W1C register cause an
interrupt storm if a higher-order bit (e.g., bit 4) was asserted, since the
unknown bit would never be cleared?

Also, could unconditionally writing 1s to bits 0-3 clear new legitimate
interrupts that arrived after the initial read?

[ ... ]
> +u64 xsc_get_max_mr_size(struct xsc_core_device *xdev)
> +{
> +	u64 max_mpt_mr_size =3D xdev->caps.max_mr_size;
> +	u64 max_mtt_mr_size =3D xdev->caps.max_mtt * PAGE_SIZE;

[Severity: Medium]
Can this calculation overflow on 32-bit architectures where PAGE_SIZE is an
unsigned long? Both operands to the multiplication are 32-bit integers befo=
re
the assignment to the 64-bit result, which could truncate the capacity befo=
re
the type conversion happens.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D2
