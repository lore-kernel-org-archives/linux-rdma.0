Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64134582DD
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 11:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785841715; cv=none; b=Enb/o+We/NNbT2oAj58BTjTQb9ahI/q3jG5j3Xew1KSZer4Q1HeHxAklEY8QPJRWPevrSFBJMu6+DyocetEQW4vmarL81fEvZQOeCr09fhQwetm4D3PbNLBC1TmT55Ec3onu6j+LUSfmJlvhk8VENvvQ8TxBmtvierZiOmHE570=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785841715; c=relaxed/simple;
	bh=qpSjpcdU0lZQjHDQk8/Zn8BjE1TAsojA7eExd4R7QrQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PebBHL3XpBc8H/qZHga8dhh2Q1XHpbgO90Ktxp3ZqRmp7FVksvVGsvpoFsiIxZJS0KvkLLzB4F08w6U3rWSnu7+w5y2dU5/UeGjqfZ7szlNflKe+urlZqDJtzZ0A6mNTsJoH3q3nwAmH+Hf3HCQCRDA1F/UZiX0+UNpjyhtEWCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=TqegCiS3; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="TqegCiS3"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b2a8e4c77eso4458738e87.1
        for <linux-rdma@vger.kernel.org>; Tue, 04 Aug 2026 04:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1785841705; x=1786446505; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kI4V36Sbi2eoM2PIUIRbZwfMejC4hN4t85DIc4lGtp8=;
        b=TqegCiS39TZCFqUxGKmbx6F6v4PhPEZGnLtS6H0oHlUCeQk1JyY9oyn5300n2hVb5s
         qPTbSn2hICCZkE8omIEiOwqpT5P4NO7JgM57hlwwSIcomq8gBywe/rl3U1PRz3VQfnAN
         smJjBSlhPgzOSKkAlDaP8vWGZ3v9mew7BACg6Bol4WMnTVJaUl6XQ7LWYWYCnlfVZMNF
         e1OfNbnRRK2W59OXjV9FO5V5yZvB2OHw66ny6bg/kq7mPVW3fnHXax3QQ0ka08tan9JH
         atqRU0N7mn3vQWAO1rKZjW9JEfnfdmr/EZ4M+iHOpV6zoUOWuWwClhvigbHgifO1Oobv
         y8SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785841705; x=1786446505;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kI4V36Sbi2eoM2PIUIRbZwfMejC4hN4t85DIc4lGtp8=;
        b=GKMlvNB170XlQHFdYwiLp2DZeM/KiHub3ykTgdLNokvAkOMY9E4A+AmuOy6Yz9JwY3
         URrby5WoGcVZkvH73dKof3IhOpDsBgyKCM35TSHQ1jZpxjAG/nAdkn+RWIlsMYO/t2ZW
         2OGeMk12x1SYCUKVlIBkkkZ9618PGIJ4pTcGW3gnfwdpCO1A1usus3wzq7wmhLCmzhVC
         /7k6Abuw9HTcTz7qNWBESJtUAnBxTchyp4N70OIVfflMyJkCpKpDaqOSQLX3Rwc66EFy
         UrotvNu5pPFjW2//KBLj7TnCdejgNwAWTITdzp8Y4Cgmi5oqDrp335EsL3e3B4jQgh17
         rPlA==
X-Forwarded-Encrypted: i=1; AHgh+RrP+HnPtkW/YGgCFtn0mtx7YTt6avyYhNW+RHBpEwlvTuIs4LtrRgvfN2YN3zap8HBj/v9+ortPMCd/@vger.kernel.org
X-Gm-Message-State: AOJu0Ywte6BrHDYm2jdGqT4NHhlLOo/troNvrT+kH2TO4MZqwX1f92wN
	dOkACYbRznofcHKI8tEfzylmUV2yCIS9dE63v27HUmB+Q1bzgpVD7hw2uXYgBQnmAFQ=
X-Gm-Gg: AR+sD10rH/f2tW2fnh7t4taO+LjM5u5/+fEeB1gV+pZ51FWOII8GIw6r1bQSXLIqG/2
	oi4C/tlarjc4J0FAO/2SeR2OCuM51is5wbz9nKfjEvHrwLZ+iJmYPGpN2Uupfoj8OHdLmWgRpOq
	m2t4XFMygh71lp9Uya0sR04XpMGFlZl90A2THwJ93wjN+yMy095Oee6SGGvUqjy021G0yyxxWUY
	2db+88YYgJtw3zWKbrn41J+k3TZgt1ahGFt+Wwrx8cXFC3NIoAodnirPaLMOX9o6BnREcTaFm4a
	ms37aw3d5kvgfbrYUOPwwNpjBHEczHpBaYdU1jM456WdkCaw5fe0tQonLQ1nkxqAGZco/6MUG0P
	4eYx9tb8cRgSl7nMDWNnWo0cpFvHohsjhE1XoL9drBUSu9HC/da6x5k4gel2C0/7GQbIWSn6cTp
	XKCH20R24DdIvjuLutN4F2wHRLaIeUXrN6/VSvcYCEle3k0+D+TS15kcFKCkehwlxv8r3NKZrrz
	HuwA13Feg==
