Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB153D3D09
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 16:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785083987; cv=none; b=DNCOZdOxd8/ACRmOz+W4KbCzZTG9yWr9tGQU6fZ9Ov/yJavXkI4Xj4Xz7SLLrC1SCVPjIkfY+3WiWfMw0Fbr6KagiP5HV5HN69ktma6sYH7yHxL30hlpu2+sDF12wzW4U7nEc30VJSxSzKZlFy5mCavlT/qw990J11HKm7Gl7Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785083987; c=relaxed/simple;
	bh=2Ro/9S4BQ5TNB6srO/HHxekj2YW5ya5HGRiHsGeRo74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AohT2fx3v8iWhZ8zMxDXHaH95HXAsJg7e3gFW0yzVTb5yunGQhYPyN8flzSqQkSjegn+YVHeuILcc/F8ypi5Nj19f0kIBVC6INiCtI8MwGyvJdRYKwxVjO97N9ZqvukXJPRmX7wC+aETfXDBcir9/iqkD9VH09M/oPeAyL4cIjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=RZHoUaA4; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="RZHoUaA4"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cad8076b01so22394665ad.2
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 09:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785083984; x=1785688784; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gq3vDCA8qyUTutalHgGj6aRcp1kNTbzzKTiRzZxdQZw=;
        b=RZHoUaA48HwArzJ53Pnh4xTHTAZ+DylaHnf9Cf0GZDDD69oy79HjC7BxxfMU/suVq4
         l5jhlyOIN+edi33y2+gDMlkdoNUTsS3k7/FtybbnPEE8cBoQFZT4jujcYIrrS5PGX1FY
         duNosodtuRS4yIcZkciA4RuG2ILgLyqYIhjhzt8EntiTtOpGALqxNchlbMZDmzrz66hy
         9xg3jkJV9jJYvIz7CshhXE9QTn9ZACASf8TPjMIiHsDiu/PPtAJmM4X5YI6WhMP0m8om
         ACJSOptlSGeIO+2vpkhFVEPPfdPICGUlf9oCjQgoUOSbAxbe4j0e6JAD7/lk0gLZ0h7l
         6+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785083984; x=1785688784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gq3vDCA8qyUTutalHgGj6aRcp1kNTbzzKTiRzZxdQZw=;
        b=Tt6XKAeClu9BrS1RbXRJvRybtFcl0gMcwN1oIyP8cD9QXpIF3jlBO45tFRcGYTsWve
         vDtU6enGcf61P/NPFJDkjEW+y290gVBoPjj8MzGpA9rX+GxFwWZxYT0MuTSunIRZV8JD
         vd/IrvZUj6/gYxKKR2icsEdeh8/Svvam0i2bjyZkNja6GxIMVGpIbDPVE0WwWkik2tpt
         veDcY4GHVOIz2P9l0h16yKdHfRQ6bo9IxdGdOFT52LJlSradWu5uSa/SGiENBD8CrZnR
         18rt8lyvSaHdnab6vnyznSsit8E8ooGiJj/fBf1wZay3EpIDOogLIvId5pU+qudrZRzU
         L0xg==
X-Gm-Message-State: AOJu0YxuuO4kE9u/MUGBh6fUHmR6RYRHJXeVRjFMAw416v/WJiwnJOA/
	MySRXvYyw6wNPLE6Lx+679/wEXFkio2yA+O1JkIPQQ0nleKR6jdWmx2X97Od6pYH0XQ=
X-Gm-Gg: AR+sD10BwwzghYpg8SZCRKADgSSusQImXQcv4j6C0rQyq0UFJTxc4D5OJvJYfciJxjo
	NfKtfu8cIUFoLreB8uxStmllUvHRMG40bbwDoux/FvkD1ve0OkfjH6zOQWevEcReN6l8nTDsH9W
	GcRuZyFqX38TrQBGXUpTGxCqylaHTZRq2HlsAz8SdqHDH5dPnQRrV9h29ExyyYKwFMt7jr2iHnc
	n0EA0yI53XMxuRQhRwKPp8MaQzaMMoMNScPMBYIlj7ibAKNGlsm5HCuMjVOPA1ryA2Z/WID+87z
	ay8D4kqH73QeA8NUmMkqNTqvufOjQvMsQXxd21nJ62j7YEiTlvlBh0zwdZhGHHt+lD93HtSHYz+
	TbyrgiWmJFeyj2aIbenUUwY8G2yH80xAtpGTNgt0ZlXczcCtXljW+HrmYqAjL93eEX2fC/gzwO0
	63nEajmwArQiJPWDTv+gDTZQEC
X-Received: by 2002:a17:902:e541:b0:2cf:1536:3d41 with SMTP id d9443c01a7336-2cfde84b893mr53739685ad.28.1785083984191;
        Sun, 26 Jul 2026 09:39:44 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:be9c:ea6b:29a7:6c78])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde80306esm21514315ad.75.2026.07.26.09.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 09:39:43 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] IB/isert: reject PDUs declaring more data than was received
Date: Mon, 27 Jul 2026 01:39:30 +0900
Message-ID: <20260726163931.971063-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260726163931.971063-1-yhlee@isslab.korea.ac.kr>
References: <20260726163931.971063-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_recv_done() hands each received PDU to the opcode handlers without
ever looking at wc->byte_len, the number of bytes the HCA actually placed
in the receive descriptor. The handlers then copy that many bytes - the
data-segment length the initiator declared in the BHS
(ntoh24(hdr->dlength), via the derived unsol_data_len / imm_data_len) -
out of the fixed-size descriptor:

  isert_handle_iscsi_dataout():
        sg_copy_from_buffer(sg_start, sg_nents, isert_get_data(rx_desc),
                            unsol_data_len);
  isert_handle_scsi_cmd():
        sg_copy_from_buffer(cmd->se_cmd.t_data_sg, sg_nents,
                            isert_get_data(rx_desc), imm_data_len);

