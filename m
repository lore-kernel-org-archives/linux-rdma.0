Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51D9472F7C;
	Tue, 18 Aug 2026 13:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787059958; cv=none; b=VZhlRe21OzKTaSXVOzqKJM7XlNuizr4tHVn5AeEOgKtlG/BrLqo3k2TxNCbOk07F1dlPWtSiHr9nRVPs+/PaVsOSl7USh8xd46wI1Qv1B3melqMYCqEfaifuBu9TLctGL766LVkoxXpqavyZEqFVAui1o1WJF4zTPA42Mok3SBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787059958; c=relaxed/simple;
	bh=zODo0YxaK8EvQyzyub97afGLMRh9681+5f+JksrYehQ=;
	h=Message-ID:Date:MIME-Version:CC:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YPC2aVXTYUIXYxI6FlMjKYsVDi6WFijHrrSYTdaN7/EFEL+E8FPt9s37H9kmTIYrzgZnum/wtsXcXMHcCVzD03hB7KOOTTnX54JFK60eiAVl9R0Y9CfpbEbaS9hEsfeWXiBleL4dw9xlLNwxX/GvSRGCp/z+tRffGRHbGivXAfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=loEDKz/q; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="loEDKz/q"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5Ao0mjFbvVNW/izzO3jvpj6rQ9rGRmC29qURkFZh6ME=;
	b=loEDKz/qrpzbvC0Lh9UjT1BLiZqEz5h3Fgx0xNC6h/0utCONZfj9gJxFUI9wWKVaZTuJfmffK
	7S3eS70EYvMPfFus94IwKTMYKXd5JQ8EdS5aR1dCPT/BmpIjoY3aJyPJvE1YRIqSzH+47+68a+4
	LQhcHzRcKKboSqyIuM0NyTU=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hPVj20XhbzLlTg;
	Tue, 18 Aug 2026 21:21:42 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id C5D2A4056C;
	Tue, 18 Aug 2026 21:32:22 +0800 (CST)
Received: from [10.67.120.192] (10.67.120.192) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 21:32:21 +0800
Message-ID: <dd817755-eb4d-4ac2-b282-ac06f847270d@huawei.com>
Date: Tue, 18 Aug 2026 21:32:20 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <shaojijie@huawei.com>
Subject: Re: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
To: <chia-yu.chang@nokia-bell-labs.com>, <shenjian15@huawei.com>,
	<linux-rdma@vger.kernel.org>, <eperezma@redhat.com>, <jasowang@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>,
	<xuanzhuo@linux.alibaba.com>, <pabeni@redhat.com>, <edumazet@google.com>,
	<linux-doc@vger.kernel.org>, <corbet@lwn.net>, <horms@kernel.org>,
	<dsahern@kernel.org>, <kuniyu@google.com>, <bpf@vger.kernel.org>,
	<netdev@vger.kernel.org>, <dave.taht@gmail.com>, <jhs@mojatatu.com>,
	<kuba@kernel.org>, <stephen@networkplumber.org>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <davem@davemloft.net>, <andrew+netdev@lunn.ch>,
	<donald.hunter@gmail.com>, <ast@fiberby.net>, <liuhangbin@gmail.com>,
	<shuah@kernel.org>, <linux-kselftest@vger.kernel.org>, <ij@kernel.org>,
	<ncardwell@google.com>, <koen.de_schepper@nokia-bell-labs.com>,
	<g.white@cablelabs.com>, <ingemar.s.johansson@ericsson.com>,
	<mirja.kuehlewind@ericsson.com>, <cheshire@apple.com>, <rs.ietf@gmx.at>,
	<Jason_Livingood@comcast.com>, <vidhi_goel@apple.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
 <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
From: Jijie Shao <shaojijie@huawei.com>
In-Reply-To: <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo500018.china.huawei.com (7.202.195.199)


on 2026/8/11 21:31, Jijie Shao wrote:
>
> on 2026/8/5 5:35, chia-yu.chang@nokia-bell-labs.com wrote:
>> From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
>>
>> Currently, the hns3 Rx path sets the SKB_GSO_TCP_ECN flag when a TCP
>> segment with the CWR flag set is received. This is incorrect because
>> the hns3 hardware GRO resets the IP ToS byte to 0 during packet
>> aggregation. Consequently, no valid ECN signals are carreid, meaning
>> that it cannot support RFC3168 ECN or Accurate ECN protocols. Setting
>> SKB_GSO_TCP_ECN or SKB_GSO_TCP_ACCECN under these conditions misleads
>> the upper network stack.
>>
>> Fix this by removing the incorrect SKB_GSO_TCP_ECN flag assignment
>> in hns3_gro_complete().
>
>
> Tested on hns3 HW (2x 100G, direct cable, openEuler 24.03, kernel 
> 7.2.0-rc6).
>
> tcpdump confirms HW GRO zeroes IP ToS: aggregated (>MTU) packets carry
> tos 0x0, while non-aggregated packets keep their ToS/ECN marks — so the
> zeroing is done by HW GRO, not the sender. Before patch, CWR packets had
> SKB_GSO_TCP_ECN set (0x5 = SKB_GSO_TCPV4 | SKB_GSO_TCP_ECN). After patch,
> all GRO events gso_type=0x1 (SKB_GSO_TCPV4 only), no 0x5 observed.
>
> Tested-by: Jijie Shao <shaojijie@huawei.com>


