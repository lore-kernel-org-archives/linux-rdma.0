Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B7E3A874C;
	Sun, 12 Jul 2026 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783855616; cv=none; b=q1NRHy3Us1CIob9xbFsmM0XlmILk9RuZt3//KNwreNvTAaa/3Oce2szowK/8oS9l3krMMd/jRCxO+N5aeK9e+ZokOAw8ibfMrjSS4wt3UbaICS9jE5chu3DSWTKgbRIcG/zDvK1Pw2Ahg4y+MseeuzyLYtZnsDQ5cLuv60GR8FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783855616; c=relaxed/simple;
	bh=NJFmXhs56sl0Ki/0UiUrVlqQmLNmiAf2fTGNjZrlWcU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=WTzlIa4LreHltfCouXkXu5X6HhlPNPRYJ3kq23Ot+0R3L6M98Z0INIWXaiLLUvQ09NRS+HqbENERyksYMNz8AnZDcp/uC6ZtZJ9pCoOBUce/1HYDMmv+PWE8dcX+yjIStpSNfp559EP470WSsLH6+hwWUC4fN3GNlx9y2S8hKZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krV6uiyo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krV6uiyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855E41F000E9;
	Sun, 12 Jul 2026 11:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783855615;
	bh=uOxqoWTWI956EmPvMQ8dXeVRuoljNi7+z9lw6eF6Zpw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=krV6uiyonq/iKHDZYZW/XFK1kalPAauIYBhWbNaFXStu8u30WXYEKsjd9+peXkCPb
	 CwF1LIWpS8W5sWuCZIQ1D9LvVXyH5zNPxEYfydCRGy0kjZZd3AP1beggj357vowUYx
	 CyMSSzITzabn7vWI3+tb0pC2//JZiAHLH7RaqAqhDl7sqZLPwvIfUHyoEZaQ8Nvw0f
	 77Locj0Hw8Ekht3cNSqXw7qaBC6hEXmJRhTRnDE2ij/hQLb1B+OarCoaYdpKs3NwmN
	 gvdqwAfBmK5f7AdCq+bQqViAyGTqnK/8EeqXcsSV3Y6NaOIRqyYUWjzqhl1AH3nUbt
	 ggUl2CGgpi7tQ==
From: Leon Romanovsky <leon@kernel.org>
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Allison Henderson <achender@kernel.org>
Cc: Bob Pearson <rpearsonhpe@gmail.com>, Ian Ziemba <ian.ziemba@hpe.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260711165419.13486-1-achender@kernel.org>
References: <20260711165419.13486-1-achender@kernel.org>
Subject: Re: [PATCH for-rc] RDMA/rxe: don't re-execute the current packet
 after the QP moved to error state
Message-Id: <178385561233.1568177.12923180855822763346.b4-ty@kernel.org>
Date: Sun, 12 Jul 2026 07:26:52 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 11 Jul 2026 09:54:19 -0700, Allison Henderson wrote:
> When do_complete() finds the QP in the error state it returns
> RESPST_CHK_RESOURCE.  Before commit 49dc9c1f0c7e ("RDMA/rxe: Cleanup
> reset state handling in rxe_resp.c") this was the flush loop:
> check_resource() had an error-state branch that fetched each remaining
> recv WQE and completed it with IB_WC_WR_FLUSH_ERR, without touching
> the current packet.  That commit removed the error-state branch from
> check_resource() (draining is now done at rxe_receiver() entry) but
> kept the do_complete() error-state return.
> 
> [...]

Applied, thanks!

[1/1] RDMA/rxe: don't re-execute the current packet after the QP moved to error state
      https://git.kernel.org/rdma/rdma/c/15ae32c4a3551c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

