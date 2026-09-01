Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26C146A5EC
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 07:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788248003; cv=none; b=bDhEYKOJ+NVnwkns3NbiumeJkRN75TZxmQvxqXhO1TYlTqkPls2L0eeJd2CZRF3WWxPhCu61RvWRVgE2yh6iqIztZc9ZuynvMTUkgUJniZNwqQoXoIM38zLjpajR3eRZ75ux5AlKPJ/83ee22r2d+HlY1fdmaWLAGOkjwHwYn5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788248003; c=relaxed/simple;
	bh=vaQsn5S9Z4OFDgwAu40uKk01dILl4IqA0Bo5brqk53s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=B3cUBBQ5MBT7/rNbF5VbJVfGRIaIV/8zKHW7hcub35qQ05pG2CH+Ohm9uq2NS3M/k2qyRXoEmERqieTQdmNuRdFVvGmGNgWrYcsT0BX3k/EAPrw9qOE6IyPlS9GHt25wwyxmZ4TmFmu4nw0+UbIEtkVlF13aa17RHk5Whi8/+0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NsryLHr4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NsryLHr4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E433C1F000E9;
	Tue,  1 Sep 2026 07:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788248002;
	bh=zO/r9rewX/dlesFPEOqeIEqVxbPW6Tc+EDkKU03YngU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=NsryLHr4LvZUuMn8w3ty8Oy8GVsPJAPhLAKEoaL+wweLu9j4vEgZ9HavpUYn1eS+C
	 yywBG+K1KdjElh9iO330m3xspFiozdxzEnQA+cNHG+RI+3rMlqq8gaGSLcSwGWJ03I
	 O0fSJGTjpLoR6qH0Y9Ov+9YUNqo+r2wSb0h312U6mpdbBDXkmOGj658nN1qFs7zg9R
	 mgjGm/X9q1a+FZ5SUv6kbzl+I799EROq3VuLG3g3oENTmi1Q2IZhkTnOiIO2/csbCa
	 pfvPZXqBRDDkTICGitOjKjibJrVWpZrkhvxjJqV/YFvvWh3gju+WDIjp4Qa5u6vQsV
	 vhpT3l5AhbzWA==
From: Leon Romanovsky <leon@kernel.org>
To: bernard.metzler@linux.dev, jgg@ziepe.ca, 
 Guoqing Jiang <guoqing.jiang@linux.dev>
Cc: linux-rdma@vger.kernel.org, shuangpeng.kernel@gmail.com
In-Reply-To: <20260827125553.12831-1-guoqing.jiang@linux.dev>
References: <20260827125553.12831-1-guoqing.jiang@linux.dev>
Subject: Re: [PATCH v2] RDMA/siw: Clear association under lock if
 siw_qp_modify fails in siw_accept
Message-Id: <178824799963.1082236.2000808272690080766.b4-ty@kernel.org>
Date: Tue, 01 Sep 2026 03:33:19 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 27 Aug 2026 20:55:53 +0800, Guoqing Jiang wrote:
> We need to clear cep before release state_lock as siw_qp_llp_close and
> siw_qp_modify->siw_qp_llp_close did.
> 
> Otherwise if siw_qp_modify() fails in siw_accept(), the QP's state_lock
> is released before the error path cleanup. A concurrent ibv_modify_qp()
> transitioning the QP to ERROR can race in this window:
> 
> [...]

Applied, thanks!

[1/1] RDMA/siw: Clear association under lock if siw_qp_modify fails in siw_accept
      https://git.kernel.org/rdma/rdma/c/32cd87f54dd107

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

