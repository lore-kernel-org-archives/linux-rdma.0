Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 568D73BA241;
	Mon, 27 Apr 2026 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777297863; cv=none; b=poTGdep3JDeYiHpm8LEAP9pxhyLVp2SMezosenH68LDg+s8vhPiPfsc7wW6ugFmggTfb+NU/aZGVLwvdZS87PfxCR5/fgjycrxYFhWbLFTUR5Wn69WnIcAb4yOLHaCdM7KrD3bFjWDceGOCydlTDHjTnrTslJ2RagZrlpIudUe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777297863; c=relaxed/simple;
	bh=+b/XARtL8TTdO5avBV72s4wEqPqZTYtiOCXUOIpscXQ=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=JBbCZYANgPtSguXMwZDSu5OQfx83kTOGtixBQZWI4E1xffcIDzYLi0ncSzBobmSzJMgWESU1/6ecznXOf5NDejb32thoh733ZkN9KabaUCQ6T7rGk17+bSnVXXMqI/8V2VuIxAC4nm5JA0o1aFrFhnDRDGzVm5LxSXPekg8Fsd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ZXFFxoIA; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ZXFFxoIA"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 83B4C20B716A; Mon, 27 Apr 2026 06:51:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 83B4C20B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777297862;
	bh=JjVpccUnXnnI/i5ox4+KGA4Y9noeTr3ND10yN1jOoHY=;
	h=Date:From:To:Subject:From;
	b=ZXFFxoIAeUD8B7w1wMbldnxsJscValauGXIjdFCs+DaZDXhrsE3Ax5RnuuNodFPmg
	 9tBYiB2KqkG5snNSJCaLs0//HqRqbwg0CoSNUBBDxv9N5a4hBPrgQbhHsIqPTdTX0A
	 prAL8T6PMpP8Q9fba0txT8f1BtdkyYulV2QBxzkE=
Date: Mon, 27 Apr 2026 06:51:02 -0700
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
Subject: [PATCH net-next] net: mana: Force single RX buffer per page for
 CVM/encrypted guest memory
Message-ID: <ae9pxvJfkAZYfKMf@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Confidential VMs (CVMs) such as AMD SEV-SNP or Intel TDX, the guest
operating system's memory is encrypted. And current hardwares lacks the
support for TDISP (TEE Device Interface Security Protocol), meaning the
NIC cannot directly access this encrypted VM memory. Consequently, all
DMA operations must utilize SWIOTLB bounce buffers.

In the MANA driver currently, there are two distinct paths for DMA
mapping:

1. Without PP_FLAG_DMA_MAP: The driver manually maps full pages for each
packet. This creates standalone, page-aligned mappings where the offset
is always zero.

2. With PP_FLAG_DMA_MAP: Optimizes memory by using page_pool with
sub-page fragments (e.g., multiple RX buffers sharing a single page).
When PP_FLAG_DMA_MAP is enabled, page_pool maps the entire page once.
Subsequent RX buffer allocations use offsets into this pre-mapped area.

When page_pool allocates sub-page RX buffer fragments, the bounce buffer
granularity may not align with these smaller fragment sizes, leading to
failure in mana driver rx path.

Refactor the RX buffer decision into mana_use_single_rxbuf_per_page().
When cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) is true, the driver is
forced to use a single RX buffer per page. This ensures:
- Each RX buffer is exactly one PAGE_SIZE.
- The DMA offset is always 0.
- SWIOTLB maps full, page-aligned blocks.

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index a654b3699c4c..2d44eaf932a8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -12,6 +12,7 @@
 #include <linux/pci.h>
 #include <linux/export.h>
 #include <linux/skbuff.h>
+#include <linux/cc_platform.h>
 
 #include <net/checksum.h>
 #include <net/ip6_checksum.h>
@@ -744,6 +745,23 @@ static void *mana_get_rxbuf_pre(struct mana_rxq *rxq, dma_addr_t *da)
 	return va;
 }
 
+static bool
+mana_use_single_rxbuf_per_page(struct mana_port_context *apc, u32 mtu)
+{
+	/* On confidential VMs with guest memory encryption, all DMA goes
+	 * through SWIOTLB bounce buffers. Sub-page RX fragments may not
+	 * be properly bounce-buffered, so use fullpage buffers.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return true;
+
+	/* For xdp and jumbo frames make sure only one packet fits per page. */
+	if (mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 || mana_xdp_get(apc))
+		return true;
+
+	return false;
+}
+
 /* Get RX buffer's data size, alloc size, XDP headroom based on MTU */
 static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 			       int mtu, u32 *datasize, u32 *alloc_size,
@@ -754,8 +772,7 @@ static void mana_get_rxbuf_cfg(struct mana_port_context *apc,
 	/* Calculate datasize first (consistent across all cases) */
 	*datasize = mtu + ETH_HLEN;
 
-	/* For xdp and jumbo frames make sure only one packet fits per page */
-	if (mtu + MANA_RXBUF_PAD > PAGE_SIZE / 2 || mana_xdp_get(apc)) {
+	if (mana_use_single_rxbuf_per_page(apc, mtu)) {
 		if (mana_xdp_get(apc)) {
 			*headroom = XDP_PACKET_HEADROOM;
 			*alloc_size = PAGE_SIZE;
-- 
2.43.0

