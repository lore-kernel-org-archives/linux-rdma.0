Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752CE3DB63A
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 16:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791994913; cv=pass; b=B+bAbLB6r9SbdAaZFWWRbkHHZEiuIXlYq3NsCqaxHFWtd+0tNhfjxV0Le90Eg7uDrHj8ASp98nrvBWxnxJ8jNYLIAPh2XEm2Pdx8/il8fQsP5u09WouODLLIMvvUQ39qMWjao9svsjhO0bENYHcntZQZm+hSApBuGgojDcp4M98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791994913; c=relaxed/simple;
	bh=Uo4nhhn4ccYLf8haAnQH3w6H3MFou4kEMXYGeM07i8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OgVguhFPexuK0ZZivhA+xWYw835nNICJHZNkDbX+CnPXdkR/FoJVggVzbGpW6p6ag9UUyd9sSx0keJjbVGYN/KuZ5V+CYAj5fy4by5g8irK1bmkOEtrWsXOv0v84tJ2StxFTqLOG4LdGEh1Yo92uXh6K5wRRs2V4Eutkdy9l9CQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bwsZ4mnJ; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bwsZ4mnJ"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6cfed5dd083so837148eaf.1
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 09:21:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791994910; cv=none;
        d=google.com; s=arc-20260327;
        b=mSmQOd7GpxjgnuzV5s2EputgZexd/Mvkz0WoivCly9e8T92/Qqmojmp2VOLcoVccZN
         snNoPQG3W2J1WNct9Z3NC2/PXN144MX/hCBMke04RgnhGOK/Ld8N4pcTuCRRinN3gGtI
         /Kty29IcNkcSJCyS4E2Chjz1qUiaARU9t8GJvQZTP1FTGnA2nrKu67P2ItN2bNttBrv4
         oAUkhWMICnLAAHhfstueCoawBX0bz1UTJlKDPpLtU/Q1jXLtI02u1nekmJe2wjVX/wbc
         00a6QKOM2h7FW0ntHsocR63pUHBLNS/8Z/+n7QFxeVfJS/8jLPJMw0kNBpRnEPQhCsPY
         MTDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Uo4nhhn4ccYLf8haAnQH3w6H3MFou4kEMXYGeM07i8k=;
        fh=vIpiSaPgDQin/XV7hXXyUkkrjEUWW6lqsk+KTKnHGaw=;
        b=m+DhryvhTiFeD1mqRllfyTz3jYULX/Y3FcXBDT5svS02Z2C4dcn5rnUwcm3oo+eGHI
         YLO/YM2wtLSg50Wgxu9Dzl+t1opzgmIXh3vvrjVd3/ocubRCSvSZ4Mcom/mrGZkDZnv4
         ekq9DFX6qklFHsLx/L85zkkW5g+vmgLQNqgtlRMb1qaovUWFboLVO0jEwqRzeJC80km2
         x7kU4F4u5R6FDt2SPtqLSy3y17QwtuMse4Ksc9y91t+41uOu27yAFqzuQMDGWwYKqfiq
         QDuxuA604xraRE/KTuaYvO4CAstWmY0TY6qyGDjzdJST+2zOZnkLzNVrY+f1qJULdhYt
         J+8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791994910; x=1792599710; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uo4nhhn4ccYLf8haAnQH3w6H3MFou4kEMXYGeM07i8k=;
        b=bwsZ4mnJzyet4YO7wkRWTZPh9+c001f2dgbNOYir3RES4MT3prvAD3kXdjye6Q1Q/a
         nhqx6BykGbgDjwtst0yPo1HUTnNw0tTbToVh2VBBh21u7PwfJ8hmyYV6lMepigJm0c8Z
         k7tQGw3iDw2uJgnSoopA5wEH27ScEYC/hsVeaibwJ/a/t4SGqJIBT5Z95Fk8m07eLIKa
         qxl2npU7Vn+XaGKwlvUpN+Sh7cA4R8alXn0QK/P6Yeo5sE8S1xLpwfGbdk+RF046JayF
         nnboXdl19Bxr8kZXW+Y/E3hi0XqQRdIGnpbTg4ut5Eib9pB1VMxx8/JmlQDwvN3XW09Y
         vbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791994910; x=1792599710;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Uo4nhhn4ccYLf8haAnQH3w6H3MFou4kEMXYGeM07i8k=;
        b=s4bWRVsErZzsWNTyHtU6HphJ82NGcCZkPm8ov541c1cc/vp7Ib8F7oKuK0HJN2eTvM
         g+b2kBWzSAA+MZoSw8jZ8T+pAdKVld7uFVc9vjWLnmn2E6+fX6lqmOrtFgVP5LUpMFdi
         XBj4Q+abUr/w2xZTVmTn+Ewgv12wQGET3RXlTtpr+QlKVC+HWXtTnGVZB4V+4CDP9WFA
         j0KOCelbid6Fk2VQzyMxeR/AT/UZQPt5GVVSPBOecNjgnfracnrdNhgRBMaXE3gC0RsK
         e5aT7L9KAzTc2VP8KnIlc6AMAThLMU8ZW/PRAI8P4qhmDAZTCrxJnBbwsmyATh7l2eve
         oUOg==
