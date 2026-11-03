Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709847;
	b=nUAsqeFj6uI1pcEjYt7J7HIsyS4MrRscBNCzldc+HGsCEhvXqCSe1Pp3/36GBQLwHD2G
	 +krWp+LCxSsJik6YNQ+3QChCahu9HByzTusEdjF7TahqkQWFxwK90AsThs6KDjKv0M9N/
	 D7ZnwJWyNNS+XeFp1kW+dAEfkhF7IsBOmZTboGu/Lg7zFBecr+HZnPYGuBbaUT+uM5Oft
	 QyHvHw9qp79aoWBUSUxXZcRt9UOw8EXgO2S4W7HDhD6DuwQs2e6Eazvc3vN3edIti7PMI
	 3Vzbk08jsgFThmquT41y5u9lyVAt3gBbhg5d6aQMMH+NRdLVwcbcjcqX/urJ8m7h2eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	b=SDONtbWDzjpkNCP8z+J1ZmTfhAL8f5UvEEB+UemUNR2+MVBcsz6kDWS71TRfpcEOtY24
	 nBCZyK3P4kXl1yZ/rN5x4ycidqrHcMMtqAkoDHpHhDJTIr0nKAfXP9lBpqSXLKQPprLPt
	 SPkY5w7f8muiJ7/7HA+Z5BzDNodYk/+/oCn+dbjBKS9mleL7aNtlzacnxKoaKShVnJ8CK
	 GCrIc62/Mb6zTMDd6mT5q0e1fZUIcYBxmW6SqLVzC/GsPdhWSOAjQ029RjvtB/rUXIsks
	 e2y5nSfPUCihvO3bjgQyKEIz2yYt2TFw/QoVF3qUpeM5C4rMoMeOUxiBQkqc934jkDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmQFcXMD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB4C606EEBE;
	Tue,  3 Nov 2026 12:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmQFcXMD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533AB1F00A1A;
	Tue,  3 Nov 2026 12:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793709846;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmQFcXMDmEnNE1w0efpuVPmoPkbfYCNmcIm+1Xq7CE3g2WHuBhCxOUf5YvXN1gUJy
	 3hEd/eJMQ6r0PWqAFRmgDyY7M7wGfkPrPbZrpl6V1ImusRDd4isT1bkklu7kNkepqc
	 J0uzB7aHBv/grD0RewWcmn2SfyxSpWfo75Kbt27eAbEwqmKy9vDtbBHz02nulqfpoQ
	 kH1HDFl0wzRqoEOwAHhLHyVEkaE52N6H398cNoF3V4aYztps7zNr9Xk3EjPS6CVjz4
	 cC6Xj0m7QdHSFvhYdQDzf1YG7iSI4qUdEc30KKfXzBIi5NkAvEVW3LUO8fcGUnDeQW
	 gFk0pnVWqvnhQ==
From: netdev-bot+sinfo@kernel.org
To: Mahanta Jambigi <mjambigi@linux.ibm.com>
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, hidayath@linux.ibm.com,
 pasic@linux.ibm.com, horms@kernel.org, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net] net/smc: fix handshake abort on a terminating link group
Date: Tue, 03 Nov 2026 12:44:04 +0000
Message-ID: <179370984481.488859.15201934441460346319@kernel.org>
In-Reply-To: <20261103123955.47454-1-mjambigi@linux.ibm.com>
References: <20261103123955.47454-1-mjambigi@linux.ibm.com>
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
