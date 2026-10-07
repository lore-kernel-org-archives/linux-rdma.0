Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D143F3914EB
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 22:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791412348; cv=none; b=Y8HHU4rUzOiIdod9zgW6bk0shV0atEl1YF4NEvPEg1UW7UVlzNlltFEayJi7WjeDtYtQJ9byEJgAX3EvLvddSF1O6QE38YkJ0pNw1gFB3hXevp/55Zs7ZhGByx3656cL8ftjw7fc530+F0KpTP4sHBoXObtgo6lztYlcWEUb9IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791412348; c=relaxed/simple;
	bh=4M18bMgvdRGJDiD23QqzIbOOWWQtTqINwj+K3l62LQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CmQjj/pyIiestXKPYrUQioi1nKLXsaZqG/mA6AXgg7+jzX58EFwHY/wsJABMG9AYcFc2psBN9uhf+JnlJD3lS3kTcl8HpyEC46HdF09+22tHxFLbZ4Vf3m/DVMXbioUAxtaMe4ISWekPUjOFUb/1j4FaEJ0nzMhOen66mY6xsBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XYZ59GIs; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XYZ59GIs"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a02667ccebso19293055e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 15:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791412345; x=1792017145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LsGpXsjhSIt6Hp0xVu6tLDy44l44xi/XBn27PlboDSQ=;
        b=XYZ59GIsxpnHuTNP5U8zx5cdGE6HpdQ4T4y71a9yyZb+gZAjDUJ56MUGx/nVhWpj7x
         mQYfqaBJiX9CpSLdEso9AFr2yTpAIMLLxor/+AvtanCHodS9/hx18l5DmXEsAzaagfb+
         7vZ+j83ci69tqiCPfJpyV2ejNELGuQo8+y9/KXS2lzk3GrzKQmosTH6Wm1h2j6cURGV4
         4NQXdrDPFjlws34h0GcjKoaZ65VUU8+8TUZjLgJ1N1Tph/ilgqvFPw2EqX2v0JzpE4QQ
         nW/2uwfibQwfh466PLn/YSzDPZImFabaeDe5L5akiXrtBcIwQY35ssGd22t7zNtVr7qX
         GAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791412345; x=1792017145;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LsGpXsjhSIt6Hp0xVu6tLDy44l44xi/XBn27PlboDSQ=;
        b=E2gI0DP/gb0Blosyu9N4vG23QX0jyk7S4tg9g8y0eerYDgOhmQ2/69fZh1IZ8uimV7
         RttZ+7FIaUs1hvkloFhtRAjAuZ8/ZGTsnDodohmHJtzR/QVcVqY+SDPKuHh04sRnJ1fc
         bIQuTXKxjmAbPk9cqO4ITBsFHdWBHqCvB4nGXvBnH50YG3Ln9i25o0se+rGJJlQ5S5/J
         8QpQNRTS1HfplrODJu5zkCcre44rZJVvNfLwwYIGKTIrFi+X9l21n99fhR5q7JEt0WNB
         Qe+kw8j5WJNEaWGGtOPBH8LkfBqXlLaDTztNol0fabvCZU7g0Id/EvRKNRhpqsNpj2k1
         4nKg==
X-Gm-Message-State: AFuF++mFWKm/+0NyLMn1UIKd9ahyuBf14xxLBsmnMGqQ2ay/BBF53t08
	jPQf5ZTiUL6Us0ZHhoCPX9j3eX4mBDUbecgYV/xRcBLIaLpo47mjNoAaEhEN
X-Gm-Gg: AYBFou32SOt00eRzYce4aDCpH67LpK2wapa6QeDngqVLDNY8u7EsChX70G7fPK51g/d
	iY5CAqh+hQRf3Y7X3kAQWOGOjLTc0tbnQ2kSZN5DD6JxgYUrfzpYsjA+UlGa48yQnjEsJ0u13QF
	6jinV4bTvetlIphoGaHqxCogA4BjA8BRpxkyDlLK8+Y9NBhRHJL50Xn6w4RTd/prmikqQ11o/77
	uTkWwgsh+b9XIlQyk3JIJ/JuR9FxsLk3vX6RJXjkGwfECDdPMNveyV+RRSZtb0KeDIo+x9GpUKN
	KYeCkDC2xK9IP/HpV79db5B5LI3B3xVj0ZZ7sN7JwmHWMo4RnUV/rXtbNxTmiIkx362y8Q2STXG
	ny1tk/Kpm9IXeRHHFKC0KgwnUxBnk8zVVQ99Dk2shmjM3cUtDfI38rdc7TE5IurKcgazdjnnFCO
	ZFL6qnHwnMRrwtJSxJeG827BWYxVzvtWVbv0Bq0sc=
X-Received: by 2002:a05:600c:c4a6:b0:49f:ec98:f030 with SMTP id 5b1f17b1804b1-4a1806719aemr65687335e9.33.1791412344962;
        Wed, 07 Oct 2026 15:32:24 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d1fec3sm7743500f8f.37.2026.10.07.15.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 15:32:24 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	zyjzyj2000@gmail.com,
	bob.pearson@hpe.com,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v4 0/2] RDMA/rxe: fix TOCTOU races in send WQE processing
Date: Wed,  7 Oct 2026 22:32:20 +0000
Message-ID: <20261007223222.2342804-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

The SoftRoCE driver maps its send work queue into userspace for direct
posting. The kernel reads WQE fields directly from this shared mapping,
which allows a concurrent userspace thread to modify fields between
kernel reads -- classic TOCTOU.

This series copies each send WQE to a kernel-private buffer before
processing, in both the requester (patch 1) and completer (patch 2)
paths.

Changes since v3:
  - Copy the full queue element (max_sge SGEs) instead of computing a
    per-WQE copy size from num_sge. This ensures inline data (which
    shares the flex array with SGEs) is always captured, and eliminates
    a TOCTOU on the copy size itself.
  - Clamp dma.num_sge against qp->sq.max_sge after copy (patch 2)
    instead of against the global RXE_MAX_SGE constant.
  - Invalidate the cached copy on QP reset (rxe_qp_reset), on the
    ERR flush path, and on the RESET state check in the requester.
    This prevents stale-cache reuse after state transitions.
  - Each patch now also touches rxe_qp.c for the reset invalidation.

Changes since v2:
  - Addressed review comments on naming and ordering.
  - Writeback status using WRITE_ONCE() instead of plain store.
  - Added smp_store_release() in requester for state transitions.

Changes since v1:
  - Split into per-path patches (requester, completer).
  - Cache the local copy across retransmits and multi-packet operations.
  - Added writeback of completion status and rd_atomic state.

Tristan Madani (2):
  RDMA/rxe: copy send WQE to kernel buffer before processing
  RDMA/rxe: copy send WQE to kernel buffer in completer path

 drivers/infiniband/sw/rxe/rxe_comp.c  | 53 +++++++++++++++++++++++++-
 drivers/infiniband/sw/rxe/rxe_qp.c    |  2 +
 drivers/infiniband/sw/rxe/rxe_req.c   | 55 +++++++++++++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_verbs.h | 12 ++++++
 4 files changed, 116 insertions(+), 6 deletions(-)

-- 
2.47.3
