Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795154408;
	b=p8IZcXGUcE81mizduZdF1/2gCtA4OUzyDUH1LhZis23nJbIzVD6hWwW5dRNE7ISO2AeQ
	 iXIzF3PUQ6oz/zh6czzEhuFL3G0g6CLSheXd0Wr4qFqOCO/6SdeGnWU0ecnvPWkdCiN4Y
	 UiaRR9XLhfWGYDOHBOriAgDAumhocw4iDufohGAMySg+su8S3KVCcj2LGK/LTao1l3kZy
	 FR1vSeCyjKhrTqyxK4RhQfIOsdcQuS6IoM1gHJbq5caM4/iudE3ut6ISUGaNOOZ/4o8xW
	 t0QyctW9x3S9rtG5m0OABs/v/0eK4iEd+l03/LWFVKFwrrXwbXEqzuHsOycMMCTUovg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795154408;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=0vH3Pe7qbPVUeRwEI/ELo5LV9S0v5bTVx5kzQrC2ljI=;
	b=g8jscYP6nPv77Qu3MF1i49uPOs1UUZADeGiIwSkmgYo1pN765Ka3gIfazZLVRYoJ+k1l
	 RZ4IPSopLID2A8fdcwu9ZQCOpH1m/cwF6Hi0bhbd+YM9oOFw0n8ZG7EBJNhH4ADCYjVIs
	 C/Igb1DxLYHhwsB1xBsnWYdbVGJ1aRk4FJwdlDRFjQtjSnpDLbWZgrPlSKUcOkIrm8+FK
	 t7vAnUDRzCS5GfZ+bW+GPO8OADmMV/Z0BfGTe/SfHCXJKFewj2J4AW+AHTy4w7NeUF7zu
	 90yu6tMOHxMY3AKpiAVKtvkA6GisSBWgjEMdTm3c+DWE9BmF2IaYd7o2nF6ZEC79rIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ikuyo.dev;
	spf=pass smtp.mailfrom=ikuyo.dev;
	dkim=pass header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=TpigftBh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D71E606A51A;
	Fri, 20 Nov 2026 06:00:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D71E606A51A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=TpigftBh
ARC-Seal: i=1; a=rsa-sha256; t=1795154398; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MjaxucrZ82qXcpVEbs3dAHQyK8Rl+2GxzTK1wUUKpVYpBjdtUIEo+uni5K00DR7bTPLZetHZ2exDGBRFWs32nUvlQi27c6dCQxa6iKExn5nK9HsXIFIiGO8ix/oKN5lz9ddFJJELUdeBddyi3CNnkw6ekVyyLt4bLw47tfNZop0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795154398; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0vH3Pe7qbPVUeRwEI/ELo5LV9S0v5bTVx5kzQrC2ljI=; 
	b=cBOft/tcv9AfyqopzKY0UoTjCQe2K6SEQrOOahpP9e94lweCC1Htfqt1VB4JnVwq/HSmtCsbxB66bia+RCNXHY/cikRfo6GNALzXhMyiSVcNMmYm7tH0BtXUOQEm7z6QWujigFyQYpvdXnpVogWzJGgUHguCpfrFW41Wk9OQm2k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ikuyo.dev;
	spf=pass  smtp.mailfrom=eritque-arcus@ikuyo.dev;
	dmarc=pass header.from=<eritque-arcus@ikuyo.dev>
DKIM-Signature: a=rsa-sha256; b=TpigftBhZG+v2kFJL/zRPATsqZCeWAQYHO+RaVhttCf2C52KD1sdJvaUuh6/Z4BsddO3rDomYw1mt4bpIccdmrLwWiRMMaKMrUUO2A3nCIsgZJHv+wdpMbF0jZHVqB8RtWjqvy/bdvKKazSKua+4LnstuwEJ6Xqvsb5//y6AcGJAEwghMlJXcVAZZ2FphXZuOiYk5Ook0LoIzm+xZOhf8nY06+tKFsspUpVxoqI/OOdtbmt8R52U9F/yKNPKV/0Zrc0h69whBwA9NWqwyiVQvNN4e5S7ZX1Nvoxkwdchk38M8mOZufh3vDBEkBTgsLCGUJYmm+rhzIWIb8El30e0WQ==; c=relaxed/relaxed; s=s1; d=ikuyo.dev; v=1; bh=0vH3Pe7qbPVUeRwEI/ELo5LV9S0v5bTVx5kzQrC2ljI=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 179515439685480.13724806856385;
	Thu, 19 Nov 2026 21:59:56 -0800 (PST)
From: Yiran Qiu <eritque-arcus@ikuyo.dev>
To: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiran Qiu <eritque-arcus@ikuyo.dev>,
	stable@vger.kernel.org
