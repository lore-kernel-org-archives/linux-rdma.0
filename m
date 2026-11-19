Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795094244;
	b=GNukikdEqMj2Z5+KlBvMz/fH5Y9kzPRhBiXb1Y6xko/J0+h4KhWqLSmt5OV4w54jfN1J
	 kgTHoGq5nBwsp/MKLjGAmcdYoPC/Ni1SqLxXOdXhrUEJ/qz4Pef5ScHLMC5IkBpyim24A
	 x3e6xVx1JyOwx24BmIBd+Yeon9fJCNzbI5h/M1vDs42SEhdsrmvmqSlfd6nmM+of5O6A/
	 6wySyTmLQfJt/lf1eGjfm7U4g/XvvrzehOVXn1ec9F7KoRucBKTw+l80PGwhFyZ8Vyybe
	 8jEqhomdJJHqpI7MRdiNKsgjeBrTC/vC34R4MuKMLyO+T2yrMnKh+f9YTBTgqS4RJjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795094244;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
	b=JU0K37BhA1aRupvgx4VYESDvlGqLH/8fnP02ScDPxKQm/k/bMrc1AqOHJZR0XtongB20
	 VPQIMkEIXTSQLR77ftewUVMs1HmavS3EyrgstI6qO2EOs0sWulfrge16Kit3dBQJGotSe
	 30BLdIRNKfoRAcAVgysjqxDmrDE2TOs9yZyLc21PSCsvbdlkdIE83h/QRAT27OYPO5BzQ
	 dU+FztvFqwfQz2PYy1q6cnnrornKLPCFbF0EXAhHJDCdJx51c2KrKPVgOopIxbnwEkHuQ
	 4IYSxnORq/n7Rks1AQCXi6dFXjAL2BiKEUKk1tjbAC7VRyi/7wnVHe2BE4KSYhXWGEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="dMc79+3/";
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D28360A2634
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 13:17:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D28360A2634
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=dMc79+3/
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b5a6f2f27fso1085039b3a.3
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 05:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795094243; x=1795699043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=dMc79+3/bbz2dq/bJUjd6kyg4QIMok8By+PE3QK8cvP6ZawvYbZUM2YRgN4WmchUGo
         9cMCKmDqt7cBFOeH6A4qxfuGvgJnyvlamjSTmtMkbWxM+xGEcWswf4ZwbqNsl/SvPaXy
         zPCk6pxp4IBpZa9hNMp3Davj09P/kLs6qcW89RuyrDEv4GBJLHhEgHUb3s/9QOeiRu10
         +T1LfJVBnstPqqdz/eTr2mBE0x3w+PivdvlePMqVqEjGmyph0JKJ2Bjvo5h4Ir/IXDbs
         wEqNgxOUUlKXDZICvVHa1OEPQ2Gdn3oAoytRqBZpg4RRBT9Zd6vWlCR1UIjho5DM5SX5
         vbkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795094243; x=1795699043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1F5PhsVSMvlAKbqeP5i5JDJo+bg6gq7qbiCDaCKQio0=;
        b=bEM1Vfm/PGKWX7F0Wrab1sdsTMa3tdQ+ixLJSPsl0QHgqmod8RqyPEIStpKOLG4ZQu
         X8zHNCzYcZqqWk++wL+IbiJj+6eWadZ67CksFgdxLTe5iYXMWQuvtFZnCAtmDx1NcnCa
         7q2D3sq5ZiE/sHFF6QyE2KiHXMsB+xAYDwrRjH882Mzv6nfWXl34AlXA7E3Pvc4EslC7
         4OJDZuu0AWolSf4dsObEihI0OfGws93J+Iaj25q8zAEK1KGOtto2diZPASu2m1OTJvep
         DU/K4R0SXkvjcqSi4jMDOluJwOKoi7NWcMa3HeP84+O1ExxdOKd77doQB1XntKvF3VPO
         gfYA==
X-Gm-Message-State: APuU4Z+asHDlvp7L+lLv98KTaOJt/vj51TAbL3Xp4uYN+qoJDO1cVUiK
	Yt3eNmB0vqIbd+rFXRynyUuxWkNYsijmUmQr803KwmJ+B44dwSRDDdV2YvmDv+N+REM=
