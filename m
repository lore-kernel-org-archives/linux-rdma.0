Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=67.231.145.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795024002;
	b=KzEUAeCvch4URY74QIIH1P/APNg6nxI0hKYCjGDd6xEgVx5bxz4HcwfACy+Bl6AF3xR+
	 noSfZFH3y2dRnAw5CqUPxvfbuTyd8zjVdUYAzc2LqBrKUNxp32cJHx3MfkBz+2ILNPlei
	 jrxnnFiYKqjTh7JB351Bv1VFOaaFspCKEjsVlhkvvxPNGSywOdLFjvM0whYJ3+wvHog4A
	 zcaHiXrou5LrzLNxp2IUXxumOQg60ookdl2zIXvdZMPL4VZg+dV7jy5klypB2C6UXVBCt
	 g6TmGAp7KRCkFII7c88dGad75g22iWRj1L2uguakNpIzVcDPvoV/I2lpcoXoJHPuLXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024002;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 X-Google-DKIM-Signature:X-Forwarded-Encrypted:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version;
	bh=3ykO91BHuXIQ6tsZKZrYbUoukzNZTCZ58wQfRBP+nBg=;
	b=yEidWB4pNhx5GaOEYhZHg/1qbpwDfXRTcvVmdtwoB1rTz8zMnZ+D2NdNsv5eHgpl7jiy
	 lIGOeGy0jQkFaL9slj2Q8MDvkaEY7l2GrwgV7Hk29h/XG7SHuVa0V/rUREiY7OJNT3VoQ
	 GEUZR9nqRPW2MoQo8T2kKOzPdz0yiHLTA9nwbAxgb7kKkaGpvKokAuZ+p2fuZztACPXkO
	 gq14rcfJItxqY5/vS4kta5YhH3Ph1ord1yclKe2D21NLln1RsMHb2N79nd10P355BICW/
	 Xs19HoqO3ic7gwFZKmSYrqblI7wC9Jrfrn9J8mcgWMdFLtTscJ9Bts9iZEgEMlZh6ZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=mR5cWZhH;
	arc=fail smtp.remote-ip=67.231.145.42
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE14E606A335
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 17:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE14E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=mR5cWZhH
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AIHGTRq2280792
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:46:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pps82601-s2048-2026-q3; bh=3ykO91BHuXI
	Q6tsZKZrYbUoukzNZTCZ58wQfRBP+nBg=; b=mR5cWZhHSGlgX9Kp6sEX3IH0+vZ
	7DhjCpS6kNifZvDX+8X4OeETq3AcTzE9isy0aS2loX670ry+7TN75kVbI8yRo1Q6
	gq+x5l6yhhuU6Wk3IRlOTXzEW1O8Kj3CPXaW7nmZ2iZTsfulilCriD9DhvSNbOFV
	+LEfsYSD8WgJDdr759A/H/ZR2SrSVA+o6i8qGD/4Jzx/vvk0c2DA1O8WtVgovNWz
	mS4mSF17IRuXojKZUPJgIbCJz3yts0xln4eo1+Af/NfhEOcjMVu4kVfu/pGgrgga
	CqMpmoyU6vuiNbRC90iCXLfbCcUEM1uT0uRPofW0D9uZzMwYVDSoS0KcRNQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j0yu7fd5b-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:46:41 -0800 (PST)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8b7cc3f8a4aso969956b3a.3
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 09:46:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795024000; cv=none;
        d=google.com; s=arc-20260327;
        b=NvOtbS5qwhM+6XqFJd1IHQyPKoXZ/cKCMklbGKqNqeBD3H2mg65phqdhI5zT+kfmFc
         7R3NoV+k+GoauFOkbT5DQr02Qm9/g4XZnSOCRtIYn8A5qDi3MY4aXlyk9I/UYIxJkNPk
         vwnuLFsCZQfAAlk1pU8iCu8NkJqM3sRta/gxYSuKXCP7CsJAMY9TZxN6/QiPf2wFYecI
         NrWDtaNaXXY70VQYmuRbryHbdyMYQoQc0C1J0cf3Z+Af82EaDAqdtWAEi1aGHJJerhWC
         XHS0LbUdxAQpZ3I7UAlKtef1Zg7z3idKh5jOyt07C2E/dF4woqLCxFwDA7LDIoTlFZHT
         v9zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version;
        bh=3ykO91BHuXIQ6tsZKZrYbUoukzNZTCZ58wQfRBP+nBg=;
        fh=8fWzSJONAVg5M7gGsU7Na/EkCuXx6Rvy/teEEey8/sE=;
        b=TpXVIPYphIt2zZz/At2EV0bvL6bRI+fspOujD+2ZdV7Y5OOfer5Y98ODL/gIGjegyc
         dIN+pNadN+Ffj+oBy55Ye+tJHH4ask8JYryz8De6a0RVR37gxlZtmQa3PLZYfGGFQ90E
         v5QyF0xLfM3tmHZbum1UL/uk7ODiovmWhmR7Bahdtl3zzIRycmAfd2F4JXds6TQUBeWg
         kmpw+xFyi5fgH5AEf33iMjAdv0IDpM4e0+YwR9CHsmb9YD6MmhRBABSQYSsSOeHYueOB
         07nCkNJgRJeFBgMJp/EVbV3y/5dshB4RsT3pbQHfVCTZz45V4jGJPp8LEr5ByBxKeIy+
         2Lfg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795024000; x=1795628800;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=3ykO91BHuXIQ6tsZKZrYbUoukzNZTCZ58wQfRBP+nBg=;
        b=1TSZrEx7ZmdQmqQkc2Sylm4j3RNQimjT89zvLTYddK/mFMWGiBFFvI4MBvIGatO/65
         yAG+X2FJ3gHQvLlYgpr9jJndxwr1FtCyCemndSmEWDrGpU/IzKtpMDoUnzZy1L1UfN1K
         7iVDkIF4ykS+C2sW5LADBXubZ4srGMA6RyeCg/uvjuimFuWk8KT3d6ueuPikUopNjjKQ
         0MVH6kxc4zxVP3sj1lUZSAJY+SYhCluVH9VV4t//sE1qTmGQaixaZeMU+szkzJc/mK6u
         slflbtIwdZupiB3I7gmoYib3bQtZ6XiR1qk2ePI1lENuFXlRPIsntj8ufUiOAgolBnY5
         N9FQ==
