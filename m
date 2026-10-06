Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5123386C25;
	Tue,  6 Oct 2026 21:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791323859; cv=fail; b=ZqrlXfgkW8gnGfaFMqznRrW1/dwnQxs60hBvMiTeFHyadQyBX3jRCFVt6Khud8pA7E0Di7BS76C8ddYPxJRQUb3AnJphDBonW0AyL4ACwXU0T5kc7V7N34yXnz9314vqPTbyIgitgbjIVYJKlxc+HvD1qaAO9E8x+wGjIX68Zkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791323859; c=relaxed/simple;
	bh=UVP1sj2Jc7WC7lDaJUenCUTeRBdaRHZw/7ukygKBXFs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k38fs5dsVbEL6IPTnQebGJoYAdED9lN8OBMVbvslSBqfNmzCUL5eBPUNlpozwmGAzUxHwn1zb61bNtRhOhWgXAChATxLjxbZFxJdfqgcKVMW4716ig6lE4Cal9OfCt7OvWnfrRcgvWY6HUkBxu1+CSTNIsqNymhpX8jFtQMOnrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jz8Q/ZOy; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jz8Q/ZOy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791323857; x=1822859857;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVP1sj2Jc7WC7lDaJUenCUTeRBdaRHZw/7ukygKBXFs=;
  b=Jz8Q/ZOy/Mta1uW3bKZxKJroTUiaNU9u3ZjjiXJ84RMniKh4vXC0hlDz
   xh00LpmeZQNhVndCBL1BPGoMgXE/WNz6yaHpQaXtJKa0rQc3gWdRk6eTv
   SJFtXm23lGiiHxSyJwZHrRkPCmUfr7WEdOLarT6U6FJONpTZGz+neqCYE
   dcqmI/BF9Panh1SOle6feH2Bv8L+FMaku3+GqRK14LDUWXx97HbYWhyGs
   1qMTWuoavw4lAJhlJ1oQpEZWE7hE/XvKGkJ7ycztat2LFg0+pFwyWZE7S
   r5SAE+wU8ASAITSBe+sISouPofcMRa7Rjz7pgONSfUnrangYj3MQf30gF
   Q==;
X-CSE-ConnectionGUID: Thpmw0DcRhqGSf8nFbp73g==
X-CSE-MsgGUID: oxNVqVFYReSQGwesO2T+ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11927"; a="72355"
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="72355"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 14:57:36 -0700
X-CSE-ConnectionGUID: d+K/X1RYRoS9v+U/8xNRJw==
X-CSE-MsgGUID: hq00iYyvRbyffu/371t+YA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,143,1787036400"; 
   d="scan'208";a="285178714"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2026 14:57:36 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 14:57:35 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 6 Oct 2026 14:57:35 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.1) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 14:57:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6hd/B3m97FZQJff7PZluYYdN/rMaQ0nd3gDj5PmsmJTjoXLrmT5sTzsCjayZoOvJAIzmwmKI8JpTM4Qb7qriOCruuJQ9rmp9PztQYC4bMuic376ib0BXoAZfwKKrGWiFynBGz52Ad+HLOSazk7R99cKvFLjKIGXbcVRAos7ieW8sVPTd9CugYCHzqwrNCCGF1MiDIv4jybdJgM7xfNpD9b/vFf39cZPDR0QmPaIW/IC779ZRBY9PWG2Ds681lpyBF8olafDaJzn45UKCZpj13LmA+iZzPrSy5TRNsxuekWLrae4utorJy/DFwtyARKYxZc6ydhQ86cEd2iWN+Uvaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7Lkvbx9uCGtnXAWNsrsjZ4JbdQIkr+CCNhQrKgOu3c=;
 b=hrjm40Rrd3sa9TU8FHc9sR5zfwtfJWuFHj1ZXL4+zYvc09piIaaLhSZtvAGVhIxywQfjc8lxruSepq7IuY5g56QMorHU1z7LWf3Md5LE7sixPK9kqzEY1NQAP/sKaVkcYpfyAHFS6Mrq7HLVB30XOEVDCtXdGsug1Xxuo3QBiVdKL3+GaDTINIYc3wcJV0Z34NMn9iVRZO3vnLCpbS/cwgBHNlfNwL579CSwgffO2cnFPJEqM+IPCkyWP5qXWIZlkL0TRljU0ZG4PYl0ezlF6MqXkNlS8PeXfpc4HGh88waHbsys+IcfIwZ4/3Ef1hiBSBgNnyTyMZfbec6Aomwcgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14)
 by MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 21:57:31 +0000
