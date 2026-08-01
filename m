Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E783B635B
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 09:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785577359; cv=none; b=HIdRS4GHZtI1Son2Wn8y/lL5A/Gu1sfoYHiPVxd46GCvVlboOfqUnXopoH+gyfM7AldD1OkNak5avdhMF/30pmPGz0lzy7UhyFnKQRY/yFfohlxA+7qMdaoKLlFhzMLaBkUXP7GrbUCnVYCwHNUUKEBoiyq1igbeNSSE73myKk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785577359; c=relaxed/simple;
	bh=q5UEPjHCTM3HJeezdrQHBgApF6M5fV7Fh+3R+qmBDNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGjqjdUvXyP4DBBlMWeuuRhcI/X7tLYW8fmGxbR4JHUiC0kuL7wpouZ2lJNlnatK7hbWy9h7OicK+pUocOzx2rzEsHKzn85v0d5UIxcvLzu4ppmnHVobh63qLt6meBimz5FTNVvz3YpQcW/eFek/8VD5lYj/0Ri0E53TbEIa/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=RPP7wGPs; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="RPP7wGPs"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cca0c5799eso15702785ad.0
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 02:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1785577355; x=1786182155; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yz1oRNcg19iVfX+eVJWelaG34L/oIKLecIITUvBw3oY=;
        b=RPP7wGPst9eodJlskofJOoAey0kzAW7k0FnhPBzFXqfCkPn+PT4RHqTfXPCXjFickL
         PYcLPVA0fdap+OWhQfIgA5oQjioAQinDhJG8bs+SyVeA5mODu3RFsV5o/H2Hp0Xnp7ZW
         60Fz+OyoN6+/XFF0WGKHjt3NrfU1AFZjItUdsWw+mt4xiTCM5WVArhwf0qCjONJO4sQk
         fbZaSxiTdqAfm/9A4YmlPVGsDDP1EIzWGCnp+Z+EAz4bvc49tPB/ZB45v3Hd58178R8K
         S2P/nz0+rbjW8IUmVOJXMzINA4zCDCO/+sCoTNzmmlFc/zJrAqqpiqRmvyugB++wGTuJ
         oDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785577355; x=1786182155;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yz1oRNcg19iVfX+eVJWelaG34L/oIKLecIITUvBw3oY=;
        b=ZCs5G2iVyB/YP3CAkqGP0kFMCQ0YWo5URjSMoo9mcSMpBy24hHx5ub/F8G0FHeCiAH
         bdRqCyJQbnfFWYrkgzFCSqoQZqfeTvve4W9ta8qQDA+XPPzySIDEir70znnhNO9f46q+
         iffxKmR5CHYB6qKGV2j46bpva/LLSZWJ5TiSNp0c8HRqv02l19+LNjjGV87QmtxBURi2
         vIM+inh9AMGZztPwrVuhPGWkNneacJj/38QRHHBmfC1tx3E5KYahkz0RgmAyGZqgod7W
         U6BgrgleW5iMaOymKZWR8EYbw2ZXtct5UqD6k3PcQKGpqJ/sBcVX0GE3PYHZ8GiVv0Te
         zP3w==
X-Forwarded-Encrypted: i=1; AHgh+Rqie7uSUYjJ/8HnM1K+Jwt+99vyBJzFB5FsVRTzcAPZdpYcOIpAezl3TSqP0IHf2w+cQMl97oL17dgi@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzt+NM5wtNqJ+LudWYjODzjeZi6nmtlFbZWI8MbG7MqLi1/LmY
	/dwoEbIshJrVnP1s2j88iJeYR+1Xqm6DVbzh2L89ywhviNevjDAuhKEsluGHdGnav3I=
X-Gm-Gg: AR+sD110CWJTHok8Fcn5lFK3UYrsnEJkqtkwUOhCQ2K1YTpI+Mutd6m/6NwazGDoU0l
	vWvzdUxGbMygSu0Q35xhKgIwrk4mgLJQOD3T7VD8AtXQWLW04YqE2Hoy4ACNV8v+QMsW+Pg4KP3
	B8iHH6akw93fopRkGl+T6/rqir0ws+2syawRZ+bucPXn7SmT5/DP6+W6jy1+NznTTw/ZyYaSBvQ
	UWeab1o25j18Smaogip9lviPF91tiWpx6HuEUVRt0H8riwaRpFJsaStS4eLcyJ6G00oj/onTLi2
	L89uR1y9jMXb7S6OCkPzSfGNQW9XzL0OwtbiqjUfOD4NPn/lIlLXjhFoDX7mx67mUGD2/0RCevJ
	sgnCGUF51s+fEkij3W/aHUAKcEOHVFOjriT+VrXsVmZQIq+JjuHf2jYB8m1OC6ukcNOuxOpvKjg
	DGwr2SdakFjDTgVZ/sQt72ds6wmVdkseVHev2MLT/g3M/PYR0E+tFgXvH/f3yBpbXOtibyMBNVs
	6uAXOXaqSM=
