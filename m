Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E332448D15;
	Thu, 30 Jul 2026 17:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785434259; cv=fail; b=P6uEBM52rKk8EMN+tx7IVj38gIOOKJyfBnNrjqerbTVQhw4yazvUy/I1RkyX5Jt+zHVXsNc281gCs4t09PebdcqOgI7AZKdsQRKphyxzeFjzlpo3BtjnZMMpHDthyHjNtCBxVVAJ3F0kpLEQ7KSqMf6SdYEywYIr7NTd/s+YPpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785434259; c=relaxed/simple;
	bh=dHVSeBQ25yHQBP2am21PyuDeEwDEtsWrpJam1sd72gE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tYZxbTdcTFSMx9DjI04pZ7pcKK3pfRF1p15W8FfGcYLIak+6YEj8ECGfmlXzmSckXDbi4s9WlwoFar3I9/NOGTn1p4XtlsQYBGY3hhRgtUP/kY5rqefEXi4pEG/qDUGKw8aAkCFTTwUFjL5nQQIopgsjq1H8SkgweffIEmb+Et0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bNxjbpHy; arc=fail smtp.client-ip=52.101.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bNxjbpHy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VI+gWSgnbbalHbbDVJTVH8EL7PQ6yFyQv5u6CmU4vZRvEnTPkWyCRRBT3MwyF3ncSqLcflT86W1n0+h3F4Bqk6ulInE4WBlEXx+W3d9Gia75AQ5c0r8V19VeMHolstEWhLodzCn3oTz4/dVlhflPhu/qMTiblVkKAu1GXK2sAMDlRDJg1/tU0QcCVSul8GQAVEbEO7tz3WtpBIPWaH2bU7fx0dDrlxb3IhjlAyXixbBmIEdCJ+1XVR1Nz3aQi4MHkCuNyD/4yYNNaWyQRDeF5JMiOxYQQprPaWgcTPbIJVe8flOjTD1oN7fytVIW3x9cvRf8sPuAaVjUdcrH4oq9nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lTKoejLeFZAg1ymcbv2pybBxlYWU4nKoavgl35y7mS8=;
 b=VR1r8pmDzqhfmwxVgLm8r2Uo8PHfV/l89r4yqLbUcOlDusSwEqUzaZ/Tw+p54ZRl4KlaZG8KNbbYNpi1vIqY3aKuqjHUmQPoBNPyJSsB64hIwimB5KSrvajbphGQrZFiwKP4R5wwEIWT6PTDNTjWtcLAAYOPdfW6eQRCdnyXfJGBc14TNX9Bp5Xj6aF7779RQkwsJiqLosEEl3G7HHENtRWJ2kjq75hrtvqk4Munrq59wDwYjDV2BG2SDTRPq6LMIDCGzYJPED9BltEJDjyLLUlr94JZvjuZEsvve/3k2NxWCpcnirxBWcboz3yC/Kzt4JB/d1doR7xDfVCd8hZkMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lTKoejLeFZAg1ymcbv2pybBxlYWU4nKoavgl35y7mS8=;
 b=bNxjbpHypY4XgGZUItGcGfximcJTt8qIKixLOtUFpoHuqJZvWjf1I4bYizwh101un3721vbGkacIfHFGGOyyZfm0igAapeSDMEskC6pWEya2I5/83czCRFuZvB9ruAPT3QBH21OjKIq2fapNMfrxZx6ywgALyYo8nVEbRnY5ovC+3Z/ionZ6oZqUSodKiIg9NZ5sBp7YjGNetL1DzCQ4f+B76+CnMbIjNu4QndEaHye9SF81sO5/BS8xWWYoQKz6zM+gFT8CKD+YT8l2crAANPYQ6QLfN9Iuq2icn5qPYVh5XOERA8H91FqdxpG3CTLAw9KzO28+B2s562uhT61TxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by DS2PR12MB9797.namprd12.prod.outlook.com (2603:10b6:8:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 17:57:31 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0270.012; Thu, 30 Jul 2026
 17:57:31 +0000
Message-ID: <13fde98b-d3cc-469b-b970-840469427a0d@nvidia.com>
Date: Thu, 30 Jul 2026 19:57:25 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5e: SHAMPO, Fix IP length overflow on large HW
 GRO sessions
To: Tianyu Zuo <cosmosocket@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Khalid Manaa <khalidm@nvidia.com>, Ben Ben-Ishay <benishay@nvidia.com>
Cc: horms@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260729204745.166584-1-cosmosocket@gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260729204745.166584-1-cosmosocket@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0192.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::10) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|DS2PR12MB9797:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e79989a-9689-435d-54a1-08deee6406a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|7416014|376014|1800799024|921020|6133799003|22082099003|18002099003|56012099006|10067099003|5023799004|11063799006;
X-Microsoft-Antispam-Message-Info:
	+TFqlDOrocAytyc6VTn76O7+xgO7rcTgzDWdnSYEhajUdZbXx4Ttar3tFo7dXpQa9aI4RTTurQdDx/1ffyXndOZjgxcZmKUcYRQcjTfYQ6hAlR+BzV5xzm1EYDnBbBJ7Q8w3Sl8cusCf6gU70RVb01hxdyqgxNmLFIcgw4gQH0d4uHEtJI8JmyuqOMV7pIvg04caROUZ/+FfiYrYYfHUJRh9zYeOCAJirPGBRe6y71kRjY6YUzJFEclkysGxY6VI3lbMCoBK65FAQnf+n1T553weHDgz/z8v9tA+9xHWRylBiOkpqwGjmA1yhk88CUV5XV8rief54Ik38kD7BpvH9OgIcwBFcXGjmf17w4M9SiOxk6sTM26u5cSawFyCV1ezFy3Vbx0/qXPwF4pEIfd3gIMpB00VK3IGEgHsLMeLWf6+RvcCJf5iqpld3gLKnUIUdWU19QuEFqsaZmtHk4zGCvS2vDOh3PEzhGA9zIwfg9t/ptC8uatuDpknEN07EioAX3brtFolN7+NvDgvzD9zWPg5nP1sjJvDCTQiU8Afb5p/ShflBeKl+B8OWMJiIoDseTyF6yXPCGhpl7JFT5P/DbaKRcMrVSjDzPgUenz9P5BKykSJYAqy6ons0adOi7T6RhptkF4fEsGU/wQpGNFpunogXvuq1sVG9BAO2E2TUo5+tVaZnXNcek8Uw84pUT2MjFPqb84S6PiGZVOR+yRguw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(7416014)(376014)(1800799024)(921020)(6133799003)(22082099003)(18002099003)(56012099006)(10067099003)(5023799004)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MnRzUWVSVFNidHhhd2p1cjV6a0tTVnk4R2FVVXEySlVwdS9DUE1tVytQdTE0?=
 =?utf-8?B?YUx0SWZRdS9hdktPQlBJWDZxaUhaWm1UTW43allHMXVxdFpQUzVWampHY2Fv?=
 =?utf-8?B?MUlORm43VDRHdEpxOHczOTZkaXdLU1hyR0NxVnRzYUEyUTFkUU45VXBwYVZz?=
 =?utf-8?B?RU5kUEFqeXRxSGU2YWNSVkZJNUZIek5pQ1pwUW5ENEhjN1NoZTBPc2FOcUxY?=
 =?utf-8?B?aFZSQ0ZnSWFmSUlIZDdBSzY5Y0duc0l6Q3VZckw3bHFKZitPNDYvUGpYWXpm?=
 =?utf-8?B?NlIvdGd3TjJES3o2NWcwcFp6YWFneXhZSDJPTnlsbk5rNDhaVFo5V09PYjJx?=
 =?utf-8?B?eXArcjNwamhSc3l6MldwcjZoSHBkUnhiZ21LTE92aUMxSWJsYjI5bWU4dGZQ?=
 =?utf-8?B?Z2JZbjQ4QVIzS1pleklEUFJpYk80cEZidmZndks2eG9yU3ZtSjlIUTV0Ukp1?=
 =?utf-8?B?S2lPUlYzMEU4cUlYMmFyOURpSmZQenh5U2pmWGJSK3hUS21QQ1RaS3VPQXN5?=
 =?utf-8?B?d2JNdit6aisrd1Byb0Mya1ZJeVU4MDJtS01QL21UWDBkOTBUbXV0ODZyRGpt?=
 =?utf-8?B?Kzg1N1BRM2JKNmNLeWI4MnBqTUhRS3UvWVMva1cwK2NRelkyRTlvOFUxRHlI?=
 =?utf-8?B?a0NnUjlMY3E5UUlXVnZpTk01NTAvdGZmczRvbm1YZ1FjMjFsbEpOTXVHMjVW?=
 =?utf-8?B?Q2pXS1Vmajd0QS9CT1Rwb1NEaTAzcG9xQll2aHFaaE42b0pMa0FEYnlRU0JD?=
 =?utf-8?B?K040TXVWN0JYWkc2dmdHYWhreHVobG9xb2taQnNzQ2RkSHQxbFZuVllDNWQ1?=
 =?utf-8?B?WGlaMHBTbEtXUWhtNkd2RFRoTFY2cjBSeEZLU2FmVWpXR1ZkVnVKUmNmRlJQ?=
 =?utf-8?B?ZmJQVE4yaWUzUS9YcXhHRzhXaXgzd3U3RGRhVHk5Wms5eDM4UlgvT2d5d3NK?=
 =?utf-8?B?aGVSWExtZUQ3dHRvQ3dQKzFWcnNzRlZWeTI3c0t2aVdIWWdmNDVTTUhkVVpT?=
 =?utf-8?B?V1RwcnNQVWluMVVQWVloRnJBLytxNU9QcHZ1eFQ0YVVicWpkWi91d3dDMFRF?=
 =?utf-8?B?MHRoNFpuYzFIZE0yMzY3ZVVCS2c3Ynh3V09oSGsrclFacHQ4OExkL1lySW9z?=
 =?utf-8?B?aXA3OUZQbGFLald1eVpZSkdCNlgxZEVCT0NlNzRIQVhmS1hFb1ZzNG1sbzFn?=
 =?utf-8?B?ZE9USHp5aWw5a0EwVmI0cjE1WU03dVIzUHhhZUFkUVJvcm9hVTdVbmdNL2FG?=
 =?utf-8?B?TjNSaTJwdzdjU2k2WDIyLzIwQjREQnk1bEVuZnc3OXRwbnVoVDVsMXRVR3A1?=
 =?utf-8?B?UHdJZkZrb2ZHN2dNeG5ud09sTWoyV005eU5GYlJLMWdvSVBaUjFzQW85akJW?=
 =?utf-8?B?Um1aLzcrbzVlT1dCd2UzbnNFQ3orWHROUnhjdjlneFF0azg1ZHdVZ3Q0dHRO?=
 =?utf-8?B?SXBJQitvYTQ2N2UrQU85dGhkODVEcllNMW9JQlI1cENvUzQ0anlaeW9HSzk2?=
 =?utf-8?B?bW5WQjZNMlBydExnWU52YWcyODZXSUpXR3FYZjNlNE9CUWlFSGdQM2o4V1do?=
 =?utf-8?B?TVlxNmVHMHdtYW9yWXdDNksrQTJpQ3djWWQycXZyY0VDWE5xUzZUVWE0U3FC?=
 =?utf-8?B?bUNWb3lpSGdDSlNiWUVCQzhNcWhOcTBvS1NTZER1NHV0UEVUS1hYbzhoRnJx?=
 =?utf-8?B?TzEzRE8vR2N1ZHVaUytEc2YxZUhDeUVxZ1I3TGVwSStiWWc1U2RMZkxpNkh6?=
 =?utf-8?B?RHJ2c0JvTENvb3pSL3BTQStwZndtTDNOWXB2NmFiUzhReFVDVXB2N1BwaEJr?=
 =?utf-8?B?dnA1VzRBKzM4ZWFmQ3ZWVnBXckg2NERNbUd4UmtGdGUxbVY2dXg1bjFqeHhm?=
 =?utf-8?B?d2xZa08rN1Jra1Fxb0N1RVFyalV1Z0U2NlJySi8wVUpjZXF3RU9Jd09kQ0Q2?=
 =?utf-8?B?R0tYOWVpV2ZYdWg0bDVZUENDL25DM2VwZ1hBbURMMXlIREVtWnNMdjRKa1Fk?=
 =?utf-8?B?MVJKOHlJZVhnOXBhaEt6UHVRUjltZ1FXQ21walN5R0hUVkpGeGRXaGdKeVNZ?=
 =?utf-8?B?RnZRbWErS0NqbFNhM2NqbUFSNGQ2VU5UUnJCM0tYTkVFMGFjSmtmZUxVOU9H?=
 =?utf-8?B?Wk13c0VIZFZBeVZuVXpqYkRhUFl5S3JnNUFhdFFzWUpLaWhNRGIwYTNhbXAx?=
 =?utf-8?B?V1ltUU10ekhMMkExWExRYkZJOHhqVUhJcTdteUpWQkpZWWVPZE5SQUJ0OGJW?=
 =?utf-8?B?eGhoeitkd1NvdGdiZHpFbUJuSEsxK1hBRGJwdWZSbU1yNkNRbVRHL2RJY3VR?=
 =?utf-8?B?TFpWV1JidXhpTmtTbEFWWnZvbWlyMGMzQlBNWW5HS2RvWGF0cCtLQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e79989a-9689-435d-54a1-08deee6406a5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 17:57:31.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y78dxEx00Mja9y697JNZBUKbVhZFQbLN6Sjcg0Oe9bDln2UoRvhjKoFMi3i2vnQ/B9/p+XiW7yzIcADmi8gjfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9797

