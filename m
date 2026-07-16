Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C713CE49E;
	Thu, 16 Jul 2026 09:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193367; cv=none; b=qX5SNGsqLkm/icvFdL4P+l42QITLm9c4gprqlDXDp6cUpDf7ok1SjyitjizRNIr9mVNebcytMCtRyVvIagdQNBxo7at/4GYeX/MLAk2EH8FXRZvM20kYDRj2ig21JCgEd2ZAs1HYDlsyed+LzP11H/98Hmv77JAcS2QV0De2sFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193367; c=relaxed/simple;
	bh=dD2eqQ8WLOfYH+YqShvyCnYsZIiabqgbVv+bQb/OfXk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fGDvFDIbrDyQ3ALuOlxwujqUkI4UhaMUNzffuUN3dQ188es3GsvM3wt6FXFD3Rl6Cdcb6squsSSRabh3/zLIajQ7tmpmLchNobwhm59tirl1HKjTT5cubhREcgP/wTM/isCAlQiFi9FQX8zYJ8ToLaXAj5mxfPyMuHZy76u3+ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4AqT9ki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4AqT9ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F7D1F00A3F;
	Thu, 16 Jul 2026 09:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784193365;
	bh=UCmUnRzG8k5PIIGKjgr1uEw9my/9lPUk8PR50Fnayh8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=U4AqT9ki+EMghvAO/89VcheITnOeKGY5zuA1xa9+ZyBJLwYHuQ/jLESETcqNIJtpG
	 npxQkbSgl3uN6WEsIn/f/SXeG4YHjtj5Bw8sFmBbOI5/GyIMOvzekErqxI4CLORC5E
	 kk5GiQ6FUI59fqm/PyGR0ujAvYeALQBtvvz3AT7Ql02/hPw/VemG9rAmO8IKE7fBW5
	 CbfMLbYXXk5qJa5t/xISWCTu8vNMW/XcdFHWh7DnlqFDcc7oPnKw7s2gR5dHcVWsZf
	 eL4r7YMtnZvJUq0qGXLbYsinMgdjtFL/TXSssx7aOiYJEbLhhg1GA93lDis9ORnTel
	 o7FFWHAQ2vC3g==
From: Leon Romanovsky <leon@kernel.org>
To: kotaranov@microsoft.com, longli@microsoft.com, jgg@ziepe.ca, 
 Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260714123113.3792099-1-kotaranov@linux.microsoft.com>
References: <20260714123113.3792099-1-kotaranov@linux.microsoft.com>
Subject: Re: [PATCH rdma-next v3] RDMA/mana_ib: Adopt robust udata
Message-Id: <178419336295.313720.476565746425792364.b4-ty@kernel.org>
Date: Thu, 16 Jul 2026 05:16:02 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 14 Jul 2026 05:31:13 -0700, Konstantin Taranov wrote:
> Enable the uverbs robust udata interface in mana_ib by setting
> uverbs_robust_udata and converting the driver to the new udata
> handling model.

Applied, thanks!

[1/1] RDMA/mana_ib: Adopt robust udata
      https://git.kernel.org/rdma/rdma/c/bf8b3f48878ed7

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

