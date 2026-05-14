Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414FC25B098
	for <linux-rdma@vger.kernel.org>; Thu, 14 May 2026 05:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778735767; cv=none; b=cbGms1UqbU7VtTA1Ka3KhIW9SlpbGEhC6h96e2jvWdxSYYjSOCzypOTMGEBMdU1teOjFaO9eJ+JV8o0jnOMUJGQoWwiTjJ5lKb17UuOF9ldrzK4S0/XtmVUTYsLva+Q3yL6hhMo2qr0c4O6mRjI00hGBO7Lhcd7GaWxXim5lAJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778735767; c=relaxed/simple;
	bh=RaIVkvzIUD+7F+yesByfgntfUdiKWKDhPYi4p1oYlHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AFuE4NE8AnT8SGtofLUdjj6Q4XjmVHkHz9YFyKXXZwXHOz/gNaT2Zaev53cMB3+8FDlH9dw9aUu8EGP1Pz/rx35nGaYua8SPCt6+KCIXpNWfmNEQDb78iw+0PbKqDriW9BamKZr8Kej8KG4aEqCT/TOJf7ptj3eI9RI/SjYFl4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HrzNSO5d; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HrzNSO5d"
Message-ID: <871ea091-9328-48f2-a33b-fbf3d23f6742@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778735764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaIVkvzIUD+7F+yesByfgntfUdiKWKDhPYi4p1oYlHk=;
	b=HrzNSO5deDNCzzfTBcrEnrLSPm+uqlXLVDJY3CQ3kuFHJAATdnoADsk1GU9KDtvzXPLEjx
	PcQMbFFLXkmSErvYz/iJF2fGqnnyKMyTyq6Qr9cwJBQkafJVAcxkm2qnKdrUfrXd6LZ8fJ
	82XtJ1B/oEl+vuCjfnsYVcase+yaGvA=
Date: Wed, 13 May 2026 22:15:58 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [syzbot] [rdma] general protection fault in kernel_sock_shutdown
 (4)
To: syzbot <syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com>,
 akpm@linux-foundation.org, arjan@linux.intel.com, davem@davemloft.net,
 dsahern@kernel.org, edumazet@google.com, hdanton@sina.com, horms@kernel.org,
 jgg@ziepe.ca, kuba@kernel.org, kuni1840@gmail.com, kuniyu@google.com,
 leon@kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
 zyjzyj2000@gmail.com
References: <69fc0c7c.a00a0220.387fc1.0006.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <69fc0c7c.a00a0220.387fc1.0006.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

syz test: https://github.com/zhuyj/linux null-ptr-deref_kernel_sock_shutdown

