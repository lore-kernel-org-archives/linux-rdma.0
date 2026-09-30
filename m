Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1C24CDDC6;
	Wed, 30 Sep 2026 12:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790769722; cv=none; b=pZnYuNjYr061F+Mjhixo5k3kgk1Qb7Z1kI6sX2QibQ4J7TT/OAa33UAbBcZjKMzm/er75hRLo5/EmT4vUT+0pkcfWzdIXjgBOtpIfdzchRr6hwF8aF/2AREeQcQ6Zr2k4kb6e8E4HpmEL9uZ0N6X1j80uetyzyj1V1fqzK35tZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790769722; c=relaxed/simple;
	bh=nF+t7BLz+zzxEB7N9ungKCfZcqviKWw+ZrER2NamY0A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Nrrrf+2Dic/7D8WRUTgqF4cSwF228Cm6iyb1lG29Ha2Now5+Lb0Rx6sX3eGSdni/mPZTGEVCgZfJYt/gDR7BurqbTYlxaw4ggmB0RJKwEfY8tTNXHOXWAI4aqZIaPIuUXxP2HmWMCoSC8HikqUNj1PFax1JmVx1klC1ysPuZTyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sb2cO92i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sb2cO92i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B251F000FF;
	Wed, 30 Sep 2026 12:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790769720;
	bh=3LNqUVYBKtBXN2PwwcWnzFFxB+aCMYTNCKruTEwKVIY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Sb2cO92ifyDNNrclYiEz9s8DjimDOsFGrR0/sgOUQzHOjOnExMjk7zBvYOT/7TmBw
	 bODEeVrqNmSU1e2eaLfv858eeR/W9NeCAWsCpmittLr3oUbaN9VUK14LrgUBsFO0mi
	 aFVVEFyDSud7RX43+diPsI7RQZVWOh7rnNrG7WvMaPNGco3P4SkTpMEAoNnbQTkhXq
	 /obrEEB/uzcmZ2EOEWlVZ6JCiwMJsFO7LgisStmyC+flexDHElxZbsPOvn8geKQiTs
	 /skv8hc2J/6Pt3oxtaPJIn+utFxZ+yb4OPOuNzePuxBk8HeDGau8SXcdoI5pF28QpY
	 IZyCqTdRcBomA==
From: Leon Romanovsky <leon@kernel.org>
To: dennis.dalessandro@cornelisnetworks.com, Jason Gunthorpe <jgg@ziepe.ca>, 
 Hongyan Xu <getshell@seu.edu.cn>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 jianhao.xu@seu.edu.cn, Leon Romanovsky <leon@kernel.org>
In-Reply-To: <20260928134148.977-1-getshell@seu.edu.cn>
References: <20260928134148.977-1-getshell@seu.edu.cn>
Subject: Re: [PATCH] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
Message-Id: <179076971729.227216.9009372867608054774.b4-ty@kernel.org>
Date: Wed, 30 Sep 2026 08:01:57 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 28 Sep 2026 21:41:48 +0800, Hongyan Xu wrote:
> The SDMA state reference and completion cover the software cleanup
> tasklet, but not the hardware cleanup tasklet, err_halt_worker, or
> flush_worker. Queued instances can therefore access an SDMA engine after
> per_sdma is released.
> 
> After the state machine has stopped, cancel err_halt_worker first
> because it can publish the hardware cleanup tasklet. Then kill that
> tasklet and drain the remaining flush work.
> 
> [...]

Applied, thanks!

[1/1] RDMA/hfi1: quiesce SDMA asynchronous cleanup on exit
      https://git.kernel.org/rdma/rdma/c/a57bf5ee252f5d

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

