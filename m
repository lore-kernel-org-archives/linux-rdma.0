Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6282F36AB4D
	for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2026 10:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782210391; cv=none; b=EV9/GbgqItlV6ZP4jYMUwQAUkJB/d3XMfXy4kyUJofRrSmyd1GSZR7C8TsOvqhJ/yNqBdQCDAjF0yv2sbU35YKLjcOjJWB4GI+aQXLZ13jji44y+UV5GmLmvbWk2KJDSiAdO0So4PTD2JatAVGjhRuhRRssn/DcieTQSU1q/RFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782210391; c=relaxed/simple;
	bh=ZicVcQULmEi1D3wqM/OXJGkYPS/6xwn94yQMDm/QxNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eh6e+E6H3ZeXaiWC2ccAVhxht9vXPaj3AkEakr8vlU34OrWCHn8IKvZDoP/LrZOcmfeyL36S2yCqrqvDuGe5ZpHrp8amYaVu4qVr5E8HDxfFVoG/R9sfzZIm5hoH5El/EkWG6ccHD5olRbdg4hTuPGIIPXslywaI2H5wrpzgxHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=uwJl2XYL; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="uwJl2XYL"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-492329c5514so3556525e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2026 03:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1782210385; x=1782815185; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=go9dLKmrBOvH8kf8+oUtKSoaHWifWeb8ejqPgpL2gPk=;
        b=uwJl2XYLCHPl/tlHmqnor3egwyxdiWX8HGA1wXQHsZ6Qx4OxcyqEolhDq2dHhZT7d2
         2egGQssVi1gKg3wOld/bd2JPrjZfF0rNcJlS3wRa+lTIyPZlKup6C+f79wZ7YeDbm4JK
         AOvA1EACZ0JHsx5p/Zydk6L6bOKwySsh21bUdiaYcJ6+fXhubvrfgUYgSQCsSBHYF/Ro
         mHIYc4ALgqD4KY+iiLQN3nAU5m4XQr5VEosKbqSz/doPvMzFGr0pxBofmn6VDDKGzAEp
         m4/qc8fsIqCww3dMlMRKCqMz4ybvJMK/mkbLZ4H9uP4YHGg7cRk/F8A5QGBe3pg4diTn
         yD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782210385; x=1782815185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=go9dLKmrBOvH8kf8+oUtKSoaHWifWeb8ejqPgpL2gPk=;
        b=Nquz9e3GPLgl1kMyq+j7ODfZ20hNqN4eQ2A3aZ3zW1Luq7LOUSs/OFPHzTaIhFkWBR
         G8Ft9yvwTkCQrF2eplBBZ0SEm7BrcLP1QYR+USUmxUcte7X2RWUdP+SyUM1jWTsFk7wk
         Fo+wNISEbsNFm56v0v86UXgh/67RRnPMG0gXA0oU2cjj0Wy1nx6b6J7DLMSTzfKrFOyc
         CzWNCLXDuOP220Jq+e9LukB6yAsTbgD48k8e/V81HNc36Cx6RxlJUhIUHT31yTn6d6zC
         l5xg1COm1KeAIZs1MU1SX+n18wAubdRjCS3E9awnu/d/30aIBOi4SMymQByNahzfLaYz
         hyMw==
X-Gm-Message-State: AOJu0YzEFHx8qn79F/rF+MqSmxNv/WipTW2JD5of4pJlED8exzgsDhw2
	+ErqY6W//L7RzLBkmkwNR03q5Wkd10XkoFdWjDxuVhlKctptfzKn20B9czGU7jdCl59l3y+q+Ck
	Zz/vA
X-Gm-Gg: AfdE7cmzk1It1CqDMImhLBHIeHC2Z+QriOqfxbbWwkX0kcrhVjnxYegAyoR8pWVQv5F
	W/vqJXEKxLLSuwM/GoK83z+oEeaP7i05Yz0U9vYwKWGlnHXpqcQxbyAL6grMr/xPLVhze9f1qeV
	sCQ+xqocapgreCwPtE/WGcRJswiNKfniQ0FWyShp9rgYW2AxzdcaF3FSke9RLa69LfclyJM629W
	cS9ZSI2u20HkZMWTrB2EQU3zniHmo4gguXC96cGNMiCgp2yUuh4HFWLpM4bT4wFbQLcPO9v9vfh
	IMMrdX7IPUa6oRtR7Wd52Jw1Y1k61cKxxq9GZD/KdbSQSNTI5H/VaQIuG9r980EGA0EwDti/lV/
	coqLSGUqyaFdHoymqJu0WTdId/s4ugf03dcvoKk5RDAQXbyGWMkQ8lpFOrabCT+mXezoULHz4vU
	wW+FtSCxTXuwNPkPfuMFpG9A==
X-Received: by 2002:a05:600c:620a:b0:490:bbc1:c9be with SMTP id 5b1f17b1804b1-4925a045e50mr40461215e9.0.1782210385412;
        Tue, 23 Jun 2026 03:26:25 -0700 (PDT)
Received: from localhost ([140.209.217.212])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923fd1fa34sm412848485e9.5.2026.06.23.03.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 03:26:24 -0700 (PDT)
Date: Tue, 23 Jun 2026 12:26:21 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, jgg@ziepe.ca, mrgolin@amazon.com
Subject: Re: [PATCH rdma-next v2 4/6] RDMA/uverbs: Add ioctl method for CQ
 resize
Message-ID: <ajpfNMfTpajyKWUx@FV6GYCPJ69>
References: <20260615085040.1396623-1-jiri@resnulli.us>
 <20260615085040.1396623-5-jiri@resnulli.us>
 <20260617110605.GV327369@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617110605.GV327369@unreal>

Wed, Jun 17, 2026 at 01:06:05PM +0200, leon@kernel.org wrote:
>On Mon, Jun 15, 2026 at 10:50:38AM +0200, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> Resize CQ is currently only reachable through the legacy write()
>> uverbs command (IB_USER_VERBS_CMD_RESIZE_CQ). Add an equivalent modern
>> ioctl method, UVERBS_METHOD_CQ_RESIZE, on the CQ object so the
>> operation is available through the ioctl interface and can carry
>> per-attribute extensions. The handler mirrors the legacy command: it
>> looks up the CQ, calls resize_user_cq() and returns the new cqe count.
>> The legacy write path is left in place for ABI compatibility.
>
>I have a general question. Do we actually need CQ resizing, given that it is
>rarely implemented and often incorrect in existing drivers? Maybe this is a
>good time to consider deprecating that path.

Good question, turned out we can actually drop this.
