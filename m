Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384145;
	b=PRlCmdGhK6JsRUDUtID27FLBx6ah7TfbeoLfMbb8amTETUEX5uuJ1271onqov3Y88VjP
	 WuEHMxlN70Vb7716mjK+hmbJphkxI1Tu41pez6r3UZ4AiEX6y6ZT7Pte9ioYfSB7Ax7Sw
	 U2hhnewwUaBkGZylJtq7rMT/ES9bNIBwskQodsz8klDkTsUSOesDke9tGwMYzxizP1aOx
	 V3lq796IhnX2wIvqe/TzcTO84Kr4ype7jDMSNCMdD/SJdbRHZiDNtnSksQ538OCVrCvOu
	 +KjxD56FzCDwG0xaArZuzpst6yan0CvDHDQAdkDADuvQKdlKP1SaqhD4MwVGYZQpn2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384145;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wCcV0rg12r0VQC1RmFLoD9rDhMDyyca61RfRGBocBOM=;
	b=WjlCZwWJYsfowmmkpUKK2zR2fOzoL3rL13pnNciuMTWbu27U4AFDNPvAew/cCCjRtV9I
	 GxZ5B2vVaN5TdjZVINlyIB8xGLh+FaV3g+luHdVZWop+yOvJaoX5ENa5Dl/339AAiAC9M
	 c1kjeZUvvb6R2qpLHsjvDd4krtzvEG6sbG1aSNoIG5VB1cy+w7FTxt0Trvntyz1mHXkWz
	 cYRsF6rb8TFkS4wIpVeMjEHLSbtq3F23fwYoLIeH22Pa5k0D6lQW02uNrbUdlEolUGdtc
	 Twhrkd8X2D0SQ5TwrqQ+Ig/b6sv5u0qwhvYR08dyPnH2PZ6bmFQpb5QIkGUXoqfuaGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=x6u.co;
	spf=pass smtp.mailfrom=x6u.co;
	dkim=pass header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=iWXYbrXf;
	arc=none smtp.remote-ip=209.85.217.50
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A86F606A31A
	for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 18:15:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A86F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=x6u.co
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=x6u.co
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=x6u.co header.i=@x6u.co header.a=rsa-sha256 header.s=google header.b=iWXYbrXf
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-74ab99038afso671310137.3
        for <linux-rdma@vger.kernel.org>; Fri, 30 Oct 2026 11:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x6u.co; s=google; t=1793384144; x=1793988944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wCcV0rg12r0VQC1RmFLoD9rDhMDyyca61RfRGBocBOM=;
        b=iWXYbrXfu5hW2s3o3NyEH3ysvIQRWa+eRuSLHPgi4zKa5vI/fbl9OkezffsokkFKLG
         mT0PXgz88oWvayTXyWq/EGZPauJyG5XsfYorOS2w2XnUGnJG69/I8cvGX73pYKMJA9Ah
         4NMyuzhDuN3R1gQQkQTWAp5HMHyzd6x+9qVNvdWiwNMaKqwTlebbSD9GxvG5d4N7ps38
         DbcmDdxPmwVhOYR34rSjZiwbO8rvOQeb8uWu6Tab0/f2T/nBMxeG6IhZGXqBpGewZgJ4
         nTASu0Tbxt/t2ldo2hlQ4BOLQxvagdABp4/2aVh+G76tSyA4djFn0HjLRVnu2i0bJRdF
         Ar9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793384144; x=1793988944;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wCcV0rg12r0VQC1RmFLoD9rDhMDyyca61RfRGBocBOM=;
        b=tCWvqGOGZJUzGNsmbSRtvTftLUUe2xrmaE6fbYQ29LiB7q0j6EPSw7wRAwYWQajkBl
         sa0vQICO3mRlvK2nRXdTsgdFoeaChamlzuZvjxtYYwQ8cOjyGkSsLmctFCvxnvzCPT5L
         4pnca5RK9DAW3NRBfpMOJig8SfVHt+mbf9QT4NMSdopQOh9hEBmzPXK8ZDjr860hS4w9
         kwXuK6U7qCYVDgCMIG7uSKzfiQFmPXOEdqPdR7SI8AsPUQTn8z7CKiDqlSVV4owNaijW
         kvAsXsCg4YnF0E3KWxab2S7QIcu68ciDC2ckDgptAjpxgwxt5w7Lp+u0Chz8t8Ab8YEo
         h72w==
X-Forwarded-Encrypted: i=1; AKwUvBwOqAn9qRogRmYFLHJJgohTwnBWOH0SusmGdobiR/UZJ/giOKsA807Y3mlIJjfDr1KDR6/p4QhaWQiH@vger.kernel.org
X-Gm-Message-State: AFq9FYLHWjD9h6WMq4lLOJ0qb7h24roHmF3ZtTjtpd2YjiViZP3Y1lod
	3hbdPypzEXXqzWUGCAGs2w9T6XrNUKJcpYA5k7AYrACKQvSn/w59evxnMWbETvJ8lnOE
