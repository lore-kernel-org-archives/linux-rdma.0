Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010045.outbound.protection.outlook.com [52.101.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CAD3B71B0;
	Tue, 15 Sep 2026 13:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789477298; cv=fail; b=f3E5sC27bpUPuHy6i7OrTaE08FbEr4jpHZ5PNL/5rmkguoQ+yjhX/182Ey/Ejl+7TVkWhUyShI84O3UT5jKJDfVT1iR35MBW1JC2n/O7AmB/UrY758oM1BFKdQpeb8gZYd6+zktruqLlKWlJMbA0+BHd+cGw/2M5nfMb5tprlVI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789477298; c=relaxed/simple;
	bh=TRD/79/3sp/CuwL/PmxjM3Q+qrUuYxiX79OHqSHMq7Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jj5DtdVmNMT21Zk7J2xI64XDf1zMt3C1VNXZ95CMXpwxE3461h0ZQXsHspyAM9Y7+vcBLf13nG7LErzzxiQJ7EePO6iH6EoVOgBc/ofTQbQB6F01rTrsz3vxc6JJt5RmbbrVVJZ9mes+YFK0h7UpfEH4qM8a9jM2NfMNU/EuVl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=v/RIkfQX; arc=fail smtp.client-ip=52.101.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="v/RIkfQX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M+zhfPNiAz7Tbv+Mv/kgDj2n4QV3IlTqU1b3+UMwZp//lhKBqVUEKrVqrerGtj+gqhMKGlIvPQ3ew22e7ir44sy16K77cfhTh++wj87wGAlH+ItqQWo308EeKI9t2JJNfWxwYQNo/ykNMj7S2AWrxZQ0bJv88QxyscLutbu5WuvETO0SWW4X37UfucODItvSUH83JydGY9kOm0N2l9j4hw5ygA4SO/hI+15/bB6zmu1Qw7+xn6vamp76xuSmBqP2VHFulq80DvhVqAsB8YgZYgJXm6KPwAyNmITgcE+yBH+VP+S9p9vTdwgQ1Kuf80jdxUXa4Yv2oRBqfFDPoMKFLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZJ48K8oA+68hHT3CzLF5VhHobGmz9qEpyFGcmmqp7I=;
 b=tQqsyT4HJD8IXd31n2wiIZ6t3Q4LQnIqgvlqtbZ21C0dExqRoWw1C0/lU8uKDFLglEbl/Cgr465mYLfsBsTTNzYg7yk4Via3Cb6hLJB9fgwajqZKeR2H4rH4C9NCaPRnWDpqg4k4eQDGqIRsoO9lYRtFBuOqR4EDX3/yclQiIYAUH26tSIsK8wc2I5LPjoFiZW8dTOADLvMcekbOMp0Ykq5eL4VdyRO71DxwQRaNXapQsgxkg7id7Oce04STXQqA+vPPvEqbeIKO2bUTANkigs2os3y9MAGJzA2Ggv0C8bw0oA/nVlRsgATubxgrxv8ruYx9LX8ctO6pkdTKInn4oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZJ48K8oA+68hHT3CzLF5VhHobGmz9qEpyFGcmmqp7I=;
 b=v/RIkfQXPt6ewDSDR/1thJkfiFjICW6tbNqfiqFUNLbNDhnriFKBuLgeUP4iyCVJ/P8s3BFXe2pB+xSs3AI2RXGNuivDH9JMg7AF6R0PnufmlJVImS1/Ib5xat+ccSgul0dcPOp1c74vzThhYCCcUoSxOnEKxQpAGnXIIm8etIs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by PH0PR12MB999089.namprd12.prod.outlook.com (2603:10b6:510:38e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 12:59:49 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0428.008; Tue, 15 Sep 2026
 12:59:48 +0000
Message-ID: <92950084-ddd1-4868-a81a-bfe214184122@amd.com>
Date: Tue, 15 Sep 2026 14:59:43 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer
 access - ping
To: Leon Romanovsky <leon@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, kvm@vger.kernel.org,
 linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
 dri-devel@lists.freedesktop.org, Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex@shazbot.org>, Jason Gunthorpe <jgg@ziepe.ca>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
 <CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
 <CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
 <c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com>
 <20260915113752.GK13683@unreal>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20260915113752.GK13683@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:335::29) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|PH0PR12MB999089:EE_
X-MS-Office365-Filtering-Correlation-Id: f6f4fb8b-83f5-4e83-7307-08df13293920
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|6133799003|18002099003|22082099003|4143699003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	zaIlRtkgcyIuSbg/5xpDV7dmGYtwnkGZHVFTOobj0Pq4wWePt9sC8JPv1MYAVjcXnaukhygCaojIICto6d1qSDt5VzLfGltV2ZqGNVLwfXwI7n5fdHsd/Spso9K/V8rXiKOgeMSAgKeQHay38qV5Ck0G0AoAbwG0ogV2Z7nRmlWB3o5FJ8V9ZY3C+HzIIg1ZTyNYdCf9ovnaBcsbXSXDXpIOK9Nzz23qkPhsbbMeZfRUztD/0lccuqNOABR6rDZ6Y3SQK06SGXBj6/498i3PiKOz9+8Ag26MR5jY2NFOE85o1ABWSdbQzQuAptiGZg+9b3ADNKWJ3at730+UiyS1KGixQN1d9/Pa6Ltg+meOztz9Zo0v3H4wZfdxLUtp1rbFOdnUOLx7BH/8ZFHgy+RPpy/20DxlTIxnCfb872IhsY4gPaw2R4tVzK2mAHHCZtWfrSZ6VTdn5RGfhbWZlJ2Cg4A/Ulh50reW/bVQd8/CYac/j+zLbFMZZegBenehh2n4TlS+XAMXps+oD0bqvstWFo9xDFCnPHIWhcLAwVoOWINmEGf4K4JOKPiHWOdrqyIgHeQBjKAYjbCh039r4MmyAQYI3ScrEbnFgYPx/K+63vfQTB4uIGWdUbBB+GDgEhS67mSPWmm+s6Wue4yrFpUpUwTzLd2hthVsMrnq+xChGQc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(6133799003)(18002099003)(22082099003)(4143699003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEhROWU4NlFOaHNseHB6OS9GWmZmdUpPU0pFeWFBajlCRVR5WmJJY250NmZN?=
 =?utf-8?B?Yi8rRllYVW5WSTRlbXFRd1ZJNGpqN1NQZmlXVysxYmdNQU1KdllmcG9rT203?=
 =?utf-8?B?L2psL0Y0aktOcWhjU01iL2ZVNmZpMzdsUTdPeWZmL2xzRGZ2cEN1d1lKaFkz?=
 =?utf-8?B?U0FpdTRkZmJUclkweWx0enFxQ1l1WGpMcnJLNjEySlFTbVpOL0pXRGs3TUN6?=
 =?utf-8?B?UC9FWjh4N29GSnRoUHoxRFFJVGVkMmN5UXBvdWRFWGQ3dUdFQWg0V2xueWJt?=
 =?utf-8?B?WUM3bUZldDNZUGxVLy9oL2RQbmt5VHhvRHB3UE5vMXpTSXpIdm9JZXhSc2JK?=
 =?utf-8?B?a2NwTTIxZ0dRQnkxZDFLbkd6enNMSGRFaEhpcmdhOHliRFZCSzJBTFlZMTFH?=
 =?utf-8?B?ajZCTmI1c2tia1hTVEZRN2lUYVdDd0crNEZvMUdsUklsNTU0RGdRTE90czNY?=
 =?utf-8?B?bzZvZlRNVjBFaU1SWWhyMnJCS3JBcjNoOU5Teno0TzdzT0dNNlhxdlNWUkVW?=
 =?utf-8?B?bXRGWXg0c3QyMXUwbVRoT3kzbnRwZ1pNOHZ3ZUcwM1VtcFFtUVFGU1NVRldX?=
 =?utf-8?B?YzBwS1p1R2VTdk9HaDVRZjVkYkJtNDFOTEFiU3UwcitZY2NLZ0F3ZnNuNHRQ?=
 =?utf-8?B?TExKcnBoRFRKbHNGNWZBSTd6c3gxOU40bXF6RnE0WFZ3eGI1SVpKODIxZXQ1?=
 =?utf-8?B?YjZpclhpeHVEeWxBakp2RVpaVW92Nld0d3h4aVVzbUZIRmpVSnoxMElTdWRa?=
 =?utf-8?B?eGhXdEpiT1R1TUlEZU5YTmNxQmNwOGRkczJvdEJJOHpPaXEwUmtFbFg1MjVX?=
 =?utf-8?B?MC8zK0xVbW8rM3pZeFZJbkkwdUhVdmUzMUVGRHM4cFFDQlpodlJRVS9TaFJM?=
 =?utf-8?B?RllRK1Q2OGVOODkxYmtvckxIdUV2V2h2L1hrZElEclVlMWo2QnBYZEwxUmhv?=
 =?utf-8?B?bmNtTklEcjl4czVTQ0xPcm1WNWFrQ3JnTWF2RlZXZ1EybGtSd0pXNVBOaGZz?=
 =?utf-8?B?WFZQTVEzWW9mc3JGMnJESk5PY0hBVnBwMDFRNDlkZ2RVbVRWOWxSMTB2d3ZW?=
 =?utf-8?B?MGJZRXc1MGVkS3MzdjI5MTJjc05XRHBVODZlN25UWnFuTzNrT3V1N01EQmJW?=
 =?utf-8?B?Ky9uZTA2K2FJVEJMQlRpVFpIZkpFdHV0WWozakU4d1JTRGVxTlJvM3dRL3c0?=
 =?utf-8?B?TUVJN1ZQaDRwUmZKYWlSbXlSZG5tMmlKRkF3R2JYbENWTVRNbHQ3dWNTWVJv?=
 =?utf-8?B?ZStrand0eXRjTzVreW40MXptVmxjVmZmQ3Y0QkU0TitwdDlqRGxsMlFtNVI5?=
 =?utf-8?B?MVRmSGFwRE1nTUVpTWxmTzhKTmdnelV6bGp2Y2hGUitLTFlmWGsyejQwRGFF?=
 =?utf-8?B?SjNZUlZMZWgyeXg2Rm5nOTMyS0JlYjMzRVh0ZHhET01jSnBIWUdlU0FvSUVL?=
 =?utf-8?B?K3d1bWpQaXRQR1lrUHA2WEVQMjFwRzd3aG1BM1NxVm5wd05vRmhoRlNHRStu?=
 =?utf-8?B?cDhhWWoyMnc4RG5uVE85eDFLdTVRcjZveXJtS2prZm9XWmVQZXM5TDRZVW5Y?=
 =?utf-8?B?ZGdWd2pMZWFmbG83YXQrL05VSTh3UGM2THpkRGdmS21KNHgxclh1cUUvS0lE?=
 =?utf-8?B?dWZzN1R2SXFBYlJOcEg1YndUN2RjSmtLQU9aTkg2MUZQZzNCOWdxK05KdVR2?=
 =?utf-8?B?MTYvUGpqVEFWY283blhubldXS1diQTV4bGczalZpV0NIWXlhbDMwOUhERS95?=
 =?utf-8?B?S2hxWm1HWXkxelpteGd5eDRKYzl2bTNUS1c4VmYwdUtyL2dhUWZDa2FjcW9Z?=
 =?utf-8?B?NUxxRm5rUFUwdWVxSERGREdkNzhoUUs2MmdOMkZCR1RaZWJSR3dPNDNRSU9t?=
 =?utf-8?B?Si9sQVkraWJFd1huTlVHVW5uaEh0cEhMbFk0VnV1OXRJOWgzL01nL0VETkpk?=
 =?utf-8?B?ZkowTHo2V1JxcnlHdGZCblRCcG5hRnU4TzdOQXkvVW1SY1g4TVJJY3VPNURr?=
 =?utf-8?B?c3J3NE9KRkdzWjRBaEo0RmdwVkd4M29rSEREM1lnTk5MK2tzNU50enJaMkpY?=
 =?utf-8?B?eklaZUlNLzkwNmJxZ2U3UnVTOWxKaUpmdVNoMjBrck54R1ZzVkZER1RrZDhi?=
 =?utf-8?B?ZDg5UTRmdS9pWDgvWHd6dFJQTDJ2RE9CUFkzektXTFdIZjltbDJBUjFyaE5Y?=
 =?utf-8?B?NDJNQmN4TTM5Y2xJT3FDYktBc21qTEY2ajZMYzJMWkh6b25QNTVGUVlZcGNH?=
 =?utf-8?B?T2l3UzBqdURnbHJWN1E3SFhudGZwcnllMVlQbG1VZ25ubzB2VW9HTkNHT0py?=
 =?utf-8?Q?CnOGdQXYs/NTkVCZ5V?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6f4fb8b-83f5-4e83-7307-08df13293920
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 12:59:48.4785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cv+SyezcLniHRkXkzwCbOd6ObhQdTEMr8MkzKYaq6I1SQymMWsfowaT3V57exdIx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB999089

On 9/15/26 13:37, Leon Romanovsky wrote:
> On Fri, Sep 11, 2026 at 09:58:28AM +0200, Christian König wrote:
>> Hi Zhiping,
>>
>> sorry I'm completely underwater at the moment and don't have time to take another look at the full set.
>>
>> But IIRC you already fixed my documentation requirements and skimming over the patch once more I can't see anything wrong of hand.
>>
>> So feel free to add Acked-by: Christian König <christian.koenig@amd.com> to patch "dma-buf: add optional get_pci_tph() callback" and push it upstream through the VFIO channels.
> 
> Christian,
> 
> I'm slightly confused here. In the other thread, you expressed concerns
> about having PCI details common to every device in the P2P world in the
> dma-buf code, but here you seem fine with adding a niche P2P feature.

That one is only using u16 and u8 types and has no dependency on the PCI subsystem whatsoever.

Giving those adjacent information sounds perfectly fine to me, we just can't have any hard dependency on PCI subsystem types or functions.

DMA-buf itself is massively used with vendor specific P2P interconnects, PCI P2P is just a special case of that.

Regards,
Christian.

> 
> Thanks,
