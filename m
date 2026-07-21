Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D785142EEA4
	for <linux-rdma@vger.kernel.org>; Tue, 21 Jul 2026 06:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784615579; cv=none; b=nJLr5H7toTza0bcvD7Olrox5my3ArC49J5p18QKle2VRYFGLtSRKP3KVNqRhmUERD+EK+JNQby8iMnrhUnBIh/A9601rxqWaKhLGoy819qV9l+VGrGE7ASvg7jIZd5Zu5rHZ6oV0gv9Zr/pmnhRi+fK62p7b6bT9BdmRt12TAkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784615579; c=relaxed/simple;
	bh=lFpgR6tOrrkTqN4dOXdT5fIhji1ubPYEovQigi1E48Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hhw0UP/r4JQOgkBSXl1qsP3a+v2cwT3dr46CVuVgXDTatMqpYFLmk+DOGV9aXATQ47XKxMZrqGF17st/LF24leN+5QQjOlZKCwIOw8gCuES7CSu39CsXkY9q6+KkLVCsavnBu2ljNsnzRlU75MQC7Rgk2drgHkUqcdIfahSCfPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SZ/b1ip+; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SZ/b1ip+"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cc97653887so119317795ad.1
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:32:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784615577; x=1785220377;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fUvsufTfKR4BM4kKrEkHMgZteEsqzJlbJaOA0OL3AGM=;
        b=F9uUfFmtoyqclwIjZJwXZ1H3w+Y6Egc1zXzhaeYGIm2mx/nKND7NP4NlmmIqg8FZph
         AEN9o1OshqT8fQ9NRF3sFUsAenGZaswxIxQjdht6KBRumA/qwFfHiqVdUDRSEzxLrwzP
         hRWv/YTT6lZatrfBQzHOzac/jbHuo15oXyR66KvY4D8AzcGuqjesN2pXF461esd13iOU
         BlEdN4S7oK4QSapTpZoGPywTqOvtT+dgvRXwaNPctUXCYIEkgxjCQxZmNs4mfm7kqTji
         ZoHZuque83wvSFxmGGzisD4qa3dvJDnbD/+NImmzot/CFV1mp0g+vXeAOFOt05oUlsVY
         ZZHw==
X-Gm-Message-State: AOJu0YzknzpkafWLL1vElDYNHKSExbjoCT6y6HPlOFauxRQKC1Q94oQd
	o22LT254GmH7mPeetAsRzrnAMFZpriZUip1IYewZndfJ2ABYEVvUwXPArTE47LIOliNoUecxsKo
	OEMFW53cuoVQPsodYAUEHMyeMIkSGPafBToUTriOjUr/JVcZ+GyuIVYGdbGG9DcEg/uE3HO8gFZ
	bdp2W/CgEpChFv1DcM9LdY/KFO71g1y8LY4GYY+2J1a6hS73SVT+qxA2hmtOH9k21HrY7wwWRDa
	RA97d9Ma7QFjEKctw==
X-Gm-Gg: AR+sD12IjlzJ/zjwdE8YYmhR35oYfd+UBTTR7a2xPMFnYX9NY4ykpjt2hBwu1tJbVVL
	N1vXfjVzJRZfwxq4lrfs4Brn1uyOAyK9XFXanQBC76twNa3p6mPZeY7VQpB0xBF6HxRgisWR5n/
	Pp2nzV3E+DKxUasteDYWfT5+6Qm6liQOHhcrVlV1uI9B8cFLB8I/phnbd9xyHW9TQMh/sF740fs
	vx6lMfYDl2wZwysgbq9hkfgUk+CzOWkzpkfZo+OXqREfbLE13k71awYne7v7zIWw9S6qXpGRege
	dNRGFUdhqcbDIe3glU77+/nDGIdeUQw9NuR50bxvWh1ihtE9IBUNHUqjDRZ3g4T4D8LpMEgKSy9
	jl0Zn9yj7LiIVALjVtYYPFFHlFW85QZItH/pnntnmKJjj+9CvzIcTcQilqSGSwA1CWzqdqSsKEM
	MtQkXOjiR9O8dJ/osIojfTPmSBy9YZTZljhVMm
