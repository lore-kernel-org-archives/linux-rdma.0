Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC9A451999;
	Tue, 11 Aug 2026 17:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786470011; cv=none; b=d7CqzMyFlGLQfgllqbI4co6RvYd/pkLar/6rPE1b3MCupjDn7ChqBxKS8XaWyH8mGd4fHFf+fEVEhSJIggo+qH1U00dqboujDxttZntrjHYBlVXzXWWHthy2DRRswfFcwrwo/JJX4H4SxWRcycHS8eXbrBNydFn0vMKU+eNpqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786470011; c=relaxed/simple;
	bh=jAEFoIypcMJEHz7ico4YwgC/lcPYxGnTr9vL8aVw5rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fE3dKWoMBNr3GinurcweulxCuyG5fbD4lgcTR5Nu5zOUIn184t5sNUTLk7LF9W1Nh/LxYMIN/ca2C0YKemU3ovSqHIxQF5zyRGjAIcXlUxa2vb270rmIA3gjCK/KBwxAK6TSYUdPYfi8ehDHYWft3HqRzEG+HLCLUj5BPLfbIzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ULAwL0SP; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ULAwL0SP"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67BGVnGA4030061;
	Tue, 11 Aug 2026 17:39:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=P2tmqp
	hf9PS6CV3eg/wZ4xpBxzadhL8621i6oaSbuJ4=; b=ULAwL0SP4KTU+YSn/nweP+
	2eiAKPD8pIQhdomCbiA6zkThYVi/jTg1TOHIs0BhZETRpTzNqaxwYej7apFeCQSc
	9/Opx/VFLi9+ry4cMOC7hiCdwdlBZy4+sxrGod65juOsciOJCwgx7i8qgjaQfhL2
	dMnWG0dBd4z6zSVPBck3ytnkDhmL5X5sCb9SHya6/KvYd0bgmSnDrStKroabjbSJ
	NqXJmrr+75ybDCdKfOervkdG+y9VzQXGpFK+El7/g5abFbAKEKYrMb/XpmxFDE/l
	z+lZ/4okl9ay53y8JlH1rDteIul7nbmGE4iYOcUiNS4uuwVGHMbAl0TWzrLpcW1A
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fyb23px78-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 17:39:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67BHQFif013455;
	Tue, 11 Aug 2026 17:39:55 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxfsjt1ay-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 17:39:55 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67BHdrZ232113398
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 17:39:53 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 76A8258059;
	Tue, 11 Aug 2026 17:39:53 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91DDC58055;
	Tue, 11 Aug 2026 17:39:48 +0000 (GMT)
Received: from [9.39.24.110] (unknown [9.39.24.110])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Aug 2026 17:39:48 +0000 (GMT)
Message-ID: <dbb06d1d-17cc-4316-8efc-8e27c9bbef2e@linux.ibm.com>
Date: Tue, 11 Aug 2026 23:09:46 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/smc: abort the connection when the peer
 overruns the RMB
To: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>,
        "D . Wythe" <alibuda@linux.alibaba.com>,
        Dust Li
 <dust.li@linux.alibaba.com>,
        Sidraya Jayagond <sidraya@linux.ibm.com>,
        Mahanta Jambigi <mjambigi@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260808081242.409253-1-hexlabsecurity@proton.me>
Content-Language: en-GB
From: Hidayath Khan <hidayath@linux.ibm.com>
In-Reply-To: <20260808081242.409253-1-hexlabsecurity@proton.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XqfK/1F9 c=1 sm=1 tr=0 ts=6a7b5e6c cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=5K2vC9JcGIupk1VW3fYA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDE0NyBTYWx0ZWRfXwbfteqk7RFeS
 PG50MHmnCP4MNAuG9PcNIp9e7ia6nIMlxbq7/fcL1sULUHURVfOq7zEkAFK3TeXgsZU93YRgUI6
 +yI86KASPx851WtcFRRfFk/oUzMliCxJSSQ/yCnskWN4U/y7L5ygojoos0yzZ/s8DMPf7FIc/03
 JNGhRGYJEVZA17NZXrmqUcdpOQd4tXS4+BnFFp019dIT2wN7n5lhWQyQrXkMpQ5ZAuVALhZ3BRq
 JV4UxKZORQvpJl/6GgBOvcL0SwVqUC19BeQqY7k72SfGYkSbjYmZwLeB7SJ1bi2MtZQebyc4QwO
 XGv4ioJ579Plr8377nII/vtNHQvSsKJTV0Us7NIvaEZnEHX/wKuQRoL6S+a1lsAXK1WADm7qYPV
 DhbbLBlmMjhlY6kb+JX8QveNpC7qMFyDUA7pCDEXWa3H8o/Ja4PErdr9Z2RxkP7CkIny2fh2irx
 G/u92d+E9L935sNtO9g==
