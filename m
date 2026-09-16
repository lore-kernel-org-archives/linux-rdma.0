Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2629460;
	Wed, 16 Sep 2026 03:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789529034; cv=none; b=UVfRrLGb8BHGT4JQuCVzJNEaY2/zQz7XUVMaYINXC40KSWu4hWRt5M81sD+RIhRdlEHqr/JBv7A4+Al4TVrcyLxybmXLaZXYxLMx1GQ8H4u/2l7K7+ttpD4ymBH8YXbFnh7ec1cPbPkb6qqNrY5EVzWVMxPoOmpeX8oUUBSp280=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789529034; c=relaxed/simple;
	bh=YZEeBTjZ4j94kPxqHjiN0sv6nxgqNvmqXycd1yft3tU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgQWw42MM32Hk3xkW8GybxR71UIcHszrf66wrrPWor7afbrBVjS6Bq8N2mKfc5b/C2kQ7Ql3acJ68PmGhkZsuC+gsJuLkFNz6VUFGw1u6zFoVux5FQb/iBOwNBo4GfVxS0J84fT52RImcUCXYuQgdnAF9sziiHyWqMKmda8aqp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Driynu42; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Driynu42"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Message-ID:MIME-Version:
	Content-Type; bh=8I2KYbRF+uZjmyOxg+G/X0kJ975qnJ+ZHzGU4sG05zc=;
	b=Driynu42NHjYuU+fyCA/Z7tplDXzXRV8JKepXA1uFue54HBYRmeN8eAme80fV2
	KcAAyGZZOidaQAl7mpV8F5yW+f2tFWhfHtjtf8PidFAdM76McmBiK4yH1z1Ch5YI
	6zbcgkvDPkevMERFFIUtMH7D8+kCtoqJAluyaN+QeeM7Y=
Received: from localhost (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgCHk4m5C6pqEpRePQ--.9601S2;
	Wed, 16 Sep 2026 11:23:38 +0800 (CST)
Date: Wed, 16 Sep 2026 11:23:37 +0800
From: Honggang LI <honggangli@163.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rxe: Fix out-of-range unsigned-to-signed conversion
 for RDMA message in 2GiB size
Message-ID: <aqoLuVxDIOHMuePi@fedora>
References: <20260915064532.194540-1-honggangli@163.com>
 <20260915114914.GL13683@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915114914.GL13683@unreal>
X-CM-TRANSID:PCgvCgCHk4m5C6pqEpRePQ--.9601S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr1DKFWrGw15tFWxAF4Utwb_yoWrAFyfpF
	WrJ3Z8Kr43XF4I9FsFyws8ZFWay3Z8GasrKF9Iq34aqFyUCayagFnFkrW7uay5JFyDCw4x
	tw12yrWDGr1fGFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRaFAXUUUUU=
X-CM-SenderInfo: 5krqwwxdqjzxi6rwjhhfrp/xtbC6xo2e2qqC7qyNQAA3K

On Tue, Sep 15, 2026 at 02:49:14PM +0300, Leon Romanovsky wrote:
> > After fixed it, the active side of RDMA READ failed with error code
> > "IB_WC_LOC_PROT_ERR". When RDMA_READ_RESPONSE_FIRST packet recived by
> > the active side, `do_read` call `copy_data`. dma->resid is u32 0x80000000.
> > 
> >    int resid	= dma->resid;
> > 
> > This conversion set resid to -2147483648. `copy_data` abort as length
> > greater than resid. Change resid to int64_t fixes this issue.
> 
> Why not size_t?

First, size_t is u64. dma->resid is u32. If use unsigned type, u32 is enough.

Second, I'm not sure it is right to use unsigned type. In `copy_data`,
the loop terminate on negative value of `length`.

Use int64_t is safe and minimal changes of the code.

int copy_data(
..................
	while (length > 0) {
	^^^^^^^^^^^^^^^^^^^^^^^^
		bytes = length;
..............
		if (bytes > sge->length - offset)
			bytes = sge->length - offset;

		if (bytes > 0) {
			iova = sge->addr + offset;
			err = rxe_mr_copy(mr, iova, addr, bytes, dir);

			offset	+= bytes;
			resid	-= bytes;
			length	-= bytes;
			addr	+= bytes;
		}
	}

> 
> >  
> > -	payload = min_t(int, res->read.resid, mtu);
> > +	payload = min_t(u32, res->read.resid, mtu);
> 
> Why don't we use the proper types from the start to avoid the need for
> u32 casts?

Again, minimal the changes with u32 casts. We need something like this
to use u32.

---
 drivers/infiniband/sw/rxe/rxe_loc.h  |  2 +-
 drivers/infiniband/sw/rxe/rxe_net.c  |  2 +-
 drivers/infiniband/sw/rxe/rxe_resp.c | 15 ++++++++-------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 64d636bf80fd..ceb9321add96 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -91,7 +91,7 @@ void rxe_mw_cleanup(struct rxe_pool_elem *elem);
 
 /* rxe_net.c */
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt);
+				u32 paylen, struct rxe_pkt_info *pkt);
 int rxe_prepare(struct rxe_av *av, struct rxe_pkt_info *pkt,
 		struct sk_buff *skb);
 int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 53daaf4c1eb2..f548f312b393 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -536,7 +536,7 @@ int rxe_xmit_packet(struct rxe_qp *qp, struct rxe_pkt_info *pkt,
 }
 
 struct sk_buff *rxe_init_packet(struct rxe_dev *rxe, struct rxe_av *av,
-				int paylen, struct rxe_pkt_info *pkt)
+				u32 paylen, struct rxe_pkt_info *pkt)
 {
 	unsigned int hdr_len;
 	struct sk_buff *skb = NULL;
diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 02b16e2b49b8..383706de0b29 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -827,20 +827,21 @@ static enum resp_states atomic_write_reply(struct rxe_qp *qp,
 static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
 					  struct rxe_pkt_info *ack,
 					  int opcode,
-					  int payload,
+					  u32 payload,
 					  u32 psn,
 					  u8 syndrome)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct sk_buff *skb;
-	int paylen;
-	int pad;
+	u32 paylen;
+	u32 pad = 0;
 	int err;
 
 	/*
 	 * allocate packet
 	 */
-	pad = (-payload) & 0x3;
+	if (payload % 4)
+		pad = 4 - payload % 4;
 	paylen = rxe_opcode[opcode].length + payload + pad + RXE_ICRC_SIZE;
 
 	skb = rxe_init_packet(rxe, &qp->pri_av, paylen, ack);
@@ -934,9 +935,9 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 {
 	struct rxe_pkt_info ack_pkt;
 	struct sk_buff *skb;
-	int mtu = qp->mtu;
+	u32 mtu = qp->mtu;
 	enum resp_states state;
-	int payload;
+	u32 payload;
 	int opcode;
 	int err;
 	struct resp_res *res = qp->resp.res;
@@ -982,7 +983,7 @@ static enum resp_states read_reply(struct rxe_qp *qp,
 
 	res->state = rdatm_res_state_next;
 
-	payload = min_t(int, res->read.resid, mtu);
+	payload = min(res->read.resid, mtu);
 
 	skb = prepare_ack_packet(qp, &ack_pkt, opcode, payload,
 				 res->cur_psn, AETH_ACK_UNLIMITED);

---
Thanks				 

