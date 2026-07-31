Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674A72DF3EA;
	Fri, 31 Jul 2026 07:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.22.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785484105; cv=none; b=daQYqzrOvZRtcKpE/QyhtWMo6NJQtqx56BHC6+lE1CZPcBQOHJPKsWIyiytboxidYuqzs3/UUqpN+hVoKsIZ63w6u+lqPjW/0mbyJ2wfVV1ixdacz84gPHW6XRXCW1NnVUgUrVBy+55WTxMv/4eUmsPXpzt3zNQzkQts+1grIUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785484105; c=relaxed/simple;
	bh=YRbgYrI2in1OagB5eEC7q4kyXL/MKuvjfJ9CmLXvtuk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GY0mYXwNszttZtRQB7bYPgUoXrXscm1A7TV2dnhlDRDFw7TWY1Xa2z/fYBYWbsCSGAr0zWoTqm2Hjf43hMZUc1LN6Un5Ck9cHfe0duHOnona6XbDY1ockKCAmd8UQCtay//OTJrqFG6bcR0aArYofTPhwsSP72uB/RorcwO++pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=Jr6l9mNp; arc=none smtp.client-ip=54.207.22.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="Jr6l9mNp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785484071;
	bh=j21Dw6xROaTMQecO0BO9iq0AyKrsHh5yK8KVdRpYgEY=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Jr6l9mNpFeMDS/O0HCAH+6CupqI1EMu7J3Yw1g0nKqmaR/Dk5SCewwF+XjxkCj2kf
	 dYmp4tGOqCq8PVx0DIqYGm2xZRB0VbHlhU1JVmMzsdOa3xJoaWle0SLQEq4m1k8z/Y
	 ZXnd/SwkZAE2Jnynssi4uDnA9kFIlgwR3KILUs2o=
X-QQ-mid: zesmtpsz8t1785484064ta95e2761
X-QQ-Originating-IP: Y5/G7RGXiE0Q0p/zXZHyea8lWScHsc+Gf87dUwJ96Gg=
Received: from [127.0.0.1] ( [36.152.24.163])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 31 Jul 2026 15:47:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3901282503883598559
Message-ID: <3422EBF9B30F1E33+4cfae8a5-d16d-481a-9059-5e0e15faee71@smail.nju.edu.cn>
Date: Fri, 31 Jul 2026 15:47:42 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] RDMA/rxe: memory leak in rxe_qp_from_attr
To: "yanjun.zhu" <yanjun.zhu@linux.dev>, jgg@ziepe.ca, leon@kernel.org
Cc: "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
 linux-rdma@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <357830C4A3236804+c7b5ccba-01ba-468f-97c8-cb6053a8b771@smail.nju.edu.cn>
 <a35ece69-60af-4a82-a0cd-da1aeb9c60dc@linux.dev>
Content-Language: en-US
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
In-Reply-To: <a35ece69-60af-4a82-a0cd-da1aeb9c60dc@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NPR7uEA6bBhoe42/WtEUPN8zPohO7+OyudDOCEUpIqUqG5VOO7JXI9mU
	s2T/H6P46Dxq1Ct6+O+Y7ifoyUFCVwdpPHQW0x+lYRBqv6b40FIn9jrJy4OPD7MLbPb1kAJ
	Q2Wzao5JjZ/wlSPx0TdVzPXVDww664B0uzQVl7v9iZz26qhvXJoOwNHEGBC17uGpuTYf2xc
	1E6lIkmjOpLA3KoZ409PUjVqrFUHiUZcH5S09DZvgKrotFpHXkhGDeqEcbkUm2KtgXa7G1F
	SN2Q+4o8VYUCDmK1MNqSUmtsxg8DZ1UOaPobic9jpY+P2QPww2SW77hM75HBiJNC8iKyZ1/
	CyAxvNrOQRI2wKavlh04vrQmbS9ZkLfvniUqlJJSZsyxrwCkW2q0Z2mnVmchEc5lKx/jPHJ
	VGiARHGlHEQrAYR7Gl9vujymUa1BCijTVcODFWZXLrGICeZGE/ZIHgoGUYQ3ivYlJ3z2heW
	ZsqZZybpAdL9vW1bQdrlf197Ar3z8UX9BCPBzG8d5hCc74y/Z2SZObRDs+MnDaXFvvCxfwt
	yo6+cIQT2TD+l/f+b2cbQrSBUKOoV0LSAXkQ+6k1b53fnz+USKUWmrG9kub1VZ1sjxBkA90
	4J+uTYr4N0FjdwpJ1PMsY2/UF7YpehS10KFS/dafPN/jc0L0xS45b1w892abgfvWft0X2f3
	0mjtoH9G7YGj5ONqu/HhPjJfuHeCsN2U7NYHc4OOvTsXEMM2j+RnrrE+9DtZ/0EKXyvvCdc
	FQ05vm7Tj0z39hjCoq4f+Ow3II4oCa9bfHANpfLFyabwfDSwJbuaXgpq7p/f2QnHSzZfU8A
	wJHK1nGKgPmryB4gPGGLigV/lf4No5PHhoEltIvwWJ++TeOJDh+ZKbenVbx4Q7X7Fi0GiiJ
	Ti1zgBWsUTgh7fM2IXYc1Txlh5wCo+k+6OFsuxGiil8hHM5/2ccXo3viTYpbP0Im2duy1Bl
	4O1gw63TYZ2CIW3SL6iz8TCDpvaiU+SiMjJfUKrKOnjg5ypojBrE6HCL9Wvc6wSF6E2Rc/S
	BhlylzsmGZltX3NcJyRMBfaZx7zNwMKBy15A496w==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0

On 2026/7/31 02:07, yanjun.zhu wrote:
> On 7/30/26 1:40 AM, Peiyang He wrote:
> 
> Thanks for the detailed analysis.
> 
> From the RDMA usage perspective, concurrent MODIFY_QP operations on the same QP are not normally expected in real workloads. Typically, after a QP is created and transitioned to the required state, applications use it for communication. If a QP attribute or resource needs to be modified, it is usually done by the owner thread/process in a serialized manner rather than by multiple threads concurrently modifying the same QP.
> 
> However, since the kernel interface does allow such a scenario, especially under malicious input or fuzzing environments, the driver should still handle this case safely.
> 
> For the fix, I agree that the resource replacement path needs proper serialization. My preference would be to reuse an existing QP lock if there is one suitable for protecting QP attribute modifications, rather than introducing a new `rd_atomic_mutex` specifically for this field. Adding a new lock may increase locking complexity and could introduce additional lock ordering concerns.

Thanks for your suggestion. I looked into the RXE code and it seems there is no suitable existing lock we can reuse to serialize QP attribute modifications.
There is a spinlock_t state_lock in struct rxe_qp. However, since the IB_QP_MAX_DEST_RD_ATOMIC path in rxe_qp_from_attr() will eventually call kzalloc(GFP_KERNEL), using this spinlock may not be the best practice.> 
> It may also be worth checking whether other QP attribute modification paths have similar concurrency assumptions. If the QP modify path is generally expected to be serialized, protecting the broader QP modification operation with an existing lock might provide a more consistent solution.

Yes, rxe_prepare_res() and find_resource() also use qp->resp.resources. They should be serialized with rxe_qp_from_attr() as well.

Thanks,
Peiyang

