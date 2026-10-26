Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793001813;
	b=tioEJae1XYnrngWuSKdiM/IDQh/Ne8imra+sn18ZAQKNMhlHlaV490sHtsjht4xtdu+q
	 qa8oBKXlVIlQCOHTZXFH5i23K41c4MVfuKXYL4UsE6QdhKrI+i3ncnKqfGMskLPW9bqbS
	 kC7BEKQ0m0o2GTax+d5Tzx722pMoATEJ+OSnLtPAQacLp+r43o5KrkqUgiHc2Y/KgWcuH
	 O6XzbjljCqRpq0vfI1ZAuroqHNgrpPFZydQ0JNaYJvzhHONw37DPoiv24tjpYpyZoNYGW
	 2ZbCcQHOc7uCdhtsTt7A4Bgs3234QCyEJTFHkf0lSft3ePKZ9Di4ttSs+MrBNGYAH9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793001813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=oue2gY3N148Z5QjebnGzECChsQECIfu8P/sF36ovlgA=;
	b=ZtUk3tyoyupIUt00F9fmQU9pTY7vhRpIGBSWU5ZmXFhNrtD1jBtRfIRLf4V1LEyJ8Wgp
	 Rnk+nVc/VZGoy2qTXXFeoOmXglOuWlgVJMdWmRDVTORmTgd/LvzTWNUHmqBV3Rg7d87WC
	 vuiYcchEosVSqJNggppK6X71owDMXB1HV63SYlt6ZvEaffDiS67FpWYdcEAtvcETVDGbz
	 VpMo9J6zJTGKeR6EAy3FWOCp5lCnsmotdpz4SLJhbSxiGJwcjuU++mmrLXkE4lIzRZPRv
	 raIKvuLyV+Wdc+apWNj7o4CWoIOLpnjr9MqK/N6l/MNcddFuHaizQo5jk6DNlr+XmTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C350F606A320
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C350F606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48c4649b35bso2746368f8f.3
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 01:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793001806; x=1793606606; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oue2gY3N148Z5QjebnGzECChsQECIfu8P/sF36ovlgA=;
        b=bC638255INWrPGEz0y4VxyECSaE1+RFwT0AYvc57JZMnX/SDkH2oYoQlp72ynZKxQA
         09imCDi3xA5Wxyz96Q5/B+fO67UzULiZJuMTb9xIJe4Qac/NjbBvoWY1D5+Qmq6ERYQ1
         ZFS7ptfkGN6W6kgUD76g35ultPKI3Mn/+cgreu7FkFJ2k0W16L7i8kfiTy8CwbVazJfc
         2p5DDHzw6V0BVn6v0rpVZCSd6WDMjFyze/50hKPWV5GT2NJ70rtCbkeUXzJU3Tt90+To
         JlBd6INSJAx0qJMl9u7FX/1KF6i6I84SmGVSG1eu523g0VcXNZ48mfUbTefcone1dpDU
         0JrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793001806; x=1793606606;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oue2gY3N148Z5QjebnGzECChsQECIfu8P/sF36ovlgA=;
        b=XcrRPeIFw1rItb18Ez8N2OP9P7+8B/1jItcUNZAnnC7frLXf6vfK7dHj2Yndxr6lzq
         naHY6ZjE+ytg3WVhNWZc2lxOl0mf+BjPEpEwotJifutU+jW0xiE3p30vZkSANP9b+p6y
         RBgPHAfmdxac0goxY3fhnR9NtsOASpVKY7AvBiW8WT4eAMWU6Spc/HxQLeKqoNrhYqdk
         EipOlg+JwPlPLockdcbD0GjirwcGN7Kliaj/EI0A3zud3XL8PemL2Sz9ta0xF50ZYwfO
         MKfkH7bO+gf4m/hYI2rjIdma4pS+1SL2hK7Zm5A6SPwG+V7yPKtcKFbdXxeJyt5e3F8R
         FUcw==
X-Forwarded-Encrypted: i=1; AKwUvByCDZFJfOxlJxkhVB3VXvxa+8y9jaVES62tz0jARGzhjd4wNIs+2bmllFKMQFIoWY6EJQkcP6DZurfJ@vger.kernel.org
X-Gm-Message-State: AFq9FYL5MODkE4Xaji6HWaKaksa7kOitDGFIRapwkb3PegEh4yGCsrgQ
	piIstUXMcc4sR+/P0bRVyTa0izINvjLZb4IWoM1siMPYPfIcJEW8cW6P
