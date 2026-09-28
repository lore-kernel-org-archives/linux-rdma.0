Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557B341A55D;
	Mon, 28 Sep 2026 06:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790577071; cv=none; b=jJwe7+oGqo/5SMqS4jAmeublCC+UdoBj2KvyiU9ZxYWvRtCUhfLQDYMiqXJWiMpT6SGTMy/DKN/gwM4JsVhBglfSTeOM0zbeZZKC5+vE/4YfXIgFLkAqnouvbvRdbmsUdv6zaK8V43JAUaq3ts26SewVPk14fifQH50PxpN3yS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790577071; c=relaxed/simple;
	bh=gp7PRv3WjAiMJrp0DvXpRvTv3mwC8R3NiezXzUE7FxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dWVlM+eVlf0LAQrMMWOOFySZWPdmR0WaoD5YSehlVbfOnLgk7JbrEICd3/jCVK834jMWJjKujL0OKvsxsqJ7u1ucC9Kv69FjQwvmPTIe/P2cQAuTWlnZkbDlHLm2ePorv+AlvBnrti7t0FOBDovEnefHimwMmF21wtJK6WQGSZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTijFqXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTijFqXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA1C1F000FF;
	Mon, 28 Sep 2026 06:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790577070;
	bh=Z9zRtXHe/J1k/4/9wAeq1n+PwAt+ioXmV3zyjSNrjDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTijFqXlSDe8o9kQm2Rc90CqL01hG5JnvFMdGOiHv0vMm2HqtboyWcdReZYYMOpVc
	 Sz8Ma8XmAXPFaWDok0Um8brRjOXvp6uTwXUoC3Sd8HhjSZlqtvJGaIOGlXg3UICa6c
	 LI3M/Kje8DIuQ32VC1SbqnFieXe4WjzXW+t1Gd/ppILN7VAGmtC8GEMgvcz2Ol+HW8
	 SnA1lq9RWtJcEBroVsZcPIdgQWd81JYcDV3nQPe3d5XYlA42M/e/vwuhwPeiW8/6ed
	 Oqm4X6iKdXlOZHluEREVZSTgepWtfPMCyhRG4MwUnmSOAoNrFqWJWLrHZttHQQ0ur9
	 GDXRMU2w0gzWw==
From: netdev-bot+sinfo@kernel.org
To: Atharva Vartak <atharva.a.vartak@gmail.com>
Cc: security@kernel.org, alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
 mjambigi@linux.ibm.com, sidraya@linux.ibm.com, w@1wt.eu,
 tonylu@linux.alibaba.com, guwen@linux.alibaba.com, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net/smc: hold a reference on net_device returned by
 pnet_find_base_ndev()
Date: Mon, 28 Sep 2026 06:31:08 +0000
Message-ID: <179057706891.31693.13379632576088097849@kernel.org>
In-Reply-To: <6aba080c.b933486d.297b72.5042@mx.google.com>
References: 
 <arn3qTu_SeM8Yrjj@1wt.eu> <6aba080c.b933486d.297b72.5042@mx.google.com>
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
