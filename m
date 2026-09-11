Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010060.outbound.protection.outlook.com [52.101.193.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5055383C67;
	Fri, 11 Sep 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789113517; cv=fail; b=ZuPmUC5xZ5dz8TG0BwvBJrwPl+/yOFckoMQyFBTxPVKaS6PaZfqPYIFOxjSonFCpd52S6gZbgYea9x7rtagp7lg2ENaDjHBw9rN0Etqvderr8JZhzRuKrRcomURSQvssexFMopPqdtBeu2dUj/jgkP7B99qdjBFRjy6TTZ/Ym48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789113517; c=relaxed/simple;
	bh=bPnrCRPcX+rmsQa3LdhWwcjZvRMcqvTVAMM6iw801fg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s4IE182iJni7nWD7l4kS3hd4m+J0J96TuzaSgtqhMxW+BJosQsFcpBADX9Zeyp5DI1s2QqxXNky36ZSTraPxeeKmKdqsAnYKUj1hlSVYquAIF6KAC5Xg2mSYQLu0f2rKfWcF9uVl+fKk6MAWiEZfL63+48jrOiC33V3lwF+bmTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OX04SZ0M; arc=fail smtp.client-ip=52.101.193.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OX04SZ0M"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofHgP5xIuNkTtRZPvGSJwqZ4QxwLdXIcJ5/lLpq5p0cK6r4pocCQGym4K4Ujt9NPKc9Ml9qbEKA1fKu1Sxzx3kGaqeCecQ0x5VVQ49N0OmIMpbO+6gU+J9s/rxND87WdODP1dTTk6BHLoIexcJYut6THoiMqO0r3u3kDdsHS14J819d+M04yhvfDpy/Oztt6HHQBZJeK6DtZD5TCX4MwlAffVUclnJdq2vWsbfIdVlaNNt8WZEOFD0Ay6Jq3LjiR3AvihtzCxQyKxyo7OXW/FMyHM8bzWkNQUpy/tRsOp5mo/xpX4xT3p/1Beryr/OKGV/ll7+9EO/LIzQReVqmEKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wN7S3L9YhbhqLrBindsZgMO2eXt4YANXX9yCyIonxI=;
 b=C3tJtq158XmWQDv2F+b53+1eq8G5NGeYDV0JlYlYlZK0jgBcRqVf3Dt1EqHtBi7DBheKN5LPyeKFRY4ovtV5rRUfokI09zVbUOtEEvxRn8GVMyeV/zw7JNTCUsrddbsyL6xwKw1frezrAUXaH34MnIWoZIeXre0DosXMO0Xex5C3HgJ5bazI1pe1tfdI9Rn3b+V0RjDpFzVGiKXlj+jvaJR2HFaktqS3/mvFWfO2qSZPHsBPRmkSbqxLp42/U6J9By+k1937f+bHE+MF/+5N42SRwJ8GOHjLRSNVYuwNE5ExVA+Sp8UmjagpT0JwwiLjjiOmKuEKvtcHkTGC9mjrtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wN7S3L9YhbhqLrBindsZgMO2eXt4YANXX9yCyIonxI=;
 b=OX04SZ0MgVW5UtgGQE8funZkEPuXsjveAoB04xGFQll3ae1HMC6joQbROIaNKxWPG5UXa+1wjGjCiZlyqDB0r4XBzcapaMcUwpaq9guKv5Q8NHhnlrm/zCRd+/OmQrht6jjOQN+23k89ecmtSQ9SPNUH4aUkCzMoNKjV4FyvCnc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by SA1PR12MB6918.namprd12.prod.outlook.com (2603:10b6:806:24d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Fri, 11 Sep
 2026 07:58:32 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::ce69:cfae:774d:a65c%3]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 07:58:32 +0000
Message-ID: <c0c8dea4-1571-482e-be33-f965c7c357d2@amd.com>
Date: Fri, 11 Sep 2026 09:58:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 0/5] vfio/dma-buf: add TPH support for peer-to-peer
 access - ping
