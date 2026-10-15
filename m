Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178484848BA;
	Thu, 15 Oct 2026 09:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055028; cv=none; b=eoRLplfJRb8Zl7cW0TQTpfrNueFU0MANVrtuX3MiU57h+eEAuzgyJ/EK80DFHuVFgGlwPRlqrFofXPv3VjWJjEecMbvctQ/c9WEcnx9eashu/QiyFN+MXoyGct/OmN/c3DMf2EFpIz09NSVA7vxB3MXAvZ7zIG5halOLdtJMxvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055028; c=relaxed/simple;
	bh=DxOA3K04TdGKgV9RBzwq7NMB042SfZvdvrNpiga7nYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eAgq2tkUGpX2sXbCrVrbFldVJLTIC0Z8IydUb5dleEgsj4uOvvsrzdZf/v0bSgq07RlrUn/3m3amXsHQ8RGT7zBtALp3/PrrBpPQENMkdHG3KAwLe9qlZ9W/71PYNaLbWSNHo/9SVBhn6z/ey2G4ArxfAOTO3VVd9sTyfNdKuI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeoC8Fk/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeoC8Fk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A1B1F000C4;
	Thu, 15 Oct 2026 09:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792055026;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oeoC8Fk/hvQ75AsycJvkVMkByhxPIzupidqzUKlM5YkuPP7Im9rU+E0vjw0NLUVRh
	 uHwRejb21YIek9RyrZ06ccGG4fXjYIbDKBTPLWmwhbI1ieEs4SJrzPag2u85jTk+a8
	 n3RHq0uEDda9gZH9hoG10t8nA3S5wGc82Z0pjFPDPCfzjoUvIeFKL9uBqGb8hlKI93
	 3BeWK2GntPdT4cpIaqN2Fg7OENazzoK8hlPJbeZxX9firOeegdheCuXiH+LH5eOslk
	 Z8soc1wbDejHkdebEClyl+hRMWSZGz/6VQ4+hu1jdpKNt/lIYQZrp7kxqMQLVeFsSA
	 flLlbHVOUFZnQ==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Gal Pressman <gal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Roi Dayan <roid@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drory <shayd@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: rep, Fix races between devcom PAIR event
 and uplink close
Date: Thu, 15 Oct 2026 09:03:45 +0000
Message-ID: <179205502546.408196.15852916239937447709@kernel.org>
In-Reply-To: <20261015085744.1109107-1-tariqt@nvidia.com>
References: <20261015085744.1109107-1-tariqt@nvidia.com>
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
