Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C157471D1F;
	Sun, 20 Sep 2026 17:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926652; cv=none; b=VY0Lx9I+MPVrJ4buJ+RE3DjLNCAi5MmgcsdqTa3ZCnRkDYdkpj1/HsckVI/Y4BpX2efVSSmID/o0z3iY7XyHrAL1CMg8T7ZhwZWl4qZSScNRE4XpVogMAnawjzr6U9gTdbReoxskuu8ZHot2VI7kqctKHE7Svh2uJeu7Re5b1I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926652; c=relaxed/simple;
	bh=4m1GXz6a1xOtAP/TVGNzaxyLhRp364jMk+9zi4fcjvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q49ud8cyMw4YdFaLNyywgzloNsCdicxNFKE67Q6kgRmERzpFsmfV8SZf8io0hd8c/8JzYH613GwSHH8OU3YlLtt/67PUBk2O9hDxC5TlmLJ5ZRcviw+3CyC4bTV2Y51zpQIklXZd7IVUvnOXHaMJpqKP52W42lqIY9ht30J0SGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQ8+Bkl9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQ8+Bkl9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EE291F00898;
	Sun, 20 Sep 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926651;
	bh=+m0b3LGQSx/lLKOTPekaAGlv/MnmrW6aY+li3UbTmjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQ8+Bkl97sSUVkikZRBkzqYaIH+KSiTYzf5uywVpOTKhygoz3clvAnoT/iz+Rb9xU
	 cfXAGmJTf4KMz401qZisHlZXKnyQ8LjF6wJY58iPLWFb/vj5Fbn4+1CODD7i7W8Luy
	 ryiEm7uQA0K/KU++EdhuWUYTmiDxr1ndB2LB8c3YbKszFeDNhWxMyUMLwrkcA+RYAC
	 24oFR8MTSFgmw8oQTtuHBrDKW6gUCN6kv4zjSuP0Alhd4hzFbf+PFAg8cRDCSqchF+
	 Y0kW3Fe2N5w7rGoy0yHcNmR3xjtth9C4ntVM2mKj+2xjwqQ8YcIrhnlZrKIvQfT/lv
	 whFhYgk5Sh+8A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	guangguan.wang@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	Junjie Cao <junjie.cao@intel.com>
Subject: Re: [PATCH 5.10.y 0/2] net/smc: bound v2 extension offsets and counts in CLC proposal
Date: Sun, 20 Sep 2026 13:50:34 -0400
Message-ID: <2026-09-20-daily-reply-0002-re-net-smc-clc-proposal-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260920051403.712116-1-junjie.cao@intel.com>
References: <20260920051403.712116-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> 5.10.y also lacks 9ab332deb671 (CVE-2024-47408) from the same upstream
> series; 5.15.y has it since v5.15.176. It goes first: the ism_gid_cnt
> limit in patch 2 bounds the gidchid[] walk only once smcd_v2_ext
> itself is inside the receive buffer.

Queued the series for 5.10, thanks. The 5.15 half went in alongside it,
so the two trees are back in step.

-- 
Thanks,
Sasha
