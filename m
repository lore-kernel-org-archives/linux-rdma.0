Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795444649;
	b=eIEqjjCIykiqPhSrpEaEvsi3YSbEFOMIfVnn4SEAu6X7C413F8Bqv7cinMqs49XyTAQt
	 HBUA0gMZbUJnIgYy/LKJTO6rT3Nv6AhAb9myJe5/PtDFKVO6arQUjHkpCWz/8UxplJWNx
	 Y5lJYyuAZFe9pFqFxkAVQ/rYW7aR9erRh/aYTmp7Fofyczy6/6PGJ2sX2cEcUNteQRNMi
	 VU89mKb/VBndvfs3JwpxokrtOaBIWfN06BXrsNNtptWvlMgBH6lMzdfdWNsMMEXVW3cBk
	 h0y/y17xGd7oXqzzv/li9vXjZXqMQd1jIy4IQlQE1WmO1HrJiTTqo1M0o1QW//VkEVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795444649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gN50QlWQWT/ZG4psTpRi5d1+zreXEDSKMJ2KTMExSjs=;
	b=SviMm2Eug0s1a+6js+AQsZuynRtcB0lNekGuBtfmHp1gK+RpXXBi+wBuhKZkRQ02a1/+
	 FeoPyYEBWV3gT/U7wf81+TQE9wEu4i7IyotAfQrQeDHBm4Ga0Ti4Qp2Zs8atD33O/Lb/R
	 32xTuJrCUXfull8/Jdjv8vKF0qKC6gUhHQUplujZre8RGIXQvyBC+KA02fOYXj58et71m
	 OnV62do/s0ffrDMYfLRJOKne6GqecLiWektNyisXpmN4cZw8nmxKJ1KgaGufATgUEA2+n
	 B9a5V2NgilxYAQs/+uVrGa3MlGFaVBEasc8H335KTZ8K9hN3Cfv4EkIVOhanmrJ4vSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=a6QChABO;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE29606A339
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 14:37:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAE29606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=a6QChABO
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so31420415e9.3
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 06:37:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1795444647; x=1796049447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gN50QlWQWT/ZG4psTpRi5d1+zreXEDSKMJ2KTMExSjs=;
        b=a6QChABOvUscaGTSpqa0fnRHPGE2+LKwyTLMt/yu+F8MGPXBs9CPgQClRHqr4Sk8oE
         LBwTRjs0Gn5rzxtoLAYrbIOBhee9an9raD1exAVy3eA0tO1xqivP+y0VOa9uRtmkBV72
         jrBxjEbOEj56Lj/ceCSzEqRzzlfhI9Gx6h5Qgl3ySIq0XCC/R1gIH0LFsA9vxaNBkAhT
         m20HWPuP9LeQClplPCCLV85JqhNFSZnXK/TSfM/3HG230laYdmN3DB9iiXjWrzSyv1Jp
         Uo8Qwv90pFQlzj6/RD/fhr0Wf5UAxnIj8YSrjHgZVxCuptJSFeQ1xE6vj5p03onOjjMa
         Mpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795444647; x=1796049447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gN50QlWQWT/ZG4psTpRi5d1+zreXEDSKMJ2KTMExSjs=;
        b=ElGFZ11cZBe38Ryoq1ED7sGCKosPYsQiOeTUd80b3PIEOFQUpe0dJB6sl5Z2UvMvU+
         eE7gaEmyjSrJcGfInu/5BgQBYuVsNUFcETKwhhUITTvtepMuDAsxDiIniX0luo+o92NM
         rS6VPQ26rPFsfihTysw3ciD5EruOMpfo546ByTS+31TDDRI08r8EVKNxbDeQtrUB+o+/
         j6u/K0BoeipyTt5iH25zDLdWGVSWqJBwFjjU8GM9etH1tJlnY/mYkyvg4yVYQmerf/W3
         lGTjWTa51YqCQ8LBgeTyuT6s5XRB/T3/HpPrxV9PnErA1v+DhdHRb3LA0WQXceO6LMij
         UQdw==
