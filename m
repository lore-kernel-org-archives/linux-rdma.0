Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDE52D248B
	for <linux-rdma@vger.kernel.org>; Mon, 11 May 2026 06:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778480519; cv=none; b=el4LNI6q2JreO6DhbrmVcVvIk1r1oVve3egY0jYD+fvWhYZTzapcUjo3/j2NiTsIQX+QotCayrXuX8VQiD8kefjPXLWI8kVuWSp1t/YxvJNNU5yzzLUtYVf6LnZmMXU9rUcFC3bvLeNHqConj+FkVCNb9ZFcN0oSaul/RNGzA7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778480519; c=relaxed/simple;
	bh=A7y3fzKCF+AJo3foiCNqQdkebzrP/Mi0PRjx4WBSn84=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zvv3/CoBxN31o2klME97dVL0wbch7HvBl3nCyFXVIFXhaYIqQ8u7EJSEN5jgy1CpGHRgin0dTuDZIXDLuu1wLIZc2+EH6jSsukzK6MZvQsWig90WlLbV+VnDZZ4Zko+VQWuRRv3OHkkhmDPzCiI1Hh/whSAx02/lds1X+ANV53c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=NBqYZFdh; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="NBqYZFdh"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12c8ccc7755so5459993c88.0
        for <linux-rdma@vger.kernel.org>; Sun, 10 May 2026 23:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1778480516; x=1779085316; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cLVkZzC6n6tfb7crw+XJ4fgX5lyHGF1s/SBlI8VZgbc=;
        b=NBqYZFdhZq+RQK96TfcXFzU4STpoQTG0rofHiPtAuknXhXQH20V43EsufTJWZnLn49
         PkWK4MXWjFjAcEhxyoHsDS9Gzh1iW7okoTs2izRAx2oEhZLYNNqZFr9lRNp/NBzHNxRg
         4r2afnXeb5cSpUZyFzEXfuxLkeiaKJB0tT5QcDk1MtEVKG9MCfZVDZq62OypBr5vhVO3
         HnKgW+zyLjoPE4hRy6M1Y/dGXySjSl3Rq3kLOKFWccGJs4XfFnJ+lI+EulOHJLqOZWHD
         Pif4qIWzIOOmKDjWKH7Hzd8kZgAm9q5/fWXxyi5/h2tCc86JYwK+DpMP59uGlMhQS7BO
         ZP0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778480516; x=1779085316;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cLVkZzC6n6tfb7crw+XJ4fgX5lyHGF1s/SBlI8VZgbc=;
        b=egBQw0S7s7rsAb3MkyADaygzIYP/RlD2skpCVLWxUi0sHOoeqmtY8wKB7VsbpQOgtt
         17DaFF00RCLbr89950sDVkcNbbvls9t/r/lm2jDaZTLyWXRCrBDojjYg2zMfcBQc1jIP
         h5fr8ysVVMp9RUs7HZHXt53MctNryPi2h80dMEWspg/ej8zw+yUQtAt6g+kLfWYVeeUj
         pWAV/L2Lz1iQi5Icwyn5TdguGtEUe+MXrHxQt7SS0MoJbTGHS5h7fB4J+AByZ1nuhTmG
         H9rOzEgHorNIYA4A/gsnv00BZc2fTWbwdvRSzgl8Iom6Ob+RYbvJH68w0C5rFC/ur7/u
         LxYA==
X-Forwarded-Encrypted: i=1; AFNElJ8jO5B0GnOCCAOQg/tfeAreobpNyTXuDKspTSdjnkW+t/OEi2mSv2HSMobPgR3+GfVHykpx+cx+I+nN@vger.kernel.org
X-Gm-Message-State: AOJu0YwauGP4QXeaa4tOtfe8cdYZwdg4flpmccAMTewk6jFal6ORaKBf
	jbmM2BX6oOxzyfZd0NUtXdupk5a5hionaJT5C7mUqX5mK8m5HE10ltCDmBNi2DwOMg==
