Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68799317147;
	Thu,  4 Jun 2026 19:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780601056; cv=fail; b=PQVUrPRVP9qHlLtaj1y4NXXRHCLjtQeBfUWKI1epXKLZQ5vxZJrDnV0Lfg0WNgaFma1928HUjU3IPl7GCi0dQbmmG+OcM11KILoEJNubwt+/J6s5rXoBExiB0yU07B5T10rWOpUsjcnuD/E8beiDNTgtIfp70tKFDeLi7osYoJs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780601056; c=relaxed/simple;
	bh=iJLkzifCdkFLn6hX8z8pzuFzrxiMBPXWqB/UAkJTDkQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Uxbo2Osb5Br+q+Vy5ax+mpU41rFhzmYeU7xMVzqhR7dduZxk361CPF981VCecDtZUP2QGRyMvla/69VS115eRl/5kLCM8VlMkn8ivDcDFvLrvOZQTyee3GuhMJ67L9Ue8wEDpYf70n8ScmE0N2ITfii49saHANSBFecNjH5OmMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wkj+emqb; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wkj+emqb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780601055; x=1812137055;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iJLkzifCdkFLn6hX8z8pzuFzrxiMBPXWqB/UAkJTDkQ=;
  b=Wkj+emqbmsbIB0cXjBo9sd5Xnr+YvKl4+/tFlWpK5g+3vprp50iBZktz
   MqajsH6hdtjw8HM+IQV0DrogX9PP7T2W68aE8BgZWO+fpMFK+PtDf+X59
   oSTuyrUwWEoqA+OSRfTwcUz2QxTtcXmPkFTeJVcxq4U+QeWSwdSrXiC5w
   l+YA1W0SsMy1byahMMC6l8tIqQkM5+nPEexTekEJFphVesoGAPcnBIZzB
   hEGEynV/GfiGfk+lBbnXKDGHmjG7Vyv2wjF/8d5xggr56a4V/dgKyhy+M
   wr3fWpqN/x2X99f0XrOBAbmD4HrYMSa77IwaRByqCZFQj5MzP72c8WRdd
   A==;
X-CSE-ConnectionGUID: Fm7gXvfFTt2h2ALFmy1UMA==
X-CSE-MsgGUID: dda38gKdSnaD99Yn3fF8DA==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="80471534"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="80471534"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 12:24:14 -0700
X-CSE-ConnectionGUID: YRHfny+lTWm2CQKwQ1AnaQ==
X-CSE-MsgGUID: 2QE4BLK7QxWXEUSyrmRcYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="249729553"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 12:24:15 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 12:24:14 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 12:24:14 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.7) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 12:24:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjnOWQOutfXr5/a0uF71TUz8PqCJolIQLekZ1ItjaIh61fdZzoOwIzaVQGNKVAB/L/XWHCIMBuZR6ZPssUdFuW1DIGKXWDbgDcerhgwd87UkCJIfCzffnABIyOcGpEpdYhRn1qpHDYm3llk+ZLiEsgfX6HVXgzOV58btw5zWdzML0eojV7pEF+W8TytZV1rQNm6399V7JmzvgVO3/iddCt2GBls3hTr7ZimAprV9oPYa8JFlWUTPRhgz8iH6G6LtmsoDzh7zBc0iG9fvj3f80mZ3bIUzDTFN/u8Z1HtfrHpJT18ijudEGG1SJqJFXR7XQfZYsmTRbHeckkHm9GspZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVVYpbSItzPmelmwxGrFTHqR7Dq6mJnFPdyJ6isgRys=;
 b=CWo7fovcpo6yJ7sAy9yqQ7YjyQxKHkdd6cI87MM7QRZ21URfjfRNTc6aAQOCQ8lzsh02v1uMvqtNqD5+Nb7nfhd04ktrOB2w/bveJ2ZhOkyS/JKrDheYx2ziNTRmxmfGV2OtNmDwWJAzfeyXc9f6W7YQH2M7IyU/BGKmUVMaze4SAIpvzuYROEkVpTggzqpkdTrclhZvIkej4pcI8zFCx/uM/qB7FKKYu6CPmk7t9NKtHVtKLzw5Ks8DFy1vHLlR2jvStfgESdVbf+tLVSDIiDh2GYLAYTVM1K2YIMbFYVRiRa27uKT2HuiIEySou0lNHRpDFNKq0gw1MQ4dmZcQAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7381.namprd11.prod.outlook.com (2603:10b6:8:134::14)
 by BY1PR11MB8125.namprd11.prod.outlook.com (2603:10b6:a03:528::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Thu, 4 Jun 2026
 19:24:08 +0000
Received: from DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58]) by DS0PR11MB7381.namprd11.prod.outlook.com
 ([fe80::4c39:dfe6:d6dc:6f58%5]) with mapi id 15.21.0092.007; Thu, 4 Jun 2026
 19:24:08 +0000
