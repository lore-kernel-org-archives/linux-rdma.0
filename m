Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414C14F391F
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 11:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891973; cv=none; b=WgfMLqHF7bFEuddJmqaDMgdL9n223VMJIwKMg/8EV5gzCSnuG/GktpD6iKB/rtMOmf3VG+/6ieALzGt9KXxGSx5DxHukE+PZxVI+9ncfuDMoP3I10RP9dyPHJ3Kgvmrza7xwmejkka3BWjJApvaxexpQbX3WoCJ4dP/wVtvamms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891973; c=relaxed/simple;
	bh=pj51lxhh9851NWRpgQ3wm99bsi15F94RkbaZBAv7+tw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lZeYcfjjN0reVaJxOBSShHlIjgUasQILTCL4wctdrC1EJgR2OP0ymKiHt+sQEBZaqrreHY4Kvz+ntR9Ug2oohEtk/ngH7MZxpFu2tLDm58wFU8uev6JijaSZy0l2AaW617Tr3/byiGudt+Vo3BI8WsUFjM+0wfIlqnm12ratzG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d45zwWSl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d45zwWSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0963D1F000FF;
	Tue, 13 Oct 2026 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891972;
	bh=pj51lxhh9851NWRpgQ3wm99bsi15F94RkbaZBAv7+tw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d45zwWSlsNlQ/uj8v73rhn1oeeUbWYFtXIIvA2g4pJRdLKPu5AvLGCxtO0kn7O3Vv
	 aHHAhBG9bqqdMqwGOgmfhrPbHg2YbzXBO7bOIWYteNpg0qYVh7/0wZuuktEYOzgxfj
	 w+CzWTfqR0H+FIVtlyWI9p3FgGZDAL3lTzOvwaR+9EdgcR6mQJDLxjaFwbMA+HQh0V
	 mFnfnlrNc3vMq9MviTL0eB2JX4ZZIXAzvpRnXCVrAAXVxF/tedec7tqCrTgHL6T/F2
	 rPgidsGGqV0zQyOGtDqBCFTM+KznFXQ0soA8IFRnVAiAS2+AB0X1NSdXeGj+r/MSSj
	 b1S+VxcoI6iYA==
Message-ID: <sashiko-outbox-169646@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/15] yunsilicon: add PCI core driver skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261012114352.2471317-2-tianx@yunsilicon.com>
References: <20261012114352.2471317-1-tianx@yunsilicon.com>
 <20261012114352.2471317-2-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 13 Oct 2026 11:46:11 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [High] mm: invalid kfree() on memory allocated with kvzalloc_obj()
- [High] hw: endian-dependent C bitfields in hardware descriptors corrupt d=
ata
- [High] hw: native host-endian types used in hardware DMA structures
- [High] hw: implicit compiler padding corrupts hardware command layouts
- [Medium] pci: missing dma_set_mask() forces 32-bit streaming DMA fallback
--

commit 2f6b2de0263e58c06ddcb030ee0e72ee0f685f39
Author: Xin Tian <tianx@yunsilicon.com>
Subject: yunsilicon: add PCI core driver skeleton

This commit adds the basic PCI core driver for the Yunsilicon XSC network
device. It includes Kconfig, Makefiles, register definitions, and basic PCI
probe/remove routines that enable the device and allocate the per-function
resource structure.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/pci/main.c, inside xsc_dev_res_init()
around line 105, xdev->dev_res is allocated using kvzalloc_obj(). However,
in xsc_dev_res_cleanup() at line 118, the memory is freed using kfree()
instead of kvfree(). Does this code potentially cause a kernel panic or SLUB
corruption during driver unbind or probe failure? If kvmalloc() falls back =
to
a vmalloc address because physically contiguous memory is unavailable, call=
ing
kfree() on it violates the allocator API.

[Severity: Medium]
In drivers/net/ethernet/yunsilicon/xsc/pci/main.c within xsc_set_dma_caps()
at line 22, the code configures a 64-bit mask for coherent allocations via
dma_set_coherent_mask(), but omits dma_set_mask() for the streaming DMA mas=
k.
Is the streaming DMA mask intentionally left at the 32-bit default? By not
setting it, all network packet buffers mapped via dma_map_single() or
dma_map_page() will be restricted to the lower 4GB of physical RAM. On 64-b=
it
systems with more than 4GB of RAM, this forces the networking stack to boun=
ce
all network traffic through the SWIOTLB, which can cause massive performance
degradation and potential silent allocation failures if the SWIOTLB is
exhausted.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/common/xsc_core.h (for xsc_cqe at li=
ne
242, and xsc_send_wqe_ctrl_seg at line 99) and xsc_cmdq.h (for
xsc_cmd_layout at line 113), hardware descriptors mapped to device DMA memo=
ry
define C bitfields using types like __le32 and u8. Will these hardware
descriptor layouts break on big-endian architectures? The C standard dictat=
es
that bitfield packing order is implementation-defined. On little-endian
systems, GCC packs bits from LSB to MSB, but on big-endian systems, from MSB
to LSB. Furthermore, mixing types like u8 and __le32 in bitfields causes
compiler-dependent alignment padding that bloats structural sizes. Compiling
this driver on a big-endian system might result in malformed commands and
silent data corruption. Fixed-size types with bitwise masks should likely be
used instead.

[Severity: High]
In drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h, several structures
passed to or read from the hardware via DMA or mailbox commands define fiel=
ds
using native host types. For example, xsc_cq_context_ex uses u32 pa_num_ex
at line 196, xsc_event_linkinfo uses u32 and u64 for linkspeed and supported
at line 863, and xsc_hw_stats_rdma_pf uses u64 for statistics at line 927.
Can this cause data corruption on big-endian hosts? Hardware devices operate
with a fixed endianness, and using native host types will cause the CPU on
big-endian hosts to read or write the bytes without swapping them, producing
incorrect values. All fields in DMA-shared structures typically need explic=
it
__le32/__le64 or __be32/__be64 types.

[Severity: High]
Also in drivers/net/ethernet/yunsilicon/xsc/common/xsc_cmd.h, missing packed
attributes or explicit manual padding creates implicit holes in hardware
command and configuration structures. For instance, in struct xsc_hca_cap,
__be64 flags requires 8-byte alignment but follows u8 rsvd16[2], resulting =
in
6 bytes of implicit padding. In struct xsc_create_qp_request at line 313,
__be64 pas[] forces 4 bytes of padding after u8 rsvd. In struct xsc_rss_attr
at line 782, __be32 hash_tmpl forces 2 bytes of padding after __be16 rqn_nu=
m.
Does this implicit compiler padding misalign the hardware command layouts?
This padding shifts all subsequent fields transmitted to and from the
hardware, potentially corrupting the mailbox commands and breaking the ABI
contract with the firmware.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012114352.2471=
317-1-tianx@yunsilicon.com?part=3D1
