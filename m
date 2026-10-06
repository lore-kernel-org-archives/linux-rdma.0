Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D9437F739;
	Tue,  6 Oct 2026 20:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791320114; cv=none; b=Ebq4qsL/uDFFeKQ/WD/Djufxcxvv/PfBuXYjFTB5nziNV/Hr8i0YfuK1r3TBUxcHbk6DxSmawVuHB9Y57APZBUyCbOSkUaq73VtOHIvWb6RqFRTplHFz83Jrp2TCZWTmLeQCmRceWZo7y39x5qTzatvT0qXkEXl4NkzRjo8Ayac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791320114; c=relaxed/simple;
	bh=x8GQ9TqAFu5driuvo38kqzYt3n324pebOlaNmEELI+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=H3bSSSKGP1bUd8ZPU38HrUK+zw3X9Y3YNGcCMA1cU+7yhrqCTFysz5XnlUX/NYnAG//q7/9SxSPkl0H7ZEi3mN/LFQMblW0+ta55QNJMjCLTVhVXnWKayxBf5qdQ75whR3Xa3C6NcNeN8pIkZEeb3Za9Gl5VliDmtm5X9el0E2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQagaFuq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQagaFuq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A9B1F0089B;
	Tue,  6 Oct 2026 20:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791320112;
	bh=PJRu7W6/Or1we5Gv3BgoLEtby0D0Y0UGgfjBHfRc5+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dQagaFuqQLNB9IDq7PyswQEZwFixksVTSJNLbkJ3k3dXZY7XNqJU/c96bflC0wLbj
	 fBzlRQBVod/008Hw9TdXhnfddMlgkP4qUMOOPWBKVM0Mgmai/8ZKuddiv7ivhXt4kq
	 y9E6/9IMoiyHCTYQPLCtHq/JHq6vs+OhAmQRkeQ0Mvsn52iUa2piY/br2QFQ8YnHh1
	 HfOrePE38TXKhidUO4Ue0A+62Uw7r3aZifuF0WQ42iYkKKBwHTZrqgjJvZVhYUYAlq
	 dINmFBWkWDpjwpLwzIC8yWxZbmz2IvwzSSXg8+bSVM4XGqNj0zraD4RsQFf0G8z/7n
	 soH/BlNYQtjHA==
From: netdev-bot+sinfo@kernel.org
To: sungbyeongchan <tjdqudcks0424@naver.com>
Cc: Allison Henderson <achender@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Andy Grover <andy.grover@oracle.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] RDS/IB: validate receive completion payload length
Date: Tue, 06 Oct 2026 20:55:11 +0000
Message-ID: <179132011155.2231598.14821411537905810702@kernel.org>
In-Reply-To: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
