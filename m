Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5753B3896;
	Thu, 30 Jul 2026 08:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785401266; cv=fail; b=ah7dx0Er5gERq2abAgCU7V5vb9JFoMb8pv5XhduXz1jNjGfXPajPtpAjraJJgH1tGWWkh4CNwL0sn+hC2N4wV55TB3WkDpA4f4STOza1w3KM4Pi2ApGf25D1qfh1TLvIuH5k9yaXIsUsA9rZ1LQOB6ZM4MijI65X50wJasCGjhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785401266; c=relaxed/simple;
	bh=cOiMhwQN0CKmT2qlBWAdpCvkSvaseyko2XTAIn8B6m8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iwI5sB7P6GkJ4HppsjczoQlKrPS3TQ/j6L9v4A3LT4hi7smG4YFQxYmGd3yJNuML1sZoN9hFAvwuEvtcIR1mb/kwtrqnLpjb7oLEpxVDG5UZv3jFeED8Qj83UmSDlUXANjZtlaQTI2XCAI/X1rcQUaDYAfUwfJJVFFNPV3GQXEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=S4wlh4fx; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="S4wlh4fx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sfXzp9mrpyRoXjTT6LhNXoRyEwqWg7v9RlooARaFPa40ObnjM2idtltwohm9jOa2qwlvsYnJfR/sqtk4luCwNuy2u+lcLbeSRb/xXDJYpRuqtbVVCiMPhj5Vn8699YD4VnQlqj5SSPrACqghDt0aAaKW+TYUckoBzp1uDRKVVSusOl3U0GqY5FVy0d1IH9WwmUu6dlr3Cffgs3Q2zm/kz1+qXkAGkBZ0G4j/4vC4rr22+5tKzXYTRT2Z9jGufMh48EpiBn8wz/xtsyjsJm4aoOTtVEIP4i3gGB2BlbP++1etV6kl8RyyU1J0YZnxzGgXBCO067SPalnapNl1Bro4gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOiMhwQN0CKmT2qlBWAdpCvkSvaseyko2XTAIn8B6m8=;
 b=Q2yb7dY9o20BNFTq6si9CBM9y813ATAk1FAcKT7l3LquYIBoTyuW3ObONGQjAaFaNWKgkBC9l4/394W7WIg9OSrRU9f+fWJcVs4flbhDIKGGMB8w5d1RVMKSfJDZfiPvkcbjr2yBk22KxPzSSBlo6+TVGDWonq37l2WdEwWTVsAtV2J6Dzhg1kngPwal2uzdW4jn+Ja8C32nPlT96wzfVtXXTgQRe4cIPrADRSdIyOouZjxmvYssDWmJvVRTQ7vackUvEmcwuh10S5UEehnel+G9YIl+qoHDF2xsvxWIZFKUvm+lKF1M4FMtcFgPhTSmKihdYaEfvsKxxTyFPcqwxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOiMhwQN0CKmT2qlBWAdpCvkSvaseyko2XTAIn8B6m8=;
 b=S4wlh4fxWN3PIB+HCdSsl0szLslrjG7m9gCGTWdwcX75gskd8PPa4FQovoNeFDNYnBZRpEFZ1TLhhU4CBBQSgkKnTUhy7DtKEUVedwV3FsGh213xIiGtSJUbHejpAXYHnt0m3T/VQeaujjPWYVhni9T+u/uNERBClTwOs183yDU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB7777.namprd12.prod.outlook.com (2603:10b6:8:153::22)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Thu, 30 Jul
 2026 08:47:41 +0000
