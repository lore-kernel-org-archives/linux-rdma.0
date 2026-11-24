Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795534873;
	b=yONCgK9KqQ/jvEdMN0h6q/fHuK2lFaaI5EM2y5we/NT3ji6k3Sjqhb+Le3I4Pb+TYk+w
	 VbEWv+V3ZieS/kK6ftiwodzEkJbjTGlE9S4+fPxrCxFgEDu5kwZTtOMkXz7NbnI7lnrpa
	 LVj2vVRr0s5cc1zR9fwBAhO7p3J5bXJQkJb5ecSpObd/Uac6LDoqjPG5V/k6T2dr3SDCI
	 0/NXRdFIuFiksjAT6J2VvuQlD/r6shnnfruqi80e7QiuBiNq5f7TAlcUmQd23nJVPsjpw
	 +Sq4qGYTGsTLh1ymmnX7h7IAR3l3/SGmiJsFKW7m4V+x2IDUXepygpgJlXqeH0tXWiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795534873;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=AzZsYoosrn/HfDTUHNVy9Q5o9yaH6GlY+jQTsO5yjMs=;
	b=zrQ5QqtQIO5aC40Pfw7b8WqWWkIcVe2ttZS8wsddSX1/63dSMrovThhcS1LdENZ1bkg8
	 6vYg37W7ixS8YaYGaOnlFf8djNO+yHaWrHMdr5sSc0/7C0zDX1akCbBYj1riH1q9esasR
	 Ng/yNoZQcNm/cVxuUc/9SR91tV8S733tsoZ3PjeDofMqpTlTxFiy1h+AlA8H6AGhBN7E3
	 E43bIFesUKela3mT2GWj+sj7Mzcze2JWc4vrRK1J+MaqL1zaXgWMEo+av14Beb5pSGGXI
	 RM/AoSuhYalSEBP4618auIvAA8KC5tw6fGDz7G4CkXvRDkRnRYEzW4YcEGwQ8MpUNRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=VhzCCvj7;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3415C606A332;
	Tue, 24 Nov 2026 15:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3415C606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=VhzCCvj7
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id BB95320B7170;
	Tue, 24 Nov 2026 07:41:01 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BB95320B7170
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795534862;
	bh=AzZsYoosrn/HfDTUHNVy9Q5o9yaH6GlY+jQTsO5yjMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VhzCCvj7zfkD+Ue6H5p7bSDi2NFOYbqvfGX2BrXVF5AScGQfCCRFtsu/H9FNOL0Qy
	 af7bsFBPFuIZYYolzug4+go2+L7uwEL53X2nsykSc9sr4t7RmiqjT86WoW5nOU+PF4
	 XUTxrp3FG7o23eql2+UgeorAPKxqG0qYJKAoTmAs=
From: Wei Hu <weh@linux.microsoft.com>
To: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org,
	shacharr@microsoft.com
Subject: [PATCH net-next v12 1/5] net: mana: validate the HWC doorbell before ringing it
Date: Tue, 24 Nov 2026 15:40:54 +0000
Message-ID: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.1@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
References: <hwc-v12.91ec3eff9cb647d5bc5cc932b3c6f60c.0@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Long Li <longli@microsoft.com>
Date: Mon, 24 Aug 2026 20:04:01 +0000

The HWC gets its doorbell page from an initialization event. Unlike a
registered device, it uses that page without checking that it fits in
BAR0. The EQ can also try to rearm before a page has been assigned.

Check the page before storing it and skip doorbell writes until a page
is available. Fail setup on a bad page rather than waiting for another
event on an EQ that cannot be rearmed.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Long Li <longli@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 .../net/ethernet/microsoft/mana/gdma_main.c   | 25 +++++++++++++------
 .../net/ethernet/microsoft/mana/hw_channel.c  | 19 ++++++++++++++
 include/net/mana/gdma.h                       |  1 +
 include/net/mana/hw_channel.h                 |  1 +
 4 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index d6ae89c2ccddce5cca264fa499ddd1cbdee8cf85..673a4754c9dd00a8a0b4436e27ce1c433d85c2ff 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -547,13 +547,28 @@ static int mana_gd_disable_queue(struct gdma_queue *queue)
 #define DOORBELL_OFFSET_EQ	0xFF8
 #define DOORBELL_OFFSET_DIM	0x820
 
