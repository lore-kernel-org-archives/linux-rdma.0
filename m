Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012068.outbound.protection.outlook.com [52.101.48.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13365233944;
	Mon, 17 Aug 2026 07:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786950367; cv=fail; b=burwzhrU49Ic8nb6lUvS22a2vuvb38Xkypm+PAD+0+2QPl/5mv7bGR+/M9gQHgTBcnzTsLzpdJkzj+2/3XiF3UOKGWHD+DskSFLXh6HRyEMUJ76KCu9VkvogCkx3pCSVBPe0XRoflWQYGSQmwn1ouxyakLinpNhE0uCBekTjx54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786950367; c=relaxed/simple;
	bh=bLW9FlM/qsTfU+MoQKrqnUlBj66Dz9i4/4o+fhTC1is=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kvXPHrwbJl04aV99S3IeomSR77fwied383rfaHvaWuOtpNZuFbV6M4GdEVhG0s914DPFPXQDCHsu1q7eJCSBuRnxn2RxApBYJIYq1+IKjoPQakJevN4/kOtB3XfjVmO3t9whYaabe6VArCh6V7FDOxREiuZAbXwUnrajuQEULbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4EKLjtVU; arc=fail smtp.client-ip=52.101.48.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4EKLjtVU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jh5CGQ5E/BsRl6AavGf5gl2Ter0Y+UwHg1QSwK+uCx/kADk9VKpv3EhDbdMXbw/2Pivri0JpwNv9wDLHsq9vEU8WljKEm2RC/sW3WaRPwL8g+EiWag0bNg0xsznrIpL9vFTbvEi6/pNpeTBsZyEylLSb73HLbWWxOpavrPM/brxF5oR5VbiX9uBe49Fk9U5DqRQEapI85GDPlAvAu5aZIMq5V5lJlb4v2mvxk8lEbXyNQQou2YVeYIECIGQuVgDd4Juba4E2r6cGBFeylCx1veTrrURTCvzYpmuwXi/koTGCeMrmOmy2KSU4vLBbxF41Vl2yy8hWQlWZlBnU19/P8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bLW9FlM/qsTfU+MoQKrqnUlBj66Dz9i4/4o+fhTC1is=;
 b=AphcKQuff0XTKwViyMOCSz/3klvgk+6D1eMe6FBaU/1ghG5vAp+Nbdpr5FlwhfY4mCoCL//JJot65XkXLv6EweFNhvu8VLa0yMRz1dvx/uHYRtFlRTLhNN+uoHy3MpMy3+X6a7RXkXjQWj+VHebr8HXzCPPATQykk0K+9sWOsGtRZKMxqA7c0qZK8eVA1i1w2X4Bnm8T1aQuI+Jvv9OCCe8voHa3drROBcH3x4HVqu2Znq0AkaGfsc7e5ieitb+CMUBTcNnk9rwqDPP27rx5xo6Cna0QDeWlZzjqcObEohJg2eWIAIWwUh7131CdHJ1Or1fZf4m8sjZL2NHPl0WzEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bLW9FlM/qsTfU+MoQKrqnUlBj66Dz9i4/4o+fhTC1is=;
 b=4EKLjtVUQeV2rHNPRiW6pOwrSutB/IciLi9PvDvlPddMCkgKTJ6hCsLpFc35BbuS6W0r36qUJ61TBrEoQjpXGw4RyhP6/DPadjlzbEIN8npNQaobOVipAeLyeFQoLHEMM2Pn/htGz453MMXCBFDVdTPGMSbUhV/9zflHUIqvGUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA1PR12MB8287.namprd12.prod.outlook.com (2603:10b6:208:3f5::14)
 by MW4PR12MB5601.namprd12.prod.outlook.com (2603:10b6:303:168::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 07:06:01 +0000
Received: from IA1PR12MB8287.namprd12.prod.outlook.com
 ([fe80::49d7:28b5:dabc:ba95]) by IA1PR12MB8287.namprd12.prod.outlook.com
 ([fe80::49d7:28b5:dabc:ba95%3]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 07:06:01 +0000
Message-ID: <c565fa0c-08e7-60b9-90e9-07daa4777a48@amd.com>
Date: Mon, 17 Aug 2026 12:35:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [for-next v6 0/2] Add Reorder Completion Queue (RCQ) support
Content-Language: en-US
To: Jakub Kicinski <kuba@kernel.org>
Cc: jgg@ziepe.ca, leon@kernel.org, brett.creeley@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, allen.hubbe@amd.com, nikhil.agarwal@amd.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260813104954.319065-1-abhijit.gangurde@amd.com>
 <20260814102413.5a26bf8b@kernel.org>
From: Abhijit Gangurde <abhijit.gangurde@amd.com>
In-Reply-To: <20260814102413.5a26bf8b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PNYP287CA0099.INDP287.PROD.OUTLOOK.COM
 (2603:1096:c01:2b9::8) To IA1PR12MB8287.namprd12.prod.outlook.com
 (2603:10b6:208:3f5::14)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR12MB8287:EE_|MW4PR12MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d180b71-9e61-4391-b3c0-08defc2dfee0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|22082099003|18002099003|56012099006|6133799003|11063799006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	/W8IoLEMGiuWyMFmRCt8CtHw3FeIqEcViX91c8QatSyaHCzYx1M4sbY3gyAFqjYtzza3gjwSMAsgAbZn92u3Z50UR3QdlisBa19pgd+n95xPiKnlcKXJppo476pE1imCLKfCYRisP5yF7LmAnXyBj84ybVKKBCGA5Olkl23qO4WXtpHS/BeN8JLY05s8r3Tu95XXPJvE+i9HpZG8D0J3mCZdDr4RhARhgLurmaKVUww5n/1Z625imGBf6TC81mFGsxKBdprhcR29NmOsKsNux3AIaWC4tbPH8HJvFzwAvDyxS8UZBeW0QRrF17lFzRdKICcMayvUxtLxDztEMx9xEz23XoP58yYIow+/qNswQiX5PwHWaQSSA2k2lhpdhkUOAwHnSTVj++EfCcF7yTOXDR2fB/SsrmgkfYCY0WfzYLoG3O2KlcYT6X0daao7nI0DrSULEQf1xHpE09yBiKULENdL6uQx+LzXnXMPWgT9l6qhfG1UGeJiPlPkQviIbOqid17D7FCa05IEjSwNosOeKLmt3ohEcNiTcSuYPQtm8QlUYys78GDAXDk7bJ0fdurszbigeH7DynPelZ8kxKzEjEh11GrIpgMa3d759GaO9JB/y6o4sRGZDJ6Lli6hVHsD+cQ4LqSvCeesv22oVJQRYheX2IYgpaE6osJhBCdN9Jw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB8287.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(22082099003)(18002099003)(56012099006)(6133799003)(11063799006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MEwxTmFGN2srNm41YUkyaXJqaHU5ZmgzME9CRjN5anRYdnl2azc0eGxpbE1l?=
 =?utf-8?B?NmdYaFNVcmhKbDB3V1p4b1Q1VVkrVmVnQ2pacmR2MG1kVU84N1BsT3JJVzFR?=
 =?utf-8?B?SitJbVo3RHByUFJLVWZGZDlMVzdyMTBNNTRtQ0FaU25OcDg3eEdTbmE2Q3VS?=
 =?utf-8?B?WnFhVDV3Lzc2cmlqVnFaTCttdmU4a2E1ODhGaVYvRWgzbHFwYmQvcXFMRkhU?=
 =?utf-8?B?RUhCcnROaVBiT1FrK0xxc0YyN3c5L0dPemVkbU1PVFJtOW9NakFxRmVadHNP?=
 =?utf-8?B?MTY2RmJ0SEh1ZzIxcW82L3lGWWVSNVUrUlhNd05EUDJpb1FvWUM4NmYrb0g5?=
 =?utf-8?B?dklWV2tVdmljSmdFMnYxTlpKVGNXUURxOGdhamhVUDk2ODhrc0VtRkxrcGtr?=
 =?utf-8?B?eE9rQk0vUG5HWGlUb3VvTHgvdlpqMnltL0t0elpXMitBYllCZHE2SzdNQVhh?=
 =?utf-8?B?UUo2S0h5d0tOL2ZQdUMyVWhRYnozZWRzS3ZlUTVMR1RXN2dRMjFiV1JyYkVj?=
 =?utf-8?B?WndhSFl6aGtFc09FT1RoaEJiYjVUUisvbUxlbTZCUnU1MU0venYyNGpkZzFY?=
 =?utf-8?B?L2tVQkswcUI1OHM0ajdRZVNRYVdqQzdWYy8xTzVrVE41TlZFVkZxVEJiM0dB?=
 =?utf-8?B?Nnl4cFphL2dMNFREdmNRQmJxVUdEelY1eEQ3bnJTYi9LVHU1TVAyelorV2Vq?=
 =?utf-8?B?Q09VcnBwQk5MbWQ2cGFOYUlEangyNldBS01rNlBDQjhuQ0JFMXlnMVhDM3Zi?=
 =?utf-8?B?RDNRRmUxZXpidlVWTlJLOXRJdHhDM2lhclJXOWtocVlTRmwwQmdFMkxJelJo?=
 =?utf-8?B?NUF0MEJRZ2pzUTU2MDZkYXRKNHNuN2doVE1TaDlYbjYrVTdpcUhNYUhTdy9I?=
 =?utf-8?B?RWNTWmtrQVJ4N0RtMGZZdHdGVUFnWHhYZUtmQnNOMkNZQTZtWDdMQzIyRXBk?=
 =?utf-8?B?Q1lUVjd5MTFNWmhkWlJqMEtvNEZESFVnTGJOdVpRb0R1d3I3TVRZdDlnb0tU?=
 =?utf-8?B?a092d2hzdlJKREJyZmx6OWNqVUx6RElieFpUcXExcTNodk1vbHEyQ3grNk9m?=
 =?utf-8?B?STh5MUpFN1NwT0Npb0ZXNUZlM3ovejdxMUpjWTNta0ZKd0s3L0MrQm5QdHJm?=
 =?utf-8?B?WHk0MXFuR1dFT3BLeVFSYzJvOE5lMElxY2dNOTFKSGgySkRNQUtOOW1vWmg5?=
 =?utf-8?B?Zm1UZHVwR2N3dTJibDMvYTJmVjY2UlZrMC9ocDMvZnJPenBQODAwbXdhNEZJ?=
 =?utf-8?B?SDVSRkx3MFJFcWVQdjhCTmlKUVQ3bFNUY1d2a0l2dTk4MklYTEQzWU5QWkd3?=
 =?utf-8?B?ZGx4YURieS9DLzVLZWNGRHFVRUp2aGNVL0JsaXRoNTFOdStvT25UeGVEc3hO?=
 =?utf-8?B?MGpWRVVXYW1RQTJabWxjRUhoZ0FRdU5jdndabGNEck5tRkMrd0NxYnNRSnJJ?=
 =?utf-8?B?dU9PbEE1S0FMOHo2TW9uek04NUlndDVYNGhET25sWWlhRWdnM0lVQ2lJUkVT?=
 =?utf-8?B?dmhHS0tHMTlHbEx5RkxnYTM5ajN3VW5XakttY2RySFlRWlZkMm0vSFZHV2Yv?=
 =?utf-8?B?aDdrcnFRVHpYWkNXNkl2c0hud3JqU1lON1RPMGZpajJKTG5SdTdPbjd2bFpW?=
 =?utf-8?B?UkJtR0RKelJuUGJwUDRHQjJTSmkrSXJHWFgybitKbVppUVRkVXZOcFFYeGUy?=
 =?utf-8?B?R0FzQlhmcmlNR3JtRndPajlOcTJJS0JLcVUyU2dzUG9sRkN4d1BlY21Kb01G?=
 =?utf-8?B?VDRkRGNMTFhkZjBPZVVUSFV0Yi94bWwxdFdlYTNLV25INlQ1cDk0amFEVzdz?=
 =?utf-8?B?NjdhSzY0cGZYUDFwMDdPU3g2dE91M1IybkpBWjUxRTlKa0w1ZnN5T3lrK0dV?=
 =?utf-8?B?YSt1NGJXYUJSMFplR3VBSUErSGo4ckNMSnp5S0tpakpkN2RhY0NIVEJRSTlL?=
 =?utf-8?B?R2xOWElLdGU1cXFGeWhWWmFINW9rQkFWdDVhWkxNRUR4SHYrUG5mK1pOTW5Y?=
 =?utf-8?B?U0ozSGZmWVd6UnY2R0U1VXZvU0xIUWVSQ1pXbE1IUjQxQVdKWGZjWDY5T2JC?=
 =?utf-8?B?dVF2bE9ZNytZaDFnc2FQQzhEazR4ZFVJM29wdHgvQWhvWXFpODFacWI3YldO?=
 =?utf-8?B?SElpcUZBMmhwckI2TDN5UFpjeUZPQk5MMUNHTEUyU3hYMkI1a3JFMzRrTk1h?=
 =?utf-8?B?L0pJcGhzZ1JkeW1FNWRrc0VWTGw0aWVXeC9ESHErNVU1LzczUlNNbGhsSHJR?=
 =?utf-8?B?YWx4aFJnRXFRVkcrb21kNDk5emxBdVZKazlIRUJkRVgzUC92TkNld0RNZW1v?=
 =?utf-8?B?b0ErbWRpNTY5SmVkMTJRZ0hzVVdOVzJzSi92aVpZV3lzYlVmQWEwZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d180b71-9e61-4391-b3c0-08defc2dfee0
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB8287.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 07:06:01.6270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrM9xV+x8/iZhkZEur516XwieK/VdhJLWVyKmO6URatzQqSvhjy8mGJgocrnfgNeGoeLQvP7QGyNSIovIzYJvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5601

On 8/14/26 22:54, Jakub Kicinski wrote:
> On Thu, 13 Aug 2026 16:19:52 +0530 Abhijit Gangurde wrote:
>> Patch 1 extends the net/ionic firmware identity structure to expose the
>> rcq_sign_bit field from the RDMA LIF identity.
> I asked for a PR, based on a tag from Linus's tree with that patch.
> Did you send that?
>
> I only see a PR for rdma-core here

Hi Jakub,

I have the PR ready on Linus's v7.2 tag.

The following changes since commit 8d3ae59288f1e7d58d76558a6ee96d533bc5019f:

   Linux 7.2 (2026-08-16 14:32:26 -0700)

are available in the Git repository at:

   https://github.com/abhijitG-xlnx/linux.git ionic_rcq_shared

for you to fetch changes up to bb23acfd05f0399f33dae000df2ef4a88787b7d0:

   net: ionic: Fetch RCQ sign bit from firmware (2026-08-17 10:58:31 +0530)

----------------------------------------------------------------
Abhijit Gangurde (1):
       net: ionic: Fetch RCQ sign bit from firmware

  drivers/net/ethernet/pensando/ionic/ionic_if.h | 6 +++++-
  1 file changed, 5 insertions(+), 1 deletion(-)


Thanks,
Abhijit


