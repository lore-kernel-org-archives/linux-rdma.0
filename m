Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794003131;
	b=KhV8Eo9FDED8T5pVMozlSOPIz9gCzJ+hFsJ61r1xsw+d5fGBTJudhaBJhd/I4pUmfaxw
	 StMfr9cN4Ra9IK6nzA1LL8U5Wvp0gKXm1jl2Ewky1UrcEDHYRYWxII1LZsrzCh3zFyNM5
	 G/DU550NlU2TBJS16i9J/y1u2CzQkU+mOd8GoMLO/KY98xrOLNOvCHzMoMkSgauWR8PqE
	 walpTmQ1Je/yIUT+4yh9UhGMaGxAasbP0WNuFtvMKHpa3VKymkgI2XewDy2u4loP5BA6I
	 N+Od3Aglvm1DEpNSgj1UcEXbx0ffrWgvRLjkfuxKb9qVEonrYXA94lEtBZB5EoqcxFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794003131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=EOC+dHVBn9CzqxGBLrCpDu2EUwGsnaFBhIh64nbQuDE=;
	b=gXX8oi8nY73LpV5X+YaovHx43gGIltRd+s5QA1B3OVEgrxeJWAHGmUT1RjehAmm4oN+n
	 sm4V+JLeo+kJaLjVQXPzH8orXfb8J30XfOCPvWKolTrrObkJBkTEw2AKXH86r9Pmim+PC
	 BIB2ib8TqyjRBigFrq6U93HL93EWW1WbE6GiV88ljtEhkfptmSB4vWY0hjMDrPfs+76/f
	 QYrM2RFMDvGdiLRfGI3qf8RT9edz44Mb8suAk9EWDPXMInMUT9MDGptl7o5GhWHTbBD7/
	 z8uPS0gJlv1+XpIykjLmm9VJfb1/4Fz06CZNGTCyG7swifrIqcfljDQO5E0hc3MzYSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BLr3sphq;
	arc=none smtp.remote-ip=209.85.222.197
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACE4606A32D
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 22:12:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3ACE4606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BLr3sphq
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93cb71b1443so245728685a.2
        for <linux-rdma@vger.kernel.org>; Fri, 06 Nov 2026 14:12:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794003130; x=1794607930; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EOC+dHVBn9CzqxGBLrCpDu2EUwGsnaFBhIh64nbQuDE=;
        b=BLr3sphqWf729vccmalhswpr/glN9F3aicKUdIAYCZ6z1P/hkbHirwPxAJI/101zJw
         5BKFAQ/Myw6ea16h/HnBjX5kvKE+UR0SuzGtxC/HmoRMPHQFSgAKFpq9nyhwPEDo/qzN
         j3Hh5suAgDpHIExn6Af6O8k2HT9gVvc4lQTJZ+nNkhrXZFSm2QTWHLEQkJBH/d9N2rvk
         luA/z90b1v1Ft/KOoZAIRm4tm4JKCzIQWBtWy5gUsPHlYHFhl9GJCMekRRliG6V+zayD
         /po9LOvEbkbgdd2z4esvhD+hBDPS6xfOYeWxv3fsHDWrETqe9T/Axrvx5sTTBjMGx3j7
         zUWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794003130; x=1794607930;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EOC+dHVBn9CzqxGBLrCpDu2EUwGsnaFBhIh64nbQuDE=;
        b=2z8YAw3T/gHmLebX4AfOLo1qEdGnT7oFc6rQa0OA9qxx6y6Y+6O6YFeT8cmsmkZqxU
         LVPMjLu4n39JBhbCfiEnKm86mfG8fher3VIpu/ngGXqC+ZkhfgKtPy4ap2GxNmgbE4qV
         Ik0mhcc8Y4hDrHu8cnaS5aHFaeMt6PAIEJhDAKF6m8AimtOmBebxXvnNzL4+f1r4Re/l
         if5IfEr76Dg67XsG+t7ydOwnMnnVs7ihuY81OHS338wsIS3L6+fU91/GamlRac0AWCno
         iaPP9WaLfYwATFboqOQrJK+nbt5ol1QED0rza9ICtlSuie8J4Q8zhE+SAHVZlAjC59Nk
         azuA==
X-Gm-Message-State: APuU4Z+wIaZfw7aDoxOwzVM3S/4rWsO/CYBNweHp+TKdviZwyNpyV4jT
	HOFkglG4AgyOv0cx7+20xLrRNMYHe9SSgfeQ7ZwQ5ClxMIuZ8Bslkh+0MzfGxI73QBq6efvpvCW
	ZuricNr+pJw==
X-Received: from qkak10-n2.prod.google.com ([2002:a05:620a:a0ca:20b0:93e:4a0c:964c])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:620a:4586:b0:93e:6f65:de63
 with SMTP id af79cd13be357-945f356f20bmr637513885a.47.1794003129932; Fri, 06
 Nov 2026 14:12:09 -0800 (PST)
Date: Fri,  6 Nov 2026 22:11:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106221201.2266301-1-jmoroni@google.com>
Subject: [PATCH rdma-next 0/4] RDMA/irdma: Fix SRQ completion handling
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

SRQ support was introduced along with GEN3 HW support, but the kernel
implementation contained several bugs which rendered it unusable for
kernel consumers.

- The QP handle was being loaded from the incorrect offset, which
  would cause a crash/hang upon receiving the first receive completion
  for an SRQ-associated QP.
- Similar to above, the CQ scrubbing logic was scrubbing the wrong
  CQE offset, which would leave stale CQEs in the CQ for a QP that
  has been destroyed.
- When SRQ CQEs were scrubbed, the SRQ slots weren't being released.
- A NULL dereference could occur during CQ poll if scrubbed CQEs
  happen to be in the ring at the time of polling, due to the NULL
  check being located after the pointer was dereferenced.

SRQ functionality was verified using nvmet-rdma with use_srq=1 with
sequential+parallel I/O, disconnects under load, etc.

Jacob Moroni (4):
  RDMA/irdma: Fix QP handle assignment for SRQ completions
  RDMA/irdma: Check QP handle before decoding CQE errors
  RDMA/irdma: Fix CQ scrub for SRQ associated QPs
  RDMA/irdma: Release SRQ slots during CQ scrub

 drivers/infiniband/hw/irdma/uk.c   | 64 ++++++++++++++++++++----------
 drivers/infiniband/hw/irdma/user.h |  2 +-
 2 files changed, 44 insertions(+), 22 deletions(-)


base-commit: e50525a486300e5ff8014c9985b8477b2fca0368
-- 
2.56.0.455.g6c5a503b38-goog

