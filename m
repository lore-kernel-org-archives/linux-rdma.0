Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E682A158535
	for <linux-rdma@vger.kernel.org>; Sun, 25 Jan 2026 14:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769349840; cv=none; b=XXrILOt/yRM5zmuHjQa/U48eOFNXGhdInNh2kdv1WfzinB0Hydck7KE3GZ5vk1raejQY1vdJ1yW9KL8xhNpa7ny5da/YURJYklUUvixsVxhOC+K/YePFe0F5VHr0epK79bHSqVPMXHa6QF29LyKkr/ewmHfAngT5bhwdfqF4tS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769349840; c=relaxed/simple;
	bh=HhhvwjRWNpijfI86OpwrQxhPTjvkxGEnenHIQTlRyec=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AWvqBWh124qlxbrnD0n34lnREDD8TbLL7nhAr17iYSM/gT1reih1xOZySKjauZrC0L+YJ3pxSMDQB63ZNMBDCTdr2TtGrPJmythHu97D4Kh+McabSWNKBIg0DQOtq72mqti9Vj1yll0b0DPjRlQoPh6wbCZ/mwnsFeARfVHwHs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nPa0Dzcj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nPa0Dzcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032D0C4CEF1;
	Sun, 25 Jan 2026 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769349839;
	bh=HhhvwjRWNpijfI86OpwrQxhPTjvkxGEnenHIQTlRyec=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=nPa0Dzcj/YB7gNjlQmIS4tuYCBA+Qwy0+ssr45QMUdcZs5NoTkmB9De1h4DOKSFJh
	 r82ikt7y6QGRH8G0UTe/J1Bjlqv/V5LEgojwe9TRLzx/Wv9WIkeYqiN/rrXllYQeOV
	 wU3rbyMQs9JvBuuH/VbbpZbsFUB7JYKAyXE/IHh6QLZvxfXb6LXIpvUdFXSStXcwHg
	 cik8o1azkbYp4Uuut8MC22R6YeyhlcguivYsfHf5MaS5ZB3vIk3AB3PfLnn1NoLRlA
	 cgkyoVqkho5MJpbUgrLa+U64/7+V/XhZqWZgcmfayp/HBGqUqfyNKFJzd0KF9yyNAB
	 pdxrOM4KIRcug==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, krzysztof.czurylo@intel.com, 
 Jacob Moroni <jmoroni@google.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org
In-Reply-To: <20260120212546.1893076-1-jmoroni@google.com>
References: <20260120212546.1893076-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Add enum defs for reserved
 CQs/QPs
Message-Id: <176934983614.889283.7386900738569848717.b4-ty@kernel.org>
Date: Sun, 25 Jan 2026 09:03:56 -0500
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-47773


On Tue, 20 Jan 2026 21:25:45 +0000, Jacob Moroni wrote:
> Added definitions for the special reserved CQs and QPs.
> 
> 

Applied, thanks!

[1/2] RDMA/irdma: Add enum defs for reserved CQs/QPs
      https://git.kernel.org/rdma/rdma/c/2b7c2ba1308a54
[2/2] RDMA/irdma: Use CQ ID for CEQE context
      https://git.kernel.org/rdma/rdma/c/2529aead516738

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

