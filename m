Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793248050;
	b=hEGTNxJbd755ZdzH80PIWlXsYq9atp/Lx7vHc4ztt0V6tEbbmWdBNf9jWYS8exKC2Nds
	 /1+tPFs0/O/sL6kHMM3nbzTKM+rrxlyaSEz3QiG5gTkCf90tzMEZjHRUQNlPQbX6NlCra
	 J9c1AeQc7MCfxdKyzzH8ezYY+UPQQV6gpnRkz7OwHaO4XuuKb1NteSOwjC5ib4B1C6PbA
	 8JbYR9xIQ4gNiHiMXPbJfbc+PvWnhQjy/r5G8etYM9GtZXE2pxhw/CtJOSZGMfnEWua6S
	 uHSffBNQXzM2DpvK/UwIhy8WfFaaQtdSEWaUXEPfhSrnspSERK3L2Wkq0vDD7s+bKIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793248050;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mxbVMUzWax0uAxNX40g1OGro32Jp/gDaHDkDHqxdT/w=;
	b=fW+SYNwuvxQwMdmtXdARCAn3d31KqueCo7I/eyV6vrz44GNk6HRSzEJu3H1JI1b5eLHN
	 hJRJK4oUenR8D7ImL6PpS3Dl9AzrCFjv3YJek4H93V3qrI3GZQED9YL+CQnSC1VEZH9Ck
	 41w3eebj6LstrJ3x1dm3QJkn0aoo5R20gySD5W6yr3/Edo33yKpU11cRvKzLNSG/MKNWM
	 X1uEJomU/1Yf1eGl5RbYy6Zp7WKqFbQ7HFPadene19dMhSEVs+7gbVSq1MfNKc/IQkbEN
	 OBWLnF4WdUpnhAAV/G6ASyUThT2ekmQnRNgmvTHUCHvzlZ8KxTrjVd8Qqrv5/zpcKJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sKpoZlHk;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8660E606A31A
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 04:27:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8660E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=sKpoZlHk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso984079a91.0
        for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 21:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793248049; x=1793852849; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mxbVMUzWax0uAxNX40g1OGro32Jp/gDaHDkDHqxdT/w=;
        b=sKpoZlHkZAGlA4AwBctxXproaGE+nyIl8R+Z/dyRTS0KQYMudvu1eJs9+hOE7Lv+6f
         wL1gY3b6iQrjgY9d4Dr2rXdBYBa+y9NF51ifbRWFVeKfZYSo3PQBLgsWwj16d5dAEMHX
         7oVpqzqXpxSg8cyA2apF9+EyFRbrEKiIGpnzMXiL8xNQ5E/M7W8XtnIrNP6fzi+gGLz1
         7JAEhej67M/nISnTeQiI5Kh4m90uQ0KGaT+wyfTuj8cXTp7BjRxj0mdM0G50rL8xyvA1
         N+a4N7RN6GwitcQVOjHlw0OU9fam+Nt1/dtT6ivdPoVxr5wjFDsylpnl6sBn5E+BjpQ0
         Qn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793248049; x=1793852849;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mxbVMUzWax0uAxNX40g1OGro32Jp/gDaHDkDHqxdT/w=;
        b=N8bizz++sz+bIIVRrzeQ5+F4FNkDka5iEaQF/8WdtS+P1RgajbzUmzCd1X0uGIvuPX
         m89Vk+WQYvWA/D72EUWQI5i1DvLqDlvwoyj0bRCxaNo1Y4S7T1c7xg3MzyqGISGkKiXQ
         78GMHxWmLl9rOkClQY2no4WvMS7kkMG72ZL0qqPxd20SXGZjbuMsH9587+Pg5V4ZmU+2
         yV5YdZUnJXSWHZUv2UPo0sIyDBdVx09o1E96stmhBewhAkT4NuuECJZebBykl3XoFwCJ
         i2Px6C+UcD1Bf8x7ZsGbSbyXFAsABmIFPi0gTInNdeG1qcfgOad4O+zNo7fowK1WE7KJ
         tXsA==
X-Forwarded-Encrypted: i=1; AKwUvBwuEL6iNjHtz2o3IIsAsDUIxqzojaw94jG++9qfKSwNQYFxif0AsQfBSF2crM217O7Z/Bsul5/qal5G@vger.kernel.org
X-Gm-Message-State: AFq9FYLCCWeOVBTqb9s89EMP2x9PGo7rbZtH4iM7+PnZ1I4RI2/GqgZb
	08an5egCUSC6OWZJxkHyC7ecrl3N8oN2420kqq1w3yxfsofc4I3Ar1juwJSIaakJ
