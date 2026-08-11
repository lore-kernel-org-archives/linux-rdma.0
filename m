Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011065.outbound.protection.outlook.com [52.101.57.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26243E3D92
	for <linux-rdma@vger.kernel.org>; Tue, 11 Aug 2026 19:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786477191; cv=fail; b=ldNCRP+mHWknXXsj5mYmxe8ZIzmhJJD6tMpb+6iHnZHgvFjcxjF+RkDO2Gtmf9IilIY5UYT0aDJeH5KEkfBvaH5RLp8hUTSWWZoSIfwU5B6gEj+Tqs47STLwUvSDH1Bwwy9LlhSB1skhMKZPaE7JAMlHVZNeKr2SLdYgN4ShDho=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786477191; c=relaxed/simple;
	bh=Lix5FvRTM7jQp5xnNQLX5bITLzQfwPq8M4KqgJcc90c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OV0+BGED3LjLiArBaLUdL+mjoxZ82rvpHwJ+iE0CYUNh4AwL7crNYo8codze0WWm9e6uD+mREQBHCJSQDnYYk/S1MSrSmWDwo2FlmgBAzKXaMXx6Rw+YQdtLjI15EgLdlBdUP/c2cjxlB2SR/wFYZ/UVD7LFgqYbhduvN2TaWn4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lQexfy35; arc=fail smtp.client-ip=52.101.57.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lQexfy35"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LlSZ3zCnC8YYHn7I7DWwFqWVrzYvfrVg8NG54CC7+slRpTc0DOXgtnCl0vuhUWyVZSlkjtE/Jtt1kBz7o1s5Bbwyq1bnHWAqfbUFYYoEQ6pQjQhagn6sjHbRB9EUBFd3axuy71ZC8mkt8LdNK/Ug0XCcgx3X188YsVLPAKZW63zqPyFJuhiqiQAvw29XbFpsr82LCF4T+Uvb7x9IWnqkPoF27hkoEgYhRItt/fwC6T6QHHRI9EgkB2xGbIUtzo6bHcTxoVNwqU0mUG0+2acjuyMlbIli4auLkez7FkNaP2k+FMyhieNbAniIPT42CiSgAdvzIiK4VNnVrRN52pRIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4doYxHFmaVCMpxC5/fRT07CXFclm73y8kPewTYAouss=;
 b=dn8hPP4L6/u6EnSCR3oEIrqJQ7FAmMSAAo5amFY6P2ius898bqsZCClkoxfqYRHwOZVC2JKqXUZyfbarmo1D/I86GsXNv3ht0f+U9EGIshjFz8J/4C6jaYhddif6cfdfyOIbyvA9SpcAuJ4tvez+EAwJWTlTclOGwTd/BtTmRuQ3k0IyDrJsvWrakc9Zf7BBDlMGiWV4GetGuW6CZkwxqF6cYY/4mVlgrsaOb1ghWPv6ZbP3G1dEvLdCgFNvxo+0cMe+Z7s3+RUz3C4G2PUY9sTsHS3tGi6z4lyOLSG+198d5SFvfxc0bpx8sHOdSzwOQ+VPpQCSsnaFjetv9cyy2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4doYxHFmaVCMpxC5/fRT07CXFclm73y8kPewTYAouss=;
 b=lQexfy35Img8kP/pgE5vg+jvjE3QJH5EEcXQ1s0OnFtKapbb38Cekn6Rib1/oJkRQSSyz1GqkJmeemiCzoyBHjEx5yIqwNhGx3+zf1YaXwxqRep/L6S2BMFp3vpG94YVb+GWd0aJdQUKvxby0PB7fKASjfeH31D6zNyePn1rR0MJMiI2XyNCpn32yEFONQEw9+sMVP2z7/Ab3HQ/aoyv34L6oYtBuEWbyCNhZELNRI+v4N+YbzyTc0Cu2UfNM/MvSks09gOmXLs976ws0QNog/aRR6BrX+5h2TfDflVej5SjeML7Fy39ajcfsbXmZNs3rT3jhY2wYlsKAe7YCZYfrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY8PR12MB7659.namprd12.prod.outlook.com (2603:10b6:930:9f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Tue, 11 Aug
 2026 19:39:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Tue, 11 Aug 2026
 19:39:40 +0000
Date: Tue, 11 Aug 2026 16:39:38 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yonatan Nachum <ynachum@amazon.com>
Cc: leon@kernel.org, linux-rdma@vger.kernel.org, mrgolin@amazon.com,
	sleybo@amazon.com, matua@amazon.com, gal.pressman@linux.dev
Subject: Re: [PATCH for-next v2 0/3] RDMA/efa: Add support for 128B admin v2
 SQ entry
Message-ID: <20260811193938.GA661193@nvidia.com>
References: <20260731075007.3878376-1-ynachum@amazon.com>
 <20260809192237.GA15936@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260809192237.GA15936@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
X-ClientProxiedBy: CH2PR18CA0006.namprd18.prod.outlook.com
 (2603:10b6:610:4f::16) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY8PR12MB7659:EE_
X-MS-Office365-Filtering-Correlation-Id: 399353f1-a140-425a-cee5-08def7e048eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|4143699003|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	DZiZv+Yw130m76yDrl5KSbHf5hMRuQZaNpKzsfG5wKUTf6k02Oa+2Gm4k6LfzLOPT9Q1NOm8ItqGnlnrLSV+uEqqh5UNHrPUa8y7T6aZDgGKNuOz9dyfmUrdO75Oyfhm55gVh6Gxa4lEsbsP2c3OSYrr97ZvLNoY+dPYNTHTyb/7SY+zzMLet6bs3BQk7cOGgAs6bYhsxf/DEXvxuPi6ZMWM4hznTGFKeJOHGa2MG0ETT7SNDFUZJwU12h2Wq5Ob3DsL3JEDCO4ZTUlfmPOG+S0pIVRsbpPY492K4a+NWxu4H3WePIORNsbDVnUb9vtYyIq/gYxvb+aV8cRAniv1DJpbfy5vHy/QAVcayzZAb4nhBQSNpY/WgJ3er1p6/umAcV7JIKsOWnMk3Rka27rPn5IvWv7kdyJn9FrdDRD2dfLloQeReqEHkSwJ7IBwxm8lZRT2BDyAOHDO9oXIlvjC/iAG35jRmcCXZlNY43TMYvjgPZZM8YwxedVSi+QFw40/fwO/fRAdiNypA64ct8g8ncKmtn9fPSeLL1gJbyx1i/crI+Aoj38XRdok/FY1p9gBh/zmeRvYRCXWbHYHAim0iZCYSZjunht02y6o2Eq8UkVeYF2OtOi+TQgUHOKXjIqWmXczh9aDf4ItMD3AJ9zXCc16ca6H6Y19vQ6uYGWNn5Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(4143699003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?epo262ZBLRE6/JAuUgcXkuRMwBkj52y4pJa5Dhc0RWWSjq2ty732+pHBoTmg?=
 =?us-ascii?Q?aUSEBuWvv0WbF+n6S12yixqs1063n31lUa52C5UuVwrNcSbT8lfdjxc8I0c5?=
 =?us-ascii?Q?07IlIsh8F4hsbK1fp6PeiGDFLhtTFdEBva2zXi4+UBS56RMGIW3QWO55KFa9?=
 =?us-ascii?Q?EgntSy/aSatdQefrpCMuXi71IfsuMxZNLw2yhYWvGutc5AhUbYdlh39k9MMB?=
 =?us-ascii?Q?ei6/6RPi6rqhF9RHqNWO3Jkw+wdPWqouTWh/g86iOqbJzD+SpuvTQTQiQDtP?=
 =?us-ascii?Q?NlctHxsGu0VDT5omppkBM5EuibCa93J1Q7LMy3TsUQgg2Emw+V7ghRVY2rwi?=
 =?us-ascii?Q?gSWRouKpea4DYyB/os2QMkElNONZ2tB25UuOPKSRoOiL7IVFySkqlOM7Y2be?=
 =?us-ascii?Q?N/xTeBogjXit6MkWknG3acxVN3JcC1f+nqmV5KE6Kr87SeKVPFSvisLW0Elq?=
 =?us-ascii?Q?DAJYjlqd5KRG+62WDf6qkD2ssZbqkg8JMR02hm+MH6yXfFFod2Q1E1YxlNOY?=
 =?us-ascii?Q?X+SZAp1o17zwv4E+sTH14Lh73KB4Sv4Qt2mSWVTuXJKdWaaMsjPVQbRQGd1s?=
 =?us-ascii?Q?4AKx1nqeWx43prS7KlU9yXMag/0iZFaYli5sOPJPjGGgVSiLGkq6CoWBlxVe?=
 =?us-ascii?Q?b5rlj86RIk11Jrl4Y8CJPpH/wKgASi8HTlbSUYyQI8CTDfHzuc0fe4FxgjUY?=
 =?us-ascii?Q?yeZN2z+ydpwOWbD6SuWtxEKsq0CSovYUnC05rTJDQkfagmikFEUomXJDFo1U?=
 =?us-ascii?Q?HkdBxOnTIjVf1guGl8+hDnIRO+dX/UZw7HZKHWanDETQ7rN079oy948Aj9wV?=
 =?us-ascii?Q?B79EfEckaRDwMr4cPT3wIvD3cg83F2ohDiembNFKTHXFbfxBGRIVxcjDnVzR?=
 =?us-ascii?Q?yr8cYB9lJNelsY7+hMZtcPJKvK86wp78d9wOLHwTa4xH2vfPcHbyger5fHQM?=
 =?us-ascii?Q?8pi9MED6YXUCQCnNDdK34nENPRHKZhvTMTHH2cHqTGpEHrp8M0epeCemK7c7?=
 =?us-ascii?Q?7HOKMy8X7vQB3pzLqMbo7J97Iv1QBwqYvOxYfPBJFMbGN6KtpU0CrTCI8d0L?=
 =?us-ascii?Q?UzlrShmU2Db4UILgLiXsMY+XfLr7/0UgSCvRyzafZJlUpuUPTOQF3UhTyk4B?=
 =?us-ascii?Q?VGorLY16ocmJc7EiVRHwtRvSBpiQuxKeTBfg5TxRC+fUDmNDe3TI0Y1X4Uo7?=
 =?us-ascii?Q?se1kqbE0GSYWxARWPt6FThi4l7p+yqukZmUtW7HxipEKvsAYic1VlsS7d+H0?=
 =?us-ascii?Q?OzsVn+WtFonLKNXvA2hFPb5YXwENfkHBqmLD+pu192cXtvwcScPcqHOLS2Cs?=
 =?us-ascii?Q?mK+dK3R5O50FwxpI8RghmN7y+IXL+/1tsBWyCbu09L5McmUa0swsBnQjroqW?=
 =?us-ascii?Q?rwHhxh8G4DXjqE/QMl8appEioYgI47CIEk6eHekQGLhEI6a0xcWknriZaNCg?=
 =?us-ascii?Q?zpnWAc68Cs6sCXoWIOhBIOPiWYQHmr+AvQRNf9DSNlWIOVkhme3J0omn73vI?=
 =?us-ascii?Q?nhDgFNlL3tzdejVwROkzlqZlK5pCaTLuNq50L1SUz6f+nCdWrPtLJykpy097?=
 =?us-ascii?Q?+8ItbBSb0+yO4BQUyO4zQkAgNK17Z9T2+ZPiCBK3YK8l9Lm4tnC0DSShOM/U?=
 =?us-ascii?Q?ZNifXIFbbRj9+fFUo7BFWsk5sKQAa2Z2nx6brOrcrx7knC9NnWgrl+ESkYB+?=
 =?us-ascii?Q?X7/upHJ0zNY18ActRRL0kLZ0idEkSce9G/ays1ZMoBumHvsVYeWjwv4Bj7wR?=
 =?us-ascii?Q?Xu+lSX6vWg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399353f1-a140-425a-cee5-08def7e048eb
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2026 19:39:40.3967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CZbyhZGLu1mbt1yi6yqhYXitJYzDsTFl0J9UjrvNdxm1X+saX2F8qgS95fykF6Bx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7659

On Sun, Aug 09, 2026 at 07:22:37PM +0000, Yonatan Nachum wrote:
> 
> Hi, kind reminder for this series.
> I reviewed the Sashiko comments and they aren't correct.

They look correct to me, the stack buffers should be u64 arrays for
the alignment reason it gave.

    common_v2 = (struct efa_admin_aq_common_desc_v2 *)aq_entry;
    common = &common_v2->common;
    common->command_id = cmd_id;
         ^^^^^^^^^^^^^^^^^^^
Stores u16 to an u8 aligned memory area.

You should also fix the race it pointed it.

Jason
