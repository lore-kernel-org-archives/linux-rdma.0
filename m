Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD2E451985;
	Wed, 23 Sep 2026 07:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790149100; cv=none; b=uG8JucABitBTsxTgcDGdHYvGpezzcbH+fiGHzB643zxB74f52MQtoqCysFASP8DE3u9Odz1pW5WkugY0+FITE4XwOAfVLCXdjbGWMzgqJ7HEOBbFbngY8H/g8rJ34uzpOFeRv1ugqvDd8cPt0/mPiKq0cYWplFblrtgt2GQw9sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790149100; c=relaxed/simple;
	bh=ubFKvsJzdIQbjfCj3q5g5fiqfTLyhaEU+cYUmdFV6uI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=O4tK/rTO0MEka+gFLxbSmF1WVkeAx/XoYegyop3v+K31oIUt9CAv47STbIBhysccWZZOlBe8eC4N2/IYqWtjmQ93wN4GPs85VGBmNP7foV/pPe3gYS8bVMB56QeP5u10UNWEIOqvfPaUFKYiV+IZxS8qrlKaoUNmy00aVDzDO7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GDYYA/df; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GDYYA/df"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BED1F000FF;
	Wed, 23 Sep 2026 07:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790149098;
	bh=kP4M/oE1S0ICpQzbu6Ej984kBkHIQei+7qBk52CKPTg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GDYYA/dfaxvF+9nW8WHNzEVFU/ery2uM21UtsSk8DLMavpv5CIsJEJESiQFhMe2Cp
	 Muw5GYSkUcDL/947V+zh+9753n08f5gz/EgzfI2552Ww9CCC2Ljnrb+2n1Ea2sfIN7
	 mS6N14DZJuLsc+aB9cufg2L60fVXa8omp351YVpMgp3fl1a0P6R5ExNNfvg9jOxTlX
	 d9XR/B5eppQauSwngUsvVXoZZR0xYbdBISmRuVIgq7Q5cM10T88LSnEYy9OpESlSr+
	 b5QwLvlEWojFsC4cE5h7OVf6iBFH93zccvv6ey6uBsIYln80XgKCmNtqL43FTNWFJ9
	 CrcMo4Lc9LtJw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Slavin Liu <bolin.liu@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260911060909.94219-1-bolin.liu@seu.edu.cn>
References: <20260911060909.94219-1-bolin.liu@seu.edu.cn>
Subject: Re: [PATCH RFC] RDMA/irdma: check vport device allocation
Message-Id: <179014909566.3387894.8889638283182921509.b4-ty@kernel.org>
Date: Wed, 23 Sep 2026 03:38:15 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 11 Sep 2026 14:09:09 +0800, Slavin Liu wrote:
> An existing RDMA function does not guarantee allocation of the new
> vport device. Return -ENOMEM before initializing a NULL iwdev.
> 
> Detected by static analysis and reviewed with AI-assisted source auditing.

Applied, thanks!

[1/1] RDMA/irdma: check vport device allocation
      https://git.kernel.org/rdma/rdma/c/2a770e6a64d66f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

