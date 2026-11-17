Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794940080;
	b=xLUSLgmadW8jzjaZ0vKWCM4dSx/+UCuXH/h8uAVFiGAnuvFrRXdZulqrZI2MV+RJvJ1G
	 5u+OfDEJ/NySr3weXZD1K+gRQxjczlJbxZtUllqvIeq3B5NLuwfSqHpr6G85iQWxgR89e
	 n5C6EjyraROr8d+jkcdLE7Ipbt2KgPZu/cO+UU5a+txO8bvyJ22B8+/1MXPzvBtsFDG1N
	 /8Z08mAnnYMpnKKAfPdBy6MXflrbBgfhe4WF751jO+GrTKnS+w2DrBcTto6jWDAlk/sCM
	 Ahpk0KfbcYmLHCtx2yFelJ2dSc+4EjFMEHJLUUFuGu+eKnAPikIa3lOhQ7s6gxlC/yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794940080;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 X-Relaying-Domain:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4HIDElfk1fUBR+g3gRBqfDseCIheuM9kcM5hnFH2Y+g=;
	b=ftmXhtWdXIOgp5n9cS+a/HUfBJiG3IpUHgowUXZSQwiGTyOc9/tWc8xxQaE5HR5y+kG9
	 dAvhcrZceFhgmN0isZCfBnNzcIAzNWgo0SjfIrksxFMw9CMXuElqgaTEqFcQZrneaoV4D
	 xl+NNrQzVQjk0ry5LW08bloy2uMf4qD5pfpaPbLOdWBpK3r0iH5ENjmFrVG4mQJz9Ur43
	 88if+Xh5LP3mo9kXsFVu5nfNccQYO0hp/HavUNrjQf/7jPsEUKEqNqnYAVijFcOl3ZYcx
	 4M6HX9V9gIdsNh6bj0Jcma6PZO8gKfqAeHmlyPEu7F/mW+CSKmEvPa0z2zEYK0QlMhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=everpuredata.com;
	spf=pass smtp.mailfrom=everpuredata.com;
	dkim=pass header.d=everpuredata.com header.i=@everpuredata.com header.a=rsa-sha256 header.s=google header.b=uOs3Ahgj;
	arc=none smtp.remote-ip=209.85.215.227
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291FC606A334
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 18:27:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 291FC606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=everpuredata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=everpuredata.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=everpuredata.com header.i=@everpuredata.com header.a=rsa-sha256 header.s=google header.b=uOs3Ahgj
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso101695a12.1
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 10:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everpuredata.com; s=google; t=1794940078; x=1795544878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4HIDElfk1fUBR+g3gRBqfDseCIheuM9kcM5hnFH2Y+g=;
        b=uOs3Ahgj9+nx34cROVVGq20lgcXGJt2vVPpnszE6xPya+N5tpyTvWqV2gfQ0r597kQ
         u7OsHsx+A7t/z+rXxrCwGza0CSjZD6bMOgOUg0n+rqq3U3M40TIKsaC2vgg1HqbNkSLM
         sRvpK2gq1/qjHMc/LU6b4IQKPPTsHsqL/nITdkzcL0HOh/kDRXL75jTdDQ8s3dEkGWGm
         CRnGH/pPh0XydxUFACuGxsOn/gdkqSXeTToq/fctuyImgwYaE+OkDZR8gLb36ux8ELL9
         sZiUpJDnJwu+QOgjCUagnIkqaS4xu2BIg/6ufW608Ooyjt0mYI1+38OhK2vxwyEMhCr2
         AysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794940078; x=1795544878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4HIDElfk1fUBR+g3gRBqfDseCIheuM9kcM5hnFH2Y+g=;
        b=EsxCoIX2yN4f0dRkUd4mPkD/hOS7xHur+0H80nJw2dHTE8a5mJu9r5HFpoqteUvgFM
         htF3Ps5xNsZ8vhbq2yAqecMS3g6ta95M3XQzOMPGiYTdlhpgX/7zwZ+VTl0alt5kmM+w
         t0Ckg1H/jE3u/uUyLeE1iPLXkA07md9VX+C40ySkBLqXL2VCzIkANTnUZSqMqUwJR7uW
         LameLaAJszJZBNq4OGzE84guL6n/dd9mqnFBE70rlMI52IuNXbn1v8jplq8GnfSxpj14
         pj1Z73U2g1X1X11MHpJSPVUeFPepgSlz0OhizXS03slwbKfIy3qchQh0ZrYOySSRJx/U
         ndrQ==
