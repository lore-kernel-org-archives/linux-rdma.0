Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0C74D4860;
	Mon, 28 Sep 2026 19:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790622117; cv=none; b=H58OoBKdVWhzX9aijDS96gSImAd3NgsSxKrNiCuMbBNWloOOSU04hdQIk7b+LgbKRVLCJ4WxLGDZ+sCtVpSMo0jNX5wtN1E9Q8yn6ajZzLIz0yXhDnhFsIeC/f1RP48axHkZNAhgbulgg9V4b8dWw6EAPB6asLtX/91g/fvMrG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790622117; c=relaxed/simple;
	bh=vFgJqxqFOP0Q40hrf9HunNgC9nUPL6lDIJm2xW8CLIY=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HDYGQgm05WMBhnMvPTQnYTkuIR3e5lsOmwJ0AJEftTHdAyoYiYqg8TLzoleF0v0d525rcIvaUQ8eqfecsYZJkawOroPBULYK5UVvqzT03BiIMJAiEYlKFiYv6ylD9RsBmVxHrPbMZgQDqTQu4DjGM1ve8JwrsQjnXC3kCspT5pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O89Btx/F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O89Btx/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DC11F000FF;
	Mon, 28 Sep 2026 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790622116;
	bh=GTCPxf8Pg31/dIR73pZbR4szs2hgqnh8hWFW+iuRaEI=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=O89Btx/FxnfKbxg5kvYHbcDfGo5YCnohAN2ksj084KHw1NnJK3w4p22sJ8iW5RFF2
	 PtEO+4Sh/zV1kiHmgHQpswJzG4F9xYH7Mgd2Q6fxCfFujPzbfhJ8gWNChnNpW+3f8Q
	 xWbdwTU9W5NpNTK77eTvUCk9B3AO3VukaP4GUvS4ff+PX2OoSwLrgSkcbyr1o5RVSi
	 qqpzhGER7nwcnIC0RuilyGHJD8OtJ7W/vvS5nJO9QBeUGVSlfWiBxZixwHpibSAofP
	 aSO2ZQikswuURw4pMNw97LPpCmWYelDIV15d/hHDd9NHJmBBXkbdSrVcmSQF9X/SxW
	 6IFgpQ8sXv+bg==
From: Leon Romanovsky <leon@kernel.org>
To: Sagi Grimberg <sagi@grimberg.me>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Jenny Derzhavetz <jennyf@mellanox.com>, 
 Nicholas Bellinger <nab@linux-iscsi.org>, linux-rdma@vger.kernel.org, 
 target-devel@vger.kernel.org, lirongqing <lirongqing@baidu.com>
In-Reply-To: <20260921031100.2199-1-lirongqing@baidu.com>
References: <20260921031100.2199-1-lirongqing@baidu.com>
Subject: Re: [PATCH] IB/isert: Don't share drop_cmd_list across concurrent
 connection teardowns
Message-Id: <179062211311.3939514.108950860534877462.b4-ty@kernel.org>
Date: Mon, 28 Sep 2026 15:01:53 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 21 Sep 2026 11:11:00 +0800, lirongqing wrote:
> isert_put_unsol_pending_cmds() declares drop_cmd_list as a static
> LIST_HEAD, so the list is shared across all invocations of the function.
> It is called from isert_wait_conn(), the per-connection .iscsit_wait_conn
> transport callback, which runs independently for each connection during
> teardown.
> 
> conn->cmd_lock only protects each connection's own conn_cmd_list, not the
> shared drop_cmd_list.  If two connections tear down at the same time, both
> threads list_move_tail() commands into the same drop_cmd_list without any
> mutual exclusion, and then both iterate and list_del/put it concurrently.
> This corrupts the linked list and can double-free iscsit_cmd structures.
> 
> [...]

Applied, thanks!

[1/1] IB/isert: Don't share drop_cmd_list across concurrent connection teardowns
      https://git.kernel.org/rdma/rdma/c/d30e9b1bc47bd9

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

