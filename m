Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635B71CAA6C
	for <linux-rdma@vger.kernel.org>; Sun,  6 Jul 2025 07:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751787484; cv=none; b=Sl3wEooPdd5r11iBV6wIRiD46qa/aSgp6TTuWhiDVjKc2datSxmJvWEI+03kdAEPGQuXH8oA1uk7Qpgk+1NwZWkWU7mYgx7w+6U8GiHe1TJtot7r7K9UCp8uY0pUWMBWKi3x0737JhkPwk0VpXM5FqWip29eZH48Q+pOxM/Y/V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751787484; c=relaxed/simple;
	bh=pX7DMTvoFF9POBNvBE8MuFyTvMe0XmNXOu2e5gho7qU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=cNKMjo5bDD8LwRibx+5aEwG2dI2cTMbDkJB6WWX/ZeP6KTnx5jnwsyWEvpHEmxAhKzYaRMUqlr/cLgGLDb0j3FdU4JdcuQI+GrDiIceQO3SQ2ZJzHphD/ZfPvoni7PXKK8kU2qvfPJscWLV/vQ8CzrJ50tuOiE2StCvzGJ9F8o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaKADS8I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaKADS8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6BDC4CEED;
	Sun,  6 Jul 2025 07:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751787484;
	bh=pX7DMTvoFF9POBNvBE8MuFyTvMe0XmNXOu2e5gho7qU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=UaKADS8I6146dHnY/57HsveFyy2BPYE1G3bnj5x0fpSbJIeRd5E/fe7+hqxwOpEbX
	 VtBdcnydoZcTxgrGqWW0993qy/TIZvq0luRLzyOLJ1o9hkwButv7zj/m0LC7r57pa+
	 Fzn0wmO+VgOnTJagVjDHLxnraMs4Jaxb3SWUwHLrA49/dC+zWUzviPmb2ObGM0dhZ3
	 mL9EpTVGzPQQxsbPxAzyQDPo0Y2EuC3xUYeeFHoFmtXgs57fe62YIo84jQH8VkcJkJ
	 jEV5tVKVJhl9urbxJK0KHES9Y9S+LjtLUrZKK53fkhIEBvRS1D5WsuuWDY62tpcvt7
	 z51xJ7DBXxw5w==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 selvin.xavier@broadcom.com
In-Reply-To: <20250704043857.19158-1-kalesh-anakkur.purayil@broadcom.com>
References: <20250704043857.19158-1-kalesh-anakkur.purayil@broadcom.com>
Subject: Re: [PATCH rdma-next 0/3] bnxt_re driver update
Message-Id: <175178748069.897826.12893471590441976308.b4-ty@kernel.org>
Date: Sun, 06 Jul 2025 03:38:00 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-37811


On Fri, 04 Jul 2025 10:08:54 +0530, Kalesh AP wrote:
> This patchset adds support for 2G page size in the bnxt_re driver.
> There are couple of cosmetic changes as well.
> 
> Kalesh AP (2):
>   RDMA/bnxt_re: Fix size of uverbs_copy_to() in
>     BNXT_RE_METHOD_GET_TOGGLE_MEM
>   RDMA/bnxt_re: Use macro instead of hard coded value
> 
> [...]

Applied, thanks!

[1/3] RDMA/bnxt_re: Fix size of uverbs_copy_to() in BNXT_RE_METHOD_GET_TOGGLE_MEM
      https://git.kernel.org/rdma/rdma/c/8ba2e1eb6b3ec2
[2/3] RDMA/bnxt_re: Support 2G message size
      https://git.kernel.org/rdma/rdma/c/c6acd006f110a0
[3/3] RDMA/bnxt_re: Use macro instead of hard coded value
      https://git.kernel.org/rdma/rdma/c/bdc5726cdd454f

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

