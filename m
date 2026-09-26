Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE03344DA2;
	Sat, 26 Sep 2026 01:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790385704; cv=none; b=T5pReKh/iMRDhKbUXXNxKc7e4NZcJ3BCk1gVIy81Rd6/DtK3nhOxavpr9U8vvn3j6GgLGZ9+cmyMlubfgQozKK6+45JguzJRyevCpy2BRSzDif+0ecxqY20kPcwODNDAJTtm7fluzqfpgcD6hHGY8qWHVcySCesmk6crlHW4lPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790385704; c=relaxed/simple;
	bh=CaTSUyJbbV/eQCZEZ6cCpnqK3H3gd3WpnZdPD717H+g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uG576NW39L0+ULHBmBi12i6cYKe4XeUgV116bTOJKNCCsAY9JZoA+O1hoO5AvELKOZAW7IQwxRDjBOOrys7uu0ikxoYOvEzL0i43xV2I2SH6Lr4f4Mz18LsUrLsICdjxOKY3JLr2aOCfrTGKogbs7W9njIAyoP44yS3+mIPGEqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mb6Wrg6/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mb6Wrg6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214AC1F000FF;
	Sat, 26 Sep 2026 01:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790385703;
	bh=ebMhnPH3pBTR+S9cD5+R6A7TI3NMDviIz3SKHBOMtQQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Mb6Wrg6/9m0acC5AOZtbTynd4qJYtGKJrAOJ0gTRGQ6RYEdkfStZnO9TpUi5kaSv5
	 ybcN/xAb6iE4o2PfZ0NFqfag1S44hVmZgl35pKdXnlm24qLldsJ/8leKOkdPlJYOfY
	 PtolqxZGXT/8fRxJF3EQ+jujDzBaAC/39A8xG38k4mfo8TOIxM7i22FrcYogUTTmpV
	 +vj2T4HLZcPwoT4UsoZVtFPpWOQ2PQx/RnwBH/dMBakdDwEB68LwQ1I2oBSnSTTBCf
	 NVXDhi3QEpLJ5fEsoqNw2bYMO0MCX04PrPBArkzVd0XG7oAooaSCgqBTQoUQpaOMrT
	 Bm422iLWFklXg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0D093809A08;
	Sat, 26 Sep 2026 01:20:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net/rds: replace tasklets with workqueue
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179038563039.3233155.4555576377186057947.git-patchwork-notify@kernel.org>
Date: Sat, 26 Sep 2026 01:20:30 +0000
References: 
 <20cbfc32678019daadd3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com>
In-Reply-To: 
 <20cbfc32678019daadd3c67fd75262b8264aa180.1790178801.git.sunnytiwari@google.com>
To: Sunny Tiwari <sunnytiwari@google.com>
Cc: santosh.shilimkar@oracle.com, achender@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Sep 2026 06:26:11 +0000 you wrote:
> Convert the deprecated send and receive completion tasklets in
> net/rds/ib to BH work items queued on system_bh_wq.
> 
> In rds_ib_conn_path_shutdown(), replace tasklet_kill() with
> disable_work_sync(), and call enable_work() after destroying the CQs so
> the work items can be used again when the connection reconnects.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/rds: replace tasklets with workqueue
    https://git.kernel.org/netdev/net-next/c/5ccac2330deb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