Received: from DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58]) by DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58%6]) with mapi id 15.21.0451.022; Tue, 6 Oct 2026
 21:57:31 +0000
Message-ID: <345a40de-5353-477d-8be2-8c4e6468875e@intel.com>
Date: Tue, 6 Oct 2026 14:57:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] net/mlx5: allocate DMA pool structs on the
 pool's NUMA node
To: Seongjun Hong <hsj0512@snu.ac.kr>, Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, "Mark
 Bloch" <mbloch@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
Content-Language: en-US
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20261006-net-mlx5-numa-allocate-pool-page-v2-1-0dc4c2eb1376@snu.ac.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0329.namprd04.prod.outlook.com
 (2603:10b6:303:82::34) To DS0PR11MB7381.namprd11.prod.outlook.com
 (2603:10b6:8:134::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7381:EE_|MW4PR11MB5776:EE_
X-MS-Office365-Filtering-Correlation-Id: 259cfee8-ff33-44a9-5c78-08df23f4d1ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|18002099003|22082099003|921020|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: bNuNUMKF65+7BvY1nxjLVwC2sV5sSnuObb/EJccwrGgA10RfVRWmzgm8tfNkk9HwDSKM/hjySN7W87TVdL73N8yvFnEWNiIzaN/JMbc3JlUNVXwMErzbFOwwnf0tWIqfXv8b/izvQgctVLajBUBz9tJBTuAFw1i5MfPaGRo4fQRWhqz5j/IFDVJSQajJvSr38q4zFRiUjr64kuw3GL5B1w60bUUvV3IZAjvLJ7dEIEDrwLgoiNwevK9HkxMGI8EFggQLsLYlOMwP6cT6d5AsJf7PvrSyZT1c/3LkQ85zF7BsjN5IN8TVQ6QQULOuHp0c/RB3VnOdW+UICRHIVKCUZ46aFJF86vv69e6fXLn65cc0ZWhB28Jo3gF5HJN5CSs2dLNGcWUayFuv7njjpo6ITo8gBhzCkJJUxL7wDLHt5MzaeFm+9e/oneO0wYrpAaIFeulBhE8fwqGbqp71VYwvST3l/ZZ7cuopCP27F7pwyP4Q6HoJc3P9KIgUDCU0l5BifkPKBLzTAubeAODEAWnQzcx0feiC2l33MfYuCWvOiDmjdYDud50wuCoGgmivRHPdcoSEmoG0UDVLl3NlvDTJFeliH27KGPCykW5VqVscO+NhSUDjRgoHG2IiVEnC/8vD2PvpViso3rjk32vyDlVFE7/BR1MjIrt4KtvHUTfp835Wia7XApZDLBTdSyaxVqvPk0k/HCvVn7k8Hw7O2wHp7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7381.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(18002099003)(22082099003)(921020)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVBFQ0NNdXRuVlRPOUVSa0ZnYlQveHluNHgvblp5SEphS0JCeFBQK1NPTk1l?=
 =?utf-8?B?WTRjcXRVdGJPenp3eVEwV2hsNWFvRS8xWWk5aGIyaXV4K0RBUkFnYUhMcWNZ?=
 =?utf-8?B?UDhhdnJlcFNLSGxEMHJZUDNWaXVwb1N4d2hodFJ4aFlzTkNIdzN6S2JNOUlP?=
 =?utf-8?B?VmZTY3BCRmVpVkxVLzRyMDJBWnJlQllzZnRCajMybmErZk5xcnIxWkNiUWYv?=
 =?utf-8?B?MlhPYXE5SlNnWGFXN2Ruc2FIeHFpK295Y1BqaGd5TnJWbFE4TFpRQkwvVjRS?=
 =?utf-8?B?Z3hIVEpUQWRUdUx5ZGQvWGk2Ukt5elVHWlVVa1ovN3pOVjdFcmRqbzhTWHhr?=
 =?utf-8?B?N3ZwUWRza3g1WDRqaExjbS9wQ1EvSVNYd3dGaTR6dmljdWVLYVpCNXZVcVFx?=
 =?utf-8?B?NUx5TVlRbEpKV3p4ck85NVVpTURwejJrRjNzM3lDVmM3ZDRLWmx1cHg2c0hD?=
 =?utf-8?B?OUtvQ0ZORzNMbDh0a1JEeEJWUkhVZkhNNEw1L0xXUjdheXZRVExnSU5jZ2Q0?=
 =?utf-8?B?T1BrTmZITS95aTdHNHliQzQ5amNpZlNRUmxmQWNSOFZHMy9sUFVIYWhzbmVy?=
 =?utf-8?B?M25QTzE3R3VJSjNlckZYMmNWTTdiNTJXWkgraldjOStxUHJqdjI3TTVoNkZk?=
 =?utf-8?B?bEVrY1pSTDQ5WVltTEtXVFZMMWRybWYzbkhtZDZqejJaY01QakRFdy9wN1NY?=
 =?utf-8?B?cnltUTJqbGpNcVdMaU4rTkJJSFQyVFN0b0dNNHFOcGtnWFYwbTA3SUh1WHNC?=
 =?utf-8?B?ZFY3L3VsUzdXMnZiNklheEdZS3V6V2dvRlBvSTBFbW5uemVWa3puUFRqMWRL?=
 =?utf-8?B?cGxxL3V6bWNVdE5QZkZjbXRjYkYxVkpmZTVlb1pobkw4dG91d1BCMldwTVlV?=
 =?utf-8?B?TXl4WmFmaTROWWZwQlBML0JiTk1PRXE5YkRNMWhnbHhVaW01SHlNbnBCdlFD?=
 =?utf-8?B?Z0prNXJNNGJKeGZFOCtJT3NhV1pUK1Aray9KajlyWWd1U0t5NDZ2VU9QNXk5?=
 =?utf-8?B?VU9TQ3YrSUlaRFpuaWQyVlJMa3RaKzlqZ281RU0rak9JMi9FWDNRWjdaOTc4?=
 =?utf-8?B?ZG0yWisvdkltM0F0WWZCUUo4UHBkM1BBV1crRkxjemZLSndVZzN5RmxHQnpu?=
 =?utf-8?B?NllQTEVPMjlYZ1oyY3pod1VNZ1N0L0g3SEV4NVFoN0NJMGFrN2lLUEFaWHRp?=
 =?utf-8?B?V0FqanI0b1BIWnZaekZSTlRZTml2NGE1RWRsOS8rd3lWL3JPaUYzMVZEMlNw?=
 =?utf-8?B?cGh5OE52aHFBVVdKOEdCWHkrK1VXdlQ4MlFZMFBxRnVtWkNxTmFYeWdNV2xF?=
 =?utf-8?B?S09BTm11NkxDTzdJZDJyVEdZekprM2VacUE3UTRSWVZ1ZnhZY1VUZ2RQSndu?=
 =?utf-8?B?RncvT092MGdteHUyMU5RY0ljMmJORzVCZ0hFQ3RZb1J2aDdaUkdSOXdLem1u?=
 =?utf-8?B?cS9lUzN5bzEvbHdVTys1NGdabEIxY1k0MEd3bXordlduOTBSTVIwWE9xNmQw?=
 =?utf-8?B?ZnRUV3VtTW9EbE9mUDlSL2U0c0E1bng0OEpPakQzNkxxRTNRUlQ4VlY2aHk4?=
 =?utf-8?B?MSt2TUtBYXgvZzdXaTBPUklqNHViMmZXQzkxVXYvU3VkM2xvWmJsYjVCQ0dw?=
 =?utf-8?B?RStZaEEvSDRyQjkxT2FqOVhLNGRCOGpPbWtmdGlqaWJFQU04VXVUK25aYnJE?=
 =?utf-8?B?MFBmRUZqd0daUVhQWTRPM1dOcmlETVU1emxIVjA0L1RFVktqc1JBWGxkRmRa?=
 =?utf-8?B?eVJadjd3Q2dIUkVXYVlaZEZlWjA5OHdEdUdiTytTWll5ZmZMaXlTdXFyYXox?=
 =?utf-8?B?cjFnbEtUQ3VMR0ZYZXQzV3VDTGtUZndSZitsMGdmWjZHRXBBQ3I4Y0doT3l5?=
 =?utf-8?B?Qm5QMVJHWjM3MjhCeXh2WXdSRmhnU1Q2RzV1ejNVdzI4KzR6bU9qeTgxaGVY?=
 =?utf-8?B?b0F3cVJXMjZJMCt0cW5nclVZeVN0KzVoNUhyRjZTSllOdCtUQTBnQnVRc3VN?=
 =?utf-8?B?VFg0ODVyQnBqYkNKYmRLRVhuZlNHSllOWXhQZ3Q3OEtJUnc3alR5V296cVhh?=
 =?utf-8?B?T2pmMXFPZkFSZzgxa3gzVjBNTmtWQTcyODJ3WDJ0VDV6dHVxWFBUVlpuSDZS?=
 =?utf-8?B?MUJiOWtQcmh3Si8rODN3amZLVm5XTitpdHF6Q1A3L043N2kzbUFsOFVkS2ZN?=
 =?utf-8?B?NktDRmJWUFAxbzZoUzhaSVVtN1R1THprczFlbjF0eDV4Q2hlSHhLb0NpeGhm?=
 =?utf-8?B?MUJndDFVUjZRclJ0RjFESWhDckRIWUROSDk2RTFGR0pVSXhUV1k5MHF1MXFR?=
 =?utf-8?B?M3d1b0w3VFg1QUp0Tzg1MHdtc0FQUStiQnpkamg3MnhFTmxkZGttWnpwbEZq?=
 =?utf-8?Q?CVWEQ/eCbrSYot8Y=3D?=
X-Exchange-RoutingPolicyChecked: J0qPsg7NHrOeF4ZpkinQ7iN0ckTOdf+SS8wUjaMYtpgi4b6FHIe8VpSkFQQxQH2xWPRhitjZyzjv1RDMSLrmRWBCJ2q6nPK3ExFlNjI9XPowSvKoXm/8/WphH1m+NC37ajDHBHqBI62piWCNwuheHGBskuGOi+kz/Ver14TTXtmk01+MC/dw02FaUVZKGTyn0USgW+xunvHBhyFBAfdDBFMCafLMeAjoG9xDi6eEjrcEIz+rEGlYX6qM/4Dit7KlOHa9M0Twm8PP5iManIqzAW6cauf1E270CeSY6iYEXgPtZe4yJBVuocb1W1kooRekstNpvvoOnnX24D+Yjc6zag==
X-MS-Exchange-CrossTenant-Network-Message-Id: 259cfee8-ff33-44a9-5c78-08df23f4d1ba
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7381.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 21:57:30.9449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjqCHp+6t517R2UuJ2iAlW3EnwbqJrCMPmTP4t/fbVpzU85kVUV6RLZgBSVZuM4XJlHjR62/7oi3606Bzd9QYt6sKscXeXocaJ1dlxXLmtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5776
X-OriginatorOrg: intel.com

On 10/6/2026 7:16 AM, Seongjun Hong wrote:
> The mlx5 DMA pool structs (mlx5_dma_pool, mlx5_dma_pool_page and its
> block bitmap, and mlx5_frag_buf_node_pools) are allocated without a
> node hint, so they land on the node of whichever CPU happens to create
> or fill the pool, while the DMA pages they describe are allocated on
> the pool's node.
> 
> The pool, page and bitmap are dereferenced on every block allocation
> and free. Allocate them on the pool's NUMA node as well, so that all
> of a pool's state lives on one node.
> 
> These allocations happen on the control path, so the performance gain
> is expected to be small; the change is mainly for consistency.
> 
> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
> ---
> Changes in v2:
> - fix typo and specify the structs are allocated on the control path
> - add a prefix net-next to the subject
> - Link to v1: https://lore.kernel.org/r/20261005-net-mlx5-numa-allocate-pool-page-v1-1-01f4283932b4@snu.ac.kr
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/alloc.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> index a92cf545bdaf..dcd281c4691d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/alloc.c
> @@ -110,7 +110,7 @@ static struct mlx5_dma_pool *mlx5_dma_pool_create(struct mlx5_core_dev *dev,
>  {
>  	struct mlx5_dma_pool *pool;
>  
> -	pool = kzalloc_obj(*pool);
> +	pool = kzalloc_node(sizeof(*pool), GFP_KERNEL, node);

This removes all the benefits of kzalloc_obj() here...

But I guess the __alloc_objs API doesn'thave the ability to add a node?
It seems like we'd benefit from having support for the node parameter..
but it does seem tricky to add. kzalloc_node_obj() could potentially be
added. Staring at the implementation I have no idea how complicated that
would be.

Still, this only really changes two allocations and they're pretty
obviously correct.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  	if (!pool)
>  		return NULL;
>  
> @@ -127,19 +127,20 @@ mlx5_dma_pool_page_alloc(struct mlx5_dma_pool *pool)
>  {
>  	int blocks_per_page = BIT(PAGE_SHIFT - pool->block_shift);
>  	struct mlx5_dma_pool_page *page;
> +	int node = pool->node;
>  
> -	page = kzalloc_obj(*page);
> +	page = kzalloc_node(sizeof(*page), GFP_KERNEL, node);
>  	if (!page)
>  		goto err_out;
>  
>  	page->pool = pool;
> -	page->bitmap = bitmap_zalloc(blocks_per_page, GFP_KERNEL);
> +	page->bitmap = bitmap_zalloc_node(blocks_per_page, GFP_KERNEL, node);
>  	if (!page->bitmap)
>  		goto err_free_page;
>  
>  	bitmap_fill(page->bitmap, blocks_per_page);
>  	page->buf = mlx5_dma_zalloc_coherent_node(pool->dev, PAGE_SIZE,
> -						  &page->dma, pool->node);
> +						  &page->dma, node);
>  	if (!page->buf)
>  		goto err_free_bitmap;
>  
> @@ -278,7 +279,7 @@ mlx5_frag_buf_node_pools_create(struct mlx5_core_dev *dev, int node)
>  {
>  	struct mlx5_frag_buf_node_pools *node_pools;
>  
> -	node_pools = kzalloc_obj(*node_pools);
> +	node_pools = kzalloc_node(sizeof(*node_pools), GFP_KERNEL, node);
>  	if (!node_pools)
>  		return NULL;
>  
> 
> ---
> base-commit: 8b4e7209c842d8cb9516f1f5ef0a88aa2d8831a6
> change-id: 20261005-net-mlx5-numa-allocate-pool-page-2ee20a04147e
> 
> Best regards,

