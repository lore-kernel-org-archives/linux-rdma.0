Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186721;
	b=4vOHMq/Ay+p1ZOS5C4VU01RXHNLeCZ3918xWGgagZUatuJEL+jbVQd5eI4c34wErOZ/5
	 HywjyTvZJPMO6chnxpTsThp9JdvW0mXrDMyaqKrPNjW7i+dN8sLClAJrXh8zbH3vJAt/F
	 NZDafC5YzsPfT97J5LlbvK71rcXHdpIj4XU0LALgudI9DDsD5PaQvu89Ss9ZpqYRHEJWe
	 K60RNuaXAqbLctrymTTgAneao+gNkOdusy0OkHtNKohP/TLDTyhnIpMGaTVj7sGcsiB+L
	 ihwL0Qaak+MrH4+at2SXRhfx8NJk/wkGmHo4NG+9+Oc5Gj6Xv/OILtF5fz6HX0Mbghw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186721;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=XdoRtQhHoyHImXneWx/psMei/x18HxmV1jWcBPR1VTA=;
	b=dnnuKQ6XwtjLaCE7sZY2ztJfjHDodX+RWLYOBzVoq4LLRofTxk1+ju2ZGh9AUZEvp5qs
	 91JXQntp0DkOHtvlWWBX8HUgro8bbyT0EX9B7v/vG5GvVWu3YIZ0m4cFtRhIVKowPVsF8
	 WQlnrP9FCDoBV05w16xEMAYbkcuc3jKfbfZX1dM+0j98lFJrlg1EQLp88LgMEEOnq8zZg
	 KgzmrLUpb7Wd/PfGvym22xYgdQPwixm0gUd6P0aOWb1JhgF0QV8JSVEkjsk+nGyTaopH9
	 Y1Smq1MoKoHH+JMLlq9wcFYryW8km66KDscaSVCQB9RsiGsqnfCcpQxZ80QL79+6MAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TAM82AbG;
	arc=none smtp.remote-ip=209.85.214.169
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967B160A3833
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 14:58:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 967B160A3833
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=TAM82AbG
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f03eeda984so5073145ad.2
        for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 06:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795186721; x=1795791521; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XdoRtQhHoyHImXneWx/psMei/x18HxmV1jWcBPR1VTA=;
        b=TAM82AbGbrL6t41u5NLlu7pp/fSxNbY3VEmtbHwc67s7Fe5iIO6uEPOH4AGW9HsEl1
         PqW5FdoV6Dy1jyYEW61TvwRD4KSK7XZFvm5QmfgC7nuIUh/qcCEZGdXl0Wm5isOobxLM
         jZOUtbCJCgfJy1R13t2VpCsza2EGqxaOUwNBzA9CIPXENbaJ8u43KB5/dEKKDuOlyJvL
         n/+FT1PFnGcZ2nNqPD65jO2yhFzGJHiRP8HrjQ3HnMS+uGy90T5mHtA4nm2aArPWAlIL
         yPB9IeEl3WGYP4BKNCpyn6YE34sRCSMfm4OGyxKdyQ/9hflvXSo/TRAZK5NPQ0eY2ZQR
         74ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795186721; x=1795791521;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XdoRtQhHoyHImXneWx/psMei/x18HxmV1jWcBPR1VTA=;
        b=D8Mpy8FycTrfh42Ol1wbXGhtz7VLj6NxPnyzrNuQGaZHE2Mqw2aN922fNf4gezy9y4
         57x/Sui3DON2UlfkWLC1azJ+gieqQ/XlEXBlzBl1u+Q+6Y+y0K1dgyS5YDHpkWrWxuYP
         NnLSUuxPC2yjH3Lq28tt4lH4YcYxfdH5ccDrPcE6xi9Mu1kPmbA9mUOlHF75Wr4eM2ov
         ++FnDAOkSc6xVraUrvx9l+Op92JPKXj76FAdSBZEg+TcAfHs8PiBtF+2sNiSqC/3zOBk
         PacW/VlhoQBK/MeDWFynzVDw2IkvxewW3Y3o64gVmfhymBUgNQnBjWTwEezsNNU0GLxU
         PHNA==
X-Gm-Message-State: APuU4Z+nLam/R5fe4/3j6XPcZ8KQ+XF8u7slnWuJiYUliOZhBGEUADIE
	Xoy88f+tZPMDMNBShsl/EqoX8choyiAXiX2VgH9BdRhXWQ7SwNW2yiembBoKZAsoyDElRlQAfoy
	GAs+Wxbs=
X-Gm-Gg: AZFdTZdNw9oE1c1G92mwMXgitpjluuh6yQNm0WvNVJ63re0y65itAf21aCvKjv7kJgG
	aEc4Wx3djQnUHNVxcPUNvExQWPMMTfu+gfbdM5t+xlCFN/ELLd4gucTl5/nW+Csgwz6bwbWSMix
	lk4dUVA4Ver/SoNm+xlsOsYtBuaOuK3h+niVFLnSAHq9pqVO2yZIHEiKNW3W/G5tjWozRBDSC9v
	SlBGpaNGa6I/8lv2etH/dk/UmBKRTBT8IJa/UGDhQAopRAWSBdyDbuGAkLkDqJqEchKaPI2pL0N
	xy/36yj7r4vpdUVf94iMT/Z03AVk2sXVzxfZJ7LgugVQYnX/HP5CllyILveskOpBI4Gt3DnGE+h
	29KsWvPsGcBgfo9jTGDCLy2lRyLEh718oFXSg52WI/iQQOhZdxXYYvVE3u8ldBBe4hCIsfYBHPR
	/eIh4QnRAFv2vJBABYb9MGKGwW3IWQLL81HKogCV5MtscUHmGWyNmvVAbICdj54GVP5gHTqhBkz
	ftNgBihR/2CWW8YAvchSS7nnBiBVF7IClr0Fm6c58KBTiWkRWnKyicWsSygfR4b6aiGA+V6LU++
	zwHWeEDLpiULVMhZDtWUM26coGG2GXkaWDJtqN2D/kRJ7FDFzZ+qbwfDHnTsppUwo2a7yTwAAYO
	4I7VLH2B30mGqIqNuYNEixPVEclBxNq2HWXNg
X-Received: by 2002:a17:902:f543:b0:2df:a0f0:6625 with SMTP id d9443c01a7336-2f03f17d1a2mr38645095ad.17.1795186721178;
        Fri, 20 Nov 2026 06:58:41 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f108205sm15372495ad.44.2026.11.20.06.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 06:58:40 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-rdma@vger.kernel.org
Cc: bvanassche@acm.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Fri, 20 Nov 2026 23:58:36 +0900
Message-ID: <20261120145836.3127736-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
References: <20260812190418.200337-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, Aug 13, 2026 at 04:04:18AM +0900, Yehyeong Lee wrote:
> srp_destroy_qp() drains the send queue before destroying the queue pair.
> For the fast registration and invalidation work requests, the wr_cqe it
> finds there is &req->reg_cqe, which lives in the blk-mq request pool.
> srp_remove_target() frees that pool first, through scsi_remove_host():
> page_owner records the page freed by blk_mq_free_tags_callback() while
> that call is running.  __ib_process_cq() then calls wc->wr_cqe->done on

This is superseded by v2:
  https://lore.kernel.org/all/20260818035229.505098-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
