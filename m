Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7AD647A0B8;
	Tue, 11 Aug 2026 19:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786476740; cv=fail; b=THbvrtyDCsMpVdgh3hE3TVFDBNhJJ1jc3LgQoDsSoa68MvaZQndfAwn4TsmPEzud4B6E6xuhvUiZXWqYwgFXAhCvJULjoeIMuw/5LkgUvyoMQOCkbBjdUNQBXKahDBXUozOKXs81HVFsTVsvUyMB1pRPBP/APL2Pm1+BcM0oCc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786476740; c=relaxed/simple;
	bh=N62UmzDQam54oz+LGG/dbOkcJ6peBefrmdeTnOxl+7I=;
	h=Content-Type:Subject:From:To:Cc:In-Reply-To:References:Date:
	 Message-Id:MIME-Version; b=g8y7TqYv0i1+YDph/v8a+r9YQ2lScMO8HZNHwq7vmHdo/OwytaMFG6gw2I1tq1aiR+roK5pLxBPvnckDP1VIL2D/mIKDItdz5T6iuhv/+zetBQNmkSgL4E2nfXewwvvvMhLopYv+zLT5ktpvuFhdXAMEC7hT7rklkvFIcQ4Jn7Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PvV14vkb; arc=fail smtp.client-ip=40.93.194.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PvV14vkb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MPwCNIkgwbo0vMgaJK8ineFRK4d0hgxSjzSB8vhmMKE7rfE7EvNvx8v9BrD2Fxy52sNG5hUIYfqgFDXlcK+t2iRr509dB5+cdm6G38NHwisOqkzrKYaGXcFU8YYYi8cDvGo9z9EZsj85hDkjEBKKKkiAt9n2HBjoh10ZFzn3kifWPkqJWM98/NSeZ+GpugR7yCMwkI1zeJzNV6TsrUJxVyfa0n1X0SW2bvG5SVlrxl5DSvQgjMxIXiZE4c941zUPRcmL+vtrbW5DULOe5aA0ZbHm2QpEhEZs3+FUq7lRMyTsYs6KrHbPTrFfr1ZZD4E6X0TC+uRcyIrXGi8NDXHm1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNvsSn+p6xV/+Tui6SiTk+JV2U7azzhMvuERgejfsZw=;
 b=guB86cuBiNeEq3ale+l0pWzINkRTftoJyj0v2x+3Mg7eibYkp8ttTb+NflySZtvwDV6h07Rx4ZDqdxTjnZpdtIUVFQeenrb5OGJY9+fhl0nbrGjJtsiKxVqiZ0u7l1NJ7cGr6zdY+VAYOja4MREOUudxHnL86/4i0wIsWpegY6GqUsp7/F+s16WuGLKCcJdbF42/PUU8dh/pJLz+0v0l8ZXKHD4y22BRvs1niEyynx2Ros8XDgNARxEgoSekR4g5LU47C+ku/x0Zbbw540mhkAHLnL4mgcWdwTy6e0W7P0VotUlaDRffI4M3nFsRaIAH/hzJru+v0UnMxMwYb8CL5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNvsSn+p6xV/+Tui6SiTk+JV2U7azzhMvuERgejfsZw=;
 b=PvV14vkbWc6IipNvj1n59YsRORz0JjISg3HUITddgsElO7+Md0uArCzzqmXh5+OSslXfpcGrkpWSL0EVGpzFLqWvnGPmisNKnNxnnPMg5ArIlXMuvZbPPc7eG2dlDxiTp6EBjql0cGxRqVZCznW57JYIR6VfE4ZT6FmcghA4tcYIiTJJbffjmNs0Y491HM9NcKe5ouE9MVRSeposD0aFhe1yF6HINK3PPg6BMc5jFh5UotWmxEuo4PUKXjybsxuAg4KFFPdDc/8eHZFKm8l6v7y0UYv6a9+KlzyaMMLJi+u44Kzu447qdiDv5O8Nq9W13VrDGBC6ihdJMcl4VJhZOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7238.namprd12.prod.outlook.com (2603:10b6:303:229::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:31:51 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:31:51 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH rdma-next 09/15] vfio/mlx5: Enable relaxed ordering on
 the live migration data mkey
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Gur <michaelgur@nvidia.com>
Cc: jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
 netdev@vger.kernel.org, Edward Srouji <edwards@nvidia.com>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260726092943.2880176-10-michaelgur@nvidia.com>
References: <20260726092943.2880176-1-michaelgur@nvidia.com>
 <20260726092943.2880176-10-michaelgur@nvidia.com>
