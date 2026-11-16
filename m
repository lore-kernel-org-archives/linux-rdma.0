Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.130
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794842767;
	b=obizPo/YEGMNX/eCtNNn7O2YlkkOrhKJWhLHGyan0/OxlmKwR310QhvTJA0YRz2WYM5v
	 7rschmdS/8HqcuFXK0YOck91dPbJRzv+LczfWq3t4pqsF1Lz/hYef4iEL8xYpZh5IzkGR
	 et+KhcMwzptsgGtFXp5+PDSMe9+Pwdr0l4mvIiMsGgM6uUbuTj6URadt4NsYK/HhSzXxr
	 grmKpqixDXcy2sq1nOkv3k7JDIHM00G3Opa8boq2UBg/VMblmNCroHLjbv8m7PmLuDE+b
	 DK5rv167cO/IKbcAvthG+c2/wvp8KVv2tQqn54KaS4G4mAzSBoVWf4Ipma1mMheAh1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794842767;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=Iq0gvta/Q6CQ/D32KI0+/Ff7riJuqsj3tfy9XR+jzCE=;
	b=I6SHx5SAvwRyqkjSzVpo2sWziLooq/BDI1frE0nL5iYEgx01eeUq6YobAQeE4Dvf76KJ
	 6T/wKegQvqudSvMADWy+Fu72ywFx5DA/mFrVZVfE/07hVFBgekuZZeKX8mPz1K4U1zLS8
	 fPlF7DbpWa6oFP7jB2jHT2svN+OzSl5wmQ8PElR8QWgiI3/D0CFqMFEEcghllrAGR5cGd
	 1x5j2TOg16vbqf1uX/FADlhOR7HfqCfbLle65zJGSPmtV93MarEbsEKnkXeUnZGcwq5QR
	 TN72x8JphvRX3np5cZcHj2U2JrvPPKxR5nB6PFkaKKY8FpAFwFUbTnDCWTBGVfAFPnQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VAcZVJfQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.231.130
Received: from mail-oo2-f2.google.com (mail-oo2-f2.google.com [74.125.231.130])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADFD2606A893
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 15:26:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADFD2606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VAcZVJfQ
Received: by mail-oo2-f2.google.com with SMTP id 46e09a7af769-862a5ac28e9so975163a34.1
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 07:26:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794842765; cv=none;
        d=google.com; s=arc-20260327;
        b=iG+TB89tQrGiP5mrILJNrWVuhMnRiNbznd7iQctVGbqcDcnomLNAeHfZxOZoLaIPS0
         F55etMJQdraY1Dfv7oxvU4wTGrPARweH8oT26ZbiblJjPOAr/1ZXeGBXoW2S5ZsUVEDQ
         ESpGI1QmExLjHjNd9MQI+lwRUPgeS5XzFLNk2L19bMD2wl7YZIeIB/XD7+hF/eMq6dx6
         Pr0OUocsvCucYcfzSU87jT8MqmXY9/vS/w8Rv+BoKU9u6AY1OSdQepaIePIkAIyoLfHH
         c0tVjzXW8oUfMQJhpimMiplZW8epjpccURAIp4qQvXEYqMMn6ZhojRG/Iq7KPV5w4dPc
         4Qnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Iq0gvta/Q6CQ/D32KI0+/Ff7riJuqsj3tfy9XR+jzCE=;
        fh=1hHXF9oqmHisMbIs37NS1sYkJ5kl5hvS8Az/OIx6Hxg=;
        b=AkpSdA6tnmP154A8ryhepo0QN3m7ESdK/RBgaR8dtE7y0Sza3as0KoiPUJIE7QRobZ
         IKN+DbKQkX7C51hGX9OBxvef0veDnz8i5LqUNflUUM2zgW7iqnLe3Q5aw+KG4ManF9tO
         Jd4Nw7zh5HOUBTbuq1WOw0B7z+p/ZaEFCWdE7W9/2aI9HPYwjGHkuUk6KM5JDxVNKYQH
         qYrqoQUc13+m2pJT7AWtCNbazyBUB3BuCjkcQ3i+dQkFnYVmCQeqHvjwuNdv7xHMGXXA
         kZvSAzD+dJhFkMMJrkaP8HBHZuPVout32R50x+8az7yeNFIpCsDFMbKNgKFFk5lsoW3l
         F6TA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794842765; x=1795447565; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Iq0gvta/Q6CQ/D32KI0+/Ff7riJuqsj3tfy9XR+jzCE=;
        b=VAcZVJfQcVpNw9B6+eo7YYDLhUeLrAVYky8jyUBvVckKs86KZ7U5tvkWPl1+OzTt2l
         t7AyoOR7UKHMC2B/xRQSnTOHA57DVUrTMSP88JGWxzLpxSOp6R34+eoVMghw/zeyxEY6
         bAxriFQExR9zERYlbjPUVSmQnQS0mH1C7Xez6c88+/jDDhwUxB907kXWV2Gv8NICp2aW
         8JxMY/n/2+d86xjSwzu8G6BUQ2oH/yny67qxhDKM7Hon221vdr0dtx6VBVfeILwGQ1yO
         Jqqn0QP0n+SmVOf/D1LwcLiCZFl4/gdECvrHslgtER1/1PVEAlrZzxhzn9bGdlK7rKzK
         A6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794842765; x=1795447565;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Iq0gvta/Q6CQ/D32KI0+/Ff7riJuqsj3tfy9XR+jzCE=;
        b=Y/RrnGH0KaBMjMr76odVSSK6sTA+RkdZLQoTKHZpH2lWKt3+O35+osdD8OS90jEKfZ
         ufs6PNCHWByYlAI4oSgV/oT+u6JgP5WdMUiq/4FXYLbmqwEF9SFFj1iRCbv2DREazML1
         EXbmjIdFfo0SbXJkCZbLU3ObYa6n+yjDrewFlx1oc7/QHVYo/U5ZHzPkzDIudi64O0oy
         BsASXGFzU6UATBHzNQm4Q/A4vO2MzvOY5nPOSR/ZVhGtqRDVsylvGRqDBKqBJKuhMzkt
         GnxkdXBzIZUqaRW+rXV+05jZNuvqlOrDzHZVvQr9AqLBJ5DmffmPQXITyYj5Rgv7H7v5
         hx8g==
