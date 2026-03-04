Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124323A451F
	for <linux-rdma@vger.kernel.org>; Wed,  4 Mar 2026 10:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772620464; cv=none; b=SIhBRMi6idKJfltvhvekmYcTAb304CA+/3yHjrssUltMepFMB8pOG67GpCsfDBzuQmfR9cIYkfDcmBXIrwRQJHtT3nOmfTcFW2PihIwquPbPFmIIc3OfZur5Q+LcCM8rs+1wwuDotKZletQEJKsuuLi9eRDl6RhZw4GQvU9c9H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772620464; c=relaxed/simple;
	bh=rsnQDpKzEj4Z2yTxDa6CF8A7GwiuAZWpSeFHHfKXoIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5uPEjVTjzlZVKeTBFGwcAmxTDH5lkkm3s1OtTUCxQ91G0odSbp2zXkeR/ahbX+36zIMlnIa9xFSiSNbLRbovKVb6Xd6mtqhNWUZ0A7ejqRQf+w+6Opv1Jquiy3gyXoeL3IZwJjgniDH6DBy7VX+8oXRd3nEbp6AVKjTFYdGHy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=v2rTtyqr; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="v2rTtyqr"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4834826e5a0so76153595e9.2
        for <linux-rdma@vger.kernel.org>; Wed, 04 Mar 2026 02:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1772620459; x=1773225259; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=32nyzB5LhHXwJ+wC7E/bptZjPbk/YG6iOgM6+tf22gE=;
        b=v2rTtyqrqtUBZRZMayOIVCD6cb/dRadEr1ZBV+xfFXusUUFhTF3mrzfOOrD7c/opYZ
         YQgH0hqbWZKce4PpDbXZ8a8RwGDvrG2M64JofNhHGVUMfdTPYUYdK8tu2d2PoU2Ytkv6
         LxVxw/wOPG6Q68agLIzHmXKpat2iiGwS7W3V2vTdOhR5rF2g78dN4Bf0MSsOpZ4KidJ8
         EVzwdyijcHyYft4V3uwpiy3hlz85lFcUsc56iWsFje+KBd3d3vC56CT2Dn12nL00neu+
         /9KDjPoQY3dgsbyjB7uYkAnKpdBg1V7V46rOb7ItSsVB633YyHNx0zo4R6evplg3NNTC
         RQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772620459; x=1773225259;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32nyzB5LhHXwJ+wC7E/bptZjPbk/YG6iOgM6+tf22gE=;
        b=ZY3M6+nsjXj4taF/AYlkU/ipBViXru6+V40t3u+xZl7Ok2O2IljBK/N7HkiVSNtP/Z
         0Gb2Y5GNtyRj2pO+eVepIsCpYkdyl+uLSKVvnZmI2i546fbHbSNS6tg4pPBSmSKaJNtf
         SXWuSje0M2xW1lDaEvawEgtwZD7LW48zQ0C1aUTCrPV61/+z6m587pIJiChIrrtjyks9
         T4E9cvk7susTHwaJ6KcAvI33gPr5yMGnh5Pc+MrWE1P+QcPFp4BzFTSDM8KrqGorKxk7
         KggaGEXvTHeQkePYLCStL6QlD5DeVjN5Hajl9nyPwPlwLgwBKlrsUh/CxLWdl/D3fUaC
         StJA==
X-Forwarded-Encrypted: i=1; AJvYcCVL9++VMhA1tb7XGsQttrejFSFF9wSNv7rIxWqMNvllZQaq1vudyaSlmV4/2QZr3RrFBBCaSnSy0x6E@vger.kernel.org
X-Gm-Message-State: AOJu0YxwHpjPQORi0xqfaFx8MOnXUYTUEhlG77XGUyhJ1Uyx4vV2s4cE
	0sRMY4gEpybc9ywD2y7E32seiO5VA5rwRc1Xn13YK8sWe5pb17NfOnWiVHrGMBDRiQU=
