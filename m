Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793004927;
	b=iMy7WPlkoLG6UzjQxv/8Dcs8z4YF2vTBF0Nngn1cxZptl8AitaP3Fz75NRRG+Db0Jh3R
	 wybOXHSHksC304ipXz6PVbneY6N3iKNnxWfuPRXkvP7RhQJ2tn4AcltO6uLfltpRqIXjk
	 8UMjVY9ptjleD5rRgPFT4Iqyqsp1CAAZd3PR/XnagUICJgIte83TIZRoscZk86k1b7Az+
	 eZB0xdUQFI8CAmv/4G2wu1ayhBu6LgMG5MlBUF6QxW2yzHG/E+F6eTTj5lBsTLMgQL+S7
	 8w8ht0lEVtwizwTpFWJcoYUuIOnSlgv+GxjkXVfEavDxChUjmRvlajdH6Ks0s4tNmXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793004927;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=7uWmG7opjqY1CLT2aRtMPjlXwAFlsI+vF8Hp0fkUZZI=;
	b=YjOWxGuk2r2TCwZmjiqy0HfAHzfhAgvgJ7sCFTA5FbqZHGkCsn0oGafOYss5x4eDhCEd
	 597yQlzeJyah8Hm3+PezKk+OI6MvmSMIlQYQmmuyfwOGC7mnfRXskSM4g3Eta9Mjfw6Xt
	 w9uUc5Yp2Ko6gLM1hZYpcQfVXsC/jkIvTJDBXRd7s8GDXx6tYzlobrp5jQWbEqG+fto8f
	 rhz8zVL001y2uOGNt0681R7pvGCDvC2DU8DqRH/6xj4MHQsfSWYY5RqiMFd3Km/JOR09a
	 R6oD8ngl7dUfRV+bZEc3pkP4+U6CK1RZ947DAXeSbrkCrJeD9x3fce/x4KOViDv3qUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CqfNjM+8;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF949606A31F
	for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 08:55:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF949606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CqfNjM+8
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e20edd106so2361059f8f.1
        for <linux-rdma@vger.kernel.org>; Mon, 26 Oct 2026 01:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793004925; x=1793609725; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7uWmG7opjqY1CLT2aRtMPjlXwAFlsI+vF8Hp0fkUZZI=;
        b=CqfNjM+8C89bgkGlsM4+XoeauRFaGUstDgQmv4Dji7ej8YT+OQ8qiXadrk7QpMoJMz
         9TQ68alGc7yI51WQJEpyAfPH+ve+64y9D5tkWt8yqjMJnrDpropJ4SMFgDXTH3rMGXsc
         BTucVGdZncp8jIrbuyGAQXTLAZxGXQbu0LyQ0HW5ChyjbXxtKbYnV8Xi1uqK79wywByL
         d6+vF7ey7tf/XBXevxDakMwrIBIeQjPV4QyA/x3bxo1MDu0dizScD72tkq8F48kSIUpE
         9EQTHut+PAi5ZKFiFr2nkULCLCo9soJFS0AqSiwft0OSg1eDxLUvtBQkyg38qOAdgtBo
         AoWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793004925; x=1793609725;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7uWmG7opjqY1CLT2aRtMPjlXwAFlsI+vF8Hp0fkUZZI=;
        b=d/ht/GfOk3dFrP3u07dFQogvBWM3VX+6NpaP1rvnKS8+5SG5PjH8uV2ot5zCerwoMs
         aK07/Ou80dAsxzL+a+weV9ZJrRFUB3wKVwyve6W1bYQBTGGyywPHANwquobw911i3gyJ
         6DZTOOSVXYxGemfhONBdHy6Uf05sJ6p6CVggHv3ae4Q7aPWVwLfnlM+uG9PRJuwPnAMC
         xgCetNOZDNnotWjcGYF1NXV0era5sIrOB3eNfWRkTbj+TQmz3d91KboaNvTq8nuBegds
         5UhudfmeJN4OAzPehP6bQR/IdiyragV6l3bAb4xUcvqHcVmOX2FlyOb4FlRluS84yH2w
         h2gA==
X-Forwarded-Encrypted: i=1; AKwUvBx2ItyDp3OEzVsIfZZ9Obuwtr6kEo1IC0FO6UoSeoSX+VZt2tS0U6fzLsPFEGG+vMMkHX3Yu8mCUVeO@vger.kernel.org
X-Gm-Message-State: AFq9FYL9h2o/tdaFL26oU+zQoVr/xx79PInULfKKYvzHpNIyhSrM9V9d
	S5E2JNIMGfK1k9hMutlale6WOyNSdBm0uEDY7F7ggEt9Di8T8PYKEgWs
X-Gm-Gg: AYBFou1hqlLUtQ/FzeQIgIQ1ArCI5dnfLJmlcZww6FmoVL+ZgUh5knKbdkKckQ11q4o
	z+2mTTrYocz1Xm05QKef/RhCIifvoJ9bUPbW3FMnwRlYxNOM33DTcXZsDVLqGoV9RLVsNIr8XRi
	npRPTIqnJy1nEcVAk/Ia58ov/vIEHrDS/rKxx227IFHa8ImTNSALVIJ76MhcYgIFUYZYhhzN3fO
	RYvbbWJeBWuxqEFyZLwuNzp2kDGmz6HPj9esAG8RwgVwrdlugSV9Y9B3tCBZeC4YA2RH1pIkvoF
	M0P93nm8jvYWLoliCpZofs177YO4Q/7pdk4iSCmJKATqVNOXfAlm9JPl2Ys8Fiy0vuimEhf73os
	WQS1QynMx3z9SZ5mC5gB2bgoqlMOb65WkfjgbV3oKgvADFFGjVc3ABuy0St9bPcCYB5syGahX0s
	z2JBc/Zkl4ili6Pd7gHrfG4RT/IHU6sAMKEbAGACqoN3DmXwBdgUI3t/eCo/f8HlvhBuSL8uYig
	w2AoLk9B+Gt+uy0L/TA6qKjLk5Dl/Fd1VGL8wLOmldb18ynRgM+rQV5AxUwrKhhvKqmwk3g
X-Received: by 2002:a05:6000:4908:b0:48d:cb76:548f with SMTP id ffacd0b85a97d-48e3eb92448mr11162750f8f.38.1793004925077;
        Mon, 26 Oct 2026 01:55:25 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd37f4sm17884912f8f.44.2026.10.26.01.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 01:55:24 -0700 (PDT)
Message-ID: <f2dfd241-a664-46b7-881d-13c3b974b557@gmail.com>
Date: Mon, 26 Oct 2026 09:55:23 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/uverbs: Don't return the shared zero page from
 rdma_umap_fault()
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>
Cc: linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261025-fix-rdma_umap_fault-zero-page-v1-1-186255624f1f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/26 3:04 AM, Zi Yan wrote:
> After disassociation, rdma_umap_fault() returns the shared zero page from
> ->fault for VMAs without VM_WRITE and VM_MAYWRITE. Such VMAs come from
> rdma_user_mmap_io() in drivers that clear VM_MAYWRITE and they are shared
> VM_PFNMAP. A page returned from ->fault is mapped as a normal page and goes
> through rmap code. Two issues:

[snip]

the code LGTM so:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a
