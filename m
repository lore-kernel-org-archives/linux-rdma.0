Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC1A3CC9E9;
	Fri,  7 Aug 2026 22:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786143539; cv=fail; b=mz+yQjcaA77RN3yjP4H8sG9abWYlNpBDofg99LNgWf0kpmByIaFiSb5naU495xRwP/YHLj8yL+asIJtNpMC7ufb5Vqoc5xexNepbFklSBQqRtcuV3XNXlWjXreU2spstCox58unWKMem2Wnzjl8mrrLZvYu4jVb5IL/doAZAKjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786143539; c=relaxed/simple;
	bh=leOybZhzLBmMapV+NE9zDkeSQ1uIsx8aSbUHVHZMre8=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=OUmwkFd+D2gO3j8IhFVnN1ef71nei1+j2PKQOIaDkTuIikBK83pNjU03u6xDJq+PzmSPVTn5wZpQ0Lbbher+szh4Rqk23x/iKPFn6MBRLcxm+zprCkzmZ9ajCfSW6U9EnQh5BoJQTGxrsbaT5Yt2bRA9l3u7Fe/tURnbmGrtchc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tA8++noj; arc=fail smtp.client-ip=52.101.43.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tA8++noj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AIFt81BTlQcpQuo4j2aH/XbiuAA7H8RXC8ofMibOG0dTTNMUdyRdxwuLqRmTVyvPZWiAKed7yI0TiYF8RDzE4zRo0Ita1DX77uUUXqpPYV9SylYKgRo66knHeHZfVqauzCl5q9IhAlBT5rSnewiBGpf9NEiDE+W262AG6ZdEUAHsDmTtRIYD+lgGsw0+rjeiarFEXCrsGsrfxNai+/wA+y4DGFcs0r/ichlONviYjy1qDpD/PRiZg21SJHqAQggXuONivstP688sleam/nWmSjsPzew0Ak1xC/H7naVS/ZrEbPrM2WEZuNBBdpnzMINS3nIH88Aa6/34SZKBIt83Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yI36uAv4J+Q7gDgitqsHe/ctRlfTFFFxaHCodPO1A9k=;
 b=YiT+zAa7EJkaJnZS/MRyD/JRl/9dMkpO6H621KmfkZcDOMSrQ8PyYR0MZIVBRSA1l8p9roAWE9GzhiQL/54J8oCew9z49STpqWZERTJyUZ9IliVrq3hVoj3NQd1zG52QrdFNR4geO5aFkBB0g0R3hrfm5oqFb48JewDP1O4CR67/oVLbephZdXcb8QiULA5AQ5foO+N4qLX6E1AXOkFINBC1A74d5EaWgZxAdsPk9Uu1Qe5EGU9CZNhJixGiHuyzFGqt7DfsvuKhUntqsC6+dV602bDlRyOzIWNXWAr/F3Gyy1O/VyNltRDF6NvMnlx6lCvbv/nlGGp+qL2VUiTv4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yI36uAv4J+Q7gDgitqsHe/ctRlfTFFFxaHCodPO1A9k=;
 b=tA8++nojEzslmHwEh7VmbpXyK7r9e8ttXUtFEc2/x412buXVC5kk7u3Bm5S2V4cQyq8QLJwCpy0vzMwEYXaZe47ltlgQllmUX61AdxqX0UcX5HgvH7LS+9SgNBDquLa1nWfxrMNi1PitvseXdf3Er1NAjUZZS2rCO4kOlixpiYmH6bMq37D5hx8L/jCpsuhukGzv0kzMjkLb504baq9wGz2PgXrLemOEzL+jjO7BFzTr+JvWh10S5yxwknAwAxQ+gtRmMRz2pMdn9cjcFdKU4p5UeBVopkISwF2y0padgjKEOvC2ZUQOITse67g9TdcxKCNM0nwLcgn4KSj79oyVqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9420.namprd12.prod.outlook.com (2603:10b6:408:200::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 22:58:54 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0292.022; Fri, 7 Aug 2026
 22:58:54 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [for-next v5 0/2] Add Reorder Completion Queue (RCQ) support
From: Jason Gunthorpe <jgg@nvidia.com>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, leon@kernel.org, brett.creeley@amd.com, 
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com, 
 kuba@kernel.org, pabeni@redhat.com, allen.hubbe@amd.com, 
 nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
References: <20260728111323.2559185-1-abhijit.gangurde@amd.com>
Date: Fri, 07 Aug 2026 19:58:43 -0300
Message-Id: <178614352363.282103.2807701138755369244.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: YT4PR01CA0106.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV8PR12MB9420:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a5c1f6-dc94-4788-d5e3-08def4d77442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|56012099006|11063799006|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	OpZNcMhu3ocJdH6t2+DflDvnSSEjJ26Pyw+yOd5MtEEaqKcO4iJ4AFAKvNCrBB1yx+/XyoxiPuXKAuc8HiWDbudsfWLxBzTgv06n65eVRHLt8FS0LrmaioIviSir56Q0BHYIEeYSsplQm5qIRNFpAx0tHhIRUkQSj1h7vVtHiZb+zxeo5GQqySL9D8UjfbKcWaPwX+TBHcM7wPQ03GIegW4eAsCm8S0gPjsMdjgo2MxudAzSNd0g4uzQzDAp+G+kcnZY31qHXVLRCaC4t5yo0m5zkg/sCpYuvAmC5AboCxqbgJvoDJb8jfJzq1ChPYxss0sbJOW9MuegmJxOZHFOV+Hl1v80zgay9BTmBDKqq1eFSYrI0hCvfwiJ/prlYA3IVWN7QarYUd/F9TPGnBi6XmpJ0EsLcRw0uFLmGGiI8CuAXyliIR/R5MqoXAe+TJSHLnPmJVmW6gv/EkW798bEVMy2ds9xBlul4AZAPphIjF6uOjp1oR4oRoTB7DI8NQmJ2zUhgM03ZhEhMI532eYjYhZvSrayw9jiDIfuoP5jfGRU+xNOdZEuTkPb3e0hTu71cKnB0BAv72yucQYgEmFSodXSdvH+4o+VZHWiW0KPacqeqBzIsW8Vc36vE6Ol4K9N9Z67XHkD8rJXd2H5cpgMdaw+U3vS/vAQWu4GzWdEt+c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(11063799006)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UXZOOEllaG5TYjJCVkxzYkFHWWFzMXlLK2hLeUR4VHZ2K1RRak42b3hyTlpv?=
 =?utf-8?B?T3Z4L0FrTXp0d2N2RTQ0WG9heHZRdFV2R2dPUExZNm1iR0c3MTNpZWdGcHJw?=
 =?utf-8?B?dkZpSGk3N3lKZ1h1RDg3Q0tPVTJuSDZaMlE0ZlVYVzc5aGJzN0Y1YXZoMXk5?=
 =?utf-8?B?bUVVRXFvOTluSThUbkNkMjYyZlltV3kyODBrYWt5MGpjSE55dmZrZ3NUaUVW?=
 =?utf-8?B?eU5kVm84enl6MlUzSUhRZkJkQ2FOdnc5UlBuenNTQVZZczhUbVF0SEYweVdk?=
 =?utf-8?B?NlpyL3FCNlUzR1JWbnc0OEVEVzlsY3hlRnlrTUlNR0tiY3lJUHlWeSt5R2Jn?=
 =?utf-8?B?akZZaG9KMjZKMlkvNU9rNVE2Q252TlBvSmE2YzgzVUd3ZURINEVWcGdsZ0Zy?=
 =?utf-8?B?TU0vTTB0ZmZmN3RzWUN6ZmxDSzVWZGhYVW9aR3F6U2VDTlNhdURmWGpLcjBU?=
 =?utf-8?B?bG8yZGVYWTYzMkNOV3l1c1NIV2QyMXljcnN6c3RuN2ZZK0pnS25TbnBtcjlB?=
 =?utf-8?B?WVFZU0JqeDJyTC9QL0hIQmxhSUVjakxrWG15M0xUSlN5aVUzbWJRMTU1Mi9G?=
 =?utf-8?B?OHZvalZ1NFJ4a1dTR0s1T0syUHcxNHlFOEZJRDlGNUtiL09EQm1tLzBzdmQx?=
 =?utf-8?B?aXorU2hudU5pTXU0Qm1wUmw4UXVZNVVTbE9KVS9FZjNlR3lqaWE0V1pjZWN4?=
 =?utf-8?B?eVJJR1NYZHhvVnFjL2x5N0xhaGh0WE8yUGp5VC9aei9TOFRVVjk0aWZIcmRH?=
 =?utf-8?B?dG1MRzlIM0dIbk5ISmJ4ZnEwZWNFRS9pRElQNDNvTjJrZzZ0SmRwZWRUOTVr?=
 =?utf-8?B?MjlhalUrT01ZQy83dVc4RVVESmQrRXhjSXIvVGg2NVQ3aElic1ZzQWlCS09t?=
 =?utf-8?B?SkRMeEw0cm50eDB4SThFajc4Q2pqRFpkeWlOOEhzUGJDM2dHRkxzTTFtcXFE?=
 =?utf-8?B?c3dZQi9TaW9NRThXazdhRUszMU80S3NjL29LN2RJalc1eFIyeTVQOXo2aHZB?=
 =?utf-8?B?dzd5UThyWjNLalA2bGRFRUo4ZnRxWklNaFNQMFNpWmtBU09JbkJSdVlBZnBK?=
 =?utf-8?B?ZzNvdWZZZXFndll4ZXU2OHFheWErQjBpeUFXSVdTcE9HbGNlUkxKSElpeXh0?=
 =?utf-8?B?TDM3UFpPY2k3MEJlZEtqN04vdXRackRnY3dpSmNrRldGY0dxM3g1OUx0RWZH?=
 =?utf-8?B?cDk3MWk2bkpjeXBOckpqSEpkdHpySWJOSitreElkN0trMTFxTnlMRElXUjdi?=
 =?utf-8?B?NFN3KzduNVJiU2F5aFNQbkFMSXN2ZTZNQ2dRZHpFVzZxSnVlT04zRWVmWlEw?=
 =?utf-8?B?di81aTVaaFB0NTBMRTVxa2pTNnhreXd1V3hpZFAzblJSTnNUeGNhQUFaVHVJ?=
 =?utf-8?B?djg3amFKbFI3QW9IZFFhNlAvZk1PT0VueVFZemdaVnhZSnhEcnlJQWxCN1Rw?=
 =?utf-8?B?bU9mM3dicUI5c0k3VnNJWmo4TlZMODhObHNaWHRjY3VmQ01YTDRYVElQbll0?=
 =?utf-8?B?ZGJCM1R0Vnl0UUtjd2lQNlkxMU9VOHh1eDdNN1JiUWNQNlRmcVBaZ2ZWdzIw?=
 =?utf-8?B?c2YyVGJ5M2trMzF6bi9yaFo1NDZZZjNySWFCVnNhcFliQ3FWNUVYdklTQSs1?=
 =?utf-8?B?TUhLRjdjYTZYNyt0MXQ2T2taRFlWTjYwdjQ3SitpU1hZZWt2OGRhd0tqSzdP?=
 =?utf-8?B?ck91UWROZmloMHZFSkJvN0d6U1BrRDFmVnE2eGpuaXpRUGVYdkdLZ0tDVWV2?=
 =?utf-8?B?WitUWXdGcWIzU0tKcE41L0RZRFMzUHRQU20yNWtuenJSaXU4cDJYQnJMNW0w?=
 =?utf-8?B?YXVIOHJ5NHFhMHJNMzBTYTZUcmZ3VVUxSGtQZnoxN2toaDl4emNnSGJ3WGM2?=
 =?utf-8?B?ZkZ4cEh5bzJwVEtXa05DcEYzWW9kRWliYit5UEpGbnAzczBoT25wVCt0Tjhn?=
 =?utf-8?B?aGlweG44ODVsQTZvWURyc0hIWEhTSllHaU5kMVBuNVdIc1NKOUdRcE1FWHVW?=
 =?utf-8?B?VGkxbitvZnlaeEl3U3lzMjlXUCtvZXhydjBVb0M4VzRuR0VMTkpkOG5yVGQ4?=
 =?utf-8?B?d3NIV0FNTXExR3RBeFZSTzVtdnFsM1RrM25xdGtHWExxOTZaMGptdUJZOWtR?=
 =?utf-8?B?UDNQVDZRMWVNSGR1WWdaYllxZWZodUlPa1pHcXgrQ0VFQktTNG1CeFF6YmJ3?=
 =?utf-8?B?WVZ3OXAySWFPSHFLblMxcE5SMENjT2xNVWxMWkh1TUVHbldhRGFmdk1GU1h4?=
 =?utf-8?B?Njd6eElzS0w0RHpFZlNCVk90WHpnbXNrKzFaRVJ1ZXRrdytjeWtYcmlxNERO?=
 =?utf-8?Q?eoXNiiugxSmL7BrhXa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a5c1f6-dc94-4788-d5e3-08def4d77442
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 22:58:54.2911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TG3WJFbgL3ScJNqys385nxZ+gsd2A94ac4gngjvkiIvtHBoU2uDlhGM6vIM7E8S4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9420

On Tue, 28 Jul 2026 16:43:21 +0530, Abhijit Gangurde <abhijit.gangurde@amd.com> wrote:
> Add Reorder Completion Queue (RCQ) support
> 
> This series adds userspace support for the Reorder Completion Queue (RCQ)
> feature in the ionic RDMA driver.
> 
> Patch 1 extends the net/ionic firmware identity structure to expose the
> rcq_sign_bit field from the RDMA LIF identity.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