X-Gm-Gg: ATEYQzzwtmSxugMIt6JI3FlJCSbJOdqcOhNdrk6USPaouRlWEZjSfVJkhX+7l3avYvQ
	onVQ4rDOIZrPnDfmu6oCDJWncDO3cbPVg/79be1+KuG6rbgggd0LJ5IIXHV88sXE4ZRLTlnpXf8
	E8gqU4r3/9wCBIxIIoEv5K0vMOH47k9bfkWso/ayDZAf8T7HH7GisLmqXuZiEuBcxFANDtG5FGo
	e6YEv8LjW6+8xJzx34a8d5S6szjD2a1NWws2z+Nirk2zF5wzHq34M7PocSdBLpW43nK8QH9s0Nk
	nsgzX/oUELAbIdNBp/tdGjK0KnZCcRGg0tbknLzhIt2ROJ1ftwyxPEch3skUhnZCCgW0xG/LBGH
	rfcGXWCnOpTp8Qg4jPjz/vlDI1IcQZWabOg/QCrTJGhv7eMjrmmBrcAxk4Qkw7lN+S5MgL4zN9P
	TUxrwwdnZofefwcQNIS461YbSxia6yXnWH8A==
X-Received: by 2002:a05:600c:1e2a:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-48519848388mr21825225e9.6.1772620459148;
        Wed, 04 Mar 2026 02:34:19 -0800 (PST)
Received: from FV6GYCPJ69 ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c75a25dsm41054094f8f.21.2026.03.04.02.34.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 02:34:18 -0800 (PST)
Date: Wed, 4 Mar 2026 11:34:13 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Saeed Mahameed <saeedm@nvidia.com>, 
	Leon Romanovsky <leon@kernel.org>, Mark Bloch <mbloch@nvidia.com>, Shuah Khan <shuah@kernel.org>, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org, Gal Pressman <gal@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Shay Drory <shayd@nvidia.com>, Jiri Pirko <jiri@nvidia.com>, 
	Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next V3 00/10] devlink: add per-port resource support
Message-ID: <jssifysprwuafkinc3dguspngxmplrngqxvotp76vhvu4e5lp6@e7mdrjqc5rme>
References: <20260226221916.1800227-1-tariqt@nvidia.com>
 <20260302192640.49af074f@kernel.org>
 <pmxkihhtsskkwsvdia4z2ss4wxpfc4a4kqxkjv5wk3mwdmpzii@6go7pizk2nst>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pmxkihhtsskkwsvdia4z2ss4wxpfc4a4kqxkjv5wk3mwdmpzii@6go7pizk2nst>

Wed, Mar 04, 2026 at 11:05:06AM +0100, jiri@resnulli.us wrote:
>Tue, Mar 03, 2026 at 04:26:40AM +0100, kuba@kernel.org wrote:
>>On Fri, 27 Feb 2026 00:19:06 +0200 Tariq Toukan wrote:
>>> With this series, users can query per-port resources:
>>> 
>>> $ devlink port resource show pci/0000:03:00.0/196608
>>> pci/0000:03:00.0/196608:
>>>   name max_SFs size 20 unit entry
>>> 
>>> $ devlink port resource show
>>> pci/0000:03:00.0/196608:
>>>   name max_SFs size 20 unit entry
>>> pci/0000:03:00.1/262144:
>>>   name max_SFs size 20 unit entry
>>
>>Code LGTM, I have a question about having a new cmd, tho.
>>
>>Does it matter to the user how the resource is scoped? 
>>Whether the resource is at the instance level or at the port level?
>>
>>I worry we are mechanically following the design of other commands.
>>Since the dump handler is new we could just dump resources with port-id
>>there. No existing user space may be using it. Alternatively we could
>>add a new attribute to select a bitmask of which scope user wants to
>>dump.
>
>You can specify what you want to dump with dump selectors. For example,
>if you are interensted only in port of specific devlink. That should be
>enough for most of the cases, no?
>
>>
>>I have a strong suspicion that the user will want to access all
>>resources of a device. `devlink resource show [$dev]` should dump 
>>all resources devlink knows about, including port ones.
>>
>>What's the reason for the new command?
>
>You are right, one cmd would do. Good thing someone forgot to implement
>dump for it :)

On a second thought, if we merge multiple objects into one dump, how
does this extend? I mean, the userspace has to check there are no extra
attributes, as they may be used as a handle to another new object
introduced in the future... Idk, it's a bit odd.