X-Gm-Message-State: APuU4Z96x0b6TM5nccnPVkDLzNwTigUrwDvwxKgggh9OoP4bNCNJQyuq
	fQe8UTxBK6zQce9Q5RzTERNGldOwmyqW69+EKoBBeQKbUg6FWt9rxSQhfkfV6nDx1uJVUDbKMF6
	gc3dS2SA=
X-Gm-Gg: AZFdTZes1pculMsRrH2LjIhIgNYrAqo4gUKU6BkKmf9JzX+6tgjbxSNgq2zMNChl2w/
	ID0QtrX3c47t9ah8KA9lnx+wTVTaTVNux4LgClastPeudMTLub2tl5kvf3lKfDrFBXWAWEsrCVv
	qKDLPoLD+5aYFNw6/8n3AF0S+GdqG7Hbdm9vwb7rixKHr6UUwILwxdfdmkJHWBV1MhWI73yej8e
	Y0eguX/mL4kVURgLg6BX5zE0F0FeuAjNy6M6qMZjib2TikDlJrWFOZ21U50qm8mg50VrSNjPMTp
	7VEc6XsTDQOxPi1oWoQ61I45Me/KGzZf0PD3F+ZwoWEUtgvBwZB/51l8NsC36P/ynvQw0VI6oYq
	yWnd++YzgxaDUVWR6daV8JXJVOqN37KowihSmNigwJCdhiIX0DtcQEhlkqnWZ7f1igx2OIYo5UM
	EsMjHuAFQ/pIy0vSYdUWtGAhtqXC56wFkkpsndNeD/UhOkD2cCC0Pg9+31/7OZNVBY2z7LNraSF
	hBk9pGiGT/n+B01XO7C+A8UMEdBliD7jb/wEYOTCBN35j3TFPBQZLGGSBElwc0GCVGOspAyFw/w
	8omJPyFidH2J+vQg1IXh3i9EjIBlX+tO/c6R0tZqc602bIOaCELXy1YqyVibaaNucGtyvI6tC+U
	B89z6Sxq6Zx7h+Ud+jnVxUKyO1mhrIN81rF8q40A1ljAjBLLSbxogRmZ1ML2L0KVLWHzYEK3EUu
	f+MtP8oMKadcb2yYbgoUulHGhB/SwmrbBXomA=
X-Received: by 2002:a05:600c:5493:b0:4a2:8c5:5e5 with SMTP id 5b1f17b1804b1-4bb8881c734mr254647255e9.7.1795444647312;
        Mon, 23 Nov 2026 06:37:27 -0800 (PST)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906d6a13sm172562325e9.3.2026.11.23.06.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 06:37:27 -0800 (PST)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Md Haris Iqbal <haris.iqbal@ionos.com>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Subject: [PATCH 9/9] RDMA/rtrs-clt: Close all paths before freeing any in rtrs_clt_close()
Date: Mon, 23 Nov 2026 15:37:19 +0100
Message-ID: <20261123143719.938876-10-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123143719.938876-1-haris.iqbal@ionos.com>
References: <20261123143719.938876-1-haris.iqbal@ionos.com>
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

rtrs_clt_close() closes and frees the paths one at a time. Meanwhile, the
paths that are not closed yet can still walk clt->paths_list: a reconnect
fires link_ev(RECONNECTED), whose handler calls rtrs_clt_query(), and a
closing path fails its requests over through rtrs_clt_failover_req().
Either can then touch a path that is already freed:

  BUG: KASAN: slab-use-after-free in rtrs_clt_query
  Workqueue: rtrs_client_wq rtrs_clt_reconnect_work
   rtrs_clt_query
   rnbd_clt_link_ev
   init_path
   rtrs_clt_reconnect_work

