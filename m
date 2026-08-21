Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010014.outbound.protection.outlook.com [52.101.201.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2730F25EF87;
	Fri, 21 Aug 2026 00:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787271876; cv=fail; b=DXmDYPmb2T7f22WOYM2ecz/5Gap0xjbPWzBWLwzokdls72z23eSCSmriFSndvbCIhekoLH+vRuWYWEGyEVTPM7H5Rv7LtNN4f2DTttT/VFcCtBMS+/UIqY4PJwcfSG64WDRkS1Okfq243hTOg0X/6cr9ahte6hP9tHT1U69tP18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787271876; c=relaxed/simple;
	bh=FNgWQJg8h6HBmGRJ53pnKP/kO4sIjEQMbtuRPq8pjRo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aSvgoESf+7MhHHF5+h1usuupY3WjocVAmOcCvxCdZpAuYGp3vY8lU4gbaenFSWfDspczxqRHfJBWLm0vJEL2iVJshJczhNz4Gnw9403ih16/uEBZ4lyAirS9HstcqCT9Wl6ApcEAsQVVMhevt7cAkc9p68OQ5uluN/tlQLVSMUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FmLFgebU; arc=fail smtp.client-ip=52.101.201.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FmLFgebU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f7/rxYKWVB3P+AVvATa3I+XSX7sQw/iiG1JErkKM64eKml/dvCZ34sQWlblApOTyvw5lCADefRi/ii8AeRygAek74DSu3+fYYY1xy5MRguQocaKS1UPO9xWMpo+HJ6cpj5Cp9DSW2MyR+2t+6Smv6fpAkhc6xJkEQZi2EqKPdlIVvpAFKikoOuIuWWPxDF6xHHREl5paqyS9IK6vYUUWwPbZ30eZxj86goOhiM1jc9Wz58YkUm0fX5SrzhXza8FcDAZUWbNGHuMvN5xLy+po3+IlCpdfSWYcOz/ZHssAdEJ3wTrk4+MFQXDcBFZwHL9pdlMLsGq5A8yqKA6nNbcSxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypWgHtxmE2//D3FUUFSXA+8Fa0jH1ExPQY7sgyHJmuw=;
 b=ttVOI575Mz7bE5P6ZVPmvdYS4Uz01EkevxLYEjA4abf72JuwhzqoYqobiMuJkSd+5gujeBZ5FegsLJuJzBk+dFkH7Fds1upDlvM3pPYsbVywVbjxYIsKKrlnd93f7h2614pHxni7+YWIkfSafWLRg+eELoTLMqzvHRhBKUiBD/b9aN6U+Jyq2ERg6vxAURBzxQ9lh8V7Erquu3q3/FWGb9YV+ZsvMkiCcfSTmXkzP77XJHjJK95y7dQKvexJSHnl/rZCy+V0kDxyrjj82DNCzuBfUDYioTTnfk6UdE073JaTlQ0Fel1B0n8pzDYryhn/hCXZHfL3SM2U/rRLKUla4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypWgHtxmE2//D3FUUFSXA+8Fa0jH1ExPQY7sgyHJmuw=;
 b=FmLFgebUa8Zzsquhyw9dvIW93YoVY+88/XpJx7FJhuE1ETTKTGJ2Shump/s92NzswAPRzbonPkcvxOHtbhcmistcrdLSTbUyjouTDEy5d3glX2tvyXypYqLErvhDJ2uPRmJd6aSIWU11dayoDTBz+bnqqsQXehQui+HhpphIuxo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS4PR12MB9708.namprd12.prod.outlook.com (2603:10b6:8:278::7) by
 IA5PR12MB999276.namprd12.prod.outlook.com (2603:10b6:208:60b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.10; Fri, 21 Aug
 2026 00:24:32 +0000
Received: from DS4PR12MB9708.namprd12.prod.outlook.com
 ([fe80::8570:d817:2f81:c62a]) by DS4PR12MB9708.namprd12.prod.outlook.com
 ([fe80::8570:d817:2f81:c62a%4]) with mapi id 15.21.0339.007; Fri, 21 Aug 2026
 00:24:32 +0000
Message-ID: <c940bf1d-11d0-4564-ab1e-e423b0c8ceae@amd.com>
Date: Thu, 20 Aug 2026 17:24:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 4/4] RDMA/ionic: Add DCQCN parameter
 configuration via debugfs
From: Eric Joyner <eric.joyner@amd.com>
To: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 Leon Romanovsky <leon@kernel.org>
Cc: Brett Creeley <brett.creeley@amd.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Abhijit Gangurde
 <abhijit.gangurde@amd.com>, Allen Hubbe <allen.hubbe@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, "Nikhil P . Rao" <nikhil.rao@amd.com>
References: <20260506041935.1061-1-eric.joyner@amd.com>
 <20260506041935.1061-5-eric.joyner@amd.com>
 <bb6f164e-5f95-48ab-a22c-5582dcef721d@amd.com>
Content-Language: en-US
In-Reply-To: <bb6f164e-5f95-48ab-a22c-5582dcef721d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0298.namprd04.prod.outlook.com
 (2603:10b6:303:89::33) To DS4PR12MB9708.namprd12.prod.outlook.com
 (2603:10b6:8:278::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PR12MB9708:EE_|IA5PR12MB999276:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c8ff19d-0a05-4465-a205-08deff1a9221
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|6133799003|3023799007|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	7dRzehGnluSgUxsfq4SEvzgt2xfhrsNWId0wDV0djBMKAIY0p8myPqmTV8CmBSa+ktLo/3AwKkX5UubqTKN2JBaTsTuKkTlkfjJZzbAl2244qXKzex3fFwov5141KPAnqsqq847iC5Ua5dHFpmQnSyGVrJrMpb9hqh8sZCZYssli1xPwYP78Kw5GtEu/PkRCtdEEo22fBNQoesMTWwmJV2CLzpHecB4bPdH3R/qBLj4HTEAKppzbMs12YGHBAsDf84jJoqUO9/wwGpTFkRAq9BuiHwrctqYRfFX60o7KaE9dCSbYcACKEJA3vv9bLqUYvmI8/VKiCKISldmaXQKAHweB/GNPU3MUqomOhVLftDaBTfdO6E7uXkO+hSyi6WyKV9vuKbky/2wwJ28tPLpANnGf8Th9b84pAPsTtzLe7HW5NC3F1TidQvirTADKjH0KXPec3kY+v21nVf9P3gQPbvI/nxaFQsKydYKl7ypm4L0QG2EiQFWzV8g7oGCKQPEUvrLH/O9cRIJPBx6DX33vfGb1ljMUte7Z1O25kKOCcGh8wB6KzKlOwvoBlZB8jVRATb0ECDM2nZJ/awr18T1E9gwspQzftoOHOiPyVq5tD2cJmj8esjMnx6poLdnG8st93HQNQlYUuzlgOBj5ayYEWbcJ8EZT+uZTGSiZS53fMuM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PR12MB9708.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(6133799003)(3023799007)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RUd3dWhjTjFWTEFLU0JsNkJUZmNVS09oMXh0WlFqWE1WWHFqZnFsRnE5THRT?=
 =?utf-8?B?RGQzMzdaSGkvWDhGanlWdHN5c1EvRzlCQTdIR0hmeWp6bHRzaHg4UVhmQ0dT?=
 =?utf-8?B?ZnlHMkhkc1pJTE84bmVHazRsaHhNbHdoQ3cyOHdZRGJ5Q3Ric3lGTlJjeEti?=
 =?utf-8?B?QSsrR0QzU2dDZ3FXekR6aWZtcjVhdHg1cEdmRVB5eG5za082MTFYSFNUSUZo?=
 =?utf-8?B?cjh2aDBhR0d3aGlFNjF6TUt0VDd6ci9EYTlXZG1zREdTNVp3cERZbkFSNE1k?=
 =?utf-8?B?NDIwS3RLbGlOTDhJOVNCbXdGa3o3N0tKRVhUM3BYR0o4MDlEUkdlaHhDSTFu?=
 =?utf-8?B?UEFaZUVyWVU0eFhrUm1TbnlLWmJlTU9YZkp2ZjdRelJIUDhzYmtWRTkvOGQ3?=
 =?utf-8?B?M1BFQ0d3K21xbG5JV3l6bTFSV1lETHY0c3dmWDFKUk0zS1ZYell3Tkg3SU1B?=
 =?utf-8?B?YjVWT2lqWFlnSVJnTzg0dHFFS0RYVHg2V2dxbGJZcFNhbithWHp6cFFyVzZ4?=
 =?utf-8?B?ZWc1S2E2aXpieEdFV2N2dXIyMnZIUDZaYmgyUGkrYTF5VE4rOUNtMUxiWmJU?=
 =?utf-8?B?NlN4WjUwLzFONFMvc2Z3MlpZek5ZWXZEQ2VDSFpCdTZxYkt3Q2NNMnk5aUI4?=
 =?utf-8?B?clBHNDFBRVV0b3Z2L1ZUY0J3RUduTm5tSkg3ZW1oUjhoWnVoaDNCTmpRcFhw?=
 =?utf-8?B?eTdlQlBWZi9lcEhURlRwOUQ3UXFwWi9aamwzcGJ1bkg3alliL0xER24vbzdN?=
 =?utf-8?B?aCsxcm10NWQwSnZOd085a0t3WVlISHlhaG5jeGRuTHdFanJQRFlLc3lHank5?=
 =?utf-8?B?RnUvVDk4K1NVTUZKQ1BxRVpxQnIrSHg3d2VaSVNYSlQ3cDI2TURwMnlJL0Ny?=
 =?utf-8?B?UWFRM1h1RFFpcGtQeEQ4bUNocFY1V0ErTUhLeDJWUjdDS3JGZ3FsQ09vdVg0?=
 =?utf-8?B?ZThjUHVpbkxkVEY2UXZ4eFFBWjFTNzBwQVRBTGFnVmZBRGdoT1FDTTFHMlFX?=
 =?utf-8?B?OXNDWGxYWGhLL2ZjZ0VGMDBTMGE0SXRnQ29PUTNTNDUwMXphbWJ0QVc0UG1U?=
 =?utf-8?B?Y2dlU3NZQ2VBQXQzMUdYOGFXVWR3Q0E3RHd3dDc3T1ZSUGd0cWd5SlFvaHBB?=
 =?utf-8?B?WnVoQUhrSDhaS3FtSEx5NFZUSUU2c21mR2twYkdMM2hLQUxnTzM4d1FGM1dF?=
 =?utf-8?B?ZWJzNGM1akFaUFVOeFRPYm5mRmt0M3J6WjlBdGRacnlUcUhsWFl1czZxMFFj?=
 =?utf-8?B?UjR2Z3NWZFVYZmRmbGZKdVlaUU1DVXR5ZG5KSDBRSkdUY2VlUjNhVDVpd052?=
 =?utf-8?B?bHpnU3d1em9Ud0k1ZjZXVHV0dFRZWU96N1NCTFRJVHVuVVRreU1yczFIeXU4?=
 =?utf-8?B?ckhoZTVnc3drVXpnM0pqQmV4SGFHSUF5OWhheGtxbWJXSzVsbk5BQm91WUpE?=
 =?utf-8?B?YUdaQmE0cTdsWk5kbVVHMUdHZ0RWenYzbllWWGR5UkRLZmpDUmdPVmZpdEJY?=
 =?utf-8?B?R3VWMVFIVjFjWUpqMCt6dS9FQjNwV3NHU1NVR09rOTF2ZCt5V2w3Y0t4T2xJ?=
 =?utf-8?B?eUhtT1lrczEwNGNGZlN1bDh3QXdqd3h0ZnBwL1pPa1MrR2lIRGhYbjZIZ29i?=
 =?utf-8?B?U0Y2d3hvRmg1SmllQUZoaURvTmg5SDFIODFmeXdQVXBEZzVFUEg1MHI3R3lG?=
 =?utf-8?B?U3U4VGJCcEFWL1YwN0pFRHlvcFV6cjJBOVZ1YWQ2ZGpMRFNxZnFiUko2WXpG?=
 =?utf-8?B?NGFWdGo5V1BMazl6RndCM0V2ZUlickM4KzRpa0VyanlNUzRVdk1ZM3BtOWNF?=
 =?utf-8?B?eFRxWDd4MTl1ckFjM1lIanNvbmJkTXIzOEZuNmJjR3BjN1h0ZDJWbktlU1hi?=
 =?utf-8?B?RVJDMGl1YXJRbmFLSTAzWkViYzU5YjcwaVRoQ05oN1p5K3IxL3huRU40Vzg2?=
 =?utf-8?B?UWFHdTJXU3lseUlqbDJIaHNkNmVIQS81bWtnUVFWUEhxeXAwS0xpdXVRZ0pC?=
 =?utf-8?B?bjdXcGtwbXhMMHhrSmlETmJyWmEzKyttMFdsbDduSkE3d25QUkI3Mk5CY2kv?=
 =?utf-8?B?ZTNTYnlqOFhKbVJRUEtzNTBFRVdsSmUyZzE5cGJ4OUFRZHdiQ3hBWWltK1E2?=
 =?utf-8?B?YitpSVdmV2JYaW9FV0Q1YWRFM3NaTk5tY09BUnNod1JxOGNmS3IwUTJ3Mmx5?=
 =?utf-8?B?ZjRFNGNUR21lcXBjU0x4VWNFTFRDb0RZd1BFaGpXVWRvYlZUeWk2K0RkVEFw?=
 =?utf-8?B?czR6REtSZXRIOHBJcUZ6NHpTbkpRdVhINTJhNEdFdmFyd0hPaXBzaVM2VWZH?=
 =?utf-8?Q?nmdC7OJwoSSw6xzqRw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c8ff19d-0a05-4465-a205-08deff1a9221
X-MS-Exchange-CrossTenant-AuthSource: DS4PR12MB9708.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 00:24:32.0736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yn6Y1HX4+sTs4XPMSJnWFeWmPHi9T+TrfkRENLMkr/CjzlSkNTV4De33bta+zB6U
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999276

On 7/28/2026 4:16 PM, Eric Joyner wrote:
> 
> Leon,
> 
> From this thread for Patch 3:
> https://lore.kernel.org/linux-rdma/20260514163540.GT15586@unreal/, I understand
> that it's too large and it's exposing too much information; I can shrink that
> down and remove the entries there.
> 
> But before I make changes and resubmit, is what this patch is doing okay? It
> adds DCQCN configuration parameters so that they can be written to in debugfs
> and propagated to the firmware? Would this be considered too much meddling with
> the firmware in debugfs, too? We want to have a driver-configured mode for DCQCN
> and possibly other congestion control profiles.
> 
> - Eric

Hi Leon,

Can you tell me what an acceptable approach would be in terms of the DCQCN
configuration? It didn't get mentioned as part of the debugfs discussion on the
other patch in this series, and I want to know if it's ok if I can modify the
debugfs implementation to have these DCQCN tuning knobs in there, but to drop
everything else from the rdma driver debugfs that looks offensive.

- Eric
