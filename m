Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70496382298;
	Tue, 11 Aug 2026 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786455139; cv=none; b=N2pRAgHqaxYgom6v4OlxtnSFGU1bSC6Jyu3qozJFGn/Ocmcj5kfgQJZB5aOpfBVqDsEYv1g4k2Q0xGXsftbrlKwr53029n7PzZn+UT+K2vxl612GvBP/7XBBQChBZY6XFvKk1nAEgxNCV8QaJLKgVFXoYf/Yns+In6/bIs2MTOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786455139; c=relaxed/simple;
	bh=7oUk7vcZMZh7Kmnjr0sRE4TUfpBeeMTt+zlm+6qAkq8=;
	h=Message-ID:Date:MIME-Version:CC:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lf3NUTjbLURSFcNqxw0eAan+jZwuhtCyuaOMLBoaHHvfUjkFIt9KmScO/B+9J7KpjoNzTke6SVuB/1+RKPFsQVmnTFtde4JufOIW3XmdOZqoQMCqbmT2BmN8UK/u/GeUuc1419bta4c0OyyZyQf8txs7Gy9JM4bUZUK8NMTq7c4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1eWBaKqw; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1eWBaKqw"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7oUk7vcZMZh7Kmnjr0sRE4TUfpBeeMTt+zlm+6qAkq8=;
	b=1eWBaKqwvWQTJuOPnnjp6koX97ircDeqhOomYz9PRZGrQn38a3eLyzDdexfoau1XDMSz5J6Fz
	pD7EntVYieru84JzuQ+bD0FXZZgNx9weiEXKuBMH4JiZ/jSSxBwoqAIShMwcwpky75vbO8ZWZVW
	HV6pLlt7Sm86/Cixlkdd+Z8=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hKC2T5jlGzcb0T;
	Tue, 11 Aug 2026 21:21:53 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id 73EB34057D;
	Tue, 11 Aug 2026 21:31:59 +0800 (CST)
Received: from [10.67.120.192] (10.67.120.192) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 11 Aug 2026 21:31:58 +0800
Message-ID: <61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
Date: Tue, 11 Aug 2026 21:31:57 +0800
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
From: Jijie Shao <shaojijie@huawei.com>
In-Reply-To: <20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo500018.china.huawei.com (7.202.195.199)


on 2026/8/5 5:35, chia-yu.chang@nokia-bell-labs.com wrote:
> From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
>
> Currently, the hns3 Rx path sets the SKB_GSO_TCP_ECN flag when a TCP
> segment with the CWR flag set is received. This is incorrect because
> the hns3 hardware GRO resets the IP ToS byte to 0 during packet
> aggregation. Consequently, no valid ECN signals are carreid, meaning
> that it cannot support RFC3168 ECN or Accurate ECN protocols. Setting
> SKB_GSO_TCP_ECN or SKB_GSO_TCP_ACCECN under these conditions misleads
> the upper network stack.
>
> Fix this by removing the incorrect SKB_GSO_TCP_ECN flag assignment
> in hns3_gro_complete().


Tested on hns3 HW (2x 100G, direct cable, openEuler 24.03, kernel 7.2.0-rc6).

tcpdump confirms HW GRO zeroes IP ToS: aggregated (>MTU) packets carry
tos 0x0, while non-aggregated packets keep their ToS/ECN marks — so the
zeroing is done by HW GRO, not the sender. Before patch, CWR packets had
SKB_GSO_TCP_ECN set (0x5 = SKB_GSO_TCPV4 | SKB_GSO_TCP_ECN). After patch,
all GRO events gso_type=0x1 (SKB_GSO_TCPV4 only), no 0x5 observed.

Tested-by: Jijie Shao <shaojijie@huawei.com>


