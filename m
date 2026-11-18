Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795007994;
	b=jH5G4YT7UyLhyIcAC8xqYPk4MoOTOkTs1sQLu1725lWOF/PQui3QCPRkoOD6P+2Nknuw
	 wIRDVTXH27rwVVb9cfaV5qEvMHiwA4kdFOjVnD6yg9pA434gvNTqQa1YBMyF9Sb04Ori9
	 IfQaCB+Me90nGEbT4SRC4+ofgwEL0CPleVJD520UmCL3aljBxr19Qf8EbMPH4yjBI7aRF
	 0VMdrILW3GQzROgwRv2Lmlcgb7lOs7n3HNGPx7fXbmN9mh1jVz0Jewav+X/6kc1upZUWP
	 CIvdhx7ee8pZJAussCe7cHIEYQHmgvD6ot1sbDwxKkAK2876tS3zYs3nhykziagUEAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007994;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=jewcBXyAjPJVV3XNKZQtYMrq6DypFvpPXn3B2o2g9R8=;
	b=jbENVK+/3gqq4XTyPhUkFJoT6g4XxYY8+3ACAXy0mc1mjY3Rivu1XjSHMHNLlq3YTuI/
	 R1dMx7gYV7r6khz26iv846N0kyB7ZfMpCCJ+4D+MlnwR5zY6N1WtfGjbLxK+t5seM27sb
	 qYIDMkNmXNfvvBgNA1QPXVZd7jyy1zZofuBxWi1gr0W3yyuB7ArP4reMDh27h5yH35pxY
	 ACOyU+z77hSqSQVC8O5IjLyOXv/4M+cGPGlW/Erq3Nxw+o8wgLJA0onqcvsseMgt2J0PZ
	 maV4x6F73N/GEaWGliUuNTPhw4tu+FK/KYePK7HaJdv/c8LBuYj4812QbDdnNMu2Bow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FgXzjSfW;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E411B606A330
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E411B606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FgXzjSfW
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso16088665e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 05:19:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795007992; x=1795612792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jewcBXyAjPJVV3XNKZQtYMrq6DypFvpPXn3B2o2g9R8=;
        b=FgXzjSfW6stuhYECHvHEyTMOLp4MpLCFM5gIkQeaR/WgkMdrzPZ5SnxIDY9MvGdNoi
         WzVf2dd17jlr9mpNrbnKHBGG9aPD6bZAxgaM2/ZbTu0UGg9Wd7bFqWESfkjIC5AqMpaA
         SL15oHh+/gu8DglLuXN7aE77t3b4H3g1Ps/peRDOGdWQS72NSdxvgBod7scQPGVX1Jwe
         qvpG8VmYnPTUoY8OkLDCmgCI4Qa3WWQQOOZIoLlKPQfkgmDVoSyAEY5FiIziwRDofONR
         QS4GGecAtAJ6I/i+9S+zKtTT0nf/12qxBe0MqmvIWr5Rr8MLhXf6+gaPVcfyCRJb0LK8
         7oWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795007992; x=1795612792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jewcBXyAjPJVV3XNKZQtYMrq6DypFvpPXn3B2o2g9R8=;
        b=zi6cKXVGewwzcdOBovRHS9gzRt7Wmi7N7oPka1TRozYnF6oCoMtnUklcSxZO/kdXDK
         yB508Ph3YjZ8FcUPMZKL35sg2bmN9X5msGZnSjXrb9z1HXRY/ZLbAKmcVqHN0xSxt4WQ
         M0M2RHpxL2iiyaiz67FqGuFGJsGZqPy5sc+jjHBihMNueGPSfgcI3vLrb05EIIdC/21o
         Nb8ZKO+gWdIq4CzkNYOmscl2/BGCSuO+mIz09sSfLcMtHDaca/v3cLyCgbbm/tCKwIqZ
         mGTYaQSKMBJjzuNLbHcuWIO5qHbZpr/RXtILlT76R+nslPKuGLp85DuxsRZGV50RadKA
         aSWw==
