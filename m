Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794734209;
	b=eOqD6x9kQyTDF1XOT/mYPWrsAss3IIboXLCij5TZZwnwrmkWr8wJgOrxHM+tvHi6V1Hz
	 OrGGSiF1Pd3eAgfxTtIKU0iWsSlS5ygBvalvtsbEYxoCu3UjOoaaxvLvo+RhyufIiFd5Y
	 QZF9g7rJvYf0X2nrch7Z1Sdj7Q/QCtBJBBhXJmGKQrHBRNLFnYwRkORtKLA2M8ceEmAKu
	 1eNT02n6o6J3rKqDDUcwO3Z+xov00fwPmew7C4G8FCoNx25iiKCgZVrPBQ7CwocvAEu45
	 t31rCDsQdJUtuPCTPkMYB+oMlKzlIaYKP5waDFSWhqebdtTiNxL35G4cYHMbPbvVhfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794734209;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=/eA178NmP+qd+yyHrEwC++3AzN54INzuTidmFixN9xQ=;
	b=tKzJiWFD0ZkUGcPd5Pm7bTjL+19CeSmai+H70Z8B1mzXWUXxD1BLNCNefaR8u644njIV
	 eHVYa0rgMRr5hSpHelabpLzGmb2NEwomnP5hwi9NZpEOOI3z9HeaQlHQt1mR9bogb4Mk1
	 30j2diM9QI40kiPiGp+ru+7oVDCeDIYIVN4pd08zm6G571PUStHpR/g4zAgKgQ484U+dj
	 zLcTSHBwz3rIWlcICurIRzUTf1hKjl959tppyeuPXJRC6r/sckqpRR9FhvegydJOtw3SJ
	 ofV1RPsqvLho2A/+xThKRnMhfil7Df2vL/FoUYFQF30+BBFYNdiFHIX5iph/MmMK/KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=g2GxMQaa;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD2B606A31E;
	Sun, 15 Nov 2026 09:16:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1FD2B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=g2GxMQaa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794734207; bh=Vf2ZDii9Fnnk+owsauNU235j++Ql7OZyQ68P91fILfo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g2GxMQaaxNk0YJ61TQ7IqxSaeJc9KnKwJTIR76wc+U4CVecyQWfK/aAI2Elr+d9X7
	 ZlHHPUddXUqTTs8tS1A1rmz2DvabBOBXXyapiz1bWVzBJ81zORPQuhruCZnuevl3V8
	 6nMz5XXfyfGvkMnhsxSx9oW/wp2lodlEH6RGo6d5OOmiqZV/lTtm+ulTK3eUNfRYTc
	 g6g4009bljlCVfObIvqOJe7HQMXyEZAiz1SqTxTGLcVJKWAVsAe0eUWnMcpqqkJf3k
	 Eys+TfRu21qFdocaZiX/Ex2+UZZN8wjDbZ62SIz7S8aH22/NhJFCvRU8n2Vdu6673G
	 uAXhCyvI5dWQw==
Received: from [0.0.0.0] (unknown [213.228.1.188])
	by rcs.proxad.net (Postfix) with ESMTPSA id 07D1544C03A5;
	Sun, 15 Nov 2026 10:16:45 +0100 (CET)
Message-ID: <81c57b1d-1b86-4e62-868c-2d632a9fc292@corp.free.fr>
Date: Sun, 15 Nov 2026 10:16:45 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 07/10] selftests: forwarding: tc_flower: test the
 enc_key_id mask
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 jhs@mojatatu.com, jiri@resnulli.us, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, michael.chan@broadcom.com,
 pavan.chebbi@broadcom.com, bharat@chelsio.com, donald.hunter@gmail.com,
 corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org,
 dsahern@kernel.org, idosch@nvidia.com, shuah@kernel.org,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 oss-drivers@corigine.com
References: <20261109131039.959438-8-acassen@corp.free.fr>
 <179442433006.2199510.18178415453434864193@kernel.org>
Content-Language: en-US
From: Alexandre Cassen <acassen@corp.free.fr>
In-Reply-To: <179442433006.2199510.18178415453434864193@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/11/26 20:12, netdev-bot+sashiko@kernel.org wrote:
> [Severity: Medium]
> Can the skip_sw pass ever reach enc_key_id_mask_check(), or does it always
> end up in this branch?

It always ends up there, because a gretap device takes no skip_sw 
filter. v2 runs the test in software only.


