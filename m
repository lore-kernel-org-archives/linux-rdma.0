Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795351322;
	b=ncsU7PPY3v9wE+WHXLbn9iw8JFh/tzlY68wBlJQ9SP66s/DYStttWy4FluCxVAeghXr2
	 3NgDear7C1N9YGXawKP1j5wpvrCWMJCryr0fgi8RRkK2nDRmL8TdsSudadbPYUq8RFYg/
	 Y+LQARs0PaVkpQ664dYJewyv1NcTq4bgrhaalIS5qqNIFVqKXA4yVFlwDQtT+k7yuiBnm
	 OfyD/FGqC0FNvLAtwSCA+gkYxq4jjvKPXWoVP3o+Tl31XcJjckABtV5RKNMPkdY3ZGmZJ
	 kMVU/PzoA/7ulkynPfTbH2EpajDeU2YYvcb5MfYmkJQ0rRgRWwgsy6CjEUYQszfFmew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795351322;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jjpAuMyGBhhxXmZKruArTKrFkOhOCL8b3s5wdD5wOnI=;
	b=IzVG7/OGE8y87Xy61Rc8G5fPkD8dWs9khN9r2XebQ3iLsDp2w1pafEIyFhAzECWyEQn6
	 e2curR7IlZZVVk4qc/9wTlTr2nhXP7CnPazG3bfX+BrpZCEgSRYFRqcJQBil9D9L18VRv
	 3KBrkfTs9jguAncKfqnluvt5me4mWcQdsvT9hAdI8Og2xQJILyaD/pXGONuxa8ScYTWNU
	 8qyS9XVYM6hId3WX98C3cqKv+VdpXWXEn3mewGQqG4FZh6tNdrOoGZZkR6NkIsk6prRWF
	 2/GgA11qaxa2dM4nmHxokvYSXYesFGHNsJGJwBzWBmVvQeRlUFldteyRBqYOb4mqBXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kzCiZYTb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BE606A320
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 12:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kzCiZYTb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749A81F000C0;
	Sun, 22 Nov 2026 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795351322;
	bh=jjpAuMyGBhhxXmZKruArTKrFkOhOCL8b3s5wdD5wOnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kzCiZYTbPNOyhsTJQwalpusSCImFOkxLtLO73C3kL2wJF6TaPeHH3gltgkEp296x8
	 272KbvqLn3/LfkbzEt2kxvIMpYtJgwzE4ESTpRFeiHoG6kuuYrngKgBXtqQl61j0cF
	 feB78lbXGMPNwam1YHcIiTJ1bcEaj3OZgaBNRuMhYH1RgM5R+QHdP6u2NYwAf/Iezz
	 cr5xmys/waPTuQI3QMkLMU2isJXoGyY2QMiVngIjvCQAMCQ0VV9BNGUf5LQQSaKJka
	 BliqYCcfh/a/cUhXzfgU7LGrQ3B/hjMnfo6QlNcrLUyMJxMBckrvUlAbmJ13Cx1Wf4
	 0gVTDRTejTqQA==
Date: Sun, 22 Nov 2026 14:41:58 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Abdifatah Suruur <suruurism@gmail.com>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 2/2] IB/hfi1: reject writable SUBCTXT_EGRBUF mmap
Message-ID: <20261122124158.GD14811@unreal>
References: <20261118131948.28748-1-suruurism@gmail.com>
 <20261118131948.28748-2-suruurism@gmail.com>
 <179500901107.1415.1266627283580496093@gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179500901107.1415.1266627283580496093@gmail.com>

On Wed, Nov 18, 2026 at 04:36:51PM +0300, Abdifatah Suruur wrote:
> Hello,
> 
> Please drop patch 2/2 of this series ("IB/hfi1: reject writable SUBCTXT_EGRBUF mmap").
> The automated review pointed out that uctxt->subctxt_rcvegrbuf is a
> vmalloc_user() buffer that userspace subcontexts sharing a hardware
> context intentionally map PROT_READ|PROT_WRITE: the process polling the
> hardware receive queue forwards eager packets into it. Rejecting VM_WRITE
> would break subcontext initialization, and the existing VM_MAYWRITE clear
> is deliberate policy. My patch was wrong; I am withdrawing it.
> 
> Patch 1/2 (STATUS VM_MAYWRITE) is unaffected and stands on its own.

ok, applied it.

Thanks

> 
> Sorry for the noise,
> Abdifatah Suruur
> suruurism@gmail.com
> 
