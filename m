Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793929173;
	b=APR6s3Jj0yH53M94FK5rBwEGcFAA214DnTdf4Mt9fC/aFmUVx7UwvM5u0g2wY7BOnB6k
	 VGCzRfCUuEfEzOrJxCyvV1rFkVneirwxGYPn8/D1qjDagacYpzLqEAE8wWpTO1T6ODT6q
	 +6T9OO4twER6+8DDegNbcROGhwY0RxdGH2ZFvBrMYy5F0W3G0ALuCMvuEBB8KuiEzBrMw
	 ryGOYzB/b4kA0jWGqOAhdqTnDdYIOQtpITVW3My8FpatABqWUWcZWnc5gfot6X4+rX5KW
	 PR6hjuwydhnQf/kt3Z9xehr8+2qPSNk9FAxI9F2XoLmOlqWvdFaFvAhF9+QTBO43n0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793929173;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=pV/kNvfzk8F2VpUAoJWwVRBZCZ8dFSwiu/B6DvmYRHY=;
	b=yuAlAyaVTitxl7mHPKemM41GoY7IVn1kgRJBNyDyNGmkjqez8zFnKjA1fpDnaV6aA/Xr
	 mx04zYr9wkud3T4IHwagFjpI6mu+MY64bzA8HfTlgEZiZn7zB86bOspc6HYXQuq9xtKiq
	 plZ/y993GhkLMViIrI3iiGCUi6xIcquMz56dan8qReSgOy+xU+yVaSdURUpDWHO/Ne1Ep
	 amQZLzHYjAjGuZe9T0YorxX6eQ9VZWKOt1BmglunyXyhfUb+UX3Z7V/s2w6cqhVDJTVYM
	 N1yL9Dedl+eRNwjbDCHL3opzk80saAsaA+RTB2Kl0fg4cL8xl9CBmG1p6d/PUNT2PdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tv6GLX0f;
	arc=none smtp.remote-ip=74.125.82.52
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4FA606A326
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 01:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BB4FA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tv6GLX0f
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1438d9363fbso157370c88.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 17:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793929172; x=1794533972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pV/kNvfzk8F2VpUAoJWwVRBZCZ8dFSwiu/B6DvmYRHY=;
        b=tv6GLX0fyEfho2UYnmfo57BkKedAtXn8lB+TNhXnenV5HgMj3UgR7LVY2VvhFiD5Co
         1xrjTlsRt4KJM/9XjhNzGpk6UuiY31/LQvno2ZBouvkrtzJ6+SpmToVSE6q1sn94tNZg
         GmJXWBZqW+zfRKEEeKPClSylMKdn19CFOaHTgcfpzHx9ZOlqAgZfY9upKMEQTcuYgcAp
         QZ9jMCus4EJj2LixvXn17RSeVe6N6CeiEDXgllveTiKNpNycARbJD5RUklSpCs3EZqfW
         uA/vagr4j+3ku3lOS08GCQHPHKB6MISgKSZyGYLzJRgFB99BucByQntGj+k/wHRzMu0u
         Jlpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793929172; x=1794533972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pV/kNvfzk8F2VpUAoJWwVRBZCZ8dFSwiu/B6DvmYRHY=;
        b=JYBZNLj4LIFrKloWXkiUk1xjVJ+vJ/ZWb8EO43K+OZOiw4WQPvyBLikAofxAonc/tQ
         qAnWphTmuWZ2k2hKCamirz1lJIVuGEiYOtqH9ypDDgIgdDdDRgmyerrX5Ri4CglwOuX5
         JetkdVaSAze7NJwTJLpAzD7cD22A1vDrHTaw5UaSk4cU4iZAhU9ij6FjaeYzBZJGqNXd
         Bw1BfAD+PQHnBL0jgkrHmZYuRh+twGxhqhKA8z62gTPcojJQMhUxEGFdxhV0xiK8L5bl
         cwrCDtJ7bxv40MxavRQ1awtLAkj1yvv5x4E/26f786hG+IzNAZ2F6rERqABOWhQWcnpA
         Vemw==
X-Forwarded-Encrypted: i=1; AKwUvBxKKzRjAgAUgsmTsxIc82jysYOuRLsQxco9i1YOCuODRKvt8WcS82FiOuabDO+QNYOT7olOxZcTDt6W@vger.kernel.org
X-Gm-Message-State: APuU4Z+iXKd+GicCPbajFAL+n2624/bslrmPsdgcJZHvtf+fS8Nys9Bm
	RkX3Xc7sjqh7Hr22OaeAkTM2fRn29aE/ymMV8vMu047ATB9wOU3cTI2R
