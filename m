Received: from mta1.migadu.com (out-231.mta1.migadu.com [95.215.58.231])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365E733508E
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 03:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.231
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790567465; cv=none; b=fbdefWbbMp6sbL/Psf8Mi9kNl9S2EewEln24qgLWbnUsjiTV7vyvGVlWifxTE1SIRzUX4xTBShhD4pUNpsnnEnPmN1ujv+XFbSvO8SmLs8gQ8zPWIMWKkbeV4tyI1gi8hgD8N1Y5cdUW9MHUW5HziDVxjX3EiHqT1bj+tY6m0lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790567465; c=relaxed/simple;
	bh=qJckOsQEo+P6Q3TxXb+3mRRw8bbwMJ3dFYvm27FlOC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r98jP8gBO/qLwqsAg5kVmn4qcdT6hhDdPH+fBKemHLqW2CfAAQq4uD+5caBcNknO9YgeSatLusoQQ4mcuU6tGxvNxquBQtI3ufvfMgVkhbHrY3glZvY0A3T/vjKuz7D8PJJ7VIJdz5KGXT160HEGfGqqHBu7JTMkbPeVmo41/7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Dwn5oOlV; arc=none smtp.client-ip=95.215.58.231
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Dwn5oOlV"
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qJckOsQEo+P6Q3TxXb+3mRRw8bbwMJ3dFYvm27FlOC0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790567461; v=1; x=1791172261;
 b=Dwn5oOlVXwMuc8K15rBpjuuUXd/PUnWpcIXabWE2MB0spRnZquKQ4qZ4ggf1KbPFrt25VTLN
 eo+6OaSS0++mBTn1LHZF+Wv0vvWP9vM3VCRO89NSCrnIwKc+yLoFFBJxnrUr6ayg1RuqtFMlhi/
 hjbtqyYkLVFJE14eB8kBcgc4=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5b926d13267ff78e;
	Mon, 28 Sep 2026 03:51:00 +0000
X-Mizu-Trace-ID: 5b926d13267ff78e
X-Migadu-Flow: FLOW_OUT
Message-ID: <2f03544b-b503-4339-9b2f-234dcdb9a03e@linux.dev>
Date: Sun, 27 Sep 2026 20:50:55 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/selftests: Fix the kernel config fragment
To: Sasha Levin <sashal@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Shuah Khan <shuah@kernel.org>,
 David Ahern <dsahern@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260927161655.1184153-1-sashal@kernel.org>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20260927161655.1184153-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/9/27 9:16, Sasha Levin 写道:
> The config fragment lists bare option names with no values:
>
>    CONFIG_TUN
>    CONFIG_VETH
>    CONFIG_DUMMY
>    CONFIG_NET_NS
>    CONFIG_RDMA_RXE
>
> which is not valid Kconfig syntax. When the fragment is merged, for
> example by "make kselftest-merge" or by CI systems, the lines are
> rejected:
>
>    .config:5514:warning: unexpected data: CONFIG_TUN
>    .config:5515:warning: unexpected data: CONFIG_VETH
>    .config:5516:warning: unexpected data: CONFIG_DUMMY
>
> and none of the options gets enabled, so the rxe tests skip or fail
> for lack of the modules they load.
>
> Give each option a value. The scripts load and unload tun, veth,
> dummy and rdma_rxe with modprobe, so build those as modules.
> RDMA_RXE also depends on INFINIBAND, and rxe_rping_between_netns.sh
> runs rping, which needs the RDMA CM userspace interface provided by
> INFINIBAND_USER_ACCESS, so add both.
>
> Found by KernelCI kselftest builds.
>
> Fixes: e01027cab38a ("RDMA/rxe: Add testcase for net namespace rxe")
> Fixes: ecdcc8a455b7 ("RDMA/selftests: Add rxe_netns_names test")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The fix looks correct. The existing entries in 
tools/testing/selftests/rdma/config are

not valid config fragment assignments and are rejected by kselftest-merge.

Using m for the modules loaded by the RXE netns tests is appropriate,

while NET_NS=y provides the required network namespace support.

Adding INFINIBAND and INFINIBAND_USER_ACCESS also matches

the RXE/rping runtime dependencies.

Thanks a lot.

Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>

Zhu Yanjun

> ---
>   tools/testing/selftests/rdma/config | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
> index e1ff54ec0f579..1be43c4274bb8 100644
> --- a/tools/testing/selftests/rdma/config
> +++ b/tools/testing/selftests/rdma/config
> @@ -1,5 +1,7 @@
> -CONFIG_TUN
> -CONFIG_VETH
> -CONFIG_DUMMY
> -CONFIG_NET_NS
> -CONFIG_RDMA_RXE
> +CONFIG_TUN=m
> +CONFIG_VETH=m
> +CONFIG_DUMMY=m
> +CONFIG_NET_NS=y
> +CONFIG_INFINIBAND=m
> +CONFIG_INFINIBAND_USER_ACCESS=m
> +CONFIG_RDMA_RXE=m

-- 
Best Regards,
Yanjun.Zhu

