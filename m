Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010033.outbound.protection.outlook.com [40.93.198.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3497957C9F;
	Fri, 28 Aug 2026 09:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787907779; cv=fail; b=SlnXzemklqzx8/UCgnhQRHtSG5/7rAc+i56XwXb1zjvIwUi9KPwzxqdyp9+w8IGSGOeI2cLlFNIbIcAe13AJE4XR94oUahNIvN1xvHUh6oqV8a02blbRq5WnsAq9gGihBvuBam9AhDLsOu2zGnxLbE8ZlG/2u76ga7D1lq7kbn0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787907779; c=relaxed/simple;
	bh=i1EieOvBXIVEWHy4/R0ljGa8Tt5x3HPckkyRE7MbDOM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TzsyH4Lk6xrE+DO7nfms3Zx5tW0C3R2sbV79Hdj5QAdvQhiqs+/cSHxRTT1g9IVXRKOUNbB8xu1u7s2atyKKzSrQ2vHuLM0qlDXG8v8XSlF+Ym7DkHNtDoCNuSfDKsVy5jz4YYwp2y85KAts9JJZ1+xhQeFMOBtm5fcU91LMOxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d3jV5b0c; arc=fail smtp.client-ip=40.93.198.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d3jV5b0c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KiMGhKYX8tu9203wK3jEgQ6fDwklVwf1wtav/pJJBEgyQDo+lD+aDNWM8QVXS8X3S+0IwkcM2oSIuKVjluOWxiiTeNaj+y9D2eE8tP3I81EsPynT/V/v3DVOg0qtw3sPJhI/Lppf+2Cl2BhureUrWdbEMNxqjFzhotbtyy08fFRw8Y7o7A9R9ONOpqhOozpzD1eJIvJ5E4Y8Nc1RwCqmc+n8Q5Hq30hd/UKQLTIm44xi7WE/XW5CL6FbAHHu0E91BKi2xyVTa3Bbn8QZgoiY+yjLpkVBGGsd54jfdSCe6f8PAe2NdyyxV5WHCyenkhuasSBFpXH1eV4oQoWMnv+Bqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqTaRsFBWt6BXtQG4oFf2rK4+xdTxoWl4UbJgVMnOE8=;
 b=JDOO+ZPRRk0YSNc7eGtN/lsJhPPbht2SZrQx8xPjGiTJtBHG7S6avN0TKGcn46SGV9V32POupYuH1sfxUDKrATmUTi12sZ27yu3YpxlkTpxw0/JzVmVCkIRUto785Hv3Et2XmvCmED1IfCtUL1lBeWQLLd9L2jJGDToQa7I3D3golxHiDY3rvbHFeJnNVgTTroMK5ajrQxLA2mwn6PkooEQg5d9rBSP2sMp9W4P+i8eIYA0v45ywO3hKAXdiP/j3YW1YVMdUzA7XCuyyhJdXDsqC6WvBBS2bQepnigeeQfQ/dVqCpkKdOENAfKNX3YUdV5CSXXtBlbVogwusZsokyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqTaRsFBWt6BXtQG4oFf2rK4+xdTxoWl4UbJgVMnOE8=;
 b=d3jV5b0cyh4owfzwq/ISOE3iTp+pOeh7MBsJ29x8WV5niQ0qOF3uY1bc18wBG69NXdCyHQDP0aT9YhDSyQi/m9042glIHGTrWrEtTS4xuXdJfrHI45sS4m6i86EkJRgqbtUZ/EM1JJo+85UcGW0dQDsFvcqU0DeOBik9LAVlizg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14)
 by PH7PR12MB6718.namprd12.prod.outlook.com (2603:10b6:510:1b1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Fri, 28 Aug
 2026 09:02:55 +0000
Received: from IA1PR12MB8287.namprd12.prod.outlook.com
 ([fe80::49d7:28b5:dabc:ba95]) by IA1PR12MB8287.namprd12.prod.outlook.com
 ([fe80::49d7:28b5:dabc:ba95%3]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 09:02:54 +0000
Message-ID: <a9a9d118-fe06-654c-68a2-75d6c1ce875a@amd.com>
Date: Fri, 28 Aug 2026 14:32:46 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Content-Language: en-US
To: jgg@ziepe.ca, leon@kernel.org
Cc: brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, allen.hubbe@amd.com,
 nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
 <20260814102413.5a26bf8b@kernel.org>
 <c565fa0c-08e7-60b9-90e9-07daa4777a48@amd.com>
 <20260820130817.43317368@kernel.org>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260820130817.43317368@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN3PR01CA0005.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::6) To IA1PR12MB8287.namprd12.prod.outlook.com
 (2603:10b6:208:3f5::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8287:EE_|PH7PR12MB6718:EE_
X-MS-Office365-Filtering-Correlation-Id: 668b0e45-834d-4b0b-c10c-08df04e32584
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|23010399003|366016|56012099006|6133799003|11063799006|10067099003|22082099003|4143699003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5DSXAJaC43jLC3i0u6VrE9qfO/10AwCnrq9AKu6KTSsQa5aiZUsrzA9M4oqHTtKaQSEqUVIVlpIBaK6JvvV8zJwSinYmGOUfMd/DWgZb7LkCI1DpQY0kuvZRKHtW60w6XxE58olLyG6wA1LXF5kP1IBj8Nn/CQzuGd16P0ylkXmSrpvbVjiFZFpMyHePMyomO5/Y1F6d590t5XwV8hdpxJhUwe5c3JdwoSCoItZtEbEvNPNebzggjZi6nj3IW3WxwiMD2YDehpXZ0D/jcL7q/3A0Q1ZWh9ddwzntU+ofExJ6V4iJZAHeCpLG6YpYuq/gvKwP1SnsWSJXfH8MxzHdk+stUCpirkQLEmtj+BU21FqdO2Y16FSkOK3Hoo+U2JCbWJwaiIDXBjxVDpf53VLC/Tsib4/0/VRvNnjfePm9NUk1x0HuoVqdvodVGt40gLyXqZMrexBTDa5ANWDDHfspVYNqTMeLxWV+oww2+BId+Yjm/BHwHH19LGKHpXPpACY8RCq6i5jLnUjKpvYmuf//IaMPHqQfjCq1pKIogIVyetJGaJegdBHDtWYzaQbN4TdvQJuCoaeRnxx7AmtRpgGbSV2WQJtoZcrOx9iU9LEhJFpPB/6FLDldJawgPGfKn371QbVt5tFoMXO0Za6rp3IPbpZX4hEhNOMKM5FGKvXHi8w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8287.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(23010399003)(366016)(56012099006)(6133799003)(11063799006)(10067099003)(22082099003)(4143699003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T3piZ3B4ZHErUUcwaDRUNHI1M1RCTVhoaHNLYzVHUUN2ZE12eGFyQWJSQ2Zt?=
 =?utf-8?B?OVhLZGpwRVRWaG8xc2IxY2VPVk84UnAwdk1NbVRLZEV3QUg1TXpnZG9OUmNy?=
 =?utf-8?B?ZisxcnRjMUtIYW9CQ3ZZSFBvcUlPcTJRNHlaZG1LSUlHV0tLem9YL0pKczVk?=
 =?utf-8?B?NHQwVEdXWldHSDhsL0JlYUtha2RNZHBtYk9BdlhLVlFhanpjU1lwTHhwbGpZ?=
 =?utf-8?B?cWFiRlVGczJ3ZHZnUGVaMmNOWFB6NnE3cHpYTHBOam9KbVpiamJvaklNazJ5?=
 =?utf-8?B?a0RhdW9Xb0I4UDRJajNwaSs4ajVLOGxrcmtRaUlwWlVZa1lNK2s4Nnd5cklX?=
 =?utf-8?B?MjA3cDJod0hPNm5TaXd6M1BMMjQ1YW8ySFdRMzgvLzhZLzJKV0pwNXZwZ3Ir?=
 =?utf-8?B?Wk5wNzkwNytmRlpLWFdCMHJJWmtTb2Y5bjVybDZ5RWROdTgvNndCL0Q4elJU?=
 =?utf-8?B?VHhXMXNMdVdJQnFqajFlM0YwQ0pvcnFnc3dsWkNQVlphWWI0eS9JdCtGalc2?=
 =?utf-8?B?VHlwV3A1bW83OWVycUZmZTNVNXVFaTFLR2xmMUtVTkFuUEM1NTQwR0xxWTAz?=
 =?utf-8?B?Q1N0S0lPRDBOTGZJY25YaWdLblZiVTR5VTBXajQwbFRFK2R0R3cwNDlRNXhZ?=
 =?utf-8?B?dWY5VXVTNWFDUEZFMXdzem1HR29NV3U1dEkwKzQrNk4vZkgrNFl4MklFU3Ja?=
 =?utf-8?B?Zk90OWhVbmxCS1BlajIrR0JtenNCNUptUlBSdzRaZS94a1JzN1YzM2lBTC84?=
 =?utf-8?B?dzNqaWswVnBKTXo1QmdGRnordWR2cDdUSjR3TDAvR2dNVVpLNis4RmZmbVFh?=
 =?utf-8?B?RzNIQUhRWmtmQlU5RlNGU1NZMUJoN0RnblgydEtpQi9CaWRDQ3h3MHRBdDkv?=
 =?utf-8?B?N3FPay84MmU3Q3Z2WFpNS1ZFUHVsL1RHeFN2em9FQkFNczk2Smd1THNYS0JM?=
 =?utf-8?B?SmRjYUVFZ3g1MndQMmk2WkxOTCthSVhOanVOR1VUWnlMNWt2a2tvM1FtRUZI?=
 =?utf-8?B?d2Y4elVEN2wrdkowaGJpT1p3L1BzbWd1UVdUZFA1R25wWkVaK1FDRXQ2R3dj?=
 =?utf-8?B?V1pabDlTNkxIeW9jellWbkVXdmZ6bTJtMU04RmEwSFBwcHlyRForcXUwT2p0?=
 =?utf-8?B?ajIxYXkySk4rWTlOWmE1OVpjT3pCUXBEZExUTXFGYTRZMGJZNzdNMnlqOFZI?=
 =?utf-8?B?WCtaKzFRRnJiSmxBK3dnUVZ5bm96ZUVzNDBkcnI3cDE0VTExMkVSKzlDTG40?=
 =?utf-8?B?MStCZWwzSTN2TDlsN3NHZEZyK1NzVWdJNU5JcjRnaUJTZFNDSnhoWmxDWjc5?=
 =?utf-8?B?aGYwRGlsaU1JSmxpLzUxSVRPTHRKcDk3MWRTR3JkcG5XajNRQllCaG41blJq?=
 =?utf-8?B?ZG13K0xyS0NTSTVFdWVvT1ZWeTZRMlFLbFRqenR6MThuaDQ5dDJHYSs3eTFV?=
 =?utf-8?B?VU00WVJDMG4wZE9kWkRwZDkrNGYwMnkxeG5PWUhqMHNVZU5VMVBFM3Zmdyt6?=
 =?utf-8?B?Wk9WNFYxQUJ2VVlPYWVpTU5hUVQvaDdKbDJsRE8rOEIrWFlBWEpzNGEzY0Zn?=
 =?utf-8?B?RE15Nnd5QVFrOFRJM0N3TkppakRibjhDZW5zWElCeUxwYkJPcjZzdFB4bFpK?=
 =?utf-8?B?SGx0RGFSSWhYYlVrc1ZSR3o4WnFRbmZneTZOdW54QW9FREk1MTBpbVY3Y2Iw?=
 =?utf-8?B?b2xXTDM3TUxJSHZWRVBYaTRub016b01xSjhHcjBlalE5S2Zoc3dNanJ5eHd3?=
 =?utf-8?B?M1ZlZ2VBeUlRVGJNcnN2MmRuWkMvWHVURWJKT3NKWWp2SUFVZTRxR290VzhX?=
 =?utf-8?B?bXlrbDB4U2xhd1IvcUVqcmU2RFdSUzQxLzRaZjJvTGFkdWk0TGtkT0ZHOTdr?=
 =?utf-8?B?MjNsVFV4SXVrNjJzOEhOMlVESUdMNjQ3aytmNnhqQWdxWnVidEFJS2JodzZF?=
 =?utf-8?B?WnVJN2FmS0F3bEJPWHBCYTdTSUVKaFIyUS9ES0hrazVReDRNMGh4OHdYbWhD?=
 =?utf-8?B?RjlGUHFBWGpEVXhnTGhPb1hvbWhDMU4xbHhmdG1kSFlDUDJ1bFp2RGVnTGx3?=
 =?utf-8?B?YmhHZzhsR3ZMQmFLaUZxTDlGWHNBbmpjQ0ZSMTlKSE9jSjdvVExDY09pTnJK?=
 =?utf-8?B?RGFLYWFON1l6SWRtM3h5RG0yekVZNWJvZlFmZW1UaUVQTXZrUktIV2dNdkh0?=
 =?utf-8?B?am1jNGpObXhydGpaZmczSVFIUHlwSjFZUW9XMk9xUTAxYTBVL2piWlpXRlpQ?=
 =?utf-8?B?NlByMU9ybmwxM29lYktFSVJ0VW9wakEvaVh1TmlWbk1KQStFenM2ck92aFV2?=
 =?utf-8?B?b25kVnlJd2h2UE9TeENmVzhSMWFkQklxckFKa1ZKZklUYy9DZHY4QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668b0e45-834d-4b0b-c10c-08df04e32584
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8287.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 09:02:54.7120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jn0pse+YDST+dVeye+su7vPu6ziB9LcxVQZw/EW/5eOpXKxi1lPoFJgBmBncVs2JVJPW7p65IMWHKLatXTzSzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6718

On 8/21/26 01:38, Jakub Kicinski wrote:
> On Mon, 17 Aug 2026 12:35:52 +0530 Abhijit Gangurde wrote:
>> On 8/14/26 22:54, Jakub Kicinski wrote:
>>> On Thu, 13 Aug 2026 16:19:52 +0530 Abhijit Gangurde wrote:
>>>> Patch 1 extends the net/ionic firmware identity structure to expose the
>>>> rcq_sign_bit field from the RDMA LIF identity.
>>> I asked for a PR, based on a tag from Linus's tree with that patch.
>>> Did you send that?
>>>
>>> I only see a PR for rdma-core here
>> Hi Jakub,
>>
>> I have the PR ready on Linus's v7.2 tag.
>>
>> The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533bc5019f:
>>
>>     Linux 7.2 (2026-08-16 14:32:26 -0700)
>>
>> are available in the Git repository at:
>>
>>     https://github.com/abhijitG-xlnx/linux.git ionic_rcq_shared
>>
>> for you to fetch changes up to bb23acfd05f0399f33dae000df2ef4a88787b7d0:
>>
>>     net: ionic: Fetch RCQ sign bit from firmware (2026-08-17 10:58:31 +0530)
> Thanks! Pulled
>
>
Hi Jason/Leon,

Can RDMA patches also be merged?

Abhijit


