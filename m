Received: from mail-wm2-f11.google.com (mail-wm2-f11.google.com [74.125.225.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541F53E0724
	for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 10:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037375; cv=none; b=JEb7FrTsyk2bZE95M8gFSc8KjJ1SmAXMrzDTcHCo0W4fxU3rS50+WJbVzxJAd+mCaKvMxvXRTHtUmf1noXjLvwxtTjem81jJCAtQosMxkiwhEDNsC8GZqVvuHrobQ1RY8CIaHKehC3x1DGsf6+mXtBGXmWmlTmXgz2b+n9yyMZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037375; c=relaxed/simple;
	bh=BvbpnQGPvfTWDP81tODh27OGD1ht3yQ6yFG7OIw7yfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iu++pvNpjIjnA68a3bYno8ydTSenXsg8lfknGudJeW991MuhjgzrGVtrKsKoMUdIR03q248gDJm4QbhRzOd2dJBKUUIcWIq7GByxrk7qAwddOpZZugEQBbkNwxLm74T0G0v6CmhoKYK9QuY5kj0VmrTE7ezQFN21KV658++OtUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RcWMU3yy; arc=none smtp.client-ip=74.125.225.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RcWMU3yy"
Received: by mail-wm2-f11.google.com with SMTP id 5b1f17b1804b1-49ccea58fe3so14642005e9.1
        for <linux-rdma@vger.kernel.org>; Thu, 10 Sep 2026 03:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789037369; x=1789642169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bI+U+fsPLOvEOMqGzYRotHx97PTJxMVyp0ELRDTR1ZQ=;
        b=RcWMU3yy83WYK5Wd2cAi/JGJO0liJN95NwXwKXUy839HRCgD/NMOAxpdwhSBUAhxSV
         BUpn50KS3J0SpP2b1qi0ZHMsuo79RUKH4ro+tjr0y0Gm39l3hwLb6XIw8L3ZUHP4XZch
         dMinvVEL4som4l2958QPgl0M7A5K1pIm3eoSxlAejHTDoscEd2HF6apVTVibkT/hkYsV
         3l8hXeIOBzD81AfCSCWnjXH91aCqzCLD0j8vbYKkiPw0DOqtMtpzYDewOvahmkwgBEJT
         2E9U7R8hL0d1YiWeHyyuAB34bY70meGjQl1JKW7Es0cU4Ruwiebj/tCEQdyFsCeofDTJ
         dVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789037369; x=1789642169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bI+U+fsPLOvEOMqGzYRotHx97PTJxMVyp0ELRDTR1ZQ=;
        b=gpreNVS4I0yKEKlwisvYBZDAXvvYztb1Lkha53GJuH5suPuIcfktyy0Wx7SZSjRBzl
         r7pUHSkQOFNXz001r7RjQLJ3RcvBOUnd+IlF3SjphTe8B6xQp2r6cCIcfku2GhEXAbqt
         lzZxiiGxRT+pofmOZlRbOjHP5PZb7kBp1C7rZcJOdOY5LojbSh6gJ1h783AuDj79MvQO
         +5Y8AvNnoMCRB8W7PIBoGru05Hmw2owveSS8jtt8oAqkpN/o3u6NHBxPkZA4ZjMhdKOa
         iwz0PJ9oAaLiYUgF4WrnNAZj9n9bijlxirD5JY9nmuR6Lwi2Fpe7AOQ3KjhLRVrOn3Wf
         WcvA==
X-Forwarded-Encrypted: i=1; AKwUvBx+eQmV9QnnY/UzfhSa+TWZdrMAu+TWdffmvJ4SV9ZOcPCSMTbvZtkFEuqxLoKNaMFuBtyLzn2VzDvo@vger.kernel.org
X-Gm-Message-State: AFuF++mjgD3nIkC301+Ll2QLI3V6ZJnUsqQGQ0K74Rq2e3/8fGvsiHXk
	8TvbhGEo+P1I0nhXAiD0Cn1i6JvuPmP7Xf7MYwQRLiXPfkWibCnpZHvs
X-Gm-Gg: AYBFou0VbCbstO7uNJw+N7Rf8snfb4+ODd/qoRHt+xob3Im2h/vxfg7IHwIOmaIvBaz
	g7RWQKDelPGue64srgSwEF7AAy1vYNoVuj3Ayn4CbiyDLlBAuNLWYrIe4JyPWupXWsXVUq9KbRC
	ph++N2fc4zp3DcbBCvfV1Md3r2VW+1XWQkuAn5tSo/j05Z3D5UARL6BFXgSsX3bkVDxAAd868ws
	d0dgQry7WXUz0O4NusCAkEaFK40JVIG28tYIRo66Fj3eWUwn5AaJ3MImnDXQJqvOmRue7skKKVv
	XCeXX9AvD1rS9VKUB/MLR16QRDK44UJjPVvkArH1dcOHGoHRM8v37Dt5NPY6ccxOXgsbzGWvwi+
	UrAANF1mA2uwP6ylm9/TUzYufE40tmqkF7xRqUPdwUGS7BovD1jLSGxALYss6zcdZj5p/MJuHi5
	O2yLrNlkdIPDGEnkMECDp88Ui8eP9UDXW0gYvpWV11i+xreWrMKvdnXplrkdQ4rukVC+gglROgK
	MkYnngY2iTJdiU=
X-Received: by 2002:a05:600c:46d5:b0:49c:fc6c:be04 with SMTP id 5b1f17b1804b1-49cfc6cc091mr348067955e9.27.1789037369203;
        Thu, 10 Sep 2026 03:49:29 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.255])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26be3e0asm67419465e9.1.2026.09.10.03.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 03:49:28 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH v2 2/2] RDMA/nldev: remove the unused dellink link op
