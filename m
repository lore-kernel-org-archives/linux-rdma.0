Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07D3187346
	for <linux-rdma@vger.kernel.org>; Wed, 25 Feb 2026 21:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772053635; cv=none; b=jIWlbJFpjN7gUjiiDQXlH/0WiFT+aWJSqoC7NwfIllUgemXvS2/N7PT8H1B5QOpAoAd/8D+0katPT4O/LY6YjVtbPVIYcZfhNpkc6CQjeSK60bo1OKib4cYm1If6zScKiQsjAPq/RO1oEJPdtAPqiVFESNvrgBZOJCOee7goOmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772053635; c=relaxed/simple;
	bh=XEG7aELRTLTme6Xkt8jLwGlw9UXLP4KKyvtmQ4zmhdI=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Ic3yhsXA2cdISt0lFQUNiEQgI6vlAcS9SfDgir79e6K5zpi4EdeLuF3+pzcRZcpnbHrF5DxWN/nbYy6/S1ixRuBuH1U98S8kbLSWloDKv+ZsENlRRlaeIlBl7gvYAauGr726R7SgQ7obGJvrFbHhZ8cbYNt8X2Cm0QoPvvcJUxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NOEqRwbi; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NOEqRwbi"
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-899b4ce513cso12316396d6.3
        for <linux-rdma@vger.kernel.org>; Wed, 25 Feb 2026 13:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772053633; x=1772658433; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DuQSjLBQbe416OPRcK8wPIYORuzWUBbxoKLX/CoPoy4=;
        b=NOEqRwbiIh6jgdG8OU0T49/9ykniArkfBcYR49CGDUZ6U+P/0+rpzS9HR1m2iHaPW+
         H4ks+fk2ZHkY+1+QE7XvvA02DpGv0Tt9bRlLhelN7VMuQbIQzR4jI831h+aGDy++p1xw
         e7BYx8Ju9MeHFkhqWLqiPvGNPkwItLrqYyqHEJxkIFOzUyOO5M9XkwQxAiX5p+0bfTmE
         k9Ydl0aEdfqU5q7MW3f+YUzMYihrSJu4cHL1m+I1vzq4eMaOMwcK++V/xgDCmMfYv2Au
         +67C0VElnpQF01ABJihkfjvgO1H+OyN7FvOJt1ozBdhN3/yh+lPlOh0OpztETNlHO29C
         hJiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772053633; x=1772658433;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DuQSjLBQbe416OPRcK8wPIYORuzWUBbxoKLX/CoPoy4=;
        b=moUBCgxKoWwCNMODX/Q1c4PekIAswK2IcpecCTRrtBvP876GcSNC7NQOVZsqp6ytiw
         Tkt5ZaKbVI5E21ttihfTawpg4QXGzVscC75Av9P4PsOddzQcaGwpF8wL9NoCqFyxz5Ft
         o4Iywz9PBZm+XhLeQZtPOr02tvEy1HD8Pne3Gpjy5YUtBKm/XW32Vl0tH44AvB8Me/LP
         /Rz+x22yg6LJFnBZpvp34P2iupgN1Jwqyky6EUoJAeU4cADu6djluY9hZbfMlPDMpnck
         mxzUrHhv4WupwK5LbKYEJnpP0x8js1bSfS2sJnuXA/j0qSTepwx9nDpIDsXw6GJdWmo5
         NWsA==
X-Gm-Message-State: AOJu0YzMTwf1PSIz6KIobxB41O3AZfUHNvFKEmJhz550Fu2dASFoUlJW
	tHhcULjTuP/hxpuXkE2MMRCMR8fOnxBLqF5lC4lYpgBJxyEK0LWmCOjEiXPUW06jIlVCF4ElPUa
	L0FJmg8+5ow==
X-Received: from qvbly2.prod.google.com ([2002:a05:6214:5c02:b0:894:5e39:4bf2])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6214:d42:b0:807:8020:1055
 with SMTP id 6a1803df08f44-89979ee8fdbmr264319756d6.37.1772053632712; Wed, 25
 Feb 2026 13:07:12 -0800 (PST)
Date: Wed, 25 Feb 2026 21:07:01 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225210705.373126-1-jmoroni@google.com>
Subject: [PATCH rdma-next 0/4] Add pinned revocable dmabuf import interface
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, krzysztof.czurylo@intel.com, jgg@ziepe.ca, 
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

Some dmabuf exporters (VFIO) will require that pinned importers support
revocation. In order to support this for non-ODP drivers/devices, a new
interface is required. This new interface implements a two step process
where the driver will perform a sequence like:

    ib_umem_dmabuf_get_pinned_revocable_and_lock()
    
        ... Driver MR allocation/initialization/registration/etc
        
    ib_umem_dmabuf_set_revoke_locked()
    dma_resv_unlock();
    
This allows the driver to provide a callback that can be used to
perform the actual invalidation in a way that is safe against races
from concurrent revocations during initialization.

The driver must ensure that the HW will no longer access the region
before the revoke callback returns. For MRs, this can be achieved
by using the rereg capability to set the region length to 0, or
perhaps by moving the region to a new quarantine PD. For HW that
allows the driver to manage the keys (like irdma), this can be
achieved by deregistering the region in HW but not freeing the key
until the region is truly deregistered via ibv_dereg_mr.

Changes since RFC(s):
* Break the interface into a two step process to avoid needing
  extra state in the driver.
* Move the majority of the functionality into the core.

RFC threads:
https://lore.kernel.org/linux-rdma/20260223195333.438492-1-jmoroni@google.com/T/#t
https://lore.kernel.org/linux-rdma/CAHYDg1TB1Xa+D700WrvrcQVdgZFE5f8iWp48EmQM9XjK9xJdew@mail.gmail.com/T/#t

Jacob Moroni (4):
  RDMA/umem: Add ib_umem_dmabuf_get_pinned_and_lock helper
  RDMA/umem: Move umem dmabuf revoke logic into helper function
  RDMA/umem: Add pinned revocable dmabuf import interface
  RDMA/irdma: Add support for revocable pinned dmabuf import

 drivers/infiniband/core/umem_dmabuf.c | 122 ++++++++++++++++++++++----
 drivers/infiniband/hw/irdma/main.h    |   1 +
 drivers/infiniband/hw/irdma/verbs.c   |  71 ++++++++++++++-
 include/rdma/ib_umem.h                |  20 +++++
 4 files changed, 195 insertions(+), 19 deletions(-)

-- 
2.53.0.414.gf7e9f6c205-goog