X-Received: by 2002:a17:903:2442:b0:2ce:d34a:5963 with SMTP id d9443c01a7336-2d05229870amr27434675ad.24.1785577355171;
        Sat, 01 Aug 2026 02:42:35 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c329:7b28:fe02:5dc8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b0eb486sm16006465ad.53.2026.08.01.02.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 02:42:34 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	wenjia@linux.ibm.com,
	kuba@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: horms@kernel.org,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	guangguan.wang@linux.alibaba.com,
	kees@kernel.org,
	gustavoars@kernel.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH net v5 1/3] net/smc: fix use-after-free of the LLC qentry in smc_llc_srv_add_link()
Date: Sat,  1 Aug 2026 18:42:06 +0900
Message-ID: <20260801094208.1937951-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260801094208.1937951-1-yhlee@isslab.korea.ac.kr>
References: <20260801094208.1937951-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smc_llc_srv_add_link() keeps add_llc pointing into the queue entry:

  add_llc = &qentry->msg.add_link;			smc_llc.c:1482
  ...
  smc_llc_save_add_link_info(link_new, add_llc);	smc_llc.c:1494
  smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);		smc_llc.c:1495
  ...
  u8 *llc_msg = smc_link_shared_v2_rxbuf(link) ?
	(u8 *)lgr->wr_rx_buf_v2 : (u8 *)add_llc;	smc_llc.c:1504
  smc_llc_save_add_link_rkeys(link, link_new, llc_msg);	smc_llc.c:1506

smc_llc_flow_qentry_del() kfree()s the entry, so on a link without a shared
v2 receive buffer the pointer handed to smc_llc_save_add_link_rkeys() is
already freed.  Before the Fixes: commit that branch always used
lgr->wr_rx_buf_v2 and add_llc was not used after the free.

Detach the entry instead of freeing it there, and free it explicitly on
both exit paths.  The reject path has to detach as well, otherwise it would
be freed twice.

Fixes: 27ef6a9981fe ("net/smc: support SMC-R V2 for rdma devices with max_recv_sge equals to 1")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
Reproduced on an unpatched tree over rxe, with KASAN, kasan_multi_shot and a
link forced to max_recv_sge == 1: the entry is freed and read by the same
call, and the freeing frame is smc_llc_srv_add_link() itself.

  BUG: KASAN: slab-use-after-free in smc_llc_save_add_link_rkeys+0x333/0x350
  Read of size 2 at addr ffff8880052194de by task kworker/0:1/11
  Workqueue: smc_hs_wq smc_listen_work
   smc_llc_save_add_link_rkeys+0x333/0x350
   smc_llc_srv_add_link+0xaa2/0x1e50
   smc_listen_work+0x489e/0x4d00
  Allocated by task 48:
   smc_llc_enqueue+0x72/0x560
   smc_wr_rx_tasklet_fn+0x474/0xa80
  Freed by task 11:
   kfree+0x121/0x380
   smc_llc_srv_add_link+0x9a8/0x1e50
   smc_listen_work+0x489e/0x4d00
  The buggy address is located 94 bytes inside of
   freed 96-byte region [ffff888005219480, ffff8880052194e0)

The offset is past the 72-byte queue entry because the out-of-bounds read
fixed by the next patch is on the same line; what this patch removes is the
free at smc_llc_srv_add_link+0x9a8 happening before the read at +0xaa2.

 net/smc/smc_llc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index 954b2ff1815c..90746cd1e29a 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1481,7 +1481,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	}
 	add_llc = &qentry->msg.add_link;
 	if (add_llc->hd.flags & SMC_LLC_FLAG_ADD_LNK_REJ) {
-		smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+		smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 		rc = -ENOLINK;
 		goto out_err;
 	}
@@ -1492,7 +1492,8 @@ int smc_llc_srv_add_link(struct smc_link *link,
 		lgr_new_t = SMC_LGR_ASYMMETRIC_PEER;
 	}
 	smc_llc_save_add_link_info(link_new, add_llc);
-	smc_llc_flow_qentry_del(&lgr->llc_flow_lcl);
+	/* add_llc still points into qentry, so only detach it here */
+	smc_llc_flow_qentry_clr(&lgr->llc_flow_lcl);
 
 	rc = smc_ib_ready_link(link_new);
 	if (rc)
@@ -1512,6 +1513,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 	rc = smc_llc_srv_conf_link(link, link_new, lgr_new_t);
 	if (rc)
 		goto out_err;
+	kfree(qentry);
 	kfree(ini);
 	return 0;
 out_err:
@@ -1520,6 +1522,7 @@ int smc_llc_srv_add_link(struct smc_link *link,
 		smcr_link_clear(link_new, false);
 	}
 out:
+	kfree(qentry);
 	kfree(ini);
 	if (send_req_add_link_resp)
 		smc_llc_send_req_add_link_response(req_qentry);
-- 
2.43.0

