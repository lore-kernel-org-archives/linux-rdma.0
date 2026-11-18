Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794995354;
	b=3ngCAFSNEnvllCOAE+pONn//pKIRHnKB9PWxd113YXrV+qOW2D5PW8OnW237eFMu/ZzH
	 hqpZoIrUTfkXDLOUxAxJD/egulaMY0E1FqHAUQuSM3sF1u5keicS4Z8MmoRtDzmrFAAT0
	 DWKBOheYDvPi+yloS7jk/oMuoI3TVwkAV47sm5ACDA4AS+OaPIsAjSGgGh8jXOYFd+K2n
	 WHHSdn6bmZ3/XCju5Fx6AjpDRbkVfOrH5zKa8lJJ88ek8gvkt82IZQvCZh7BV2sVomXKR
	 uSKLcnBkO5DTe+TmF7L3nSf3o+CMk0AdJjAfFS1kKIj6NKiF5Nw7MwXJ0YVPk/RRwaQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794995354;
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
	bh=+o4wJf08bRx+9Ccjqy4Y3NjCioCSaFkm/ayZnQtFCds=;
	b=oR+zj/XQUA3SN2qcyTCFhjhjAexM/kuDssfxZhei12dELc2uRviF3E4MG714OXnyDD84
	 DWVyc9KPO7MAOi6DfmP2sc3tamaSCjJ9MDAZ+ZmTtfzIgNlfiQNpl+Ocm1BhVrmJPSPwQ
	 nNP3NGa3LmXFwLYkvHhEeVD+YUcFhxqyvH2Flbj9jre+UXoGiv7OYPgs2/sj7csRPIYuK
	 cgP7SFfC5e6gdn8y+GFrGiwWzvK9IZfnrwQXf3TcIzuPnE+ikZSwnXb0piHRmTdVHwHCZ
	 RUzxxDMnNKN/AEG84cfEhGRD3DNxRdDbe+X+2gzIFyfQpHdPgXAK42TLQp5xooVtXrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=L7aA8aCd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.2
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD890606A31C;
	Wed, 18 Nov 2026 09:49:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD890606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=L7aA8aCd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MGwHFtFlzDsNfabP3pJyvgiaWkTMOgLgnp57XKjRAxsu9QgyLU7588pYyb1gf4tdndn6T+Eo4uHXj34KkddfBU5UOmmQjw8fgHdstX+BVNqDPXUv3QyXR973/WLeiK9PKhXNhgyQ3c8UmIFh+bzqNP0pFFGrwMXtHiaPQMt2SFVCQixI4PSZxj0hn7KA4mgLzfrKoZAtMqU2zoT2G1rIu8BQn95YRHX6aCRokXxvJvrx8bwJ0r5ClEmqRxBgwre3Yn+MyZ7U90QHR4dbZpOW0SIOzz5pCraW7bJT0jPPZgNycpMIQPXeoxm9pnm7JfvR/S/bodyw9V5xR2bKbmB4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+o4wJf08bRx+9Ccjqy4Y3NjCioCSaFkm/ayZnQtFCds=;
 b=KgyDAKsBI7B4h51b1GJIgs7/cRtZbUrlplDwcDOenwi6FtC03I4QTTCD0dnqmT4Y7E7tZPvZicCNAu0x9mCWBjHG7eTJ478RlbF3qiVqojoBvJ1IZrGaCWmRt7Cd/nSSWVyHVtlbffegCnrgr/Vk5ydJ/dIwFdUE4uDu8QpL3asCjQ1bMx5lp1iCXchaL2VW2oWNWKGVDNo4HezsUvO6kVntNozzl4Y/oreX3M5Mu6qGEe+d20xEDZijtpJ45I8fIGSl7kTP3AD+fnQoUADRBgKBUkVgw4cLp90tGgqjUS2iEUWmZk/PhOgO8H2zdAzu3NLCI0VArQHpicxVRJ+L1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+o4wJf08bRx+9Ccjqy4Y3NjCioCSaFkm/ayZnQtFCds=;
 b=L7aA8aCdSZl2MK7GWnXrWLn4EFFyp7537Ftp32uhv1je1StsoMYo5Ge70ZiJhqbqwYhTKaZGAQMoPTE3Ad05shz1GPlXLIQusTH08FT+Hk0By+RleeVmsMWaDNEgZ05gHRsVqHbJF/oe0hy5eWayIKkVq7yppVGwPGdZ+zE27tAnrjA3NZiJ5M4SsAmSMu81oYqfRRPAGr9fTX0trZDh36now2r2DP8Aw3MEmZPv22LAZDrSE+7jQLLqLwfEdDvEW8ZEgHxbZvUJLkJSV4II2XQyrGzucE7S5lFFxXz+Zkqbr1gvitRyZrXv9TySk+hJptyJD6VIBVYbN8j3lhi/tg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by SJ0PR12MB6685.namprd12.prod.outlook.com
 (2603:10b6:a03:478::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 09:49:09 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 09:49:09 +0000
Message-ID: <96a5ce67-89c8-4010-bfc4-4553e1aefe87@nvidia.com>
Date: Wed, 18 Nov 2026 17:49:01 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5e: IPsec, Fix RX mapped ID leak when adding a
 rule fails
To: Changyul Lee <lcy8047@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261118051247.3885308-1-lcy8047@gmail.com>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <20261118051247.3885308-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI3PR02CA0014.apcprd02.prod.outlook.com
 (2603:1096:4:295::6) To SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21)
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
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|SJ0PR12MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: aa357831-02d5-457a-2f95-08df45593124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|56012099006|261026121527099003|11063799006|10067099003|261009223027099003|261026140227099003|261022105027099003|261028144727099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	LTChM0lx1Enm4q51U/JO212Fp9oOPe5isrHfxbL5tPDAqVyrooZXpZGbw8CjogZUIdiGb4k/Mcw+ni7EdkJbtLzne1HMRdjX3pBqj3dHUSQzvNNz4Lkg3V+SkZhUSwM+AGCxS5luLNJYVBCkQEXDNZeJjLj5Z17KGZeTGZrBEe8AAVXt05cf6XyyW1JOkrnTU1YeaNma3+YeaFO9XOM6AuKE6A1d18bGaW1TeMNsX8k30LLrGnGOE7sorXnmv+UjwNq0xyFPfpjwfxoDgz2bPACibZ99YdSDouENghRU5VtFZEuZ21LWJZqBOtvW0+yLQbDy1uXycyFJNeJ5C4fr6UG5ilVHlpBE2cGGPRUJcx4Kk6XchUGe5pU9vl+/QOkhc9UU7oNu3iroj13MYnwPXcHNd00gJqJ7InN3TWWkO6kupYlUaEQi5yF5fzsIxw6asCw6/zq/jZ1sNOPeNb+hUAG16pokaA8Th7/o1Kdb9uvnhIw88vGpkRWYdo//pa6Uz4Irr68pMPNuBYzpHKootwDjSz+vXhzy38qsBENRraBh8gv0gJuxOuiAtXKR/LywL1jJ5eIppvJQSGEjkcorZi76KHED1w6MbK69bmK2ivll8yCBvCaz0AudpcRBZur7Q3MB+i1Ba0TQHwPSV/gpzh4VlbqsD36jP3NyDBDPlKA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(56012099006)(261026121527099003)(11063799006)(10067099003)(261009223027099003)(261026140227099003)(261022105027099003)(261028144727099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUVQZ2lnQ0RGUmoyYlN4bTEvaDVXVE5JaUpGM25OZk95L1NrYlE2ZWhqby9R?=
 =?utf-8?B?K05tS1FWR2duWjM5V3BESWpnU2FEUUdEalh4V2hEVXpncnZ1SFlhT0ZxVXlD?=
 =?utf-8?B?ZnBBcnh4TnM3LzFxeWNQb1dQZXgyVEFJK0JKQS8wdEZYSlpqc0xWUUVtNEt2?=
 =?utf-8?B?QkpNaGt2WmRlZ1BuOHh1MisrYXcwaUF0cGtHR0lSQUlYVjAwRUxxcld6V3dS?=
 =?utf-8?B?US9hemJabEhqMEl5MTBlRHptUm5XUDJ3dmw1NVJRM3EyTU83ZFYwWHBDUU10?=
 =?utf-8?B?OTFmZ0N0NGsrMzBmWUdNbGMvWUpxbUg3OWYvQ0lkZ1gwNnpuTStBS2RBblNG?=
 =?utf-8?B?Q1R1eW1Bb3luK0doWCs0c29BZTJRNXFUd3J0Q2JLT3d0RHN2TGdNcFBtSXBB?=
 =?utf-8?B?UGNZbUZPVWkwSkFMNVRzbmxpdEo2VTl6eDdZZVFuRGFKS2VvcEQrc2E3Ykt0?=
 =?utf-8?B?SWZ5S0tOSG5yUSt6QmhGdXVXK2xpdDdrclh0Z2djWEJLMkFMbWlhR0U4RHRp?=
 =?utf-8?B?M3U2Ri9BQnFUMnd5a0hpeERYSUY0TmRTMlJuQitTVzhuc2F5eExmTkRaTVhm?=
 =?utf-8?B?aXpDeklDa0RSSC9wUmFRYkV3U210Z3ROb3JRd0ozeDQ3UkxnZG81WHoyVitt?=
 =?utf-8?B?NmcwdVNweEZMRnZCVzNkTVBiTi82aElOOVpCY2lHSWRnSXpYRnF4WEVFVU9M?=
 =?utf-8?B?TUU5ZzNTWmN6c0paT2s0VUVaakZ3a0Uxb0xockN0N1U1bkZYYjJ4c0pQTHdM?=
 =?utf-8?B?SW1Qa0hJbkZVYnV3MXdUSnpNK1lHSXM2L0lYVVRxVTg0WUJtaDlScFdrcSt1?=
 =?utf-8?B?b0lQQTQzY2VLRGVENGh6c2VDWHIzRVVpb1RLT21RZDhFcjI2WlBoSVB2YlNW?=
 =?utf-8?B?UUQvNDV4WE81cmM1V0Fka0xEUDd6d0ZxeEhGeEIxOTBHYmNaWnUyRUJRSFpT?=
 =?utf-8?B?TEZKSmlxcmd6RVk0RnpBUHRJTzI2V0VnUlA1eDVISlAvNmxPK3hxNHhPdWE4?=
 =?utf-8?B?OHdGWFpHbWJUSnU0cXdKSHlrRWhrWk5rYUF1MlYrMWY5OFN2aWMxTXR3WnFK?=
 =?utf-8?B?SzI3UkEvM2xxdWV5aTdMZVp3UXZoMThod1pmSnFhRUNNbTdpVG1CMVRCUnhh?=
 =?utf-8?B?U1Qza0RBQ3JpSGkzTWNYZW84Y1ZPT2xvMkpUb0FsUlpMNVo4Wmw5eVlldkV3?=
 =?utf-8?B?RU1LcE9QNGxFeTUzRVU5TnZITzQxdUk3WjgyekxsNUdUK1FoQTZLWmhtdEti?=
 =?utf-8?B?NVo3bU1naEVxWEJVcVpBQVZmYkxuWEtqbkNzKzhHMUEreE95VmRsek5aTlBT?=
 =?utf-8?B?SEV6OTBtRWhTRWhZUnNuM2xjWktGSWNicUZEV2luNE5PTmxFS2wzWU1nbDYw?=
 =?utf-8?B?NUs2MUtMb0tOZWhaQWkvbHBVWnRVM3lBZU85TzBnNUR6ZGJSUXFDTTFzMHJm?=
 =?utf-8?B?ZHlQQW45b0F2NDR4aDhZVUpsU0VsTHBXRURzUHVmTFNvWXd2NHREL0s3L1Rw?=
 =?utf-8?B?Y3UwdERQeHlOckhXS3dSRFNEc3NUZlNIdkRnOEhGYlhRSGQ3MENkWmVBSzJ4?=
 =?utf-8?B?MUd1bjZUdWZCcmFveVk0b2pweHdtV3RMcG9KY0tLSDVjZUJUeTk3akdQTmJG?=
 =?utf-8?B?ZlluYm1vZjYya3Z5Si9NcEV4RzgvVEZaZml4ME5UY0pVazIvYWdDZ2tXeXJt?=
 =?utf-8?B?blhQbFBJMkZ1UUI2ckxweEkvNURSMUNINVlOY0hzSTFocEtwUXpZMjhocXE2?=
 =?utf-8?B?NUI0L081QTRQd1RJQllyU2UrTkJ2OHNiVlBqNGRud2ZUTTNrTTBNZ1VXTXZu?=
 =?utf-8?B?UkdtRWRkVVhDblFtOFNMMEFDMURJSjlEUnRyU2I0dTUrVzhGUGtHaExuZjY1?=
 =?utf-8?B?SHhqZ0xwUU1SaThXU291NEFYOXExaVhTNmRpYThzNHorSk12WmtvTk94eWNq?=
 =?utf-8?B?dlhNNkFLTURIN2MzWDBET05HdjAvMzQvQ01GK1cweDh0ZnZxZjlMK1JvRVY4?=
 =?utf-8?B?dXBubW43Rk1yQm9nVGY1VWdnTDcxYTROZ3phOXpSbldmRXBpcExvZ0cvNEE3?=
 =?utf-8?B?ZC9GQThpS20zazlPYnlCNThoeEU4MTh2bGZITDZML1NCSnNYTWV0RDB1dE1Q?=
 =?utf-8?B?dHNVMkVlMWhtZ3BnaHFDb1I1ZWdJT1c4S2E1bFVYVzFBNitEc0l5QkV4b0Qv?=
 =?utf-8?B?S0M4NlhIcjR0WVFuS0tpbWNaaEh3Y2M2TEFZbUNUa0xsQ1N0bzg3a3oySzMv?=
 =?utf-8?B?cndvVkNLQTg2MEVyVWJ4bkpmRVZSY1c5TXY2M2NROUFWdTlOQ2syZTJ1MjE2?=
 =?utf-8?B?NVZEcDdmcHgrVEVTTnlvWG1TVFBDbkV2UlNqaURVeTJ5QVEwd1VSUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa357831-02d5-457a-2f95-08df45593124
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 09:49:09.0064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnHvhuQ6zB2TxnS9EPEgTieX5ErOwYVEdKYnlnfVhj2JU5I2Hu+JldtjTdCTs9u1iIUbLSLeZnTBtMg5XbNKMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6685



