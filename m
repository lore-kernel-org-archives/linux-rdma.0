Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A618B67E;
	Mon,  7 Sep 2026 05:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788759588; cv=none; b=cVwFikvPQH01abRv5AvH886yofqaFzUNXkjBd0fXkxRongCsMe7z+cx6RPa59dJmqBP5IODQ48i7kjOWAdvH7cWHig/swxry8vvrUcvA1dyF8S4t6B8bC4DzaztE8kVir8gH+6plTW+B8xD0nGnV3xtWOwiW8KyTAV4WzUVIAQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788759588; c=relaxed/simple;
	bh=1ayE33JIYEgD8v2D8aiKYUHjDj35pSwuimK8pvsU9TI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TFxa9UTq8E5Vq6lVV/ObERCmzKoquVJrEUDQksnNJ+Y/RGH8m7Y2Ly48LaPtVqlBRuT2fyBaaK2PRofeM7hpyf+rHeSGcBjfvfuN49k9QZQaQ6GF4chg9qP21NgwkY+sx8fiefqdf9jm9RCQFdSS03+0ckiIAKFEtXvRCiuR200=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ysz+RQQv; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ysz+RQQv"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68741TCw786605;
	Mon, 7 Sep 2026 05:39:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7I11SF
	9E/mQe/lwfM/926kpmsrcGT+7JJpNnz49U6r8=; b=Ysz+RQQvFMtGUumCBNJ9bG
	dMGWjUIIuhpxQrWWcUzUEsyWI3yHryYCUbkgHT32uRKdHLybQhbOiN0Hr+u5u7kR
	8Xyuy0P+/Va6ScmEx2QkI79thIklnT6Ur3Xtz+q6B656JeocKPI6lOlyKmHdLHc3
	vEy0pCNFcbgD0w5HBk2UDfeLn4XVNy7EnXAKkN9HM74vqcgk/zhL7vT3w1jOqCGf
	zm4twOwDV/RUTQJkVAWCM3AcrwArZ9pOPxA4kpHNv6qdoPCOgVE0jwJzN9JVG4RQ
	c8dm5I29sKiIyG9SPjtKa9ZKmomyqkNrj3AeZBAV6II5cCOtJ/M6b81eEjjNklYA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhket6d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 05:39:40 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6875QFpu002205;
	Mon, 7 Sep 2026 05:39:39 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gh03y3ww1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Sep 2026 05:39:39 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6875dbUn60686746
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Sep 2026 05:39:37 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 331FF5805A;
	Mon,  7 Sep 2026 05:39:37 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E3DA5805E;
	Mon,  7 Sep 2026 05:39:31 +0000 (GMT)
Received: from [9.39.28.204] (unknown [9.39.28.204])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Sep 2026 05:39:30 +0000 (GMT)
Message-ID: <7a174d1f-80d8-4294-ae66-829c9dacd662@linux.ibm.com>
Date: Mon, 7 Sep 2026 11:09:29 +0530
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: do not credit bytes that splice() did not
 take
To: Simon Horman <horms@kernel.org>
Cc: alibuda@linux.alibaba.com, dust.li@linux.alibaba.com,
        sidraya@linux.ibm.com, mjambigi@linux.ibm.com, andrew+netdev@lunn.ch,
        tonylu@linux.alibaba.com, guwen@linux.alibaba.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        pasic@linux.ibm.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260820085543.967490-1-hidayath@linux.ibm.com>
 <20260824104758.996259-1-horms@kernel.org>
Content-Language: en-GB
From: Hidayath Khan <hidayath@linux.ibm.com>
In-Reply-To: <20260824104758.996259-1-horms@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDA1NyBTYWx0ZWRfX4u+t7fQl2RVb
 XG1qdyrb5WVSPGcig18fnExe9PcvFaMjNba6CIz+AWtuFKThnZtxKJaWq+aTCG7UucqEZeDNhFN
 0+c5cD2j/yBMFZNgFiN0cl4GOfhCh30=
X-Proofpoint-ORIG-GUID: 1SPqgldcfgpyxhbU5BXxrvwhO0sCyYsg
X-Authority-Analysis: v=2.4 cv=NMDlPU6g c=1 sm=1 tr=0 ts=6a9e4e1c cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=9R54UkLUAAAA:8
 a=VnNF1IyMAAAA:8 a=NNFXEjkSxkYUhrEG1f8A:9 a=QEXdDO2ut3YA:10
 a=YTcpBFlVQWkNscrzJ_Dz:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDA1NyBTYWx0ZWRfX3ROHL8dc7Ns0
 tNShS6ovtdNVdqN32s8HcNoRBk5Q+QRQfazQKTiKVpcMj5iGz1ldttUo3gZ02yj1IUbtJ1Eo2zV
 m3G3NKAIjzrvWPvUgwmPmbWBBDjWv0soueQ7lTmkHijPJM4TYLubIcWmDAs3PjAPgoIogFEoZo4
 YZhfNabEyfXbfkf70Jhpj6sX1lDU/YBkRV0AWkEeoKCwjHOgNDqfx9ZSncNTsOZbmD+r2fF21qY
 tvZdQSfjnPv6ywkVE5efgH8h50hGb0jPcfZ4OoaQKoiOAOf9i4OeKgap4qRWYh3XcP+s89rnM5Q
 +E0LVyyBb76kEE5YDVHEzscc83aF56aIS5JwFzoIobenrEiddLX4HzRIzyHjcVWNyhY9DwL1VCb
 BRNsKPOQPbwL63AUoCFJrG+Hm68ctR9eL4x5Fu5+aZ5DxpquocNy+Gev7SZ6HNEyqDbViGNeHAO
 +POIfu6cGEls3f4+Ahw==
