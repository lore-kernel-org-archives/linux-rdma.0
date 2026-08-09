Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFCA199920
	for <linux-rdma@vger.kernel.org>; Sun,  9 Aug 2026 03:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786246096; cv=none; b=mhDhqcOnRz3NMu/NaOatPLuuGvbuRHZZiCvaL6Hg6SZC1mANbTyLiMWiq2+Yfx9yyRF8VYoli8vMfvJGjRzR0vWRCAlCCWGt2k3SX/gN5M4cHYE4xTrlGq6u2XHhCBSsatm6jkap6zaKWURsVEN3hdyOe5TcbwkFbcUrfzNH9Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786246096; c=relaxed/simple;
	bh=OaaO9X8gqrUDj05mGTYFdmi8nWGXU2LWgsF5OZwTkQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=luPy/qcg+zAw+deue/s7bpyoJNXzyzofA5ak9BTdvLaKBkQExLCSmMjCLUlndr5dfvvpAPy9PQ+jBD4jfIBZLaqhUKVVDMKXk+VehGj/xKsM7vqs7smXisj4qKDisw2U8aj5ZJTcHxE4KHBlax9sOrPO4X4bBtnKKleEaNnrZ2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Aq+mk915; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Aq+mk915"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38759bcd877so786080a91.2
        for <linux-rdma@vger.kernel.org>; Sat, 08 Aug 2026 20:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786246095; x=1786850895; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PWRK37gCFVYLj4iCEyB0nOW3fLyTc/Qfqd+mtnl3Xik=;
        b=Aq+mk915TUH3OV3/MItWeSpBDfVVo//3gjvmVNuIclNOur1ILucWU8oPmA9GFVDSTs
         cTJLol9CpZsxoMB1irnyn8PWqBz3aPbvdKXADAj+3TjA+k03hySWObI0gTtbs4tlYbLO
         OBEmn9nlwLLjRPRkL/oE4KsFdTa8IY+VreNsRTstIs3qToSn7nO1YfrR3c2rupyxfUG2
         jjHenqqnekNKXn/FzgtMHSAza/86uTQ+8gilY5QdtCUSGhwE9MGicnwm3TDGVsqJxRlA
         aUyMJNvpk/rD3u0Dq7+YNChPML+/wD+9tMck9Ju6F7Uq6Oq4KMK0SV5H+IOCWV4iXyT9
         eVRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786246095; x=1786850895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PWRK37gCFVYLj4iCEyB0nOW3fLyTc/Qfqd+mtnl3Xik=;
        b=oWolWuI98P4N6L/l7xtczQjHyuUNQyO+Wc78pIO5oqLfqbH2ldwcde2Cix1vMzcl+6
         meSXb0PgrAFmJonZLTilLoV/Fzz+/7eGlaIOwl8+CtWTXYkx5cmlvOsKHyEQasaNc0Da
         6kyI05OnQcClNQlOd9h/y8ddsiPL8PDc+eFZo+RvrcahKoG1P6FeEWgtRjhGpIUyTAt1
         pPYW/R5zmlyhIZf5uKAj8D4ydHHoUCWTs5zfSTSlRtVQY7C8dD5fZgXpUAcHjlot4DXE
         JxK2l+XG+vyNWyLYRS3GZzqojr+7T7FRjMTpWseuvldr9WziqCCR8c7rRGm7Klpm2S45
         Cg9w==
X-Gm-Message-State: AOJu0Yw0epgeai6847btkuk6Sfp7XH4K+8+P/1r3SO6A3hVGoM9J2W+7
	PwefXf3jKf5Fww/u3OphU3nGSkIHLYCm+DrqdxO/S1dqtfGy9IKjzlAq