X-Gm-Gg: Acq92OFfEskixdoZJpP57q2AFW1YyXhQvtkgJ4ah75yn+/51MIEpojcu6dYlwH1xVV1
	78ZsFEvU2gqRYSdUZ7gJZdpHBII07nBcMZomeQZIriqUwJMmwMnYMP27THwtiKUqogyGHdwnmis
	8tESl3NNLdTgDY/WnQ2JJgIxK05f/+JG2n0iEGb3Zgg+17VQDle9JrK954zO1+xZSuCM7tmBqEu
	bYe9Hz7e4ZrfN4xcdPzpJ6xlqkP8Ea8DF1+sqYrGzJnkeSG6dcEttUtw0z0154W9PHnobffvwoR
	5Kx/FNGiun7FphlXZqc7xHTFUM58hihhrq05K/Qpm6u7l5R/UesK7uGCPkfOq3DQLbQpoVeQqwp
	S9bhLTQwMMHdZ7eeGjcAlFSGERjFOo2w8DpYTl5FFfYNwnXFhJBmRdHVn/0boAEJR+i2GkLwKqb
	H3CI4pVlQGopOotpj3LPC+xUUvNstkAAnFT5xnVSpYSef4H328W7KEtw==
X-Received: by 2002:a05:7022:439b:b0:128:d24a:a5ba with SMTP id a92af1059eb24-132a83f77d3mr4278742c88.20.1778480515748;
        Sun, 10 May 2026 23:21:55 -0700 (PDT)
Received: from p1.scai.dhcp.asu.edu (209-147-138-15.nat.asu.edu. [209.147.138.15])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13278210d40sm16083102c88.4.2026.05.10.23.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2026 23:21:55 -0700 (PDT)
From: Xiang Mei <xmei5@asu.edu>
To: netdev@vger.kernel.org
Cc: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	ubraun@linux.ibm.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	bestswngs@gmail.com,
	Xiang Mei <xmei5@asu.edu>
Subject: [PATCH net] net/smc: reject CHID-0 ACCEPT that matches an empty ism_dev slot
Date: Sun, 10 May 2026 23:21:38 -0700
Message-ID: <20260511062138.2839584-1-xmei5@asu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the SMC-D client, slot 0 of ini->ism_dev[]/ini->ism_chid[] is
reserved for an SMC-Dv1 device. smc_find_ism_v2_device_clnt()
populates V2 entries starting at index 1, so when no V1 device is
selected slot 0 is left in its kzalloc()'ed state with ism_dev[0] ==
NULL and ism_chid[0] == 0.

smc_v2_determine_accepted_chid() then matches the peer's CHID against
the array starting from index 0 using the CHID alone. A malicious
peer replying to a SMC-Dv2-only proposal with d1.chid == 0 matches
the empty slot, ini->ism_selected becomes 0, and the subsequent
ism_dev[0]->lgr_lock dereference in smc_conn_create() faults at
offsetof(struct smcd_dev, lgr_lock) == 0x68:

  BUG: KASAN: null-ptr-deref in _raw_spin_lock_bh+0x79/0xe0
  Write of size 4 at addr 0000000000000068 by task exploit/144
  Call Trace:
   _raw_spin_lock_bh
   smc_conn_create (net/smc/smc_core.c:1997)
   __smc_connect (net/smc/af_smc.c:1447)
   smc_connect (net/smc/af_smc.c:1720)
   __sys_connect
   __x64_sys_connect
   do_syscall_64

Require ism_dev[i] to be non-NULL before accepting a CHID match.

Fixes: a7c9c5f4af7f ("net/smc: CLC accept / confirm V2")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Xiang Mei <xmei5@asu.edu>
---
 net/smc/af_smc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 185dbed7de5d..12ea3b6dbc64 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1400,7 +1400,8 @@ smc_v2_determine_accepted_chid(struct smc_clc_msg_accept_confirm *aclc,
 	int i;
 
 	for (i = 0; i < ini->ism_offered_cnt + 1; i++) {
-		if (ini->ism_chid[i] == ntohs(aclc->d1.chid)) {
+		if (ini->ism_dev[i] &&
+		    ini->ism_chid[i] == ntohs(aclc->d1.chid)) {
 			ini->ism_selected = i;
 			return 0;
 		}
-- 
2.43.0

