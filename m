Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011025.outbound.protection.outlook.com [40.107.208.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B8B2417D1;
	Wed,  1 Jul 2026 19:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782932544; cv=fail; b=sgmnu0audiIxQtyc3kdjWgyhmGa5bvSmH4YBXkEzBQx45VaTdwI948SVupdmt1s/VbQGykFRL6WT8ZHlkoLirWqXCQpyj2p3uwP46pvh40d2aRQN2iRxVYcA8ScutGgx/YwIoBRQ3rdTZ3E4HRMOVnrhyv5uNbHSfJXeBroYzpo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782932544; c=relaxed/simple;
	bh=bkNovMIFo7ggMxK15D7bVmI+V+a+eX3n1WadFs6dy5s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dbH9FhxLBgPpuqWLeCFzmnR43yB0p4jVYRESEAlInu8QlQvShcZURCE+whtmEQjtVjX93MqOoh0Yam+pTYgiI0E950B44WVjs+O8gc9BjuRnVq/nn4oPB3JfoVZUGQLURGnTgYkZr0UznIqtXaU4qOixFTxCrDpiJ+YccK9nfYE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P4U57qCY; arc=fail smtp.client-ip=40.107.208.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P4U57qCY"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uf2y8twOQvZCDyOGbbjSLuRphLwFpRMnIV5EMMgxSmXd9tC9JX118V5UumCUuuU8BsYrbdz3eaw3qZURwyrpchl3D5QDGfnEIw3lWVbxV64Vqln1PdM1QQ6gzxv3yh9tVNDVAd/oyJWT1X/wj5fWUdtRS1zyr0TpmaorqiE+Tgjmjy5yA2M9W1gvgWD9s1K5ha4HA/ysm/1M2XCm7Yu1ETzrsvvKdU7XLkjbORD9K0VNS+elHSGwy79wgYXUUb/RVOz2qLKMyS8Lm66N+7yRg68PkZ9NG4quOocCoFB8bDynAt9CYUWpAPJFSKD21wRZjZzj51I3p2S0i8tyU0SlBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KMgbkc71Q6M+bmdfUHJjGIFuUoC5xO0riVDhaO9Wmg=;
 b=GUg7UtMdt8FmhC3vVH7gW09n4zKQSQfTVgo/5g+tAKysy3eJMN/9k+XHmrmjrRxgm7XT2WmrPzrVcpefGX4BJzNazjsj+IMI/q2BcbJGQJm5Ckrw4cqA+ECIOShpCjR56DHgo90TNQB9SGBPiJykOUNaTddaf8JRe5eMHCjBpaAX1fZG8qWtT+TMUbYFdphzPGhaiBAwyWDQnJaEWSxtw8pXns6zv6TkWlyDvb59Heqc1UzPHCXUqzJ9YM9iV7N1kaFfk1SjzoLYAGOuoY7kdRODjsWHeDxrQP32X2UzRXg/0sUZpH20ph3YO73tuGUg1FmZyk5pXRjZAekqwHb3JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KMgbkc71Q6M+bmdfUHJjGIFuUoC5xO0riVDhaO9Wmg=;
 b=P4U57qCYPapIf1/NefTEdHffb5/n2H8yJOMyYJNebbB+pQmtPeP1EVDyeyjLQN4EAeDbcZ2JrTieq38oUtyFktbUJChriB1PJ+fMgPcJHvBm4VAmwLpu760Lou49AzmM9Wngc1lZ0ot4xJlkNoM2A9xD1UI7ylgi7IbA6VATXdYKZgwB29ut7pW0UpHeXfezb9m+YGBZy7RC9BuUVshZ+XfBPwGNvp0OUvfEalG4XTINxlVc6eYFbzKNZ/QyTVpIl3QV11Oczz+G3qZoALRK1igO7IDUMz8jhdQ+U8G9Pwq89KdfxPJZViGQ1xJ4d7k4Lv5OVJmRxh7zUrN8op/Ueg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB7086.namprd12.prod.outlook.com (2603:10b6:303:238::20)
 by SAWPR12MB999115.namprd12.prod.outlook.com (2603:10b6:806:4e3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Wed, 1 Jul 2026
 19:02:19 +0000
Received: from MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e]) by MW6PR12MB7086.namprd12.prod.outlook.com
 ([fe80::4eb8:7fcb:fe8d:e95e%6]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 19:02:19 +0000
Message-ID: <dc2b9fc8-9f5c-4767-916b-a27665c8647b@nvidia.com>
Date: Wed, 1 Jul 2026 22:02:13 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: HWS, fix matcher leak on resize target
 setup failure
To: Paolo Abeni <pabeni@redhat.com>, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leon@kernel.org
Cc: andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, kliteyn@nvidia.com, vdogaru@nvidia.com, horms@kernel.org,
 kees@kernel.org, stable@vger.kernel.org, netdev@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
 jianhao.xu@seu.edu.cn, zilin@seu.edu.cn, Dawei Feng <dawei.feng@seu.edu.cn>
References: <20260629064049.3852759-1-dawei.feng@seu.edu.cn>
 <8138f145-6a4d-465e-a45c-b8ffbf9e05bc@redhat.com>
Content-Language: en-US
From: Tariq Toukan <tariqt@nvidia.com>
In-Reply-To: <8138f145-6a4d-465e-a45c-b8ffbf9e05bc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0200.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e5::9) To MW6PR12MB7086.namprd12.prod.outlook.com
 (2603:10b6:303:238::20)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB7086:EE_|SAWPR12MB999115:EE_