Move every path to CLOSING first, wait for all close works, and only then
unlink and free the paths. A close work cancels the reconnect work of its
path synchronously, so no path is freed while another one still uses the
list.

rtrs_clt_open() tears down its paths on error the same way, so move the
sequence into rtrs_clt_destroy_all_paths() and use it from both, with
sysfs torn down first.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Reported-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Closes: https://lore.kernel.org/linux-rdma/20261105202939.3104321-1-shuangpeng.kernel@gmail.com/
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 49 ++++++++++++++++++--------
 1 file changed, 34 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 7930039dcd32..760ae71c9230 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -2862,6 +2862,38 @@ static void free_clt(struct rtrs_clt_sess *clt)
 	device_unregister(&clt->dev);
 }
 
+/*
+ * Close and free every path of @clt.  The caller has torn down sysfs, so
+ * no paths can be added or removed, and does not use the session any more
+ * (no IO, no rtrs_clt_query()).
+ *
+ * Until its close work has finished, a path can still reconnect (firing
+ * link_ev, whose user may call rtrs_clt_query()) or fail requests over,
+ * and both walk clt->paths_list.  So move every path to CLOSING first,
+ * which keeps further reconnect attempts from starting, wait for all of
+ * them, and only then free.
+ */
+static void rtrs_clt_destroy_all_paths(struct rtrs_clt_sess *clt)
+{
+	struct rtrs_clt_path *clt_path, *tmp;
+
+	list_for_each_entry(clt_path, &clt->paths_list, s.entry)
+		rtrs_clt_close_conns(clt_path, false);
+	list_for_each_entry(clt_path, &clt->paths_list, s.entry)
+		flush_work(&clt_path->close_work);
+
+	/*
+	 * The close works have flushed every reconnect and stopped the
+	 * heartbeat, and the caller issues nothing, so nobody walks the list
+	 * any more and no grace period is needed.
+	 */
+	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
+		list_del(&clt_path->s.entry);
+		rtrs_clt_destroy_path_files(clt_path, NULL);
+		kobject_put(&clt_path->kobj);
+	}
+}
+
 /**
  * rtrs_clt_open() - Open a path to an RTRS server
  * @ops: holds the link event callback and the private pointer.
@@ -2887,7 +2919,6 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
 				 size_t pdu_sz, u8 reconnect_delay_sec,
 				 s16 max_reconnect_attempts, u32 nr_poll_queues)
 {
-	struct rtrs_clt_path *clt_path, *tmp;
 	struct rtrs_clt_sess *clt;
 	int err, i;
 
@@ -2943,12 +2974,8 @@ struct rtrs_clt_sess *rtrs_clt_open(struct rtrs_clt_ops *ops,
 	return clt;
 
 close_all_path:
-	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
-		rtrs_clt_destroy_path_files(clt_path, NULL);
-		rtrs_clt_close_conns(clt_path, true);
-		kobject_put(&clt_path->kobj);
-	}
 	rtrs_clt_destroy_sysfs_root(clt);
+	rtrs_clt_destroy_all_paths(clt);
 	free_clt(clt);
 
 out:
@@ -2962,17 +2989,9 @@ EXPORT_SYMBOL(rtrs_clt_open);
  */
 void rtrs_clt_close(struct rtrs_clt_sess *clt)
 {
-	struct rtrs_clt_path *clt_path, *tmp;
-
 	/* Firstly forbid sysfs access */
 	rtrs_clt_destroy_sysfs_root(clt);
-
-	/* Now it is safe to iterate over all paths without locks */
-	list_for_each_entry_safe(clt_path, tmp, &clt->paths_list, s.entry) {
-		rtrs_clt_close_conns(clt_path, true);
-		rtrs_clt_destroy_path_files(clt_path, NULL);
-		kobject_put(&clt_path->kobj);
-	}
+	rtrs_clt_destroy_all_paths(clt);
 	free_permits(clt);
 	free_clt(clt);
 }
-- 
2.43.0

