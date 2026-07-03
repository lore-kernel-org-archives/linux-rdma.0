Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4621C288C0E
	for <linux-rdma@vger.kernel.org>; Fri,  3 Jul 2026 17:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783099966; cv=none; b=YT/QILBorVuGb2acHtizq4tXJQJyzjsQhQWIpXnfwp9uv3ZlT6iXv3gtlGUMhqplc1fGJ0gAESF87wkzKsesoysf0vxSGqIdntBb5ZpM7va/y00U/IlUbJR1hJJlxGPS+v5InmvH0/8SfRKhWfS2UpBFE8OLINVh+rNyOsat0Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783099966; c=relaxed/simple;
	bh=m4OmTCGCFQYOaBMhqaNh/6jBqsW0ccksDY8TRqlsGpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ruoKkaJrhBNDQyYaiq838PbiUT4p+HzQneJBZtVd2FV9Y0HqHQPS2zyLu72twAHE0JWQ5jdcN5YST/NmvmZCm9wBTplPdik6Dbg0umGcJZiO27Ic1UpZgT+UkoJkaunS42QJOnMMOQoiyotx2jzub9SnZAlu35Nohl8g8sDVzLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K2OW9Itp; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K2OW9Itp"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493be1b9564so5884865e9.2
        for <linux-rdma@vger.kernel.org>; Fri, 03 Jul 2026 10:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783099964; x=1783704764; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=utxDtrwNzXxKXcgvcghh8twZ7t+WAmGcuINw5MslGgg=;
        b=K2OW9ItpBBNRjTwIO9TzBz4WPlYPcVQxO+gXbxaVfb/T1mj5N+XO01XvS+cvrTFK0r
         v2rR/nj0qKIjKaXMKZ7ZMhp5G7YXyrr9JzwryRq+mfIq0kM3ZHIn2tXXXVGGpepNQpEf
         tAnfN7axHdUFGt3yDVrtmN4mzW+nOw1ElnHwfny9flWj/oozlvl7LhTqud5s5ouddnWj
         HF4xxKt7Z14X1atwbRBQXUaSklWlaY/ThYREQNWZq6Ra59pZ+V0PeXW7kEQJCgHHcha4
         cpRCso3Vt9cDNQ5XQOpMFFCC2gL/XxX9wowEghMejoiyCOyBo4MhVkTrcl6ydF2GueGc
         vEwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783099964; x=1783704764;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=utxDtrwNzXxKXcgvcghh8twZ7t+WAmGcuINw5MslGgg=;
        b=QfMI4jLfNvgnDrvNJc84CxEjTpH045zbqRI95bmZSNyhUgU6jSUzgVVtJko5OlNr+M
         1vwQCf/kgfVvautishYz7NoGrMOkT5uro2eRwnlkvrq5p8LiM5wPL2n8aqhembdH+HPE
         Lb7twz3qyR8k+cIZ5H7ConViQ0yvHr12L1XwOtCo+EQ5C1iDL7bNCL1qn4CrcUScNnHG
         /DnnYTc/z032qFWrAqDaLwDkVRPUNhxsugewcyIckBqVpWLZaje3xosq4O/WkiLgnip+
         rf83ryOyVHF+/zRFyuZQtVoazh2lhMGzcX0e/UnK63N2CyzaAw1SWHpsYZ67+R4dNi7z
         PKNQ==
X-Forwarded-Encrypted: i=1; AHgh+RrQN+UA42ijADgbu/za4nAVJfE5EuPX0+xa1+IxLptmdM8Dcwe7AY2IHw38n4lzp1iin6NefXWdaXu1@vger.kernel.org
X-Gm-Message-State: AOJu0YxgDaxJGAsx98Tj8/Ss08hCAODu8eHXK4+oa/u6FSE35yW7pMZ2
	9Edmt2HJzslo5ehYOGn4ApD0/nj9wotkx+7A32WhvsgZN1lItjBMcClR
X-Gm-Gg: AfdE7clwzetuvoysgwg/xxwEcIa0LmaN2WVy/cQm+zjZvag6vLTVWRYu54ZG+wjQYVs
	q9FBxYj1wB8LlNFVCoWqNmx5Hoc/g+o1TOJ+dP8sw7R4TF90vU3LhSLDySvsR3MFoIOeVU4S7HU
	9uCkTaOmNMtnJ//4usyV3L6VSwmMRnA4bZ4q2d7kwXlUZk13Cvi1jbHBdhOvcdDjqz+aUUe7mvu
	g9AXPJpxbcD+c4qV+45InDCpKHWppWPN+RKE+uHvj1NTFTlHi26T7DYhZhGknhHAuaxIbGZ9AR9
	E/FXx1VlP8k/Nzt8wyr4/xeC1BfN2wexKfXaDmStjFAwPFb2jRn/RXcdy+g58RxXT+gBvLWDlLy
	wywCGIMmFqld1duLA1vbxDJUQi7Ivl534g//x1tH65vdOJLxNw9Z3+pMxz0dVfhxSb5chADVngu
	qjkdSQ6isYKOylfEf1vHzhq4lePYP1bPD6X0PKlwvJYM18FHVtqpebgTpKO07kSZD0UQoMnRrJH
	iCpJDxE
X-Received: by 2002:a5d:5d06:0:b0:475:f0f0:9ed2 with SMTP id ffacd0b85a97d-47aad928473mr386128f8f.61.1783099963618;
        Fri, 03 Jul 2026 10:32:43 -0700 (PDT)
Received: from [10.128.11.240] (195-23-151-163.net.novis.pt. [195.23.151.163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f213e8sm812176f8f.34.2026.07.03.10.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 10:32:42 -0700 (PDT)
Sender: Julian Braha <julian.braha@gmail.com>
Message-ID: <5e95be5b-ffc6-45f6-ad98-92219e265a59@gmail.com>
Date: Fri, 3 Jul 2026 18:32:41 +0100
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma v3 1/2] RDMA/zrdma: Add ZTE Dinghai Ethernet Protocol
 Driver for RDMA
To: Yanze Zhang <zhang.yanze@zte.com.cn>, jgg@ziepe.ca, leon@kernel.org,
 huangjunxian6@hisilicon.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 wei.quan@zte.com.cn, han.junyang@zte.com.cn, ran.ming@zte.com.cn,
 han.chengfei@zte.com.cn
References: <20260702122256.569952-1-zhang.yanze@zte.com.cn>
 <20260702122256.569952-2-zhang.yanze@zte.com.cn>
Content-Language: en-US
From: Julian Braha <julianbraha@gmail.com>
In-Reply-To: <20260702122256.569952-2-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi again Yanze,

On 7/2/26 13:22, Yanze Zhang wrote:
> +config INFINIBAND_ZRDMA
> +	tristate "ZTE Ethernet Protocol Driver for RDMA"
> +	help
> +		Say Y or M here to enable support for the ZTE DingHai (ZXDH) Ethernet
> +		Protocol Driver for RDMA. This driver provides RDMA over Converged
> +		Ethernet (RoCE) functionality for ZTE DingHai network adapters.
> +		If you choose to build this driver as a module, it will be built as
> +		a module named zrdma.

The indentation is off here for the text in the help:
should be 1 tab + 2 spaces, see the example in the
kconfig documentation: Documentation/kbuild/kconfig.rst
or other nearby config options in this subsystem for an example.

- Julian Braha
