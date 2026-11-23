Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.33
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795404203;
	b=2O96xiQovPxLc2K7scVnRyOpr5AS1hwwhB9XboYlNr08UmSk5/jzoGfM5b+Fzluj9X+O
	 hcoHuaPvwn3EgJ1BGTSoNwPC5JlVPsAtKuEGByHiyrxNaGu1obBEGBUl+HZqluAjCu5Yp
	 ETw0beEDzxSazRzHK1F4ZrsTkiha2uakQXefroErqMFx6Qw/0w+5YxUMpR3m+F31eo1aN
	 jGPltMJb9vf3nSE4q5sO2AwLLpQYrzsK/TIKUorIxBehTkBBou12m88u2ZI45prPzUS1P
	 ATXBEa+WRTvZ9q6tpAK7HdTte1lf8Gbce54eRXpwfFUjdFsTK4Qh2dz+3PlLFYe4ULg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795404203;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=os6B77HbQFFqlElEABpssTymFjkcw1LNcBBfr9CvWEw=;
	b=FBNaQG+Mhz3MMwufi3H5JQs9mHVy/4sgD5+P5AAWT+xPPe5P1OM89Ecxb6opJDDrfhsI
	 oSIMmY7S22aUvvuP+qfIFDy7H2CEV/KyqqtftogRWd5WwIa9d0wscVDNRKz81ADQNnVPB
	 S9Xk+7SkSNcuhRw/HL6Hf0GBg6vPk9J0uIR3Lmlo5t4z/ecupal6NlsgRcP5ZuNhkXEPB
	 y58TKn0UyFVMGKbJIevGZh6+728U8MBWetx42RqG+bHXWYmZ8LgwLFyFVzhZ+W5HLw1nV
	 XuZoBx+D2/E1uQURoInAg3OIl2PzZHrZ0lagiSO0JQs6PS5lwO4hbvmo7ZjNXIRc90w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bWGV+2AA;
	arc=none smtp.remote-ip=91.218.175.33
Received: from mta0.migadu.com (out-33.mta0.migadu.com [91.218.175.33])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B24B606A31A
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 03:23:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B24B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bWGV+2AA
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=0u39niVwbFOFUZ3XAAWfl3hK/+/xR+0nbPg5QI1AfQE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795404200; v=1; x=1796009000;
 b=bWGV+2AAmSGY24gyHwTKho7oXVuHuCrZzCDeDUIwLCXglvxxSKvxmYwMgo4HM+Svgr0TtDDo
 CAEToaIwDNmkO40phJC5f4XpkccZo6sxcAYEmcELjghhjUjugaMiFM8dB4IQhNiZBJPb6DPyuvj
 EY+JACjy+4AtbtBl3LpQOjew=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0c05b397e295a58f;
	Mon, 23 Nov 2026 03:23:20 +0000
X-Mizu-Trace-ID: 0c05b397e295a58f
X-Migadu-Flow: FLOW_OUT
Message-ID: <42d52366-8409-4c64-8f52-c99272bb85c3@linux.dev>
Date: Sun, 22 Nov 2026 19:23:15 -0800
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
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Mask the SQ producer index read
 from user space
To: Shuai Liu <847807867@qq.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, zyjzyj2000@gmail.com, jgg@ziepe.ca,
 leon@kernel.org, rpearsonhpe@gmail.com,
 syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <6adb54ac.d1cee5ca.8df35.0007.GAE@google.com>
 <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
 <tencent_BEE58D9BBE7109C47C2796DDF5A4B958F609@qq.com>
 <3a58ba4f-fd64-4144-8635-4b99983f7640@linux.dev>
 <tencent_F2E2C28A054CC8B94B4973B1ACCB0B34BD0A@qq.com>
 <270a5fbc-9711-4664-9de8-64c150eb5307@linux.dev>
 <tencent_798DB4150B83BC51530EAEA918DFC491FB06@qq.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <tencent_798DB4150B83BC51530EAEA918DFC491FB06@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/11/22 16:35, Shuai Liu 写道:
> Hi Yanjun,
>
> I tried to use #syz test, but the command is currently disabled for the
> email interface. See
>
>    https://github.com/google/syzkaller/issues/8122
>    "syzbot: `#syz test` command is temporarily disabled" (opened 2026-11-11,
>    still open)
>
> and the dashboard silently drops such requests without sending a reply, so
> there is currently no way to get a syzbot test result for this patch.
>
> For now, the full serial logs of my local verification are attached
> (gzipped). Both runs use the same kernel and the same syzbot reproducer,
> only difference is whether the patch is applied:
>
>    fix-v2-run10.log.gz
>      - patched kernel, reproducer bounded to 100 seconds
>      - zero "rxe_pool.c:212 at __rxe_cleanup" warnings, no BUG/Oops
>      - "=== REPRO DONE rc=143 ===" and "reboot: Power down"
>
>    base-run4.log.gz
>      - same kernel with this patch reverted, same 100 second bound
>      - the same WARNING repeats once per reproducer iteration, together
>        with "rxe0: qp#17 rxe_destroy_qp: cleanup failed, err = -110"
>
> I will re-send #syz test on this patch as soon as the command is enabled
> again and follow up on this thread with the result.

Thanks a lot. I checked the dmesg logs in the attachment. I am fine with 
this commit.

Zhu Yanjun

>
> Best regards,
> Shuai Liu

-- 
Best Regards,
Yanjun.Zhu