X-Gm-Gg: AYBFou1+IatL59eGJzCBBqTv2sZlQQF52lBmSlIMA5xWyBtTpLqKuZAQeLp2Cr3LVtn
	t6qKesK6ZgpBebwWAJAjWFIeusdj/4I8Yb8GxIsuRBqLXnJ1Id4QnpGenWymv8zO7W+R2HqBr1X
	4Bz1AtCCdOywmhUF7akfkqNDj5qbGMNEKxGwcsi0Zb/mUMkutTOXl/8gvEmzur9amHulx2pQYyk
	6qu+LtD6+3wZMUYAqea1a25nxoz3uPpIt1zlYAIKimkKgq3umB4shcNALYuIp2FP0YmhkAm4cqJ
	A3pGbmMpmVIrKFvegWoJhmGJ/KhBLQfOdKq+Hr2YOPDVTmQHzsZX+KMQSSAP4AsIH0aBa/zQlkU
	0MRkbRhiYmVQi4mM3uyO0YECVPS5hwXQPbbzAmdYrf+g0Ip0LcSwI2ApNHdCzvL9fhJHAm/rTDI
	HV4Detkw6lnPKHnUjVDzcfh6q+c2b3ZSzU1ZKH16PN25mHjYmLCIWP3jb3iZYVFuQpfvWNBlvvc
	+skUwaOrIYCGw6CDqb9bUF9hRw6JoZsLe3ZhtCtkkYDzuWoz00K0k9jcPgKAD3xX8lPgpgbsmT/
	kSMwwjDT6qXCG+Lkp1L8QHpWfObm/gFLDotcMrbuHQPt+c1QPGR3ql62vJ34gPjziOEjuClW1Z8
	vhKVwDAkykGghIujjasDJjJviUuiJU2RTJOADSCsyiffQqh+VrYh82IFQ5RgaO2mX1ZoSvha/lx
	g=
X-Received: by 2002:a05:701b:4192:10b0:1b2:581d:5dc7 with SMTP id a92af1059eb24-1b2581d604bmr2850197c88.25.1793929171358;
        Thu, 05 Nov 2026 17:39:31 -0800 (PST)
Received: from deepanshu-Legion-Pro-5-16AFR10.. ([2405:201:682f:383f:101:8f48:8a62:6bff])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4fad14sm733468c88.22.2026.11.05.17.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 17:39:30 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: hemanth.selam@gmail.com,
	yishaih@nvidia.com,
	edwards@nvidia.com,
	mrgolin@amazon.com,
	michael.j.ruhl@intel.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Subject: [PATCH] RDMA/uverbs: Fix radix tree node leak in uapi_add_elm()
Date: Fri,  6 Nov 2026 07:09:08 +0530
Message-ID: <20261106013908.21789-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
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

syzbot reported a memory leak of radix_tree_node objects allocated
while registering a siw device:

  unreferenced object 0xffff88810d78f488 (size 576):
    radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
    radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
    uapi_add_elm+0x61/0x140 drivers/infiniband/core/uverbs_uapi.c:41
    uverbs_alloc_api+0x85/0xc50 drivers/infiniband/core/uverbs_uapi.c:659
    ib_uverbs_add_one+0x1b1/0x350 drivers/infiniband/core/uverbs_main.c:1196
    ib_register_device+0x4fe/0x7f0 drivers/infiniband/core/device.c:1503
    siw_newlink+0x36a/0x3f0 drivers/infiniband/sw/siw/siw_main.c:433

radix_tree_insert() can fail with -ENOMEM after __radix_tree_create()
has already linked intermediate nodes into the tree, leaving them with
no entries. uapi_add_elm() frees the element on failure, but nothing
frees these empty nodes: uverbs_destroy_api() only removes populated
slots, and radix tree nodes are freed only as a side effect of
deleting an entry. The nodes are therefore leaked when the uapi is
destroyed.

On -ENOMEM, populate the same key with a dummy entry and delete it
again so that radix_tree_delete() reclaims the empty node chain.

Reported-by: syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d60be66dd00b4490fa96
Tested-by: syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Fixes: 9ed3e5f44772 ("IB/uverbs: Build the specs into a radix tree at runtime")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 drivers/infiniband/core/uverbs_uapi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_uapi.c b/drivers/infiniband/core/uverbs_uapi.c
index b67db3790f03..6b2eb392b076 100644
--- a/drivers/infiniband/core/uverbs_uapi.c
+++ b/drivers/infiniband/core/uverbs_uapi.c
@@ -15,6 +15,7 @@ static int ib_uverbs_notsupp(struct uverbs_attr_bundle *attrs)
 
 static void *uapi_add_elm(struct uverbs_api *uapi, u32 key, size_t alloc_size)
 {
+	static void *dummy;
 	void *elm;
 	int rc;
 
@@ -27,6 +28,16 @@ static void *uapi_add_elm(struct uverbs_api *uapi, u32 key, size_t alloc_size)
 	rc = radix_tree_insert(&uapi->radix, key, elm);
 	if (rc) {
 		kfree(elm);
+
+		/*
+		 * A failed radix_tree_insert() can leave empty intermediate
+		 * nodes linked in the tree. They are only freed when an entry
+		 * under them is deleted, so populate and delete the slot to
+		 * reclaim them.
+		 */
+		if (rc == -ENOMEM &&
+		    !radix_tree_insert(&uapi->radix, key, &dummy))
+		    radix_tree_delete(&uapi->radix, key);
 		return ERR_PTR(rc);
 	}
 
-- 
2.43.0

