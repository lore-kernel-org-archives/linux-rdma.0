Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682616;
	b=vjpZAXwL7YJIJHq/XdLa8Oss04Dufu7s8YqFDHGjA7Nf+h1eFnxgzpdrT7JHnHmxWf6Y
	 9pMMVbjTWR04Rry/ISvxxZfuVhLYOJjar7IXvzHrCADj+QkhmHMEA0xQJKYWve2N6cckA
	 tTs9Ay6cMIridNSvUKRxPJOwB9AvkeZVpB+4ZzdhC1OnOEdhBMWivgdHBnVmk6i9RZGT5
	 VT/bSz9F7Okxsf4d+3SAHMJfwxmNV115SLqCuxPuuSwxBw/uxfybmIdvzc75KWtfuKG7w
	 3IgNsF3LH5sjI+HLxVZBgPr2A9wsBvKL3gGRFV5JN2jNzMl0zlgyxvRF0rkmqfYu3Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682616;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=wnTK++/ENxzpo2Dbi6+G/l7vS1tqf/r5+A17f9Auz+w=;
	b=Uey7bgko0Xwip3ANXq+h579YQHTM0IzAtq3ypx7pPjY7frS1kF9j2nVvMkam61dX2mZc
	 S1a1yywhWj+IcMOqJuFSCLZJRrkjEHCY0xTB1B/V/zqW9L8vknnTmmyQZgnV3qdtRPxEA
	 nUZZazAr5+5ZNNonQH6nTYFQ3p0XTE/+6C9S2SwGq9SX+umx7pGINWUrU5grr1WIAmMLF
	 KOLl/PdL1h5pLVW8Wh/RK39KEK6m+cacAJHFFdECk/im91oQ1t8XC7/8NudYm+uot25IJ
	 VEFa7M3DV26AHwqVwEczoDgDY7kyqJGzxfe3Dc4tCLghMxbt+RUdi57RpVAIl4LRZ4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDzx8jBF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56BB606CC42;
	Thu, 22 Oct 2026 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDzx8jBF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769741F01825;
	Thu, 22 Oct 2026 15:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682615;
	bh=wnTK++/ENxzpo2Dbi6+G/l7vS1tqf/r5+A17f9Auz+w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iDzx8jBFslRlBoVI48B7EZHUF5BZw3o6M9tGEuY11kBqGn4zR2C/W4IHWRFsiI/k+
	 YAXBs5l78yGdfuAlQBCuTktQsY0PCsJ+sllCcg3Tk/PU6OsEUNEqgsGE0F2q2RUm8t
	 MFDZmCN7CiskUEOM13LGtId+1qcMCI0X5Zk4zWIlsXnSaMWPLp3aSOG+iSv94qSzBs
	 xllFGelcvhivzEl8UQFala5ZKSPsUo+M7mnYiRj3ZF3x2TntBF0/4mFrRUQCdvN314
	 gTKwbjPUpVupCFyCUnepEmySy1YCgoORVOCcz8IegRULL2STiTn6E+NBhpmGxADpB/
	 qXZvtvpjKjRWg==
Date: Thu, 22 Oct 2026 08:23:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, davem@davemloft.net,
 pabeni@redhat.com, edumazet@google.com, andrew+netdev@lunn.ch,
 jgg@ziepe.ca, leon@kernel.org, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, shradhagupta@linux.microsoft.com, horms@kernel.org,
 ernis@linux.microsoft.com, stephen@networkplumber.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 gargaditya@linux.microsoft.com, kees+treewide@kernel.org, kees@kernel.org,
 mawasthi@linux.microsoft.com, weh@microsoft.com, edumazet@kernel.org
Subject: Re: [PATCH net-next v9 0/4] net: mana: concurrent HWC requests and
 dynamic queue depth
Message-ID: <20261022082333.5a259426@kernel.org>
In-Reply-To: <cover.1792679388.git.weh@linux.microsoft.com>
References: <cover.1792679388.git.weh@linux.microsoft.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Oct 2026 15:02:58 +0000 Wei Hu wrote:
> This four-patch series adds concurrent HWC request ownership and
> PF-directed HWC queue depth to MANA. It starts with depth-one bootstrap
> queues and keeps setup private until the final channel is tested.

## Form letter - net-next-closed

The merge window for Linux v7.4 has begun, and the net-next
tree is now closed for new drivers, features, code refactoring
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens. There is some uncertainty
about how long this merge window will last, so please check
https://netdev.bots.linux.dev/net-next.html
before reposting. net-next _may_ reopen on Nov 2nd.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer
pv-bot: closed