Hi Tianyu,

Thanks for your patch. It is a good find.

On 29.07.26 22:47, Tianyu Zuo wrote:
> mlx5e_hw_gro_skb_has_enough_space() bounds a HW GRO session by the
> payload held in the skb fragments only. The L3/L4 headers that
> header-data split placed in the linear area are not accounted for, and
> the limit is inclusive of GRO_LEGACY_MAX_SIZE.
> 
> On a 4K page system a session can therefore grow to 16 full page
> fragments (65536 bytes) plus the 40 bytes of IPv4/TCP headers in the
> linear part, giving skb->len = 65576.
> 
> mlx5e_shampo_update_hdr() writes the IP length itself:
> 
> 	__be16 newlen = htons(skb->len - nhoff);
> 	csum_replace2(&ipv4->check, ipv4->tot_len, newlen);
> 	ipv4->tot_len = newlen;
> 
Commit message is clear until here.

> With nhoff == 0 this stores tot_len = 40 and updates the header checksum
> to match, so the corruption is self-consistent. The GRO stack does not
> repair it: the header is written before napi_gro_receive(), and
> inet_gro_complete() only runs for skbs that the GRO engine holds on its
> gro_list. HW GRO sessions are typically flushed on TCP_FLAG_PSH, which
> makes tcp_gro_receive() set NAPI_GRO_CB(skb)->flush, so dev_gro_receive()
> hands the skb over via GRO_NORMAL and the gro_complete() callbacks are
> never invoked. The length check in inet_gro_receive() cannot catch it
> either, since tot_len and skb_gro_len() are compared modulo 64K.
> 
> ip_rcv_core() then trims the 64KB skb down to the wrapped tot_len,
> silently dropping the payload. The IPv6 path wraps identically in
> ipv6hdr->payload_len.
> 
> Triggering this requires the payload of the aggregated session to reach
> GRO_LEGACY_MAX_SIZE with every fragment fully populated, since
> page_size * nr_frags otherwise overestimates the data actually present
> and the session is flushed earlier. In practice this needs an MSS that
> is a multiple of the page size (for example 8192 on a 4K page host with
> jumbo frames) together with a page aligned start of the session.
> 
You can drop this bit.