Received: from DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74]) by DS0PR12MB7777.namprd12.prod.outlook.com
 ([fe80::826:25fa:4fd6:2d74%4]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 08:47:41 +0000
Message-ID: <31315f8d-44ad-db97-4cb3-ffae887d7bb8@amd.com>
Date: Thu, 30 Jul 2026 14:17:32 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>, leon@kernel.org, jgg@ziepe.ca
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, allen.hubbe@amd.com,
 nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
 <20260727182825.7b9bdffe@kernel.org>
 <18c6130a-c8e0-8e58-ad1c-f1578e1c5f46@amd.com>
 <20260728151058.17f8fc94@kernel.org>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260728151058.17f8fc94@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5PR01CA0139.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:1b9::12) To DS0PR12MB7777.namprd12.prod.outlook.com
 (2603:10b6:8:153::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7777:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ae07855-983f-4666-cbcd-08deee17372c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	D1cUhxG7eBLMWmJjSq91TXmNLMjweq7nIBvVgAr6uln865IFWSHW9CEIvcpFjiLzXts2cezr3SM0NNA7w7YwbPG8r5j1WKDGQGpVJpBtSihTgGcIQ+XsWb4/549Khmdn4x4avXIR4DyztueEw16WfZ2L8s7OVGhK8ql5GzGoykpbgsU+oNXy+d/LSxxVjNhIjR5VZupSqhO0mHWzS3BrgYfHUXDcmXhOrAbmGKWlvp6CXSKcYeRzRScIYw1Hhrn3d+JPldBwC+XXPe/MUerIemuobzeVNmQt5HDs2LC6q/iryDpMrc86QjDna/gyUIOEWb/Uxd/dcUMnuovG53KX1WBAkRVDrMofR7yTDTNZzondNT0Ta6vyMQcDxyv7B7i2woPLEQ5cECImizkCLvyN+f+tnd2y+/2BPEdDV+O/GAl9XOHhbA49IZwHMDUHXn9/JeNJb+yqMAP3wuJJ2HZRmXgXnXsRZr0nb5TcOB8LYaaE7O207zKqoqBfTw5HNwc4LFLRydhNnUsTj127DAER+KfyMVXR+kwGZAR9FgBeUT0LGywmHiaBz80/w1cMoMrJhYf0zAUyFS8UD6tjr7gjgCcvgxtMndIvDNJBGE+fSVcHKkhwc9dHW4sVW3PEGsIPh8YRNmYr6kaWdbu5gZK0E1DA/aW8FlBJxRYNNsZTteM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7777.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEo5UzBId21UYlZjYmZDY1pEaWxtcS9uUkdpUW9xZ2pLVzAxczdTYmdyNU9y?=
 =?utf-8?B?V29sN1VJYy8yVUZZaXF0K3l2ZGtMQzRZWGF4WEtpa0o3VDRoSmpFZjdtbnRU?=
 =?utf-8?B?Yk1uWWRQejVqbWtyQWFtVDU0VE1DS1o4N1FUQWtQQzRFcWtweEZSNlFseENM?=
 =?utf-8?B?V3NBMm0xdm5lRkZ0U1hEclBMVllaMmk4OVBaOFI5YUdHZWQ5Wlg4alRnN2Fw?=
 =?utf-8?B?M0ZkSHkxbHpBVGcreEFwU25nWEJvR3MrRnFBYW5tVi9adFlDSXdWT0xxM2d3?=
 =?utf-8?B?WVJ6bzZuaHFuRGs3TGsybWVIaEpXRDArVVREa3JMZCtGL1lIazM4NjFBSEhF?=
 =?utf-8?B?QTZxMjhGMGk5S3NwM3VEczBFa2I5cGR0dlJaRnUxQVpkQnZ5MVV2Znc2RHhM?=
 =?utf-8?B?OU9NRTUvWEhDWEliQ01HRFJvQWpvUVZTanBtVVlFTFVQVHEvWHVpVXlMYmVj?=
 =?utf-8?B?eGMxclpzWTVxcFM1WENIME13YU9OQ1NWSUk1S2c3OW85VGZrcDNNT21ZUVdM?=
 =?utf-8?B?a2czVXhKNU1PZnJ2dU1JU29vODBUSlB5SGpLMWhWbENMQ3RiT0tsRzJWQTlu?=
 =?utf-8?B?R3cxSUZnb05uODZQeWxxTXZ6ZmJERnpZK3g5L3dhTkdNRlBoaXQ2Z0l2L1Rj?=
 =?utf-8?B?Ymcwek90cUdWM2VpaTBWY2M1RUNlL0RXY3E2STI0bVZtZzlMQ1Fua2xwLzdY?=
 =?utf-8?B?cUFyamd0MjNkc3FZZE5LOTRvMVkwcHY5QnlQejlhajRrdVRDeGV2NG5yRmxV?=
 =?utf-8?B?RUFwR0lTVllZMHc1Q2o3VS92QjFaK3JxcXd3VnVIQTgvRkxCTkFzUGhlN0Uz?=
 =?utf-8?B?MHVjWkxzc3ZSMUl6WEIrdGxvcC92VDdKYXJsNW84VGpNYzNvdHBTNmxKRFFn?=
 =?utf-8?B?cTJDVVA0QWxKR1oxTXJveU1JS1JjZkY3OVpqN0NQcGNlREhLb2lXTVNzZ0Fh?=
 =?utf-8?B?L21KTHBZZytBSThUbW1UdDZWRnNIT29OYnpPbHJoSnNpbzJwVWlUeWdtNjZu?=
 =?utf-8?B?L2VadmNwb3BIWllERHp4cHlwdmRGbmZ2cG1sQVExOHQyelJYTFJ6RlJBV09G?=
 =?utf-8?B?ZUthOG96Q1JBM2dpNnhUY25KQXBaZEhxc0oyeUtDM3RPYTBmOUdOZExPbUJn?=
 =?utf-8?B?RnNpRWdvK2EzbUgydFZ6SnlzRGJYMXJqY1BqcXp5WVY2Q0dabE02Z0xNYVRL?=
 =?utf-8?B?U01VWCtPcDhCc3NsaTBiRVVEZllSUkFRbnA3VHdZRUI0blhiVzFqVjBSWVRl?=
 =?utf-8?B?ZUlheUs0aDFWSGFsanBzeG13RlV5VHczYzduQzRPYklzd3FHQkEvblBOY3Y4?=
 =?utf-8?B?VE5mWFBsVjUzMHM3YXZ0eHE2M0k0SGFPNmlQeGxEbFNycHA4Q01mNUg2emJP?=
 =?utf-8?B?WmtxWnFOZmdTZkdRNXloZTVHbVRKMUYzTXd5QmxaaDNvSk93WjBkT0ppeWlq?=
 =?utf-8?B?SHNTVUUzNFc3THUwUmhiUHB1T3R1Uy9JSWE4ekFiN0tnSmRYdzZrY1pWb25U?=
 =?utf-8?B?NmlYWWsxSkNjQjBJcmxrYkFMMHBvNUJNdENTZVZjTTVsQjhxZGI1YjQ1NGtx?=
 =?utf-8?B?NlZSVnVxUDFNZlJDWDJVUmFvdHdZeGgyNFUwTUtVamM5U1drQUYyNDF4bmVo?=
 =?utf-8?B?Z0tMTlYzRzRudDMyU0Erak9nMHQvbUJLbXhkT0RLRkFaZ1hPQXhObEkxMFRX?=
 =?utf-8?B?Yk14ZXZDa1ZvSU5xb1FoUFB1NFZ5MkJ3UWhhQ0VIWUx0TnFKdDk3dW80dkNs?=
 =?utf-8?B?V2p0RDNiTVNKc2NoZGVZU0Q4TU9YSmd1bmVVSWx4V2d6T3Q2Tm0zSktvZUJF?=
 =?utf-8?B?ZlduT2FPL3NLNzVNS3d4V1djK0dLR2RKaDJrZnZDMStNZDZneEM4R3F6Wjk0?=
 =?utf-8?B?eUFCYThTRFg4bEtJOHpheEY1SUdsb2lZTjZDUEJ4SUZyd0dhVEFidTJJTXUw?=
 =?utf-8?B?RVBKNDJhUnB2Qmh1VjdmZzNCWUNBRm16UGRmY2YxR0tqcGRONUZjSjIvaWdH?=
 =?utf-8?B?V3l4a3dwK1VCb1E4YUM1azF6MFEwNkljQlpBNmxTRjFiSnBEbFFuYkhWZU5Q?=
 =?utf-8?B?VEkvWTRXejFwYjQ5U2NhN3JQZmFMVk1admdubjV2ZVgzVzJBbml5clFkY05Q?=
 =?utf-8?B?bWNvZ09DT2ZTRVFDSDJTb1BubUE1dlc5R3R4YkZMV2FDejVnQ3JwMXN6dXBq?=
 =?utf-8?B?Ym16c1dLMkpqZmJWNXRRT0wrYWhpZ0QyRkpiTTRiSlNmQlhFOUpZWEtsYkth?=
 =?utf-8?B?TXROS2ZOTkRpVEdSeVVYYWlhVXN5dlVyazNvRW5rZXVCbytJemJnNjNUSzhZ?=
 =?utf-8?B?RmcxaDZ3Z3NGOFZLbFJFZG9rTjdaOWltd2FGbjRYcWVRekF3YnVxQT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ae07855-983f-4666-cbcd-08deee17372c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7777.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 08:47:41.4308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g35fybmOTZP0dLKbbU/MgFPLmWdJhYtlcQyLC59TC9sk+ufZiwRSkkapKsSsNH7CrVnTnl3zcYZHj5v3YWKA2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175


On 7/29/26 03:40, Jakub Kicinski wrote:
> On Tue, 28 Jul 2026 16:48:25 +0530 Abhijit Gangurde wrote:
>> For the earlier PHC series [1] Leon picked up both the net/ionic and
>> RDMA changes through the rdma tree. Would you be okay with the same
>> approach for this series or would you still prefer a shared branch with
>> a PR?
>>
>> If you'd still prefer a separate PR, I can set that up.
> Send the PR for shared parts, please, that's the normal process.

I have collected both series patches on below PR,

The following changes since commit f5098b6bae761e346ebcd9da7f95622c04733cff:

   Linux 7.2-rc5 (2026-07-26 14:45:48 -0700)

are available in the Git repository at:

   https://github.com/abhijitG-xlnx/linux.git ionic_phc_rcq_shared

for you to fetch changes up to 43aefbd7583f5acb3d689675028f0e49a0861ad7:

   net: ionic: Fetch RCQ sign bit from firmware (2026-07-29 06:08:09 +0000)

----------------------------------------------------------------
Abhijit Gangurde (3):
       net: ionic: register PHC for rdma timestamping
       net: ionic: Add PHC state page for user space access
       net: ionic: Fetch RCQ sign bit from firmware

Thanks,
Abhijit