+bool mana_gd_is_valid_doorbell(struct gdma_context *gc, u32 db_id)
+{
+	if (!gc->db_page_size || gc->db_page_off >= gc->bar0_size)
+		return false;
+
+	/* The page size comes from a 16-bit register field. */
+	return db_id != INVALID_DOORBELL &&
+	       gc->db_page_size * ((u64)db_id + 1) <=
+	       gc->bar0_size - gc->db_page_off;
+}
+
 static void mana_gd_ring_doorbell(struct gdma_context *gc, u32 db_index,
 				  enum gdma_queue_type q_type, u32 qid,
 				  u32 tail_ptr, u8 num_req, u8 client_offset)
 {
-	void __iomem *addr = gc->db_page_base + gc->db_page_size * db_index;
 	union gdma_doorbell_entry e = {};
+	void __iomem *addr;
+
+	if (unlikely(db_index == INVALID_DOORBELL))
+		return;
 
+	addr = gc->db_page_base + gc->db_page_size * db_index;
 	addr += client_offset;
 
 	switch (q_type) {
@@ -1533,13 +1548,7 @@ int mana_gd_register_device(struct gdma_dev *gd)
 		return err ? err : -EPROTO;
 	}
 
-	/* Validate that doorbell page for db_id is within the BAR0 region.
-	 * In mana_gd_ring_doorbell(), the address is calculated as:
-	 *   addr = db_page_base + db_page_size * db_id
-	 *        = (bar0_va + db_page_off) + (db_page_size * db_id)
-	 * So we need: db_page_off + db_page_size * (db_id + 1) <= bar0_size
-	 */
-	if (gc->db_page_off + gc->db_page_size * ((u64)resp.db_id + 1) > gc->bar0_size) {
+	if (!mana_gd_is_valid_doorbell(gc, resp.db_id)) {
 		dev_err(gc->dev, "Doorbell ID %u out of range\n", resp.db_id);
 		return -EPROTO;
 	}
diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index fb9f38f65911ca9e4171f03ff7f9c8f2a40b5b28..130b249318f208ae8369c98facf5113a3743cfd4 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -123,6 +123,15 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 	switch (event->type) {
 	case GDMA_EQE_HWC_INIT_EQ_ID_DB:
 		eq_db.as_uint32 = event->details[0];
+		if (!mana_gd_is_valid_doorbell(gd->gdma_context,
+					       eq_db.doorbell)) {
+			dev_err(hwc->dev, "Invalid HWC doorbell %u\n",
+				eq_db.doorbell);
+			WRITE_ONCE(hwc->hwc_init_error, -EPROTO);
+			complete(&hwc->hwc_init_eqe_comp);
+			break;
+		}
+
 		hwc->cq->gdma_eq->id = eq_db.eq_id;
 		gd->doorbell = eq_db.doorbell;
 		break;
@@ -182,6 +191,10 @@ static void mana_hwc_init_event_handler(void *ctx, struct gdma_queue *q_self,
 		break;
 
 	case GDMA_EQE_HWC_INIT_DONE:
+		if (gd->doorbell == INVALID_DOORBELL) {
+			dev_err(hwc->dev, "Missing HWC doorbell\n");
+			WRITE_ONCE(hwc->hwc_init_error, -EPROTO);
+		}
 		complete(&hwc->hwc_init_eqe_comp);
 		break;
 
@@ -676,6 +689,8 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	struct gdma_queue *cq = hwc->cq->gdma_cq;
 	int err;
 
+	gc->hwc.doorbell = INVALID_DOORBELL;
+	WRITE_ONCE(hwc->hwc_init_error, 0);
 	init_completion(&hwc->hwc_init_eqe_comp);
 
 	err = mana_smc_setup_hwc(&gc->shm_channel, false,
@@ -690,6 +705,10 @@ static int mana_hwc_establish_channel(struct gdma_context *gc, u16 *q_depth,
 	if (!wait_for_completion_timeout(&hwc->hwc_init_eqe_comp, 60 * HZ))
 		return -ETIMEDOUT;
 
+	err = READ_ONCE(hwc->hwc_init_error);
+	if (err)
+		return err;
+
 	*q_depth = hwc->hwc_init_q_depth_max;
 	*max_req_msg_size = hwc->hwc_init_max_req_msg_size;
 	*max_resp_msg_size = hwc->hwc_init_max_resp_msg_size;
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 1f0f9897b806dc90d81cc9b9ba2c405bf5cb920b..bde68d6a99f01634f456a9b16eb74fba566e788c 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -1179,6 +1179,7 @@ int mana_gd_post_and_ring(struct gdma_queue *queue,
 int mana_gd_alloc_res_map(u32 res_avail, struct gdma_resource *r);
 void mana_gd_free_res_map(struct gdma_resource *r);
 
+bool mana_gd_is_valid_doorbell(struct gdma_context *gc, u32 db_id);
 void mana_gd_wq_ring_doorbell(struct gdma_context *gc,
 			      struct gdma_queue *queue);
 void mana_gd_wq_ring_doorbell_ext(struct gdma_context *gc, struct gdma_queue *queue,
diff --git a/include/net/mana/hw_channel.h b/include/net/mana/hw_channel.h
index 1ab2d66c891e42f3a847e62acf75b69fcf7ffb1e..113b01325137bfbab4a0b4c42f1ee883dbcbedb5 100644
--- a/include/net/mana/hw_channel.h
+++ b/include/net/mana/hw_channel.h
@@ -186,6 +186,7 @@ struct hw_channel_context {
 	u32 hwc_init_max_req_msg_size;
 	u32 hwc_init_max_resp_msg_size;
 
+	int hwc_init_error;
 	struct completion hwc_init_eqe_comp;
 
 	struct hwc_wq *rxq;
