Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E6E377AB6
	for <linux-rdma@vger.kernel.org>; Tue,  4 Aug 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785866762; cv=none; b=IitfvlI8BDe0bUTdQO9QY3FHAe/VosYQc075m+MdFNN1JOvF4OIhkXvTrlHb64UE94lKPNj4sCa/UNZ/67I30ygQxv38tcnnp4x9VAqbJ6NAgFv6jubVbD7q2ZgYmeYVgbkJcdCCZWtiR0LMfao381v4RMlbubeJn/fO5MUURvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785866762; c=relaxed/simple;
	bh=mukZbijvR09Qyb8O6a5zSs66Nc1Ea8eJ76KYS4fy0x0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y8HDwk1BIEed3MX2FrJVtXlbfZiPnsOBdtvOy0vTjy/Ko+CX9FmKp2cKQZUh84DgNSsxGSJh5uWEPql4QuqI1FY8NvuOnuCOsW3WkhQ4V+/JoRKoTSZyof7PRFaP/czuCxmeaNqeBGoRXx9UDj3VcXKDJMc09OxNNyvjN9qpbCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/XJod1g; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/XJod1g"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e7632b193so10467485a.2
        for <linux-rdma@vger.kernel.org>; Tue, 04 Aug 2026 11:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785866760; x=1786471560; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PvFOPFIKv7IZLYV82VSUnHCVCbk2jO9N6jmpfHOfts8=;
        b=T/XJod1gvh20p2DW/AdAWJ74EQT6tre1gp5whPlqrYD3PiIEjglyZGXneLDTjxaYuh
         kfyggTEifzO1Epx13eyNGjHVTWHDsKXWH7X9Y+bE4JG1zVMdZF8EVdvRuvTtLKvJr/lH
         vHnivznxdcM2TXrBNQelgkRj6iZv+L/BfB7E+UKM+PUMTCoD/TufPWpJcgiqmfMKmx1G
         8e0ifEX+lXUADOzM/zVGLipW0fDsyVn6tBoIW6LSJ/DOtun8ixat62anId6TbOJgiOcb
         Wjbp+/SJtDyBdSa6rc2sdF6mJczvVYUkvL7CDlABZczuhp2VQ/yI1YNlDT/+i6Y1gt72
         EUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785866760; x=1786471560;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PvFOPFIKv7IZLYV82VSUnHCVCbk2jO9N6jmpfHOfts8=;
        b=MNodBZbiUVHwYca5w9C6HU5qQngNXP5uv2Fz19o3hZ+BEHi8UOuCz6Z0mxodW9m5aN
         RDWoPoHRZRpX76R401h7bRVIn/T25NVFSfarNSZIaJLMHFdLf/ehkIxdUWqOB7/d/y4u
         ZIRfiwFuFro5BSF2WJo0KtAGyYKX1Uo7ysruZ6Mx36ONLP37Pfg451VzGUys5Gs3pqnv
         Q2KOS0LgvfYOA8RFoYT4dq1IzuK7yzcN3I5bbudfU94YfqkAoXR1wiEOM9vgtjW0EqdG
         dAVxqXU0DhgSXLT5Yqv3mFtEmECS1XBI+bEym6u+cI2IKVtWVZgrLwmGvJdkAkzxDZO2
         Qczg==
X-Forwarded-Encrypted: i=1; AHgh+RoBjmpLktrIfEdfNYJhebK+9sca9K0Un9sReXZPfzFrX1GLJeOpFut/49/iAH+NzJvzsK87eJw6m+oe@vger.kernel.org
X-Gm-Message-State: AOJu0YwPI88KD2GzXX8C0z2TEzzp5uVls36ceYGFRgzkVlYS/i6Yxgg5
	21uHldMn/a8VfMFiBEziekkMp1yp15f9sQv+qfjG7Deaxjnrg+9ZXrtP
