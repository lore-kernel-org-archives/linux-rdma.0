Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E21566C7B
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788882315; cv=none; b=NCyJwApnjO3buq7ZjkxcXAXivnmHwbgGSHC0tEmDaisDPIKZtsaBnCUgjn+ndqDfAyCJMmVh43MgCfJmN02MXwrYGxvv11tmVOgnDxb7ShdwO93xdoNZojqUbAOCMUA0cqITYdD1gByOjAvsGJF/F2IQxUMhCOYYaGrykcoIm5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788882315; c=relaxed/simple;
	bh=UM1MBT/BJUGhWApI+IfB2Mek7UMuH86ncQOmZxWBn1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ERjU9LamUQ+NMzeasUiQBrvrE1EbS5dtleaIUnnjMXsqcNGwyXMHxWR2O4qLMPqJ6NX/xO5ZComguFiysBKhvhvDndzNLBYVbAHYgvfeBJJBXX2UMEG9FdtKhuHj9is+zRaRGPt5ODUCJmW5G9ll+cNhvDbvdz1+BaPrnMIS2tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G8e/7D2B; arc=none smtp.client-ip=74.125.224.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G8e/7D2B"
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-66c7e3a2332so3511424d50.2
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 08:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788882313; x=1789487113; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WekuzezNfimNZjny0pBl2QWRYC2pvuksOZKhLQ04/po=;
        b=G8e/7D2BAZJ7ZbwPsft1SkfkTeI8xHXImohFWugrsoy/dUC6EFUuGCiwWexcPYwhh3
         kq49Ysul0LRMmXUTiRBdcIBfBjvVh3ghL1SkVIWOzsXAQeheTgeQYuT4qP1s++8bjVNi
         ACxlXd6Fjgx1K7hQubUMDwnlD7bi7B7TXjYwWYztTjJfYYw3z6wnPZLR9s60O2XZHlgm
         nV2r5OU8hu818/ITiUcVDs1SH3k3zkGUwvLrme0oNtQHu8Vq7Ufl+CJEZ4bVVxFEMa7V
         ozbEktrIwMkniMON2R8UHa+4qvtlQG0lTCnCTwUVTLB43KwBgqAHiu8qWywO88JAcpa9
         toYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788882313; x=1789487113;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WekuzezNfimNZjny0pBl2QWRYC2pvuksOZKhLQ04/po=;
        b=XWA8ZrSH+Fs8TBPM9174BP2zLMoCf2CG+g5lTrjpl5xx0nKep+aA2mIWcgROTP2kpy
         Y8t1OvdwDz9yp/cJZyerjja7rv6msykzwiwFGQE7jc02MqAvPCnAHodg+KAU7p1XYu5D
         DplPXFN5jEg+ffxWnNlY3OugoXxO2LwVdpFeoOXMfFm5IC3EEfF/wsOucq7ExGgL7OIW
         V7LatttsZ1LmOFZsd8T7f0qdFq8l+l/fCv9XvtUHV+gOej7m/nb3Y+0f3jwowE/fOZM+
         u+6XhUw3HiZbZ9ojQAD176eRU0ldxqvGPylTj7fqMhB5sPuZg1mxNykNf+GdqRGSQoI+
         S1ag==
X-Gm-Message-State: AFuF++mCvS/bJnDauD6O7IqH/+fTMgGsnUAskYQqQGgINeyg3nRiHwxM
	dKf9Z5+sOG1p0o2M+NeRZfDe3GxANSWNoA8GhKZI56Oq4reeZOFRftAxELj1FJRjCm8=
