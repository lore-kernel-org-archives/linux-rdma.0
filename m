Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794823880;
	b=Ch5gJ2b1h35JZr8qi4IyGwx+D4CTQjSNi1KSq/M0m2Bd6CZz1MaoElL9yeAvnoBETuDv
	 rHekvPLnJBZEkDHnAQIa6rEykEShwj6qLX/d999xHV376q7lQguqcPpPnRdArQR+/9+fa
	 vhX7TXoforvnawoSTRp1MGNNjnc7pbsGu9bVWAjlddLxHK/eJt19C6IcTkGFP7i8YzAkr
	 qxSJMa4NsVy1/I8ZoxgDS9g/c0WawLtrTeiDSOsljaxNz31+mPA0BgcYDm6WrQ39pyUkf
	 Oc9qjVIoxUOBdpMBdde5zhvxMG1ZJ+Qgx67HjPSgVwOyTxLKxFkgYQlLKB9VmsBxkTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794823880;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gIfgCrbgWP+O7J1dWGPslYkeZ9aFum9ZTgaeYRl4oTQ=;
	b=Y3xVF9N3Bziu6dLqhmZE2mUJw3EH0lIk+h/cQ4JhjtMAAni8IA9J8Sei5cjpRhUaYlrI
	 nmXeCFLFA/B/Wro5vAYEA3y8vR/h90IbSMMI4UezsDPxz4/jY5VGv/Ot4qfkRHfuTPLcX
	 cti9RJMOrkvbnDvStmZ3yC4s7/Tj68Rr03kHZ1pJg8cTonBY9UKTwj4UGrhfp2yJNl8xO
	 eHwxVE2s1dpEUCi/iB9A18WBNWAZgHHitY5bX0xuJQpLKw08hWCHFb/A3EYJiWvUYwt4X
	 np9CvO5dkujDiKTZ9U5EgM9SNqfNuATuAO5N2iKpK5nCGGNlreJgyaimzvmJ3o5buZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OCB6XAfd;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4470E606A336
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 10:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4470E606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=OCB6XAfd
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2eddafe648aso21268335ad.3
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 02:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1794823880; x=1795428680; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gIfgCrbgWP+O7J1dWGPslYkeZ9aFum9ZTgaeYRl4oTQ=;
        b=OCB6XAfdUc5s0FIoYt6+yjDyITD7EIoOFHulkz03GRmgPZdWkYgAmmFPBLmBgISuvG
         dlm0YB3Ij428Uz5sPUHFyOUKLsyIo7SHUka78fzxljkttoUrDaVHoZDRdk5fY8JtJWno
         T3JKboSNGx542jV1xu1WEQiTlVNN3hH7WH2TyY9TyLGsCyCvnLyHlMTE99OoDi8bvLDQ
         Ann8xa9PcUJqFYKCASqGQuj8HXd0SDUAgdTNpUmxkkJ7MLVxvwK411y2HvGro+Vqhurc
         IVkkFiCDoK1hu3kvAIx30RQR5MRUm6h7Y+Ja7TphHPuXQ/8vP4JeKsBp+99Eckmu9xpI
         1LDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794823880; x=1795428680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gIfgCrbgWP+O7J1dWGPslYkeZ9aFum9ZTgaeYRl4oTQ=;
        b=JuWKQWe23IhHMjNxhiDHWFFLr+DAA46Y+h7qxjamGi1vnLEGMBijtZsUIgsCR9c+YF
         8x7YjbyVuvzWCwiyEqw5S+zt4s0f0Vy11B8+lYJRnm1ChoHzWTLfsK/5rjbEMfLvIgkQ
         YQjYSF6OP6iYXGbxyfSoriUnzC5Hs5EC6Ut0CgZqRz9UWwLMIP7gMjrofjo+N+dJLG/V
         r90ndeAdlYE0o7TOWZu0VQFtf/bh16ow9OnA1ehG6WKfdWgqLVkOGbI57Uf9dHW+w4P4
         rTaoxXo3czmCq0BGBtEK20VVxo58LDwTrToUnMuQMj5JJbHsFrD39bjkGrDujlDDpfDY
         i/sA==
X-Gm-Message-State: APuU4Z/FXmbjGZM0E/HWzYfdFZrXAXbctCyG4WbTLxXi0/lP/UhmTh2/
	m5Q7XkHadvDQFN0XOqkzviyr8A4cgNTVgxFDSMQcHfbZWn/H2zC3NN0drf+FsXtWexM=
X-Gm-Gg: AZFdTZfeAz6rcUzQA67dDEb2/nJNCHMTWw1j5Tge/UFbMMjHttFI5xRWROLkrLVpuhf
	T+aDnOWjmPgPvUE3YOKUmrK+sb7lSZJV0CGyXoYtdLspDyE5iHMmsVFgI8MQwjiar54HvZZjJaQ
	djJU82VvVyY1mlbix+wcIjuwpW2AM+1FNuiRv6fwSp0IgaSySrPqWAgN6Fci0hF+SxIIlfL5u5J
	L7FT5qScig+t0A+hoYOhtY9aozcNHrZyJr+5W3BAQA/mMaaumx2fI0ABhg2aJ/7inq1O4JC1Bxi
	pm3Yu2WmyIQGqvuXeIG1iFDEu8Bz4JgVaK6Vh348KeoZMG0W+BkmYwgsnI2U1DDNr0J4QHlxzik
	FpZKdZd6AFhfaahU7bLIp4g+BpOWkAjxcX0AdYu6GeAUQikNcLO+vwiNUDET7xSp59jlFR29Nsf
	Q4XI/dr4Yqn0k4fpzNVdjTRonitz+zrwb/tX062f70yd6GMgwUpRzXInzqODCmgrWIojO4rpjZR
	sNbef20BBusp9034h+BohlwE8AzvDWbtaZ2oy51i6Ey7NFCKzCloMGh66Zh5+w+72w5fM4JaqA2
	taCvrVoa0Urz2K2mh7xuvhyfWE0+J1xOBZy9+aolAcRpevhLPgVtGRWMwmeUAO6gm0QP6g+kR4l
	a+XKgqUlYRS6G22unl8VYuPO1604wxyBcKvG98A==
X-Received: by 2002:a17:903:1446:b0:2ed:56ee:af8f with SMTP id d9443c01a7336-2ee0d65fb69mr101733635ad.2.1794823879687;
        Mon, 16 Nov 2026 02:11:19 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:35d0:694a:1071:9bae])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f7e5055sm35533795ad.39.2026.11.16.02.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:11:19 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] IB/isert: do not leak the receive descriptor of a dropped Data-Out
Date: Mon, 16 Nov 2026 19:11:08 +0900
Message-ID: <20261116101108.1650132-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
References: <20261116101108.1650132-1-yhlee@isslab.korea.ac.kr>
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
after exactly 128 of them, in all 3 runs, with no response to a NOP-Out
sent afterwards and nothing logged beyond the per-PDU "Unable to locate
ITT" message; with this patch all 200 are taken and the NOP-Out is
answered.

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
index 81164881dcc241..8a57c880335cc3 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1130,17 +1130,16 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
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
@@ -1158,7 +1157,8 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 	if (page_off) {
 		isert_err("unexpected non-page aligned data payload\n");
 		dump_stack();
-		return -1;
+		rc = -1;
+		goto repost;
 	}
 	isert_dbg("Copying DataOut: sg_start: %p, sg_off: %u "
 		  "sg_nents: %u from %p %u\n", sg_start, sg_off,
@@ -1169,13 +1169,18 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 
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

