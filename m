Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795643711;
	b=lh9KAmQQQE9b7TYkKUGDFK/37UOz3DkufBrHZHD0mt7U9aCiP6HeP/jWOmRQyPZrUkXJ
	 4QQTn6Mr9Hhw7aNpoLFGZNlcuYgXSWBnND3RNTsEvURz4jo3lHvlQrRCzhBx9Gzo5lQIh
	 tjRxbPfXlIHmtp9+xO5AqAEWR1YFkfAlOYqgdZljQhWzYUHvortJsicHhhgpn5CULnNPv
	 KcR9PYLcCGKyOchTNHk1up7SMj+mTAD8D8NFBnEfg3akuQcLrP78zxmE0y44dMV5+8tKx
	 TsNuwMIMm5pkMh6yhh9nCpG075vben0+n3PSm8/arCj4yL3kgd0i9azh5AisGk9423g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795643711;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-NV-OnPremToCloud:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=QTpSoLnio5RhblKNnsd3oq75w3jB9HKCfel0jbGbbUo=;
	b=ttq5DDNc7Wk4aSgO9UBaO3ZfL6aqA5rLQ9je6mcbyTp7abV1BowfEav8KMMib3lzlpSH
	 zDtYOI1eHMQgvjw/YhnLsMPJ9cISjwAYX61GrQC2q71qWdiZFTwFSd7NLKTO9zHOx+uXj
	 +wCB6d9FjNQVUrky58awbTWNrH6NhhSUZxji2HCW8b6jPGJi7GvByJJH6q+wUC+ItIBSH
	 R9opU3fv9W5qTdt+R87FYUCRFTEyzrPzH7K9PyOfb+i/U14+daP8J5vAz0/zjKjU/3BZC
	 pfHEApu/IV8Z1zTMi5VwxsuLxggITzy4pBsB5HpXWpWTiMZp8uqjsygUOzXrSZ0Z8Pw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uskS6VU5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.50
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011050.outbound.protection.outlook.com [52.101.57.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF4D606A31E;
	Wed, 25 Nov 2026 21:55:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CDF4D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=uskS6VU5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OXf07mhUOmjrqKg9eENjRda8Q7u3bxoyFLETu3BKIXG26m2feHBu2QjG6eLL/h7uguPv9MkTYqR1FGSZZLDlC6AvRYAuZTmQsh7Njua6wyHiYXlnwcOm75fHHr/xUM0h8CQeqBF1Cfc8IoIzT/ap/rfJJ/ka/oTJaXQwbElHYiIbJM1NBcH1jYuVPvZsyVJev4lj6zUcAutaen6du8WVdAjNU3V2hbjZPOOEexj8oKVvjKPT58BjaXK7l2mpxmUMfL+8DorD7J0Po2Cle74KA7rGLtG69EWj7cQqtRD6mZGxzea/pTY5XVL7Q0/DSoZfgVjRyPEXxspRFV128Z7sIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QTpSoLnio5RhblKNnsd3oq75w3jB9HKCfel0jbGbbUo=;
 b=KI/FL6dBlGiv6xpSrgwCefJO7E2Tsxy88sBffCdSkG2jUkTCvID7uj4jD5gtRLqYYZN+Aa50MpkFihPVfLqaxQKCXuI8EXeJ3+pwiZX+oTyJ7lQA4A4p6zXpzr7hfDCF5YeaS/rg6F7LLhr7N7lQyJwCi9aiFK/3ewOweIpD2CSAsYKaQqpzeJNDhHoDfavCVbQ1iRDzEkCu2S/K8kMe4vrxijxHLXX2tqpEkq0Ul1bU2uq8yQmu1wqBKm3wUvD4iwm7g8Rk+P2DQZ+WLZZhu3mKJsmcoNLjkIkMbTDYXSnHKRqnCoPuD6+xpRxgWeHWmWN1q4yXOi1wAp82ZsU+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=mandelbit.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QTpSoLnio5RhblKNnsd3oq75w3jB9HKCfel0jbGbbUo=;
 b=uskS6VU5wCj0hOHXjqi9hHD3ua3kmdZSlnH57gQzr+IL8tLtcNcD5reesjcul76cnHOHcnAC3asJg9vBdE+BwvUScyhyiRP7+Z2RPKpwJxh2lKdjgkeHkoP9/9tqBA9ruWJTQiRIs4TURbnZYidyBW6b2+COamirD0a4tzcuXi1JUfKKNb/+9hJKklkeIXrOpcbMF8iXYJFewahE5uX2FTDnsIgf8j9iKaviSmyKLUoxC6VdT9KsY7/RDxubK2GKsxPSe1v4+AIqM9PK/d/OcmyiBGIVagJwneeck/+P9rcFMB8szTvDjISR0hPNqYGhAHZqu8nEWvfCHjZFVSbsZA==
Received: from CH0PR03CA0212.namprd03.prod.outlook.com (2603:10b6:610:e7::7)
 by SA1PR12MB9490.namprd12.prod.outlook.com (2603:10b6:806:45b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Wed, 25 Nov
 2026 21:55:05 +0000
Received: from CH3PEPF0002457C.namprd04.prod.outlook.com
 (2603:10b6:610:e7:cafe::41) by CH0PR03CA0212.outlook.office365.com
 (2603:10b6:610:e7::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Wed, 25
 Nov 2026 21:55:01 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH3PEPF0002457C.mail.protection.outlook.com (10.167.252.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Wed, 25 Nov 2026 21:55:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:54:44 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 13:54:43 -0800
Received: from f43.com (10.127.8.9) by mail.nvidia.com (10.129.68.9) with
 Microsoft SMTP Server id 15.2.2562.57 via Frontend Transport; Wed, 25 Nov
 2026 13:54:38 -0800
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Antonio Quartulli <antonio@mandelbit.com>
CC: <netdev@vger.kernel.org>, <saeedm@nvidia.com>, <tariqt@nvidia.com>,
	<mbloch@nvidia.com>, <leon@kernel.org>, <cratiu@nvidia.com>,
	<andrew+netdev@lunn.ch>, <davem@davemloft.net>, <edumazet@kernel.org>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <ast@kernel.org>,
	<daniel@iogearbox.net>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
	<sdf@fomichev.me>, <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net/mlx5e: Prefetch the packet a few strides ahead in the linear MPWQE path
Date: Wed, 25 Nov 2026 23:52:33 +0200
Message-ID: <20261125215233.3422038-1-dtatulea@nvidia.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <674eb8ef-c93f-4926-a760-62df154ed3eb@mandelbit.com>
References: <20261104195241.1883539-1-antonio@mandelbit.com> <a31e1e60-7e31-4a14-a087-428d1e3627f2@nvidia.com> <674eb8ef-c93f-4926-a760-62df154ed3eb@mandelbit.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0002457C:EE_|SA1PR12MB9490:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ea7a1b8-5337-468e-60c5-08df4b3ec11a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700016|23010399003|261026121527099003|10067099003|22082099003|18002099003|261026140227099003|261028144727099003|261021121427099003|261021135927099003|261102123227099003|261022105027099003|56012099006|4143699003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	7jJIvD8S7pBmoajPsGbx9QG7Yqx4HxJtQVRdt0sMuT3f7bABvum+PiXG2kD86768kjLhxCpsqNlMxd6kaMYxsTQpPV2aj0I6zO4WdTkmNUTXeIdc079durdjjso/H9T7DuSMOVI21IjxEVtcIxbGhkwD+WXuxUKh0urIXQ6Bz3vl1Wpxe3Uzx+W4CJOoSI2bwb0EWAurHO4tyhgDYDPymHCncxXG5tiVXN9AIuHyd2yT4D0V7TH8C4ySRTlJX997uj0gJA3qExT5K/cOC9a7SOfowEnx+uTTNfyCjIx+ZflL8qA7nx9yUM88ai3CumpOcx9FXZOtiRQRDHi4qxHrUtRVfMEJxYFvm+TjKAl6u/xk9udi3+5JcGtS/4zspDe+7TsP4B6eF4zfElI16TXAuccOl2b3IH7+Gia632HhBf5OuTnTcpXludgIp6kgA+JgWKnBptI2JTCFU5ya48UphQ+bmNurvSEbIghwuMXjOjkdkwSfZ1S39smVgiAf3Lgx76X1dI6thksORtAafRsoRUHpySIFAUtsEBsflaYmLXNikUqkB2rkQqzyYylk8Mn3V8702VVKgNwP/catdM6sHRhLRAWqQPirNh1TpjsAtxt9LhMe+dIPRBscd7kpw8yBrstmGAJ0VZKMaqh/I3cZNjiGPIvQIoQ09FeUGapyFpHZe1dK8qSzNnscSggmZylUH8N8n/zj9IzApOgpc+PI7A==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700016)(23010399003)(261026121527099003)(10067099003)(22082099003)(18002099003)(261026140227099003)(261028144727099003)(261021121427099003)(261021135927099003)(261102123227099003)(261022105027099003)(56012099006)(4143699003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ALCXdlKHIpf6kNGWk3n8UsLyQ7KIQ1SurZIJptmLhZhdy5qOcox96yPv23WyHLov0dWnEmsaARv1OadQ9sgPaj6DV4vb7jTXgbi4IwQPJkVh3NhDNCTXVIH6mCXwhcdkJYZndP0qBVi98Bp1Q+6ybPf3p5zohO5wLrjDTTBiTyC4polDx6u32nYx0fgjpp3mjybe1TyRdr4DhjHRpPmXvhnIlhstRtPuLpv5OoO7vtMLZiREwbux5g4oNE3VTjFGyUiTYBewI/uiUrQXFBY80XuVx+9qqgZmlI5U3sbb9HqYBpT6P2ZhGclMG8IPrX+nbjR9/ntwWg4RKTUHBnwScOGDUlMQjWgSOiwBJpj2mOsU2lc9MAT3fyuRXTDMTAmAePYR5CMJImrgSS321odpnk3FAAIjoJsarq+bDsIzRsUxlK4C8kgyx+1XuwFtEDo6
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 21:55:00.8518
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ea7a1b8-5337-468e-60c5-08df4b3ec11a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0002457C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9490

Hi Antonio,

On Tue, Nov 10, 2026 at 11:40:49 +0100, Antonio Quartulli wrote:
> Hi Dragos,
>
> On 06/11/2026 11:55, Dragos Tatulea wrote:
>> Thanks for your patch! These look indeed like enticing numbers. I'd
>> like to take some time to try this at scale and on other NICs (CX8)
>> and CPUs (Grace) and also check latency.
>
> Thanks! In case it helps, I measured latency on my side in the meantime
> (I don't have access to the monster Grace/CX8 equipment, but it's still
> something :-)).
>
First of all, thanks for your patience. I was on vacation, had to
catch up with stuff and finally it took some time to get to a
GB system.

> Request/response over the bare ports (one transaction in flight, like
> netperf UDP_RR/TCP_RR), same system as in the commit message: one RX
> queue per port with its IRQ on a dedicated CPU, MTU 1500, default
> coalescing (adaptive RX, rx-usecs 8, rx-frames 128), 10s per test,
> prefetch off / v2 / v2 + next-WQE follow-up (see below) interleaved,
> mean of 3 rounds:
>
>                       p50 (us)              p90 (us)
>                   off    v2    +next    off    v2    +next
>    UDP, 64 B     24.60  24.61  24.60   25.37  25.37  25.39
>    UDP, 1400 B   25.08  25.08  25.10   25.94  25.96  25.92
>    TCP, 64 B     24.65  24.64  24.66   25.48  25.46  25.85 (*)
>
>    (*) one round at 26.59, the other two at 25.47 and 25.50
>
> p99 and p99.9 (37-45 us and 67-100 us) varied more between rounds than
> between the variants, and nothing was lost. So no latency cost that I
> could see at low rate.
>
Thanks for checking the latency. I saw similar results. So I think
we are good on that front.

Here goes the rest:

The results are baseline (recent net-next) vs your v2 on AMD and a Grace
Blackwell system. NIC is CX8. Results are medians of multiple runs.

Single queue; IRQ, NAPI and the application all on one core, which
is 100% busy in every test.

AMD EPYC 9825 (Zen 5):
                          throughput           cycles/packet
  UDP 64B flood, Mpps    1.35 ->  1.44   +7%   1655 -> 1551   -6%
  UDP 512B flood, Mpps   1.32 ->  1.43   +8%   1683 -> 1562   -7%
  TCP 1 stream, Gb/s     23.9 ->  28.2  +18%   1125 ->  954  -15%
  XDP_DROP read, Mpps    10.2 ->  18.4  +81%    219 ->  121  -45%
  XDP_DROP no-touch,     23.3 ->  21.9   -6%     96 ->  102   +6%
  XDP_TX, Mpps            5.5 ->  11.4 +106%    402 ->  196  -51%

Grace Blackwell (ARM Neoverse V2, 64K page):
                          throughput           cycles/packet
  UDP 64B flood, Mpps    2.35 ->  2.58  +10%   1341 -> 1226   -9%
  UDP 512B flood, Mpps   2.47 ->  2.56   +4%   1275 -> 1230   -4%
  TCP 1 stream, Gb/s     34.0 ->  39.2  +16%   1120 ->  970  -13%
  XDP_DROP read, Mpps    12.6 ->  19.6  +56%    255 ->  161  -37%
  XDP_DROP no-touch,     36.0 ->  32.4  -10%     88 ->   97  +11%
  XDP_TX, Mpps           11.0 ->  12.5  +14%    287 ->  253  -12%

Results on Grace are a a bit noisier. But we can still get
enough signal from them.

So most results look good just as in your test. Except plain
XDP_DROP which has a regression. Nothing to be surprised about
here.

Multi-queue TCP, one iperf3 stream per queue, again IRQ and iperf3
on the same core:

One TCP stream per queue over multiple queues (same pinning):

  queues   AMD Gb/s                Grace Gb/s
     1      24.0 ->  28.4  +18%     33.9 ->  39.2  +16%
     2      47.0 ->  56.3  +20%     67.4 ->  78.4  +16%
     4      92.5 -> 110.5  +19%    134.9 -> 157.4  +17%
     8     172.5 -> 206.5  +20%    263.9 -> 308.2  +17%
    12     240.3 -> 265.5  +10%    382.8 -> 402.7   +5%
    24     370.7 -> 371.7   +0%    413.1 -> 411.7   -0%

The AMD system has 12 CPUs per L3 domain with L3 cache of 32MB. The
Grace ARM has a L3 cache of 112 MB for the whole 72 CPU socket.

Overall I think these results are quite good. I was expecting to
see some issues at scale but nothing really stands out to be
honest.

I wondered how much each prefetch bings and gathered some data
about that as well on the AMD system:

                          v2    without   without   without
                                page      headers   shinfo
  UDP 64B flood          +7%     +7%       +3%       +7%
  UDP 512B flood         +8%     +8%        0%       +8%
  TCP 1 stream          +18%    +17%        0%      +18%
  XDP_DROP read         +81%    +81%       -2%      +82%
  XDP_DROP no-touch      -6%     -6%       -4%       -5%
  XDP_TX               +106%   +106%       -1%      +108%

It does look like the big bulk of the advantage comes from
the header fetch.

> I'm also testing a small follow-up: v2 doesn't prefetch when the stride
> 4 ahead is in the next WQE, so the first strides of every WQE are never
> prefetched. Following the WQ list to the next WQE (only when
> cur_sz >= 2, so it is posted and its pages are allocated) removes 26-32%
> of the remaining DRAM demand fills on the RX CPU and adds 1.8-3.3%
> throughput, measured with TCP inside an ovpn UDP tunnel (where the RX
> CPU is the bottleneck); its latency is the "+next" column above.
>
> I had planned to send it as a follow-up patch, but I can also fold it in
> a v3, whatever you prefer once you have your results.
>
Do you have some results for this?

Thanks,
Dragos
