Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FA235AC14;
	Thu,  8 Oct 2026 16:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791478130; cv=none; b=mJnon0+SYRzQvlwxk2b6HKb2QVZqAMTvVEk1xAn/yu9xuY0HRVH5I2vOTzoju68zgLAXlATC9pV3v0xprLgLJ1WmGiXDdap6Mulg/ZFKw699Dw5zBHkLiIZI/l/BtYi2XSy1IVMUxlGo+j8MM9bkT7cSz8tKsxCs+SBNke+Tad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791478130; c=relaxed/simple;
	bh=EF5xY46LfyUTJu8Mh/pThdOJ6vezkuQ2VNtZ622p4V0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQOD3Q7/Xu4urPZknoRshsOop7EAaybdB9eWVt4JGugUuzfJ8LYJM510JjxiSy++qjUdCwjSfTCCDGELI7fbfCkkoj1mGxwyae9HXWJk1Jp0DcTF0XQ9tJArQmntoz1inuzZanmdpjAiZp64HM2KxySpm8+lWq6F5s/8kK6D3Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R79PWTOu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R79PWTOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562721F00893;
	Thu,  8 Oct 2026 16:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791478128;
	bh=FAFlhxzLp1BJAR8yVqOst5oB6CdwOFl5FMn14SpR6TI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=R79PWTOuzHKIfL5VG4/Lh5oJUEmFP5wHoF9Tp2Wi/pv4sWdDtbGxY+lwrhJ6X96MS
	 49Gt+NsFP26hIOtsPjzNb/EqPmjmQ8nt68caXiYFrel4wnNEPmWmYbjHo5gokRKBPC
	 UMItGIiUOUagutflLjm44p2SavrWgfuuyg8SeLF7INFl49gOUOw2yr90l70FdgMW0W
	 iOJ39YcW66uoHwowdiWkszdZeG18ZpV4sk1wjnqYhBDeo+fwwd40TzXEqhgGED94+9
	 TY8NLW+KPcEas+IA6WVfq/750/A6eOzB6Ld8dxlbFVYJVNzz6RdmvQWGHavHJpWFNt
	 t2WFxpmzVQnig==
Date: Thu, 8 Oct 2026 09:48:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: netdev-bot+sashiko@kernel.org
Cc: tariqt@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
 gal@nvidia.com, leon@kernel.org, linux-kernel@vger.kernel.org,
 linux-rdma@vger.kernel.org, mbloch@nvidia.com, ohartoov@nvidia.com,
 saeedm@nvidia.com, shayd@nvidia.com
Subject: Re: [PATCH net] net/mlx5: Lag, only cache max_tx_speed that FW has
 not accepted
Message-ID: <20261008094847.46b9b72f@kernel.org>
In-Reply-To: <179118614831.434549.13938965801473464638@kernel.org>
References: <20261004070246.215239-1-tariqt@nvidia.com>
	<179118614831.434549.13938965801473464638@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Oct 2026 07:42:28 +0000 netdev-bot+sashiko@kernel.org wrote:
> - [Medium] This patch breaks the query-failure fallback added by commit
>   ad0ae7aefa7a ("net/mlx5: E-Switch, preserve max tx speed on vport=E2=80=
=A6
> - [Medium] The commit message does not match the code change.

Can y'all comment please? It's been 3 days