X-Forwarded-Encrypted: i=1; AL+hErHeNd+wGYijqzDGEMA2lHzC+t5/TZo70ESY7IBL8tjCwOQ4zX9XJR5GIBnUapKldQf2k4pTK0fEh3Ry@vger.kernel.org
X-Gm-Message-State: APuU4Z9lsV1fYBEME1VzmmqaErAne3YWDAX/F/1SwT3W4K4FllnzwcMk
	24x+VRvXE93Y4674a+XsG7VJjzOHNGPKgIbzSmlwGDDUQbwO7Yb356aJO+x4Okzgq0Uo2foWkgS
	1BqU2JU4lZax7xw18JmhFoq1OJ0fnr34=
X-Gm-Gg: AYBFou0OzbApAST7LLoIph+yf6ObR52zGJv0rDe8NWaH/1MzmR5KcvHTjvtxXvqumvU
	TFJIqi7OhzRdI9HN+BkiL7go5NVfjpZIwKm/7SOF2ON8sWKWaxdi0M3WLf+jylloOET/PnBObC4
	pZIpkkYfgdMf954fWIWF/fHKaigytyOZhYEXK+4cNSF/D/eBN6ls5OP3qKnbWxRLj//bZYBk4gx
	3EgWuAlFy7f1MPc+PzLBkKk0T5jN4kmYEH0gagqVfq8pp+HkFZpcENqSKxDlahaz7dYtH9L7930
	RyCKtnagdY96aCpKIVwvYJKjmlA2RA7q8nSoB9Neg33kZHKALV1GgqQnTd9CWsRdckLbUvAfxes
	kfsW5NEYkABsajTK2IxBmYQ5mBRvH4huNVeXhkCv6y8KCkPQY50Kz17kFWJ26TriYKCnUChjBrm
	VIu02QUEdHk6B+gvrwSFX+lPNWIHSKTSgOouRS2TPxu0C+N8G8sZQ0
X-Received: by 2002:a05:6808:199e:b0:573:f2e:2c17 with SMTP id
 5614622812f47-5730f2e317cmr4461889b6e.45.1794842765588; Mon, 16 Nov 2026
 07:26:05 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115164658.88420-1-dennylin0707@gmail.com> <20261116133927.GO11319@unreal>
In-Reply-To: <20261116133927.GO11319@unreal>
From: Hungyu Lin <dennylin0707@gmail.com>
Date: Mon, 16 Nov 2026 07:25:54 -0800
X-Gm-Features: AclHuK-4XlKSUrW0xgWDDO2zpNonQezzc7VHG-Gcnkk_w1j8JkN8KqPTBfnLU58
Message-ID: <CAGEkeHfdRtDM0Ziwe-cJp2qsAs9vstUv55HQ=ydzZByQ7K0Wng@mail.gmail.com>
Subject: Re: [PATCH] RDMA/mlx5: Validate the DEVX command length before
 setting umem valid bits
To: Leon Romanovsky <leon@kernel.org>
Cc: jgg@ziepe.ca, yishaih@nvidia.com, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 16, 2026 at 5:39 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> Thanks for the report. We are aware of this issue and are working on a fix.

Please Cc me on the fix, thanks.

Reported-by: Hungyu Lin <dennylin0707@gmail.com>