To: Zhiping Zhang <zhipingz@meta.com>
Cc: kvm@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
 Bjorn Helgaas <bhelgaas@google.com>, Alex Williamson <alex@shazbot.org>,
 Jason Gunthorpe <jgg@ziepe.ca>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <CAH3zFs0vQidHOWif_LmS0=65S9iiCo7yGibqLvFT5jadjj8wVA@mail.gmail.com>
 <CAH3zFs2XnH6gT0fO4=WLi4x1SL2+Y0S=Jo45SWkR=unPegQ8Hw@mail.gmail.com>
 <CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <CAH3zFs2X8=x-XMXhwC7_aUZivCCPQOSuyXMy-ryKqxLEFY9u-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0406.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:d0::11) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|SA1PR12MB6918:EE_
X-MS-Office365-Filtering-Correlation-Id: 254c8a56-1bb5-4b7a-9f4b-08df0fda794b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|10067099003|6133799003|3023799007|5023799004|11063799006|4143699003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	njM/dl89oxLkPMYu5IcBLTZZaeS4HJQ3+sMLIM+99gc9Xf6cbJV0BlFsnz0O9R16iJbIluqXKJTzZIP91lYBDU6e+mJQbxypTUIwk+nfOJpdHiMykPdnoM1bRN3WG0pY1omg0aPWdESmTsEyq5qwiqjaaZAL56yr8Gbv6FJ8SJDaMhIMN5MqLmiTSaWHAtzj4NCvFswKq8+TJhvsAO9/mJWEVw06x/thW0MtWKQj59YvNEbKiZjJEbqAQ4pw9/FUileQENyS4VhtaaZ79wYecAlgidNXTAWm7ym9WA9uDuYJr5BMaxLs6AMLtWK/PC5EpdDwg0T9qjZ2H37E3xNNgOVvJiUnrruu7IOX8SD5k2LEn1Goh5BZ/J4stQzTyRCUtW7KTay2vnFd7P9OsxZOd5McHJNoXgxPSk3tWfXWxqCyRaLUayDi+Pb8IMCYE/VJzccNxjEpLAHKIG9gfNuLIiEq9TJR20quMoY8XHRlHQg3jC/03ZoYGPyP23A6nBVgrP6EP9ybIPr8XHaVXfThA/FXeCDyKhjq50rxZzIM9DG2fZE9HJTdzbV/UBoLYltwPhkW6+it5kG1X9M1yjSD/WK38ZQcSGip4xewV2OxByHVNasvtL/JGHjfzo3uKR+TNz0BPn74iwBwAoDJWWgU4AAoWvESqZQxYiOcYKzbNyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(10067099003)(6133799003)(3023799007)(5023799004)(11063799006)(4143699003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OEFZY0VRZ0N0KzE1bENNd0wwN0lETUZGdU8yRER0MkJlZkVZdGtUQzJucytC?=
 =?utf-8?B?ckd1MVMzMC9vNThackRGYjV2c1FKVkljRVh0a2EyMzRmTW92eU93bkJHV1RW?=
 =?utf-8?B?U0FmTWZzdGd0SUtMdGVKamRweWEzQ3dOcjB6SytVMm1XMlF3RDNJamY0c24z?=
 =?utf-8?B?MU81c1lNMW1OUmRLcWFneUdsUmp5bUhSSUdiRDVreGJoaVVWTXhFK0dsN2x2?=
 =?utf-8?B?QXV6YXZlUGZ2TjVYOXRpek51K3ZPRkpvSU52VStyS3l2alcxcnA2WkNNamky?=
 =?utf-8?B?eFI3Y2V3d0FKaEdtdzVBWEVaZU10Z1RRUHpFelFEU25zR1ROdzUwWWIva1Jr?=
 =?utf-8?B?b3JNcnB6ZjRGTXZJVjBIaTFlSXJwQ3pCUUI2eUJZR3lrd2krR1EvOXYwbDg0?=
 =?utf-8?B?ZFJMQkNxYzhuYklVWFBVUEt6TWlBVkdSQVl4eDBMc0dpVXZQUE45ZVlhOWVP?=
 =?utf-8?B?ckIzelpySVcrR2swdGRFZDhGUkdZVVE1TklPaWFMTGhLTUFSV2tMazVTSmEw?=
 =?utf-8?B?OVdEcWJXdTBvN1FLMXROK3Q4TGJCRFQzQ0FQUHdKWkVJeDZ4d2taK0ZsQU1n?=
 =?utf-8?B?MDJVaUVFZFFmQUN6WnlMZDMydXlLWVM3SklzeVh5Vno3WnJhbW9OemdydW5r?=
 =?utf-8?B?a0hsdThlZUpkd1k5bVdsa0Zyc2NrSUZqUTkxc1VoYzVRSEZ4Y3NyMDhybFFQ?=
 =?utf-8?B?aGhObitsYmV5WW51Qi9RaVN1UkEyMWk0cWpzUHg0cTg5Z0p5UXk2NjRieWlH?=
 =?utf-8?B?dzIwcmU5ZUpiTXJpUUVQQmRFYlI5K1MxK2VzNUg1aG1DWWN5L1RRMGQwSUR1?=
 =?utf-8?B?VDl1RGNuaHZjOWlkREJQbG9MM051bThpQTlkOFlVSEZ0bVNMSmpqSUpsZFFU?=
 =?utf-8?B?aUVPWlEvTWN6V1l1NDRTdnhmVWVPRVpJSk4wOTI4SzJFaG5SeUgyMkRwVVNy?=
 =?utf-8?B?cnNldnlqM3cvdUJyQ3ZvdXpVRjJhNlFWMTBZdyt0a2VPWlhMenVnS1lXQlc0?=
 =?utf-8?B?UGNDZHZaYU03dndya0Q3RC9ucjhaOHRQcEx2MEY3YzIvMU9xbDRoM05rcjBz?=
 =?utf-8?B?di82SXl5TG9lSlNQRkNiVXlRdm1TRk5rRHVkcWQreWJ2dEdPQTRLM0F4a09C?=
 =?utf-8?B?SkZFbXdjQUszNzU1ZVRBS1dIMDdBblV1MW5JQ0UwNHJOZDRENDdGOGdmR0pM?=
 =?utf-8?B?UmRNK1hUNVBGbC8yM2RqcWtPWWV2MCtVUnVzeGVWd2NSQ1Bvdi9xcnZPMWRO?=
 =?utf-8?B?OEk1VDRxay92YnU4OVd1U25POHhGcjdsMll0dm9OeENRbm45WVVHeXQxSnM1?=
 =?utf-8?B?L3lFZ3UyZWNOeHB2WGkxLy8rYjhHM29OYkhhRllweUZQRk04eCtmTG1Rbi9T?=
 =?utf-8?B?M3dNZDJXaUh6SDRCSTZmdmlqemxHdld0MnJ6ZzVUdEhyVUFoenpUM2R4SG9i?=
 =?utf-8?B?aXZCa055UDdjNGNoV3FUTkJzYklPUUdGS0tnc3JsWGNRdFl5YmZ5clVIU0J1?=
 =?utf-8?B?Wlg2YlNSK0NEak0wQ0tVVjdibGQ2dDVCZWpCUkJMWDdlRnptU1FDekx3dzdr?=
 =?utf-8?B?em02QnU3L1JyWDlEa0hzQkZodUpsTzByaWVEcGlETW1jc1dDRWc0eFJVL05N?=
 =?utf-8?B?Qmt1OWhlWkM5S0NOZnNyM1F6aS9keXJrTkd4cVlESUdZc0dBaUp2MC9BZU1o?=
 =?utf-8?B?QTZxZ3ZUUEJYYkhtVXZpR3BUcEpnOFpMT1dydHJzOGR5ZFVzRlNqaGpHeXdn?=
 =?utf-8?B?VVBHbExnWS93WXd3QStveGhYZGtJNkRrbC9FalR5TTBFenRNcE1LclJHWGZw?=
 =?utf-8?B?VFNGa2lBS0oyQkFZMXpUK1AwOUl1RzdUSi8rbXY3ZUlBNW1RSXZoWlNWdU9s?=
 =?utf-8?B?bWJtOHBpdE1JaDRGVXFadTk5SGFBVWRmeFo1TUxtSmpSemxIVURHMXF6QUhq?=
 =?utf-8?B?NEdUL21GVVdLMUdyUk5UcXJSSjZubFlrdWNYYzZLWXZTbzJUOUlPa2Nnbjdt?=
 =?utf-8?B?cVY5Qm9qVEtjRHM1ZDV1KzhISHF5R05YbElQUkRUVjk1ZWxETGx0NVpJeXpw?=
 =?utf-8?B?dnpHckJPYUFGRjRJMVV0ZE04NXI3WTF1UE9BSllwVWJoYm5NVGxLWnEyOEJ2?=
 =?utf-8?B?dlkvdy9RSlBwc3ArR0srbjlyVTd5TXpvcEh3WFZQWjlMNWpqRXJQakg4aVdh?=
 =?utf-8?B?WlgwdUlvN3NDbnBnUFRrS1J2RmI5ays2VmJLYVVrQzFzMEpSa3VWc0pSRkJs?=
 =?utf-8?B?cC8zSXZLOXRGamlxMW1UZ2dVKzhMaTF3Z1MyQ0labklNZVVKMjR3WjlVSmlI?=
 =?utf-8?Q?3BL6PeBS8+x8X44AlA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254c8a56-1bb5-4b7a-9f4b-08df0fda794b
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 07:58:32.3745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6faJbqjkLEq0GDGxRJoE5cjl7PpUtMWYtN7Vb9NPPHH662qzVbRIgLOW/8OT64LH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6918

Hi Zhiping,

sorry I'm completely underwater at the moment and don't have time to take another look at the full set.

But IIRC you already fixed my documentation requirements and skimming over the patch once more I can't see anything wrong of hand.

So feel free to add Acked-by: Christian König <christian.koenig@amd.com> to patch "dma-buf: add optional get_pci_tph() callback" and push it upstream through the VFIO channels.

Regards,
Christian.

On 9/10/26 23:46, Zhiping Zhang wrote:
> Hi Christian,
> 
> Third ping on this series. The only patch still without review is 3/5,
> which adds an optional get_pci_tph() callback to dma_buf_ops:
> 
> https://lore.kernel.org/kvm/20260731211601.3033906-4-zhipingz@meta.com/
> 
> It lets an exporter report the PCIe TPH steering tag for a
> peer-to-peer mapping. The callback is optional -- exporters that don't
> implement it behave exactly as today -- and nothing else in dma-buf
> changes.
> 
> The rest of the series is settled: Chengwen acked patch 2, the
> automated review is clean, and there are no open comments from v12.
> Alex is holding his ack until the dma-buf side has been looked at, so
> this one callback is gating the whole series.
> 
> If you have concerns about the API shape or the locking, I'll respin.
> If someone else should review the dma-buf side, tell me who and I'll
> take it there. Otherwise I'll check with Alex and Jason next week on
> how to proceed, since 7.3 is in rc and the next window is about a
> month out.
> 
> Thanks,
> Zhiping
> 
> On Wed, Sep 2, 2026 at 1:53 PM Zhiping Zhang <zhipingz@meta.com> wrote:
>>
>> Hi Christian,
>>
>> Another ping on this series for your attention. Pls see below for more details.
>>
>> Thanks,
>> Zhiping
>>
>> On Fri, Aug 14, 2026 at 11:08 AM Zhiping Zhang <zhipingz@meta.com> wrote:
>>>
>>>  Hi Christian,
>>>
>>> A gentle ping on this series, especially patch 3, which adds the
>>> optional dma-buf get_pci_tph() callback. Could you please review this
>>> when you have a chance?
>>>
>>> https://lore.kernel.org/linux-pci/20260731211601.3033906-4-zhipingz@meta.com/
>>>
>>> Thanks,
>>> Zhiping
>>>
>>>
>>> On Fri, Jul 31, 2026 at 2:22 PM Zhiping Zhang <zhipingz@meta.com> wrote:
>>>>
>>>> This series adds TLP Processing Hints (TPH) support to the VFIO dma-buf
>>>> export path, allowing importing drivers (e.g. mlx5) to use the
>>>> exporter's steering tag when performing peer-to-peer DMA into a
>>>> VFIO-owned device.
>>>>
>>>> There is no separate in-tree vendor kernel driver for the target device:
>>>> vfio-pci is the in-tree driver and the targeted device is managed
>>>> from userspace via VFIO passthrough. That is why the ST has to flow
>>>> through a uAPI: userspace owns the device and its ST table, so it is the
>>>> entity that can configure a meaningful value for a given dma-buf. The
>>>> kernel-visible participants are still in-tree: vfio-pci exports the
>>>> dma-buf and mlx5 imports it.
>>>>
>>>> On the effect: the endpoint's PCIe ingress block uses the ST as
>>>> an in-band instruction for the incoming P2P TLP -- selecting a target
>>>> cache partition and, on writes, an in-flight operation on the data
>>>> before it lands. The dma-buf callback keeps this opaque to the
>>>> framework -- only the producer (userspace owner of the VFIO device)
>>>> and the consumer (endpoint block) need to interpret the value. The
>>>> dma-buf get_pci_tph callback itself is optional, but workloads that
>>>> depend on the endpoint's in-flight operation need it because fallback
>>>> does not produce the same result.
>>>>
>>>> The dma-buf hook is intentionally generic and discoverable rather than
>>>> a private side channel. The exporter owns the completing address
>>>> space for the dma-buf and decides whether it can provide a meaningful
>>>> ST/PH tuple for that completer; the dma-buf core keeps the tuple opaque,
>>>> and importers merely request the namespace they support and place the
>>>> returned value on generated TLPs. Exporters that cannot derive a
>>>> meaningful tuple simply return -EOPNOTSUPP.
>>>>
>>>> TPH is advisory: a steering tag that is not honored on the path (for
>>>> example an intermediate routing element that does not forward the TPH
>>>> prefix) is ignored and the request completes as an ordinary,
>>>> non-TPH transaction (PCIe Base 6.4 sec 2.2.7.1). This series therefore
>>>> targets the same-Root-Port / common-switch topology, where the ST
>>>> reaches the completer; cross-Root-Port P2P is best-effort and is not
>>>> gated in the uAPI, since supplying an unused ST is harmless and there
>>>> is no discoverable "TPH routing" capability to test against.
>>>>
>>>> Patch 1 folds the reserved 0b10 "TPH Completer Supported" encoding into
>>>> "not supported" in get_rp_completer_type(), so only architected values
>>>> can reach the TPH Requester Enable field. It was previously posted
>>>> standalone to linux-pci; per Alex Williamson's v12 review it now travels
>>>> with the series, which removes the cross-tree ordering dependency and
>>>> lets review tooling apply the series as posted.
>>>> Patch 2 adds small PCI/TPH type helpers so drivers can query the enabled
>>>> TPH requester mode and the device's TPH Completer Supported field
>>>> without reaching into pci_dev internals (and so callers in
>>>> CONFIG_PCIE_TPH=n builds get a clean fallback). pcie_tph_completer_type()
>>>> applies the same reserved-encoding fold as get_rp_completer_type(),
>>>> inlined locally so the helper is self-contained.
>>>> Patch 3 adds the optional dma_buf_ops::get_pci_tph callback plus the
>>>> dma_buf_get_pci_tph() importer wrapper so importers can fetch TPH
>>>> metadata from an exporter under dmabuf->resv.
>>>> Patch 4 implements get_pci_tph in vfio-pci and adds the new uAPI
>>>> (VFIO_DEVICE_FEATURE_DMA_BUF_TPH) for userspace to attach the metadata.
>>>> Patch 5 wires up the mlx5 RDMA driver as a consumer. It also enforces the
>>>> dma_buf_get_pci_tph() steering-tag lifetime: the tag is only valid for the
>>>> mapping it was queried against, and the mkey's TPH fields cannot be
>>>> reprogrammed in place. mlx5 therefore records the registration-time tuple
>>>> and re-queries after each dma-buf mapping is established under
>>>> dmabuf->resv; unchanged tuples continue with the existing mkey, while
>>>> changed or missing tuples fail the remap rather than continue with a
>>>> stale hint. For vfio-pci BAR dma-bufs this is expected to be a no-op
>>>> because invalidation is revoke/quiesce, not movement to a new backing
>>>> placement, and the userspace-provided tuple is not changed by the
>>>> revoke/un-revoke path.
>>>>
>>>> Build-tested with both CONFIG_PCIE_TPH=y and CONFIG_PCIE_TPH=n.
>>>> Functional validation on the target topology: PCIe analyzer captures
>>>> on the P2P TLPs confirm the ST emitted by mlx5 matches the value
>>>> configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, and the end-to-end
>>>> P2P workload only produces results consistent with the endpoint's
>>>> ST-selected in-flight operation. For example, with userspace
>>>> configuring 8-bit ST=0xf0 and PH=2, an analyzer capture of a peer-to-
>>>> peer MWr64 shows "STP MWr64 TC=0 OHC=2 ..." followed by "OHC-B
>>>> ST=F0h PH=2 HV=1":
>>>> (TLP Captures)
>>>> 08000260 -> STP MWr64 TC=0 OHC=2 TS=0 Attr=0 L=8
>>>> F0000004 -> RID=4h:0h.0h EP- Tag=F0h
>>>> E0200000 -> AddrH=000020E0h
>>>> 00080006 -> AddrL=06000800h
>>>> 90F00000 -> OHC-B ST=F0h PH=2 HV=1 AMA=0 AV-
>>>>
>>>> The dma-buf get_pci_tph interface has also been exercised by a second,
>>>> independent importer: a different vendor's NIC whose driver is not yet
>>>> upstream, locally taught to call dma_buf_get_pci_tph(). A PCIe analyzer
>>>> confirmed the ST it placed on outbound P2P TLPs matches the value
>>>> configured through VFIO_DEVICE_FEATURE_DMA_BUF_TPH, the same result as
>>>> with mlx5. Two unrelated importer drivers exercising the callback
>>>> end-to-end shows the interface is not tied to a single consumer. That
>>>> importer change is out-of-tree and not part of this series. For that
>>>> second importer, with userspace configuring 8-bit ST=0xe0 and PH=0,
>>>> an analyzer capture shows:
>>>> (TLP Captures)
>>>> 08200260 -> STP MWr64 TC=0 OHC=2 TS=1 Attr=0 L=8
>>>> 4E00004C -> RID=4Ch:0h.0h EP- Tag=4Eh
>>>> 00170000 -> AddrH=00001700h
>>>> 00200006 -> AddrL=06002000h
>>>> 10E00000 -> OHC-B ST=E0h PH=0 HV=1 AMA=0 AV-
>>>>
>>>> Changes since v12:
>>>>   Patch 1 (PCI/TPH, new to the series): the reserved-encoding fold,
>>>>   previously posted standalone to linux-pci [1], is now the first patch
>>>>   here (Alex Williamson). Sashiko could not apply v12 because of that
>>>>   external dependency; with the fold in-series and the mlx5 leak fix in
>>>>   linux-next, v13 has none. The code is unchanged from the standalone
>>>>   v3; the Fixes: tag is dropped, since no code path can reach the
>>>>   reserved encoding today and the patch is hardening rather than a fix
>>>>   for observed silicon.
>>>>
>>>>   Patch 2 (PCI/TPH): inline the reserved-encoding fold in
>>>>   pcie_tph_completer_type() rather than calling the helper that earlier
>>>>   folding revisions added; that helper was dropped in folding v3 per
>>>>   Bjorn Helgaas and Wei Huang.
>>>>
>>>>   Patch 3 (dma-buf): no functional change.
>>>>
>>>>   Patch 4 (vfio/pci): also gate the DMA_BUF_TPH feature on
>>>>   vdev->pci_ops->get_dmabuf_phys, matching
>>>>   vfio_pci_core_feature_dma_buf(). Without it PROBE reported the feature
>>>>   as supported on a device that advertises TPH Completer support but
>>>>   cannot export a vfio dma-buf at all, so nothing could ever carry the
>>>>   metadata (Alex Williamson, who raised this to uAPI-affecting
>>>>   severity).
>>>>
>>>>   Patch 5 (mlx5): keep the !dev->st early-out in mlx5_st_alloc_index()
>>>>   ahead of the pcie_tph_get_cpu_st() call, so splitting out
>>>>   mlx5_st_alloc_index_by_tag() neither adds an ACPI _DSM invocation on
>>>>   devices without ST support nor changes the errno userspace sees when
>>>>   the _DSM lookup fails (Alex Williamson). The commit message now
>>>>   describes this rather than presenting the split as a pure extraction.
>>>>
>>>> Previous link:
>>>> v12: https://lore.kernel.org/linux-pci/20260715204008.3911275-1-zhipingz@meta.com/
>>>> v11: https://lore.kernel.org/linux-pci/20260702181025.2694961-1-zhipingz@meta.com/
>>>> v10: https://lore.kernel.org/linux-pci/20260630224328.3218796-1-zhipingz@meta.com/
>>>> v9: https://lore.kernel.org/dri-devel/20260622184211.2229399-1-zhipingz@meta.com/
>>>> v8: https://lore.kernel.org/dri-devel/20260615065912.2177918-1-zhipingz@meta.com/
>>>> v7: https://lore.kernel.org/dri-devel/20260611161546.4075580-1-zhipingz@meta.com/
>>>> v6: https://lore.kernel.org/dri-devel/20260608185646.4085127-1-zhipingz@meta.com/
>>>> v5: https://lore.kernel.org/dri-devel/20260526144401.1485788-1-zhipingz@meta.com/
>>>> v4: https://lore.kernel.org/linux-pci/20260519201401.1558410-1-zhipingz@meta.com/
>>>> v3: https://lore.kernel.org/linux-pci/20260512184755.4137227-1-zhipingz@meta.com/
>>>> v2: https://lore.kernel.org/linux-pci/20260430200704.352228-1-zhipingz@meta.com/
>>>>
>>>> Zhiping Zhang (5):
>>>>   PCI/TPH: treat reserved 0b10 completer encoding as unsupported
>>>>   PCI/TPH: Add requester/completer type helpers
>>>>   dma-buf: add optional get_pci_tph() callback
>>>>   vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature
>>>>   RDMA/mlx5: get tph for p2p access when registering dma-buf mr
>>>>
>>>>  drivers/dma-buf/dma-buf.c                     |  32 ++++
>>>>  drivers/infiniband/hw/mlx5/main.c             |   1 +
>>>>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  11 ++
>>>>  drivers/infiniband/hw/mlx5/mr.c               | 151 +++++++++++++++++-
>>>>  drivers/infiniband/hw/mlx5/odp.c              |   7 +
>>>>  .../net/ethernet/mellanox/mlx5/core/lib/st.c  |  52 +++++-
>>>>  drivers/pci/tph.c                             |  55 ++++++-
>>>>  drivers/vfio/pci/vfio_pci_core.c              |   3 +
>>>>  drivers/vfio/pci/vfio_pci_dmabuf.c            | 120 +++++++++++++-
>>>>  drivers/vfio/pci/vfio_pci_priv.h              |  13 ++
>>>>  include/linux/dma-buf.h                       |  25 +++
>>>>  include/linux/mlx5/driver.h                   |  15 ++
>>>>  include/linux/pci-tph.h                       |   8 +
>>>>  include/uapi/linux/vfio.h                     |  43 +++++
>>>>  14 files changed, 517 insertions(+), 19 deletions(-)
>>>>
>>>> --
>>>> 2.53.0-Meta
>>>>