Date: Tue, 11 Aug 2026 16:31:35 -0300
Message-Id: <178647669515.282103.2847201847360648277.b4-review@b4>
X-Mailer: b4 0.17-dev
X-ClientProxiedBy: CH2PR18CA0049.namprd18.prod.outlook.com
 (2603:10b6:610:55::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7238:EE_
X-MS-Office365-Filtering-Correlation-Id: 81790960-87e5-4999-2eae-08def7df2f07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|11063799006|56012099006|10067099003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZbfBHVm4YOuvdBTgnAIljA1f1OXxKeUjRmaVnshLG1Plljfq2T6UMFX4nVDd3RvxUtq4tsDxAf7XWP9HMlH6IT+UoQI8eAixQ8nOVOloJf1uQqh6rQcFQiw0zy9FkT0j4i7+mCnxicxOESLuFkAtKxQSAk1wjOvYJbsAKsW1fwR7lJExXsQ16f4/fHAhA+Ox/uhpBMmUf9PqGDx5Ho5IaGMCzT2leL8TWiA7WQARY0sPXdQT0ilA89cNT4R7v4OVrdrWP36dOLiFv/tTQ+kIZY8noKkx3QMb1qTbgH0x0flQ49RrHEv46nzaZaVSxjBCTZaaZInKVAGu1/pcokGTreDu5rcfvqHdDEgOd6Gb24YfxivJMNkDagMeiErYllATGE46+cRf0IKoCruRLuZgTlGGy5Ukc6kbfad7k7sW520hoK5hhEmAkysawzYJwzpxySRIYQ5peWXMRv0c4bk4F3x18trnuxxwE07Z2HbETqAx+r9OVVtdv15SNiBVsaczv/LMPLXCTgvbHcgrCLcRn6WVlBf5QKgJpjLdfhM7o3/D9BoMtlR2qAEWL6GA2LdrxQVI7QF5902yHz2IWZ3O7UfOagv2tj+zhn2CcDPf8Yw0jNwEUabxHv7IS5O8IeJTu1ScstzgWBh1njvvMHD1Un1mAVG4DwmhsVCqvXWb6m8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(11063799006)(56012099006)(10067099003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVJUMHM5MDhIcnloYzhzMjhjVnEzSnJwWmVYRHE2dnJIMnh2VDlaTGV6eUpv?=
 =?utf-8?B?cUkvMGhkbllUN3M0cUk1RnZCOU9TdGUwMVhkYlluK3VsMHJpeCtYSEFXcDla?=
 =?utf-8?B?aHZWdk56OEN1b0hhOWJweGgyanBoNUpsOXpWTDhoT2xPUVJTY0VyT0tIR1U2?=
 =?utf-8?B?aEs4OFIwaWhDUUo1VjV2K0t1UFNod3hrRDAzY1dLVXZaUVFGR25mYTZuY0ow?=
 =?utf-8?B?LzRzbzVPZkRiY0FheHBjb0M5MTNvRjFReHVlK2UvcXZNeG5ocFoyNi9nVnFz?=
 =?utf-8?B?QlowYXZ4dTUyWHhVU0ZFNHhldnlzRUxYU3RtWGdla3o3djhuNTBaa0RRZFFI?=
 =?utf-8?B?OHZXU0htWWJhODRkbnR3VlBNa1g1S3VDVzg4WGExZmEzNTVBSUZUT0k3Zjhs?=
 =?utf-8?B?TDcyS21UaFFIVDUwbTJwUU1DYlhBOEkyODhaa3FidTI3bG82VlJ3N2dCOWZF?=
 =?utf-8?B?dVp4WDF3aUNWWEVSNlRyWWNKU1VhcVM4SE5ZbEtpZWNyZUt2VHMvd05zWnA0?=
 =?utf-8?B?dDdONERrRU1iQ2xkdTZseE1NWlY4bmhoKzA5NHlZazJ1OVdUVHR0WXhwRDdM?=
 =?utf-8?B?VlduSmEwbUphWUJBcFlWYm9DZWw3YllnbmlVeEQwWEo0VHltbldHM01GZWha?=
 =?utf-8?B?N2dhcW14K1ppRXFoUlhacWRJcTZGOGJpYnBHRzFFcVBPVzFrdmxGdWpic3U5?=
 =?utf-8?B?M3RWcWFNcnpzQ3FkalIwU3FFMlE4QjlqOFoxSkE0d3BFNWJXbGFGWURocnkr?=
 =?utf-8?B?ZXJ2S1AzYVlGUkJQNlpIVFF1VnpFSUZkbjBvb1Ird1dXMkFac3hmbDhDMHh1?=
 =?utf-8?B?K0h2RGtnYlkwV1dURzZUVjg2RTkxN1Z3MjRHQ0J3R0JiY1ppbVFJemQzUTJK?=
 =?utf-8?B?MkVNNjEvZmtnZlhaNzRyQ1BVY1JqcGwvMEsvKzZ5NC9EWVY5djBESU5vK2dG?=
 =?utf-8?B?d2lJVVdlRzBzaVE1a0ErYTB3UjZRN1Mwa3YxaUNkaFFoS04rZmYrUzIxREkz?=
 =?utf-8?B?dkZwRGhBbWFvVEZuRXZodnpRWVUyYTBibXpJMW1GVHQ5YU1nejVsb1RHWmVp?=
 =?utf-8?B?VVpISUZMM1Q3ZTRzRGxLb0lJYzZYRDRkSHJla0tlUFBpWE00L0ZZUEdkVmd4?=
 =?utf-8?B?VkNUdkxEODM5clQ4V3k0VDVET01Uc1dEWXcxUHdmbEhycDdRL1lOQ3lkSGp5?=
 =?utf-8?B?TzRLREZUM04vbE5XcjJwaDZZRno1Wittc2c2RVBjOEhpaUZLWlozZVFxUWhr?=
 =?utf-8?B?L2JVZGw5TTgvUkEybXE4Y3pqUTYxbSs1UG1xczlhbjNmVFArQ2c0NjVZK3pj?=
 =?utf-8?B?UXNkVDRFbW9yMjRHSCtIMzF4a3czMlpQV3dZK3l0UDBWeGFkN25zWEJDYlll?=
 =?utf-8?B?TmhReGVEN1dsU1JPNGRxU3BiWVQ2UlV6eUZXUm9rWE1YeVF0elpNNkFqcWxk?=
 =?utf-8?B?ZzVsR1JFeHVQWE45Z05YQ1V0eXZBbFluNHB2c0Zha015dzRsL1NCUXFnL1ds?=
 =?utf-8?B?b0ZNMlBKeWh3NjVRbnlKbDJ1cVhnd3g1UzQzL1ZlVUpqWHBKNDhaamhQY3ln?=
 =?utf-8?B?cjdMeVdtREkzcXNSWkM3eUtueTlNTURKNEgyQXhuT0RqQTlQZHppdXJTOTdI?=
 =?utf-8?B?ZEZHTDZ0d3BQaHpLQ0htaVNPSGNkZXQ1QkVpSmlaNDBYZ053MUJIdTgwUW9s?=
 =?utf-8?B?M3BuUHhIYnJhRzlOS3NtQ2QrMVljcjBtdXhJcUIzUWl2QkFaTUVjZXZiU0hW?=
 =?utf-8?B?UllsdUo0RGt1ZERpMGVpUldLdkFIZ1oyUmUvWURHc3RqM0pQREQ4UzhZQkNy?=
 =?utf-8?B?WHdaT29hZTZydlpONVVTZUV6UEQrL2UyR2tPdE0yWG0zNGkwR1JXRlRNemgr?=
 =?utf-8?B?YjhlTWJDNzl1UkJxVUFwMm8zaWRGL0dSTmx6aHdTTWZBcDcxbUNrVmpGWndF?=
 =?utf-8?B?bURobXJaaWF2SUxLZlp2c1l1bGc3YkcvdWxzYmh5ZnlZUFZqS1dGUyszN3k1?=
 =?utf-8?B?RjB5bGtucnh0R2xieHdaazJDb3puWlp4aE96cElTakxaQWs0RjdheVFuajky?=
 =?utf-8?B?RXFzbDdvSEFMbmFLNjdTNWc1L01tbU5jTmN3VHdoaEtRWGpqTURqY0h0ajdF?=
 =?utf-8?B?R2RvMk8wSW1PR25qT0FHWXh5U0JWY2NvUUVlSVdWQVFOTXlNbmZxNkdod25G?=
 =?utf-8?B?Q0lxZGlJT2U3VDdsS3Z3NFJ5VmhxZDJUTlljK1FmZHRoOS9nM1BoRU9saFE4?=
 =?utf-8?B?Vm1lMnRRUGdVdHBFMUZtaytrRlNYZUlTaytkZm05M3B2eW04U0RrTldQeWVI?=
 =?utf-8?B?UHE3VDdXdndwY09uUVNhSVA2cVArTTRrQTNCQnZDdDgxK1RaekRsUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81790960-87e5-4999-2eae-08def7df2f07
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:31:47.5913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f5C2cuIPrF0FwI1L2Pb9y0h46gdQMFhY+973o7BdqpM+HJZITckW7Cv5u9lLW/hv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7238

On Sun, 26 Jul 2026 12:29:23 +0300, Michael Gur <michaelgur@nvidia.com> wrote:
> As firmware guarantees that all device-issued data writes complete before
> posting of CQE, there is no need for strong ordering of memory accesses
> on the live migration data mkey.
> Enable relaxed ordering on the mkey via the mlx5_core RO setter.
> 
> This allows better performance and supporting vfio live migration on HW
> that restricts memory registration with strict ordering.
> 
> [...]

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

-- 
Jason
