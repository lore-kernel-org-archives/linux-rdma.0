Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793283399;
	b=o0xvww4lvcssr662Ez+v3FWNXHTV1WZxSVEgUAEeWlBMhKqHoJ2TLAybYNUeNHEHpSb+
	 YuSe4jM3mgHsRhAeZUpp7GTx0hmGTZ2Yeupohh0r9MIDzgxo0OUsN16IcL90k7D/3yzbB
	 WtLhjoPorQR32YetCPG1LsYmr24w7r3GEsAq/QeXh9Q3EHWlHUwuWU7yyQNeswmIe+yIP
	 S7hLzIfQVzHUm2/B26MaFgg8PCZNzg/wDBf8sYtXPwVeLm5YEPyehcUXxzT0QCbDhFfDM
	 NvI36uRPTv74farmwuk6S9uMg0le5IbuW0WZ/gDu9vvzebcuANAsOIlAqrvAYLIax4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793283399;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Received:Date:Mime-Version:X-Mailer:Message-ID:
	 Subject:From:To:Cc:Content-Type;
	bh=i4LfI3bfVO9SNzyogGIpPP76LwxE92WhWkvR+QXJPPo=;
	b=tdsHMl8Wx+swWjNf2RG9EJHTHTcZi8QOnKc2Nrl9N+9XVHH+M1Cqwzqla9vSf225Ha4b
	 Q5KCDxj0eUDuMSVYLkptwcnnhKjBMiijphkhXoVItVyqCHu6SeI66QXiqOxlkp6GtdcYC
	 4jomT9VhHwBPABC8lwe0U+dScp/pV+oNbvsjWFbT9t0NtYxYQou4irfy2u0F4ZwRWXOsm
	 QDRAd0j+oOqpzqzTHPVXkVfqHGHVYKDKB13cqoT6pgWMrfJ5EC9wJLKCiz6jfUuM/vKdZ
	 sKKTQ8C1wzcl8jAtYrzDT85A5UL/F2yQFWJG6UxzkUQhstfFgSUz1fuGo6gDFUkQsOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=o+bE+QSv;
	arc=none smtp.remote-ip=209.85.219.69
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3D1606A31C
	for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 14:16:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC3D1606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=o+bE+QSv
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-9197553d398so49531316d6.1
        for <linux-rdma@vger.kernel.org>; Thu, 29 Oct 2026 07:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793283398; x=1793888198; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i4LfI3bfVO9SNzyogGIpPP76LwxE92WhWkvR+QXJPPo=;
        b=o+bE+QSvW5PT+0fZOlWD5GjGafBr+e0PuM93RKvQ+QP17Ik0AActCY/V128WLAxKDf
         hy40fzm9tvKZoTBcn4H35kMKHMJdooleq+MzmuRZ7HMDbf/PBlsNDCI8o+7h4lKysLBV
         h3TnUY+NrPDfdVUVZ90E4hN82F14UdeSKOolC5pUepsxU+4moZYVWXumb5NwWDSAVNYk
         YTprZfBdZ2AXGlfUVvOruJeF1cT8SS6TD368oxIBcT5dSpDDd6Y5+0W5/ffwlB30Gnhq
         wRTZy2hE4+H/RQIcbtpxHPG7aWFrw0t6REAjA8IL/1TfEPEMHXUfL0Eo/QstzyTehb/C
         fkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793283398; x=1793888198;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i4LfI3bfVO9SNzyogGIpPP76LwxE92WhWkvR+QXJPPo=;
        b=RC3m9iqws0Gqqf83AJogVZ1rbMIrTZ63IHWp4Noi5eljdp4yCdAZJRpiuqi/v7a2xp
         wfrtWnULNqh+RdkB/qPrzgO0M92MvTJweTz39DuKSQmlk0Rvql/4HxnuuIXa9o6dyDnp
         fcYOsrg6BuDyVdjp7emVKwObsJt989doWs2f9PTez2+ODaRxOLTu7AWnSPHxLGes6hs1
         475s2T60Z8LmSjGHEIXaUHmZLvdaHR+undx8cyCsOfhb3eJ7lTOj7hJexwrahJaahTmp
         hYv65o08lfSQI59GY9O60o3jNm8ex4quDBklcpz3xAJ/3PPYUZvpf97M21394iab3bt/
         S72Q==
X-Gm-Message-State: AFq9FYLw64g6DcDIUM6ChXABwWdwZ+D4lRL52Aougf+iMBkcnQRmWk6X
	cQt9IRaMDRkpcZ0k1cNOvdwdtGzZz7s2Z3fFZFIo7U5bhi06tnJpDe70c+pcIK4yzsuuc/n5+WC
	bPXtj0Y5w6w==
X-Received: from qvbop15.prod.google.com ([2002:a05:6214:458f:b0:917:bc2d:6d7a])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6214:458b:b0:91c:9210:49a
 with SMTP id 6a1803df08f44-91c92100964mr36224246d6.21.1793283397526; Thu, 29
 Oct 2026 07:16:37 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:16:34 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.313.g2479322e68-goog
Message-ID: <20261029141634.1557240-1-jmoroni@google.com>
Subject: [PATCH RESEND rdma-next] RDMA/mlx4: Fix stale umem and MTT state
 after rereg_mr failures
From: Jacob Moroni <jmoroni@google.com>
To: yishaih@nvidia.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

During rereg_mr, the umem is released in various failure cases
but mmr->umem was left pointing to a freed umem, so it could end
up getting double-freed when the MR is finally deregistered, or
cause a UAF in ib_umem_check_rereg() if another rereg_mr attempt
is made.

Fix this by setting mmr->umem to NULL after ib_umem_release().

Additionally, when mlx4_mr_rereg_mem_write() fails, mtt.order is
left set but with an invalid offset, so during dereg,
mlx4_mtt_cleanup() ends up freeing an MTT range that was never
allocated. Fix this by resetting mtt.order to -1 in that path.

Fixes: 9376932d0c26 ("IB/mlx4_ib: Add support for user MR re-registration")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/hw/mlx4/mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index a6b4abce1bfe..e7f524c28f1e 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -268,6 +268,8 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 					      *pmpt_entry);
 		if (err) {
 			ib_umem_release(mmr->umem);
+			mmr->mmr.mtt.order = -1;
+			mmr->umem = NULL;
 			goto release_mpt_entry;
 		}
 		mmr->mmr.iova       = virt_addr;
@@ -277,6 +279,7 @@ struct ib_mr *mlx4_ib_rereg_user_mr(struct ib_mr *mr, int flags, u64 start,
 		if (err) {
 			mlx4_mr_rereg_mem_cleanup(dev->dev, &mmr->mmr);
 			ib_umem_release(mmr->umem);
+			mmr->umem = NULL;
 			goto release_mpt_entry;
 		}
 	}

base-commit: c3e8e9451e6f1b69f685b75e0fbf14f3d0fb2539
-- 
2.56.0.313.g2479322e68-goog

