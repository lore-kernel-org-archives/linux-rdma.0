Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BE368953;
	Sun, 22 Mar 2026 19:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774206002; cv=none; b=IbyGYixQRCMZItk+le09aNfgOC3IaROI70w/jtSO+YjqETZOWsl3I0VQdM3Pvo9N55ZoCAtrjxSi/j955hDqu8abknWeK35cH1eBrs9t2JoUwN8f4a3J4sfXU+P+L8ah5g5IvGy2cXBiVBPoZxDtDfDRj7noGvrXqhW+SiX3ALk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774206002; c=relaxed/simple;
	bh=ZRDhWJeQvAaw4EkBF1d1Dl0Q7zmGecvafge/6JhUKZc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=HkNDWwzYGO+og+GitpbtrPKFKZBeU8PD3okljgatEaVyeQSII2WnaFAKc6IVnzPstVCaGd2sQ61NyIu9ruFLijiK/W4Hnt0jHU3aXtKuo9Q3w8xphUKZ7MnE9eZFbi9Cj6pD2MLYRvNTxNtTf1R4q8jYBHHkHgMmOcD6ojWgnms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoH+Nu+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoH+Nu+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A8FC19424;
	Sun, 22 Mar 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774206002;
	bh=ZRDhWJeQvAaw4EkBF1d1Dl0Q7zmGecvafge/6JhUKZc=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=VoH+Nu+OT1aGy8tPMM1jYTYvAvxTZGAO5fy97F1uIJ7vntfUesisX/y4fo44z5lMm
	 2l/h0/qVezWp9nm578nlYvsfvnNXPKiRzepVOZ/hBpNt5FPbwBmqFxcQDtY9XxGY7d
	 FmAyLGwLY8bMEhsGOqeiB/5NBc/T/+9mnth4OmfaFV2PfaVOiZSGxpZg2IFMnG9Jop
	 To7EHKuNyK55cYTbFlODxVCC3Y+TEm1Andp45DEAgM1CPKf53eekhfDJioxzAmiW+H
	 kweKjhpTCpTCoGrmi3HRDvbpOAOKkkLVYgdgae/Lh1Z8fLIZxOouTpiL4lgNB2HiSU
	 nAJYAMDlNtSYA==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, edwards@nvidia.com, yishaih@nvidia.com, parav@nvidia.com, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg, 
 ratnadiraw@smu.edu.sg
In-Reply-To: <20260321105859.7642-1-kexinsun@smail.nju.edu.cn>
References: <20260321105859.7642-1-kexinsun@smail.nju.edu.cn>
Subject: Re: [PATCH] RDMA/uverbs: update outdated reference to
 remove_commit_idr_uobject()
Message-Id: <177420599924.2048487.13855873772341432003.b4-ty@kernel.org>
Date: Sun, 22 Mar 2026 14:59:59 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sat, 21 Mar 2026 18:58:59 +0800, Kexin Sun wrote:
> The function remove_commit_idr_uobject() was split into
> destroy_hw_idr_uobject() and remove_handle_idr_uobject() by
> commit 0f50d88a6e9a ("IB/uverbs: Allow all DESTROY commands
> to succeed after disassociate").  The kref put that the
> comment refers to now lives in remove_handle_idr_uobject().
> Update the stale reference.
> 
> [...]

Applied, thanks!

[1/1] RDMA/uverbs: update outdated reference to remove_commit_idr_uobject()
      https://git.kernel.org/rdma/rdma/c/3909d195fe68eb

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

