Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2993845CF;
	Mon, 23 Mar 2026 23:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774308056; cv=none; b=o3Bb8u0b/X3yevYYWURi/i/RBeSql4T9WUwCPAQvaSXRKgB7Yw96ovQmyQH8UeQKRBQcAfi+p3uexUPR71zIZp9Sv1JigyKdUIpdC1ZJnW9BwykQQA2Q0B/MUh5vcp+Ei9qK0bomnzhoYJNtVpGzL5xQL6XxRMYM+54riruD1qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774308056; c=relaxed/simple;
	bh=CXejRXkyFv8rzwbuR+qRhnfSeAcHAubW4BagLISel5c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bGkl6vLDavXf8oBX12g63rvz7MHG3YV2IzvggddLP092It8GIr52NqTcFlZAEQALqz7MFjPx489ybQshs2eN87N+u4ffmdhgb39IpU/U25FUEmBdXWS6C9EPZA5BF2rCIZvIZrpDwMQvNC6U62gpCJ3vp9qpawc5nqAnXoNDvf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdlTOt1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdlTOt1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CADCC4CEF7;
	Mon, 23 Mar 2026 23:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774308056;
	bh=CXejRXkyFv8rzwbuR+qRhnfSeAcHAubW4BagLISel5c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZdlTOt1MVA50vXHQJe1+nFkk5CqbYNEGEHbm1Jh/Zbvbs8K08YUviCmu7EibRkZV6
	 bb94ryBxk95AElS9QWgt1wWP4P56O+KGnzsw82Xa+o01uMWuZO5JoppSrVCl/Q5HL0
	 gt/Ey6dGjRO74d3MSJTkpnGBtzNnC/+5id2o7yo5y4zVDEAb20PmUtL3Z49BWLoggk
	 NgHoF07Tg5iV8d0qblBTT7euugeW2kFY7bWgWqqb/uo/TqF2b9N37m0QwIfpnqi0ac
	 N8psFvp2TG+lYLONfU0ghuKdwV/PRZc4greILDVF7Hq42eLVp7jZf/ZjtnXodPzF4L
	 o08Gjtn9Br5Ng==
Date: Mon, 23 Mar 2026 16:20:53 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, horms@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, andrew+netdev@lunn.ch,
 michael.chan@broadcom.com, pavan.chebbi@broadcom.com,
 anthony.l.nguyen@intel.com, przemyslaw.kitszel@intel.com,
 saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 alexanderduyck@fb.com, kernel-team@meta.com, johannes@sipsolutions.net,
 sd@queasysnail.net, jianbol@nvidia.com, dtatulea@nvidia.com,
 mohsin.bashr@gmail.com, jacob.e.keller@intel.com, willemb@google.com,
 skhawaja@google.com, bestswngs@gmail.com, aleksandr.loktionov@intel.com,
 kees@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
 linux-wireless@vger.kernel.org, linux-kselftest@vger.kernel.org,
 leon@kernel.org
Subject: Re: [PATCH net-next v3 01/13] net: add address list snapshot and
 reconciliation infrastructure
Message-ID: <20260323162053.62a148c2@kernel.org>
In-Reply-To: <20260320012501.2033548-2-sdf@fomichev.me>
References: <20260320012501.2033548-1-sdf@fomichev.me>
	<20260320012501.2033548-2-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Mar 2026 18:24:49 -0700 Stanislav Fomichev wrote:
> +EXPORT_SYMBOL(__hw_addr_list_snapshot);
> +EXPORT_SYMBOL(__hw_addr_list_reconcile);

Why?  For the kunit tests?