X-Forwarded-Encrypted: i=1; AL+hErFkpNwC66wDQwZ2b1wMbkQ0h7wYPOVXEjf8M21QTjJyKCVDW3UmbyQWFBNVdLFIA3RV7vPvZ2Xz65Vj@vger.kernel.org
X-Gm-Message-State: APuU4Z8UNxAY+6ZxdBLMfs6QheCO0ri3fGCPfav1NTX5sz/OpsjcP0Ix
	fJgh+RU8nRDXJadkK5fYuB0a5hWKSnfBJMH6kTUWNMO7e1oe9zNg1F7JqUaX/VzbBkZgfxHwiro
	OV3KIN3sQSzgjwVW+fpZEk+/YcU3fRu04P7SYNavw85GayC6EgitO/igoKa+Y4E65k3I0ynB+r3
	0B94ktmftcrbjWvrC6PkssygP9o51yj0QnCqAw
X-Gm-Gg: AYBFou3UMlKOyB7j5Vqo17JSeDOa+atJi1xxJ42lFndthIISWBR/uFO3w3NVVwQChey
	3RZfLRH5wxDrPZHiS+A6ujwb1ve75lau07u0UZUjSMEFtxC0T6EwgMeLtgGBNzR0TVYg1KtwcnO
	f3anlpD8kMrfdhnAl2oTMpzxI2/ZiEJ21BgSmkmbA+Q/DpMlme7g72G698JDPwZxnRJbwnqIkVm
	42ukDZt5hPsdzJ3oMYumiKN+mOspR+q
X-Received: by 2002:a05:6a21:7e83:b0:3e2:a849:64c5 with SMTP id adf61e73a8af0-3fe970fb016mr3351006637.19.1795024000262;
        Wed, 18 Nov 2026 09:46:40 -0800 (PST)