Subject: [PATCH] RDMA/rxe: match a duplicate request to a resource of its own type
Date: Fri, 20 Nov 2026 00:59:51 -0500
Message-ID: <20261120055951.302239-1-eritque-arcus@ikuyo.dev>
X-Mailer: git-send-email 2.56.1
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

find_resource() matches a retransmitted request to a responder resource
by PSN alone, and rxe_prepare_res() never sets the PSN range of a FLUSH
resource, so it keeps the PSNs of the request that last used the slot.
duplicate_request() then gives a retransmitted READ the FLUSH resource
and reads res->read through the union, so read.rkey and read.length come
from the FLUSH's RETH va, chosen by the requester. read_reply() replays
the READ through rxe_recheck_mr(), which only checks that the rkey names
a valid MR.

A FLUSH with no persistence type needs no QP access bit. A connected RC
peer holding one rkey of the QP's PD can thus read any valid MR on the
device, including MRs of other PDs without remote access and the DMA MR
that each kernel PD gets on rxe, which reads kernel memory at the
address the peer gives.

Record the PSNs of a FLUSH resource, and match a duplicate only to a
resource of its own type.

Found with afb-afl, an LLM-driven kernel audit/repro pipeline; the fix
and this changelog were also drafted with LLM assistance. Reproduced on
an unmodified KASAN build of mainline, with raw RoCEv2 packets to an rxe
RC QP: four zero-length READs, a FLUSH, then a READ with the first PSN.
The replayed READ returned 64 bytes of an MR that another process had
registered in another PD with local access only and, against the kernel
DMA MR of rxe0 (key byte found in at most 256 tries), 64 bytes of
linux_banner. With this patch the replayed READ is dropped in both
cases. Retransmitted READ, FETCH_ADD and ATOMIC WRITE requests are
replayed as before, a READ with a foreign rkey is NAKed, and a
retransmitted FLUSH is now acknowledged instead of dropped. The
rdma-core v65.0 tests pass on rxe with and without this patch.

Fixes: ea1bb00ee9a5 ("RDMA/rxe: Implement flush execution in responder side")
Cc: stable@vger.kernel.org
Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>
---
Tested on mainline 4405c18c95d2 (v7.4-rc3+) in QEMU. Applies to
rdma.git for-rc and for-next.
A reproducer and the test logs are available on request.

 drivers/infiniband/sw/rxe/rxe_resp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 1b7f31737225..db662736404c 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -688,6 +688,9 @@ static struct resp_res *rxe_prepare_res(struct rxe_qp *qp,
 		res->flush.length = qp->resp.length;
 		res->flush.type = feth_plt(pkt);
 		res->flush.level = feth_sel(pkt);
+		res->first_psn = pkt->psn;
+		res->last_psn = pkt->psn;
+		res->cur_psn = pkt->psn;
 	}
 
 	return res;
@@ -1327,14 +1330,14 @@ static enum resp_states cleanup(struct rxe_qp *qp,
 	return RESPST_DONE;
 }
 
-static struct resp_res *find_resource(struct rxe_qp *qp, u32 psn)
+static struct resp_res *find_resource(struct rxe_qp *qp, u32 psn, int type)
 {
 	int i;
 
 	for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
 		struct resp_res *res = &qp->resp.resources[i];
 
-		if (res->type == 0)
+		if (res->type != type)
 			continue;
 
 		if (psn_compare(psn, res->first_psn) >= 0 &&
@@ -1361,7 +1364,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 		struct resp_res *res;
 
 		/* Find the operation in our list of responder resources. */
-		res = find_resource(qp, pkt->psn);
+		res = find_resource(qp, pkt->psn, RXE_FLUSH_MASK);
 		if (res) {
 			res->replay = 1;
 			res->cur_psn = pkt->psn;
@@ -1376,7 +1379,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 	} else if (pkt->mask & RXE_READ_MASK) {
 		struct resp_res *res;
 
-		res = find_resource(qp, pkt->psn);
+		res = find_resource(qp, pkt->psn, RXE_READ_MASK);
 		if (!res) {
 			/* Resource not found. Class D error.  Drop the
 			 * request.
@@ -1423,7 +1426,8 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 		struct resp_res *res;
 
 		/* Find the operation in our list of responder resources. */
-		res = find_resource(qp, pkt->psn);
+		res = find_resource(qp, pkt->psn, pkt->mask & RXE_ATOMIC_MASK ?
+				    RXE_ATOMIC_MASK : RXE_ATOMIC_WRITE_MASK);
 		if (res) {
 			res->replay = 1;
 			res->cur_psn = pkt->psn;
-- 
2.56.1

