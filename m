Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F1C647A875
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 10:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788430695; cv=none; b=smMk/yogghbce4qqB3hs5hBOf3jc3wZ9pQlV3AKBrv3Tbtv350ChyWJT+U/6T2mn01Di9FThI+SG2wTG1szHh254lIG6C530Lu2j1dsxGJEN9xr6TSXJlKzkCAMa9LpuyxHbINucaGS+C54aCSsCK1XlNHfTgwk4tvvUcAJn1BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788430695; c=relaxed/simple;
	bh=nkJijpibfrqgdl3VNlBSmGDYeRp7RjJg/vx3pVX/fCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WredBplDE4Dvf+jx8Dw45rYLFkUYz6XXuGXgbG3h43u1z27wzGFxfrjGnbThTMncw4mIddJ9/MQJVrNtK2v/sKLJfudTF780DMgSQNESnkoKn3k9l/tiG+2VSeQ72mffSfKRarxvdjUvHx/h71PLuWM0fVG2BtPlivKJmAkmjbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HWJkcBAs; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HWJkcBAs"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-85339ed040aso1808831b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 03 Sep 2026 03:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788430687; x=1789035487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V7T99HEkan7KgLe3r/HM6KiSk1eXB+cQcUYwvOC4cMw=;
        b=HWJkcBAsu95hlx2pBvbtSGuHrlLwVhkwVTvnpFTRZxufDMpanXCylGnqjUV72Ee4Kx
         IHupsghYfZk45lzWRZD1Byx6LgtUt+0WqAhutEVksnDn5Z9Tp7mYOFRznLWnL+XdNRR2
         pYK8XYrKdtb+hG+RWWZ6LZxYLyyIVdCNxmrDF7uX6ZGYJi2NrvJ+zoY5SUi9Dy8AVOru
         wlRBwGU2gO1f3lZ7ErbWvUJXEe6es2P/BLdmJz5toMVBdTI9A3pjDeJsmhTqCzoKZ50s
         IlZ7XBXI0tEAOyeEFYeIM35BH8vth/209X0x0DQfCHVmtxMw2MB8sJtMlAqKCiVC1+KR
         dZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788430687; x=1789035487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V7T99HEkan7KgLe3r/HM6KiSk1eXB+cQcUYwvOC4cMw=;
        b=HcIjIGKN1u6Db2l4c60b3lRcHFvJnlHu4U1K4DCeicxBEZzkq+0ah2jlnkxZoVeh31
         EbjWrOf/WAEIlptSAdk5sGy+jSkd48jHLW0spKUKTyiSKGgG4gWa8pgb/YsJx58sD9dW
         zN0mucHdDspGtvx7yZrTAAp3dJCqqtLcphcXEAF9kJmDoao2x/Z3iWRqFavDpGOqCLh0
         37U8GxD1dg06ziipsYCrjnj15VZl/02l5caHvcHFmRFqm4R+BY/TAi8LOnmZiQnSg7aN
         mt2HylvGMDZ3xzs8aKjVXnWRYDbnGGNRp65KWmLYx4upe+IsU8FAMvx2pdPfi9zGoJnO
         0GrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxg8iFVGFYTvhTn0sWbUwQoJycRB9HJNuT7swcKZ0Oek+PveipIa1SNIbynvShn6mX3aKJKdV9KJed1@vger.kernel.org
X-Gm-Message-State: AFuF++lR3H7Ho9uglXGvWwr+3ctq65soHPaZhy5RtHj8TDRTCJ5czlft
	Fe29kMOZgPM/cw3M748Lduk4a2U0jWx82E3BKTnaJwKGjOSWo2i364Gz
X-Gm-Gg: AYBFou19ZH6K+Yhh70OkRyG1tcBRa/xOnwYgQhLMQ7LuSUmGPbIIB4ZQ7N6kRY2bvWA
	MBMQJf6X86ckXPapQVWl9z2ZbHNTnpEZ+zm3QAugiOjH2whD7ycKh2OPkDXNuiy1NqLhowZOXPa
	DhEWnmOZPNKODuDCiTXUWeoS5rBeLJU7QVpDzSlUjiKmQlYFbuWo5YS9qtONF2GvYyVRoqE0aW+
	aMgN8p6kNNTXWRqBzrUYJFCI1Po/bR5AWnAIq8C0oO72P8KJqqpQg58WyjLkik8LdVafB/KkrSq
	XkY2vkLSMlnoLw+gibbsuOsYCBIcpmDMuS6Q1jZIhtz1tca1OefHZthhMbui0I/ekwYPea/PXMf
	MbTJCyhHSZ9cD+tqjIXUqfAY5kKTcBg9euykGEIH9Y5utAX6JIGa8y85TKAht/yC/XjJUe67+xm
	VGlQWhh40hkoQeWk8iadwj9qzywNlfwjAU+lpHujadpgBHOjcLO8IoXjMfx5xx/zXMpQ92xz6mt
	z8RLg==
X-Received: by 2002:a05:6a21:3393:b0:3cc:3d08:da3e with SMTP id adf61e73a8af0-3d9ad570762mr15626344637.2.1788430686494;
        Thu, 03 Sep 2026 03:18:06 -0700 (PDT)
Received: from Default ([2409:40f4:101d:3568:cc14:1945:50bb:8f16])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3325534cd65sm6078036eec.6.2026.09.03.03.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 03:18:05 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: jgg@ziepe.ca
Cc: leon@kernel.org,
	kees@kernel.org,
	Tatyana.E.Nikolova@intel.com,
	roland@purestorage.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	larrystevenwise@gmail.com,
	pj.waskiewicz@solidfire.com,
	jeffinphilip14@gmail.com,
	syzbot+bd317784d628820741b5@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v2] RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()
Date: Thu,  3 Sep 2026 15:47:42 +0530
Message-ID: <20260903101742.214304-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902085213.145312-1-jeffinphilip14@gmail.com>
References: <20260902085213.145312-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iwpm_get_nlmsg_request() initializes refcount _after_ list_add_tail()
making it accessible to global list where another CPU can kref_get()
on nlmsg_request causing a refcount "addition on 0" bug. Fix this
by initializing kref _before_ list_add_tail() so refcount for
nlmsg_request can be incremented/decremented normally. In addition,
also initialize every field before list_add_tail().

Reported-by: syzbot+bd317784d628820741b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bd317784d628820741b5
Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
---
Changelog:
   Changes in v2:
      Add list_add_tail() last after initializing every field as per Leon Romanovsky's
   suggestion.
---
 drivers/infiniband/core/iwpm_util.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 5d07c5756987..51af8c1c49f9 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -313,19 +313,20 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 	nlmsg_request = kzalloc_obj(struct iwpm_nlmsg_request, gfp);
 	if (!nlmsg_request)
 		return NULL;
+
 	kref_init(&nlmsg_request->kref);
 	kref_get(&nlmsg_request->kref);
-
-	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
-	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
-	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
-
 	nlmsg_request->nlmsg_seq = nlmsg_seq;
 	nlmsg_request->nl_client = nl_client;
 	nlmsg_request->request_done = 0;
 	nlmsg_request->err_code = 0;
 	sema_init(&nlmsg_request->sem, 1);
 	down(&nlmsg_request->sem);
+
+	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
+	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
+	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
+
 	return nlmsg_request;
 }
 
-- 
2.55.0