X-Gm-Gg: AYBFou32dkHbhGFee7u0Kq6XrEMqrjVnjeBiOgsz5nztZTfCh6p69XdfWv9ugU/Kt/V
	q4mdjXRikZUmToGZAgybgO6TMnaRyFCDslrToLUuQmk53IaI0uQqkgaaXzfILOT4839UfolUBtC
	4K4tqZPxNrvwrXflmVJNXtYPZUg3UwxGB33XW9k77kFLROqSoO6PvI0byGACz57Tb6uN92aV/58
	lSQLPGYfwbYrU3oPPPBn/7xBn0rPrAPj2A2lav3i9muQQ9VUdhtjXfYlhEpo0ArArVwb/ZKP5rP
	UzKwG2yywkAAz/jqJBOt9MLWzPVLM1wB+PwiTklpbFP9dheSaMSEgCV18YLL1UZOVzVjC9kWI93
	Yb6HX1GlkZGEdsjTLyz3Hk0YHqxmrAn+WGM2mP3SD6whbzNnImEojEWg/lkCrnCk4v1aq7vRUdl
	W0qvTvHy4OKV/0RorfWeqXCyoyGAaX1WNjH+VLAvTySXXpFVLg7MXfKBKpKGNWy96fvGS2lP0bX
	kzmfJmZYzOB5wWEZYC2Wr8XDnF30/n8FXKXaBQjo9wleV2girLZWtMwAToc/StarSpuKAL5Tp9H
	LLP2AVENnVmiC5P6EET83Uuerac082NGLhSC46dUFBBf2tajHXd/Vz3DGjgrXMhzsXCZO0HGhHv
	tnwv1B/DI/XVOROfEVDDvJkgRv2rDvOFxI0AaVA==
X-Received: by 2002:a05:6a00:230c:b0:8ba:f51a:1bc1 with SMTP id d2e1a72fcca58-8c5d3639dadmr5519001b3a.24.1795094243488;
        Thu, 19 Nov 2026 05:17:23 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:1076:1f1f:dde8:a816])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7f99f91sm2809467b3a.5.2026.11.19.05.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 05:17:23 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/4] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Thu, 19 Nov 2026 22:17:00 +0900
Message-ID: <20261119131700.2722108-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
References: <20261119131700.2722108-1-yhlee@isslab.korea.ac.kr>
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

isert_handle_iscsi_dataout() works on the command it finds by ITT, which
holds the descriptor of the SCSI Command PDU and not of this Data-Out,
which is why the function posts its own descriptor explicitly when it
succeeds.  None of its other returns do, and isert_recv_done() ignores
what the handler returned, so each such Data-Out costs one of the
ISERT_QP_MAX_RECV_DTOS buffers.  That includes the returns where
iscsit_check_dataout_hdr() answers 0 without a command at all: 200
Data-Outs carrying an ITT that matches no command stop the connection
after exactly 128 of them, with no response to a NOP-Out sent afterwards
and nothing logged beyond the per-PDU "Unable to locate ITT" message;
with this patch all 200 are taken and the NOP-Out is answered, in 5 boots
out of 5.

So give isert_handle_iscsi_dataout()'s other returns the same post its
success path already does.

That one function only.  Everywhere else a handler returns non-zero, the
command isert allocated still holds that descriptor and the response
posts it from isert_post_response(), so re-posting from
isert_recv_done() would post the same descriptor twice; the second post
is skipped only while the descriptor has not been refilled, which is not
something the receive path can promise.  iscsit_handle_logout_cmd() even
returns 1 for an ordinary logout.

Fixes: 4366b19ca5eb ("iser-target: Change the recv buffers posting logic")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b7dcfc5f88b916..804148ace398aa 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1141,17 +1141,16 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	int rc, sg_nents, sg_off, page_off;
 
 	rc = iscsit_check_dataout_hdr(conn, buf, &cmd);
-	if (rc < 0)
-		return rc;
-	else if (!cmd)
-		return 0;
+	if (rc < 0 || !cmd)
+		goto repost;
 	/*
 	 * FIXME: Unexpected unsolicited_data out
 	 */
 	if (!cmd->unsolicited_data) {
 		isert_err("Received unexpected solicited data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 
 	isert_dbg("Unsolicited DataOut unsol_data_len: %u, "
@@ -1169,7 +1168,8 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	if (page_off) {
 		isert_err("unexpected non-page aligned data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 	isert_dbg("Copying DataOut: sg_start: %p, sg_off: %u "
 		  "sg_nents: %u from %p %u\n", sg_start, sg_off,
@@ -1180,13 +1180,18 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 
 	rc = iscsit_check_dataout_payload(cmd, hdr, false);
 	if (rc < 0)
-		return rc;
+		goto repost;
 
 	/*
 	 * multiple data-outs on the same command can arrive -
 	 * so post the buffer before hand
 	 */
 	return isert_post_recv(isert_conn, rx_desc);
+
+repost:
+	/* Nothing else owns this Data-Out's receive descriptor. */
+	isert_post_recv(isert_conn, rx_desc);
+	return rc;
 }
 
 static int
-- 
2.43.0

