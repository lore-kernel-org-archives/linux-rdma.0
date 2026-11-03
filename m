Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.103
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793674197;
	b=zSY0hC+KV48Ax3cP8tIcUpdcZMVU7ewKYFgeqOY2kUVBaSg1u8dUWyKHLTqXTsJKiG6D
	 lbhtYSIiLVRgd088zXdlQaSFreie7SXtBRl0nlLQxDHVQ0LykifgbeuSgJKfuzwt3X8zC
	 x3vi76BiyDWSPde+9G2RAnCYcOv7JQvAY+pkrmkUcPlSGz02wtAPhIoqt4lgR0A6B9LOY
	 DfwSDYGk8jOWZcAu2MlttU1fjqXHBXfTMMQRATRuZdzpP2JOQxrCCmhqj3FL4Wg3XVCNG
	 sy2a3nU/FI/WOYU/MCo+1LVupsWY/3dXFndAks4SgS4IUuYrqWNILV/Sm8YO7n2RzjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793674197;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WVUCKQFl6772aaSzQCk6B0TXRzwYRA/yUl/YxDVgcO0=;
	b=hrwe4qYPq1w04ZgQ009YBCyQto5caWVW8vG4R0ZG2W7he6pXJMANUS32dfs1k9e2SEm3
	 /1J9K8FO6Md5/XoF4P+pQ+9OgyoDKnXwqKT/6TE8Cq/Sp/CtBiJ/i6UL2SqUu3s0K2icL
	 rgJfyPc/FYmOuAEIJTfvrC+/+vmoV0S2tE0cdjvt81QDJpG/sMu5IEbO5byK1Gm6pXCkg
	 VLd1sVq66PbLB0x/6dCq8GcQdotpgjXt1GUCmVNM9u2H1MEuUV/ORuMjSZgulPkCvk7oG
	 UPEyQXtLWKd25IK0cHXX/gRNpzUrMwHPdQ4w+YkffNfcL73ZYO6fg1LaFVv8Y489r7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ch3lX2pH;
	arc=none smtp.remote-ip=95.215.58.103
Received: from mta1.migadu.com (out-103.mta1.migadu.com [95.215.58.103])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D37606A326
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 02:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86D37606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ch3lX2pH
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=XSuHP4UyXY7nNfpzAF+ETikjdPrKosoEzr/m5fHrUs0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793674193; v=1; x=1794278993;
 b=ch3lX2pHucVN3az6xFbPq9D0Yf/V3tnihd5LUpkAemdTltzwAiZOQ7gLe1iLhyqgOBUAwJbA
 vlPjok6zTaFT+vKZqcNxHDBliVozPF5NLcO+75qxgbCUtHGM6iiq+ChyN+klPega+sHq3HL9s2i
 Qlf3VgC3Xehd8VwKLATR6v90=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id bcd78dcc4447aa2e;
	Tue, 03 Nov 2026 02:49:53 +0000
X-Mizu-Trace-ID: bcd78dcc4447aa2e
X-Migadu-Flow: FLOW_OUT
Message-ID: <75d65d5e-b64f-4b04-b96a-1746858f5441@linux.dev>
Date: Mon, 2 Nov 2026 18:49:49 -0800
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
Subject: Re: [PATCH] RDMA/cma: Don't warn when device removal races with
 rdma_resolve_addr()
To: Deepanshu Kartikey <kartikey406@gmail.com>,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: jgg@ziepe.ca, leon@kernel.org, metze@samba.org, stfrench@microsoft.com,
 xiongweimin@kylinos.cn, ammrat13@gmail.com, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+6699995b421c8ec7d2fe@syzkaller.appspotmail.com
References: <20261101105615.20253-1-kartikey406@gmail.com>
 <577128ea-4d44-45cd-8b3e-5f103e530d98@linux.dev>
 <CADhLXY6WuOVmZLkgffcy2yd5tuOBPKYm38mhBFy4LRTQ89ZDuQ@mail.gmail.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CADhLXY6WuOVmZLkgffcy2yd5tuOBPKYm38mhBFy4LRTQ89ZDuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/11/2 2:08, Deepanshu Kartikey 写道:
> On Mon, Nov 2, 2026 at 1:56 AM Zhu Yanjun <yanjun.zhu@linux.dev> wrote:
>>
>> 在 2026/11/1 2:56, Deepanshu Kartikey 写道:
>>> rdma_resolve_addr() on an unbound ID (RDMA_CM_IDLE) first binds it with
>>> cma_bind_addr() and then moves it from RDMA_CM_ADDR_BOUND to
>>> RDMA_CM_ADDR_QUERY with a second cma_comp_exch(). These are two
>>> separate steps. Once the ID is bound it is attached to the device, so
>>> cma_send_device_removal_put() can find it and set RDMA_CM_DEVICE_REMOVAL
>>> before the second step runs. The exchange then fails and hits the
>>> WARN_ON() added by the commit below.
>>>
>>> syzbot triggers this with RDS over rxe, where rds_connect_worker()
>>> calls rdma_resolve_addr() while the rxe device is being deleted:
>>>
>>>     WARNING: drivers/infiniband/core/cma.c:4120 at resolve_prepare_src
>>>     Call Trace:
>>>      rdma_resolve_addr
>>>      rds_ib_conn_path_connect
>>>      rds_connect_worker
>>>
>>> This is a valid race and not a kernel bug. If removal wins before the
>>> bind, cma_bind_addr() already fails and the error is returned to the
>>> caller, and err_state in the same function already ignores a failed
>>> state exchange. The caller gets -EINVAL, and RDS destroys the ID on any
>>> error from rdma_resolve_addr(), so nothing is leaked.
>>>
>>> Drop the WARN_ON() and keep returning -EINVAL, and document in a comment
>>> that the state may change because of device removal.
>> Resend this becase some error occurred.
>>
>> For this specific case, we can consider this behavior expected rather
>> than an error and remove the WARN_ON().
>>
>> However, I'm not sure whether the WARN_ON() is still necessary for other
>> test cases.
>>
> Hi Yanjun,
>
> Thanks for the review. After cma_bind_addr() succeeds the state is
> ADDR_BOUND, and the only legitimate change before the second exchange is
> device removal (cma_send_device_removal_put() sets DEVICE_REMOVAL under
> id_priv->lock without comparing the old state). The other ways to fail
> are ULP misuse (a concurrent destroy or a concurrent call on the same
> ID), and those still get -EINVAL returned to the caller, as before.
> Only the stack trace is dropped.
>
> I can send a v2 that adds a comment explaining the race, and keeps the
> WARN_ON() for states other than DEVICE_REMOVAL if you or the
> maintainers prefer. Please let me know.

I think sending a v2 would be better. It would be good to keep the WARN_ON()

check for other unexpected states and add a comment explaining why 
DEVICE_REMOVAL

is a legitimate state in this race condition. This preserves the 
existing error detection

while making the code easier to understand and maintain.

Yanjun Zhu

>
> Thanks,
> Deepanshu

-- 
Best Regards,
Yanjun.Zhu

