Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com [209.85.219.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F350D3CDBDD
	for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 23:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782775540; cv=none; b=ts7V9rbtOBZufflx1XDXq9h33IBoqXwZ8Srt5PxsnnfD63Af5bA5cXfkPqHGYbMsvVhLhypeaqaRkVDNPQF0bHw41r2F/ETANV0NsoFfPccozCppu7lYlLOw1Qtd61Gmr3xk7f26Jdpa2LOgAiJwyJRNuVgFLAD4JTgufQfXlI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782775540; c=relaxed/simple;
	bh=8/ubOrG9cDKMtEr7yuFpe+V4hVjS5eKzzTJC2PHVi58=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=YLBIVJ5eD68i0LatjdGbgcXfjWaouKSxU2Y3M1E9YnTO0Fav2BSGfErlP4aShUulQn8dVRrp9esePMwhXb0Kzm+UoLu1r4+H+xTTKrnsCwj+BUnJaM4pCJzxheJlyukQXf8ttVqNDx6Cbd1uIQb529HMHSFcf40VMX2jjHj+q+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ye47SMBu; arc=none smtp.client-ip=209.85.219.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ye47SMBu"
Received: by mail-qv1-f74.google.com with SMTP id 6a1803df08f44-8ef8249f871so34407446d6.0
        for <linux-rdma@vger.kernel.org>; Mon, 29 Jun 2026 16:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782775538; x=1783380338; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kp6jYqBxIzHGk0HWHO9OEaC+YYZoMjPngJh52U79AXk=;
        b=Ye47SMBuA32oaT2PtKHRmZg241xUvCP3PlLtG5VPCNVSY3LGaMvmAqI2zgbXmqsxyP
         S5z2WnI22WNrU8mJ9C5xhAl4VF8sT63PX3lncdN6RaRo2gMt6USE82bdc5Bd7u86obi8
         t0Q+MmHOHKZKbgMON5Khp8/F4rSZDG5ItN9Ajrn/Deo8e16ohb/2yRIufCFlGM+Vnrs/
         tTj/xH5N0mu11iVSYjGXWcxvtWFquQERLUrROhbqXh0Pl/i1W5Lh+YTV/XsMflDLXsU9
         vnFsqOpY2xX6lxwLmrP2ebGYFiRgIf1/BlUP9B+ykD/4P+f+r/j9iLngKc70mft0mFBX
         DwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782775538; x=1783380338;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kp6jYqBxIzHGk0HWHO9OEaC+YYZoMjPngJh52U79AXk=;
        b=YM361BopUqsYJJfFdCtjaPkz0Gy1T/EeatLMFl8k7p2BlAWEB2L9f8Cq3hetH8NHLN
         FJeGCPFg83ff6NwCKML10TgbZ2FxWFhVOdEov6C3YNZ9MKzEI+q8GvL/Ym6KkaWyjTcG
         4OGMkcNXrQVLogi271EBF/nMOdDb6qPh3BRVsW+PP9VVqv5hToxpS0iQNGF2YP5QqlvM
         bMSxyPBd142EGUH2kROdbbOQTZM1ewDUXXmhWmFedab/hLkGZciR2ZFm7wCgJG9Wr2wj
         dyqOuj+C/G1jFBXSdnDKC301vIOchdwi4BnmPASWm9XOo8s5ttF8dyrT2IGqT39h57B9
         +3iw==
X-Gm-Message-State: AOJu0Yzp1guyRwX+SuGakpzzTCxarZytmp0PiEjS+DMnDUsPpyG3khB8
	AVntpSs+dyo3na0he2W5P4JkCcn/wCZhCB8rau1tFhsUSHMuM9ERJxsCXeCmEmZMeYxdFwyUYsA
	lFpnuiPiOAg==
X-Received: from qvbel18.prod.google.com ([2002:ad4:59d2:0:b0:8de:98c7:255e])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a0c:d804:0:b0:8f1:4bff:24e7
 with SMTP id 6a1803df08f44-8f1bc67de3dmr17220826d6.40.1782775537687; Mon, 29
 Jun 2026 16:25:37 -0700 (PDT)
Date: Mon, 29 Jun 2026 23:25:27 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260629232532.2057423-1-jmoroni@google.com>
Subject: [PATCH rdma-next v2 0/5] RDMA/irdma: Adopt robust udata
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

This series brings irdma up to uverbs_robust_udata compliance.

The driver has been audited to confirm that:

  1. Methods which do not accept udata input perform an explicit
     check for no (or zero value) input.

  2. Methods which do accept input perform the correct validation
     to ensure that additional udata beyond the kernel's current
     ABI definition is zero, and to enforce the required minimum
     length.

  3. Methods which do not return udata responses use the proper
     helper.

The irdma driver is backwards compatible with the legacy i40iw
provider, so special care was taken to avoid breaking any legacy
binaries, as there were some small differences in the ABI/semantics.

This has passed the rdma-unit-test suite using the normal irdma
provider from upstream rdma-core.

Changes in v2:
* Fixed Sashiko findings:
  - Moved ib_respond_empty_udata to beginning of most
    methods to close gaps where it could previously
    return 0 without calling ib_respond_empty_udata. This
    also fixes issues where the ib_respond_empty_udata
    call itself could fail, which may leave resources
    in an inconsistent state (kernel believes object
    is alive, but driver resources have been cleaned up).
  - Moved input validation to beginning of modify_qp
    methods to close gaps where the op could be invoked
    with udata but without input checking.
  - Fixed a QPN leak that could occur during QP create
    by moving input validation earlier.
    
v1: https://lore.kernel.org/linux-rdma/20260627025642.4064973-1-jmoroni@google.com/T/#t

Jacob Moroni (5):
  RDMA/irdma: Enforce empty udata input for no-input ops
  RDMA/irdma: Use robust udata input copy helpers
  RDMA/irdma: Use ib_respond_empty_udata where applicable
  RDMA/irdma: Use robust udata helper for QP creation
  RDMA/irdma: Enable uverbs_robust_udata compliance flag

 drivers/infiniband/hw/irdma/verbs.c | 217 +++++++++++++++++++---------
 include/uapi/rdma/irdma-abi.h       |   1 +
 2 files changed, 149 insertions(+), 69 deletions(-)

-- 
2.55.0.rc0.799.gd6f94ed593-goog