X-Proofpoint-GUID: 5603NIrZcwhNm_tGCvePs_yuVBcXFvzA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_01,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070057

Thanks for the review, Simon.

All four points are correct. Because the 3rd point removes part of the 
patch,
v2 will be sent as a series.

On 24/08/26 4:17 pm, Simon Horman wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260820085543.967490-1-hidayath@linux.ibm.com?part=1
> ---
> net/smc: do not credit bytes that splice() did not take
>
> The patch adds a short-count path to the chunk loop in smc_rx_recvmsg()
> so that only the number of bytes splice_to_pipe() actually accepted is
> credited to copylen, read_remaining and read_done.  It also adds a
> zero-count path that returns -EAGAIN when nothing was taken.
>
>>      A pipe that is not empty is enough to hit this; SPLICE_F_NONBLOCK on a
>>      full pipe produces the zero case.
> [Severity: Low]
> Is "A pipe that is not empty is enough to hit this" accurate?  A non-zero
> short return from splice_to_pipe() requires smc_rx_splice() to submit more
> than one page:
>
> net/smc/smc_rx.c:smc_rx_splice() {
> 	nr_pages = !lgr->is_smcd && smc->conn.rmb_desc->is_vm ?
> 		   PAGE_ALIGN(len + offset) / PAGE_SIZE : 1;
>
> For SMC-D and for SMC-R with physically contiguous RMBs nr_pages is 1 and
> the single pipe_buffer carries partial[0].len == len, so the transfer is
> all-or-nothing.  Together with wait_for_space() in splice_file_to_pipe()
> guaranteeing at least one free slot on entry, doesn't the short-count case
> only occur for SMC-R with is_vm RMBs?

Yes. For SMC-D and SMC-R with physically contiguous RMBs, nr_pages is 1, so
the transfer is all-or-nothing. I will clarify in the commit message that a
short count only happens on SMC-R with virtually contiguous RMBs (is_vm).

>
> Would it help to name that configuration in the changelog so backporters
> know what to test?
>
>> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
>> index 5c9e4d8b57de4..d951dbe8eec3c 100644
>> --- a/net/smc/smc_rx.c
>> +++ b/net/smc/smc_rx.c
>> @@ -488,6 +488,24 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
>>   						read_done = -EFAULT;
>>   					goto out;
>>   				}
> [Severity: High]
> This isn't a bug introduced by this patch, but since the patch reworks
> exactly this accounting: does this pre-existing exit leak bytes_to_rcv on
> a wrapped read?
Yes. The "goto out" skips atomic_sub(), so chunk 0 bytes are never
subtracted from bytes_to_rcv. But the pipe reader still updates the cursor,
leaving bytes_to_rcv permanently incorrect.