I need to correct my earlier test report where I stated:

   "tcpdump confirms HW GRO zeroes IP ToS: aggregated (>MTU) packets
    carry tos 0x0, while non-aggregated packets keep their ToS/ECN
    marks — so the zeroing is done by HW GRO, not the sender"

This conclusion was wrong. I am withdrawing that Tested-by tag.

Root cause of the error
========================

I mixed two test tools with different sender-side paths and incorrectly
compared their results:

1. The observation that "non-aggregated packets keep their ToS/ECN
    marks" came from a Python script (scapy). Scapy constructs L2/L3
    packets directly, bypassing the kernel TCP stack, so the ToS value
    on the wire is exactly what the script sets — this says nothing
    about whether a kernel-stack sender would clear ToS or not.

2. The observation that "aggregated packets carry tos 0x0" came from
    iperf3 with --tos. iperf3 goes through the kernel TCP stack, and I
    did not set net.ipv4.tcp_ecn=1, so the kernel cleared the ECN bits
    (low 2 bits of ToS) before the packets hit the wire. The tos=0x0 on
    aggregated packets was already tos=0x0 on the wire at the sender
    side — it was a TX-side kernel behavior, not HW GRO zeroing.

I mistakenly used the scapy observation ("non-aggregated packets keep
ToS") as evidence that "the sender didn't clear ToS", then concluded
that iperf3's tos=0x0 must be caused by HW GRO. But these two
observations came from different sender paths and cannot be compared
this way. I only captured at the receiver side with no sender-side
wire capture to compare against, so I wrongly attributed the TX-side
clearing to HW GRO.

New test with tesgine (direct packet construction)
===================================================

To eliminate the kernel TCP stack interference, I retested using
tesgine, a packet generator that constructs TCP segments directly at
L2/L3 with full control over the IP ToS byte. This bypasses the kernel
TCP ECN state machine entirely, so the ToS value on the wire is exactly
what was configured.

Test setup:
   - hns3 NIC, HW GRO on, software GRO off (ethtool -K <dev> gro off)
   - tesgine sends 1460-byte TCP segments with controlled ToS values
   - Capture at receiver post-GRO

Four test cases were run, each verifying a different ToS boundary:

Test 1: Non-ECT <-> ECT(0)
   Sent:  4x tos=0x00 + 1x tos=0x02 + 4x tos=0x00 + 2x tos=0x02 + 1x tos=0x00
   Got:   4 aggregated (tos=0x00) | 1 single (tos=0x02)
        | 4 aggregated (tos=0x00) | 2 aggregated (tos=0x02)
        | 1 single (tos=0x00)
   => GRO segments at every ToS change, each group keeps its ToS.

Test 2: ECT(0) <-> CE
   Sent:  4x tos=0x02 + 1x tos=0x03 (CE) + 4x tos=0x02
   Got:   4 aggregated (tos=0x02) | 1 single (tos=0x03 CE)
        | 4 aggregated (tos=0x02)
   => CE packet is delivered independently, CE mark preserved.

Test 3: Non-ECT <-> CE
   Sent:  4x tos=0x00 + 1x tos=0x03 (CE)
   Got:   4 aggregated (tos=0x00) | 1 single (tos=0x03 CE)
   => Same behavior: CE is segmented out, ToS preserved.

Test 4: Pure DSCP change (ECN bits identical)
   Sent:  4x tos=0x10 (DSCP4) + 4x tos=0xB8 (DSCP46)
   Got:   4 aggregated (tos=0x10) | 4 aggregated (tos=0xB8)
   => Even pure DSCP change (no ECN bit change) triggers segmentation.

Conclusions from tesgine testing
================================

   1. HW GRO does NOT zero IP ToS. Each aggregate group retains the
      head packet's ToS value (verified with 0x00/0x02/0x03/0x10/0xB8).

   2. HW GRO segments flows by ToS boundaries. Any ToS change — whether
      DSCP (bits 0-5) or ECN (bits 6-7) — terminates the current
      aggregate group and starts a new one.

   3. ECN signals are preserved: CE packets (tos=0x03) are delivered
      independently with the CE mark intact, not merged into non-CE
      aggregates.

Impact on this patch
====================

The commit message states:

   "the hns3 hardware GRO resets the IP ToS byte to 0 during packet
    aggregation. Consequently, no valid ECN signals are carried"

This factual claim is incorrect per the tesgine test results above.
HW GRO preserves ToS and segments by ToS boundaries, so ECN signals
are not lost during aggregation.

The code change itself (removing the SKB_GSO_TCP_ECN assignment in
hns3_gro_complete) may still be correct, but the justification should
be based on the RX-path semantic argument from patch 1/2 (SKB_GSO_TCP_ECN
is a TX-path flag; using it in RX can corrupt the ACE signal in AccECN
forwarding scenarios), not on the ToS-zeroing claim. Or change to AccECN.

I will re-verify and provide a new Tested-by once the commit message is
updated. Sorry for the confusion caused by my earlier report.

Test captures and methodology details available on request.

Regards,
Jijie Shao


