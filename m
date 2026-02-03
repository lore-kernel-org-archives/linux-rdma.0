Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AD627F732;
	Tue,  3 Feb 2026 01:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770083720; cv=none; b=MvmGS8HNB9TjtGNIY9Gi6JwMowWWWQT1g0B59+hQ+8g7f9KeLX8pS9lGfCDgP6LFuj0sKIrUrHr6FzE8GcZiOzploQxEyGcnJ+P4GWOUUCgW2EKMdkuTuy2c4n8r/yRel1/C7VdZFdXAG402DlIvvEZo8RfFeFcsKVRTAyYMG+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770083720; c=relaxed/simple;
	bh=R8CGk6PDP6sgpNbJx4Cq0OJL4tkAgINd7ZG8ji4p5RE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DrHdpQciSkqQM3pkPlbkMsMmDl/RccOt/xlyFDmjHrx2OLtuhIl3EOQIjjrNQAeELC0AU7HPBOBvELJntSCKQvH6cp8Euvqr5n6OhTs+gQ9TmHB37xk6y06miIzuRE4pakdgvQZkFoxymaC2kr9iiDGIQCgJryVvAIlMkx/CysA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AnF8xjvz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AnF8xjvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AE1C116C6;
	Tue,  3 Feb 2026 01:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770083719;
	bh=R8CGk6PDP6sgpNbJx4Cq0OJL4tkAgINd7ZG8ji4p5RE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AnF8xjvz1z9kWgdNnWsahOmer26W8oirW5cy5VjAPfRsbO4FiRWCGa4Hic29M1MX9
	 Q6R5rpeFEal3uSRgcqyg79ZFbfQKMc8+4b9bi5cSuBx7KtZKSoIprZDufrPOLYiwHO
	 p1bIAYwMzbArUV2Xc+XvxcPBcO2e/Mqd82AwXtKvPBRduP+wR9svVFijQ9bj1Agguf
	 NqlW+UilbYXfzMDfOHJrdIVi2vhS/ywRkrEkrAEHb4cvp12Cre6rDTtJzqQSUS7CLE
	 7TjntTxRQ4dQL7c4C8E7XfxoDHym0olmsWpo64qVa/KGGYv6/Hm5md7DMHfKT2l9Ti
	 n4JU9VEVfcLmg==
Date: Mon, 2 Feb 2026 17:55:18 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 pabeni@redhat.com, edumazet@google.com, rds-devel@oss.oracle.com,
 horms@kernel.org, linux-rdma@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH net-next v4 8/8] net/rds: Trigger rds_send_ping() more
 than once
Message-ID: <20260202175518.3b207c5e@kernel.org>
In-Reply-To: <20260131012507.814119-9-achender@kernel.org>
References: <20260131012507.814119-1-achender@kernel.org>
	<20260131012507.814119-9-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 30 Jan 2026 18:25:07 -0700 Allison Henderson wrote:
> From: Original Author <email@example.com>

Hi Allison, just noticed this From, I think you'll need to respin.
-- 
pw-bot: cr
