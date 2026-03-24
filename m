Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93D1273463;
	Tue, 24 Mar 2026 05:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774328917; cv=none; b=odFU4tLVBuk66eR8AQZ0CVDF0LQC8DMC9kER/LH25il7v0jtvQDRk4anQcHdvkS4XCI+rKvkOOnwgt45GWM4SVSFkXObSExz5lbe4ZJ3ZHtzTbeJa/Po/xk4fXCcUq1ezIzGftvsRPmjRo+tBPKzX57EiwSlE3U9czH//ybzylo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774328917; c=relaxed/simple;
	bh=gensSJkkbItzXPGHFzkl4bzLWidLsQJ8foS8QlykhB4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=rw4FLujZ2z/Zb9F2/SpeJ0X8sOlLhT1cCEChDUjIy/fAnTtOJryo1bhJEFW3McuXL83gxjmNgUrw3dBOZawTsduTjlq7rfa7pnq0zYs/gd+5KN33CA4apZtqdNIFkFa30lrzVRUC62ZsLvQ+We0zEQoywuaUTCwfCOYsJlsLQ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STPsnJna; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STPsnJna"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5489C19424;
	Tue, 24 Mar 2026 05:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774328917;
	bh=gensSJkkbItzXPGHFzkl4bzLWidLsQJ8foS8QlykhB4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=STPsnJnaEQAgN/Gy5XC3qLYXTgGpv4JX63bkg8cLQgJ4WjwUequ5ZYGhGikYgdpf4
	 ancViRJKpe6q5tTLEckL3/Lcr7ISHTek8RSLNsHWCzZA6TOsTtx+Zh9SGvudQ8yRII
	 KSAr60uYTvu8L/5e6OchRxmgnzBQCzDMyjol8++/OY0oo+eQbBL1cA3+xWMwVUG3lQ
	 8JxxWwrU3dkZ70IPCEJ95M44CkYfF1nF0qTXOk9Pf86a2T32ZlzZIDlzu+wFSvVx5E
	 12dUdwP7Q8MzmEFoi7dSlN12pqz+vknmtVIOkGwbxP20xc7Y4ePg91G+W2t84EIkSx
	 SHb2g/uOH4dkQ==
From: Leon Romanovsky <leon@kernel.org>
To: Kexin Sun <kexinsun@smail.nju.edu.cn>
Cc: dennis.dalessandro@cornelisnetworks.com, jgg@ziepe.ca, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 julia.lawall@inria.fr, xutong.ma@inria.fr, yunbolyu@smu.edu.sg, 
 ratnadiraw@smu.edu.sg
In-Reply-To: <20260323134450.2478-1-kexinsun@smail.nju.edu.cn>
References: <20260323134450.2478-1-kexinsun@smail.nju.edu.cn>
Subject: Re: [PATCH v2] RDMA: remove outdated comments referencing
 hfi1_destroy_qp()
Message-Id: <177432891430.2473728.10634895324050330495.b4-ty@kernel.org>
Date: Tue, 24 Mar 2026 01:08:34 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 23 Mar 2026 21:44:50 +0800, Kexin Sun wrote:
> The function hfi1_destroy_qp() was removed in commit
> 75261cc6ab66 ("staging/rdma/hfi1: Remove destroy qp verb") in
> favor of the rdmavt generic rvt_destroy_qp().  Two comments
> still reference hfi1_destroy_qp() as the waiter that
> rvt_put_qp() will wake up.  As Leon Romanovsky noted, these
> comments add no value.  Remove them.
> 
> [...]

Applied, thanks!

[1/1] RDMA: remove outdated comments referencing hfi1_destroy_qp()
      https://git.kernel.org/rdma/rdma/c/05eec2a60c7909

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

