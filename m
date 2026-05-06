Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE99F4534AE
	for <linux-rdma@vger.kernel.org>; Wed,  6 May 2026 14:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778077382; cv=none; b=H+dTtQMnZtm/s9zfsPKtjF0JnTRxGzDOoD8A0b4xtO6q95MNfBw+fmtPeX8DHXpD2ecZgOfewXgSMxv9MdyYdpPbXdsadPJ6hqypjJU/3W0IH+AwXunmBPKrfcGZN9cgS4MxlcVNoSRh7Mh2oDmVXt/+r6X5xy8L2cPbFPk9sdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778077382; c=relaxed/simple;
	bh=g+6jgEk2tcYGGoaZ3VCO+WHzuXURtDW9FyRgyhaoAIs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ESmCogDBi7U0nptsYJ+DIr3ec40ZJMo8tq0uibjTDhWdo+FwfqSwmorJSVh/0Gh0ellOKC38A9IzKSB1vVWU2NJXb6haQ1MRKHzBxX/vhhbNr01g0ou+4kkPofx+pzULAOjLD+bK2Ykg04VHpHfNFNBH8rFQHilYaN4w9bTRXq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=c5HFct//; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="c5HFct//"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48896199cbaso57241775e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 06 May 2026 07:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1778077379; x=1778682179; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vhlJj6xp2MlOMSQCD3zAiRcufvDlKjQOGfOkqB9+fEA=;
        b=c5HFct//0iSPH6OKyQPSyFtSh0jcbyi34ufKvqOjfi+ygrsADyzlSmN+W7hmVZg4lA
         Pb2hVdiYUE5/+OhUvSSP5XkxuCnw8n3+MNNVyRhSpoH8ADrlZLMxGdCeF2h3oDIZMp2v
         kF+QDQtZnt9rumNcnrnBeF15TR50H+yHBGlfRNrxUTzZ4SFwPLUsGxtLSTX9F1Xp1514
         58WQi8Fsl/K1MoqdV0hGf35hDcHWDRvGDYXx/42/T0wtdcYoV7rFxiVM7UAt5FCRwHuZ
         HRxAmqvfDGLzR/NfL2HlKel3I4M+jJ1JYtrV3Je5kL37d0AmQCXd+G4FLjpOJGCwt+tQ
         ghPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778077379; x=1778682179;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhlJj6xp2MlOMSQCD3zAiRcufvDlKjQOGfOkqB9+fEA=;
        b=lYwQtqC8KpfrfASquJPde1f+0v12sbxfLrpnbmzCwgm4DOycrP9XAqBsT+chZpAc56
         oGJloc7f0/oUlQ7F8xDVGkpyg1XcRT7IoFleSYMBCx5uujqHTyCYaJh2Ip0R/xWI+nT9
         V09dCwXc5l0Jy3QvTw32OqPOXp+5ADp9YKDtzUBi23KLlT9idzELAjTkQ/jqQWdd1bAG
         9Yy3kPbjBSB/MjQ793q2tt+lkiahtJ4yhFxfZoJkWaIrKl6JunySm5Con5iae+tjpiLB
         vnevF3ik1dBrdgKknnuEe273zTBC2QJEt2fpTh7NeGM4o0ZujoyKIwN2Nl4KPOJIBQX4
         FDgQ==
X-Gm-Message-State: AOJu0Yy7PdOTzMxrRo7focGpCApCTdQ5pBagUZ81biI55/H4xUe2VzJS
	LbOMh+YKC1qkM34CvhfXqdjUYSD4DpKoQWsFaqNqCwLoYI0nnO5AaF/IV0rPRlF/ENM=
X-Gm-Gg: AeBDievEp9tYbS1J7T00DIqwaN0nwAO46RKwaUfY/AVrMB1O3UivDNesgD155xSnyRr
	BogQJrPfTTZ758giN0qQE2fv8/VJhY3PtC5Ph2KjiQI3vTyrvqXfaBzmq3nwqBulMxo4nDStwT/
	xaDZemZu2zs5h/FrcymtFR+JrCrMkTJQX8l3UwsYwGhRwThdZqlFEL75CC6547Pq3EWkgAkN+Fg
	OC8ks9qS7OZMw0lhyY0IR4LZnnuQj/uglQX/TaKxCenodr+C76MLYuFR7J9xe42oDJeJ5iwHeXY
	Aw7sX9jkmCfQVUr+iKvfnYAUnTeqJosC0rzGdOTmutkXF/G8aUmpUkrdc564L0rqdv7g9lbSro1
	gpqnSQfNPh0GtTJRUAfxxMqKPyo9uYSvbHsMzGZCPM969PYoYNFOF9sgUe/UQMqqvvDE94MaoO1
	G+Ma4hbc6JV3Fad0tCwpgQH2CU+Oe8Mu8aPjauZ85/fqbFV9SlU8euPg==
X-Received: by 2002:a05:600c:3e05:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-48e51f2a997mr68797335e9.10.1778077379148;
        Wed, 06 May 2026 07:22:59 -0700 (PDT)
Received: from FV6GYCPJ69 ([2001:1ae9:6084:ab00:8c0b:afdd:3d9d:e976])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e53907e8asm50107515e9.13.2026.05.06.07.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 07:22:58 -0700 (PDT)
Date: Wed, 6 May 2026 16:22:57 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, leon@kernel.org, mrgolin@amazon.com, 
	gal.pressman@linux.dev, sleybo@amazon.com, parav@nvidia.com, mbloch@nvidia.com, 
	yanjun.zhu@linux.dev, marco.crivellari@suse.com, roman.gushchin@linux.dev, 
	phaddad@nvidia.com, lirongqing@baidu.com, ynachum@amazon.com, 
	huangjunxian6@hisilicon.com, kalesh-anakkur.purayil@broadcom.com, ohartoov@nvidia.com, 
	michaelgur@nvidia.com, shayd@nvidia.com, edwards@nvidia.com, 
	sriharsha.basavapatna@broadcom.com, andrew.gospodarek@broadcom.com, selvin.xavier@broadcom.com
Subject: Re: [PATCH rdma-next v3 17/17] RDMA/uverbs: Track attr consumption
 and warn on unused attrs
Message-ID: <aftNyC_XsZEMCD7G@FV6GYCPJ69>
References: <20260504135731.2345383-1-jiri@resnulli.us>
 <20260504135731.2345383-18-jiri@resnulli.us>
 <aftIh+qQ0bl++qxM@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aftIh+qQ0bl++qxM@ziepe.ca>

Wed, May 06, 2026 at 03:56:23PM +0200, jgg@ziepe.ca wrote:
>On Mon, May 04, 2026 at 03:57:31PM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Catch userspace passing attributes that nothing in the kernel
>> reads which would be a sign that the driver doesn't support
>> a feature, an attr was forgotten in a refactor, or userspace is buggy.
>> UHW and PTR_OUT attrs are exempt; destroy attrs are marked consumed by
>> the framework. Gate on CONFIG_DEBUG_KERNEL to avoid overhead on
>> production kernels.
>
>This is maybe interesting debugging for a version matched rdma-core
>
>But the idea the kernel ignores an attribute is part of the protocol,

I'm okay to drop this patch then.


>if the attribute is marked mandatory by userspace then the kernel will
>fail the system call.
>
>I don't remember how often this ends up being used, and I think it is
>a bit rare, but it is there.
>
>Jason
