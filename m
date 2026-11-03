Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793700524;
	b=nTjsvRM7KJh7qCHYQ9XZ025XxWvG021INqKfdc4Yqdsp911Ap1Cb5L9ClJhnvLEjx0Ob
	 zeS7ucDi6S/7H0KyjKSMeG3yXyIblCD0izVN7xRsbBOrB7o8mcQNuvey1HFWjxM5zVlhv
	 0oDUR2XUslCx2gnLV+fIso0hZH9B9iHuq0a1JkcGWvhe2ulK1gLKDIMfmfVSgb10aEb/6
	 BqJxOnh+kiufb6sjWMz6aTrz/JvOieU0uCEdXXtvjF8OA+ldYiVBKJ22rXxU8oHANM+0V
	 8RJ/NugIk7zSVxdK2W9Xs0GY1oaIcjlmalw9jlBHaYgDUlmwXrRD22oq5lxC48KCSxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700524;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=swdTypR9uUvAnD2bDnj7k3fz81yQtU6FPJ1wUHvFkwI=;
	b=Aahujy/Xa8r+bfgaEwfN+iz18gUrYpc0DoMFaI0zd1WfZX0bMMdLj81JbU8CKfxkEWYQ
	 ZhQytRWNN//ZNmnZFxgZyY765ZgNdE05qcWHGZyeA1LfZnvv04Es/yvU6C0n5zlkSVSJh
	 Fe2p2zZg8JyvnEVoGnqUWTAA97zNAvLRR2BPB9Iwkz83mdi/7W4uq5UY6QHwAqUdDV8cc
	 Z805Z2l1Id+1NmHxkTMAjNTO1uRl7mc5SounjdbCqchgbkue9mSKc7lqzwm9Bj2XBWGh7
	 9ld8mrLvZJh72CYrILwtoCu4v+35uJ62AFyuf46FZ/nejwJ4UhH4NI75OQ0b6H9+fmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=osGSGPlv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6B0606A817;
	Tue,  3 Nov 2026 10:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=osGSGPlv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4AF1F000C1;
	Tue,  3 Nov 2026 10:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793700523;
	bh=swdTypR9uUvAnD2bDnj7k3fz81yQtU6FPJ1wUHvFkwI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=osGSGPlvNq1u3P3HRQCuQxVQKk7aBFb2Zu86APBhfj9PFRB+EIoC5cYrDls1aY5NI
	 iBZMWBUNFp0IbJH4XK58xD/pCM/4Ijpgiiw6zEsr6eoaooFyHvhjfM4PDY2vimLxRL
	 AVURGVxOpQpqFbqLW3/NCWE/CN8DLEHp3ZxiDkWqBVH3oMBEWf1QZtU44pCNHyBEK4
	 xaYJ51H/346ii7rjw+QS5z4NUOp8ZBX4bWKMtjA5PGk0Yvac3examoxAhT7kSUjI65
	 73UeQDkJGqg5kzFQOnu0xqyXIKt1jmDIlFJonkCwqGtRh35zAjAq8umEQKiXzthg0x
	 XOTzVBHsJxTiA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: allen.hubbe@amd.com, a.k@amd.com, nikhil.agarwal@amd.com, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
References: <20261027092353.1961552-1-abhijit.gangurde@amd.com>
Subject: Re: [for-next 1/3] RDMA/ionic: size the MR PTE reservation to
 max_sg
Message-Id: <179370052089.1715411.8295798950749355699.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 05:08:40 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 27 Oct 2026 14:53:51 +0530, Abhijit Gangurde wrote:
> CREATE_MR with map_count zero makes firmware reserve its default number
> of PTEs. A fast-registration memory region (MR) whose max_sg is larger
> than that default fails at REG_MR.
> 
> Pass max_sg as map_count. The virtual address (VA) and length stay zero
> because no buffer is mapped yet.
> 
> [...]

Applied, thanks!

[1/3] RDMA/ionic: size the MR PTE reservation to max_sg
      https://git.kernel.org/rdma/rdma/c/bfef8b13241cdb
[2/3] RDMA/ionic: set the SQ WQE color bit
      https://git.kernel.org/rdma/rdma/c/d1b8977f3a009e
[3/3] RDMA/ionic: key recv completions by producer index
      https://git.kernel.org/rdma/rdma/c/9ca2239d2fd274

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

