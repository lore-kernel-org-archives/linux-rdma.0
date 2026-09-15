Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C17C44E648
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 07:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789457847; cv=none; b=IX5cdEpMJbnERCwsaZ1lCdaBFwhiIaSEEN/FD5TZvWz0nut+n36Unei0WmK5QpF7cQV0CGeKy1ImHBZiRBtfB9NHKPDmRfVRYzU6By7f2SwTK64cRMS/Zx6UBOmPUzo9a/Lgkn51W8DVmveqPomnZub5zxAHo4vkxX7KsO8bf/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789457847; c=relaxed/simple;
	bh=YFFylM8DLcnPHJAll0Q25nIKRHt81LfxDkNfTs0GO0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r6hVlrijdSwcEwmsCngTlFkqsGP7rhBMVA+gXN/sW8+VYv1XOCS0szVW2IkxXsdPZcPoARPJL1jN8Mnt6QV8o2NWv2KE1IbJhemTkYZXJqi6wFbrm+dQ71ZhAYX9mXvQkVkGOSYGWp7lTuwe0MOJWs3GO+O5HbeMi4D6Y6PNnBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4aFpghb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4aFpghb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22C91F000FF;
	Tue, 15 Sep 2026 07:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789457846;
	bh=YFFylM8DLcnPHJAll0Q25nIKRHt81LfxDkNfTs0GO0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L4aFpghbvApNWEzj4pjbgOdTT1inP83J2A7gahzIZh/i7Vpqy01otMmLhjgEcToxa
	 tZiMNjjTgMgAarTdX3+iOZOKUUviemhOpMEsvKmxqy6AyvZzxPGaPDa9k2gefIbgJH
	 RljZg6HeweXYtAIeElGTd/ylI/xzL6TGqxHh8E8hwFKAeMs9wcRdeJrkI9a5uc2Vqn
	 kZnHuxh1XPCG1H/VkbzGzYAUOTF230DUWzL3PX6ISb9nVi59RbSpcsdwJqygy5uvzC
	 HRGrI4+WrEQdfGQ6rSvLMZkLdDdH809OPhWA1mbUin2QQnsp4925PjRy8b/si9Cs8A
	 QhDyZ64CrxI7g==
Date: Tue, 15 Sep 2026 10:37:22 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: jgg@ziepe.ca, linux-rdma@vger.kernel.org, selvin.xavier@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com, chengyou@linux.alibaba.com,
	kaishen@linux.alibaba.com, tangchengchang@huawei.com,
	huangjunxian6@hisilicon.com, abhijit.gangurde@amd.com,
	allen.hubbe@amd.com, longli@microsoft.com, kotaranov@microsoft.com,
	mkalderon@marvell.com, bryan-bt.tan@broadcom.com,
	vishnu.dasa@broadcom.com, maorg@nvidia.com
Subject: Re: [PATCH rdma-next 00/15] DMA direction and mlx5 driver
 correctness fixes
Message-ID: <20260915073722.GF13683@unreal>
References: <20260908152851.1307294-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908152851.1307294-1-yishaih@nvidia.com>

On Tue, Sep 08, 2026 at 06:28:36PM +0300, Yishai Hadas wrote:
> This series contains two independent groups of fixes for the RDMA
> subsystem.

Please reread the AI-generated commit messages and comments, clean them up,
and resubmit the series.

Thanks
