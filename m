Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793359154;
	b=Bm7FYU4Q8jzx3x3RAWB7Om+0hTHM65yfjqcxfyVcwdEE4ySZ+Ss0FMFQFLgqysec0NOV
	 RzXIOOPtiLhk+G5fVAVbqfr49oQAJFo6F4Wh7kFvmPseuYC7lCMXbnWsBEgXL2el2XkMC
	 1zS64p2ww0a/0F2+3b9cm7idJwpzxFuK/gxPcokpt74VNGfH9mOdjB7p09sZ+ienZ7uK1
	 NTN+hZ17F8BNq/EwaSM0MHYXlj54wpA6fHWUuB0sJAQjaKvQlbzOO6XXFw6OIWsvYqjLW
	 GuOIJciMeFQdOzBXqtrxzAnGACEngLWScQ1Rk+Z4EFbHFGWPhWAIMVjhQsWbA2qiSoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793359154;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=Sv1+cJmWxstnzxGwMGKtj8d6mLodGLuKFwlcDPvuBzw=;
	b=R/2dSnWnBdOdQdpKWJEJnalcj3RO8RB0LxjtJG3e3chdm7hjb7LXZCBn7zpxKdMGbwiY
	 S+1s8FsAMdjByI7qMlH/Qa3E2eOlCLTZEJCTSx7dFsqsTJxVI80gzfFvi/sEeHdWQUAUN
	 NdmMTTEDpcV64/zhvTq3G6lRSYu5YL6NgeGIE97LUcdpX/lk7HstT0Xf/PcI3GkFgVHbH
	 BxqSN0kFOaM8rkvE8LRIOWYOsxFkVIVu4o1uCzZ38WxeDlWLpCxAAd7ZU5OnZHZM+j0u/
	 wH+vt2FvkvM5SZeX9pW+QoH5MveCjZ8LwbkG7EHUeF3LVgJcAWDcVrl0C1JiblufFLg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TiAx7zld;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.61.20
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF228606A31C;
	Fri, 30 Oct 2026 11:19:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF228606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=TiAx7zld
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UaaVtbCj8JD3kQWbsTLn/o6d6cpLeOXy64tdHTuC3/RpR9uqseb99pQRqnrcPUa1LfqNwxK5jk1McqZR33HluIZ0JCoEzThmarEFPS3XpiqtdHebsG0xzLZ3WarQxrORj4suRDNCuzvK7U1yqD3rlqZaCU5FqFvHebSS5submdDm3hxFDJZnuA246K5+RsJaMKWsYrbwbwvD3UFeOBPhUboBXTzZGPn+0M5QWJVoS8a68hx4CDajQdqQp9jMn7Y995oU8+MqnnoubLCsbLHbvbMkaZCWPwQEv7Ci24jjoIhS2EYfewmk4l5nIMaDW84gPDeR31uRxZK+B21rmt3c/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sv1+cJmWxstnzxGwMGKtj8d6mLodGLuKFwlcDPvuBzw=;
 b=qr7oouUDSxQZrXnU+cAOJMkEOvkUw/kXj5E2/JiWASPDhqE3MIikAcnL2JJI9gdG14MkKnwrq1U18S+R2Nkhi+w/lDuvYv3pXjBN3VB6vc4yMPgq3TccoHipfOdxzQ6ucseZa75/R8ztqEzINRECb+KysmEtFJyofKFJpKaT9DQc+Ws2bllTTyGQR7AzR6H/Gcqlel4hEiZC/DtcjvLrddAk6Z+kkfJm5Sp/wPgCWgNGYVN9D6fG+gtB3Qj/Y7QdMGnswvfWgRfsaGanEcTiw/aq2CQ8t6aclzyV+YbTnutLlomYrPyPAKjrhaYsOsQiV7bDfp8p4KlqAaHKxz1REA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sv1+cJmWxstnzxGwMGKtj8d6mLodGLuKFwlcDPvuBzw=;
 b=TiAx7zldEJgBpAuRIEMYXziMOK9pnvDE1XMl6zvwnJ783+Qip8pcTo4oh06Gl4YazInS2KuxLOC8NZR0BwwMH9tb6Prrf/7BzbRCGYow5tr92vCArL+WSrPAuJXpT/NgZAbZCMqFc1wWMxbUTLLw8+JQr3sBuKp54nJaHSXI6y+J0LXnjtt+GzQLwVI8y0Nl4J5eYa2g+7/v99CPf7BbHIAanZsYc7vzSAARkfNfZxUFja8arKbJ2Viycosd0qwIXcrCdAJtUPeXrtzjCb6Wyn4X7W+rrRYr3C8FxiL0mU3jc9zywuszA82aBI3T6QUuvRVziavRwP+PoSaSA1FOIg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22) by DS2PR12MB320397.namprd12.prod.outlook.com
 (2603:10b6:8:70d::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 30 Oct
 2026 11:19:04 +0000
Received: from CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205]) by CHAPR12MB999248.namprd12.prod.outlook.com
 ([fe80::4972:8062:d74e:b205%6]) with mapi id 15.21.0569.009; Fri, 30 Oct 2026
 11:19:04 +0000