X-Gm-Gg: AR+sD12io1H5hxpCEsc4y4DgfbY5mxI53BIK7xZFLuqJu/rx+3wDQ8sLBit6jhCULyr
	QDSeSmXzFoMqq8vDaHdfPqWwiCdT4eOnVhQFoem/8PsMYVAlyI73WQ0rWsCQwiYmin7ffwKo236
	p4IE68WHuY6BOhQjrV/UiPCgJWQf+9SJn8yd3TgMJxbD7NjaeeW4Q9AiVreQzkJZEaX1u/b3Zz4
	S0TFKwjjTOzLdk2FfV5A/CW1k//RmxhXeEUQiTt1myo0FdWNYcs+Ev1b5BtPjAmfC96YB9N5AcS
	1j07Olffz3UuE+iOa6LabT5yA4+Ed57s6Ohtp5l+TMzDdawAHnyNH6tvpXPhsIwI92HxdkWZMiO
	z+5lzXBgRZr93XBaa8L+EeA5sQXfifE1tpeC/iNvhp85QOqsqUAYuGeVuSjph1P8BqoYhStA4lW
	Rgjff5N3ojOMQYRONT7ywqQlkymKvvCRtDpXCY3O2IS9cdCyM3pxWwmkzdBe+ryKWr7jUwV+tsz
	cprBdJ8ULHwNDoC7cEmg8iiJqflPtdqZqMCWg7k9Ww=
X-Received: by 2002:a05:620a:40c2:b0:934:aa05:f549 with SMTP id af79cd13be357-936491d3c8fmr16849585a.25.1785866759759;
        Tue, 04 Aug 2026 11:05:59 -0700 (PDT)
Received: from ?IPV6:2600:4040:9399:4000:e553:72e5:7d37:c7ef? ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93641592964sm148846885a.0.2026.08.04.11.05.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 11:05:59 -0700 (PDT)
Message-ID: <9460e089-ed71-4f3c-986c-5d29b87b3500@gmail.com>
Date: Tue, 4 Aug 2026 14:05:58 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V2 13/13] selftests: drv-net: psp: Add a test for
 PSP with HW-GRO
To: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>
Cc: Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Alexei Lazar <alazar@nvidia.com>, Boris Pismenny <borisp@nvidia.com>,
 Carolina Jubran <cjubran@nvidia.com>, Chris Mi <cmi@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Doruk Tan Ozturk <doruk@0sec.ai>,
 Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jacob Keller <Jacob.e.keller@intel.com>, Jianbo Liu <jianbol@nvidia.com>,
 Kees Cook <kees@kernel.org>, Lama Kayal <lkayal@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org,
 Mark Bloch <mbloch@nvidia.com>, Patrisious Haddad <phaddad@nvidia.com>,
 Raed Salem <raeds@nvidia.com>, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Simon Horman <horms@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>,
 Stanislav Fomichev <sdf.kernel@gmail.com>
References: <20260804083535.2946459-1-tariqt@nvidia.com>
 <20260804083535.2946459-14-tariqt@nvidia.com>
Content-Language: en-US
From: Daniel Zahka <daniel.zahka@gmail.com>
In-Reply-To: <20260804083535.2946459-14-tariqt@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/4/26 4:35 AM, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> 
> Add a test case which attempts to send several 64K chunks over PSP,
> which is more than MTU, and thus trigger GSO on the TX side and HW GRO
> on the RX side. Verify HW GRO counters increase.
> 
> This required the addition of a new command in the psp responder, so it
> sends the data in order to get it reassembled on the local (DUT) side.
> 
> Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
> Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---
>   tools/testing/selftests/drivers/net/psp.py    | 131 ++++++++++++++++--
>   .../selftests/drivers/net/psp_responder.c     |  49 +++++++
>   2 files changed, 171 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/psp.py b/tools/testing/selftests/drivers/net/psp.py
> index 315648a770d0..9b899723a635 100755
> --- a/tools/testing/selftests/drivers/net/psp.py
> +++ b/tools/testing/selftests/drivers/net/psp.py
> @@ -16,11 +16,12 @@ from lib.py import ksft_run, ksft_exit, ksft_pr
>   from lib.py import ksft_true, ksft_eq, ksft_ne, ksft_gt, ksft_raises
>   from lib.py import ksft_not_none
>   from lib.py import ksft_variants, KsftNamedVariant
> -from lib.py import KsftSkipEx, KsftFailEx
> +from lib.py import KsftSkipEx, KsftFailEx, KsftXfailEx
>   from lib.py import NetDrvEpEnv, NetDrvContEnv
> -from lib.py import Netlink, NlError, PSPFamily, RtnlFamily
> +from lib.py import Netlink, NlError, NetdevFamily, PSPFamily, RtnlFamily
>   from lib.py import NetNSEnter
>   from lib.py import bkg, rand_port, wait_port_listen
> +from lib.py import bkg, ethtool, rand_port, wait_port_listen, CmdExitFailure

nit: agent has pointed out that this new line is reimporting bkg, 
rand_port, and wait_port_listen from the line above it.