X-Gm-Gg: AYBFou3PaVt0MWBb3A/G53Ft4wnun+V8E3VEDpQs1RkrDIRikw2rmwpdoFqimHo1E1e
	MxjuzbBCI0Ao/tLzpZKxzODeCykHFghzllLsyZAlBUDE4GfV6ndgEVEe0Ec/NvRyhMeuE1mcLRO
	22oaB+7wy9MpueIq1WIMYsZC6+heTnj4f1Io7aaWUM7sMNwgX/yjx/jObIbfZDhbSCPchI3vgOS
	nMhlaJPqlBl85WYTVkwHm7xQ2Y7nEx1Cp/iUuL/eagGw5fRd6SAeWfS15CO5ZBmwd+uF6NC7Zgi
	SMdooMnXbvcuCOnRTuvQJxbwLP1JFrsGn+mgj2qDC+Ty8hFIo1zvUiJ/ktc6wl4irN9SEjP9/66
	5nkcpk9dK1NjlmZN4/RACkjmfLJzTY8BYplAcPZIqkYF1N69UkIeVLCGxnJ1247YKTAvwyQUiRc
	I19cV33mskbrGintPmiRPpry5sw2Emsy9J0pEJqSB9kypy+jXtRzaOX16CcyMED7zsp9Fte55Ul
	3YnzQ/fEHUrJkamSx7NuLf1AR07lN6bfD0uj8NLl19NSbeCScQYf62mhfjEHv9malvb8fMk7NZe
	X5eccpz2VxPo/l8C2DF3cJMDIOHobt1NV2fnsa6aIzK0Ri56yp2VKWM=
X-Received: by 2002:a17:90b:37cb:b0:3ac:a11a:7c91 with SMTP id 98e67ed59e1d1-3ae581bbd4bmr3387839a91.44.1793248048779;
        Wed, 28 Oct 2026 21:27:28 -0700 (PDT)
Received: from localhost.localdomain ([155.69.168.11])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e898317sm2010846a91.16.2026.10.28.21.27.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 21:27:28 -0700 (PDT)
From: Yuqiang Sun <izaiahsun@gmail.com>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	guoqing.jiang@linux.dev,
	gi-oh.kim@ionos.com,
	aleksei.marov@ionos.com,
	lgs201920130244@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] RDMA/rtrs-srv: fix use-after-free on sysfs setup failure
Date: Thu, 29 Oct 2026 12:27:16 +0800
Message-ID: <20261029042719.75868-1-izaiahsun@gmail.com>
X-Mailer: git-send-email 2.54.0
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

These patches fix use-after-free bugs on the error paths of the rtrs
server's sysfs setup, reached when a client's info request arrives and
creating the sysfs entries for its path fails.

Patch 1 is about what remains after commit 5b7437339011 ("RDMA/rtrs:
Fix use-after-free in path file creation cleanup", CVE-2026-64033).
That commit reordered the cleanup inside rtrs_srv_create_path_files(),
but the final kobject_put() there still frees srv_path while the caller
keeps using it and frees it again later; the stats kobject has the same
problem.

Patch 2 balances the session device reference: on these failure paths
it is dropped without having been taken, which frees the whole server
session while it is still in use.  Besides allocation failures,
device_add() also fails when a client sends an empty pathname, which
patch 3 rejects.

I first sent this to security@kernel.org, since the empty pathname
makes patch 2's bug reachable from the network.  The conclusion there
was that rtrs is deployed on trusted storage networks only, so this is
an ordinary bug and the series should simply be posted here.  Thanks to
everyone who replied so quickly.

The bugs were found on v7.2.12 and are present in the rdma for-next
branch, which this series is based on.  They were reproduced with KASAN
under KVM (soft-RoCE, rnbd mapping a brd device) by failing one
allocation at a time with failslab, restricted by call stack to the
sysfs setup, and the fixes were tested the same way, with lockdep and
kmemleak, and also with CONFIG_DEBUG_KOBJECT_RELEASE.  The empty
pathname was tested with a small user-space rtrs client.  The
reproduction setup is available on request.  Failures of the two
sysfs_create_group() calls were not injected, and nothing was tested on
RDMA hardware.

Two things seen while testing are not addressed here:

- The same pattern (a sysfs helper putting a kobject whose release
  frees an object its caller still owns) is present in the rtrs client
  (rtrs_clt_create_path_files() and both its callers) and in the rnbd
  server; separate reports and patches will follow.
- With CONFIG_DEBUG_KOBJECT_RELEASE, a normal map, I/O and unmap
  without fault injection triggers KASAN use-after-free reports from
  rnbd_destroy_sess_dev(), run as a delayed kobject release after the
  session it uses was freed by rnbd_srv_link_ev(); this happens with
  and without this series and will be reported with the rnbd issues.

The bugs were found with kbound, a research static analysis prototype,
and the patches were prepared with the help of an AI assistant, as
noted in the Assisted-by tags; I have reviewed and tested them as
described.

Yuqiang Sun (3):
  RDMA/rtrs-srv: Do not free the path on path file creation failure
  RDMA/rtrs-srv: Balance the session device reference in sysfs setup
  RDMA/rtrs-srv: Reject an empty pathname

 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c | 37 +++++++++++---------
 drivers/infiniband/ulp/rtrs/rtrs-srv.c       | 19 ++++++++--
 2 files changed, 38 insertions(+), 18 deletions(-)


base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.53.0
