Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785D312F585;
	Sat,  4 Apr 2026 09:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775293521; cv=none; b=RYVLa/GsemIGO7C+Qk0bNzep36XQN4p+dnDj+TOrsXGNqWSBUH6/7kyo/XtopVX9ahWXTbG8PCGY0jt6cy6gzE3w1uz12yMcPe8Xzo7yirZj/b+Xp5ABIaxSINsUoJWK6WCeuNQF6eBIuw31k8KF4mfwn1d/AKpzAceHJhWnkUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775293521; c=relaxed/simple;
	bh=WlDUtAdWRRYiTxm8sPedGnTX7RhDMo4Jida7KNdx5IA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hggSkic/y1xtNyTxZW7S7R/mTUyUbNium01imTjl4IPJF03qMJkKGsFVa0o3Oc/jRxMHk22XVpOy2oWbK6M41FBGDo5aoxd3Vg//wsIdey97ejGTV36B8iKBKAFhw2GDhUmbIkwjghcKO0mMwnfOp/nAXy9bos/x6c4H1DavHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jI9QLaT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jI9QLaT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD43C19421;
	Sat,  4 Apr 2026 09:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775293521;
	bh=WlDUtAdWRRYiTxm8sPedGnTX7RhDMo4Jida7KNdx5IA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jI9QLaT99JJ5lCe6ONRoU/UNpuVh+sgGg7KhLaaqFWiJOcSsRstoGjQNoImgaiUv0
	 KNyR5FiLDyCju3c8kgpz8mUeBYrz5+VxLMUSTSbIai5Qz6GYjfiIfAPXWtt7nzLYTb
	 Xzfyi25ZMTMbk249CYubIcl0XF8k6GDE0Y0fa9T4sxHw0Dkm3+EBIWw5u/zFlv8FyC
	 tL3fMnoHDt0N2ypJ5TadXa1eB0ElsN34X0vvrcZtFTZw/i9pdxJ3NSSGa8SwI4oH3W
	 WpOEBsDU7dwtF0c6f9y8ny8FVV8HlYEhC/1Q+u2vzIp4QVusgaoiZFTLGRFTynk2Vr
	 VsrLhDLT7zDfg==
Date: Sat, 4 Apr 2026 10:05:14 +0100
From: Simon Horman <horms@kernel.org>
To: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, kotaranov@microsoft.com,
	shradhagupta@linux.microsoft.com, shirazsaleem@microsoft.com,
	yury.norov@gmail.com, kees@kernel.org, ssengar@linux.microsoft.com,
	dipayanroy@linux.microsoft.com, gargaditya@linux.microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v5 1/3] net: mana: Use pci_name() for debugfs
 directory naming
Message-ID: <20260404090514.GS113102@horms.kernel.org>
References: <20260402182704.2474739-1-ernis@linux.microsoft.com>
 <20260402182704.2474739-2-ernis@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402182704.2474739-2-ernis@linux.microsoft.com>

On Thu, Apr 02, 2026 at 11:26:55AM -0700, Erni Sri Satya Vennela wrote:
> Use pci_name(pdev) for the per-device debugfs directory instead of
> hardcoded "0" for PFs and pci_slot_name(pdev->slot) for VFs. The
> previous approach had two issues:
> 
> 1. pci_slot_name() dereferences pdev->slot, which can be NULL for VFs
>    in environments like generic VFIO passthrough or nested KVM,
>    causing a NULL pointer dereference.
> 
> 2. Multiple PFs would all use "0", and VFs across different PCI
>    domains or buses could share the same slot name, leading to
>    -EEXIST errors from debugfs_create_dir().
> 
> pci_name(pdev) returns the unique BDF address, is always valid, and
> is unique across the system.
> 
> Fixes: 6607c17c6c5e ("net: mana: Enable debugfs files for MANA device")
> Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

Hi Erni,

Possibly the code differs between net and net-next.
But if this is fixing a bug in code present in net - as per the cited
commit - then I think it should be a patch that targets net.
With some strategy for merging that change into net-next
if conflicts are expected.