X-Gm-Gg: AYBFou2jgfJFvphYRCCcS9CGsjSkJOna+uDOSAakeMpkl6TuQLVaaCjt52mcfZSV8Lb
	NxIRC9H/8MNQFFZuyo3H0tsnduA6I8HgzOausxF6aeUlrdQHBGc4QiVCxuDofVhF/YlIiEoRFRN
	6kFM22k/4xbcbYG/e0iH7HuuR/GeiOe6W8DTc98jBEV/nAA2eF7yoqQW4kxFfJBfxJgBMfNoPhp
	JpDXoonezKrnQa9Wa8FU2dmkIFHq4B/8LZWFb3Iof82BBOGmKMe7FBa6uR9yHhJzQnjbje/nJez
	KVq/6VGNEzisszlXQAdQ8s4tUH5dVVt1Ouma6QP0nIay1rRwoV/JVzd5SH3fT8e9DidA+AHSer2
	zGR2DHVW0RJCkWRru3n9miO+/p1gXjoNcCdnUNiFqzyI4/Bu/ZW/1Z0cF4PZjv28/BTgpd/YZJf
	BBQB73PS/RUSvZMmSqJ+ncf/xB/vLQQoxVU3MoQV41cZXtP3ExdUpAMgdVzjt/LwIQ8CdjN3/3w
	BaO89i/8klaG1BLTkQz6ONf9nTTMrylB17+SuHarOO0joaNj3uSwY5CNTqXdgYuPMgHJ86W9Tyx
	/1RJkYO1iaO7N65QVnYqJYTZPKmyqH/7ewTC3nCjpf7w2sMe9HmTz5dx14D4kivBOInSH8nvyh9
	bHsJPaLNvNrmI1hj0bgSeh3Q9rtq5WoZiYswOq/OuV+8=
X-Received: by 2002:a05:6102:442c:b0:7d0:6cf3:d8f3 with SMTP id ada2fe7eead31-7d0726cdc38mr1776278137.18.1793384143954;
        Fri, 30 Oct 2026 11:15:43 -0700 (PDT)
Received: from worldpeace10.c.googlers.com.com (109.243.150.34.bc.googleusercontent.com. [34.150.243.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7d07754c1c6sm3077931137.3.2026.10.30.11.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 11:15:43 -0700 (PDT)
From: David Hu <dhu@x6u.co>
To: Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jacob Moroni <jmoroni@google.com>,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Hu <xuehaohu@google.com>
Subject: [PATCH rdma-next v4 0/6] RDMA/irdma: Add support for ioctl
Date: Fri, 30 Oct 2026 18:15:06 +0000
Message-ID: <20261030181512.2056056-1-dhu@x6u.co>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
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

From: David Hu <xuehaohu@google.com>

Hello,

This patch series introduces support for uverbs ioctl queue creation
(QP, CQ, and SRQ) in the irdma driver. This series makes progress towards
modernizing irdma. This enables 1-step queue creation from pinned UMEMs
and shared dma-buf heaps (system_cc_shared), providing RDMA support for
Confidential Computing (CoCo) guest environments where memory encryption
otherwise prevents standard host-VA-based queues from operating.

Historically, irdma relied on legacy write() commands for queue setup.
This series modernizes irdma's queue creation path by adopting the ioctl
infrastructure:

1. Plumbs uverbs_attr_bundle into the irdma QP and SRQ creation routines.
2. Registers irdma's UVERBS ioctl namespace definition for QP, CQ, and SRQ.
3. Implements 1-step queue buffer creation for QP, CQ, and SRQ using
   UVERBS_ATTR_CREATE_*_BUF_UMEM attributes and ib_umem_get_attr(),
   configuring hardware Page Buffer Lists (PBLs) directly from pinned umems.
4. Split CQ creation setup logic by umode and kmode into separate
   routines to be consistent with other queue creation logic.
5. Adds support for driver-specific shadow area UMEM attributes during CQ
   creation with CQ resize capability.
6. Preserves backward compatibility with legacy 2-step write() path
   registrations when UMEM attributes are not provided.

User space rdma-core PR: https://github.com/linux-rdma/rdma-core/pull/1766

Testing:
Verified with rc_pingpong, srq_pingpong, and dmabuf_pingpong over irdma
devices in Confidential VM environments.

Changes in v4:
- Reject dma-buf queue creation in iWARP mode and enforce page-offset
  alignment unconditionally in irdma_setup_q_pbl_from_umem() (Jacob)
- Bound attr->cqe in irdma_create_user_cq() to prevent cq_pages overflow (Sashiko)
- Fix to irdma_cq_free_rsrc() was sent separately (Sashiko)
- Link to v3: https://lore.kernel.org/all/20261016202909.1289496-1-dhu@x6u.co/

Changes in v3:
- Improve patch 4/6 to split umode cq creation to a new callback
  .create_user_cq() (irdma_create_user_cq) (Leon)
- Clean up duplicate bounds and NULL checks in cq creation path (Leon)
- Link to v2: https://lore.kernel.org/all/20261015011940.4122452-1-dhu@x6u.co/

Changes in v2:
- Add patch 4/6 to split out setup logic from irdma_create_cq() into
  umode and kmode helpers (Leon).
- Rewrap commit messages to ~75 characters (Leon).
- Fix a pble/umem resource leak in irdma_resize_cq() (Sashiko).
- Link to v1: https://lore.kernel.org/all/20261011011022.1445352-1-dhu@x6u.co/

David Hu (6):
  RDMA/irdma: Plumb uverbs_attr_bundle for QP, SRQ
  RDMA/irdma: Register irdma UVERBS ioctl namespace
  RDMA/irdma: Support UMEM attribute for QP creation
  RDMA/irdma: Split CQ setup to umode and kmode
  RDMA/irdma: Support UMEM attribute for CQ creation
  RDMA/irdma: Support UMEM attribute for SRQ creation

 drivers/infiniband/hw/irdma/utils.c |  12 +-
 drivers/infiniband/hw/irdma/verbs.c | 759 ++++++++++++++++++++--------
 include/uapi/rdma/irdma-abi.h       |   5 +
 3 files changed, 573 insertions(+), 203 deletions(-)


base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.56.0.317.g454f8302e1-goog

