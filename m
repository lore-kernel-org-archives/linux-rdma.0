Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B9436370
	for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 09:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785316324; cv=none; b=WYl+A2B8jEbvopkVHA0tivShuCibu6cdfTmz4sWdN4/H7Fnub5QOSOGRBQH/9e0hFd05yHWgA2a5Mj2M9tLQt5SQEYLnUFtncPyIQoWslDZkXmnrCXd9/IiXTCh5sNioltImP5zwmN390DOPuVob6mICGa9THI7egtVeQwtNNCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785316324; c=relaxed/simple;
	bh=1tfKRhaJjdfZy38gZAanLVHmCMS7aHKIqtBx3ftd3W8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rh6QmSrek0Z+NGAdXktLPKb+5g8DJU9eJI+YnzAH2CHVVP+i7eDOHk0P8DpbrluhUqLD1JsbtmYq4lr9147UBzKOIj+vq6Y0wIIBLqw2OZhzUIGlg3A14WDPoWgTxM3ZAifV8ksox/ZmGPAuet8NUJenl6sVoYaBuTrd3u5VTR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=aP37c3S4; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="aP37c3S4"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493f6de72faso5205905e9.0
        for <linux-rdma@vger.kernel.org>; Wed, 29 Jul 2026 02:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1785316319; x=1785921119; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kqRebawaW+R270ENqi7eByUr8cNF8X3bbKCoC4j9T1s=;
        b=aP37c3S4N3h61FwTq7ivW7bCrHai+dbbtEKqCspMYLM4evmUpYEKyM02y8RdbspXKe
         zJJSBaNBf1ssudK/5kqBsvJooW/UCWG32xOhz+xMhCpTFNiIfFInD+SWb5Tmpp/xKcWj
         OqzcGUj+gXoK3T7TwVFo/6Q07m6idkMh6lpVOg4s6Dt3+WDr2vS3/2eZ1cRlicc3utlL
         PANg29KTPwzxWAJpkfx4BW8FrByt/FDzhVzTLvzCCjm+HqxliOLhybIba9paqb/iGLxP
         TgHQHwq39RuUH/PhImKgDU9NxLBtjOkKl7A3uPx1c9o8scih+dDMF3biUuguGuaV1cT9
         aqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785316319; x=1785921119;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqRebawaW+R270ENqi7eByUr8cNF8X3bbKCoC4j9T1s=;
        b=XlVBBShpvM/tgDtITfNHnouUXqxiK25UoDvNqlALfe3wZCbpiIsjSpqqocI0Rkpjyr
         R1zdJpY10nZnaCGHrASQ/UXCfZ+FzT5PFQzl1E3M4ChMBJVhOPITVxOzSzQC2JWclcpw
         WNsA2I2j+bIgAPi9g8BNzMkiXwzyDFIFPdu9W2AXsCnQo7qlw8bgi3+MDR06o0iYQs1l
         P6JhOqHaS9/N4Bb0Rkb4KXMsuv+10tJL+6yoc9UM8yvOeYxeoPV/CQ429B9ktc1QZzJe
         n4QfHO7ftZ2TPeUeVjHWespxqkfACipajShK+F7wjNSmMR/e41ebsLlO7ebjgQdHMMtG
         aSHQ==
X-Forwarded-Encrypted: i=1; AHgh+RqNuEyn/as64Nli/mQYnfjSp6ve9JAUbmsjXUkV/HX3cqnSoh+nXiqmxD7i1RqKE2Vt6FK+uPc0+DTO@vger.kernel.org
X-Gm-Message-State: AOJu0YzjzmZbUKlDntDxHDZTIrqMAIV45brANqZ/ZwKmy4kx/cf/hisz
	NJxLdgePRfttcosu6TAN02194QFLGXxjJkrAY0b3hiMmxPfM9pHiHM8myYPdjROUDMw=
X-Gm-Gg: AR+sD1286h/5Ib2XphdJifNToCwmDPzBKT4zlOTS83excpvJaQdOnsILLmAoB0Spo1z
	K6CX8GSH1UrihROJEkZ01GE+9pHf6mPVOxuMDFj5/xNnLayauJoA3DgztrEsLFgi12umVCrzlU0
	75Gjt9EbFIZEbz1f0ybfa7uA5cDH5ZJY+RaRPfXGNmD+3LWYE8sOqnyrcr4qvjDQrIa/nZnBEbU
	jW/Q4iKmuFtxNqbslH56+sFLJeDiQRAUKcvsB3jzwjysWa/+8/slf19ZBqA6m3yIhkVvhegnYbD
	QpWkHhCZqnmBinxqM5JvAHkYIe3XRy1UP8/3QWWB2LtTxBH1tGDna8al8kPXFE2HyMakJ8qEjtz
	od/MqBaepSmrd+YGGDtjWlESXRxf2Lmb7Lkc9BeOCe2DTAXhOABogio0VRqcDdyjtTHKYzWtpQl
	Ue/eN7aL4ns+geJpRE3Ub2DiZmtdhh/kv1WuFzKFd27JXNFN2/xVLJbuoVMogrp74lBTFx8Q==
X-Received: by 2002:a05:600c:8710:b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-497fd311860mr15174085e9.15.1785316318462;
        Wed, 29 Jul 2026 02:11:58 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4975abdca42sm40097255e9.0.2026.07.29.02.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 02:11:57 -0700 (PDT)
Date: Wed, 29 Jul 2026 11:11:53 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Mark Bloch <mbloch@nvidia.com>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, netdev@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-doc@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot defaults
Message-ID: <amnDfSmMVzpiH2gE@FV6GYCPJ69>
References: <20260716084852.549909-1-mbloch@nvidia.com>
 <20260716084852.549909-5-mbloch@nvidia.com>
 <20260724161111.2ac47089@kernel.org>
 <c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
 <20260727131033.237f70b6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727131033.237f70b6@kernel.org>

Mon, Jul 27, 2026 at 10:10:33PM +0200, kuba@kernel.org wrote:
>On Sat, 25 Jul 2026 09:51:34 +0300 Mark Bloch wrote:
>> So I think you and Jiri have different views on the basic design
>> here. It's hard to respin the series when addressing one review
>> takes it back to something the other reviewer objected to.
>
>It'd be great if Jiri, an nVidia employee and a devlink "maintainer",
>paid attention to at the very least revisions of nvidia's patches
>touching devlink. We discussed this on a prior revision and he didn't
>say anything.
>
>> How about I drop the driver API from this series and submit it as
>> a follow-up? This series would only have the generic workqueue
>> fallback.
>> 
>> But where should the work be queued? 
>> - devl_register()
>> - devl_unlock()?
>> 
>> Can we settle that before I post the next version, so we don't go
>> in circles again?
>
>Maybe a middle ground would be to add a dedicated devl_init_unlock()*
>were we can stick such init? Slap a WARN_ON(!registered) in the normal
>unlock? I don't want the normal unlock to grow in complexity like
>rtnl_unlock ended up growing.

Yep, that was +- my idea when I suggested this, to have this in a
separate helper.

devl_unlock_in_init()
?

>
>* better name welcome
>
>BTW AI reported that we reset the mode on reinit request. Based on
>the code this is entirely intentional but would be good to document?
