Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D46E3EC826
	for <linux-rdma@vger.kernel.org>; Fri,  4 Sep 2026 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527701; cv=none; b=s9aE0MGMxqsbJKbezfOfDEWVVXeqfo9eFg6VGOxmO/Uh5U3B/6rb7GoNdggDMwoo+pfd+3KpcNl/DL/spL22/KpG9L4bEUi1Zmm8AHJJuvWa4kRbL1tkqoRSGhhbgtySs3BvnDHVp4Ep6DceMUCZH0zEWcDMgCEcTujVpCNQqFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527701; c=relaxed/simple;
	bh=BTM01R03+fXARkuE+MN9f6y768ghwvtwa3LO9NQVFSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uewfynHfheLuv1Q9Ite4ZaVj5up/l+h5AI32zTOpbV/AS8gfTAGOJsu3Q3dWaO15/N1pcy6MNeiDZiMXd7aJnCUhxESMUwKWLx7i2kb6DzEg6NGCXTlnHvm3Q9vHQkvfFqqFkDnvJTz9ABxqVLYcR3Bcj3oYei/zEeeKwVhtjY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oEyRcS5c; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oEyRcS5c"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso1065509a34.3
        for <linux-rdma@vger.kernel.org>; Fri, 04 Sep 2026 06:14:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788527698; x=1789132498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y5nfwy7OsRkgUCsCbNO0ez9BWs9ZFo3ZzcC9GWW49DI=;
        b=oEyRcS5ckyjj+Iphx+b8P+jj+Zg3+k/gOF/a198BMqUW5VU1RyW7E/mZdkNeOqO9AA
         qWthr15cc7jH/M6T8Ce2gRk2PsxenqI+mMwce/go5RmWgPYIZ1g8kIN9dYMl8ZJDd2g3
         NCw3OoacS8oiJeS2VYMMiALyNIeomajRjN/oEe18CRrYa5jzoxGTxQext3l+pIMvgaOd
         YQJ0LfVHDAl5dV69NJNPAStQOPGw08GKMOIc4dwEHBTG6W1s919AM+qRGS2p47PVPO0b
         gL9epNb0E7ahhyIHxhNDxenoFJUIolAC4ONUXwfZqu8lIdjRg5kkOL37xf110Ee6wdXu
         RcMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788527698; x=1789132498;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y5nfwy7OsRkgUCsCbNO0ez9BWs9ZFo3ZzcC9GWW49DI=;
        b=sD0m0rwATjSdYa5RNGSFaKcp1rnlcrmd9T3+VTNkBdGxv+13LsixsO4qzCcu146z3D
         i/ZSd/cGnO6Ykw+uGxctBn7DMpUDuH6Z/dv2kpj3tQo5Z7q2kl3Q7WhflJXHPsl5oowT
         rH/6cwvFp37x+NDShiEdGmTlhcavtQLzMABj1tZKk7pc9QfycgCMC2WIpTaC83GRjAiA
         z0BncER0s1R7VklveokRfCwcBgmfx0+j87iM3TRAJCHZPiK52f8CIbSN7gwOT3RKU4xT
         rh8eI3CapEcRHKJ+YoT9RczbSqjmHjwKVpQcuipBTArhJSbustXBl8xWh9W8evAJlmaF
         3Ehg==
X-Forwarded-Encrypted: i=1; AKwUvBw9bcHgAn+317YiCvxezrR2+9gbjEY8sbZSISJU+f1JONshtEilpWlvv9ZHyHNx7ACxvbbv280IQ47+@vger.kernel.org
X-Gm-Message-State: AFuF++nycVwjiCjRq6F4smFr8ecHUXNo4Stl491XL2y2byR8PnP2H/ru
	C4CJszhSjAtfhP2kKZDl52VM0PDinmVZoWJ3ZPJ5rlw0QaP55YasP8/f
X-Gm-Gg: AYBFou2KhSm5PRZWvvCEsdfgnsNq1GfnWcGRUPpoeu9S2U1MFosz2TUEtpArFb54cVL
	m6917LBDSWOrJ1Vj87Vm+0O8P1YAwwsNxeFfkOsAdhanB6yRReKLAfLCiuTdMV4QSIupSlLvLsL
	PJWZa5oot9ZPKqDbX8/o4erJ+X+JXyJDmQ4WLMfccmSflvYbxC2yKZBIOLN0iUg7a7eWYOdSbvo
	2fDBX8F93PKva96d2o1xlANvdYdbvpsacPGEkIgaoQndzo7gc6o3x7R2fNYdrp0uY5VF88EE1aL
	6BTA/Of38ugTGBX0XtomqjE2gH05DffcHtHDuMYJpVEnmmFzmQ/VfCFNkq77m4icKEPjPhJOAzt
	0bMmpsC/uRjpGYmaXqxw0jgJBUFmgzIT5e0W6bYy8rveCnHx2FKVYE2Yf/L1vvu7M3aYvqggeX5
	IjX3gSeU3popMY8F/lRMlyDamcquL8IaKn+LBW3GYU4mkYa2CmwW35lwkbtAcynkm80hQbbvQrw
	Kon
X-Received: by 2002:a05:6820:2017:b0:6b7:46fc:1d7 with SMTP id 006d021491bc7-6b746fc0274mr2550031eaf.54.1788527698282;
        Fri, 04 Sep 2026 06:14:58 -0700 (PDT)
Received: from Default ([2409:40f4:101e:1ef2:2602:9f75:700f:bd27])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-143243e6ed1sm6553828c88.12.2026.09.04.06.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 06:14:56 -0700 (PDT)
From: Jeffin Philip <jeffinphilip14@gmail.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: kees@kernel.org,
	pj.waskiewicz@solidfire.com,
	larrystevenwise@gmail.com,
	Tatyana.E.Nikolova@intel.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	syzbot+bd317784d628820741b5@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH v3] RDMA/core: fix refcount bug in iwpm_get_nlmsg_request()
Date: Fri,  4 Sep 2026 18:44:37 +0530
Message-ID: <20260904131437.12917-1-jeffinphilip14@gmail.com>
X-Mailer: git-send-email 2.55.0
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
   Changes in v3:
      Sent patch in a new thread and made sure to apply properly.
   Changes in v2:
      Add list_add_tail() last after initializing every field as per Leon Romanovsky's
   suggestion.
---
 drivers/infiniband/core/iwpm_util.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_util.c b/drivers/infiniband/core/iwpm_util.c
index 990cf928b32a..51af8c1c49f9 100644
--- a/drivers/infiniband/core/iwpm_util.c
+++ b/drivers/infiniband/core/iwpm_util.c
@@ -314,10 +314,6 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
 	if (!nlmsg_request)
 		return NULL;
 
-	spin_lock_irqsave(&iwpm_nlmsg_req_lock, flags);
-	list_add_tail(&nlmsg_request->inprocess_list, &iwpm_nlmsg_req_list);
-	spin_unlock_irqrestore(&iwpm_nlmsg_req_lock, flags);
-
 	kref_init(&nlmsg_request->kref);
 	kref_get(&nlmsg_request->kref);
 	nlmsg_request->nlmsg_seq = nlmsg_seq;
@@ -326,6 +322,11 @@ struct iwpm_nlmsg_request *iwpm_get_nlmsg_request(__u32 nlmsg_seq,
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

