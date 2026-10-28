Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168021;
	b=UjgNyTMIVjaG1G/4ICjc3NC2O0uw7wWxAEWjtKle3UWaviWIC2QFxnn8X/NhFQ8KRmx4
	 o5dNVvcuhFgwpNC7A7WyoDMtr27VLH5tZ8l1k0hZFJSY0u80zPV8eFfGo/m24WcXuqdq1
	 uXNDmbYEBc7+Xh1GlOcaZvqu07fcDGXju1O2AKVOsBGY4k/qQiv4uP4SrIpUj6KlMcu0D
	 4ECQ2/nJIcZdARyFveh3UNSdf5PUSuu2ysGfRiz4iRKCqA9bUZ6sZtjxVOAxbD38ORrTq
	 vlAoVm3eI0+oOWv7xhNIwgWxU7TmR8f6cDC3EVogWadxcCTswuq9x8Z2HzC/Nv8W88w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168021;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=U+a0k0lzQTvjLml9a90KYu5zkJZN7bnS1R/iN4tARGc=;
	b=zZxX8H9aWaYg8txC6GxS4yAk1sW7rc1u5ycYH5aYMZo+RV9W2ILi+gB/cocskfYjFTms
	 +gQktZIkxb+Mv8veBPmael7UjTDG+uG2ZpQAk91gUInbQO0KYauDFCBHIWr/qmXbUoLbf
	 AkwED+eMdKgF51B6WLP6NxfcUEGBN8mGtbbDEbpArjbs+EmxfkfBR00sDNQBz9mWxX4W8
	 KTgAKzTzUkFvfUv22gtHt1qNODB+yVooy5DRXZ3rZVKt25VLkXWvmoBZrNRyXgHabIoEp
	 9WSj1larL56XFTNLpR4nwGfHW7NBjGgK2095y7cqrGdw2zKoqFKFeA6vT6xeA8K+TWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PyX1Hcn7;
	arc=none smtp.remote-ip=209.85.222.227
Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260AA606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 260AA606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=PyX1Hcn7
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-93f20b304c0so50065385a.3
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168020; x=1793772820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U+a0k0lzQTvjLml9a90KYu5zkJZN7bnS1R/iN4tARGc=;
        b=nTZS4qQ2OJ13Wmne6BlT/SkVFSsWWe6lFl3izzVuiFklo+L4d+iAuX11G8+72bFNKJ
         AfoRyqBH6464i4QbN22Fijgxo/wemAYgInjYrXwdmLH1TjMHNkg/SefloQsgSAch2Umf
         iWOPcfCYhn31Ja/h1fpveBIcqrj3sg8+mWUhpXQqAhGBUJwZX8tS/U9TsEnGUugOveTf
         ygTs/ho4U6gfFhboP87BvLUts3pZ395CkXjZ4F9FzxpT1NgHlMH0WLB9JavbaK20kozo
         pQ46wKM3z/2ix5saCxl+VUpmlNAbsJJ+nbI6l7aKk0IBAXxE9o2AZhrnT3YOjyVg/Xoc
         wunw==
X-Gm-Message-State: AFq9FYJLyjDBDkzEw3lCBvt9NkvenHp6UD3KqNXmPp9tDhvvFTlspF6X
	FBBVYRlkY1yXI/gJm9QN1d2LUbXq1locCYR5kL0U4sDw1a0N4MAelQzlJpYbM4/ukSf0huocGTo
	SaXbaMSRgFz405fYUFNjFjIbH3S5gggw6eMfHNWtfB0mkvoC/Enaqu3a97bCT8UPNjQuI4jfYVd
	e7TDQ080KtAV5okNxtQki3yAB5/6+3YeVs6e2eAya9wfDjaTLuqA8Zj2GGuMr9UqkO2bfhKYvdB
	a1UCvpOKBMkaWHW3Q==
X-Gm-Gg: AYBFou24Q5dTh/s3UnWVJPHy99pYZQGN5oMa8sEQQuSXyk5k6OBXJjzKLPIft6OFqm/
	IiTSbj9MiFXsXOCcnO/ABsvaRB3UaKGGF9Eh1MaLXy4Mswxmhbl6GXQnzvjwu+/cKGdudGwIK/A
	Nq61QdPS3Bde1Xq0hYbGpHeJP7UH1jiosXKnvVbjnEXtt4ABo0aHSbUm5wFHSFONT3ttpEq+5yi
	V73i05xb6mTXLr2hvZzGOsr34ZMV7CYcN8T/15z2Hv/NBHxMXI68yE+V8S15IqRcDK/3SFJOKmw
	Zj6m51nW0v2IGWf3VfGUPIZ2Rdz2e9g4rrJalYzzJgNFRCxLO/P4GLs9alfQffc3c0WiWaj4G5s
	4r5H3+TifeLogSYNYeFACSONa0t53Yo0ZWTf3H52nUz54Mw8DRRj22mO/8gQHPa1cKlrlEr7SHu
	9M3Q7Q6c93RT+S79weUMYCfwr06dvCNtfnk+FYkZ4=
X-Received: by 2002:a05:620a:649b:b0:93f:3163:3e5c with SMTP id af79cd13be357-94408cee1f8mr174363585a.81.1793168020029;
        Tue, 27 Oct 2026 23:13:40 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-940f05b2712sm169784685a.1.2026.10.27.23.13.39
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:40 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8a05bfa6af5so532346b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168019; x=1793772819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+a0k0lzQTvjLml9a90KYu5zkJZN7bnS1R/iN4tARGc=;
        b=PyX1Hcn7s4Q99IGLYJPp5iVfNsoxuFySITkNZ/6rKoV41YaePoqrLKLr+TuY4fiSC/
         zXlGc14ZUV742JIEJSxLUQTIhdkfaoSVqVuck84CIBUvSQczMuY6DA3J5WTLo/dciCfg
         wAxS5lbkmn74/c4HA6F7RPRs5Rg59YZe1lgoA=
X-Received: by 2002:aa7:88c5:0:b0:8a0:3ed7:93aa with SMTP id d2e1a72fcca58-8a6e7dc9341mr1105498b3a.49.1793168018946;
        Tue, 27 Oct 2026 23:13:38 -0700 (PDT)
X-Received: by 2002:aa7:88c5:0:b0:8a0:3ed7:93aa with SMTP id d2e1a72fcca58-8a6e7dc9341mr1105488b3a.49.1793168018534;
        Tue, 27 Oct 2026 23:13:38 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:37 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 6/7] RDMA/bnxt_re: Remove shared page mmap entry on alloc_ucontext failure
Date: Wed, 28 Oct 2026 04:34:03 -0700
Message-Id: <20261028113404.33289-7-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261028113404.33289-1-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The uverbs core does not call dealloc_ucontext() when alloc_ucontext()
fails. If bnxt_re_alloc_ucontext() fails after inserting the shared page
mmap entry, the entry is leaked. Remove it in the failure path.

Fixes: 24ce94782c48 ("RDMA/bnxt_re: Use the common mmap helper functions")
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 796ea795c5b7..1ca481806578 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4909,6 +4909,8 @@ int bnxt_re_alloc_ucontext(struct ib_ucontext *ctx, struct ib_udata *udata)
 
 	return 0;
 cfail:
+	rdma_user_mmap_entry_remove(uctx->shpage_mmap);
+	uctx->shpage_mmap = NULL;
 	free_page((unsigned long)uctx->shpg);
 	uctx->shpg = NULL;
 fail:
-- 
2.39.3

