Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795504013;
	b=dF4OtJEEz+7/O7HtDxD+o0q+RY1cKxLK+CDp3StmbbZG67GjGNwiqLWv2taIi1zn1lIZ
	 65lK01PCoVr0p0/UwRpq9++EWKra3Kk7tIJwTfKTZvxScaRBzeF1oopzkB5jN+T2LnqoT
	 IVCkDnHRR4ybe3m3NUlxaZXaVFe5WRg5tyaBOnEjpnxUblJmCoiNUcqnf0xW+/ESQZx5T
	 +gy9UVVontEPwz8r1tL6PROLUt4TbgPojhnqNjw+lsDyYn1yFoFS0MaIGwkavZCCU41Jp
	 gz4275cRN7hN2MMeZ4BG3wki1TVpoZufqBsqU6LgjDgZY8K5Q9SbLfpD3Fw7eCSDZoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795504013;
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
	bh=lBmyiwShT6KL6cwAUhgXdss3N2PgV3nLAKRbINahZIM=;
	b=mlQJWOosEEX8YRISSKJKJFLnVkL2DI9J3ceqW7YIafm+dQBNf2ZLxJcM4/hrXSZL6EtV
	 RKMGjeRzG2ocpN2chfBsCXedZy5df4iap5wN7Isqklm6JJ5kbWIffbJRih0SyQDBcXqWX
	 9TSgUJhb0YGbT3/X8i/S3oHIhDolIGBZVyWlGKrh19FdrrWmxqNTq3fnfmo9bZ+D3XDFb
	 ijKekzEtUdb672JRZyE+jh90uQR/uqW06k83fn9SVr6W9lXiyaW8zbFzQLiqjKsE3jE2U
	 XJC3xffmXAMR6rFQR6/uUZXZJzkLzB8b4HOL6+T7fNiqHcd9fwP8ZqUnK7ncBn9byCg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=q84LbBnK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.70
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013070.outbound.protection.outlook.com [40.93.196.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70645606A31E;
	Tue, 24 Nov 2026 07:06:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70645606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=q84LbBnK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mhWmgbgURksu2FQy4yVQw74707huY7P4DzU7R9L2K4Ngw+NsapK+ZRtLZ3pWCGGa+XkwIo+FrAuBoHDqBkMZLfiBQp1Ifblb4u0yqJhD1LqVnXNhyPF01/CZC4IdhhhpMsZxs/J2eWtZiyeBtCmqoCbt5ehPpQq6MHTAAiRm3ZesDJe8Dktj3b0Md9uB/0lkeAGco0wOMIMOF8us9daxp9CYyTA4aNJvmSZzVvxloJ9IUeoj22SEIn2zhgNKhI0LthiQYtwzytgIy5bYtBxHEiIuipPbRXUreV+8GFbuS+2tLfog0X5Uj+r88OdnHTkg/zDLSRdJAA4JRVC8rN1diw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lBmyiwShT6KL6cwAUhgXdss3N2PgV3nLAKRbINahZIM=;
 b=tFSd4EkMSnzzms80WV6TNVGUbQRU7isUJmWM3mQ34WTXXcywGlc1MTZjRo6de4HakMGedzqlrSbiwbDRMh8qeFgwCzCOtP2FF8KGyj4sS7lIU3yOu/Wi9Tcx36xmg7vRvg1Z7H1ckfinX2S0IOYoIk3BSDkVDgRGYexxzu6eLB7HDpB4BfzlBwf5nhvBKU4yfr3JdKo8KcBVpTgP0Z9vt6bO92NalYghNlXXgVHcE04jjlpdo5gGEmuB9q8xnriBl7s7/BU2ryUa9wjt+4306A7VfyI9oRZfdtCBvmev9YbXNCvc3fM3v2ff5ckFHRb7qF+xom7dFYPi/rHWEuUuZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lBmyiwShT6KL6cwAUhgXdss3N2PgV3nLAKRbINahZIM=;
 b=q84LbBnKyh0ps4RrtmwIddf8l5XEHENVcU+GldD/YXq50wNWn2OdR/1sr57Wio4FUSqD4WcFp9Bf+j3ZaEys6eCGX9q387eIJd18Cf0H5Brbtad/V0JkIUrYaUcMcxytAtoyuQzoQPzQuVk691DrYAjvQdctpxfLOL3BWrQCmGrqB06tcoql3tmPWxnL/uqn861SSfECjloBoZc9gnm3nTm8sDQHEhKfMCkZbDC9D56APqPsSmf9WECyTqFLbwI3Phqwss+lBx2+7AzEslcPlijaihleBeLvidTeqOFIsQW/s+9nkPuWWJezJ2HMcQq+qTuX6h20d1MTTTQmtc/gpQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 (2603:10b6:806:4e5::21) by PH7PR12MB9175.namprd12.prod.outlook.com
 (2603:10b6:510:2e6::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.13; Tue, 24 Nov
 2026 07:06:49 +0000
Received: from SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761]) by SAVPR12MB999143.namprd12.prod.outlook.com
 ([fe80::219e:6553:2ec0:3761%4]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 07:06:45 +0000
Message-ID: <d3fb8db7-da9d-4eba-96d5-29b34d3d022c@nvidia.com>
Date: Tue, 24 Nov 2026 15:06:38 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] net/mlx5e: IPsec, Fix RX mapped ID leak when
 adding a rule fails