Date: Thu, 10 Sep 2026 13:49:06 +0300
Message-ID: <20260910104906.19681-2-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260910104906.19681-1-serhatkumral1@gmail.com>
References: <20260910104906.19681-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rxe was the only driver implementing rdma_link_ops.dellink and does
not need it anymore now that its UDP tunnel sockets follow the GID
table. Remove the callback, the nldev code invoking it, the mutex
that serialized it and the now unused ib_device::link_ops field the
invocation looked it up through.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
 drivers/infiniband/core/nldev.c | 15 ---------------
 include/rdma/ib_verbs.h         |  2 --
 include/rdma/rdma_netlink.h     |  1 -
 3 files changed, 18 deletions(-)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index a4014a230639..8b5b9bfb1345 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -51,7 +51,6 @@
  * a controlled QKEY.
  */
 static bool privileged_qkey;
-static DEFINE_MUTEX(nldev_dellink_mutex);
 
 typedef int (*res_fill_func_t)(struct sk_buff*, bool,
 			       struct rdma_restrack_entry*, uint32_t);
@@ -1885,20 +1884,6 @@ static int nldev_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	/*
-	 * This path is triggered by the 'rdma link delete' administrative command.
-	 * For Soft-RoCE (RXE), we ensure that transport sockets are closed here.
-	 * Note: iWARP driver does not implement .dellink, so this logic is
-	 * implicitly scoped to the driver supporting dynamic link deletion like RXE.
-	 */
-	if (device->link_ops && device->link_ops->dellink) {
-		mutex_lock(&nldev_dellink_mutex);
-		err = device->link_ops->dellink(device);
-		mutex_unlock(&nldev_dellink_mutex);
-		if (err)
-			return err;
-	}
-
 	ib_unregister_device_and_put(device);
 	return 0;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cb3b6163961b..4930def66c70 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3034,8 +3034,6 @@ struct ib_device {
 	struct completion unreg_completion;
 	struct work_struct unregistration_work;
 
-	const struct rdma_link_ops *link_ops;
-
 	/* Protects compat_devs xarray modifications */
 	struct mutex compat_devs_mutex;
 	/* Maintains compat devices for each net namespace */
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 2fd1358ea57d..d1a7186f7436 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -127,7 +127,6 @@ struct rdma_link_ops {
 	struct list_head list;
 	const char *type;
 	int (*newlink)(const char *ibdev_name, struct net_device *ndev);
-	int (*dellink)(struct ib_device *dev);
 };
 
 void rdma_link_register(struct rdma_link_ops *ops);
-- 
2.53.0

