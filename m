Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006755;
	b=qe20TJLo/d046NGj3S24SnjI4uJVBms+wJAomQjPfqqhgVF8P4p18vhxspzMGzHqQk3y
	 b9XkbpwXqa0+gxcUafe2YawnAn7I/2DDIfHGu3tz4mpkQclT6MZw5iHnI/BhyC3urKgWa
	 lFlx3Ucvpzr/dNpZWqZyjymMl0YAWqyuEJKnKNGbS8ajLN7a0cj7RkjXYPSKP6iq34Cw7
	 RQFQVv4OF86BfNZzZelnK48zG+ZWS3nGL7wvq68Z+DbiQC7WTYWRe4NHmy/7axrFTi0xN
	 R3vILUstdfbI762+QoOrdiVioK3paYTWP9lzj+TLu9Ax5OuLOjttvAVBZXL5idLybiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006755;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xV6SX5EGiGjtkdhAIi5UEb7NqFrGHjtbz3buhHPyzGY=;
	b=Qs+eVJAaXHLFDkji/dmWIlMmVFm28RRgh2AjXGL/s8lzjWcUPWrmbCkIhIvUnxMmSvQ+
	 jRVH5SNYRd4tfQT9WLmngNBkytMvsshoXVdbzrD8H+q8OY2BzIo//gswRUEU5/hsjsYLY
	 VKFo2EMV4n+agY8mUU8IgBaP1Hyc8M9hoyIJyB3pSp3TqrUhisR+sJEligiqwnlR3p4Hg
	 7mN7My2f+t3NdUDniXZAjmGtBLDSqcoCYB/cjD7qBqDHr7YXHiiRkB5+RH00Ub9gH+srm
	 7B450cr2UJTTj3k/BpQmoBCpR8jLwwn9FXpOfM/Uoml1i1uYUkRBzfdS9fBKb3uwang==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WiS4Pj7W;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A25606A325
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 12:59:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4A25606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WiS4Pj7W
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-491d1f66968so60853f8f.0
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 04:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795006753; x=1795611553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xV6SX5EGiGjtkdhAIi5UEb7NqFrGHjtbz3buhHPyzGY=;
        b=WiS4Pj7Wv+udGYtZHm2LbkFKbZxxeUir4cmqmN4Xc15StELrxcZz3IqJs9sBNj1SV5
         k+JsdyNDD7mmer6LwnNzCJ3NsbdOf94o0qxo6Jc9pcyEJxeM5ioUqrcFA9vqxibZ0J2o
         a7fn2brMmX5EJEf4p5W7FM20vCGWwKxy5u12x1de9Dx12pyk16Ew2l7IRN90alNrrW7K
         EUlrHC2tA3rFXnXyA4pIUg2kOVwu85EY4pAkVe/87CeDgVgdAEt+bOdy9v/fG/gbIJpV
         cB4c3VveUMYyMN2Ca1sfohiAL6ct+gK3Dy0MNkOh6656BTTW14/qA4sNDzBdoShj6nCx
         mXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795006753; x=1795611553;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xV6SX5EGiGjtkdhAIi5UEb7NqFrGHjtbz3buhHPyzGY=;
        b=Yl6tFOdkMNQQhuRk28dmnUuon24cgH7fc8pDWOf9DaNZ5P5ulwRalgwWyHV3smz5ZD
         1fIuiFUC0JsPq6ATiWT2psjNo5rkbr41d35uDeXY/GZIubq05yqOCbXX4APCkaKl7Gt5
         pT52OjSovz7fh6EpXxqD6C3hRJy3KvXLjPkWS3CBq8uJ190PjpH/FSiFfTsYPwyciw6g
         X/VTs80+5YZkyOE2tmVEudmEgF9fTkMOztivK8XJ8W0RgEnu+xNSu8dvbbRwKPo45nPa
         JhqBN2m7i8pvUFOPBXZLSgz6JwBsa1YOVdQD+oilPkjN0+gyTxsgRHX0iUMD7KvUV94p
         b8Vw==
X-Gm-Message-State: APuU4Z/ibP/WVtJF0mZ6oemD/fRrUPojR/qT8ZV97W5uh0O8tRjHa6ch
	0LHgL0mUrTFQswJfpPJJtvApMUyZ78vSJN2aYPDQ9kwiV+totUDfetmZ
X-Gm-Gg: AZFdTZcV0D6FDNFZsIx484kSV4Q4OCxizrn6ocRof+kH44bJKGUioBAjBYBbGL3t/An
	RFlhCGfSZAbYVmNBpLowjzB/kXiS3iVJLn93iiB40zrVIwKE8yFdDddp106aqi67CVEKbUoXioW
	9I5IWsOVUzAXUgtymVhA3dYHxlYVi8pnEL1z2jp3DMzLaW1mtDxYb5upi2i17iWNqi/eTdjnyG/
	93ORrb6F7L9NmdiTfSTtXl1elxXQMqEpivd/dH/EuqcuC4vGKa+K3SZs5pVYhBweq5yDXRLDT/X
	1V9HnapNedqwJ4ZTEO4qvxL+jhZCca62oP83NaCWqFGeWT9KLYQm0eDAopkauUmrM2F3KHmEeQb
	RB8kX7HjWU9VWRGmGP9sB8VDuqtdLaWLKEKs+6V/CPck1u8kKGeGOCOOwR6eRoCj2btbb/gZMnb
	GatVSqMq974n3IrtpvvxaLZZ68iyZAmejsf6COC7p1NLwR9nsne0dBjV7ISfUCHNB19NE+E+890
	LPb8tP9BslSYuOcDfdr0rmt4UQXMDrqtRsCV8ewTAN8s2yzdG0HpZg3S+sk/ONBWivI4ptI/xem
	4yby/TbOHuSCXs5YBZN4rPNjUOLgQkcXX7Woc3AwPyKqSee7XSyVXi8EC5SKJKhS2vC2GEKo+YM
	Os53T
X-Received: by 2002:a05:6000:1a8d:b0:48e:f10:ceb8 with SMTP id ffacd0b85a97d-4a63833975emr5859543f8f.11.1795006753058;
        Wed, 18 Nov 2026 04:59:13 -0800 (PST)
Received: from SurHub.localdomain ([196.188.113.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655db6d45sm4609457f8f.33.2026.11.18.04.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:59:12 -0800 (PST)
From: Abdifatah Suruur <suruurism@gmail.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdifatah Suruur <suruurism@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] IB/hfi1: clear VM_MAYWRITE on read-only STATUS mmap
Date: Wed, 18 Nov 2026 15:58:48 +0300
Message-ID: <20261118125848.26160-1-suruurism@gmail.com>
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
