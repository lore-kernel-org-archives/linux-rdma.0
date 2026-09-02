Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0036049DB87
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 16:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365678; cv=none; b=TOA5nVdAowfAvrUB9b37bfqmgpoIzudX+SoxmuxJNvLTXIcqi+I48pBXhctSh0/K3jGekalLfiqTQF5V1kBaTvmJ72BlUrChqrlNYDaWE030hbsWwKrmmE8k1SyuRTysLxQTQM9qt38KtWewGF6JK0Dy/l5tsw69etoLe2guEdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365678; c=relaxed/simple;
	bh=UM2t81yFxKS8/t3lclfwcgtxomPrWWYOWmiM5j0kbjs=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OAhFL51QanmgKRTf5r+Ei7bkOubohbDiER6mQ1INHJmzawnp9UgRw+ihhApPqykZDSq1FMVSjbCf5GgZtIeE5dlF60FExdmMCwbHjcMoyy1GfPwQqxp1hXd5vX3+6l9CK6G28/gPKRxuFZYdQ+TN6GtWY8iA+/MWopeU2MY8uvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lIf9JoGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lIf9JoGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE181F000E9;
	Wed,  2 Sep 2026 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365676;
	bh=sMdK7yBu4uFPSxZy6vcBoXRXdoPUkyMnLV6O45GSdrU=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=lIf9JoGmnr/GetunQuYTa9v66QHkshkVMaToqmdf5iKfQj4rtgyHZ+IFkoEMGfe3F
	 lLXwcSgNUwMa/vQ/WaSiaiOo07dJGa2rJPBKPh3mXv6T8u89iOGXRYP6YDJSYW/n6E
	 MPx+nIFN2x62T7yfKdvSlqbFLQmYLpea9Yc7WYL4FG4ERJ7p5ofjHlITgQ4fnKqEmt
	 jsW9DNbagcqyqCIhRkaF+yfr2mB8Af20tnVgL985g9A90n093zcqPS3x0ZINye+b3g
	 LAZd54mQ75DEWoh2yuI05nqe3JC1j70QF24NwiD4fJWzhcPGMqEVtfCXDSpcmzYHyI
	 5Q9Wx/gP1e0AA==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Michael Bommarito <michael.bommarito@gmail.com>, 
 Kees Cook <kees@kernel.org>, Daniel Jurgens <danielj@mellanox.com>, 
 Doug Ledford <dledford@redhat.com>, Paul Moore <paul@paul-moore.com>, 
 linux-rdma@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260826073216.2367-1-lirongqing@baidu.com>
References: <20260826073216.2367-1-lirongqing@baidu.com>
Subject: Re: [PATCH] RDMA/mad: Fix receive buffer leak when PKey
 enforcement fails
Message-Id: <178836567373.2546256.16753889656136218502.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 12:14:33 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Wed, 26 Aug 2026 15:32:16 +0800, lirongqing wrote:
> ib_mad_complete_recv() initializes mad_recv_wc->rmpp_list and then runs
> ib_mad_enforce_security() before linking recv_buf onto that list.  On
> failure it calls ib_free_recv_mad(), which only walks rmpp_list and frees
> the ib_mad_private of every buffer found there.  As the list is still
> empty at that point, nothing is freed at all.
> 
> The caller cannot clean up either: ib_mad_recv_done() sets recv to NULL
> right after ib_mad_complete_recv() returns, assuming the MAD layer took
> ownership of the buffer.  Every MAD that fails the PKey check therefore
> leaks one ib_mad_private (about 300 bytes per IB port MAD, ~2K for OPA),
> and a remote node can trigger this repeatedly by sending MADs with a
> wrong PKey.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mad: Fix receive buffer leak when PKey enforcement fails
      https://git.kernel.org/rdma/rdma/c/3476c28c9addfa

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

