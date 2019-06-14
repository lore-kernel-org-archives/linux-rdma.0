From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/16] iwlwifi: stop passing bogus gfp flags arguments to dma_alloc_coherent
Date: Fri, 14 Jun 2019 15:47:20 +0200
Message-ID: <20190614134726.3827-11-hch@lst.de>
References: <20190614134726.3827-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190614134726.3827-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>, "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-media@vger.kernel.org, netdev@vger.kernel.org, linux-wireless@vger.kernel.org, linux-s390@vger.kernel.org, devel@driverdev.osuosl.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

dma_alloc_coherent is not just the page allocator.  The only valid
arguments to pass are either GFP_ATOMIC or GFP_ATOMIC with possible
modifiers of __GFP_NORETRY or __GFP_NOWARN.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c     | 3 +--
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 5f52e40a2903..323dc5d5ee88 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2361,8 +2361,7 @@ iwl_fw_dbg_buffer_allocation(struct iwl_fw_runtime *fwrt, u32 size)
 
 	virtual_addr =
 		dma_alloc_coherent(fwrt->trans->dev, size, &phys_addr,
-				   GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO |
-				   __GFP_COMP);
+				   GFP_KERNEL | __GFP_NOWARN);
 
 	/* TODO: alloc fragments if needed */
 	if (!virtual_addr)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 803fcbac4152..22a47f928dc8 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -210,8 +210,7 @@ static void iwl_pcie_alloc_fw_monitor_block(struct iwl_trans *trans,
 	for (power = max_power; power >= min_power; power--) {
 		size = BIT(power);
 		cpu_addr = dma_alloc_coherent(trans->dev, size, &phys,
-					      GFP_KERNEL | __GFP_NOWARN |
-					      __GFP_ZERO | __GFP_COMP);
+					      GFP_KERNEL | __GFP_NOWARN);
 		if (!cpu_addr)
 			continue;
 
-- 
2.20.1