X-Forwarded-Encrypted: i=1; AL+hErEWdc39mxzVwyK5lkk3nd7PmB8dz32t+jK4/WZ7Dw1LnUypnAqDOySsjBbAwDNA88MGgt3RgoUjxebx@vger.kernel.org
X-Gm-Message-State: APuU4Z/gBFfQbCvgWevqaFl2+YnHxgLMX0SEnhaK2E7YBImddRhwBDmt
	FHE8tR0V+zEXPG8s+O08LG6daCNWLICytsXZMkYxNQOgXFLDzMLRHdb18Rk1iCRUqg26Qqa+eHA
	qQKsOucoXqLwjL/B7gyEJzovkToagOjvQnNbcTA8P3t5f5s8gzTupjX3oJieFpgIxI3Fle60apR
	wUc7B90q6nJaNnL5geUZnnZ8wpyIIkIKYD3iAIoQ0FJBMnRLC9rsn8WtWpgYrCzH7n6zljzvkIj
	H8L2rRBEoFOPiM7bofIUXQ/tiTn
X-Gm-Gg: AZFdTZfYSjUWUOnbSy4ou2EWfgsIPNItVmTkfZk88wvPsQbZ8U1XJHp3s597TPjSeo4
	XVeqc3JC0+zkAncIruDTiT8mzpOhsInzlKVS/SYivlHprgcDM+gH9I3qKGT5umDD+S/EN2AxYsw
	JSOY82VKrQJUS0qA22X+9PUYs7H7UlPFhtU/dO2Hsf6oAFLfIaygyOi927yfPZDU0u+o0OZ9Vlh
	meWjHIST6/HvRubxVnNBWUG8lBiGk6pRn2kx0NYzNRqVzH8rM7EHSXwv3/tPBT//gz+c0mUC22t
	8L7hoyqFykye+ACvCC1G0E3Pt/OQyiz2lQYSRPmBK0vVG+uls8G0BmG1iJRD5YgoQNZjaCc6l3M
	+wFyvRnTd2gxgV1C0L58LWn5YTRzfsPy4lnmj7AQ=
X-Received: by 2002:a17:90b:4c0a:b0:3b0:934c:5e41 with SMTP id 98e67ed59e1d1-3b3d07aa71bmr289902a91.29.1794940078336;
        Tue, 17 Nov 2026 10:27:58 -0800 (PST)
Received: from c14-smtp-2023.dev.purestorage.com ([208.88.158.128])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d0987ac9sm136956a91.0.2026.11.17.10.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 10:27:58 -0800 (PST)
X-Relaying-Domain: everpuredata.com
Received: from irdv-tmenninger.dev.purestorage.com (irdv-tmenninger.dev.purestorage.com [10.32.149.15])
	by c14-smtp-2023.dev.purestorage.com (Postfix) with ESMTPS id 1C2BE34052C;
	Tue, 17 Nov 2026 10:27:27 -0800 (PST)
From: Tim Menninger <tmenninger@everpuredata.com>
To: lixiasong1@huawei.com
Cc: Dai.Ngo@oracle.com,
	anna@kernel.org,
	cel@kernel.org,
	jlayton@kernel.org,
	linux-nfs@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	neil@brown.name,
	okorniev@redhat.com,
	stable@vger.kernel.org,
	tom@talpey.com,
	trondmy@kernel.org,
	weiyongjun1@huawei.com,
	yuehaibing@huawei.com,
	zhangchangzhong@huawei.com
Subject: Re: [PATCH v2 3/3] xprtrdma: Wake connect worker on device removal
Date: Tue, 17 Nov 2026 18:27:27 +0000
Message-ID: <20261117182727.104697-1-tmenninger@everpuredata.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103032758.1302493-4-lixiasong1@huawei.com>
References: <20261103032758.1302493-4-lixiasong1@huawei.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I encountered a refcount_t underflow warning in rpcrdma_ep_put() on
7.4.0-rc3 during a pNFS flexfiles read workload with one MDS and one DS.
The trigger was restarting the NFS engine on the DS while reads were
in flight. The warning came from xprt_rdma_connect_worker via
rpcrdma_xprt_disconnect() -> rpcrdma_ep_put().

With all three patches from this v2 series applied to 7.4-rc3, the
warning no longer occurred under the same test. This test did not
involve removing the RDMA device.

Tested-by: Tim Menninger <tmenninger@everpuredata.com>