Message-ID: <ade46454-e575-43e4-85aa-eeb5ad79408a@nvidia.com>
Date: Fri, 30 Oct 2026 12:18:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: IPOIB, Fix QPN lookup race
To: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Cosmin Ratiu <cratiu@nvidia.com>, Carolina Jubran <cjubran@nvidia.com>,
 Alex Vesker <valex@mellanox.com>, Erez Shitrit <erezsh@mellanox.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20261030002241.8508-1-prathameshdeshpande7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:eb::12) To CHAPR12MB999248.namprd12.prod.outlook.com
 (2603:10b6:610:2ff::22)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHAPR12MB999248:EE_|DS2PR12MB320397:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e52e608-ef04-4ae0-0b2c-08df36779b26
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|261028144727099003|261021121427099003|261021123027099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|10067099003|11063799006|22082099003|18002099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	A2UEyfyIkmZ1l0Fu6wa7jC9d4uEI0SktDWGuffo0wXjDAsfiXBHGJwVjFDOjw35TjNwd3McH7cz2z25zwC2PcWT5U6Qz8r8Ik+2wMMdRCd9oMrHHc2VVGbAgOygLjH2rZMM8v3ggwORTPAgz0KEuCq7uPHWRgOogQ/pzj+IS64PLfOCFg3zjTUTTEsj2Kk3VfNNMUxFXyKFk4qyepFfSe3C1F29r3sQeiPv7yQrlOa4mAPsxR2MrcuKCg9USrfXqStT+jewhCKTTGRbTfk9NdKEiu/4mJ+Kv4+h+7aw26PjK7NyUZn9+ECpqIVhdzhohskGhstw36mHuEzK5PicLLOgjRV40mYTgZI8nOOjjzKPAtgvgZltxgDY4FMT81siG5fowrlv/4eDjyFFi4IJLcJnUfZYy/MD/jNQ1XYmMG7y4yI0xvD6lDSq6Scf5DHhTZ5bl2xIL4byGZs8MN7AvEeLdTD3Kv6WRzZPJkh7vGuy05g822dhCcKj15booUDf6g1tulYkRmQ2pt9mcDvxbzWLU2O1IPt/B/h5Th7DRw5f4W3EZL/WfSL9H6q4XqPcE582SoVeZAsSQMfcgRuoGvu40e3Yw/ahnfKGtVe5Z2PdM8ZGhdN6z2ICaBf8rmNfm1UNZ2F+Jahvvdh8aMQQ9HGXTD/nlIws0x6qk05exA2AyJ0dG1Rb3vZMs13sYRH5p7XegOCbT6vXCB8HcB1C3Ow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR12MB999248.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(261028144727099003)(261021121427099003)(261021123027099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(10067099003)(11063799006)(22082099003)(18002099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VmVwcGZ2Wkx2T0l4S0F2cnFZclR2YjVUdWFmT09Lai9Qc0dwY3lVS3BGZHZ1?=
 =?utf-8?B?aytxWXJqalcyTVV1bjE0bkJPWE5yUUZBUGpzQU5MdUFXV2Y2Ym53NGh5bEwr?=
 =?utf-8?B?RXpra0o4b3dnKzgrMmJLUjJnT1pvZDBIMVVvK3NlQUo0VlU3NzFxeEUzT3ZN?=
 =?utf-8?B?T205My93YmV3R3dxdDN6aW9FRXhjTEVQaWNORk1NTzBWR1E5S2VzcStDRXpM?=
 =?utf-8?B?aHhKaWNSaUxOdmpHMngwa0N3Rm50MmpQZnA2d01QTld3QlphZnNRWnh3dFBJ?=
 =?utf-8?B?YWFYdkF5YWRQbytkZjZ3YXRtMFVvTE1JRStWcm1IU0J1Y1o0RnBvV1lEemFK?=
 =?utf-8?B?RWc3ZFNFVERVb3QxQzhEOFZsUjFxQmE2Zis5UmFmeFZHbHRWZndwT1JDSXFn?=
 =?utf-8?B?YTFwWCsxdzFjK2U1bGRUL1lNUUhKb2VBaWhPQ3Uwa3NSc2lFTkZNUEJZdS9W?=
 =?utf-8?B?YUcvWFBMZkVJeVFqVXdxeWEyZHYxKzVuVlBDS0lkL09ic2VBcGFMSTdzaTNs?=
 =?utf-8?B?WFIwZUdyMys4UFBLWW5EMkJiYnBiZmZiRkg0RUd5NWZ0aDZpM3htRlAxK2N0?=
 =?utf-8?B?NWpOR09EYmdwSWxOQ2VvUG1sa3U0bWhhOHlGOHFPSU12ZjN6UVY3YzU4QnlO?=
 =?utf-8?B?UXJVUEcwdnNOTENHZk5HNFNRYVErNHhwbVdoN0twdjJZVW1Cb0pvVXpvWFFv?=
 =?utf-8?B?OWxhTFhXNUZWYXQ5ZFMwRzA4ajNQcmlvUmFNTGxCQXcweThRbGtTaTA1WlMr?=
 =?utf-8?B?K3JxVk5GUCtsYXZnQVVHeWppTGcvdWJDMUhybGU5MXM2WlhQMWl3K3BBcjNv?=
 =?utf-8?B?T3libW9SSXJaK0pVSUNod0tScEhIOWFFVloyTnplaGxJSEpsVk8zZTR1Ukxa?=
 =?utf-8?B?NnU2N3EwV1BUQlpoR3NjVmdnUWZDYkN1RmFSOWp6TnZ4Qy9rOXB0ZTQ5WCtZ?=
 =?utf-8?B?WXZHYXJLN09VV3hYcElkc29IRkdhamFORnd6eEJKNklSZmVUcTEyK0dLMnJ1?=
 =?utf-8?B?enljMVQ5NC9lNlJrZU9RS2NYL1BmV1hhYm5YWFVKOE15OXEvcjIxNGN2VHJt?=
 =?utf-8?B?cjRmN2NJQjk1V0xjTm5FeGVpS0RrVXFjRnozLyt4UFZVUmwyOTZ5VktzUHFL?=
 =?utf-8?B?TUZNWGQyRGRJN2dXYzBkOE5Zb1V3MUY3eE9mWnBXUFlqYzMyemZqTjhJYVdU?=
 =?utf-8?B?bEpheGFSNjgzTzA5QTdXOXBDQXdqY3pXWXdUT1lodFBveTZDVGo0UTNFeEQr?=
 =?utf-8?B?Vmw0bjdybmRNZ2kzS01VcFUwMGVUcEFPUnJ4eDA5dm9Va2lVeER2ZVdmSjZz?=
 =?utf-8?B?Q0NOTUhYWEorREY5eGVEc0lpY011MXBFKzd4cXZiV2xBTDFlcHlzL2NlWnhE?=
 =?utf-8?B?Si85ZnFoRkZJMzRMSCtrdHpsbXJjUVAzaFJHTGI1TFBmdlNwcitBb2dzcVpS?=
 =?utf-8?B?cVdhY1lBUEorRmFuZ0RIVHc5eFBsRDdtY2NBZFF0SC80d3piNFZTcjFWbmkw?=
 =?utf-8?B?bEFsb0tiamVQbXRaWkhNQXFZOGJQRFF5Skx3QStTMTR3UUdrbFg3TVM0N3Nh?=
 =?utf-8?B?YW5mM1FuMU5oMFh2aGFTT0lPMXRya0x0enp3VnJ6OUVDYWxSTjhKdGdTY1R4?=
 =?utf-8?B?aUNIdklrQ0JqKzdDZjc3ZEh3eXNNRFMxdUdFVDM4Q1N2ZXdraTMxMCtBTUJi?=
 =?utf-8?B?eTlDZVJrRC9nd3hmRmF3RDQ3N2M1elRDU0lrVVZWVHY3aUpnMTlkYk0rRnZj?=
 =?utf-8?B?bDU3dGxYWkVEVWU4ZW9HNExrZlE3eEFTSkxvVmVja05WUHJ3SmRqamZ0RmV1?=
 =?utf-8?B?NWNsRWJxSlNlL1lUckVmRnhYdWtraktEdlp6Sk1wRnRZNTZNU0lYUlZtT0J1?=
 =?utf-8?B?QVRiN3R4OTJCeCtOQzd1ZUQ4UU04S24vcHZMQkZkY2JJYjVVMWNLVnNYSi9D?=
 =?utf-8?B?Q0FsSnZxQ0IxVkszc2tSQkF6OThKZExQeTJ5dzhMOS9QZnlqSG8xSjlLQkdQ?=
 =?utf-8?B?R2gzZVZyeWJGamhTQ1ZvNkdhaTZWSGVpVlBHUTBrenUvcWpZTFQrZVY3c21R?=
 =?utf-8?B?RzM3Y3g4RGJhRjlpOVQ1NkExbTNPelhNY1ArblRmVzRtaGZ5YTBJb3Q5MUpr?=
 =?utf-8?B?WU10MjRSRnNMVVNJekQxN21SSmhOOFNvZmxERjQwVW54d3RtdTh2cXVxSnkv?=
 =?utf-8?B?NnRnNDZ2cFIwU29PQzZUZldXQ3NUajN3cTV2ZWhXWDllaGdmV0x4ZXdWMHFU?=
 =?utf-8?B?Ui9xSDNjekRNQzZGOWtqZ3p2NmNYQVBZQm1lL21tVXN2ODQ5cUhWUjB3Q0tM?=
 =?utf-8?B?WUxqV0Z5Z0ZsYVVJWjF5NTNHRW5Xa1NBK1kwV3R4TWZQT2E4UWVkQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e52e608-ef04-4ae0-0b2c-08df36779b26
X-MS-Exchange-CrossTenant-AuthSource: CHAPR12MB999248.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2026 11:19:04.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVHTXm0bxkfLqysrc7kwcYBZThXLK6cfPFqj091EzhMUM/QGDjF3C15MOcA5jHzMeLq74caT0SPwGCjeCu+Riw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB320397

On 30.10.26 01:22, Prathamesh Deshpande wrote:
> mlx5i_pkey_get_netdev() reads the QPN hash table without ht_lock,
> while mlx5i_pkey_del_qpn() removes entries under that lock and then
> frees them.
> 
> PKEY child interfaces share the parent's RX resources, so RX lookups
> can overlap child removal and access a freed entry. A lookup for
> another QPN in the same bucket can also be affected.
>
I don't think that all these cases can happen. But I can see how a
CQE completion on the parent can read a pointer from the hash
bucket that just got deleted.

Please improve the commit message.

> Hold ht_lock during lookup and save node->netdev before unlocking.
> 
Holding the spinlock in the datapath is not a good idea. AFAIU
using hlist RCU variants will be enough.

Thanks,
Dragos
