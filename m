Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010022.outbound.protection.outlook.com [52.101.201.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B593C07A;
	Sun,  2 Aug 2026 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785690098; cv=fail; b=SqyfRzfe6tD83eIZyFAopuhGaMse6SIZVGYOlIHyazHV7OvSuc+zQWk5xuji+LB/QEmxwgzpq9xwsUx/Dl6urqo5aATzbPMEFIht2h6urkzprRwruIc3OTUe5jdTrwx431PYJNPnPjKnh9GKzX1+phaTc8gvNufcfT7C+fECTVo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785690098; c=relaxed/simple;
	bh=O8TwODpxEnvgv8Zd6fShoepGiaxKrl0pfIdBmLhEpio=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HWhMGvvGT8eya75l/BmrmzmZCPPGdgbXlenOk3RZNxVG3Er1KM8Y06RwWnC/mCRXjxWYm77gno4WXulEcEaq0EJQo3M/g/dvtrrRdz4bCuS58Yr7ZhyzvPXD1VZf5lXAjdNqjLeRWV+OS1JdwnPzCeoaFU1tHARq5vbCUo3alTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hXgcPyw6; arc=fail smtp.client-ip=52.101.201.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hXgcPyw6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+hXdI3GwvKG4iyLKuv8rDfutWRKbtnzoVew7BAJh8ocM/xKRT/woA+geqOMzN603XzHmJXIp2Pik83ou200LROKM7zKe53s2sJ4sQVzyRwwUMxLhZCi2DO/t+eMfHrRwjEMZzs7Q914K8GtcYtBt1tGpODp/7dZMu7xSbQFK4M4ej6BCmjeUTMezAAtM5E46fhcxg0GFsBBUafdiY+shoySRxPO8piVgSvs0o5D8+so96bMBNh0jSRFxRG7C6ZO7qMQvqcdmYuxyIKhYb4kVolS5f90XoVvPHbu+PhpkPfCvvSLiP/kIL5hJAmZZ9tMjfdivqsgOCVxmlvwjoRBkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XsqlfI3pbKQ6j9uT6KtdNbzU/fndrzg8sOPpz1XddQ4=;
 b=Zz1nL28wgi+08AogBUtec2aabBw5kInunFytcyulD7wr7TzjhV3P77VeOtWUlV4NDIWZqBFL4XIPN9Qf4pnkoDWfpIeDMW/y6I3rsif81rljYn+Rvsb6p48t/C5+XG3bz+b5053fR1hJdvl8TpF3vJpQ/7XYpbLodEbI+9R6xsko5Wyyf32qoKN35LLwc+vdtLJECxpvzQ8CH/4icsFsNSSpDznpALZV+o8dMzaAMYqNdbCqQndEL8NToM6oJPq8MFCkZjrsrhxN2lhKj+K0DHZIlqBPMyPxeR5i7/zPLQNwv2r7kcBlbhsYHXOMfzfFV048AOiDnQSl49+2k7M+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsqlfI3pbKQ6j9uT6KtdNbzU/fndrzg8sOPpz1XddQ4=;
 b=hXgcPyw6tmH0QIp5HvvsGJxhsgHJrmAI7k5o6zec3mw7QVC5Lkd57IgIRkJ0psa6lviMdsL4MlrXnjSbqjHJ6JcNTELWPRjQvK7x07rxJP5ATIBOm4Lr0prgC+1MYHaVN86tsuKPB+SfqQonXvJungGp60l0vkzzwSpvgj9guxQZTR+sJ6dax2hhORdImAMIQRetJ48dPOFi30IrXBo1ZsuwlBQZVgcF2q2y1WQ4B6DAYbt6c7l7yZn/KEZBmwYFQTbs5A7nhYqNYdsTw/riSPXKXpQb6S9aIBObsIYmEuD3equ++kSWrqiR15ufzoHMPprU7A1C1Lfr9oxL/02Glw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB9734.namprd12.prod.outlook.com (2603:10b6:8:225::23)
 by IA1PR12MB6017.namprd12.prod.outlook.com (2603:10b6:208:3d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.17; Sun, 2 Aug
 2026 17:01:32 +0000
Received: from DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917]) by DM4PR12MB9734.namprd12.prod.outlook.com
 ([fe80::ba44:51c5:b641:2917%6]) with mapi id 15.21.0270.016; Sun, 2 Aug 2026
 17:01:32 +0000
Message-ID: <2d0733d3-8181-4082-96db-02163698857c@nvidia.com>
Date: Sun, 2 Aug 2026 20:01:24 +0300
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net] net/mlx5e: Move representor vnic reporter to eswitch
 devlink port