X-Received: by 2002:a05:6512:2546:b0:5b2:a68d:2763 with SMTP id 2adb3069b0e04-5b2e4f1afecmr2052171e87.12.1785841704997;
        Tue, 04 Aug 2026 04:08:24 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23d23b5sm2518666e87.35.2026.08.04.04.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 04:08:24 -0700 (PDT)
Date: Tue, 4 Aug 2026 13:08:18 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Leon Romanovsky <leon@kernel.org>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, Long Li <longli@microsoft.com>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Message-ID: <anHFniO-9SrlUx0O@FV6GYCPJ69>
References: <20260731091041.2250897-1-jiri@resnulli.us>
 <DU8PR83MB0975547820CBB956D4EFFE57B4C82@DU8PR83MB0975.EURPRD83.prod.outlook.com>
 <anCBtLSxn8TtFcSz@FV6GYCPJ69>
 <20260803132844.GA326170@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803132844.GA326170@unreal>

Mon, Aug 03, 2026 at 03:28:44PM +0200, leon@kernel.org wrote:
>On Mon, Aug 03, 2026 at 01:59:07PM +0200, Jiri Pirko wrote:
>> Fri, Jul 31, 2026 at 02:54:31PM +0200, kotaranov@microsoft.com wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >> 
>> >> Commit eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata") renamed the
>> >> "flags" field of struct mana_ib_create_cq to "comp_mask", as
>> >> ib_copy_validate_udata_in_cm() only validates a member with that name.
>> >> 
>> >> The layout did not change, but the field has been a part of the UAPI since
>> >> commit 44b607ad4cdf ("RDMA/mana_ib: implement uapi for creation of rnic
>> >> cq"), so the rename breaks userspace referring to it, for example the mana
>> >> provider of rdma-core assigning cmd_drv->flags.
>> >> 
>> >> Convert the field to a union providing both names, so that
>> >> ib_copy_validate_udata_in_cm() still finds "comp_mask" and userspace keeps
>> >> "flags", without having to add a helper for this single case.
>> >> 
>> >
>> >Thanks for the patch, but my understanding that it is a common practice to rename the fields,
>> >and kernels headers should not accumulate historical names. 
>> 
>> That is not doable in UAPI.
>
>There are multiple levels of UAPI contracts. In RDMA, we guarantee
>binary compatibility because userspace (rdma-core) is effectively the
>second half of the RDMA driver stack. These drivers do not exist
>without rdma-core.
>
>As such, this is exactly how the RDMA UAPI is intended to work.

That is some odd UAPI...


>
>
>> Some userspace app, like rdma-core in this case, might use it and rename breaks the compilation. Some other
>> app you don't know about may use it.
>
>rdma-core does not use these headers directly. Instead, it vendors
>them in the kernel-headers directories specifically for this purpose.
>
>> 
>> 
>> >I also faced a similar problem from renames in other providers, when I needed a new kernel header in rdma-core.
>> >If this breaks your rdma-core in a PR, just remove the field rename in kernel update commit as that header update commit is not getting merged anyway from your PR.
>> >My understanding that maintainers of RDMA-core will merge the kernel header update, and will bring this change from my PR:
>> >https://github.com/linux-rdma/rdma-core/pull/1765/commits/0dcadd9316f1b98e21973e3a6e0f96186d49bd5a
>> 
>> this is not how UAPI can be changed :/ It simply can't be changed.
>
>It can, at least in RDMA and elsewhere in the kernel, where user
>access is provided through properly designed libraries.

Ehm, up to you. Very loose.


>
>Thanks
>
>> 
>> 
>> >
>> >- Konstantin
>> >
>> >> Fixes: eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata")
>> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> >> ---
>> >>  include/uapi/rdma/mana-abi.h | 5 ++++-
>> >>  1 file changed, 4 insertions(+), 1 deletion(-)
>> >> 
>> >> diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
>> >> index 410f0ddc8c89..431c7076f20a 100644
>> >> --- a/include/uapi/rdma/mana-abi.h
>> >> +++ b/include/uapi/rdma/mana-abi.h
>> >> @@ -25,7 +25,10 @@ enum mana_ib_create_cq_flags {
>> >> 
>> >>  struct mana_ib_create_cq {
>> >>  	__aligned_u64 buf_addr;
>> >> -	__u16	comp_mask;
>> >> +	union {
>> >> +		__u16	comp_mask;
>> >> +		__u16	flags; /* the original name of the field */
>> >> +	};
>> >>  	__u16	reserved0;
>> >>  	__u32	reserved1;
>> >>  };
>> >> --
>> >> 2.54.0
>> >
