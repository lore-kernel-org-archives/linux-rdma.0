Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7613CBE8F;
	Sun, 18 Oct 2026 12:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792325605; cv=none; b=TGQImGaqYwmXDlF+h36PGOX1Vpum8wALN6+fZGnVu5Q/jyaVXyUxY264LFdX2gUCRmmIbFORrs07Jso2Sy8cT1eMUZTxJ9QsjK6yUVU4s0LONdWQ1mOSVi2tJG/c1VXqxOTDlmlOMlDdfY5BXg284/XMV+nncPGiT6Botx0owBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792325605; c=relaxed/simple;
	bh=s+OTqsoI9cJC+zYDzX7WplZznDiSlTuW0HpKu9isYBw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=AAI3HICgtTMk6UdZttcr6RJq9iwg4sbikoPRsynSziTjmJ6wOue/swL3eve1qbYcw6Ds315hpzXcJd1WbpoWxJnPjRB67As9XHJB5bUHMU8TZcr01DJrq/7WJNlCZeSEMIBVVJlRB4hPFyN4l5zCxfWjq6YDpYbVr+KKdp9+dLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U6lxw/wg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U6lxw/wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EAA1F000C4;
	Sun, 18 Oct 2026 12:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792325604;
	bh=Ea4GY6pphxW3b3uqIiRtZy0M1Cu9MIdBtszAoHpbJoc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=U6lxw/wgX0vk6MjLyz2eEkq2cX0BnDL8bw2tpAW3yqgcgZ2dOY7Rhkob7Ft54nIwJ
	 CUfxugiYFui1SUF8f8n2ofRVyz/n6Qn4C9Oa7ofNvhKAoYCA9XL/vrzo9MdMRVhSU4
	 VO/TfDoCE+cXSqh72KHwJckWThnVnnw3KAgbY4cP3oGEEAdYKue17BiPBzJodnmzp5
	 cYZvVXdfk8kbV0xlziWRRNSPKqK3Bm+y8eh8dbv1jgxZsw+X6VTzzpYOT16GUSGyVJ
	 xp7UyD18C4rMtOAwt4Q8SRtVhhhb+RFYkUquZ/Dj7RV1zQMdEZEKduRZOHu212weDi
	 00piyo+WSd9Yg==
From: Leon Romanovsky <leon@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Serhat Kumral <serhatkumral1@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261016211509.12973-1-serhatkumral1@gmail.com>
References: <20261016211509.12973-1-serhatkumral1@gmail.com>
Subject: Re: [PATCH] RDMA/srp: Avoid reading uninitialized has_port on
 srp_parse_in() failure
Message-Id: <179232560157.20458.325420219223889698.b4-ty@kernel.org>
Date: Sun, 18 Oct 2026 08:13:21 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 17 Oct 2026 00:15:09 +0300, Serhat Kumral wrote:
> srp_parse_in() returns -ENOMEM without initializing *has_port if
> kstrdup() fails. Only check has_port when srp_parse_in() succeeds.

Applied, thanks!

[1/1] RDMA/srp: Avoid reading uninitialized has_port on srp_parse_in() failure
      https://git.kernel.org/rdma/rdma/c/4b8f20dc8d25f5

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