X-Gm-Gg: AR+sD11DPej/vh5/eoPbjvpF9y7vAoPdXtwOjDP4ms8dWk9lJLxI5vQ+C0iW8llRFvM
	tX6CcpqYIGvvhmUOA7b4alhA0vRx0YovGF8xhJyktLrjW4WXKm/UemzvircviXSm96RhnBYF9i3
	1yUhzihpOYdSvmr3pYUXNzLgYFBowFvkyaX0X9gJUzbFIcUPpMzX4611h41r75h3vkdYoh1WUP1
	2meXZtXvRFAPIgOuKOxmZe0+7vGBl8Dhu+5w8r7l3XtG9DoTur3onpGWm6qoz9ry8htOXutPmIR
	wCEwIvEL1Z3MhkTeBosRiSHmGvHHCFX244Ya7i/Hvd1i7MCfVXh46xJnlgTshA+SJKSoQtlWPoo
	yXm1BZGvYS2sDOrLL7p4OL3aXgnxRefbUIQTn3FS5M9tsKY+ETazI6+1UkPbGwvW2ZEJnUBiqTb
	tA0zWkgl0UPpFNRboWOCX8SFPBwmbLWJx3b5W0IauVEoLckdDTtKhHX+fpUl5+yOC1QKb0y2EXZ
	crpfgFe66OFLIxYmXaNAI5aF5IxcWl6S2qpInCaF8SqzzlwwIoyE+cSEe+TXSQ=
X-Received: by 2002:a17:90b:2d84:b0:38e:11ba:992c with SMTP id 98e67ed59e1d1-3903c58ece8mr33705159a91.12.1786246094757;
        Sat, 08 Aug 2026 20:28:14 -0700 (PDT)
Received: from homelab1-WRX80-Creator.localdomain (p790255fa.sitmnt01.ap.so-net.ne.jp. [121.2.85.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm7587626a91.2.2026.08.08.20.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 20:28:14 -0700 (PDT)
From: Shuhei Takeshita <jyohuku.alterego@gmail.com>
To: dennis.dalessandro@cornelisnetworks.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dean.luick@cornelisnetworks.com,
	Shuhei Takeshita <jyohuku.alterego@gmail.com>
Subject: [PATCH 0/2] IB/hfi1: fix the PIO_CRED credit-return mmap
Date: Sun,  9 Aug 2026 12:27:41 +0900
Message-ID: <20260809032743.2671579-1-jyohuku.alterego@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The PIO_CRED case of hfi1_file_mmap() hands user space the credit-return
page for its send context.  On a two-socket host with a translating IOMMU
it instead returns a page mapped from a frame above MAXPHYADDR, and the
first user read takes "Corrupted page table" / "Oops: Bad pagetable".
Correcting only the offset arithmetic replaces the Oops with a silent
wrong-page mapping, so every transfer that uses send PIO hangs instead.

The failure is intermittent: it depends on which of the credit-return
pages the context's entry lands on, which follows the hardware send
context index and so varies from boot to boot.

Patch 1 fixes the node used to resolve the credit-return buffer, which
has been wrong since the driver was merged.  Patch 2 fixes the byte
offset applied to a typed pointer and the use of dma_mmap_coherent(),
both introduced when this case was converted to the DMA API.  They are
separate patches because they have different Fixes: tags, but only the
two together make the mapping correct: patch 2 without patch 1 turns the
hang into an -ENXIO from iommu_dma_mmap()'s bounds check, because the
cross-node offset exceeds the buffer.

Found while debugging psm2_ep_open() Oopsing a Dell T7610 (Xeon E5-2650
v2, Intel IOMMU in DMA-FQ mode) talking to a Threadripper PRO 3995WX,
both Omni-Path 100.  With the series applied to both hosts,
psm2_ep_open() succeeds, send PIO, send DMA and the default mixed mode
all work, and MPI over the PSM2 MTL sustains 95 Gb/s.  Forcing send PIO
only (PSM2_SDMA=0), which hung indefinitely before, now completes.

Based on rdma/for-rc at 31b7c700670830a0e8a4cdcd451c88a13cc5dc48.

Shuhei Takeshita (2):
  IB/hfi1: Resolve the credit-return buffer through the send context's
    node
  IB/hfi1: Fix the PIO_CRED credit-return mmap

 drivers/infiniband/hw/hfi1/file_ops.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

-- 
2.43.0

