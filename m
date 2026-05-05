Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFC23C5553
	for <linux-rdma@vger.kernel.org>; Tue,  5 May 2026 06:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777961519; cv=none; b=XVdE7s87XeCNGTM0RFSF641iWOqvh7G/P7tquF3w4H8fm+1rDOZSEZIhompA6z25+m7zpns+RzADHkoZrJb3URmxMOJ+odYToUim3OO6QBuE8XD8OLP87ilfIddNIozPclix+SP1dBZgXY0eyvmGG36ygo24uyYYALR91DMg5Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777961519; c=relaxed/simple;
	bh=eUAAYZ7nRr/F5QiKkU29gKgjl2OXQk2WJI6vFyiZUe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlY479+cx6v2jTS2Z48SrsepdaZkcb/7TJReQMNaLyoebddrteOteL2S0sxy5OAoz5Ze3OoYOtAzqw+tpC4je94BoiKzYiZn/pYNMH3KHI49e8OVoWxdk2F5EHrQtQCqFwwABBeIFXeQynWqredIux7kdTcaVA7d2IBZp8gZH30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=fd/N5vc6; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="fd/N5vc6"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44a786a9a35so2423635f8f.3
        for <linux-rdma@vger.kernel.org>; Mon, 04 May 2026 23:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1777961517; x=1778566317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7arSC+2chuP7moA3/IgQEt1ifYW9gzSi2OdLx3CUE8I=;
        b=fd/N5vc6cy7AdZ7a20NMh3exdgfgFJ8oNUmklhecw2SWRn9Sx4iHqGomQLhIjXZ0jK
         kdned3oJ5R+Ik7vfSXus4vYpmF6BOhHyknBYCTmk447/NmuNDXSupRECoyWhYagtGxaV
         j8fsxKbXKZff6DY7Au0DGXqmN4UZBHcgIIgXo5ji1S4SYcYr6HzBDIgW1Yc+hTEI67Ix
         Z8JZo4ZlRqm4H8SdamYwLlhBUhR8KcvFxh4aNpBVSw0TD1zsIK5EG6qlijgrJt4hIfwf
         /4LjdncUaXqfsC6hEpBaFfX1iCeOgv48BnrwE5T4Lrtt57x7NTkGeoO3L55aWWFFZ06w
         tfxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777961517; x=1778566317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7arSC+2chuP7moA3/IgQEt1ifYW9gzSi2OdLx3CUE8I=;
        b=BIiMzHXpyyszmCD4VyhTya1GDMg4hts3oREhsKjTQNrbYpGBpx73eC1uR/r5ai3QVn
         dK59CJSyTOfa4cKYoAH3zfS1TrBTSuykiuYJNMt933TXZbW8nGdRJ7sRtYpHFrPhp5HX
         55X7LEcrgmHQU6/cr3KBYFrJy905VSfx65r44Whpu/ceL/MgyiXt3MxtmIkmJPgtj3IM
         potr9ABdqN5QGyttNS2VFpUDbOlZv+UA5qKvM04eHdW+XhKaFIYquUKVoNKTpZauMkM5
         qz2pzvtldddzddCu4xf32waFN1/pRN0xmMIf0K5snzTOeq9JhSr1GNR7nTyrJrasClju
         DO6g==
X-Gm-Message-State: AOJu0YykSF3q0JBv8xvy4tT+2ukrq2bLa2XYsWtGuvpI1ItDwOxDHJCL
	WksNPNCcNlLJWM8VosPjgbaE2RWaERka/BFreTyRBDgV2zhYsPJjXVIe3FbVZC9LJE17TTH5iMO
	/iQUH
X-Gm-Gg: AeBDievGCTcuewItRY7iEMbnt85RFL1eTyea3uAE4QhRjnuFM3hmfg6xdcrQr5vYlti
	nxICbcC8fTX5+fAVecL04jH2aSKPFMuB0GW4sr/PkNIGfpnAJk4FYmn4v+01PCZ+aXK79YScjSN
	LWoew0THWGBjid7lFbmJJhPl9v2HGseWlmUy2ZzdBQyL/cQCClX9ZVIUQk3DDV17LOR280aoE4W
	z2ixxKXH/5dCDW7AGW2pU4XNwOZoYIUodJiXh5ZUeQwKBgRWAnJd3v5BTAOIZT1SDY/IIt6Wfc5
	bL5cWh6237p/Ep41H4n0ZzgvcMjLgBxb+qYY8NhzFMt674pgQOX49Eri2q65YmpuYFmR3Js0bvK
	rlvBWBNRfXZmYJQ6oPOpVYj2hzARg7TCevrnmBbY8V23ESLUCP9SDDpEs/fsc9R2obQZG8qdMOF
	mWbbHRKOC+omLR4ePWvececslr6sQAx133v85A4C4S2OkJC1wxLSm20uCP
X-Received: by 2002:a05:6000:2dc8:b0:43b:498f:dceb with SMTP id ffacd0b85a97d-44bb2f282f4mr21045329f8f.9.1777961516748;
        Mon, 04 May 2026 23:11:56 -0700 (PDT)
Received: from localhost (46-13-72-179.customers.tmcz.cz. [46.13.72.179])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4505248323dsm1974889f8f.8.2026.05.04.23.11.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 23:11:56 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	edwards@nvidia.com,
	kees@kernel.org,
	parav@nvidia.com,
	mbloch@nvidia.com,
	yishaih@nvidia.com,
	lirongqing@baidu.com,
	huangjunxian6@hisilicon.com,
	liuy22@mails.tsinghua.edu.cn
Subject: [PATCH rdma-next 2/2] RDMA/umem: block plain userspace memory registration under CoCo bounce
Date: Tue,  5 May 2026 08:11:49 +0200
Message-ID: <20260505061149.2361536-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505061149.2361536-1-jiri@resnulli.us>
References: <20260505061149.2361536-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

When a device requires DMA bounce buffering inside a Confidential
Computing guest, __ib_umem_get_va() cannot work. The DMA mapping layer
redirects all mappings through swiotlb bounce buffers, so the device
receives DMA addresses pointing to bounce buffer memory rather than
the user's pages. Since RDMA devices access registered memory directly
without CPU involvement, there is no opportunity for swiotlb to
synchronize between the bounce buffer and the original pages.

Fail early with -EOPNOTSUPP to let the user know instead of a silent
misfunction.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/infiniband/core/umem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 611d693eb9a2..b1877b83b021 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -167,6 +167,9 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	int pinned, ret;
 	unsigned int gup_flags = FOLL_LONGTERM;
 
+	if (device->cc_dma_bounce)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	/*
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
-- 
2.53.0

