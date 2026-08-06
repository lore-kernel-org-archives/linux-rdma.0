Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D547A3F825A;
	Thu,  6 Aug 2026 11:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786016835; cv=none; b=ioPxrIoY6jlSi7ugyjobBJssbGPLQex2stj+qRqQ5Ry5VTvZ7dsjVyj5byqxrTMHuHI5QPqVcL57FW6YJs3uyRWwhfQTStOVg2+e5odHjK7TmsyNmCpY8NWd/NIyyz2wLVRjnJKpUI3vxELh+vSXnKHwZ+in+4ksQodXL7W3gNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786016835; c=relaxed/simple;
	bh=fdc5I/dA1nqBQdw+Khjbswi+ogkkUJq35gfyiNviWk0=;
	h=Message-ID:Date:MIME-Version:CC:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eXuHAvMJ/67g6G8QJ/9GHoYZulRpAhIZwJhNfrwESS4YR+w9GTquUgRxDPIFmAiBpTvlVH5SIse/7Mk/t/8JfDouOlzo7Lk80IiKpihEqIz1t2BSTvOftqMstw22AgO7kENe/ZRLWGS+aC7Dmg/JKy0zAhh4VNGQ2dHPNKYKJsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=lljNPPOj; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="lljNPPOj"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fdc5I/dA1nqBQdw+Khjbswi+ogkkUJq35gfyiNviWk0=;
	b=lljNPPOjwihvLNXNkomfvwIJ2aT3JrR9zX4iO8JmLfCfs0AeVhfIggM5EeYG8gkCXpB95R1el
	OsDybiQqwDZkG2zcdM8/ashc+PW1MY24PXpCpj1HY7ceD0yXtZJR/vB22qDeVkzbBGWCCiDwvon
	Kloe7IEbytFWhvXDfL6Ns1A=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hG4yL5yJSzLlTg;
	Thu,  6 Aug 2026 19:37:30 +0800 (CST)
Received: from kwepemo500018.china.huawei.com (unknown [7.202.195.199])
	by mail.maildlp.com (Postfix) with ESMTPS id D2D2A4055B;
	Thu,  6 Aug 2026 19:47:02 +0800 (CST)
Received: from [10.67.120.192] (10.67.120.192) by
 kwepemo500018.china.huawei.com (7.202.195.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 19:47:01 +0800
Message-ID: <169d0d62-2296-476f-95f9-5916d777090e@huawei.com>
Date: Thu, 6 Aug 2026 19:47:00 +0800
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
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
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
>
> Fixes: d474d88f88261 ("net: hns3: add hns3_gro_complete for HW GRO process")

One note:
since this patch fixes a bug (incorrect SKB_GSO_TCP_ECN flag set in hns3_gro_complete),
it should target net instead of net-next.

I'm running HW tests on hns3 to verify the fix. Will share results
based on what I observe.

Thanks,
Jijie Shao