X-Forwarded-Encrypted: i=1; AKwUvBy7D0eVfdS4KtIZDH73d+6db/TSP5O9BDYHo6g5FqS8qWili0AmFYFJUNc4+LKESokT1y/u2FP5eZNA@vger.kernel.org
X-Gm-Message-State: AFq9FYIhDqklQ8/JR8WqZMLcNLhbq0JOkNHypxYgPrK6MGO4aMjhNSGI
	AZDLpwV+YKNDocm4t6SH8hwpFvPrV8HVc4FeKaMqdx8stD22REYG8kRsNien8R8ZB12NYvKH7DB
	LO/4a0/CtcRY9BP81HFOvNq3F3awsAWaZry9UoxD0
X-Gm-Gg: AYBFou3MYBX68pD/v5yLLWZtezi1vOHhpjgbD6mifDelYQoMmppP7Yfra/fbEW2joVX
	5PEjPpapK7h1xXPpZtp54BVrhp8lfY5bmVSSpOxSFgtuyMkpiDl1FvsM/bADjRupIZxo/legiQj
	6djevj9K2JV/hapow1ij/KsAab1V5LH5Mm0UyfmqrM+92YSsg8vlJmxQFXLRPF3GI/8GkFDCi1e
	Mia242+UeoPDbF8TXlN3o1WbmhvSp61qj4usINwBi/uS88xMeOsD6zhUEHSBDUzHJYpg5JpXgH8
	wH72yp3vN12siHik6YHm0+lQ3jOO3bnErknnkQpSIdf0YCGZjvwxHmYimADjTgWbb62crs7dTlZ
	Gh5YIQnyaNw7SvM9zmVGZp3DF
X-Received: by 2002:a05:6820:4b89:b0:6b3:558f:706c with SMTP id
 006d021491bc7-6ef0eec88ddmr12134589eaf.30.1791994909586; Wed, 14 Oct 2026
 09:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261010194832.2415477-1-jmoroni@google.com> <20261012185010.GH14213@ziepe.ca>
 <20261013112211.GM219304@unreal> <CAHYDg1ReKsz_RNB_k3nc+qDu2vjGz+OQfNQhthNzW7TvGMLc6Q@mail.gmail.com>
 <20261013162947.GM14213@ziepe.ca>
In-Reply-To: <20261013162947.GM14213@ziepe.ca>
From: Jacob Moroni <jmoroni@google.com>
Date: Wed, 14 Oct 2026 12:21:37 -0400
X-Gm-Features: AclHuK_XQGy2ssR-E5Ll67lkYRxtAB-OgAINdziVXLimOhu3gN3l4_kKRDNbigw
Message-ID: <CAHYDg1R4ctNAXR8UB8cBEq=440syrSQS3gmsf9fqwzLqVs7c_A@mail.gmail.com>
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE alloc
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, tatyana.e.nikolova@intel.com, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Yep, it still uses the lower page offset bits from the incoming VA as the page
offset, similar to a PBLE-backed region, with bounds being properly checked
as [VA, VA+len).

I ran a test to confirm (nice to have in general) that start/end are accessible
while -1/+1 outside fail, regardless of whether the region itself is aligned or
not.

Thanks,
Jake
