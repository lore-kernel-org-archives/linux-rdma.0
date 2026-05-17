Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183E120CCDC;
	Sun, 17 May 2026 16:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779034048; cv=none; b=ahPY3bdH+S7BRXV/cINhha++Gdc86KLPBAD/7/mexo4eC8ayH3FtedxBzMlG7j6FuwuGAfG6OLLHS2vcUrW4cwFb+MUHYYWEb9ytR7K5REWWlcwRwhAHhWfE0cFEmtsvp5UPxcZPpNTtN6029LiJuxX6tIqnqwmZiBKBECBdOzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779034048; c=relaxed/simple;
	bh=XSszjgK65hBpLVmkbK2HuZkihV//fU+bBUxzxGh1Quk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=m6Rjsob3KbM7KL9uahtmTBjxBw+gtwJInR07FFYJJl8ySXBYBycTfF9zhL5ppqvFWyBfT1LaoGkiiTohWemQmpAE2bKcz8tyDppJecR++6cWAxE9C5Xj0BSyiPV9pOwI1+oW4VzlgVWrPK5N4aYCoQpAtjQEx8hji74aEPR9ZCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GUSI5VEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GUSI5VEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5F2C2BCB0;
	Sun, 17 May 2026 16:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779034047;
	bh=XSszjgK65hBpLVmkbK2HuZkihV//fU+bBUxzxGh1Quk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=GUSI5VEyq8lawBdV9VE1xQz9poqyL4vRZnfoG7vcE8TxoEFm8/cnc/dmr4GNWIz3a
	 HbYQnQcFNKHr+oWFF3a0VFqyPG3BNGUPUh306AkrKn0Jmb/XbiQ58xnLmbL6ZAl52s
	 zjJ67Xffnd5RgRTsc7fdJubR0BWywDFODA3thUVWhFA51lA2S+eH7ulZvbd/Wk2GWv
	 GumnQVMY+DuQL+rKd6GILiLQWrjzYEoHjq2kRgkPqyOhqo2tYkHNpyCp1hczjGxddi
	 HQVwI+MIATY5wfkShui3aSjp71eKPWE8+iwJxE9HHhXKFb+w52uA4kBYcDK8dDzTLl
	 b6quXwjtfBvrw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, 
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, 
 linux-rdma@vger.kernel.org
In-Reply-To: <6acd9c8a79b868b5e541a7e080a6b4b145e4fd4f.1778923041.git.christophe.jaillet@wanadoo.fr>
References: <6acd9c8a79b868b5e541a7e080a6b4b145e4fd4f.1778923041.git.christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] RDMA/cma: Constify struct configfs_item_operations and
 configfs_group_operations
Message-Id: <177903404471.2530582.12087012477556433788.b4-ty@kernel.org>
Date: Sun, 17 May 2026 12:07:24 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 16 May 2026 11:17:47 +0200, Christophe JAILLET wrote:
> 'struct configfs_item_operations' and 'configfs_group_operations' are not
> modified in this driver.
> 
> Constifying these structures moves some data to a read-only section, so
> increases overall security, especially when the structure holds some
> function pointers.
> 
> [...]

Applied, thanks!

[1/1] RDMA/cma: Constify struct configfs_item_operations and configfs_group_operations
      https://git.kernel.org/rdma/rdma/c/7b2e9a338a5875

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

