Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312C22472A2
	for <linux-rdma@vger.kernel.org>; Sun, 23 Aug 2026 03:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787456609; cv=none; b=K3P0uIBV/ZgzniZ/5lGvdfUOF4bhOy3zSbViCVxXmh9yu7mcBYNL0seD7Qzw5p5tqkipljd+SteujVQhoM0O0rUE5iRn0ynsqfCIRXbf2Eaas/K7vpnmp+eQMrd/qHlVmFiJ7aNNHGqaOqiHW0wL23jM1CH3H74oRI6QxXvbQFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787456609; c=relaxed/simple;
	bh=rofHdUejHXfVIrKrdDDGjtKfxyw0j4MHxSAoGCcba2M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H31Er0Sl+IouNAXyhh41zHMuGGLnd4v/CDTkOXrq8a7It/meyIsIPFOfpzGs770GqTtsdv0n85+0CSmNpSyXSO4JjGcffUBIz1aUv6IPVqYv+aBvZfeDnk2PGlt7pSZi7AK+PBVhjwsb+VGYmbYQdJwTxR4qW/N9k1qCxeV949w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=suXOLnP+; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="suXOLnP+"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so11176826d6.2
        for <linux-rdma@vger.kernel.org>; Sat, 22 Aug 2026 20:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787456607; x=1788061407; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NAfbRchatZWygfcqvUvUSI40xkRG8/daveyVQwPbjzM=;
        b=suXOLnP+E5+YX3Wg29cxJuW+qm5btqsU5HNnII2ltlnDIb8QmY/OsJ4EhoKU54XmLq
         cWA0UwAelXtpGzkHJj1JDhMu8l+8FvqTBrv34d8xMgyeFyMQUZ5NhoeScF74iNGvJHa2
         mP0ps/hnHrFfCKJ6g6Q8olQ02/1yYlfdsOhh+enYOaEowhXRg3PR6duJ2GyiI8RZL31W
         zQkt/cLM4/oQJmpqWooHIOkMgRlHvi1CzQ3oNDzta8nXQ6i7dfNfyy7egz26nonrl6eJ
         ytfoHZqFNW4GnGJ7Qg/8Fbd6Vxv7u8W12di/1WKch3rFa1DJdyDGcvgQz2jZT2P7gqds
         qw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787456607; x=1788061407;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NAfbRchatZWygfcqvUvUSI40xkRG8/daveyVQwPbjzM=;
        b=ZSKgj2NEQGm+nSsKk2/HSipjgtZ8QA7b/Fq4BlWj80hcPgeTKCxxJn94jGwMxDlZN1
         Vi2Hqp3IOA0wJy8LxkYg7Hn62yxQ2sZyQ0LMeW2xeGP7QO3CfdxWHWr5Xl1YJzOTSZcI
         PRxFead8AGkFakF/hHg+HwArYb55DUCXJUaTcZnr2xWBCr3bCQ/jsk5x/RQIpyuJYMNa
         rgqMrLnJK+k8nHIzDQLtCsjQAf+NRRE5AlD+heHh90/4Iq1AQfwkpznX1UiICRbO0uqb
         YRMYqFzSEOtc6KUcQLKazg9TSM59KH0GLNknHkdRcz0zKxDj8oFVz2uIik1df8MRwmOv
         9BzA==
X-Forwarded-Encrypted: i=1; AHgh+RquthB4Yn17UtGssqGDqw7bONa1pECe9Rn5iFJO/avFwB5QPNj+yk6VEXh0L4puiIAkk9+ggFN2ozx2@vger.kernel.org
X-Gm-Message-State: AFuF++lUwHgaQOwlGNGkMs3Tropxre9+tqCEsj8idd6svE1St/cX1/t/
	RvA71D22jvhHPtvZQSQ++WZ0OWPpokGoZEabzsBdY1UJWXwKDKGy9wcO
