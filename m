Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010002.outbound.protection.outlook.com [52.101.61.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3AD4582F3;
	Mon, 24 Aug 2026 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.2
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787593381; cv=fail; b=mTlw5cMs+vgRwyHpoOy1K1VL9K6H0cU4JWR7ns9YR9X7lQSZiteQa5rOZ1mnqtUrrmpPEn0f3bfaR6pCX8PON/mVnk6YJ+pQo5qfMhccaxAMkLUCPFMGyaEuujhWAlhmdF9X20KIite4pTI0nnNmBiREufsmRyg7YmizUJkSqmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787593381; c=relaxed/simple;
	bh=KGtr9U30HjKYVlAyc3IbD0fTACK46sOsI/VL/maf6jE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GmnCgGu5STAtKFwp/tiy+jJ6sFWY40dNA7sQG18pPVC4KRi4EnL3ZJcca3LokYmB9WDsMg8wjbBT1+h6ZUmunKDsEWOkiMQTBwSjAP+sqYwDAya6xAWq8F45UUyywxLPku0oh5fqfdiblDNCXOlojU0Gp/wVcA8LovU7E3Xpirw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NdRQ/ssa; arc=fail smtp.client-ip=52.101.61.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NdRQ/ssa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XerPmCCfKH/F22d2FAGl+XH3iQH8oFthnC8EhpVi4u4fmpjWA8dYqphqGfG+jI2qak3xDyvf1xGPRI1g80ROrmzJcMGjx+M/hUb259N3iR1P6DuMJN2QrsymCojKs92Bm/oPkETAuH76ci10v9vmTa0f0u4QKY9GGSK/7GyyvU66P7T3HtDtVpX/RWaPQ0xUno7Ux4y3HlvLj6dlzTh1DOmih1mf757E0uvmpvqZQ4FebSHxN7d+NF71EHjC6Q68E9tORKZglgtKWROmsu7MaDgcVJSssh5BvmWVBFNew+zP4h2QKnNGaQQYeQhUwbLLrD/sDfcEMjxEbuL6xJAMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F1ybBQd7eCRe/ek8iIUOxuTWXeH1ghN9Wr8saJXObGc=;
 b=ya7Fx3oFlXDBwsJN/oUsbHsbZhrQpn0ApRCp1Ebwxf9NEArZ4qPoK9hNVucqCSlxAcl+bwoSpFXRRw+lt6Wg3zm9hKYASwjwcHIm3TV58ts6hb5bTsnIBtaHrdnQFIVyXtAnT0lp8TDMlAwUuMpEeWpALs+SL8RZvXJrbZwRTR0Y9jw41RHIeHYdiDhQesAigXORpwdS8zbp/fIcZ+qSBRfjZyf5gM+pSgLCTEu65WbrDTs0mOtigHU+4Q4m6JsGjbvzXQE+/na7he6pAGEFXX4VXaEdeuC5JcABodUk4vjojU6N1r691kx2trCrw606OzVvymNmKRCXy339CfHsIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1ybBQd7eCRe/ek8iIUOxuTWXeH1ghN9Wr8saJXObGc=;
 b=NdRQ/ssauoyIFm4LXMaPYauO8TJGZiiO/UL8Cp/c9R33zHdH3xro4v1mzLZ6TEDq/ulFpqmaIcEl+Nv7pU3fFklG1owiXxffYEJVRBwlcEcZBqHfFb+98R06mr8kdEbb87jYktSyU1AW5N6TuYeYa55w5HEq/YGu82i+O3Z+r7vRoIQqiYsAHK+hZKTn+ocExneCSYeYjc0giNKHmPBR2yqXUTwmfhEVad+IZQvVHt1wjImes6PYpAs3ZJrPiVgujh+KqsWVJOLX7wrff7dNRDe43yU6alkdV6hlR3t+5YNIVjGOyexftAFTxCLqjs81rvG7fex26L1E0SrOXKDo8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by CHAPR12MB999249.namprd12.prod.outlook.com (2603:10b6:610:300::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Mon, 24 Aug
 2026 17:42:41 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 17:42:41 +0000
Message-ID: <3d72854d-98d3-4970-b3e7-c0211af42e04@nvidia.com>
Date: Mon, 24 Aug 2026 19:42:36 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net v3 2/2] net/mlx5e: Prevent stale XSK buffer release on
 MPWQE refill retry
To: Jerome Tollet <jtollet@cisco.com>
Cc: netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
 mbloch@nvidia.com, leonro@nvidia.com, daniel@iogearbox.net,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
References: <20260820151558.11015-1-jtollet@cisco.com>
 <cover.1787347981.git.jtollet@cisco.com>
 <675ce8a404cfe305e788a8e273b4091c9a90f867.1787347981.git.jtollet@cisco.com>
 <b4abc8e4-aa9e-4e92-97b8-c6a661014c16@nvidia.com>
 <20260824140943.20665-1-jtollet@cisco.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <20260824140943.20665-1-jtollet@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0420.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::17) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|CHAPR12MB999249:EE_