X-Received: by 2002:a17:902:ccc8:b0:2c9:ae0b:61e3 with SMTP id d9443c01a7336-2cf3484b193mr157273745ad.2.1784615576989;
        Mon, 20 Jul 2026 23:32:56 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2cf34468214sm11587855ad.9.2026.07.20.23.32.56
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Jul 2026 23:32:56 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c85798977dcso13078657a12.0
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 23:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784615575; x=1785220375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fUvsufTfKR4BM4kKrEkHMgZteEsqzJlbJaOA0OL3AGM=;
        b=SZ/b1ip+rBYWe0oCZ55f9xdptjFDw7Zg55TAig0hGnkEMoAobZIM/zrf84l7+P3PRF
         ceHsE51YPwo8qzKgWeNEdRl3gO1Iv+SjMyyiV3ynG062YOcmKJLvmQN85SAIvZLc0TZE
         uJ2SwpKWFRK9uQBgpe9dS6qSClLCcbfBU3XQQ=
X-Received: by 2002:a05:6300:48:b0:3c3:994f:b4f5 with SMTP id adf61e73a8af0-3c3ad67a262mr18763013637.28.1784615574954;
        Mon, 20 Jul 2026 23:32:54 -0700 (PDT)
X-Received: by 2002:a05:6300:48:b0:3c3:994f:b4f5 with SMTP id adf61e73a8af0-3c3ad67a262mr18762988637.28.1784615574422;
        Mon, 20 Jul 2026 23:32:54 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2900a37sm35230176c88.0.2026.07.20.23.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 23:32:53 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	sriharsha.basavapatna@broadcom.com,
	alhouseenyousef@gmail.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-next v4 0/4] RDMA/bnxt_re: Update the toggle page handling of CQ and SRQ
Date: Tue, 21 Jul 2026 04:54:36 -0700
Message-Id: <20260721115440.24021-1-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Based on the suggestion from Jason (
https://patchwork.kernel.org/project/linux-rdma/patch/20260615224751.232802-5-selvin.xavier@broadcom.com/)
, adding the uverb object to retrieve the CQ an SRQ structures while getting the
toggle mem. To work with older rdma-core, retain the existing code with
modification.
The rdma-core pull request is here: https://github.com/linux-rdma/rdma-core/pull/1761
Please review and apply the series.
Thanks,
Selvin Xavier

v3 -> v4:
 - Fix a NULL pointer possibility by adding a check for res_uobj->object
 - Locking changes in patch1 based on Leon's comment
 - The kref of the mmap entry (patch 3 of the previous series) is folded
   into the patch 2 of this series that fixes the lifetime of the toggle
   pages.
 - Adds a clearing of the MAYWRITE option, so that read-only mapping
   can't later be upgraded.
 - v3: https://lore.kernel.org/linux-rdma/20260713135830.1934471-1-selvin.xavier@broadcom.com/

v2 -> v3:
 - Patch2 fixes toggle-page lifetime by making the rdma_user_mmap_entry
   the sole owner of the page
 - Patch 3 adds a reference to the uobject in the legacy path to avoid
   the usage of the page va after the resource destroy.
 - v2: https://lore.kernel.org/linux-rdma/20260624223927.521882-1-selvin.xavier@broadcom.com/

v1->v2 :
 - Fix the error cleanup for SRQ and CQ create paths
 - Fix a synchronization issue for the legacy path which can cause a
   UAF
 - v1: https://lore.kernel.org/linux-rdma/20260622100528.132463-1-selvin.xavier@broadcom.com/

Selvin Xavier (4):
  RDMA/bnxt_re: Replace per-device hash tables with per-context XArrays
  RDMA/bnxt_re: Defer toggle page free to rdma_user_mmap_entry teardown
  RDMA/bnxt_re: Fix toggle page UAF in GET_TOGGLE_MEM with mmap entry
    refcount
  RDMA/bnxt_re: Add uverbs object handle path for CQ/SRQ toggle page


Selvin Xavier (4):
  RDMA/bnxt_re: Replace per-device hash tables with per-context XArrays
  RDMA/bnxt_re: Defer toggle page free to rdma_user_mmap_entry teardown
  RDMA/bnxt_re: Add uverbs object handle path for CQ/SRQ toggle page
  RDMA/bnxt_re: Clear VM_MAYWRITE on DBR/toggle page mmap

 drivers/infiniband/hw/bnxt_re/bnxt_re.h  |   6 -
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 125 +++++++++++++---
 drivers/infiniband/hw/bnxt_re/ib_verbs.h |   8 +-
 drivers/infiniband/hw/bnxt_re/main.c     |   4 -
 drivers/infiniband/hw/bnxt_re/uapi.c     | 183 +++++++++++++++--------
 include/uapi/rdma/bnxt_re-abi.h          |   4 +
 6 files changed, 233 insertions(+), 97 deletions(-)

-- 
2.39.3