X-MS-Office365-Filtering-Correlation-Id: beaea064-f1a8-49eb-c20f-08ded7a34605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|5023799004|4143699003|11063799006|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	8Yn5JoRgY+u/I0e8uYAmtIiLMhT6JaPhmvLWLXEo2qewfwvLQPSRwgFGLt+2LOZcIvHV99GX6+H4lQ3Cl4LW5sDLMAFs9SxWIVixB/nQKmGoG4uHEmO+nnuZJJoznxefXxLlOOL2x+vfB+iZcJPHBHfErVx18prBhqf00nIiaJwZ/lV04pLbZ0CA+yOWoV16KOkRAZdPyXgNhPTjJZ2xDAi4SIx7Lr6TlKyGDaLxeM+xTX1datZ+UME+fQLFY/d+hNy1Zk30ViuMJckiv0Xw5t9vjztd0tp/qd1md2CroPA0a4t4yvIatpZZgz06uD17Tp5Xe7nttmkGmDD0QxcF7A+be9OqE/cCoMY2PMbtQqUEqDL41RSu4Sksz7OEIjL1m7o8oopFyddAKvQgcfv9itmQl9CA/o8qW66xNM0V6knYswrsX33SxqQjUlHiD9ZZbcmE6sVFYI9FnbGwvzq2CCxWnBiscYmW3BPIbAdWAk+u7NE0GnTuOMuw2YdvLM4ppf7Ik9/eKuzBGYyTe1nmOZhD31h2mgb4NAvBmV6ByNYdlq7iMfySvr7GFl9er24UwlOaO2cx++e3oe/vxbE/DrwxlR4Uio59Nib2CqiVpp/rVaW6DItj4FyWT1lrGYdNlZgQbvx/TsX95yCnaCnCurnkXmqSy9ifzlWFqAXigHk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB7086.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(5023799004)(4143699003)(11063799006)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cld5MlFBajZMY09mY3VpYVc0Z3hrL1ZLSDR1MU9OVVJRUUZNaW1ubVlGVFFN?=
 =?utf-8?B?b24rRjRVL0dBQWo2TFZxWlBnWWl5akxWNk92UjZ0N0hzMGxpSCtHam5LVnVN?=
 =?utf-8?B?bkNCSHhhMG91ZnRJWmxLNVZWVGlYUFNMT012V3pUSmlXNGpBYTZSVWZoNXFR?=
 =?utf-8?B?MURtYjlXSEtFcFFXV2RBcVgySzZQWHNBbFRxUE1Nb0RYbldhN2M5cGh6UUlZ?=
 =?utf-8?B?S1JZdHQ0bHN2UThMZDJIdG44UG9MUUhnRDNIbEtsbHJUNWREWU90ejZHRGk1?=
 =?utf-8?B?djFjK1lsZzcxSklwN2wraTdZUkowOHpNSHQ1MFpsMzAxMXQ5aDdBWTExaEVr?=
 =?utf-8?B?S1haWndWeS9sV2MzK3NBdmhrRU9wRVZ1bGxIOHZ0dTFFa0haSXhrNUdVVGlG?=
 =?utf-8?B?aitleWp4UFBmdUFyak5GV3pQRWJMMm9OcnBtMmpuN0VNR2pjS0QzUkV4S21D?=
 =?utf-8?B?V0pmQWdyM1RpTTZPVm00Qzk4TGJERjhGYTZuQWhSOEZUejJ6UUQwd0l4eGxz?=
 =?utf-8?B?UVBET1lYL2syeVhGOFl3dS9CNnR5NnAxQWFWaWZIYVdIbzg3VnY3eDFXZ091?=
 =?utf-8?B?bHFva2M5ZU5zVHp4MFdweklNTGVlemJTTVAySkdyMnpVeEZIOW1HZnhub3FL?=
 =?utf-8?B?MmhET25CQ05aakRKSDZjRFNSSGgwcll0RGJLMWhJU0hYRTlhd281YlFIc3Nw?=
 =?utf-8?B?cm9lZVVteEY0WlNJMWVHYWNuOTBpczFPZlNSRFhTWlFxNTMwQ2JUT1FNQkhi?=
 =?utf-8?B?cnRMOVMwRlFHMmFWdHczM1VDdVpGdFRHZVJqVDloTWJZTldlZk8yMFpzL2tY?=
 =?utf-8?B?OEVrZFZlQ3EyMzRtak5UWmk0d1VzM0ZtbUVoVEJiaEJsSFNIUzloQUZDYUd1?=
 =?utf-8?B?RFM2eEZjTHNidHhQUE0yWDNoQlFoeitCaE9IUTBIdzcwaG9KZHhPZmZYTU5k?=
 =?utf-8?B?cDV6VXBqRnJrdUpubTlJZGR2UzA5WTdTS2pvdC8vdDNpVkcxTjB6ZkVkUFN0?=
 =?utf-8?B?TmN5Yndnc0RUVUtndlMzV3pubnVHOFFyQmlIQ0tZY1RYZC8weEcvUG1BZzYy?=
 =?utf-8?B?dzBoWmNDNjdsaVVYVUFmR0Nha2k5QnVZRHEvMmFScVZDOVhaSmhMeFlRS0Ew?=
 =?utf-8?B?c2djUTBCekFrZEZ2OEVwQ1VCb0o5bmFHUWZxZlRCZDFpS2hVY3JCRW5wVFhi?=
 =?utf-8?B?YUZ1cFRGMDhqcG14ZC8yc1FZdGVhYjUzNGNjY3pNOHhKQktlY3lrN013SWsx?=
 =?utf-8?B?RWF6cG9BL0dmNG1mZm9pMDFzRXNwNFBhUmxMdTZRVEhLNzZFVTJ6L3Fja21m?=
 =?utf-8?B?T1QwWjJKemJ0U2kzckdaN2dnSExqd29HYnh5aU8vTlVtV2NiaEhwQ2d0ZlVh?=
 =?utf-8?B?eU5taURsWC8rRzVrblpoempzQ3N4a0huR081WnhHakd2V2dlZ290NEErY1pp?=
 =?utf-8?B?cnNDZGptbWFDbTNBKzBWKzJ4enl0ejUySFRQSkhueVlVZkl4ZjlDVHNYdVM0?=
 =?utf-8?B?R3NRZ0hZYzRFZ1dUMHVxNERJeXluZEI5WE1DQUc2NHNaU1NMNWpBK0JXZjlv?=
 =?utf-8?B?WTdTTEVidkxSemJKZno3YTJ2SDlpRWZjaVpscXJIb2cwaUNlRkFxcXNQTlRU?=
 =?utf-8?B?dzA2dG81VHA1YkNCeEVXU1EvKzdxQ2tQdmsvekc3YWVKZWtFM2FsRCtFZWk5?=
 =?utf-8?B?WFdpK3BUTVl6Uk1rQzBHeEp6RE5lTUNETEtXVDV0VjVUQnpuaWdoN2J1Q3A5?=
 =?utf-8?B?SitZVkFLL0FuNGZaU2RJSzd4QVZHQSttSVV2aURnbEUvVWVWSUpoZVFkd1ZX?=
 =?utf-8?B?OEVXUzdWVnpUd2E5R0VhUTFXMXEyczg5U29ZczBCQWxKaGNpTWl6b1llOTVT?=
 =?utf-8?B?L2FnSms1MEdxenkzUFI2NFRib0xXY0pMZWJkTGNjZlVFcENIOGdWYVZNMEtC?=
 =?utf-8?B?bmhKeVBJM0JVVFNhWkhkMkR3S0ZtYnBhWGpVR2drcktKSytzVHJ5VFhQSkNL?=
 =?utf-8?B?cUc2elBmSWRENGhla0o0bVR3YmxjV3lGc2xvTElNVVVPUS9KVWNmMUxWRE5M?=
 =?utf-8?B?UUM5eXNENWZGdmxiRFRWSEZmZjBuelcyWWQ3WVlUbmVKWTFPV3ZqZWE1UWUx?=
 =?utf-8?B?aWdxQVZHVkNxcWZtSFM0cHdlK0xLNEM4OERWZlNqcG0wME9CQ0FtdVBkbWhF?=
 =?utf-8?B?S1FvYmIyZTFmTU15aVN4NVYzcHVoMmUvOUJqejJqWmE2bTVMYnJNQXBOMStL?=
 =?utf-8?B?cU1YdmdZQzdBUEFSOHJGY09iVE9MTkZhM1ZQUWFEL1cvcUNNYW9YVTBSTkcx?=
 =?utf-8?B?V1RSZ2s4NU8rUDQwaUt5Um9IY2hlQitLbmRqU0xLbXZNUmFtNWV4UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beaea064-f1a8-49eb-c20f-08ded7a34605
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB7086.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 19:02:19.0129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wKrP5d7JhfIo4HgXOw2cC6Ria9AXU3wGEeorVqjtMLBVGvlduHoyE7LWbfkscx/haZVwNvZ0JrJi6ekqhJE/hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR12MB999115



