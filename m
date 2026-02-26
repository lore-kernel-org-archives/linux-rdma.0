Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B513783DF;
	Thu, 26 Feb 2026 03:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772075417; cv=none; b=c2j5ID1IDa8ouciVwOFCqLZ8Ww/b+7ccQdOzCvuXUaN91mIdVkvuM7tX3B3TZ6siB26/OzC0edJNM96bdQqFV193C7fPdx2mMOOPuAGJdcTDW2HhRVuHsldl+r2ZEetoi7TtuNohFSVQygyGk9joEP0L15SALXbfcbFT5hjZwAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772075417; c=relaxed/simple;
	bh=H6Q+g8PlUWxnf+Bn6iXDQfEZftdjgymJC0EmFIfENwo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=N3uq/N/qPwcIP9w+sYsShFos7cXK5CASimjvsuxA8BMz9t7lfVDn3pFHCiTpbcadNURENJgg/seJazfCi8ZIfdjEbfIF1vCPTJBdJsb6JSwO5Du8vzW6pL11yTMOygJHtQ6cVlzMatYnaDDs1Q3IEabCNGt6LP0nXFflDyTG920=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBHjoy46; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBHjoy46"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A08C116D0;
	Thu, 26 Feb 2026 03:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772075417;
	bh=H6Q+g8PlUWxnf+Bn6iXDQfEZftdjgymJC0EmFIfENwo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PBHjoy46vQmuLJOnp/lZD4RmaXYDVGe8xTsvqTVHw2D4GNE2lqZkEhJ7UukCadcTE
	 hTrbDhHk0e7fNggF9h1C/1Nuf7McyaffZQb/lrNRelCQqt08CKBE6neW6tzBMEWqPZ
	 eBkFHo3xmEDyMP0TZpgWNoY9nA5+aEEd/kTyjEeEFhpNE6CygIWMlAH5IUpgdzsTGI
	 QZifJFwiJM4EmFv1tMU6LhHOs6RvbU2gyIKQZ60qZPEBbc6t5CXlGJwEMIuDJUMwz5
	 ppUPpBOqWvkdFXvawDDmSWGEGyXhGpeo/0WLFweL/XCvtZxk84c/TSI3/h6bC5mmLm
	 grgySYo8ad41Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CE7A380A94B;
	Thu, 26 Feb 2026 03:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rds: update outdated comment
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177207542203.1014739.4552653460667826006.git-patchwork-notify@kernel.org>
Date: Thu, 26 Feb 2026 03:10:22 +0000
References: <20260224020720.1174-1-kexinsun@smail.nju.edu.cn>
In-Reply-To: <20260224020720.1174-1-kexinsun@smail.nju.edu.cn>
To: Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: allison.henderson@oracle.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-kernel@vger.kernel.org, julia.lawall@inria.fr, xutong.ma@inria.fr,
 yunbolyu@smu.edu.sg, ratnadiraw@smu.edu.sg

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Feb 2026 10:07:20 +0800 you wrote:
> The function rds_send_reset() was subsumed by rds_send_path_reset()
> by commit d769ef81d5b5 ("RDS: Update rds_conn_shutdown to work with
> rds_conn_path").  Update the comment accordingly.
> 
> Signed-off-by: kexinsun <kexinsun@smail.nju.edu.cn>
> ---
>  net/rds/send.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - rds: update outdated comment
    https://git.kernel.org/netdev/net-next/c/51432958b565

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