X-MS-Office365-Filtering-Correlation-Id: 5cd8074b-1edf-4afe-f789-08df020718ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	cu2Gu/Bmk0ysni7A1zzK4nu/5AZQR4MFMyHWE7oXouJlWbLad2CFlxfK6rMbUTat0BfMVqb3a8mFvBWwfeWgt3iHsnKsteKqqLjNjiqvIUTjfqCc2b7XrSltPw5ywChE95xcbL7WNpC6JcjmVHJ1i7d17BlosS5rbOj5k3hUtd+QpqEi97CxPSl0TTq+ZAk1S4+Ht1iilEXH36TGJaEME3FEVpEhpngkKiuyWWRVJc6fcNscUU+eXnQUvaKCQxeEhr+sqJ+ioPgUR4qiU+fTZn7eYrpdwLNC/CVRTujSfpThP2l/QmvU+/tfP/9uLVZcPkshSL8nF0Nk5j52lQsn4Cxk0pD0LTiKhCdqTC0K5IFYNaSDSi/TVLGZqlgplgbeUaHR6x4k4kajmL2rXyt0rgr2eBXuM6Y4slVruxIwQz8WvK5EGGle9kMvo3bywemPLT0qgB/Yupijsgs4Ow90I/S8lUsOFUf1v75EPESB9JNfnZUgiWP2m9RAZKrw1JQ+veYr7WhYuLFSH/E6rR7YgkdrCeapDoTuU2aL8pBsE7shFaSCV6RRLNfkBXIDNtegYcxptxOUAqYu4Qz8JmTthsJ91mPeXpDEnqaX88SZPIlvomAZERv41F12XAc6k4VAOlMKme1Hme+07OYGSoayRxInpHxGhD4BQvtrprtz7Mo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkV3M040VDN4V0U1SlozVzIrdWlzSHZaaWpRand3b0l1enlRVzAyeWlLN1Ay?=
 =?utf-8?B?NHIwdER0YVdaUy84VnN1N3ZWQkROb0MvNlY4RXpZNngrTnhaVUVHd0xJOWFj?=
 =?utf-8?B?MVZyTUN3azFpS2NpdVIvOTFyM0dlSzZDNmdYNDNwbXZJYldROHBPRW1jVURy?=
 =?utf-8?B?cnlnOUxQQ0x3OTkrb2hiRHNDaFlZYk9FSU9wVmNVL0lnWHNCOEFmZU84VWlm?=
 =?utf-8?B?S2lkVVVCdmVocnd5aWFCcDNFOG15WnYzL2s1UTlKcFB5SXlYdDdaUHgrT2JS?=
 =?utf-8?B?ZXU3VXdqVll5QlJ2MmRpanRCZG9aV1FtWjNTZlZJcU45S1gydTVidTJnOEl2?=
 =?utf-8?B?ZU9lZGNGd3EvMERsdDVpUktaemhicHdwZ0V6R0pmODVWZkV1dDBCUFNRZHFH?=
 =?utf-8?B?TTUxRU1uVm83ekR4RmxuU0lQUXV3eVRoWjdnNDQ0WXJlcnIweGRqSU5YTXh2?=
 =?utf-8?B?bG8wckdiYWl3K0RnaE95eUt5MHNmTXNndHBMQzZDRTZZNFplTjV0UWt3Tm5r?=
 =?utf-8?B?ZEgrKzBybTA3WGZ1TkU4bllZbEhsczRwUE1oempGajlOdWUwTmxHSUFTcjNt?=
 =?utf-8?B?UTBmckpDMnJvRUF6T0dQcDJmK1VtYXlScFlTVGR4Qk9XcVR6ZlZIM0o4L1Vv?=
 =?utf-8?B?RGxic3dNNU1wdVE0ZStvTTEzUnFxQXp4SHpmWUVEdldqNEx0bkZaclVzdCtB?=
 =?utf-8?B?dU9uZ3I2NUJmWC8zdXl4bXRBRTZWVU9WMUJEZFlFWDMzOHhZUVlQb2ZEWjl2?=
 =?utf-8?B?c0pzYVdhRVVXRDNtSEZkWWsrR1NNVXVRREEzS1lnQXJuWFBDc1R4V0xpYmx1?=
 =?utf-8?B?TlgrYllPTWxxSnV4T05mS29Naml4YkFMRGtNVVBxMEdPSVVLS2xpZW5GRlpn?=
 =?utf-8?B?bGlaeW41Q1U3ZVdqN2VROFhhZCtNZTJIK1N3MXNIZmdsQTJLWmJvcWQxWHhV?=
 =?utf-8?B?WXEraHBSQUMzNnRqeTJqcE5GZ2FPanVNcklaaHV1dHJEakZrc1ZyVVdndGhp?=
 =?utf-8?B?YXNvaklLeDJaamJzWmRqSElaMVRkSGs4WEplTHlPWDhkb1NoOE1sZDdjMm1j?=
 =?utf-8?B?VStSSkFNWE5ZK0szVEhTeGJJM25RTjZGUGZudDZyY3UwTnIweGg4R0J1bm1R?=
 =?utf-8?B?eWJvNkIzTlUyaWlEMWJrSjJJN1NaR0kzUHRrcFFZeWlweWQ4T3I4SmtzREpC?=
 =?utf-8?B?eE84UHRMUUFJa0Vza2RPL1ZIcHUycEIxTlZpV1V0RVdwdzY3b1FiUk04dXRU?=
 =?utf-8?B?ejNvRVF4N29KRkJNbTZLOXVqMUdVWllhaGdDOUJFblFJNEZTMHBKQ1ZFUWlN?=
 =?utf-8?B?R0RLN3hrRnJGTk96VVFBY1NmZnBweGxnREh1WWFYSzU0WWNZWHNkYVc1dm9t?=
 =?utf-8?B?S0k3WGpjQVc1bkpvN2RsblJ6VFA4Tk9aZWl1emZSdnUzUEFGUXRxaGFiamJV?=
 =?utf-8?B?bkhSWUsxV1kyRHhOT3pOV3U3UGpFVjg2bGdudjZzQ0FHM0tNTUxtN0plVGs2?=
 =?utf-8?B?NjhUenlrVFZqY3hrRDllQ3VNa0N6bmptM1Z6TzR4azY0Q3VLT2ZqeTZOaVdr?=
 =?utf-8?B?TExYeDM4UStuWHduMnBNN0FBSjR2bjgycnVwM2RweW9VZ2k2MHpBR2RDRzdC?=
 =?utf-8?B?TXU1UUdoRGsxMHY5b1JpOFZlMHdGaGc0aDdwYkhiSWhNb2doaHFwdUJCdTZh?=
 =?utf-8?B?OG1NOE94b3MxYkp2dXV1dW9NbTAzbm05QU1CUnIvRm9vaTErNnhUMm1mOE12?=
 =?utf-8?B?aEduZ1BwL1ZUdlE5TEJhS051NVVYK2ZUZGt5ZWpCSkIrUGF2dmRWNWREdFAx?=
 =?utf-8?B?UldJSSs0akVSdGVpSmN3MTBYSjFRNmxaejBDdERKZEc0R0FiUDQ2eGZtbC9a?=
 =?utf-8?B?dE9tQjNJcmhsVXNwcU4wMWNJSjUxRGdjd1VkMktydVF3SDNONnYvbnNmcVdi?=
 =?utf-8?B?RFZlcTBjLytDS3QzT2YrQmJWeTU0V3hNS0RzR0VzRGFsRUFpRkdRL2RPWklQ?=
 =?utf-8?B?dkpTcFk3T21wMHlLLzdrSlZnM1pTZzdtRE9NaklIelRuVG9ldjlUWFpYdWRv?=
 =?utf-8?B?dHBmS0xJRWlzcURXZ0dRREJqeTlTbUFiSTRoOS92ZW96TDBOa3RpakJPaU5V?=
 =?utf-8?B?S3J3K2NCeDJTUlF0eU84dm5Zc1Myc2VRQTl6ZGR0Y0kzbjFHdVFvWWlhNjV3?=
 =?utf-8?B?RDhTVzFXaW1YakkxaGxvclVwQjdtMnI1STBJWW16eHRnNkhVeUptVVJuSXZC?=
 =?utf-8?B?TlJPT2drSEFrd3pudTY0MUpqYXdiS1g3clpsOWMvMTJkUlBYdStEY1dzU2JN?=
 =?utf-8?B?M0pueWRLQXZPZVlpMUxQT1dxMEhHZ3JUWTNPbkprWFYxYzNQK05sUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cd8074b-1edf-4afe-f789-08df020718ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 17:42:41.5169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fd0ElS3dL/Wl8sTp/SP9hRV/IINx39YdCNAeCkooakwrXt11nR0EXfry2zhvtHT70SabovWhjPPO2nI3hbcMkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR12MB999249

Hi Jerome,

On 24.08.26 16:09, Jerome Tollet wrote:
> Hi Dragos,
> 
> Agreed, thanks. I changed the patch to set all skip_release_bitmap bits in
> the common error path of mlx5e_xsk_alloc_rx_mpwqe(), consistently with
> mlx5e_alloc_rx_mpwqe().
> 
> I tested both early and partial allocation failures. With three consecutive
> failures on the same MPWQE, the original 16 XSK buffers were released only
> once. Retries observed a full bitmap, and a later successful allocation
> cleared it. The partial case allocated 8 of 16 replacement buffers before
> unwinding.
> 
> I also ran a 20-second AF_XDP zero-copy striding-RQ pressure test with the
> clean patch. It exercised 1,575,262 XSK buffer allocation failures and
> reported no invalid descriptors, WQE errors, or kernel warnings.
> 
> I'll send v4 with this change.
> 
Thanks for the v4 and the thorough testing! v4 looks good to me.

Thanks,
Dragos
