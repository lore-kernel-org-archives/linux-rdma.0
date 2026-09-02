Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC3947DF87;
	Wed,  2 Sep 2026 13:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788354696; cv=none; b=gHwn1sHwcllIHWA2MX7cjjesEgkY2OPuiVyKJBnGuQWJ8ejaJ4q+KR7GihhUjnz2k14tVkW0wBcPhLfxCz+2q0yscMxDopHqlLnGcrCFsOKwFpVA/ik5R2AG3FBh7c8nmtA6M2bly39+MxR61OXnFIoiUk7A91vbU0/e6WdyST0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788354696; c=relaxed/simple;
	bh=+HRiBjvZpuCi/Mxo5Jpv5ZzVc1XLs6PuqrytkvJgWJc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=EcFtChY+TSErSe4AV3zqw7Arwdp90RNGgaCiSInULUuT0GmSfM3kK5oJXfXOsqw4TQN+thABNYaJKw+53cxlKHFd80B+H2sz0bHZNOpkNubXGo/a+f8okXQe2aZmaiN2KZviHdtZb83CstjnaOvQbIIxDhwOUdFfX+m09py4/6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ifPTq0E3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ifPTq0E3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553801F000E9;
	Wed,  2 Sep 2026 13:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788354694;
	bh=wmY+hW/5qshuzIbhA0MyDRJDfvOutOPyG9kQ68w+9x0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ifPTq0E31Y2uXG/T7fUgaanA4QVfP89ACQdgITpcTqLMgPf+0xbKRReP92jNDCyfX
	 VTkOfdN7TfSKz8MYpbjgggve2MDFsr/CqD9JrQj0mTh2pWME45o5nG7rWs67c7+0Oq
	 K+gKcFwh7Azkwff29JM9F62Mpnjm5zCqM6r40JrmQtu4x9iXxrk8bwKR0pjQT7aXrp
	 uNt/FncKdMKbTwKUNZzSFRdh0h934AqVB+pOEHCHAJ76/u3StpSmaUhCV/ms295C/z
	 4MJY63FvJizTXJEfH/iYkdCO1LKwKxauK9tVJn3C6jdnub66+g1NNyIET9gYNRgyLj
	 mA8/ILGEzK4Zw==
From: Leon Romanovsky <leon@kernel.org>
To: Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260821080620.1694119-1-yhlee@isslab.korea.ac.kr>
References: <20260821080620.1694119-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v2] IB/isert: wait for deferred control PDU completions
 before releasing the connection
Message-Id: <178835469209.2452909.403462519488525121.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 09:11:32 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 21 Aug 2026 17:06:20 +0900, Yehyeong Lee wrote:
> isert_send_done() hands ISTATE_SEND_TASKMGTRSP, ISTATE_SEND_REJECT and
> ISTATE_SEND_TEXTRSP completions off to isert_comp_wq and returns.  The work
> item then runs isert_completion_put() -> isert_put_cmd(), which reads
> isert_conn->conn and takes conn->cmd_lock.
> 
> Nothing orders that work item against teardown.  isert_wait_conn() queues
> isert_release_work, which frees isert_conn, and iscsit_close_connection()
> frees the iscsit_conn right after it returns, so the queued work can run
> against freed memory.
> 
> [...]

Applied, thanks!

[1/1] IB/isert: wait for deferred control PDU completions before releasing the connection
      https://git.kernel.org/rdma/rdma/c/a8fe3dfce8c0d8

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