To: Changyul Lee <lcy8047@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261120025501.1675212-1-lcy8047@gmail.com>
Content-Language: en-US
From: Jianbo Liu <jianbol@nvidia.com>
In-Reply-To: <20261120025501.1675212-1-lcy8047@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::13) To SAVPR12MB999143.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: SAVPR12MB999143:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 96730f62-723c-4325-65b5-08df49f9801a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|921020|56012099006|11063799006|261102123227099003|261028144727099003|261009223027099003|261021121427099003|261022105027099003|261026140227099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	5KjUrxYlEuRAgcnadfD2CL69Stp5NJHXE+zeYO+v0qD6D+KkHB7W+H1TxWpcCWfLJgja+fHDr42gEEhYQyjmJKUqjUjshrJCFrDDL93eEVsE8ip81DlDrX9lRQNBKj/YyOKiJLNCPWHfTdWfcAdF3XzsOdWqe1+ps7T9vpxF0jcgiY1zQq6lo/jWsjBWe7PkgkJ3LBVoFO/JZWQrUTs+ZDsRIp4tFUOhMjrNXxWVLGJfHLbLwqQGkrSHXaoImcyRt6hML9Bt4yiUvfwe/86rZoDIC/OS4AfovJenl77PQkTWbQEmK0FY22UFd9vfuxMLqXaQp8Kp7XAGRn1uaoqvgsDUT2g+6/19+zlRobXKZ8tlHvJIyrHuryRlw/CISg8Rd/72SVFY26m84C6g9Bco2zbuWVtw/Y7yYdKUD/IiGfwuj3U/l8gPe9QQwOwG2Q65S12fb3AEz4U6lP+sZnj/HdxdMDx2ULskGp4VVILm+S/cA8winNlzq7voKn4IofrfEBcSnYke++dQwMmoEvVUx7XQbrE/GPYovEVc558Dm86wAJGm2dAUX9E9Irv6qv6A7R2OWobegHQfSbk+rIbA/FFn6uASTThWm4yrVHLUZ4YP6+HXdqpSHh5nD/lcYZTn+sqQI5pvKl3wCwiGdV3ktDcEA7ddiHLp0Rl2Yz+4oZ3DJrUR2Y1zSEekRbJr5bnqg10UU+NsYHs/s7SKL0uwrA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SAVPR12MB999143.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(921020)(56012099006)(11063799006)(261102123227099003)(261028144727099003)(261009223027099003)(261021121427099003)(261022105027099003)(261026140227099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UlExdmh2V0tTOFZsZmc4dkFORkpyZXUrS0c4cG44RlhaWC9VUnhCTFFlMDJM?=
 =?utf-8?B?bVNRZThUekQ2azhpeDlheTVueUI2ejhyYjY2RklUNFNXNHFlb1NzZ1Fac2p2?=
 =?utf-8?B?d2FkKzJxeC8xbmFkN1JvSENjWGtkQUt5cmRoU0ZQRUE4VElKVHNlWm9mOC9v?=
 =?utf-8?B?NUlxU3Y2N3VyVFU2WUhpZHlTelNjVk4zY0lNbkdZTTFWeE5oV2JYUkRNSGlj?=
 =?utf-8?B?WWZCRlF4YzVYUXlIazJQbGZCZGQwVFI2NitZVU5Bdkp6NnYxbS9XaXI2b0Zk?=
 =?utf-8?B?blBrazRFNjUrV0xMaWEvV29PcHp0Vi9qQ1NKamxMLzZTa3hTK2dOL0tUOFJ2?=
 =?utf-8?B?S3RCRUlOZU1rUU54QVdTRTEvNWhrcWtSODBNTVUwcHRjRjBSTERzeDh4dC9m?=
 =?utf-8?B?N3M0ckFycGlSc3hvS1V6dEZhNEJtS0ljbTZzVFVlVkU1ejhEMWtiTDh6Z1Yw?=
 =?utf-8?B?MXd2ZHhHczBKd0o0YzVpNXloRHFmdVZJeVQzb1crQk9jeHVHbzN0cjNmRWNK?=
 =?utf-8?B?akpoU0ZRS1pHVDA3aG11VDh2TkloOGdTVnZyWFREOCsvOExPSVFJZ0RRMzNJ?=
 =?utf-8?B?TWJUeVpWbzcvdWZKUTUyN1VuR2xNWVdWWUNDbVR3c2I0bFF3RU9jWFpac0tZ?=
 =?utf-8?B?NFpoV2d3ZFJQRGJ3SHNYNmwvOWg5S1IwY1NCOGY2cXk3Vkd4eFdnaHZINjhl?=
 =?utf-8?B?SUpTWmNwbERiUlRrL3VJaTcreHl6b3hkdWhxOGEvOWNzVzZiaDlpVllTYmFw?=
 =?utf-8?B?a0FEOEFTdUt1ZHIreTBuWWNUUytlNGZHL3JVaGJHcU1uWnphdVRkWVpya0VJ?=
 =?utf-8?B?ckxGZGowblBUc3JyVm1aOFRSMTZyZWE5c1d6VHF2ejgzei9HSUhVdXlaY0Mx?=
 =?utf-8?B?SGcxQUxUMlNqN3FFMEkzUFhKSit1cjMrWTZ4b3hIUS9LSWZSeXo1WmVyeU5z?=
 =?utf-8?B?akpSUHZCSXl3L2VKaDN2RkhHU1lxMmV0bVV5UDZxVmRDVGdmV0JiWUIwcURl?=
 =?utf-8?B?a0ZjNThyVUI0VUFkY05uVkdnOVp6YlRBNWVMRXpzMEpUUXk2bUhZanFoUmlS?=
 =?utf-8?B?Z2IyUW42SWZHdVM5UUVLM1ZndlBHTlhnT2RKbVNiSXpqWHdaeENsVzkzZ1VT?=
 =?utf-8?B?cW15QUpYVVpzSmZCdnJtU1BKeFFkdlB5RVN6QmRFVStmd3NTR05qQmtEQjVT?=
 =?utf-8?B?aCtaaTZsbUlyRWpYekRhTENZOWxVK2Rja1BjMHc4UjBzRC91eEYrbkZMUGxS?=
 =?utf-8?B?Y01HbWV2SkhNazFUZm9LcUZsTlBuT0Zqb0dmWHB4blBieWN0eHVkWGpNSFJw?=
 =?utf-8?B?MnJITENQOWVlU1RtODQyV1lKOXZPaWRVNDhEdzR1cU4rN1ZWcGpTOXRvNlE4?=
 =?utf-8?B?bFZpc1ZBVE5WTkMvODQveGlXMWJ4TmdocTRoa0xtUGtXeFFFeGMwN2oxWjU4?=
 =?utf-8?B?TkxxK1VlSUtOZ1pOdENvVkU4R2o4bW9peFBOL1dhdnJDbTVFMnVSTVd2VmdC?=
 =?utf-8?B?Z2RQa1VYOW9tVytJTk01MjVOb21zSlZtUDdsK1FnWEo1TWZDeko5ZzIycFJi?=
 =?utf-8?B?K01aY3NEQkFzdlJuOHhOVm1iZURVNDB6dk80QzRqdkczbTMrT1VWdVkwWHpx?=
 =?utf-8?B?SVJ4eWVVa0RnWXRzbkxOQTBLbSs0WUdmd3k4bE0rUk9YZ2NsMFdSalVieXJ4?=
 =?utf-8?B?cGp3dm5OL2hIM01TNTRCM1FZdHhBQlk4ZEVpbmN6SElsVzIxWEZtRjFQbHlm?=
 =?utf-8?B?RUJsTnBvdkZoOUVIbXppdWVIWFpVdjEzV1BrSU5lVjZXbEZtc1NaYk84NThp?=
 =?utf-8?B?SVY3TzlwQTRXbWQzdzhrOG9KY3lmL2N5eHFCUllRK0lVdFl3TVByODhGc2h0?=
 =?utf-8?B?MHhnaHRDM0wvUXdKWE9rUFNQbTRHdTVodmNVWW9aNzFocnlaSzV2K04rSTJV?=
 =?utf-8?B?ZTdUSEVOVnl0TG1IRDE1RUlaTFBwUmJQdXB1T1NJbFIwM3VtR1JUL3I0VjBl?=
 =?utf-8?B?SG4wTHg3LzNiWktodnpwcEFhYk1ZeE1JWCt4MlZTTUlGWjJidUpzbE5JaWZW?=
 =?utf-8?B?bGVEYk1PTWt5cVNHRmtJL1ByS3ZiKzByL21RS2Zabkxmc291bktWbnZCbzRV?=
 =?utf-8?B?b2IwUFF6L0d5empZek53b2JqRng1K1lZWGRWRDVEOWJUbFp0V1g5OVE4d29p?=
 =?utf-8?B?bENJMzNUd255UThDRFdURTlEOGFWMjU4K25FTjNFM3ZDc3RFWVZ3Nm01RWh3?=
 =?utf-8?B?UGs3TGt5WHFBWUlKcEtTbzdMY3BFcVUwUEQ4djdoOVFwSDd6YUtTZDduTmcy?=
 =?utf-8?B?SkpGZy9BbjNuWDd1ekhtaUZDa01aRVJOWnpWQWFITW5CVGZ3N2JjZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96730f62-723c-4325-65b5-08df49f9801a
X-MS-Exchange-CrossTenant-AuthSource: SAVPR12MB999143.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 07:06:45.6173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8l5h3F0eS+scAyh7aBbs424RLTv2j89u92XZW2YDf0Dn1GkFSRg1cS8BUjGsFKeOp/5mocSsOeMjm7/5nS7vVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175



On 11/20/2026 10:55 AM, Changyul Lee wrote:
> In switchdev mode, rx_add_rule() calls
> mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
> the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
> frees the modify header but leaves the ID in the XArray, and
> mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
> packet offload SA leaks one of the 2047 IDs. Once they are used up, no
> new inbound SA can be offloaded until the IPsec context is cleaned up.
> 
> Release the ID on the error path under the same condition that maps it.
> This label is reached only after the mapping succeeded and stored the
> new ID in rx_mapped_id, so the copy that mlx5e_accel_ipsec_fs_modify()
> passes in never loses the ID of the original SA.
> 
> Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in switchdev mode")
> Signed-off-by: Changyul Lee <lcy8047@gmail.com>
> ---
> Changes in v2:
>   - Release the ID under the same condition that maps it, as suggested
>     by Jianbo.
> 
> v1: https://lore.kernel.org/all/20261118051247.3885308-1-lcy8047@gmail.com/
> 
> Found with a static analysis tool we are developing.
> 
> Jianbo tested the same change on ConnectX-7 in switchdev mode with fault
> injection on one RX SA add: 46 of the 2047 IDs were lost without the
> fix, none with it:
> https://lore.kernel.org/all/96a5ce67-89c8-4010-bfc4-4553e1aefe87@nvidia.com/
> 
> On our side it is compile-tested only, with x86_64_defconfig plus
> MLX5_CORE_EN, MLX5_ESWITCH, MLX5_EN_IPSEC and W=1.
> 
>   drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> index 5c69e89b13a7..1f0ed8ab75d5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> @@ -2163,6 +2163,8 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
>   err_pkt_reformat:
>   	if (flow_act.modify_hdr)
>   		mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
> +	if (!attrs->drop && rx == ipsec->rx_esw)
> +		mlx5_esw_ipsec_rx_id_mapping_remove(sa_entry);
>   err_mod_header:
>   	kvfree(spec);
>   err_alloc:
> 
> base-commit: 2a324a58a084c5cfd7e5a2f55e0786bee170a4a5

Reviewed-by: Jianbo Liu <jianbol@nvidia.com>

