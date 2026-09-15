Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425893B1EF2
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 13:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789479769; cv=none; b=fBwf22b192F4vzQWAr1iQ0OwcswybrFHaONzPZfL1FJJCO4EJG1osjijdiWc80Ju+dJE1Mr+WGa78ZQQT6LWk4w+/KBocWUdCJimvBGsWQXVKy83Ou+0ngXW8MTF7Mfy+gST6iBNYJggko09ytAuR8xBJ6AQ8UWYK0whoEWeUyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789479769; c=relaxed/simple;
	bh=WD4rcvPW7Dk/aPhDJu1nE7KhgoUUUZKsfeK1QM7Shr4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=fefXe0pP4g7KF+GcKkOJutFbNUsLXe7BP/chXATe0UIylhvIr9ds+++r9UfsLmmGl51A57eqvqAGXGnuJ7YeWokMY7V5gZxq9jQwkM+JZaBL0+Q7aJWK4ihyUeBlaUwfsD3sS0rHe3riJK5toBzDv3z220uPPRd5JIUXZ8AuRDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWMmwCLh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWMmwCLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E131F000FF;
	Tue, 15 Sep 2026 13:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479767;
	bh=cq0Ih4C3NaSyqvhCYznt0cQCyDjc5MBkFMF2XaZzR6o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LWMmwCLh2I0FEot2p8xW/E19OblVGZ7WnbnZZte3v8FDYLOWOAWifqK3mjvf4Xol2
	 yGVNtGCvR3YQ+armyWj9daH9ZjO7aUBwVsmloCZkCXaWrgCJx6SLTRf4HoGA0+QPDw
	 tXBAdqqNXzbjnJxdmy1RK44mY61xHfArzUwFlNfnYf7sbBmeP7KDTehdw9Y6z+WPbj
	 nq7n/fTdaA0IUwsjkU8B056IkPO+CIBU6OJHrZb0ylLrV86bUAMibnniQLEk7RlaJl
	 Om43uJ3bfJB+HGfUmQb+MUQcfaI0NvQichaASLdGUnagBD3wGpBoTcfHKosPVrD843
	 XQBPtBc9zqisA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 Junxian Huang <huangjunxian6@hisilicon.com>
Cc: tangchengchang@huawei.com, linuxarm@huawei.com
In-Reply-To: <20260914024800.132429-1-huangjunxian6@hisilicon.com>
References: <20260914024800.132429-1-huangjunxian6@hisilicon.com>
Subject: Re: [PATCH for-rc] RDMA/hns: Fix the use of uninitialized variable
Message-Id: <178947976495.1319609.13551697309484090889.b4-ty@kernel.org>
Date: Tue, 15 Sep 2026 09:42:44 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 14 Sep 2026 10:48:00 +0800, Junxian Huang wrote:
> The variable 'i' is used without being initialized in active-backup
> mode.

Applied, thanks!

[1/1] RDMA/hns: Fix the use of uninitialized variable
      https://git.kernel.org/rdma/rdma/c/653c5b4605f653

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