Message-ID: <730151aa-c052-48b4-83e6-50d4523dd68c@intel.com>
Date: Thu, 4 Jun 2026 12:24:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 1/4] net/mlx5e: Fix HV VHCA stats zero-sized buffer
 allocation
To: Tariq Toukan <tariqt@nvidia.com>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Andrew
 Lunn" <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>, Eran Ben Elisha <eranbe@nvidia.com>, Feng Liu
	<feliu@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, Gal Pressman
	<gal@nvidia.com>, Simon Horman <horms@kernel.org>, Alexei Lazar
	<alazar@nvidia.com>, Nimrod Oren <noren@nvidia.com>, Carolina Jubran
	<cjubran@nvidia.com>, Kees Cook <kees@kernel.org>, Lama Kayal
	<lkayal@nvidia.com>, Eran Ben Elisha <eranbe@mellanox.com>, Saeed Mahameed
	<saeedm@mellanox.com>, Haiyang Zhang <haiyangz@microsoft.com>, Joe Damato
	<joe@dama.to>, <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20260604135041.455754-1-tariqt@nvidia.com>
 <20260604135041.455754-2-tariqt@nvidia.com>
Content-Language: en-US
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20260604135041.455754-2-tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:303:2a::14) To DS0PR11MB7381.namprd11.prod.outlook.com
 (2603:10b6:8:134::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7381:EE_|BY1PR11MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: b812c44f-bd73-4163-da2d-08dec26ed96f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|18002099003|22082099003|56012099006|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info: uEw9MLaOL4Jf1s3w5JPasbDZ3XQdmhv+xVDzzugW6DTEW8BA1bN0Qm9Fbx60ZfBEGLZW7sNg7PXEVZaAGOmmE1US98T60YevtekZb9LpdBqEMPM4tKUJR+ebm8UwzrBTWOD1XHVjFBwFmqiYcqDwU75UAWjA/PtSvSZdMegTfCiWZiSH5xBG94VjRJXV7WNIrTJTt5gFNzNXg0vSdJqfe/i49buahfbUqPGrZP/YJ0c5T1dNcLRQy9ERkvnBr0F6ppFuJUjdeX499c//M33jZJCx2Og0gURrbMvTB32LpI6yAqmSGfo7H06/4eSyQhRbpw2L4iqXkI3SLgItz60VL9Ff2hsaNbAZriM5vaNdPKimcSstl16QMLtIuifI45ONR9uBrkw7cof4mIh43hOBulknfzn9rbMMq6o3RDPVwTqyj2M51JmPagE+B/oRKIjbw3LqIdn36p1QfiFqJWZsUm4l/BZU3EVN1Y4iZSoxu8sHlXaNbjB460wJXCJ+nrv3EGr3BYW13L8ZivaUGkoCQFfKra7OI5P/jVpvwaBgAAZc/5BKSaPBQr9oTUxaHXjh5NI7wYY+jWrC6q5YG/whMdQzfepxgRGdiEZrSs8wQCO6kCvMAgachExif8xMyxPaHwiUkjkYd4QO42a6BG6y+BHqbnYusWFQiAE2V7modk1AOyy589NPHYtMW6LnKM+T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7381.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y2R2UkNnUEJldU4wNTdPdEU5S0NNZERoQXRUNDZQNktuTDRWbEVIQ1NVN3pR?=
 =?utf-8?B?ZUY3bGFiM0RIYlFvZ2dIcm9UVHVmd0ZwWWZ4VWYvbmhPSFQ4NmIvOU84MEM5?=
 =?utf-8?B?NkNrZ3l2eklvVTB3bkdSSC9hdnNDdERPcGpUZzB2M0ROSXdQZXNoWG12OEZG?=
 =?utf-8?B?OW95L0VmK0FGMlRsR3QxcmpPZUN0TjlaL1pudUlON2VoeUUvOW9TclBqSit6?=
 =?utf-8?B?U3lvdEg2RXlQaUZCeUtLNjZvVEJxN2M1ZE1DakVFYWJyTmovS1NmYThuR01w?=
 =?utf-8?B?SzlNbkZnVXFlLzZsQTBXMHkyTittQlpYZ1R6WFFVRkYrTVJmWGxnYzhiaHVS?=
 =?utf-8?B?M3I1VkRMNFZaM1dSMnhlR0xPNUdDOUxRMmZiN3RvRjN2c1QrT0VObks1ekxx?=
 =?utf-8?B?TUVkRHR4dW5jd25mMDBPRmxkb1ZET1R6OW95U2Z2RVNFOGcyZzlwQms0TGRK?=
 =?utf-8?B?YWc0YmlmaWwyY3FXZCttRW5ZUEtMY3FWb1YwQmFFd0VJOTg1TWJuR0dKelY2?=
 =?utf-8?B?VUQ1a3NGeW9OZkp4b0VvTWdlZkRuMGd6QUtlU3owNG1CSjhZNUFwWTdpQ3pY?=
 =?utf-8?B?ak5xVzMxS2VZN1BTNE05ck83WkJxM3RjbGdUaXIzNlY5TkV5OVl5LzZnS3Zw?=
 =?utf-8?B?ckd0dlE0eUVRN0hoRHF0S05meGxNQlBFRWJIV2NnV2JGRDNyNjB5bE4xY2pv?=
 =?utf-8?B?QU4zMnZ6SWd5WGFldVlpdHlLdnhLOENGRzNnalk1bWkzVWw0TmNNZ0k5TE8r?=
 =?utf-8?B?Q1htTTNMN3VqVTk5Y2pGa1BEMWppZ1pzVmI1cGVWYjZmbFkyUHQ0c0N5VnZZ?=
 =?utf-8?B?K3dZMVFpUzBqQVhVWWoxQy9nU3hwV3ZvT3VpSjJtNFVncW1KRzE0anhwQytl?=
 =?utf-8?B?dS8xV1Z2bnpWT1dORlBscFNJVFhtOEhINlRMTVB0S3dJWlVjZlFmWUlvTzVI?=
 =?utf-8?B?MkZBdGFtYzdiY1BOaXIvR3NvOTZDTkpCR00veWpsRG53YmdZMk5uc0hrK3Bi?=
 =?utf-8?B?b29SR1RuNWZueEFuMjdCUW55NnpkcFZBbVZmRnZKdXN6QkZ4VTRXMXhlRytP?=
 =?utf-8?B?NHNOWTJtbzdrZElZVG5CY2k0NzdrK2Rwa01FY3R1Qkd2Z2RsYlpvQVhvdmFR?=
 =?utf-8?B?Zk5IaVJxZXMxMzU1dXdycW11RGdRL0pCMzkxN3oyb1NnRTUvRDA2R1R5Z0xT?=
 =?utf-8?B?RHAvYkJxVmlZeUhNK01QOVhkL0xpU0RkalFBZWgvRjFWVVdacXdkKy9TQVYw?=
 =?utf-8?B?and4VmtrWTdGNThnNGlYeGowcG9lMU90VDR4WWJObGpaV3V0bDFZd0k3QThp?=
 =?utf-8?B?WE9sVlJPT0E3MTVGRjBDVHlVR1lERnhvQXdTeHovTTRBQ3YzcFc1U3ZCbGpz?=
 =?utf-8?B?Z3JIaS9RMVNuNkk4L0tIbG8ySFhTNzhxWEdPdUk5MjNBKzBNNjE2emdmRy9m?=
 =?utf-8?B?ZVpMM25XRHdYRGZCQXoyWFVmd1VUcFA3YmlDV2hBUW9UajBIVkRSTHgzNUh6?=
 =?utf-8?B?WWE2RUE3d1JZaHJHc1IxRWFXQ0xtM2NscEVSczFJQmpJRFZYVTY5c0tYSzlR?=
 =?utf-8?B?bUl5eEpPS3ovK0hCb1hFcHhnbVhHVVhSdXppMHJNRldiZGZ4eWluNFpRY0k1?=
 =?utf-8?B?SjFsTUZKL3ZrZGE5TURuV0E2VHR0NmNSaUcrYVAwT2FQNHVkVUVncE1MV0JM?=
 =?utf-8?B?cGVsckphQTNJcVNPYnpKYWFRZVdpc2NzWkpOK05QMTJrUTNudXhQaE52OElu?=
 =?utf-8?B?REZjVzMwSjNTMjgySUY3UmtxZzFVODFXSHB0OEhxVHpNdGYvZWFmYzQ5VFR4?=
 =?utf-8?B?Mk4wSVdrM1lTNXM4TWxXek95YnY1MjhKRHlzSlYya2E3YXNHeis2MHJ3Z0Rh?=
 =?utf-8?B?a3R4ZkgzaTdTVjM0QlF2KysyLzhQL3owMkRyV0RRdWNxeU1zV1laUjcwL1Ro?=
 =?utf-8?B?YUluV1cwVXJTRzJ0aS9iVTNTcS9mTGRnZlVheEZpc2pLWE13WCtKT2dvWnhr?=
 =?utf-8?B?dStBUG1QNjE2TzdUSFhrVlpVNzFuMUthV3VpQUJlbFVlbWwxWGtqbFdEUWIx?=
 =?utf-8?B?STM1ZCsxM0ViRG0vR0N3am9jNGpFbllWVTFlTmZRdGx1R3VkM1FhSkpRYmZz?=
 =?utf-8?B?ZEpGNFh4Yk9qRkZqaHFuZms4ZUV3dnRZaWFOUEdhRFJTYjdyQ2NiMzBPSWZn?=
 =?utf-8?B?SHRxSDZsSEYyeE1aMVN3aG5Bd0x5eWp6bEEvNmhYeXgydGs3OEZiSEtHZXc1?=
 =?utf-8?B?RmtCOHM2UzhnK3kzVmhaY1hWa0R0OGY1Z3FXNlB4TTFXRHEyeVYwRmZEaHI5?=
 =?utf-8?B?YnpleStaU3Jlb3hQaGVYM0NSRFRtUHFEZlR6ZE5SQytJTTEvT290bUEzUGFs?=
 =?utf-8?Q?5TVKEhYYMwjStSu0=3D?=
X-Exchange-RoutingPolicyChecked: NQKc7iTNiRw5xqNWYBy0URiDtWCVFIzGo9+YtIjywa2wVrdNqX7l8RGuIf81BeC/AzQwPNGym/+lvYe9BUvYiGr3Ey9zW1LRrCBo1CLZVRRKwqp8NLnLp+MbNLPhP4DPCFVd/8JQafPaL1lfWnUuc3pZ5OERrHGSdh18FK6Pje1h1cyD0GdWQDBLZBsRzeLH5GD9lAmrCr98v/VNOhXP3M1Oy5kyqqyEOyeKXzVH3/miVIzdITNsgkpHAf6i3k6qOBu+kbxZ61etr4o4IpSb/3tI7u2ts+u1UrRKN37hYAOagBrjkUuF7OOUrCtpA+KJCIyIzVLiKZTwG6K+M0Dd4w==
X-MS-Exchange-CrossTenant-Network-Message-Id: b812c44f-bd73-4163-da2d-08dec26ed96f
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7381.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 19:24:08.5025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQZq7347rqVpdneaOd39L25qryhwrKvPGsX8HdiUOlKAKcbfyRyJ5d+Knlf5jEJcqv23BspWDg4l45s4uWtkpkmCXB+1JDfuQxNLc29pheY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8125
X-OriginatorOrg: intel.com

On 6/4/2026 6:50 AM, Tariq Toukan wrote:
> From: Feng Liu <feliu@nvidia.com>
> 
> mlx5e_hv_vhca_stats_create() is called from mlx5e_nic_enable(),
> before mlx5e_open(). At that point priv->stats_nch is still zero,
> because it is only ever incremented in mlx5e_channel_stats_alloc(),
> which is reached only from mlx5e_open_channel().
> 
> mlx5e_hv_vhca_stats_buf_size() therefore returns 0, and
> kvzalloc(0, GFP_KERNEL) returns ZERO_SIZE_PTR ((void *)16) rather
> than NULL. The "if (!buf)" guard does not catch this, and
> mlx5e_hv_vhca_stats_create() completes "successfully" with
> priv->stats_agent.buf set to ZERO_SIZE_PTR.
> 
> Once channels are opened (priv->stats_nch > 0) and the hypervisor
> enables stats reporting, mlx5e_hv_vhca_stats_work() recomputes
> buf_len using the new non-zero stats_nch and calls
> memset(buf, 0, buf_len) on ZERO_SIZE_PTR, faulting at address 0x10.
> 
> Allocate the buffer based on priv->max_nch, which is set in
> mlx5e_priv_init() and is the upper bound on stats_nch:
> 
>   - Add a separate helper mlx5e_hv_vhca_stats_buf_max_size() that
>     returns sizeof(per_ring_stats) * max(max_nch, stats_nch), and
>     use it for the kvzalloc() in mlx5e_hv_vhca_stats_create().
>   - Keep mlx5e_hv_vhca_stats_buf_size() (which returns based on
>     stats_nch) for the worker's active payload size, so the wire
>     format (block->rings = stats_nch) and the amount of data filled
>     by mlx5e_hv_vhca_fill_stats() are unchanged.
> 
> The max(max_nch, stats_nch) guard handles the rare case where
> mlx5e_attach_netdev() recomputes max_nch downward across a
> detach/resume cycle while priv->stats_nch persists (mlx5e_detach_netdev
> does not call mlx5e_priv_cleanup, so stats_nch is only reset when
> the netdev is destroyed). Without the guard, the worker could compute
> buf_len from stats_nch and overrun the smaller buffer allocated based
> on the reduced max_nch.
> 
> This mirrors the existing mlx5e pattern of preallocating arrays of
> size max_nch (e.g. priv->channel_stats) and lazily populating
> entries up to stats_nch on demand.
> 
> Fixes: fa691d0c9c08 ("net/mlx5e: Allocate per-channel stats dynamically at first usage")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