X-Received: by 2002:a05:6a21:7e83:b0:3e2:a849:64c5 with SMTP id
 adf61e73a8af0-3fe970fb016mr3350979637.19.1795023999775; Wed, 18 Nov 2026
 09:46:39 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261111005533.6436-1-toddfreed@meta.com> <20261111005533.6436-8-toddfreed@meta.com>
 <ea8a18e0-12cc-48e0-903e-325a8ece5a0f@iogearbox.net>
In-Reply-To: <ea8a18e0-12cc-48e0-903e-325a8ece5a0f@iogearbox.net>
From: Todd Bert Freed <toddfreed@meta.com>
Date: Wed, 18 Nov 2026 09:46:29 -0800
X-Gm-Features: AclHuK933nJ--reKuON_iU7qOJYXtOh-j2OhgmEp3HOYoG1ZpPxZFsfMEYfL2v0
Message-ID: <CADh2yMxffQ3cywT3aNg3SkVfog5CFnUSp34F1esyun-xUBVa9g@mail.gmail.com>
Subject: Re: [PATCH net-next v1 07/15] bpf: don't redirect decrypted skbs from
 egress to ingress
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        bpf@vger.kernel.org, Daniel Zahka <daniel.zahka@gmail.com>,
        Donald Hunter <donald.hunter@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-rdma@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
        Paolo Abeni <pabeni@redhat.com>, Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Wei Wang <weiwan@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDA3MCBTYWx0ZWRfX8+P3nPuzmWmk
 P1GfdsqPThEZUAsVSHdFufa47ZkI9PpAeoFh0koVHUOjwjov2k1Vw206pK75ZNpxZFKRtSnnr/n
 bbOFqtwK9y2PjmJE9FpkD290ryN4o5YWMXppAZAz5ZuyLiBdqkChFc+/RTVG2sXcaih9lWW6e7e
 5fczff8y3zA5C+ZCLQaZiBmj5PTr810MRdmwkdABM6OvTY3Ui/WeOyrR7goyVXjFW4WWkBlZaMt
 gS67ZNsEkTqx3LTydHHHodLjdafZh0+W8Utyq7AYghhhw2CyrhT0RpvbGzoH1UJxyDxI9UyzPcE
 y+7CmKAsMWwsOM8Q682wSh28mdtXoQwZaJMBbDLP7iD3HI9EjGIlwdW4M8ngdJBb3nbzCQkJVfz
 gAW3Me6XzxSSqpcCp0XVMVMawkZ7kFSRaAmvbF2VY7jDfLMMDcLgvetOE4n4B/sdIRVwe4nA4qX
 4xZp92BkW9RBNkU2tzg==
X-Proofpoint-GUID: KV79r3_AWDtsvWQe6QtnHXz60fULcKk_
X-Authority-Analysis: v=2.4 cv=Zph4uN7G c=1 sm=1 tr=0 ts=6afde481 cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=PAz_-FQ8hEVmOPYdF0yf:22
 a=XWTshytv-yXGdKsk3gQA:9 a=QEXdDO2ut3YA:10 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-ORIG-GUID: KV79r3_AWDtsvWQe6QtnHXz60fULcKk_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDA3MCBTYWx0ZWRfXyEld6f8w77C2
 8eE12tj10vYoj26nfo2eApj1gdID72dwdDyehhHlclR1OYEIJRkdsSn8obAX3tx4+lRRBx8eSMH
 aBlVxjKZBjOiQQX1frVM4ZUc+XIKwoU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_05,2026-11-16_01,2025-10-01_01

> > +     /* On transmit, decrypted asks the device to encrypt the packet. Sent
> > +      * to ingress, the packet would read as decrypted by the device.
> > +      */
> > +     if (unlikely((flags & BPF_F_INGRESS) && !skb_at_tc_ingress(skb) &&
> > +                  skb_is_decrypted(skb))) {
> > +             kfree_skb(skb);
> > +             return -EINVAL;
>
> This check should rather live in the bpf_redirect (and friends) helper e.g. after
> we check for invalid params, etc, rather than here which feels off. Also, it would
> probably make sense to refactor this condition into a small inline helper so you
> don't have to open code it multiple times.

Sounds good I will move this check into the two callers
(bpf_clone_redirect() and
skb_do_redirect()) under a helper.

FYI this patch was moved to the net series "net: don't redirect
decrypted skbs to
ingress, psp time-wait validator", so you will see this applied to v3 there.

-Todd