X-Gm-Gg: AYBFou3dILnOpfiuWTGGuYVkUD1elj3uSIEpVEjuLjhzaFBYWAYBe3672fnsMurjdu9
	WjOCexojO4a7dLRL9rHdGrvYfnn7jtjy9g6TXmE/TykUTcyCwItcnHtvBx3c9CUd2KC29oOF90O
	9aIXub1UhYQMv6hjneDHhExxVnkUvl974HSvN0wTMppxYhwxtbwROlwjIQerR7/kX2sbAMwREC/
	Nc3Lx134Tr8GCH7gl0R4UxYzakcjGX37BxjXaoRgDEEioHqB7cAQT4yjlFufel43lwYu25N1R1h
	9roNk4tjBtcX+GWfq7m/+qKYdg8dx+l9UvR9/y49gPUxNxdKUSkpbQK7MHqwmxY8wyCwqfZMpcx
	QpOdeL5DsgYNjESMYEO9OKy5GpmAibVKi4Ehn0AsR387/D3UYcMUipyc9ny9/GaxpSGoA+vwS8v
	NmCh6HMlZGn3Zpoh1m4mVtSOpQUEk9eoh7GKbW2TzbWzMTLAOUnrjN1wC8iUwWuLc6+Syc67+cB
	bYhVlY2bdkH2I3a/wowygJI4VqX5eCTfuQ2CyOQSVgxAXqihKSJQtE5xm5C+qAuYHiuz9PxkGbJ
	MHET1Lsf4Nl9Ea4ZJ/e6RN5I1tZetGWn/C/+QP8qVbQLCseI1hR2vFlPPTpRejN0qOcdEEm5lPr
	YCEGiLJRrtFz1aMtohMTuKTc/CVp2PsmcDgN+jmXZ+b6vrbSwSWkKn5wRaiFcKg==
X-Received: by 2002:a05:600c:3f12:b0:4a4:7a8d:c436 with SMTP id 5b1f17b1804b1-4a47a8dc6e6mr85645335e9.11.1793001805868;
        Mon, 26 Oct 2026 01:03:25 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-b1a4-1201-5c78-89f4-99d8-70d7.310.pool.telefonica.de. [2a02:3100:b1a4:1201:5c78:89f4:99d8:70d7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ad39sm473163315e9.1.2026.10.26.01.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 01:03:25 -0700 (PDT)
Date: Mon, 26 Oct 2026 09:03:22 +0100
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Alistair Popple <apopple@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, christian.koenig@amd.com, 
	sumit.semwal@linaro.org, jgg@nvidia.com, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Matthew Brost <matthew.brost@intel.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Dongwon Kim <dongwon.kim@intel.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Felix Kuehling <felix.kuehling@amd.com>, 
	Alex Deucher <alexander.deucher@amd.com>, intel-xe@lists.freedesktop.org, amd-gfx@lists.freedesktop.org, 
	linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-rdma@vger.kernel.org, 
	iommu@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>, zhipingz@meta.com, 
	treding@nvidia.com, jhubbard@nvidia.com
Subject: Re: [PATCH 05/26] dma-buf: Let the exporter select mapping type at
 pin/map
Message-ID: <at8IQZ34wkHQ_5PL@gmail.com>
References: <20261026053623.202642-1-apopple@nvidia.com>
 <20261026053623.202642-6-apopple@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026053623.202642-6-apopple@nvidia.com>

On Mon, Oct 26, 2026 at 04:35:56PM +0100, Alistair Popple wrote:
> +struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
> +					enum dma_data_direction direction)
> +{
> +	struct sg_table *sg_table;
> +	int ret;
> +
> +	might_sleep();
> +
> +	if (WARN_ON(!attach || !attach->dmabuf))
> +		return ERR_PTR(-EINVAL);
> +
> +	dma_resv_assert_held(attach->dmabuf->resv);
> +
> +	ret = dma_buf_mapping_select(attach);
> +	if (ret)
> +		return ERR_PTR(ret);
> +
> +	sg_table = __dma_buf_sgt_map_attachment(attach, direction);
> +	if (IS_ERR(sg_table))
> +		/* Nothing was established, so the choice may be made afresh */
> +		attach->selected = false;
> +
> +	return sg_table;
> +}

The map-failure report from Sashiko [1] reproduces with a KUnit test
against the full series:

  pin selects B -> map returns -EIO -> selected is cleared
                -> retry selects A, with the original pin still held

The exporter pin count stays at 1. Preserving selected when it was true
on entry makes the test pass. Patch 7 needs the same fix.

Could dma_buf_mapping_select() report whether it made a new selection?
Then the error path could undo only that choice, without dropping one
established by an earlier pin or map.

On the Sashiko failed-pin report:
("Because the attachment is not pinned, the exporter may migrate the
buffer elsewhere without invalidating it")

I don't think this follows from the documented contract.
select_mapping() requires the exporter to keep the recorded type
servable and invalidate before an incompatible move. That obligation
still applies if ops->pin() fails.

Is retaining the selection after a failed pin intentional? If so, this
can be added as a test documenting that alongside the map-failure
regression test.

Thanks,
Karl
