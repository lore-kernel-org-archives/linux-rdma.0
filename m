Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E613320CA6;
	Thu, 22 Jan 2026 01:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769045962; cv=none; b=Pp0ykfYD4W1gqhuKTx4OpzmQPTx1K2BGyVIyilDXo2iGK3NN1z0j+Oq8rPyaXZWOEeg3O2pPnXKtdGgKZbMAdUjrUHiRGjPPYnoOKDSBM+dNLGGJa2KSZScuXBofwYdYEpyENanvAZP3Y60ZHXELO6nd57uNsic0XhziRjwrbSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769045962; c=relaxed/simple;
	bh=F8jNl9MJy+FljyVswI1PqcouiQUJLJvmdgG+R8if1CI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PHRpvozpm8H8AqwjU6pwNIF2zEAeosNUpMFfWngASaugMz/YEAkvF0tHHcxQFKTvy+dS2SV3sHUT3PAvPiOwN+2SqsDbCewIBwRMpN6aGyjw8XjihNLWNXXyuhyuUKZfABPWSHPRGCmjziP1kRYmN86hBBYNKiqfmOPcY/LJ8zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rhaPcPYT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rhaPcPYT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E3A0C4CEF1;
	Thu, 22 Jan 2026 01:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769045961;
	bh=F8jNl9MJy+FljyVswI1PqcouiQUJLJvmdgG+R8if1CI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rhaPcPYTKW3M4NYSGNJ/AAaFD5YyqQ8kPflsPBFkxT686wzWYdhnS7lc1ATUNTSRY
	 HPTCassKphXBWv9dxhaCZCPs+zqTmSo5d648vXA8Wur8zuBx7yTSt+5B0v1kRu9hdl
	 GvPVJ9NN06wn/RNFgjndI/nvRyZX4EEZrWvHcN9c6E7TgHQu3va5Cnjwfsj4A+UP73
	 yWLIH5SKaBQz9GX+sfHheTwOBtTGcbAbLJaEGhmt8SD/pJ71QBtdFFVZ3UyLwx9al+
	 KZtYpU2giDcvoYpYLncTEevLiOjN007zs+HmECk9SR9zcxaHOc/LGmw6OvMKeJ4PNk
	 gkNcI2mWfuqCg==
Date: Wed, 21 Jan 2026 17:39:20 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <allison.henderson@oracle.com>
Cc: "achender@kernel.org" <achender@kernel.org>, "rds-devel@oss.oracle.com"
 <rds-devel@oss.oracle.com>, "horms@kernel.org" <horms@kernel.org>,
 "edumazet@google.com" <edumazet@google.com>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 0/3] net/rds: RDS-TCP bug fix collection,
 subset 2: lock contention, state machine bugs, message drops
Message-ID: <20260121173920.71a093e5@kernel.org>
In-Reply-To: <83b05fbb38b2610b77d665850662a6f8c594f8cf.camel@oracle.com>
References: <20260118024911.1203224-1-achender@kernel.org>
	<20260120190913.20a16e15@kernel.org>
	<83b05fbb38b2610b77d665850662a6f8c594f8cf.camel@oracle.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 21 Jan 2026 17:50:19 +0000 Allison Henderson wrote:
> Sure, I will drop the "bug fixes" language and remove the Fixes tag
> from patch 2. Also, we noticed a potential race in patch 1, so I'm
> going to hold off on that patch for now. If that sounds good, I'll
> send v2  with those changes.

SG!
