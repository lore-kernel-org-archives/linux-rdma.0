Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416F73B42EB;
	Sat, 10 Oct 2026 12:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791633827; cv=none; b=okn9zVx9NP/OEPOYIuCWoQRyPk4UtE85EPp6tdvKz8nAJjDcaTQHOCJ8LDX+BaALMaF7Qn1b+3F61DLczGqf+m0fY9OUXl1C73qVWOsWSAj8uUgxq6FlkVfZItDaWgKJ3zBCBb+/y6k9IrfWx7Swh0h9dYWrfcrt+1W7dk1SIfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791633827; c=relaxed/simple;
	bh=Frc+ADQTxRwKDWaoqMQMlUJQ/gCXB8qyIs31/48aD70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZLiEJ6JdiczwUAF/bqse/C7+A3qINyZEoRG2uJh866Nm63a1dTUuP47j7KK3aoxA2MO4dVMZfSQ17ruVrIddzqx1LvMnd3qBtWDllMdDGJ3qQFFndr2dQPN7rb63/NbGyFVXIwloBjm6w0rc2xWHSYDv6qferNKgrYXx2IDgvYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8Fhvtm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8Fhvtm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBE61F000FF;
	Sat, 10 Oct 2026 12:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791633825;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8Fhvtm2NQvL3lId01q1HSu+qexrRUg1O8nWyKUDjIH54qvBBteO+qNNPeiYZsBRp
	 JW1k4gGD/xNHmTByF/LlzfqYd+x6NTjv8HXjNlFT27YeklM8QxH54VcGCoyveG/AUr
	 mdnU4yFWuYsJqiSRAoTDPUK59jo3Aqw5rqgCAT5YqDje6oLFpJf9AWkZUvvbp43CiY
	 3F87n30qhomre6fuhuAv+4szyyPhbAWHc3yRmH62fAua6O01UIWBefJis0ycvl8nM9
	 oW/3y58HhfdI2bvNw/h7LeXBcNRYBTjvCEsfNNBu4H5n6Vkf/KOx/fV9WtqJJuUUYu
	 llvShxE8fp94g==
From: netdev-bot+sinfo@kernel.org
To: Alexandre Cassen <acassen@corp.free.fr>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Moshe Shemesh <moshe@nvidia.com>,
 Yevgeny Kliteynik <kliteyn@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org
Subject: 
 Re: [PATCH net] net/mlx5: HWS, fix modify header pool match for copy actions
Date: Sat, 10 Oct 2026 12:03:44 +0000
Message-ID: <179163382453.2527009.16879359718603155404@kernel.org>
In-Reply-To: <20261010120147.135825-1-acassen@corp.free.fr>
References: <20261010120147.135825-1-acassen@corp.free.fr>
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

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.
