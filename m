Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103912DAFBB;
	Mon, 25 May 2026 19:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779736800; cv=none; b=RLWjygNcsej//J8eSS8xz6c/1ux3+VURyRO+0qHiXqu5B4ghn5PkHNbXUs21e+ERAePtWXhGt/yyc9aocO6UyycX5ZTEsx7FyJvoHACjsNxxsxXdQK4DqXVfCEw98jO5Pj/dbYgZE9n+Z3GD1VBwBW+cd6ErhUCmJmw+hMnIpdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779736800; c=relaxed/simple;
	bh=JGwSd8EjzXWbu1Io4pvSeacjWU+0iz6a52RG7zZ2mZc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Rod9xAYTjAx83zR/RbDQeWL8NGeWZyNtMX5AQbXkZlcuHR6YUmWj2/dYljHtxArsJ6vTq+GX02ce3N6GQnCw0tT2BG3OdLXcZc6zV1Mr15LXZ9GZ8A1+cH3SOfY3tQ3LHi+zK0bSv0chUOymJs6JixesGBBa2Mp0Rv2KW1ccifI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7lT73U6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7lT73U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE61D1F000E9;
	Mon, 25 May 2026 19:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779736798;
	bh=0iJ9VOglnVV91F3eYIQx2BUR7wpF3AWJQfpZKIfsCmk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=V7lT73U6QeznVFgHpbVAOuIYJn9l9mhpGBTB+xyVOYKqLM4qaSRUlMQxzcDkXlkVe
	 wUeoHYOhFEPOS3QQrKCTIprp3tcRCedvKjyr3rsVwJgws8ummAzQ5/F+m2l3CZCrWE
	 ypqqp7fZAkMH+0m9C2nwFOtrTkuXRWik4CcdipaYyqX0ttyro5dLJr4km1YATd2Cl4
	 JA9Sr9S6AGm7kDzMA1LNwUvsml0179Xc9GnsGLHO0/d6kVgO0oQda9FcGVGZsto9W/
	 6AJGmBOZ2hsddhs+iBqOAg0Fr5HVdHA+jQH3ypz5v4bzF9REMCN+Z1ajvrTymMt6n2
	 q5EHLbYqEfpYg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93EC9380AA75;
	Mon, 25 May 2026 19:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v6] rds: filter RDS_INFO_* getsockopt by caller's
 netns
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177973680540.3090294.2757968326227681931.git-patchwork-notify@kernel.org>
Date: Mon, 25 May 2026 19:20:05 +0000
References: <20260520084236.2724349-1-maoyixie.tju@gmail.com>
In-Reply-To: <20260520084236.2724349-1-maoyixie.tju@gmail.com>
To: Maoyi Xie <maoyixie.tju@gmail.com>
Cc: netdev@vger.kernel.org, achender@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 praveen.kakkolangara@aumovio.com, rds-devel@oss.oracle.com,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 May 2026 16:42:36 +0800 you wrote:
> The RDS_INFO_* family of getsockopt(2) options reads several
> file-scope global lists that are not per-netns:
> 
>   rds_sock_info / rds6_sock_info,
>   rds_sock_inc_info / rds6_sock_inc_info        -> rds_sock_list
>   rds_tcp_tc_info / rds6_tcp_tc_info            -> rds_tcp_tc_list
>   rds_conn_info / rds6_conn_info,
>   rds_conn_message_info_cmn (for the *_SEND_MESSAGES and
>   *_RETRANS_MESSAGES variants),
>   rds_for_each_conn_info (for RDS_INFO_IB_CONNECTIONS)
>                                                 -> rds_conn_hash[]
> 
> [...]

Here is the summary with links:
  - [net,v6] rds: filter RDS_INFO_* getsockopt by caller's netns
    https://git.kernel.org/netdev/net-next/c/c96a5209dda6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


