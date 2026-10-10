Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08FB3164AA;
	Sat, 10 Oct 2026 10:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.60.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791628528; cv=none; b=jbXcCrzNuBO+Xqls2wMa8weM4saKA5IT83/RIR3nWJfPXs0LyMOtQCj2ChbOxgBx4hGLQPiUi1uHHGlbiednOWDX/fICxI+Y/H4cqKldesCT4ghGljF/8o7gPjUFZQ7xJtTo8n2jz3RdEfTz6Uy1BRC2BAlFb5Jo8EjK3ur51iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791628528; c=relaxed/simple;
	bh=CxYjDoDi1IBAPk7Vw2W4+iZXNvVefHGrj6UhQ2uHz38=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oF5jGSWGYnRj1t/1wlLEY24DeGhMBp8QCT9li1oKCCDzDVhN9yLnuvxKwziOAVmFBueo7tEa+wlA16ZSq1AiLI9GeJ7cLdxqrFnu8b5BMOHZgoDCCCOR7fL8+cTour73x2bZOS2b2Q+V7Q+5GfA3CJ9aoYoJY7RDdKLKK8Bhsjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr; spf=pass smtp.mailfrom=corp.free.fr; dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b=E+lLVf5V; arc=none smtp.client-ip=212.27.60.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.b="E+lLVf5V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1791628525; bh=CxYjDoDi1IBAPk7Vw2W4+iZXNvVefHGrj6UhQ2uHz38=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E+lLVf5Vv/FxBcFs33K7PURs8atbZmkDZHetka+uo374W2puub37ltCpjxTHkIc6A
	 zdP+1pTyVO3O90NHpfaylpo5N4UPJRfXO2HiBqFgk48Ll+NWvY/DZjTSrgQV6h6IiK
	 8o94LBaW/9oy7S7GW7wRgPEHyz9ygwIEywZIF8zIHxW09NES05QHllVNIKjENKp/TY
	 OitUgUmRMAZsKgvaRTdN7vvgyps+qoHImxgLnmmTb9ALVzy9ppxafq1wEtnST//dKa
	 fIow2+9Ej3d9rd/LTpMeJbEQu1WqR9zww2qnI2bWmBV9kgK0cUhJnq4x6vslIkTWnS
	 8OD55ilykO3Xw==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 1868644C08F0;
	Sat, 10 Oct 2026 12:35:24 +0200 (CEST)
Message-ID: <3a18d136-36a5-4edf-a3df-0838d119c38e@corp.free.fr>
Date: Sat, 10 Oct 2026 12:35:23 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 2/2] net/mlx5: HWS, fix modify header pool creation
 race
To: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 sashiko-reviews@lists.linux.dev
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Moshe Shemesh <moshe@nvidia.com>, Yevgeny Kliteynik <kliteyn@nvidia.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261008204230.3222198-1-acassen@corp.free.fr>
 <20261008204230.3222198-3-acassen@corp.free.fr>
 <sashiko-outbox-166055@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <sashiko-outbox-166055@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

(replying to Sashiko... strange feeling)

Adding back original recipients. Sashiko review at:
https://sashiko.dev/#/patchset/20261008204230.3222198-1-acassen@corp.free.fr?part=2


On 10/9/26 22:43, sashiko-bot@kernel.org wrote:
> Does mlx5_fs_hws_mh_pool_match() incorrectly truncate 64-bit modify actions to
> 32 bits during comparison?
This code predates the patch. On little-endian the cast keeps the first
half of each action. That half holds the type and field. Dropping the
value in the second half is intended since each rule passes its values
as arguments. mlx5hws_pat_compare_pattern() does the same.

but there is a real bug. Copy and add_field actions keep their 
destination in the second half. The core compares them in full but the 
pool match does not. Two copies that differ only in destination then
share a pool and the second rule writes to the wrong field. RDMA flow
actions can trigger it from userspace.

I will send a separate fix for this.

-- Alexandre