> Account for skb_headlen() and make both checks strictly less than
> GRO_LEGACY_MAX_SIZE so that skb->len can never exceed 65535.
> 
This is useful.

> The check is strictly more conservative than before, so the implicit
> bound on the fragment count is preserved: page_size * nr_frags +
> data_bcnt <= 65535 gives nr_frags + data_bcnt / page_size <=
> 65536 / page_size - 1, and a single CQE adds at most
> data_bcnt / page_size + 1 fragments, for a total of at most
> 65536 / page_size (16 on 4K pages), well below MAX_SKB_FRAGS.
> 
You can drop this last paragraph. Or summarize it in the previous
one.

> Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
> Signed-off-by: Tianyu Zuo <cosmosocket@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 6fbc0441c4b8..2e9676305439 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -2222,9 +2222,10 @@ static bool mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb,
>  	int nr_frags = skb_shinfo(skb)->nr_frags;
>  
>  	if (page_size >= GRO_LEGACY_MAX_SIZE)
> -		return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
> +		return skb->len + data_bcnt < GRO_LEGACY_MAX_SIZE;
>  	else
> -		return page_size * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
> +		return skb_headlen(skb) + page_size * nr_frags + data_bcnt <
> +			GRO_LEGACY_MAX_SIZE;
>  }
>  
>  static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
> 
> base-commit: 51b093a7ba27476e1f639455f005e8d2e75390e4

The code looks good to me. Wait for Tariq's comments before re-spinning.

Thanks,
Dragos
