Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792692962;
	b=cswbm2HiocP8OXjNs2USfvb+EvrPQvjxGkUuI3DDPWOxSdW595bW4mR31y6uncc8N6fN
	 NHHFr5BTFuSo/xkGKQtKT5VCWR0RYF+sr3j3TtHYdis1z/vMbHZvCnMcGNuZ3yQUwETxg
	 0XyVaENMJcRSfDOkCpZQndVBKEPRlYJAANGRcjxALK/UMyAgrKJ7BgZO3x5q3RrfcGfka
	 Qjt0O5GjZ4kxRk/Sfc65j6vBamVdDpAfB6sYTh7x4v0k6lOFNKY1KL1gW5cvLizkvBOJs
	 u///oqlnQ6vmpYht8iin2IvgG+ffVZm0HMc/ZDjvsH02BoP6M7TdHBBuJQN/A0i5G1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792692962;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lV5YdQZY6ugatSUWQ2s6iPsnMBrzghU6pgYdBb3t1UU=;
	b=5jN4ABZcoaMRVr8y4NTdGTzEsKoagsut9qUsTmcJ5cBR9hVySIgQcPAhergqGq49CMOO
	 R2lectrAl6xilHb5ZPYJREsTE4f4d7Uqs+1v3D3FNUzBZAqBug5TSHthq3wIlqxc8kOcR
	 FE8aoKpjLUYvapVD9D7oRnlgdR2xS1SCgurBhmXzhPoEcTIuvWKeXozIaOknp1ao8nZap
	 mwP6sxSjl12uEdR888ID69zVQABeB72gbwcEw/9XYOBoTNrXiuM1Yntr2asRR0EvaTdsq
	 ei17uhv3Vsi3YLhDJGb0awqEqz5adPEKhdCWjPmMD7cm6Eyxe8U8B8v1HpvbamJ87EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=SUC15hpL;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EE7606A328
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 18:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79EE7606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=SUC15hpL
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-868b3248b2cso122777b3a.1
        for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 11:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792692960; x=1793297760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lV5YdQZY6ugatSUWQ2s6iPsnMBrzghU6pgYdBb3t1UU=;
        b=SUC15hpLmjAXHuU+ZW/v4EzAW0sUvPzV+xIGiD58nZmal4dDIlWvOYNA+3V+j+Hm8h
         5FoNm0tce+a1YjeoYofPA5gjuUeBxDZoQf6c2pybde5UtZLACr+gmax3fLOsUNua+1qZ
         S+2hyNPEgKdPT6dXhNSKJdA4veGGHlBNAHW9+FhP5zwYTSPuEm6nvzUOy9NiITXw9c9+
         H1cgF6ANDxiexWMucb3BO417vNnQWExGtYxY4zQuv8Pdds59vP9c9WpqaMVK/a4/N/0b
         WIWa5k2nVWww0EzQMYliqwExN0IVzfoAfbPHOiJOX1JX+D70xEczmTfVKrlyqXJyjHxA
         XsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792692960; x=1793297760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lV5YdQZY6ugatSUWQ2s6iPsnMBrzghU6pgYdBb3t1UU=;
        b=CEkiAmA4HqCfDClUS1897tcxjrKPE8LtY9Ru+jGovG7xvKD2zxkk8MtYPZQ+SARjrf
         013yrn/mu01QmoP0vf1O+nEakxdxBEXAwxOSn/wI2GQDvPHrY8yEzNz8/8+omPQqnf1w
         r9lbUDUMHXAFasoBIkTO7yXX0Mvq2Frt8uv2Eh4eqYzxVchwVyWBEujqwnHtKvZ3ejqx
         xI9FOR7Qyl2VlpE4u9FZP4TaHlXErylm+KNtVb5RPy3T5qMcwNSdoAkqDedn0ClQ1XO3
         d0JQapxNAaORUQzm3UWSTENLOTMnNaUcIAqNeH1WXLEdVJOUWjNcgnsiPZVpAqSuxeJq
         0Xog==
X-Forwarded-Encrypted: i=1; AKwUvBzZsqNe07S1SqU3gmTlpCeEXH4gw7eANmo+vOxzcY67/j53DT6B4TF5CCK2gTSoYTKc4q5uwF+MBgxF@vger.kernel.org
X-Gm-Message-State: AFq9FYIb9uufvj+vnthtEWG4BDJYYniJMoTVedfMoF1M8ZbvFCd34Gvp
	1QUOXNnZwrR4dthMOkKCVBMxoMjZ6aM0h//wBlymVgDqcPuJaOyYgZAFt48zVScX4RQ=
X-Gm-Gg: AYBFou1j8QhfdVKQMp7RFa45l93KwZeWLSOaXvk/VMUQ1OXrdI/VUxeTXRDRFHcljZg
	iuVpfa/mAIc9kfgEo2igOG4qrhbcJJVHLn7r0BG2dmWLqgv9oHn4JhGMyoGOw19StJVttjtJMiB
	REZb7idibC+Sqbos4+9N4EW2+W6alNpKeeQVT2YEOldAy8AsSJB6aupdYWqrfn7xwb6r6JPQE0E
	bsMQAQ+e2GyqNXq9NhHer876jNXBUBpSRl3klBKYdQCC+ARxRkv2rdgJPvPhXlT5CcnUGpePZFu
	5WnGuNt1hZdheZkUMT5foxYV5XwKhJMRdX6kK03bHwYyZMy9aLVWA1Sjigb80guPp3Y41I3HG8+
	rh/vuMIyRLqtlJeu5EIVdda3+zjBSVOZxpNHfExwdNv6hkd4lsguOsNWvb+Xyj1i19FOf/rM7dP
	Hvvu/emKMWPw8TreoODba4VTozzhYnPLPngLfjc1H8SaVx5x+mx0dKzaoA5/VzKf6nakOcSn5DV
	rfwbSqykqNnS4jTfXl7zTdgAQ5zzLNq/Shkd6TzQyGxiy+BO7iuMLux0D+Iy2DLqq50egT+DqtQ
	1XwGCT8QDWYH+YyfSHk=
X-Received: by 2002:a05:6a00:328a:b0:89f:450d:90f5 with SMTP id d2e1a72fcca58-8a089dc75admr5056028b3a.11.1792692960553;
        Thu, 22 Oct 2026 11:16:00 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([115.138.38.139])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a28e23ea52sm774370b3a.33.2026.10.22.11.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 11:15:59 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v3 2/2] RDMA/srpt: widen the indirect RDMA context counters
Date: Fri, 23 Oct 2026 03:15:52 +0900
Message-ID: <20261022181552.3002041-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
References: <20261022143901.2991062-3-yhlee@isslab.korea.ac.kr>
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

The values are counts and never negative, so an unsigned type fits. I
used int because rdma_rw_ctx_init() returns int and the sum is guarded by
WARN_ON(ioctx->n_rdma <= 0) in srpt_rdma_read_done(), a signed test, so
int kept the surrounding code unchanged. I am happy to make both unsigned
int and turn that test into == 0 if you prefer.
