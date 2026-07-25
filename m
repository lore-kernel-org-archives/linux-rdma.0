Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011025.outbound.protection.outlook.com [52.101.57.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC224908D7;
	Sat, 25 Jul 2026 06:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784962307; cv=fail; b=TjzbcLsehr+cRs76eMBL6r5cib0S2VnPJ5tFeSkCMCM3ns0+VjMZKggLjLXbssCd1hMrvDz/mFZl3uiFuYDbDuKi52+jqwOXf9S3l7SbqyRVcwkdqK+aWGtRAy0b4lgcP8EbiEY07LaB3qyMNxmrxmF6zRzoFKitoM5oQNv5N/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784962307; c=relaxed/simple;
	bh=bZRA/tqSmhbBtqyYv/w70bJDPtCB94qkVBDZM9gqmVY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kdE5CUvBI5uL694plgc+VErlv+VU9r6GpNHPrqOLWSx77DuqIiMaeCNh1+DAQVqt5BZoPCnMIoPcBsmQSk0gO5HgAzFt2YSrP9JJDvZHFs2sUV2PG2q+vYWD2H6geSmLufxMADyV+6DiOAJAUNz8m4JYIHi14sTt6D9ngcILltQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=azeSSl0I; arc=fail smtp.client-ip=52.101.57.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="azeSSl0I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7+HLMgJW2XQAahcMwZNqLIljx/YPRWhog8Caq2IDXqo+S00nDdg5rwLJCtsSJlfzZ/2qfYLAbJVRy9e7fjydFnZydfLi0WJT/jh0vk5b1BWDGyvIYBbLELUB6tzb5Q1Q99UJpdV5pViOZfNC/VXk+MoYeZDYJ0oPPtjcvqRvlrEpARY00N+ohABdbM/pQ+kseLhF9hkdfLqkcNpwQhkVsyXj1rKU6Ympau18uIcUjkPdF4P6RU2kqei7/bOuXSg2Dhx9VwFqbEnGz11eihx+HLwhkA79n5JQrjwKDX9HLE/FDT0NeB3o5CqAyUGvG5By+okmkVrlXtMQAz0wbcwCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjK6b+In8wvf2vmGf7ZqSUXsbbvHITSL4WDd4B++Erk=;
 b=QD9r4jdJSsSgcvyVA/nKsc3Yoh1rpovZBhApLppOrviofW7aKrSdYM/zFbu8g+JEE+UeRmd1x0/hMmdYiqBBNGNJwKocQNQQcG7gguL07sEYbJbPebHLhyYjZnszjQp2l3jL7N0dQxfmpmOtQQW1kr0LbOEnfY5qjJ50b8XoZEXveuIPnReTBCBBBp7YG16xfUm2tyelVKViRaHm6JCk1pdOvCXXg220h5OrZ0g0sBdc5dINMKlgSYdFI0kv50oIUbDs1KTqUgxwszS9Q7ZFDnfyhUx9yU9BihNO8ewa3976flMz/Y97DI7NOMPI8i65dTRb06zLW6WVx57Ckugc8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjK6b+In8wvf2vmGf7ZqSUXsbbvHITSL4WDd4B++Erk=;
 b=azeSSl0Ix389c7k6924QKd0cDBybZWq1OoRO167+exIUsi3G5ZpakapsoxF+4kydvTsru37R5ASVZ12rB1Nd9YIEZa2kBf7KX2IDL4FJbpX9E3SB44kg6OebiFCK/N4HI4u0AlWIp7NqPkVgS88L2rJp7fe47J7vPMYKZMGv5XKELWDBoQYmCGZjlPnMeNN3NHa5H5PFIxbDfRxdFEWniG5YAESLTXPbudu700DGoMflcx+lu2qQ5qnjcymluLWmF9DNrQ5D8PUuLV9Lh9SPaQOCCezqCZFoINzF+fTTPpfIZjuUWcXAZUkWVTrHEG7UtzRlPxo6RKHqAPaA1isbQQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7548.namprd12.prod.outlook.com (2603:10b6:610:144::12)
 by PH0PR12MB8032.namprd12.prod.outlook.com (2603:10b6:510:26f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Sat, 25 Jul
 2026 06:51:41 +0000
Received: from CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de]) by CH3PR12MB7548.namprd12.prod.outlook.com
 ([fe80::b710:d6a1:ab16:76de%6]) with mapi id 15.21.0245.010; Sat, 25 Jul 2026
 06:51:41 +0000