Because the declared length is never checked against wc->byte_len, an
initiator can declare a data segment larger than the bytes it actually
sent (and larger than the descriptor) and cause an out-of-bounds read of
the receive buffer.

Nothing upstream of isert closes this door:

  - __iscsit_check_dataout_hdr() bounds the inbound payload against
    conn_ops->MaxXmitDataSegmentLength (MXDSL) - a transmit parameter,
    used here for the inbound check.
  - iscsi_set_connection_parameters() sets
    ops->MaxXmitDataSegmentLength = ops->TargetRecvDataSegmentLength;
    and TARGETRECVDATASEGMENTLENGTH is absent from the min()-clamp list in
    iscsi_check_acceptor_state(), so the value the initiator declares is
    adopted verbatim (type range 512..16777215). The initiator effectively
    raises its own ceiling.
  - isert never clamps the negotiated value to its own fixed receive
    descriptor (ISER_RX_SIZE, 9216 bytes), so the target core's bound and
    the descriptor size are unrelated.

The imm_data_len == data_len path is more than an over-read: it aliases
the receive descriptor via sg_set_buf() and passes it to the backend as
the data source for the SCSI WRITE, so an over-declared length causes heap
contents past the descriptor to be written through the backend to the
backing store. The backend is the victim of the oversized scatterlist
isert hands it, not the cause; no read-back of the written bytes was
demonstrated.

Trigger: after login completes (full feature phase), an initiator that has
declared a large TargetRecvDataSegmentLength and a FirstBurstLength that
permits unsolicited/immediate data sends a PDU whose declared data-segment
length exceeds what was received. With KASAN:

  BUG: KASAN: slab-out-of-bounds in sg_copy_buffer+0x150/0x1c0
  Read of size 4096 at addr ffff888109720800 by task kworker/1:0H/25
  Workqueue: ib-comp-wq ib_cq_poll_work
  Call Trace:
   sg_copy_buffer+0x150/0x1c0
   isert_recv_done+0xba6/0x2390
   __ib_process_cq+0xe1/0x390
   ib_cq_poll_work+0x46/0x150

isert_recv_done+0xba6 resolves to isert_handle_iscsi_dataout()
(ib_isert.c:1160), inlined through isert_rx_opcode().

Validate wc->byte_len against the framing in isert_recv_done() before the
PDU reaches any handler, and reinstate the connection if it is short.
Because the test compares without subtracting the header length, it also
rejects PDUs shorter than the iSER and iSCSI headers, which would otherwise
be parsed out of stale descriptor contents. The login handler rejects PDUs
shorter than ISER_HEADERS_LEN (commit 29e7b925ae6d ("IB/isert: Reject login
PDUs shorter than ISER_HEADERS_LEN")) but does not bound the declared
length either; that is fixed in the next patch. The data handlers had no
length check at all.

isert reads the data segment from a fixed offset: isert_get_data()
returns the iSER header plus ISER_HEADERS_LEN and makes no adjustment for
an AHS.  The bytes the handlers touch are therefore exactly
[ISER_HEADERS_LEN, ISER_HEADERS_LEN + dlength), and comparing that sum
against wc->byte_len bounds precisely the region that is read.  An AHS
term would only make the test stricter without bounding anything further,
and cannot cause a false reject: a PDU carrying an AHS is longer, not
shorter.

This is a memory-safety fix that verifies the bytes that were actually
received; it does not touch RFC 7145 length negotiation and is not the
MaxXmitDataSegmentLength negotiation redesign raised in the 2017 "[Query]
iSER-Target: QP errors observed on increasing MaxXmitDataSegmentLength"
discussion. That redesign is explicitly out of scope here.

The patched kernel rejects the malformed DataOut PDU and both
immediate-data variants with "PDU declares ... bytes were received" and
continues to pass normal traffic with no regression.

Reproduced with soft-RoCE (rdma_rxe) and a raw rdma_cm/ibv initiator; no
kernel-side test hooks were needed.

Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) target driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 1015a51f750a..66435a0a5c7a 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1333,6 +1333,21 @@ isert_recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	ib_dma_sync_single_for_cpu(ib_dev, rx_desc->dma_addr,
 			ISER_RX_SIZE, DMA_FROM_DEVICE);
 
+	/*
+	 * The data segment length declared in the BHS is attacker controlled
+	 * and is used further down to read that many bytes out of the fixed
+	 * size receive descriptor, so it has to be checked against the number
+	 * of bytes that were actually received. Comparing without subtracting
+	 * also rejects PDUs shorter than the iSER and iSCSI headers, which
+	 * would otherwise be parsed out of stale descriptor contents.
+	 */
+	if (unlikely(wc->byte_len < ISER_HEADERS_LEN + ntoh24(hdr->dlength))) {
+		isert_err("PDU declares %u data bytes but only %u bytes were received\n",
+			  ntoh24(hdr->dlength), wc->byte_len);
+		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
+		return;
+	}
+
 	isert_dbg("DMA: 0x%llx, iSCSI opcode: 0x%02x, ITT: 0x%08x, flags: 0x%02x dlen: %d\n",
 		 rx_desc->dma_addr, hdr->opcode, hdr->itt, hdr->flags,
 		 (int)(wc->byte_len - ISER_HEADERS_LEN));
-- 
2.43.0

