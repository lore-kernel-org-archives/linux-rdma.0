Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B62CC2FFDEA;
	Mon, 27 Apr 2026 14:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777300873; cv=none; b=baXNCZU9ZOQ5/eC8VoarKHX20nzCalJgx4VHGtpcub9IvC/Y8FUgtesC4mEq0Iq2aKP6fX6XoOgHUZGMo/D1ovNt+pqDib1kVtrsa8mRkft7BFeVZ0rQeRIErkdw3wi1W3Yne+Au1Q6h+YzLybIBMN6fKKxm/p7TaRDDdo+dr0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777300873; c=relaxed/simple;
	bh=ioUDgHPMl7Xm1/uI6POTPcCuZqtDh6bmNp4MdAuzb5Q=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ReJbqatGXVmVKKQN73ZVC2YqbVrhVnpJkFJaAThJnGVkDCqjzwkJnX/2QC4X4+NK5rePwL+2mHVVt9qEQ4Lm+J+0/RF9kGFl+PDlsrtz/nfBbtH4tCE1qhli+pQrUGBjAh+dQmpFtGs6a85swk4rVvmMyJ6jBGdvEVPy98oqz9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=csTIdDLz; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="csTIdDLz"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id D742F20B716A; Mon, 27 Apr 2026 07:41:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D742F20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777300871;
	bh=1ydId8wXKijO3hYYEvou/zSy628grXYbkuTuuuh3SVU=;
	h=Date:From:To:Subject:From;
	b=csTIdDLzK18d/vry1oY7iqYPttyOaNtlf+ofN6xwSKHktch72FoDWco6ASeOLAJvM
	 DE7XNcltdOGwl+zlZRGlXkkqXDziwesS8EVhp5sqEWrTMLHFf7lgcJYnF4ruVrlutx
	 0i4AICDqEwBEOwSDyDj74qayDaGfbDBeBbWov/40=
Date: Mon, 27 Apr 2026 07:41:11 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	leon@kernel.org, longli@microsoft.com, kotaranov@microsoft.com,
	horms@kernel.org, shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com, ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, stephen@networkplumber.org,
	jacob.e.keller@intel.com, dipayanroy@microsoft.com,
	leitao@debian.org, kees@kernel.org, john.fastabend@gmail.com,
	hawk@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
	ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com
Subject: [RFC PATCH net-next] net: mana: Force single RX buffer per page
 under SWIOTLB bounce modes
Message-ID: <ae91hyrLf4n23XE6@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The MANA driver has two distinct DMA paths for RX buffers:

1. Without PP_FLAG_DMA_MAP: The driver maps full pages manually,
   creating page-aligned mappings where the DMA offset is always zero.

2. With PP_FLAG_DMA_MAP: page_pool uses sub-page fragments, where
   multiple RX buffers share a single page. The pool maps the whole
   page once, and subsequent allocations use offsets into that region.

Path 2 is problematic in two scenarios where DMA must go through
SWIOTLB bounce buffers:

- Confidential VMs (AMD SEV-SNP, Intel TDX): guest memory is encrypted
  and the NIC cannot access it directly due to lack of TDISP support.
  All DMA must use SWIOTLB bounce buffers.

- Force-bounce mode (swiotlb=force): all DMA is routed through bounce
  buffers regardless of whether the system is a CVM.

In both cases, sub-page RX buffer fragments allocated via page_pool may
not be compatible with bounce buffering in this mode, leading to failures
in the RX path.

Add a check using is_swiotlb_force_bounce() in
mana_use_single_rxbuf_per_page() to detect when force-bounce is active
for the device and force single RX buffer per page allocation.

Note: This issue likely affects any NIC driver using page_pool with
sub-page fragment allocation under SWIOTLB. A more general fix at
the page_pool level may be desirable. Seeking feedback on the
preferred approach.

Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 2d44eaf932a8..841421baf0de 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/export.h>
 #include <linux/skbuff.h>
+#include <linux/swiotlb.h>
 #include <linux/cc_platform.h>
 
 #include <net/checksum.h>
@@ -748,10 +749,15 @@ static void *mana_get_rxbuf_pre(struct mana_rxq *rxq, dma_addr_t *da)
 static bool
 mana_use_single_rxbuf_per_page(struct mana_port_context *apc, u32 mtu)
 {
+	struct gdma_context *gc = apc->ac->gdma_dev->gdma_context;
+
 	/* On confidential VMs with guest memory encryption, all DMA goes
 	 * through SWIOTLB bounce buffers. Sub-page RX fragments may not
 	 * be properly bounce-buffered, so use fullpage buffers.
 	 */
+	if (is_swiotlb_force_bounce(gc->dev))
+		return true;
+
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
 		return true;
 
-- 
2.43.0