On 01/07/2026 17:38, Paolo Abeni wrote:
> On 6/29/26 8:40 AM, Dawei Feng wrote:
>> hws_bwc_matcher_move() allocates a replacement matcher before setting it
>> as the resize target. If mlx5hws_matcher_resize_set_target() fails, the
>> replacement matcher is not attached anywhere and is leaked.
>>
>> Fix the leak by destroying the replacement matcher before returning from
>> the resize-target failure path.
>>
>> The bug was first flagged by an experimental analysis tool we are
>> developing for kernel memory-management bugs while analyzing
>> v6.13-rc1. The tool is still under development and is not yet publicly
>> available. Manual inspection confirms that the bug is still
>> present in v7.1.1.
>>
>> An x86_64 allyesconfig build showed no new warnings. As we do not have a
>> mlx5 HWS-capable device to test with, no runtime testing was able to be
>> performed.
>>
>> Fixes: 2111bb970c78 ("net/mlx5: HWS, added backward-compatible API handling")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
> 
> @nvidia team, double checking I did not miss any relevant communication.
> The last process update I recall is that one of the people listed in
> maintainer file will ack patches for us to merge directly into the
> net/net-next trees.
> 

Ack.

> Should we consider any ack from @nvidia sufficient to take over?
> 
> Thanks,
> 
> Paolo
> 
> 

Acked-by: Tariq Toukan <tariqt@nvidia.com>

