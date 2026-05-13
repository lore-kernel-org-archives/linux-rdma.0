Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1602E39BFE3;
	Wed, 13 May 2026 03:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644001; cv=none; b=kcJ83+fz2sz43P13Vh2jIat2r6+iBh+aGrqnQW0vKuAWSk7ytxXc+BVLQSt83gXg1ms/AJ1sQwfYjcCcZo55vgKhzn7E0rezGoVP6kW2phA7v/JoxxY+zFR8uFW5s41MnAv4M2XJgwGTlH5E3m4MWqEllEePQZH0mSpJhRZ2xsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644001; c=relaxed/simple;
	bh=wx8jql1ToDwOs5ShWi330sByxn+12rrcPbCFPrQs+Ms=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qFUSTwc8WyxX/S/HhhiraCCbDs3ggEngB4ebEs9/7jgpkm9Qk6mjnaxc6uB6t1NTXQdAWNO7Rbw5f4xwmofOfFv5RhbnCnLkm6R+9YB+rogIfKj0oPQi/hgzaVYFhFGXgQUQirgEnKKtuq97cY+RZC8bchehUVdRjdtof2U5nZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o+GgzQUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o+GgzQUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC0E2C2BCC7;
	Wed, 13 May 2026 03:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778644001;
	bh=wx8jql1ToDwOs5ShWi330sByxn+12rrcPbCFPrQs+Ms=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=o+GgzQUPqxww6cRyn+lGLyXDkvjlniJPnsXpJpYyBDf3hI8oJLPT7c1YFUspotDRJ
	 9xIQR1hU3n9WaF70tcSm5FS1o0GFnB0cosQ38btjgF/4ea4tRfvusAKAXRGNP9TQOQ
	 rzgWlTGIw2PaUCtRAJiSqvYdjtLVRTORvK2WhYEV2EzqKO+Qc5RnMuzK/TBMpqnyA0
	 AdkfXQzBTth4HhK+bDH4MQRmrG8RDT6L+PPJ8W6pSXBOJYvzPTqBbi5kCTQ8T+KRj0
	 fptqmLIBvaApQPZM8N3EXDkmbXQxbmNPVDTc/ds7nayHxa9KIhNBXF9zp1QlRl7bQ7
	 LSXxIOg5H9mLQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id E8ECC3822D60;
	Wed, 13 May 2026 03:45:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/2] dpll: rework fractional frequency offset
 reporting
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177864394680.3173643.9892837998399060130.git-patchwork-notify@kernel.org>
Date: Wed, 13 May 2026 03:45:46 +0000
References: <20260511155816.99936-1-ivecera@redhat.com>
In-Reply-To: <20260511155816.99936-1-ivecera@redhat.com>
To: Ivan Vecera <ivecera@redhat.com>
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch,
 arkadiusz.kubalewski@intel.com, davem@davemloft.net, donald.hunter@gmail.com,
 edumazet@google.com, kuba@kernel.org, jiri@resnulli.us, corbet@lwn.net,
 leon@kernel.org, mbloch@nvidia.com, mschmidt@redhat.com, pabeni@redhat.com,
 pvaanane@redhat.com, poros@redhat.com, Prathosh.Satish@microchip.com,
 saeedm@nvidia.com, skhan@linuxfoundation.org, horms@kernel.org,
 tariqt@nvidia.com, vadim.fedorenko@linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 May 2026 17:58:14 +0200 you wrote:
> Rework how the fractional frequency offset (FFO) is reported in
> the DPLL subsystem.
> 
> Both fractional-frequency-offset (PPM) and
> fractional-frequency-offset-ppt (PPT) attributes are now present at
> the top level of a pin and inside each pin-parent-device nest. They
> carry the same measurement at different precisions.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/2] dpll: add fractional frequency offset to pin-parent-device
    https://git.kernel.org/netdev/net-next/c/9c11fcb2e9a5
  - [net-next,v4,2/2] dpll: zl3073x: report FFO as DPLL vs input reference offset
    https://git.kernel.org/netdev/net-next/c/54e65df8cf18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


