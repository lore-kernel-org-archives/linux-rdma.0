Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qOggcZwp"
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD6E7
	for <linux-rdma@vger.kernel.org>; Sun,  3 Dec 2023 01:27:40 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701595658;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jyFTmfTcRc/N3YNW3p9yTrNvCItvRn4ZVJp4GPZO6c=;
	b=qOggcZwpsK1iE2lGZ3yqmzweaTcaK2/mqKAfqXS7v/t4hhlTfEPBoeRLmcO8tkhzUU+8M8
	jmEIepORH9nVxhGxxHyXujMVqjqws5MX6c2JoVQeyJNLbtjzIDiDiuXkmdroXeAhWgV5KM
	NaU+MoFz/xxU2t10SjO6Ef7zZpErxpg=
From: Guoqing Jiang <guoqing.jiang@linux.dev>
To: bmt@zurich.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	guoqing.jiang@linux.dev
Subject: [PATCH V2 2/4] RDMA/siw: Reduce memory usage of struct siw_rx_stream
Date: Sun,  3 Dec 2023 17:26:53 +0800
Message-Id: <20231203092655.28102-3-guoqing.jiang@linux.dev>
In-Reply-To: <20231203092655.28102-1-guoqing.jiang@linux.dev>
References: <20231203092655.28102-1-guoqing.jiang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We can reduce the memory of the struct by move some of it's
member.

Before,

	/* size: 144, cachelines: 3, members: 17 */
	/* sum members: 124, holes: 3, sum holes: 12 */
	/* sum bitfield members: 7 bits (0 bytes) */
	/* padding: 7 */
	/* bit_padding: 1 bits */

After

	/* size: 128, cachelines: 2, members: 17 */
	/* padding: 3 */
	/* bit_padding: 1 bits */

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
---
 drivers/infiniband/sw/siw/siw.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw.h b/drivers/infiniband/sw/siw/siw.h
index d14bb965af75..2edba2a864bb 100644
--- a/drivers/infiniband/sw/siw/siw.h
+++ b/drivers/infiniband/sw/siw/siw.h
@@ -288,10 +288,11 @@ struct siw_rx_stream {
 	int skb_offset; /* offset in skb */
 	int skb_copied; /* processed bytes in skb */
 
+	enum siw_rx_state state;
+
 	union iwarp_hdr hdr;
 	struct mpa_trailer trailer;
-
-	enum siw_rx_state state;
+	struct shash_desc *mpa_crc_hd;
 
 	/*
 	 * For each FPDU, main RX loop runs through 3 stages:
@@ -313,7 +314,6 @@ struct siw_rx_stream {
 	u64 ddp_to;
 	u32 inval_stag; /* Stag to be invalidated */
 
-	struct shash_desc *mpa_crc_hd;
 	u8 rx_suspend : 1;
 	u8 pad : 2; /* # of pad bytes expected */
 	u8 rdmap_op : 4; /* opcode of current frame */
-- 
2.35.3

