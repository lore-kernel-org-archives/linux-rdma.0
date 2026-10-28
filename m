Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793171107;
	b=Mg927AXnAaAFTLeETJPUMaFJI8DIXDcJuRQ0/UnTNlEme1Lr4DX7Gt7HMMsK/Y5RuHIU
	 dZo/jkL5Co0sLpwVgqxLOHJntIbwlCnYZJdj921i/NWsDKX3E+eiaWWgk58F3F/k4lM80
	 e/3m1xU6wYhQcNy8lYovundZLkarekJwwGlOGgJfw/vJUDlCyHz3DKM48tMoUzH/NdNea
	 oP2Oa7/NgV52w6VLM2qqUiyrfJXFhSzYH5bD5neaxUCFpncSxWATRgYauq3xbTQCd1iwF
	 IKhtDNd1WqmgRyT3DH5c8YP4X5gpYjvyqylu+bBjSuLX06sBMhiKaojnQlGgVVoxXVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793171107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=hxtukN8vLMbgPxheR+Gz5VbuD7pOBjN5QZLywwUeEcn4JI9J7EUfGGvv1huMvc5zf8pK
	 kO05nhd3hsFv/mI/ePY0HVx3SSBRB0JI7We00jNbqZOrZ8veGTWRWvuVwv/QYQyJj0E0X
	 oIFAJ2jtLByHJgynOkcGwn8YmUd7VM0csAmo+qSJiov6PZaTR+zZpsqWL1G54Yl0TCefV
	 1sqfDkye4aPgsNQD81e5F5w2ESGCYVgu36GK4CW6xR3A5UjZ6iQQG0Z1iKhFTUmDXSFFX
	 kotDvTLeFaa2xG8fHDGk5oQUk8PTM6PfRDE5AcY5ajcPx6bjaJD4smhgbHorQwDmEyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="NtEIePh/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F06606A31A;
	Wed, 28 Oct 2026 07:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NtEIePh/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1A11F01825;
	Wed, 28 Oct 2026 07:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793171107;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtEIePh/4VU0pQ6RJJArgaTkNONldbb/wLXiw3l2Bk0+GyH5tGTHUTe3wp4BpOfAZ
	 /09vYGt5aCXsf5CPFRApo7YSLg3wYH6rZ8uY1Vh0eL0ds6GfsLyzfXI51kbaHwS8y8
	 9oJdMoRUSFANcVYJjWLOK7oL+M5qM1XEF8FOUC2xhKnQQ50kcqUJXGFUbHIskwbT0x
	 M7LVsRqV4ueAxEXu+ggt5VAWJq7Qu+daB8w+y3K5FqUURAiRT+mn3rYkhX47lbWr3E
	 CiFHf42PHszCUcdfb3/XiZbLz7QdiI5DgJixSgX90VrvRrhmLkRMYaJYdV7Py7QTFz
	 qb6BgVvuECVKA==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net v14] net/smc: fix lgr/lnk lifetime vs diag reader race
Date: Wed, 28 Oct 2026 07:05:05 +0000
Message-ID: <179317110565.3327.10865585380988219772@kernel.org>
In-Reply-To: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
References: <20261028070210.1685136-1-mjambigi@linux.ibm.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
