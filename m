Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BF93BCD19;
	Thu, 30 Jul 2026 10:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408684; cv=none; b=EEBq/q2MPweU8MAZm/iryOdsW9PHpfktXSEfxRgNtAA3oGKYkpt89n55jteQk6p6to9kg3+X3urmrAF//3yV69/wMs6GwU/mpMVu0H52S4P4jj+2Hu1LXPAFzvzmT8olYiYtbuSzlbXy2kA7gNIZspe57/ZJ64ZvP22AvDygL4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408684; c=relaxed/simple;
	bh=EcEjdIiD4gX7duLIjRPUsDpbKHt3Fls1hOXaF/ljQbc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=k6NdqVY6JMeCI2tvfTQnG27JmNjO7K0dW+c9FtPikpzkpgqyt2/hCReO2aooefQ25VnsybKvQVcHl/hhnFfIpRaZcOvco8USFodDyIdeBpGC7FTJynI6vE9ppOR//MZQ1AAu3KupX0HoHmOuK/xMAjIvHjG03Y6LYA3lYoZPLE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JlJymsfH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JlJymsfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5889E1F000E9;
	Thu, 30 Jul 2026 10:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408682;
	bh=R5nBLGM2jP7AWn3rsiy+oPc7luDvQPFkSVZgMSwF8r4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=JlJymsfHbo4pgYLxuwXivCExR6w+MuFsxItAC08yLPePmz9EK3VIzECBEEHPVpNKQ
	 cJfV1JyronNGuz+QuCviYUbfmcJ9pvC0NXxg08yEqbRl/EHJd5Q/I3T5gxrsS91TXx
	 ZHKE91YI8fKBGTpg4FpdVzGur/dVBE6QGPJ7IvyD/cb5lusjbLRtjM4CS/qSy3/6pE
	 y7rEgCrRHujJ1Mpf5qeej1BllwC6O6fneeHIVy6+uhlbgG6+JdRcgLAbyZJTdkfLVb
	 oNWWBYxugqDghpUEhypFx1SDP3dRG3mNlhQ2ZMRtTw3utEdS25ZVuEeulNpiOFLHR+
	 S5gCIC/bfh6uw==
From: Leon Romanovsky <leon@kernel.org>
To: sagi@grimberg.me, jgg@ziepe.ca, Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260726163931.971063-1-yhlee@isslab.korea.ac.kr>
References: <20260726163931.971063-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v2 0/2] IB/isert: bound declared PDU lengths by what
 was received
Message-Id: <178540868011.2279429.6419525677448670854.b4-ty@kernel.org>
Date: Thu, 30 Jul 2026 06:51:20 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 27 Jul 2026 01:39:29 +0900, Yehyeong Lee wrote:
> v1 added a wc->byte_len check to isert_recv_done() only.  Leon Romanovsky
> pointed out that the login path needs the same treatment, and he was
> right: the declared DataSegmentLength of a login PDU is never compared
> against what arrived either, and the login code reads it back out of a
> fixed 8192-byte buffer before authentication - from two different
> callers, depending on which login PDU it is.  I reproduced both under
> KASAN before writing 2/2; the splats are in its changelog.
> 
> [...]

Applied, thanks!

[1/2] IB/isert: reject PDUs declaring more data than was received
      https://git.kernel.org/rdma/rdma/c/957f92ea4022fb
[2/2] IB/isert: reject login PDUs declaring more data than was received
      https://git.kernel.org/rdma/rdma/c/2488b5b4827e54

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

