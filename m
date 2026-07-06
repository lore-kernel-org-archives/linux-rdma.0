Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9653B5821;
	Mon,  6 Jul 2026 08:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783327852; cv=none; b=Qkj0ix/uWBJgSRIB+8HShea1G6WKUYy9n2a5P5jbqmJTEEjVZ6HPvB2RFs9yxwGbWQqsfWTesZzAxRbE12G+Th61IAqOMM6by6Y6YmhZQZc13jZaPRE6i586vUbauERlzldJRoB1iWHeVdXlL+GxT0r91c9k56o+WiShToG5LOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783327852; c=relaxed/simple;
	bh=hWup9gA8sPCnA13J+yJWxxyTMbU7sGR6m6gwxBveUGw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XnHU3CCeH8av2bE6qWJvkl0g0oWV+y4QbNezPipKtYpH6OfSYNdeaH5TNWcSXmXsXDFVmGyE9UMGpPRBCIB3CNWUHQbcoqPLKK09ZVkLf01rM5+402lcsQxKUWahaIy9TKhIf+uRgx7bEGzUa3v0hY+neor1Q4peKIBU6PIBgMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kCHIlE31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kCHIlE31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9631F00A3D;
	Mon,  6 Jul 2026 08:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327844;
	bh=jTUIm1tORoIMmZWrTVmwM1YfxLd0AKVtQztkrJeClIs=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=kCHIlE31rQ5XPVK1Vs45QGGqF29OASswjBCwppeKtAa3dvuRGJ1puilirl6htP9FU
	 T6U6XnAdYxfCNM6b3LFYVb9eLKvJeWeWHysHKwss31LdomfrI6uMA0h5swFy8i62g8
	 7boMf4SUwz/XDvX2H0wVDJgIRwbHs4SXkm16OhfYPEu8vq+mlTfg4jMNoaAMo9EQ1i
	 KjfiHKgMLi+lGZTTuLdFpCGSRv7Eug5g4+7uUTEjcwemktE9GDnVOvw39mDM3IpBIL
	 94Ba+wjnfwe5TVu4Y+0arwmL9/REdup0zD7SEwkdLoSJ6W59D3FCWAA6tSITh4ySPI
	 ZFFLPZLZbxkkg==
From: Leon Romanovsky <leon@kernel.org>
To: Siva Reddy Kallam <siva.kallam@broadcom.com>, 
 Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260625003614.27515-1-pengpeng@iscas.ac.cn>
References: <20260625003614.27515-1-pengpeng@iscas.ac.cn>
Subject: Re: [PATCH] RDMA/bng_re: return a timeout when firmware responses
 stall
Message-Id: <178332784169.1040247.15205002231588689405.b4-ty@kernel.org>
Date: Mon, 06 Jul 2026 04:50:41 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 25 Jun 2026 08:36:14 +0800, Pengpeng Hou wrote:
> __wait_for_resp() documents that it returns a non-zero error when a
> firmware command does not complete, and bng_re_rcfw_send_message() already
> marks the firmware as stalled when the helper returns -ENODEV.
> 
> However, the helper ignores wait_event_timeout() expiry.  If the response
> slot remains in use after the timeout and after the polled CREQ service
> attempt, the loop starts another full timeout period and can repeat
> forever.
> 
> [...]

Applied, thanks!

[1/1] RDMA/bng_re: return a timeout when firmware responses stall
      https://git.kernel.org/rdma/rdma/c/5f9576c6734abc

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

