Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EDF384CCD
	for <linux-rdma@vger.kernel.org>; Mon,  3 Aug 2026 11:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785758359; cv=none; b=mzz6UUl1mBIGNgMmfnkVN4InSefelH0l3zv2W95Lzmm96w/UimHIBbTtPXPe4TxhgphgtaDYnFECzLL6DI3+E0krMRKyoztE+7Q/NOnx1tVcN9zpO7bPuBtHdVb02n5Uz08NVRUkpWPUO9vitavPTX2apYB/bKENCXGyF/CEmH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785758359; c=relaxed/simple;
	bh=LGr2JBudFXtQ4Ni+TyjMLiHTOBXGdKgbtU1pxmP0shw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwApzc4XyFfUKvLgqfz7aXe8f/+2GbK/DFog/m+tBngwXYFT6G2Q5nS4BaTaLZcYaMKx2QBuLiAccUQCjczR1Pv1U6qPLnsOFfGLf/HWRKvteiE5KQwdEo2U1x8oSwr1nVa9jER2km80vEFyvtgTp/pZIbWBYNyA94OzTA9qB5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=SYwqDgyd; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="SYwqDgyd"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5b2a3166398so2709866e87.3
        for <linux-rdma@vger.kernel.org>; Mon, 03 Aug 2026 04:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1785758353; x=1786363153; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s5nX246tmJ2aEHx092HUDukd7vHZ9i1KeOZr9TmAuuA=;
        b=SYwqDgydHQW2lqhDHNU1neiMwX6fT2+e/kKHGQ7SErLpmHyy5iR3BPxeEfdTFBLsqo
         zo37nd2X/QJsVlmPeymLxkBz9phGqhlaE93gaiRBxe55e4xcNl5eoDHvAMC+SWOsRsbH
         Rnu3OOk8y/6JQH8Dcc79sNTM+jCiFSzYIkIApefu+3pMT0aPCCKAdOThQxtvd0QCVhbz
         i/p3ihe3GagGnJAwFpOyJB3hVSOpZu79/VFpkEDf45s26e7/jyMO6HP2bH0QMkqWexO0
         V0S29Gs4OLf4OMGmzATi56lQuvsrXHcYiZGMNjUyMpqMg7xlCEuKCdG5VP2zS77ck44N
         Wwiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785758353; x=1786363153;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s5nX246tmJ2aEHx092HUDukd7vHZ9i1KeOZr9TmAuuA=;
        b=oRHsl29Tcbhu0MVP+R+d0ATS2kos5gfTz4detVmuAlTviRj0B4GTt55WtBfV2Qb43h
         RhDv8rQpr/n+Pb9TsoFgR9CKFQDkhfcWuzx9rfSUMdXmL4JurWRsLclgBKQ1Y0n2z/91
         pfzJlVuoiAVxaobnFUWIQXk3zMS2uIXq1GbbBP64Z4f3DCDVi5Y1ecLlE2jOQ0DWNqix
         tUN3eHuC845VFdF0/3CnFHL8D9cPWb6ZSxePneeN3+KYxcI1jC63no9V6fqf9f0TYbz9
         CQkmqlX7b4YTCwKHjuCOavCk4sKb3NnJ2W3FOk4thwkK2WcPKwlagSsgKttvW2wm6d8r
         D/hw==
X-Gm-Message-State: AOJu0YwRU8R3O0LrT4EGa//KWEQD+QgwY1CAK+XtFDByNoehUGbMtrX6
	zr80dMl9DNZ4zkVDcN9WH4Pm6s8XHkvQqmHSbN2ZLZ59zU4BGSjmh0FvrrxkW9kCBBE=
