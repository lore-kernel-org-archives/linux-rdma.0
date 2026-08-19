Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41EBC275870;
	Wed, 19 Aug 2026 02:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787107911; cv=none; b=gMVMrTFyp0YPTurXZukz3rRp6l9N1MhQSdTELcwcv2Mzx/3i4q2E29D/B/nyuzAbOLUUrib3ilmIMVMO0Qojfiylgq2Zj231GQMXDRznH2jWxYwPJLyTFiejzY8kTVqNEwUyx/9tXoBhIQXwSxWBW7Wv4MwUfs/ya0FijYYRc0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787107911; c=relaxed/simple;
	bh=/806s9Z6FPuQkp69sO+d1jlqaLHZbcjzztrS7iCpl9o=;
	h=Message-ID:Date:MIME-Version:CC:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZgYIoAN9xAaJXoXE8vw1WL3eSVDf6kqeRHfz10O8FNBqAsoDESfuzVGLxqtaF9UMao2tm04pDm1+y/E5nhevkN2Ix+wIdlmidOciseOvPkvd5VqGhPnfgkqGdznMnJg/VnD5DpAHWHb3wK/dsjQw8+LS+vHQekSKevSAe6ZD+2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=XHNqjnFw; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="XHNqjnFw"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=xhtZRXjoCnMWn9mFXaTj7fZKbM8NqbXiis/kR/upGLo=;
	b=XHNqjnFwQ8sme/7g89G8PlcjwNXIUE9tyH0qII8KGgLBvvQ7VkPstRJuLBOLan4VKem0teuBz
	xa3eejrWZwF10E9W+MyaHv0o1xvI8uel43bsbfnuifTMSwXU0OPBADf7ys0t2Y8CNUnwFb8QQZH
	rd0/aVbjTzJWr4vmM8HQHx0=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hPrQv5CwkzpSvB;
	Wed, 19 Aug 2026 10:40:39 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 35A5F40561;
	Wed, 19 Aug 2026 10:51:35 +0800 (CST)
Received: from [10.67.120.192] (10.67.120.192) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 19 Aug 2026 10:51:33 +0800
Message-ID: <b1aa6136-3dc1-4190-beaa-32bee88b7091@huawei.com>
Date: Wed, 19 Aug 2026 10:51:33 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
CC: <shaojijie@huawei.com>, "shenjian15@huawei.com" <shenjian15@huawei.com>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"eperezma@redhat.com" <eperezma@redhat.com>, "jasowang@redhat.com"
	<jasowang@redhat.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "mst@redhat.com" <mst@redhat.com>,
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
	"horms@kernel.org" <horms@kernel.org>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "kuniyu@google.com" <kuniyu@google.com>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "dave.taht@gmail.com" <dave.taht@gmail.com>,
	"jhs@mojatatu.com" <jhs@mojatatu.com>, "stephen@networkplumber.org"
	<stephen@networkplumber.org>, "xiyou.wangcong@gmail.com"
	<xiyou.wangcong@gmail.com>, "jiri@resnulli.us" <jiri@resnulli.us>,
	"davem@davemloft.net" <davem@davemloft.net>, "andrew+netdev@lunn.ch"
	<andrew+netdev@lunn.ch>, "donald.hunter@gmail.com" <donald.hunter@gmail.com>,
	"ast@fiberby.net" <ast@fiberby.net>, "liuhangbin@gmail.com"
	<liuhangbin@gmail.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"ij@kernel.org" <ij@kernel.org>, "ncardwell@google.com"
	<ncardwell@google.com>, "Koen De Schepper (Nokia)"
	<koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
	<g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
	<ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
	<mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
	<Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>
Subject: Re: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
To: Jakub Kicinski <kuba@kernel.org>, "Chia-Yu Chang (Nokia)"
	<chia-yu.chang@nokia-bell-labs.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
 <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
 <PAXPR07MB79842CC27C2F5CF9BD40E007A3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <20260812155927.57ee295b@kernel.org>
From: Jijie Shao <shaojijie@huawei.com>
In-Reply-To: <20260812155927.57ee295b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo500018.china.huawei.com (7.202.195.199)


on 2026/8/13 6:59, Jakub Kicinski wrote:
> On Wed, 12 Aug 2026 10:35:25 +0000 Chia-Yu Chang (Nokia) wrote:
>>> Tested on hns3 HW (2x 100G, direct cable, openEuler 24.03, kernel 7.2.0-rc6).
>>>
>>> tcpdump confirms HW GRO zeroes IP ToS: aggregated (>MTU) packets carry tos 0x0, while non-aggregated packets keep their ToS/ECN marks — so the zeroing is done by HW GRO, not the sender. Before patch, CWR packets had SKB_GSO_TCP_ECN set (0x5 = SKB_GSO_TCPV4 | SKB_GSO_TCP_ECN). After patch, all GRO events gso_type=0x1 (SKB_GSO_TCPV4 only), no 0x5 observed.
>>>
>>> Tested-by: Jijie Shao <shaojijie@huawei.com>
>> Thanks Jijie for confirmation, I will submit to net in the next round.
> Hold on.. Sounds like hns3 zeros ToS out (?!)
>
> This would be invalid and illegal for HW-GRO. If hns3 nukes crucial IP
> header fields it should probably be advertising LRO not HW-GRO in the
> first place.

Your assessment is correct — HW GRO on hns3 does NOT zero IP ToS.

My earlier Tested-by claiming "HW GRO zeroes IP ToS" was wrong. The
tos=0x0 I observed was caused by a test methodology error: I used
iperf3 with --tos but did not set net.ipv4.tcp_ecn=1, so the sender's
kernel TCP stack cleared the ECN bits before the packets hit the wire.
I mistakenly attributed this TX-side clearing to HW GRO.

I have retested with tesgine (direct packet construction, bypassing
the kernel TCP stack) and confirmed:
   - HW GRO preserves IP ToS — each aggregate group retains the head
     packet's ToS value (verified with 0x00/0x02/0x03/0x10/0xB8)
   - HW GRO segments flows by ToS boundaries — any ToS change (DSCP or
     ECN bits) terminates the current aggregate group
   - ECN signals are intact — CE packets (tos=0x03) are delivered
     independently with the CE mark preserved
     
hns3 HW GRO is behaving correctly. Sorry for the confusion caused by
my earlier report.

Full test details in my correction reply to the patch 2/2 thread:
https://lore.kernel.org/all/dd817755-eb4d-4ac2-b282-ac06f847270d@huawei.com/

Regards,
Jijie Shao