X-Gm-Gg: AR+sD11U6vrv3bT0tvtuUoKMjr1UJK2Fc18AJM1otziCMO7i9WYBUm9Joz/djTR9OrU
	yI03fWK3m1v8wOtM43XKK/uIirmocZa5pJjk4r4jMhTNrGdaEKkcoC3yoTQYWuyR8TxfKplSJZy
	nuj8ovKATSk/zKdE5jotyLJAoZZZtcssoFa9WONs7gewUOigjMRLH86TPpD4wJcuohYn5YccFmZ
	6qzPaI5c74EsbeRe0e7pidcCJqaG3RahrlRXZw7WS4dat1gur4ZMdy4sN1HUbtoejiXbG8KlWUS
	2QFzu9qi84YkDrHV142dR9UTe6TDsMgzxsmdCeKm+JGINukorzwxnd+lRAsdEON+vqikCqFJD6n
	twYj7w1EbTOqXVhaqTOQpT4NLdbe1LCJjeZNQxrCSTgXBeiEms591E+I+msFHo9TligCxrY5r61
	JfVirr7mEw/YTDC3Da2rvuCXClly/cGKnrwqiEc9j/XiHNS5A9xvwWCUF5GPy8UhpQTZbaDqvKk
	EljpwXJeDNJNwwvGZtgpJ3YQRLdQxzwtH0ZDg+0OVZnzH10ILVltFOE5py/AxJD6Z4KzyxP/V1s
	91q6W9w=
X-Received: by 2002:a05:6214:4113:b0:8df:98e0:4594 with SMTP id 6a1803df08f44-90c80c5c09fmr164598746d6.15.1787456606991;
        Sat, 22 Aug 2026 20:43:26 -0700 (PDT)
Received: from hedgedog ([2607:fea8:260:d500:60e9:8830:c11a:f2b2])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c935fbb5asm28276236d6.11.2026.08.22.20.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 20:43:26 -0700 (PDT)
From: Ryan Mehri <ryan.mehri1@gmail.com>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: Ryan Mehri <ryan.mehri1@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com
Subject: [PATCH] RDMA/rtrs: guard against null kobj name
Date: Sat, 22 Aug 2026 23:33:43 -0400
Message-ID: <20260823034303.163403-1-ryan.mehri1@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the client, if `init_path()` errors, the callee tries to clean up
with `rtrs_clt_close_conns()`. However, this can lead to calling the
event tracing code with `clt_path->kobj->name` being `NULL` and thus
causing a null pointer dereference when trying to copy from it. 

This just adds a guard to check that the name is not `NULL` before
copying from it. The server appears to have a similar pattern.

Fixes: 5a93929d9f9a1 ("RDMA/rtrs-clt: Add event tracing support")
Fixes: c16762b7bf54d ("RDMA/rtrs-srv: Add event tracing support")
Reported-by: syzbot+1695193198994f4e7fed@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1695193198994f4e7fed
Signed-off-by: Ryan Mehri <ryan.mehri1@gmail.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h | 2 +-
 drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h b/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
index 7738e2676855..29e23404bb7b 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt-trace.h
@@ -55,7 +55,7 @@ DECLARE_EVENT_CLASS(rtrs_clt_conn_class,
 		__entry->max_reconnect_attempts = clt->max_reconnect_attempts;
 		__entry->fail_cnt = clt_path->stats->reconnects.fail_cnt;
 		__entry->success_cnt = clt_path->stats->reconnects.successful_cnt;
-		memcpy(__entry->sessname, kobject_name(&clt_path->kobj), NAME_MAX);
+		strscpy(__entry->sessname, kobject_name(&clt_path->kobj) ?: "", NAME_MAX);
 	),
 
 	TP_printk("RTRS-CLT: sess='%s' state=%s attempts='%d' max-attempts='%d' fail='%d' success='%d'",
diff --git a/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h b/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
index 587d3e033081..a7d7b971e6c8 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
+++ b/drivers/infiniband/ulp/rtrs/rtrs-srv-trace.h
@@ -61,7 +61,7 @@ TRACE_EVENT(send_io_resp_imm,
 		__entry->msg_id = id->msg_id;
 		__entry->wr_cnt = atomic_read(&con->c.wr_cnt);
 		__entry->signal_interval = s->signal_interval;
-		memcpy(__entry->sessname, kobject_name(&srv_path->kobj), NAME_MAX);
+		strscpy(__entry->sessname, kobject_name(&srv_path->kobj) ?: "", NAME_MAX);
 	),
 
 	TP_printk("sess='%s' state='%s' dir=%s err='%d' inval='%d' glob-inval='%d' msgid='%u' wrcnt='%d' sig-interval='%u'",
-- 
2.55.0