X-Gm-Gg: AR+sD11n/YOHWNmjp7QW6UFgI3Y6/3IIxagcn56jkdJIaD6YSuZ28dYz/wlI6E3zxbK
	brST8WhvKax/nSeyn9CbJ4yiAYJo4kF8EB4rIPn6I18e8dJ3OcwCStvNLIftkUvj+w/iD3R68Bv
	y7rvsGcKW2/pL7V9YwHkrGOYjVjfdM/WbkyHFxAv29G+th4KocQA5oDsZhHjFuHv0x9FpFV9Y8n
	WI8heNd8PYVHV1K/qCoqZUnPWZk0m7KUBds8MpNluJ8R71qQqpPvpPnWez4eu9w91kkmnzbjvab
	02+G8PjvmJTOX8BqJOpddNFKL2uEeAm7n6oqtnAZqGiVHGXN11insjHxvpxTzrjr3sIRIbYmZOG
	+fQNT/a4qQTDR3iewUIFQQVGRyWwOWVBnuzE8dgOXU5wYnJd8EO19888ZRVSmTW1a388vXFaQ8K
	WJs7m4Q5Wj/sL4vkUNHnLrbDz9dGf3BRVVeb14BckkP3/Nhy+aAXw+nSIAA3xx7n1QpFpaY6M=
X-Received: by 2002:a05:6512:3da4:b0:5ad:5c4a:8221 with SMTP id 2adb3069b0e04-5b2e4cdcb49mr2598346e87.0.1785758352621;
        Mon, 03 Aug 2026 04:59:12 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23cbf5asm2007557e87.32.2026.08.03.04.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 04:59:12 -0700 (PDT)
Date: Mon, 3 Aug 2026 13:59:07 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Konstantin Taranov <kotaranov@microsoft.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, 
	Long Li <longli@microsoft.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Message-ID: <anCBtLSxn8TtFcSz@FV6GYCPJ69>
References: <20260731091041.2250897-1-jiri@resnulli.us>
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>

Fri, Jul 31, 2026 at 02:54:31PM +0200, kotaranov@microsoft.com wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Commit eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata") renamed the
>> "flags" field of struct mana_ib_create_cq to "comp_mask", as
>> ib_copy_validate_udata_in_cm() only validates a member with that name.
>> 
>> The layout did not change, but the field has been a part of the UAPI since
>> commit 44b607ad4cdf ("RDMA/mana_ib: implement uapi for creation of rnic
>> cq"), so the rename breaks userspace referring to it, for example the mana
>> provider of rdma-core assigning cmd_drv->flags.
>> 
>> Convert the field to a union providing both names, so that
>> ib_copy_validate_udata_in_cm() still finds "comp_mask" and userspace keeps
>> "flags", without having to add a helper for this single case.
>> 
>
>Thanks for the patch, but my understanding that it is a common practice to rename the fields,
>and kernels headers should not accumulate historical names. 

That is not doable in UAPI. Some userspace app, like rdma-core in
this case, might use it and rename breaks the compilation. Some other
app you don't know about may use it.


>I also faced a similar problem from renames in other providers, when I needed a new kernel header in rdma-core.
>If this breaks your rdma-core in a PR, just remove the field rename in kernel update commit as that header update commit is not getting merged anyway from your PR.
>My understanding that maintainers of RDMA-core will merge the kernel header update, and will bring this change from my PR:
>https://github.com/linux-rdma/rdma-core/pull/1765/commits/0dcadd9316f1b98e21973e3a6e0f96186d49bd5a

this is not how UAPI can be changed :/ It simply can't be changed.


>
>- Konstantin
>
>> Fixes: eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata")
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  include/uapi/rdma/mana-abi.h | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
>> index 410f0ddc8c89..431c7076f20a 100644
>> --- a/include/uapi/rdma/mana-abi.h
>> +++ b/include/uapi/rdma/mana-abi.h
>> @@ -25,7 +25,10 @@ enum mana_ib_create_cq_flags {
>> 
>>  struct mana_ib_create_cq {
>>  	__aligned_u64 buf_addr;
>> -	__u16	comp_mask;
>> +	union {
>> +		__u16	comp_mask;
>> +		__u16	flags; /* the original name of the field */
>> +	};
>>  	__u16	reserved0;
>>  	__u32	reserved1;
>>  };
>> --
>> 2.54.0
>