On 11/18/2026 1:12 PM, Changyul Lee wrote:
> In switchdev mode, rx_add_rule() calls
> mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
> the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
> frees the modify header but leaves the ID in the XArray, and
> mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
> packet offload SA leaks one of the 2047 IDs. Once they are used up, no
> new inbound SA can be offloaded until the IPsec context is cleaned up.

Thanks for the patch. The leak is real.

[...]

> @@ -2161,8 +2161,10 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
>   	if (flow_act.pkt_reformat)
>   		mlx5_packet_reformat_dealloc(mdev, flow_act.pkt_reformat);
>   err_pkt_reformat:
> -	if (flow_act.modify_hdr)
> +	if (flow_act.modify_hdr) {
>   		mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
> +		mlx5_esw_ipsec_rx_id_mapping_remove(sa_entry);
> +	}
>   err_mod_header:
We have a fix for this in our queue. It releases the ID under the same
condition that maps it, so the eswitch helper is only called for an SA
on the eswitch tables:

  err_pkt_reformat:
         if (flow_act.modify_hdr)
                 mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
+       if (!attrs->drop && rx == ipsec->rx_esw)
+               mlx5_esw_ipsec_rx_id_mapping_remove(sa_entry);
  err_mod_header:

I prefer this form. Do you want to send a v2 with it? Then I will add
my Reviewed-by. If not, we will send our patch ourselves.

We tested it on ConnectX-7 in switchdev mode with fault injection on
one RX SA add: 46 of the 2047 IDs were lost without the fix, none with
it.

Thanks,
Jianbo
