Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873406;
	b=1PAp0xRen9vIHT4QT5izTa7Bi4a+DtUfcIqlUCLBxCuywHQ5FSd1SwS9zohI44FoZS2h
	 qdhyFNb+dYYCj0oJ7yuPaCTpfSvqb1QDq0XGOYrd9rJVbZZKZJ/wioIo2NWqD78vdTcLm
	 YamsZw0eaJnXVVoGD3oon5EgFopb5I6PDRVRIUE0Vj6U+hIk5wloKBMIOj7sH8QP65xzy
	 eF4EXZrxS5PCA3SCUJ9m4ACTDiSFLmuQAt/CwaCs+0oothXfHoxX2IQ2KvMHi5fZtMxbU
	 /ZhsngEPSasG8Y9e6kUm4uNKOzORxXuXJ4k5GKbwQS/KBvX2MmV0DHRZ7mFfEf9pKhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873406;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=ieB/BhshfTpFf/Emjsa3FOgNDbWqDdGD+LYI2ibqIWA=;
	b=Z3uWmMDv+tjucCkJBXffzPNgV6Du/+CmemP05t53iBvmMIclMNng3Nq8HF9MUyLljfO2
	 k11HL7TtcpuY/0dMluGKCLeQOsAsJg/2ouH+x2V8ivspZ51DhObenZOAU0nNWfXv2cM+z
	 NsgC7wLGgrrIP9bYQVwoKFGRC/0WNk45ReagDwHmdLn4Fn5xcDIHy8k/pFc5zQvMKrbzV
	 7cODaVBvC1MEYjNeAHVQHaUbwezMKuIvrC5F1RpQ4HRDGlWbgbYO0YfOzS1hH61Xz6oiD
	 6ruo6vTaXB4HUpM+XIcvQ/NXq3NEnpekIuGR+TfKtBhnKjkCRxam8ibFOpMoz4JS1KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NcbxE9rS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86BD606AA42;
	Thu,  5 Nov 2026 10:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NcbxE9rS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACEE1F000C1;
	Thu,  5 Nov 2026 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873405;
	bh=ieB/BhshfTpFf/Emjsa3FOgNDbWqDdGD+LYI2ibqIWA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=NcbxE9rSkL6ykptZDUXYUGaW5KjF8LKeYduRjN+GCvqtF8QXoDVHovtevVM8XWZgM
	 HobuRrw0NEFs5nymdF07IShXapQx0mcaN5XZ3C3Mby48RzUYyuQEIQVSm+0iUYit/W
	 IEHMUio9V43T+A+HHHmw7eOaGG5kba67nVZTbYra+d/Tj5Sqj9wEmfSdCD50Bu0r9p
	 0/T9tEjT7Rf6Kwk8fb3IMY+DAIJaMEZvvQcuQ9I4/qOtWykRhtmabbU5wrIsfZCGSf
	 Kufitg0YJjhGCgN7d6Vm81wORJZ+cZDrOzr5bLX42Ebt+9GkW8NFdGPJpqkGtohWUK
	 DvPEL8zMXH2qg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 400C0391AFAF;
	Thu,  5 Nov 2026 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/smc: don't spin in smc_rx_recvmsg() while a
 pipe holds spliced data
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179387340405.3565783.10479272570067778591.git-patchwork-notify@kernel.org>
Date: Thu, 05 Nov 2026 10:10:04 +0000
References: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
In-Reply-To: <20261029-b4-disp-da7f8e6a-v2-1-9052904adf72@proton.me>
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: dust.li@linux.alibaba.com, alibuda@linux.alibaba.com,
 mjambigi@linux.ibm.com, sidraya@linux.ibm.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@kernel.org,
 linux-s390@vger.kernel.org, guwen@linux.alibaba.com,
 linux-rdma@vger.kernel.org, tonylu@linux.alibaba.com, wenjia@linux.ibm.com,
 netdev@vger.kernel.org, raspl@linux.ibm.com, hidayath@linux.ibm.com,
 horms@kernel.org, ubraun@linux.ibm.com, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 29 Oct 2026 03:03:33 -0500 you wrote:
> From: Bryam Vargas <hexlabsecurity@proton.me>
> 
> While bytes spliced off the RMB are still in a pipe, recvmsg() waits
> for the pipe to release them before it copies the data behind them.
> The path to that wait skips the timeout and signal checks, and
> smc_rx_wait() returns at once on RCV_SHUTDOWN. With a signal pending,
> after SHUT_RD, or once the peer closes or shuts down writing,
> recvmsg() spins on a CPU until the pipe is drained, and SIGKILL cannot
> stop it. MSG_DONTWAIT and an expired SO_RCVTIMEO wait there too
> instead of returning -EAGAIN.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/smc: don't spin in smc_rx_recvmsg() while a pipe holds spliced data
    https://git.kernel.org/netdev/net/c/8288ba942cfd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


