Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11FB1FBC8C;
	Sat, 10 Oct 2026 03:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602725; cv=none; b=j4aWgSOhvg6AjDSXfpaKGR8q+qLpJmUAx8vdP9mBR5TCKVx1BVDCpXnOzziNPqyh4Bvni10NDW1O6XaLhDjIBL4n1fq5lfOv924O4PaUeLCPxNhAg++TapwiVNJMqPo8TMBuYjGpHuRgG6EZYZukdUZI6V+H3j5czMr2poH/EoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602725; c=relaxed/simple;
	bh=Frc+ADQTxRwKDWaoqMQMlUJQ/gCXB8qyIs31/48aD70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fMZllqoghCt86I7IYIB/pObvzklKv8TE3fkxILuS4hsjOV/fx0/EMFsQkccDPGZpW4DfKHDxlmSHU3sRiidc7Jeyhw7TyVcJQWv2WTX3ixOHMdQQSsnVRTVZ3ZYYE1R3JW37ZdGxER8jlzPKnl07zZ60vb15FHfQUn7TDCq31W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1yan0GN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1yan0GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7030B1F000FF;
	Sat, 10 Oct 2026 03:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791602724;
	bh=80POjU5WP6ctS0DqN7hA/63JAQ8Agh1hTny2C1kJcvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1yan0GNX8GBVnPCrjlLSMyfQtDrS/h8pKB+m4TZUQTWZAcH8Fv4kLYRPL4swtEet
	 xjUOxL9z9IV1h75yA5oJ+c9Wx2p7IAtMw7gaWjNDYbbjAstcQ5j9EEmz6SmBr87b0P
	 CdOoCt7UKMrcKaqpW5nNZmtyg1IyT3l5uPUdYPi98tyvfih6nRwKmHgWlZe6r2mzKQ
	 l6H/Qmu03fzd/CDzudKKoCWCpWBS8SJBxbnB3QtWjYQyFTFGwvOx62Zywhd+9DgjDC
	 COymzfjrb9gQ700TsgosBe3X6JDdCssefcJpBylVlPjRh0PV3Ojhkht46JmGClQ4nx
	 6B+Z1sz74ibfA==
From: netdev-bot+sinfo@kernel.org
To: Binbin Deng <18983559317@163.com>
Cc: borisp@nvidia.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, sd@queasysnail.net,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: mlx5e: Fix use-after-free of the MACsec
 xarray entry on RX SC deletion
Date: Sat, 10 Oct 2026 03:25:22 +0000
Message-ID: <179160272288.2527009.600458371077116507@kernel.org>
In-Reply-To: <20261010032115.93545-1-18983559317@163.com>
References: <20261010032115.93545-1-18983559317@163.com>
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