I will fix this in the series: when chunk 1 fails after chunk 0 was
delivered, set copylen to chunk 0 length and break instead of "goto out".
The memcpy_to_msg() path has the same problem and will be fixed as well.
>
> For a read that wraps the ring, chunk 0 can succeed and chunk 1 fail.
> smc_rx_splice() has already committed chunk 0:
>
> net/smc/smc_rx.c:smc_rx_splice() {
> 	bytes = splice_to_pipe(pipe, &spd);
> 	if (bytes > 0)
> 		atomic_add(bytes, &smc->conn.splice_pending);
>
> and the queued buffers advance the consumer cursor when the reader drains
> them:
>
> net/smc/smc_rx.c:smc_rx_pipe_buf_release() {
> 	lock_sock(sk);
> 	smc_rx_update_cons(smc, priv->len);
> 	release_sock(sk);
>
> Chunk 1 then finds the pipe full.  fs/splice.c:splice_to_pipe() converts
> no progress to an error rather than 0:
>
> 	if (!ret)
> 		ret = -EAGAIN;
>
> so control takes the quoted "if (rc < 0) ... goto out" with read_done ==
> chunk 0 length, jumping past the only debit site in smc_rx_recvmsg():
>
> 	atomic_sub(copylen, &conn->bytes_to_rcv);
>
> Doesn't that leave cons advanced by the delivered bytes while
> bytes_to_rcv still counts them?  smc_rx_data_available() reads
> atomic_read(&conn->bytes_to_rcv) - peeked, so would a subsequent
> recvmsg()/splice() start at the advanced cursor and copy that many bytes
> of stale RMB content from past the producer position?
>
> Also, can the documented invariant "0 <= bytes_to_rcv <= rmb_desc->len"
> be violated if this repeats?
>
>> +				/* splice_to_pipe() takes only what the pipe
>> +				 * has room for, which may be less than was
>> +				 * offered, or nothing. Account what it took
>> +				 * and stop: crediting the whole chunk would
>> +				 * advance the consumer past data the reader
>> +				 * never received.
>> +				 */
>> +				if (!msg && rc < chunk_len) {
>> +					if (!rc) {
>> +						if (!read_done)
>> +							read_done = -EAGAIN;
>> +						goto out;
>> +					}
> [Severity: Medium]
> Can rc ever be 0 here?  splice_to_pipe() returns 0 only for
> spd->nr_pages == 0, and otherwise ends with:
>
> fs/splice.c:splice_to_pipe() {
> 	if (!ret)
> 		ret = -EAGAIN;
>
> smc_rx_splice() always builds nr_pages >= 1 and returns the
> splice_to_pipe() value unchanged, so the "took nothing" case arrives as
> -EAGAIN and is consumed by the pre-existing block above, which reports
> -EFAULT to userspace.  Does that make this "if (!rc)" arm unreachable,
> and the changelog claim
>
>       When it took nothing, return -EAGAIN instead of reporting a length
>       that was not delivered.
>
> not take effect?
Yes, it is unreachable. smc_rx_splice() always passes nr_pages >= 1, so
splice_to_pipe() returns -EAGAIN instead of 0.

The zero case arrives as -EAGAIN, which the existing code turns into
-EFAULT. In v2, I will drop the dead arm and return rc directly instead
of -EFAULT (which also fixes -ENOMEM reporting). I will also reword the
comment.
>
> On the same note, does "SPLICE_F_NONBLOCK on a full pipe produces the
> zero case" hold?  splice_file_to_pipe() calls wait_for_space() before
> do_splice_read():
>
> fs/splice.c:wait_for_space() {
> 		if (!pipe_is_full(pipe))
> 			return 0;
> 		if (flags & SPLICE_F_NONBLOCK)
> 			return -EAGAIN;
>
> so a completely full pipe fails before smc_splice_read() is entered.
> Should the comment block above also be reworded, since it describes a
> callee returning zero that splice_to_pipe() does not do?
>
>> +					copylen = chunk_len_sum - chunk_len + rc;
>> +					read_remaining -= rc;
>> +					read_done += rc;
>> +					break;
>> +				}
>>   			}
>>   			read_remaining -= chunk_len;
>>   			read_done += chunk_len;
> [Severity: High]
> This is a pre-existing issue outside the diff, but this patch depends on
> the invariant it breaks, so it may be worth mentioning: in
> smc_rx_pipe_buf_release() the cursor advance happens under the socket
> lock while the splice_pending decrement happens after it is dropped:
>
> net/smc/smc_rx.c:smc_rx_pipe_buf_release() {
> 	lock_sock(sk);
> 	smc_rx_update_cons(smc, priv->len);
> 	release_sock(sk);
> 	if (atomic_sub_and_test(priv->len, &conn->splice_pending))
> 		smc_rx_wake_up(sk);
>
> smc_rx_recvmsg() assumes cons plus splice_pending marks the start of
> unread data:
>
> 	splbytes = atomic_read(&conn->splice_pending);
> 	...
> 	smc_curs_copy(&cons, &conn->local_tx_ctrl.cons, conn);
> 	...
> 	if (splbytes)
> 		smc_curs_add(conn->rmb_desc->len, &cons, splbytes);
>
> In the window between release_sock() and atomic_sub_and_test(), cons
> already includes priv->len and splice_pending still counts the same
> bytes.  Can a concurrent splice on the same socket then start priv->len
> bytes too far, skipping unread data and handing stale ring content to the
> pipe?
>
> The recvmsg() path looks protected because it waits while splice_pending
> is non-zero:
>
> 		if (!readable || (msg && splbytes)) {
>
> but the splice path (msg == NULL) is not gated on splice_pending.  The
> pipe mutex doesn't serialize this either, since splice_file_to_pipe()
> holds only the destination pipe's lock, so draining pipe A can race with
> splicing the same socket into pipe B.
>
> Would moving the atomic_sub_and_test() before release_sock() make cons
> and splice_pending change together with respect to the socket lock?
Yes. I will move the subtraction inside lock_sock() and keep the wake-up
outside. I will send this in a separate patch.

v2 will follow as a series

Thanks,
Hidayath