X-Gm-Message-State: APuU4Z8HusYv/Eyy6T2UqIyxpyftCQTAolllbPxSNplL7tEWkV2LKjZL
	fXGw1nB+RXRQeqyLxLDI1uB2GvBMINC1sirz2wB3Rm0AMmDlQ7lUR8GU
X-Gm-Gg: AYBFou3Gyv4RB/MDLQcyKc5CZ91esJBGDDyt/CiaRg4RzpK/qyz9wCAWUR/GDRkyVqY
	P8ut75UigaK/uvOhD6hvFISu9ta2wc7gutu+fXQ9dSo4eM9HCCxQIhjtCbHFFl8M0ii+4RsI+bq
	359q6kMgzNXicG9dEExPextIE5n2CHU8MuuSk72anZlSp9RrJ5LckpVASdvsNZA33hyux9tI2U3
	+4/SdQfkLHvQSZ4OVib6+CL0OmYHydiYTjau+2Mz49EMOURL45vvd/cNvVVQRf33qEN/mBJd28o
	BbocwDvJKVNNndhbAHSm6pArdacJXB6hCVcrKbWQEgnUQp/XmXbl7ZAFk2eculSpGicAU0Jv2mu
	oR48eP65pDS6n3fI1o6vrZ/x72M2Ft/9EqvKGsymcCMk1ku7VjnXx8pRWLzUpJWIlKan8gzliJJ
	Luh0tFTrFVzzbN2/sgQIOX0XvZFUHAdoERXqWNFiyAe5YjLt26ekRLMMU8uzcaawMV80pdsA/G9
	anE0PhQk6zS9V9L/Trz3VdXfyRg1mZNzUlSskkWzyfHIGP8QLx9ZIIGCw3zSjrN1x2NrTGYSTlT
	q1m0p6hMUn+20mg+N36yuv2G2N/D+66FoMzOFHtH5IP9R0969MIojygZoRVLXo4FwNAqpq2SuE7
	s8vCwY7nUeVBYnKRS1WbcGCwV/w==
X-Received: by 2002:a05:600c:a013:b0:4a2:526b:d40f with SMTP id 5b1f17b1804b1-4bb7d57749dmr47878945e9.0.1795007992279;
        Wed, 18 Nov 2026 05:19:52 -0800 (PST)
Received: from SurHub.localdomain ([196.188.113.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb7e513c28sm24342875e9.0.2026.11.18.05.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:19:51 -0800 (PST)
From: Abdifatah Suruur <suruurism@gmail.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] IB/hfi1: clear VM_MAYWRITE on read-only STATUS mmap
Date: Wed, 18 Nov 2026 16:19:46 +0300
Message-ID: <20261118131948.28748-1-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
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

hfi1_file_mmap() rejects a writable mapping of the device status page,
but leaves VM_MAYWRITE set in the VMA flags. Userspace can map the page
read-only and then upgrade it to writable with mprotect(), bypassing
the check and writing to a device-owned status page.

Clear VM_MAYWRITE on this path, as the RTAIL and SUBCTXT_EGRBUF cases in
the same function already do.

Fixes: 12220267645c ("IB/hfi: Protect against writable mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

---
diff --git a/drivers/infiniband/hw/hfi1/file_ops.c b/drivers/infiniband/hw/hfi1/file_ops.c
index 680364fda856f..779dbe32c69da 100644
--- a/drivers/infiniband/hw/hfi1/file_ops.c
+++ b/drivers/infiniband/hw/hfi1/file_ops.c
@@ -492,6 +492,7 @@ static int hfi1_file_mmap(struct file *fp, struct vm_area_struct *vma)
 			ret = -EPERM;
 			goto done;
 		}
+		flags &= ~VM_MAYWRITE;
 		memaddr = kvirt_to_phys((void *)dd->status);
 		memlen = PAGE_SIZE;
 		break;