X-Proofpoint-ORIG-GUID: OoQSMA3OXODw6brNh61hxbrYXp2pDwwk
X-Proofpoint-GUID: IOqm7tqt-wkjUsO2kEKPkRwNtT3NBXJq
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDE0NyBTYWx0ZWRfX+5/datP3egfs
 OmaMLJMp2bauzpzQ9sadIFyqK4C47mqL/cOp1meqgYLYXJGkylOtLnHfBJqoUbVC/LZEFtjNpuA
 +zMVDju+lkOFY4AEWNCuFfeY/Bs/gKM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-11_04,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608110147


On 08/08/26 1:42 pm, Bryam Vargas wrote:
> Hidayath,
>
>> I have a standalone net-next patch that aborts the connection when
>> bytes_to_rcv + diff_prod exceeds rmb_desc->len.  The check sits before
>> the atomic_add(), so the accumulator is never written with an out-of-range
>> value
> That covers the follow-up I said I would send, and the placement is better than
> what I described: I had said a check after the atomic_add, which only notices
> the counter is already out of range. Yours doesn't let it get there. Consider my
> follow-up withdrawn -- I am not sending a competing patch.
>
> If it is useful for the Fixes decision: I ran the wrap++/count==0 vector on the
> real SMC-D path under KASAN while working on the cursor series. With only the
> per-cursor bound applied, bytes_to_rcv reaches 6*len and smc_rx_recvmsg() trips
> slab-out-of-bounds on a read of 5*len; each CDC advances exactly len, so
> diff == len and an advance-bound does not fire -- it's the accumulation that
> overruns, which is what your check catches. Logs on request if you want them in
> the commit message.
Hi Bryam,

Yes, please send the logs.  I would like to put the splat in the commit
message and credit you for the reproduction.  Right now my changelog only
talks about the accounting damage -- SIOCINQ showing a length that is not
there, and poll() staying readable with nothing to read.  A real
slab-out-of-bounds read is a much stronger claim.  Any format is fine, I
will trim it.

Your point that diff == len on every message, so an advance bound never
fires, is also worth putting in the changelog.  I had argued that only from
the arithmetic, not from a run.
>
> Two heads-up on collisions, since both are in flight this week rather than
> merged:
>
> smc_cdc_msg_recv_action() is also touched by "net/smc: order the CDC receive
> path against buffer publication" (v4, 20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@proton.me),
> which hoists sndbuf_desc to the top of the function and gates the tx-trigger on
> it. Your hunk sits just above that gate, so whichever lands second will want a
> look rather than a blind rebase. I'd rather flag it now than after a conflict.
Agreed. From reading the code they are in different parts of the function
-- my hunk sits above the tx-trigger gate you add.

But my v2 also adds an out_of_sync check to
smcd_cdc_rx_tsklet(), and your v4 edits the same line:

   yours: keeps "if (!conn || conn->killed)" and adds the rmb_desc
          smp_load_acquire() after it
   mine:  rewrites it to "if (!conn || conn->killed || conn->out_of_sync)"

So they conflict.
>
> And you mentioned running the abort_work cancel for both transports in v2 --
> that edits smc_conn_free()'s SMC-D branch, which "net/smc: unregister the
> connection before draining the rx tasklet"
> (20260808-b4-disp-22f119e6-v2-1-61647601a6f3@proton.me) also rewrites: it drops
> the !list_empty guard around smc_ism_unset_conn(), moves the drain ahead of the
> detach, and clears conn->sndbuf_desc before freeing it. Same branch, same week.
Confirmed, that one conflicts too.  My v2 hunk moves
cancel_work_sync(&conn->abort_work) out of the non-SMC-D branch so it runs
for both transports.

So my v2 now conflicts with both of your patches.  Both of yours are posted
and mine is not, so I will rebase on top of both rather than ask you to
work around me.

If you would rather take the abort_work cancel into your
teardown 1/2 while you are already in that branch, please say so and I will
drop that hunk.
>
> On the shared bitfield -- agreed it needs a layout change rather than something
> folded into a fix, and it's yours; I'd noted it and left it alone for the
> same reason.
Thanks, I will send it separately.

One more thing, for information.  I have sent "net/smc: fix use-after-free
in smc_rx_pipe_buf_release()" to the list.  It clears conn->rmb_desc in
smc_buf_unuse(), which is the rmb version of the sndbuf_desc clear in your
teardown 1/2.  These are different functions, so from inspection they
should not conflict.

>
> Thanks,
> Bryam
Thanks,
Hidayath
>