X-Gm-Gg: AYBFou0Yj590CdQheHWtWr+EfWkZTIfI9IKYYWrBomQGJv3ydQC9x4vNooWT4bY3wak
	wKiG1T0UnbsKuTNGXUxcNkvr1H2esMtX7r1jEvZuvp/m3KSS9gx4B35Q/lhQ/B+04WgP6BGk5yG
	HtVrTaMIpXKcrT+7p3rfeFUeYVHV7sn3lcgBIJbjQ2/vGiJPjiEpPql9aVyPqztwi0CEY9xBLP0
	JhKKBIXij76EHbfqLGldSCIShJ2AFoHY7yk8soUd09g/gFbluwUL8vgd+Ta0Ga1GXYq9q1fQR4O
	6iOeG80LqMReQgxu5sfh8N20sFo/zV/FeBIF/yBDBlUZwhOrcO2kgK3Ic19sevX9Lts/H1RqHvl
	LzKY8bRVhsEMYvsOxv7kJjaOIl4t/fW2NVcVdlm5yFt683k04ZTvmQw3eTABkopo5pRMC5IuI56
	7u50qKYsm0sruMFXivgSQQKf7hVd4527ruwWlM6i3fM+ocbrEGfkBfHITRCmI9p7x2ttdvKuK+o
	ymaAShtsm4FzolnoeMoksjsg5NrWCLCqAhdJqreMgHNv70lnmS3iZ4EvNKVD9aj6gUkN52S3w==
X-Received: by 2002:a05:690e:1244:b0:66c:707b:60eb with SMTP id 956f58d0204a3-66fb5a149f7mr8100296d50.23.1788882312712;
        Tue, 08 Sep 2026 08:45:12 -0700 (PDT)
Received: from Ammar-PC-Fedora.tail72f32.ts.net ([2600:1702:7bd1:29f:8000::1])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104049d30asm120779386d6.0.2026.09.08.08.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 08:45:12 -0700 (PDT)
From: Ammar Ratnani <ammrat13@gmail.com>
To: linux-rdma@vger.kernel.org
Cc: Ammar Ratnani <ammrat13@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Stefan Metzmacher <metze@samba.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Ammar Ratnani <aratnani@nvidia.com>,
	Kechen Lu <kechenl@nvidia.com>,
	Mithun Maragiri <mmaragiri@nvidia.com>
Subject: [PATCH 0/2] smbdirect: don't hang on netdev reconfiguration
Date: Tue,  8 Sep 2026 08:44:25 -0700
Message-ID: <20260908154454.10966-1-ammrat13@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When I mount a CIFS share using SMB Direct over RoCEv2, I observe a kernel
thread hang if I "configure" its slave network device by taking its link
down and bringing it back up. Attempting to just `ls` the mount point in
this state gives EHOSTDOWN.

I believe the following is the root-cause of the hang: When the link is
taken down, the corresponding GID Table Entry is marked as pending deletion
and has its slave ndev set to NULL. All sends on RDMA connections still
using that GID Table Entry fail at MAD creation. SMB Direct eventually
detects this and tries to disconnect / reconnect to recover. Unfortunately,
disconnecting requires successfully sending either a DREQ or a DREP. Since
neither of them even post, the connection remains in the RDMA_CM_CONNECT
state, and no callback moves it out. The SMB Direct layer never gets the
RDMA_CM_EVENT_DISCONNECTED it's waiting for, and hangs.

Fix this in the CMA. If we call `rdma_disconnect` on a connected connection
and we fail to send both a DREP and a DREQ; disconnect, and thereby send
the `RDMA_CM_EVENT_DISCONNECTED` event to SMB Direct.

I tested this change in QEMU using RXE. I ran Ubuntu 26.04.1 with a
mainline kernel. On commit 9f0346dcbea3 ("Merge tag 'driver-core-7.3-rc2'
of git://git.kernel.org/pub/scm/linux/kernel/git/driver-core/driver-core"),
I reproduce the hang. With this patch applied, SMB Direct immediately
disconnects and reconnects when the slave device is brought down then up.
Listing and reading files from the mount point also work afterwards.

Artifacts for reproducing the hang and testing my fix are available at

    https://github.com/ammrat13/linux-cifs

There, you can find: logs from the "bad" and "good" kernels, the kernel
configuration, the VMs' configuration, and a playbook to trigger the hang.

Ammar Ratnani (2):
  infiniband: force disconnect if DREP and DREQ fail
  infiniband: trace force disconnections

 drivers/infiniband/core/cma.c       | 41 ++++++++++++++++++++++++++---
 drivers/infiniband/core/cma_trace.h |  1 +
 2 files changed, 38 insertions(+), 4 deletions(-)

-- 
2.55.0