To: Simon Horman <horms@kernel.org>, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>,
 Adithya Jayachandran <ajayachandra@nvidia.com>,
 Cosmin Ratiu <cratiu@nvidia.com>, Daniel Jurgens <danielj@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
 Kees Cook <kees@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Moshe Shemesh <moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>,
 Parav Pandit <parav@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>
References: <20260729070059.2421788-1-tariqt@nvidia.com>
 <20260731165722.GK51943@horms.kernel.org>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <20260731165722.GK51943@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0154.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::9) To DM4PR12MB9734.namprd12.prod.outlook.com
 (2603:10b6:8:225::23)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9734:EE_|IA1PR12MB6017:EE_
X-MS-Office365-Filtering-Correlation-Id: 5918b8db-fa98-4f7c-2345-08def0b7b3f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|22082099003|18002099003|11063799006|10067099003|56012099006|4143699003|5023799004;
X-Microsoft-Antispam-Message-Info:
	DkiDusFUnuXInNNQHw2gJoUfDjvqNk5YS5Gz85boSwlFAzwoYJ9LILLB0+ZUZv+HWKh4IccUaUFHcLGfhUfaIn/GhBsYM06t1wQwgFdcJi3grFd2zfZSVJSq0S3HuECXF0VB6kIA9D6yY+2kk5KziO+DlYf2VqPzFrMJzPP9pcaOqCbIoBG33x4fsA/6KYi2g/DlTfAo08EE7HBud2+d2hJ/xOlIspz/TBBkdoMfGg6YJfIBqXYgEc1JRGZkemaMKOo+jxlO2qWHeq63GiNMVNPWiX9zIRH2E6O6TZVyZKra2YnLqn6sqywv9QcenuRvztRbAI0i5z/9Sa9142CmO3kohg3kdbEmXkfUvuuLMpMyvHCm3bcyDojsK385zcX9760eK3h1fuz6O+ScOOqX+v4I3d9PtvV1PQjqkbVeADIHZo0AV3WfoU/kamVGAL7Nvm0A6THZ1qdnaLV00Lrvvln3dFB5upkaspK7U9jIDtobffPQVL4bK25MJMwGPXoaZ3nfT8y1nbD5RGKkcti1Hi1In/25DTdxgmu7cU2Q2MrjpfpoZqqz4Qhf7hfzTGa6yt6Nz8wZVtoRxtizNbifpy+JETl+ryFR0u1cxHquaXayGdEjNP86AgIpfPW5+o2Yp77Ugjzz+Y3IY75E2GGtFtvsUbEb/oyjUa7pFZWxDRY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9734.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006)(4143699003)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkdoL2pQMGQ2TkdXZm5UTTBRSUhIclhlME1oczE4V3JhOG5kSlFVTkNRRWVX?=
 =?utf-8?B?OUE4bFNJOTVTS2c0NXgrZHZCdFo5YUVPQzBGNGgyc1IvUlZod0ZnUW1xMGxW?=
 =?utf-8?B?YkNlNnNSUUFNNkRSaVdQVjNsWmcwY243ZlRuTUJySHkzWUlnSnlPNGZzS3Yy?=
 =?utf-8?B?SGdZanRKVWNYbDNnQm5nTVFBMFJUdkJaYWZxMWNLd2NzUzE4aTRLVER1c1ps?=
 =?utf-8?B?dUZKUCtIb2FYdnZUUks0QXRMZWNuK005VkF5cFMzYzR5L1ordWU3dG5WZGFu?=
 =?utf-8?B?KzNsZmNISmpBVnhSVDU2REtqVnF2RjAvREUzamp6K0lFMkk2QzdaSndkMkNj?=
 =?utf-8?B?ME5jbmFNcDA0ZkpKRndRcHZwK2wwODJtZFVvSVNRczVndUQrcThVNXVJYXBs?=
 =?utf-8?B?aGcrNHI3bjlhSUR3VW5TV3RNOGs5bTd4VzhvL1cwQUsybHh0RU1jTWJkbXZk?=
 =?utf-8?B?eHdlbkNYNUhuU3MyRy9GWkJvQkNGbjVYUE9tdzFIYW5XcWRrWHczR3JBa3Jo?=
 =?utf-8?B?MXZEckJJbmhHOVFscXVaakJQUzNFOWI4NmgrZ0ZQbXpXTTZrNlNjbUM4MVkv?=
 =?utf-8?B?R0thbm5sVkkwOEFxNWxIenM5elpPc1BmdDVMbGhrZkdRaXFzTHJTM21TZ0dG?=
 =?utf-8?B?dWdYU3h2OUxURCtHMHRkeWdFMWdUMDV1Lzh0U0I3dWtjM0hRb0xpN0R4VTZG?=
 =?utf-8?B?Vm1HL2piWVZEN2hwdndIRG5aTTFMaUZJNFZlSXRzNGRxYlV5dUUwczlDYlpQ?=
 =?utf-8?B?WXNTcGlTSFlIMVZtclV2bUIvMnhOMy80aXhnNTgrSEtDL0N1anVFOXRJUlBl?=
 =?utf-8?B?MU00Z2JYQ3pNUWxtUlhieFZKMkxLMDRESnd4Q1hlRVhVREx1R1Y4Mi85aHh5?=
 =?utf-8?B?bWVBZ0tiR2RtcEg1N0dqSG42VU9vczNEMkozNVdIUUpabVVkTTdBQlJDWXdT?=
 =?utf-8?B?VFQxakNsa2Q0ekUvbUNza3J1VWt2SGhqOWZZSzRqL0JkSmFLTW5QTXBWZXlJ?=
 =?utf-8?B?dm1hYmEvUEdqcklkeFQxbHFOK3BkcUt6ZmlZR1ZzWkwrT1NWY1U2YmxBbjIx?=
 =?utf-8?B?S0YxdjlHMW9aa2hrQ1h5RVUrRElUYnNuWlp4Uk1WOEFPMGVWL0k1eXZaektJ?=
 =?utf-8?B?N2c4N0VINXJRSzBJbVBraTJQTHhRSHEzUXJsWlBKRFJFaGtnamo1eDhHQkN2?=
 =?utf-8?B?M2hYYkZacTh5S1BFRmZlS1N4Ukh1VVkyYzE5eFUwdjJDME9UTkwrUDlSUEpU?=
 =?utf-8?B?TENYQjRlb0ZpSDREM3F6bXRkMDUwcEhIejcwVGRvU3I5S2QrM1BEa0crckpn?=
 =?utf-8?B?VzEzS0RDQXhrWDVnZFAwVTJHWGRKRTVIOUtESGRqcWE0aHorRldxdzRQMjVG?=
 =?utf-8?B?UHZhbS9Oei8waVZLakRmdE52elBPbFVpeWVSODUzQ0ZJeFBXQmh1VkpRNzdy?=
 =?utf-8?B?cEtFcHlhdEU5WHJ4TlJtMVlPSWR2SW1iNkdVQkNicEFGaXVwVStDd01lSWZR?=
 =?utf-8?B?UnBWcTF5STQzYXMzYXFta0gzWGJNZTZpUHY2TTVMQVRZdGVDNWIrYjVzQS8z?=
 =?utf-8?B?RFlreG1NUTNRS0dINWRXNjQxWm5TMFgvbmt1UHJYcGVLT2wzSTk5V1EycVNJ?=
 =?utf-8?B?M1FjUTZzVGlOaUNXUnBEKytXcWtvZ1hES2lhaE5GZm1Nd1JGRExoTGN5ZW1n?=
 =?utf-8?B?NSt5SzM3enJWemEyTTUvSTNoRzk0MllWU2R0ai8xbjZhOEJxV3paRG8wcUUz?=
 =?utf-8?B?cExHWGRyK1lsdGc3eGVZTmVLUVhENm9aS0ltUGlCU1dOcWdWcGpta1dURjg1?=
 =?utf-8?B?ZGtQMGN0Vm4xTENnTlVRWEZjZm5mb1VFTUg2ZVljbXJ6K3kxOUZRR1VUS3dB?=
 =?utf-8?B?UGw4Ynp5TVpZTmkxdFAxNWZNaFJnd0hBYldYd3hjbFZLMkZIQzlwOTB6Q3dW?=
 =?utf-8?B?T1FOTDI1TUoyczJNZzJzS1dUM3FRSC8xc3A5S1FDeXV2TE9JSnIxSDFseWxN?=
 =?utf-8?B?VldGY1ZZclVVSjdnTi9qM2hSaVJwQzA1SUVxRWhRcHNNZTNNeGRuN1Q5Zi9z?=
 =?utf-8?B?emVVb0xIWm9zVVJkb1BmM2l0SHJOYjRtd0N3Z1ZaNEJMVno5RDUrTkpZcHJM?=
 =?utf-8?B?UzNFWUxDOUhockZEakVxK25EeGFZQzl1ZzVRVklFYTJKcUQ3aytnaEF5SkhL?=
 =?utf-8?B?eDFYUFN6d3pPYjJTblJNOEFuVUR0SGh4VEtpTUxhRDl5czFZaEFWaDk4MTg4?=
 =?utf-8?B?aUZEWDhybjB4T09Fell3ZnU2Zm5NYkw3alI4all6eWppOE1zWHFrTHdGdTFX?=
 =?utf-8?B?VE9tNnRIVEJZT0tJQTZGVW5IQTRacTU1clhsMnczK0FBeWhpRjYyZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5918b8db-fa98-4f7c-2345-08def0b7b3f8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9734.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2026 17:01:32.4450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wc91ziQpo3PVPe5Gjt0Z/BnyYYTARGzMwMoPCzpb3lKtUpqwwS4C9SKsKL661jE5xLC0JtjyKO/NYbJodSgeYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6017