Message-ID: <c6c0d67c-d832-49a1-b62a-57fa6ee56a47@nvidia.com>
Date: Sat, 25 Jul 2026 09:51:34 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next V7 4/4] devlink: Apply eswitch mode boot defaults
To: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-doc@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>
References: <20260716084852.549909-1-mbloch@nvidia.com>
 <20260716084852.549909-5-mbloch@nvidia.com>
 <20260724161111.2ac47089@kernel.org>
Content-Language: en-US
From: Mark Bloch <mbloch@nvidia.com>
In-Reply-To: <20260724161111.2ac47089@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0001.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::19) To CH3PR12MB7548.namprd12.prod.outlook.com
 (2603:10b6:610:144::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7548:EE_|PH0PR12MB8032:EE_
X-MS-Office365-Filtering-Correlation-Id: 06e5d490-ba41-4cc6-b41b-08deea192e6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FTvJJcFh4VT99qCYFdGNodgyLZfeMaecBR05ZGV+oDILNpZMOaM8LsZKLJGOBg81x3lKEf8yV6ktWMQJSShDwuJ88Q8r9Bz3/s3JVA/U57CQuRGQ4gvU09zQwINt+DWnz/z+EVSj88O8VFmS2f7F2n67QJ+TEPGTmbcKNK/reC+WBOXeV22rkgukkJaa0Z7Qsgn3wO7vE+gMe9QnxCrxaZspBITO7oVpfdK1eEPzEmVqLcjIc1Za95OBtzfeSs6JF/5XM/SJt1xPwSrJkBc8heOSY6trryyRs6O8kBM7C736fESN13w+kTPGoJn5NDQLVouvOo9nn2W3G8Q+WTIqAVpNGrsR1Y4/BomhlTEGkxn5nx2lDLZ5hkXvZgXzc/CaDXbumBEXMUOr9h+ClLWb5S9KZ+Ug7+XU5NsmmAHFH+LLT9bhqhnGED0aOHg+yFuSiR8/kJKaGzwiimjHGPgU9Q7ObzclIqZzm/wGnB7sQHYmo4Q9cPawZbrHK2y82lc+k81U2HhDpUOdCvA6ucyPmzpK6UorGRbZytaxXnFag+LLqSO7KqKwlRQDwZiOpcCO2aABHHH0MEBsvPgo8ZQ60OEh88CTlco88fwGS0gnSwftKluoDnGbHaKmUVhvUB+VU/psU5Besy2+Iau811YCS2rD7SsPk6I1P72CKcivz48=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7548.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TGFuTjYxaWlpYWl6S0NkMDhBOExoeUlWM1FOcHgwakgwbzkxSmx6cWVLNDdv?=
 =?utf-8?B?QzRFQlA0VGZMeXJicnBHMGVJc1ZLeFNTLzJNTEtHb3BUZE9SVkg1cVR0bDFQ?=
 =?utf-8?B?c0Y3YTFTNyt2YlJuNmN5Z00zcHNBQ21DakNmK3N6VFJPR2gvRFNGcGs1RzZC?=
 =?utf-8?B?Y3liQlhUVStxWnB6bkNnYnFwMlBEVlpqVnBZT1E5aE5BRmpTeVFRajA2WlFL?=
 =?utf-8?B?SjA1L2VtYUl1OVZYQ2NhVi9MUmM1SEoxeE5LSHk5T3NnM1plRG1PeUZVRjRV?=
 =?utf-8?B?bEYyS1l5dm9GYVR3dDBwa2t3QmVXNmdJZ3YwTkVOT0UwcnJHTFRremR0K0lD?=
 =?utf-8?B?UTdiS29YUDk4UEE1TXBRK21FcTNkaHB2cnNmcjlSOEVXS0VISXVXMS9lYjha?=
 =?utf-8?B?L0pqallxNXdIQjllQjB5YkFuV1VzWlBDaXc3VzdUTWpveGJZMzFqWDBOS1RY?=
 =?utf-8?B?RlRzQUpRVGZkeWFmbXNNWW9mb1NUZGJxWERRRGhRUUY0Tm1ERHVXN094NVhP?=
 =?utf-8?B?NjF6YXVBWHFSUDRLSTBHaE1vTFp4ZjUvQm9hUDBuT1JNY3lYR0xBTUxYSkRT?=
 =?utf-8?B?ck1TTFA1aElJZjZ1VmNhZmtpSFljSWpwWTJGZUxtbDYxb0JacS9pZ3ZkTWRG?=
 =?utf-8?B?VldKaVI1cDJXcFd0dEpBUFpoS3ZUdHdBdFBqTDFsTDB3UEJjSHFZMHJxS21T?=
 =?utf-8?B?R1FnZTBTcGFRdUhOcFlGU2wrL3BscExiRVVVdjNFRkllWlQvZm0wSU1ucXJW?=
 =?utf-8?B?bUJWd2tVUHl5blA3SkVQUkVWRjVrOW1qK2Q0azd1Z05xYSsxcEdYQTJHM2Rk?=
 =?utf-8?B?MDY2eHorSjNjR3lvaFdaZko1cWlZNXh5UHdxN0VManhaWTdHWWZVbm1ETi9T?=
 =?utf-8?B?NXdLUkNtaHRGTTRXS0xGdFdFQUcwTFZWdkhVNjU1dkFSd0VRV1E0ZkVtV0Nt?=
 =?utf-8?B?RjJOVEFlTXd6M0xEUlIzRnltc2ZMaE5mWFMzdnltS1ZRRUFvMkY3cjI0UFpx?=
 =?utf-8?B?eUkxaytDM3JTdElYTHJ5L1JuMG56b3NQY1VldVpRTlRJWTBPUDBvODZ1Z1dW?=
 =?utf-8?B?NzZ3YW9sUTRhRTV4RGIwb3VEeTZkTW5NWjVMMlE1TDlMMkhjdGUzZmZqcy9I?=
 =?utf-8?B?R0FCYjZrMzEyeDh6dXhCeDlpSVZXN3M5OWVaQ05BSk9WSGVHYnlZYlRSN3M3?=
 =?utf-8?B?SFFGS3duOTVyYTd6WXZIVUM0OE9RWDRWTjEzZTZGYmZCVGlsYXNJR0dJZ2tp?=
 =?utf-8?B?SzRYb2tSTUtCd0JaeVZHWi9SMkZ3YTlQOERqQ3VnYVJWT0xDWVlHN1hpVUIw?=
 =?utf-8?B?S2tPajdRYTNrVmwwUDBqdi9INGZFK3ovMitFdmszeXpxR2pRNGRzNzlHb1Zm?=
 =?utf-8?B?ajlpN284MEVBdG9DaXY1SHRBVStmbm04V3BPRVJrVjJoSkdGVXNwMU1vM1lQ?=
 =?utf-8?B?c3o0cW0zQmc5OWIzcmVLaERLWk5BVUx0NG9kNzU5WW52bUFpWnpvZlliSEdo?=
 =?utf-8?B?aEppLzNhdkY5OUtZdlFiaUNWZ0p6VEtzM0Y2VG1LVjhZNEQ0V1BvTEJWZ3Mv?=
 =?utf-8?B?blNpMzk3cGEvWkY3MUoxdGpsZjUvVWxpbVRVQ0RDbjhZNi9ITms4aGhYWmdx?=
 =?utf-8?B?RW5ORE9YV3BLNUJxNHZ2QXlzL3ZFYlFsZGdsdStmNnRBbXJpT1Q2dytTZ3pR?=
 =?utf-8?B?SFlMVG9Zc242Y1dnbWtRaW01ajhqNFI5MWk5TjNJR0pIUytkS1JYY09BcUxT?=
 =?utf-8?B?ckpSb3MrZEc0TWVsMDhrYmtORDJWOU41d3RMMXRCaWl1czVXS3VRT3ZWNFZp?=
 =?utf-8?B?TFVWRy9haE9JanpiWndHRjlPMlJOZDl2Rmt5eVd6K3BIdWJxNDZ4TGtOdS83?=
 =?utf-8?B?M1NISFN6Y0VCTzhCTzBQQStkVy9mVGpQdWlkUld1bjVSbVUvVDFTMHZHMWxx?=
 =?utf-8?B?cXY5THBNUm4rZ2R6ZlZBTHhOc0xkR2NVRjh3UmluUFVpeTBVMmtDYVdTK3lu?=
 =?utf-8?B?SDR2c0FBWXc5RlEyd3BkKzg2YWNOY0xGUlcwellOWVRjelNrc3grZForSGha?=
 =?utf-8?B?TC9tZU92WXR2MDl1eDk2K3BzK2lFRWl3VGpvUHRNZnBQNTIzUzk4ZHFJS2pK?=
 =?utf-8?B?K0dkcnVoclVod3Bsaks0bnkvN3crY2d6Y3QzdysrMWs0K3Y5K0lhNGZKQWh1?=
 =?utf-8?B?TklNRURROXg2bDZMcDk1WlBZd2hXKytsYTlvMGc5UTVuakgwMytTdERHbE5X?=
 =?utf-8?B?am11b09jNncraFhTOVMwYytwS1gwMDRyM0hvaXNNVjI3eTgzeTJnTzhxcUV3?=
 =?utf-8?B?SStSUkxvNkZqQ0o0RkhjTmsvZkdOazdEQmM1NWwwYzgrWlRUbG42UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06e5d490-ba41-4cc6-b41b-08deea192e6f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7548.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 06:51:40.9823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: otE6iidKTI0eV4qD7+PWna9gMNhLw1nlQV7tykk0VDUv9v5wBM6vahhZUQM/NHfKZyKOiBqkt4vQB6PX+ffTkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8032



On 25/07/2026 2:11, Jakub Kicinski wrote:
> On Thu, 16 Jul 2026 11:48:52 +0300 Mark Bloch wrote:
>>  void devl_unlock(struct devlink *devlink)
>>  {
>> +	devlink_default_eswitch_mode_apply_pending(devlink);
>>  	mutex_unlock(&devlink->lock);
>>  }
> 
> Nack, please don't insert such hacks into core helpers :|
> I thought we discussed this.

Yeah, we did.

AFAIU what we agreed on was to queue the fallback work from
devl_register(), and have a driver API for drivers which know
the exact point at which the device is ready.

That's what v4 implemented. Jiri objected to that design. v5
moved the queueing to devl_unlock(), and the following discussion
ended with both the work and the driver API being dropped. That
left the direct call from devl_unlock() which you're objecting to 
now.

So I think you and Jiri have different views on the basic design
here. It's hard to respin the series when addressing one review
takes it back to something the other reviewer objected to.

How about I drop the driver API from this series and submit it as
a follow-up? This series would only have the generic workqueue
fallback.

But where should the work be queued? 
- devl_register()
- devl_unlock()?

Can we settle that before I post the next version, so we don't go
in circles again?