On 31/07/2026 19:57, Simon Horman wrote:
> On Wed, Jul 29, 2026 at 10:00:59AM +0300, Tariq Toukan wrote:
>
> ...
>
>> @@ -252,6 +275,16 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, struct mlx
>>   		mlx5_core_dbg(dev, "Failed to register port resources: %d\n",
>>   			      err);
>>   
>> +	rep = mlx5_eswitch_vport_rep(esw, vport_num);
>> +	reporter = devl_port_health_reporter_create(
>> +		&dl_port->dl_port, &mlx5_esw_rep_vnic_reporter_ops, rep);
> Hi Caroila, and Tariq,
>
> I'm wondering if you could take a look over the following which appears at
> https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260729070059.2421788-1-tariqt%40nvidia.com
>
>    Can rep or rep->esw be NULL at this point?
>
>    mlx5_eswitch_vport_rep() is a plain lookup with no NULL check here:
>
>    eswitch_offloads.c:mlx5_eswitch_get_rep() {
> 	return xa_load(&esw->offloads.vport_reps, vport);
>    }
>
>    and rep->esw is only assigned lazily. In mlx5_esw_offloads_rep_add() the
>    assignment sits after the continue that is taken whenever no rep_ops are
>    registered yet, which is the state at probe time when
>    esw_offloads_init_reps() creates the reps:
>
>    eswitch_offloads.c:mlx5_esw_offloads_rep_add() {
> 	rep = kzalloc_obj(*rep);
> 	...
> 	for (rep_type = 0; rep_type < NUM_REP_TYPES; rep_type++) {
> 		if (!esw->offloads.rep_ops[rep_type]) {
> 			atomic_set(&rep->rep_data[rep_type].state,
> 				   REP_UNREGISTERED);
> 			continue;
> 		}
> 		...
> 		rep->esw = esw;
> 	}
>    }
>
>    The only other writer is mlx5_eswitch_register_vport_reps_blocked(),
>    which runs from the mlx5_core.eth-rep auxiliary driver probe
>    (mlx5e_rep_probe() -> mlx5_eswitch_register_vport_reps()):
>
>    eswitch_offloads.c:mlx5_eswitch_register_vport_reps_blocked() {
> 	esw->offloads.rep_ops[rep_type] = ops;
> 	mlx5_esw_for_each_rep(esw, i, rep) {
> 		if (likely(mlx5_eswitch_vport_has_rep(esw, rep->vport))) {
> 			rep->esw = esw;
> 			...
>    }
>
>    Is that probe guaranteed to have succeeded before ports are registered?
>    esw_mode_change() discards the mlx5_rescan_drivers_locked() return value
>    and sets esw->mode = mode regardless, and add_drivers() only warns when
>    add_adev() fails:
>
>    dev.c:add_drivers() {
> 	priv->adev[i] = add_adev(dev, i);
> 	if (IS_ERR(priv->adev[i])) {
> 		mlx5_core_warn(dev, "Device[%d] (%s) failed to load\n", ...);
> 		/* We continue to rescan drivers and leave to the caller ... */
>
>    In that case rep_ops[REP_ETH] stays NULL, rep->esw stays NULL, and
>    mlx5_eswitch_load_vport() -> mlx5_esw_offloads_load_rep() ->
>    mlx5_esw_offloads_devlink_port_register() still installs a live reporter.
>    Would a subsequent "devlink health diagnose <dev>/<port> reporter vnic"
>    then oops on rep->esw->dev in mlx5_esw_rep_vnic_reporter_diagnose(),
>    with the devlink instance lock held?
>
>    The old code could not hit this because the reporter was created from the
>    REP_ETH load callback, i.e. only after rep_ops were registered and
>    rep->esw was set. Note also that mlx5_esw_offloads_rep_remove() does
>    check the same lookup result for NULL, which this call site does not.
>
>    Since struct mlx5_devlink_port already carries a struct mlx5_vport
>    pointer, which gives both vport->dev and vport->vport and whose lifetime
>    matches the port exactly, could dl_port->vport be used as the reporter
>    priv instead of the rep?


Good point, will fix it. Thanks

>
>> +	if (IS_ERR(reporter))
>> +		mlx5_core_dbg(dev,
>> +			      "Failed to create vnic health reporter for vport %d: %pe\n",
>> +			      vport_num, reporter);
>> +	else
>> +		dl_port->vnic_reporter = reporter;
>> +
>>   	return 0;
>>   
>>   rate_err:
> ...
