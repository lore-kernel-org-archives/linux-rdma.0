Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.8
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795589126;
	b=h/PM928lT9PLWtNITHShcYGuGZ/91pgTBMCC+vqFi5dwpu6JHEplUdLwTR/PCUfurAca
	 sZo8xGSTExAMP07H55xC3teX6CZsttWUn4Oe2ZrHiPzRc5Dq1G8abWPPqY583GDxpCvX7
	 2riDLlQj2AEHA6TFDqIb1JJiv49ZZW+R+NBl5LOyBszxMmkwav3NkGv71mEZtHeJpJIOJ
	 tDngTQLyisU7AbuRAa8PaUtnFKiQls0lcgqxm0kwgu8xJv2kXr29PDVembHsj6xhKU1G5
	 Bn9u9XyhInPxuFgE4GBKeQYHlqIYQq0fIg2YlOrj4LaQu7ilyi2q5dSPZEGQEO+n6Lg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589126;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=f5Lhk+uxhLms2wP1ubnfMvCbBT8jathvKp6CO5DqquM=;
	b=IP8SrAjYaM53RHOMXU0xIaDcqzg7VNujTgDU2dyOHUC0/QOPWUl8Fyc3BQxnSkBpaVWI
	 pX70nT4ojgTssWeAp6uyGfet3t27by7Z1ELrOVF2iWKJ++74MWxoilQ6ATL6MEM00duts
	 WKkka2f9bmYuC/oACKZNIhP/5txpBGT174bpAICf3mBDbCwSdkjUrG8u9rWadWyVY7mgq
	 nTWZmjf62TjEW2X0QLC1a2jweJMTZMZepOKRDq0aeafsTTvp1BOJ3pKlK+YIMuVE/+ljq
	 Qcfmu52hlTLkOuCY8rS+0kooFSvFeJJLDdFBgUmtXZTrZsCJGvqZqEzlVAX9f24uq4g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RQIxprb5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013008.outbound.protection.outlook.com [40.93.196.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7427F606A321;
	Wed, 25 Nov 2026 06:45:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7427F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=RQIxprb5
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hVHaS7uocg3QgEU/zPOj4Mz1zQBqmBChBnNOkyCGxwLtQ01YxdH29w0I1TW/dXf7skG43MXHraNIlXjsezyEA7VMZt0QOAgdS9ydRYUtWW8jMB/pHz79X/jQMI1u7T8HXkTew7IOrJS81y3N+WqNFs4P8Ocq/j0WB9DNrPNrrYSRNtQp9rc7iNA7GKCywyaPBJ7kXzRFhYiL6SoZPOt5Pez4p66edq1lvZqJj6hd7Qj9JfUsuBfiFHWPd8LqwVkAeQ8zNQ33mhaXw9scSTu97e3BTNu1bq0ffVw1SqfXb3LlYKh9wlja9lrlRYp7K+uUg/iEsUJwfDtqgvDAk9JYqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f5Lhk+uxhLms2wP1ubnfMvCbBT8jathvKp6CO5DqquM=;
 b=t1ZDY0bqT9qL+lGVGI/e844LKT5fxzXel1dkeaV3pd92DaPV+vUws7R/olbvR74qxYiJpExW6HLCAmM+FtbNsKORKMU1CVOY7dSkh67DGTgtKdWiYlKodUJ0eCcN9Mja2xZUBNgZdsCnUWQ1rTT57nrUi12G7eOy05ALwZgKODSuecrUaUtKOoCJ+cyV27vpLuDhPiavE2uw5e9+WXs3lK8M4ct8ecPCqjRl6w99BUESuvuUbh06wjmlqs2yIjmxdKixO9f8uGR806+jUzCdxRN7/f5BG9bINZ8Dq9XhzAs7xz2lcqIACHOtQeKzfCGp6H64TdZiVCXbFoT0CDDAfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f5Lhk+uxhLms2wP1ubnfMvCbBT8jathvKp6CO5DqquM=;
 b=RQIxprb5iBibgpm6kfq85M/JOiTIbAwLSstFFsaB3OvH0eYO85qhyCaXgoUc9Z90OvN/BEZz0mUfoixjtwr0pr2XrkCQVkIXK+kcII42C37lhgxlMZNhi9/aECVYhmw5ByROH4hS5VyHSmQSQepQnKVIppLIHeATv4eBYvERNPaqZmV+nR0Ef/sGd9SDjUUMv2uai88T3/Zr0vcgJEbTNbdwBNF1os/dUAPZRMPEfGHAIeTP8R1wS+i6k4nbQxKMij8T5cqpeuaBo2OGD3Fea10YIq5kqlibffRLrcONFMW205K8oWKM3WXZc278OuXrLsnOsB0J4kZytaEQ9bio7w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL4PR12MB9723.namprd12.prod.outlook.com (2603:10b6:208:4ed::16)
 by SA3PR12MB9226.namprd12.prod.outlook.com (2603:10b6:806:396::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.4; Wed, 25 Nov
 2026 06:45:23 +0000
Received: from BL4PR12MB9723.namprd12.prod.outlook.com
 ([fe80::218e:5de0:e859:4146]) by BL4PR12MB9723.namprd12.prod.outlook.com
 ([fe80::218e:5de0:e859:4146%6]) with mapi id 15.21.0662.004; Wed, 25 Nov 2026
 06:45:23 +0000
Message-ID: <dbcb3cfa-25e0-40c8-a3fa-e381a8db5445@nvidia.com>
Date: Wed, 25 Nov 2026 08:45:17 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v1] net/mlx5: Use generic power management
To: Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, helgaas@kernel.org, bhelgaas@google.com,
 bjorn@helgaas.com, saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
 mbloch@nvidia.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261017194104.2684-1-vaibhavgupta40@gmail.com>
 <179235249198.3135.3606400485703838782@kernel.org>
 <0e7a46e2-982f-46c0-9d77-b986e249e252@nvidia.com>
 <CAP+cEOMaiHDRW+YAdPdj795pntKLUCQDB1E=vM4cjNfvPqTWvA@mail.gmail.com>
Content-Language: en-US
From: Carolina Jubran <cjubran@nvidia.com>
In-Reply-To: <CAP+cEOMaiHDRW+YAdPdj795pntKLUCQDB1E=vM4cjNfvPqTWvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TL2P290CA0019.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:3::14) To BL4PR12MB9723.namprd12.prod.outlook.com
 (2603:10b6:208:4ed::16)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9723:EE_|SA3PR12MB9226:EE_
X-MS-Office365-Filtering-Correlation-Id: c1fae3e3-dbbc-45bd-4b21-08df4abfae13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|22082099003|18002099003|5023799004|11063799006|56012099006|4143699003|261022075727099003|261028144727099003|261026121527099003|261102123227099003|261021121427099003|261009223027099003|261026140227099003|261022105027099003|261021123027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	7wIk33ZkMMSLNSL++8kNmoOl2I+E0OHz334t+Jh3FEvhNKRhu8UgnCpbl8XVfSHCfVI0r6IOVvVRG9EbaEtvPueg4z62MAtC7qdbdW3I8fHe+dPOLyjrMX7cLYRtim8JeqOYmnxQNn13WrjWzBfct3Y2iJA1YTm2Shw9SBo6CvJAg7RQ78DmQAbxz+CB5lu6i/CJHf9CKS8mPAWNMhfrZKjVnCgfrMEaE4/wiTWIU8U4BucLEN4CZD2QrKoM0VpKrzhYopdtEmBYwvCg+vJrbhuRGVK5O/pOJmpSlV4BEuFVWVzjKMeWrKlOs2WGXZZtRiJm5d5bz2JtM12IF7Cc45tKO9+YqYwWB9hvlfIS33B8R47q97n+m8rldv7FMihr1lHX+15h6BE3vPhCqUEW9fwCkz9v8viqbZwzTk7TBxZrEpXpqjoCegquT0/0BcLfhQogWy3V7+XOTc24P/syAiPE9UC+yIclnVinXFZAnSGxnVxzQrL4JzI/pPSx5QPSROmXCJ6rHgF0TANZx6Q6IRc6eupxa7BgOAWyxqoxcuzZicuwP3dsvMvy0j3+XLaOmzP+zOu9xELRpkiXMw2CmNKYHOxb7ydUDVELVS8pioAz2eys+7p+/qcISR72Smvv71LaPNpYKDlnrN5PZDskFJoZmTZMvbOS9GqH9emAG1k=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9723.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(22082099003)(18002099003)(5023799004)(11063799006)(56012099006)(4143699003)(261022075727099003)(261028144727099003)(261026121527099003)(261102123227099003)(261021121427099003)(261009223027099003)(261026140227099003)(261022105027099003)(261021123027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OWdCQkJ4Wit3VG1XRTRxM0IvTDZjelBmUndLa2x0VlJWcEV4aWlGZHh3OHJr?=
 =?utf-8?B?KzA3V29Wd3JGVC9RL2FPSjA3bjRURUdydmZpK0RrWE9Tbzkxa3lxcktwalZL?=
 =?utf-8?B?WnBKb1ppNVpBRjRxaGl2Y0tJczZLMTEvMUpQZWhpb0I5bEVWekdzTFk2YzF5?=
 =?utf-8?B?OU1WZmlJR3JuellzM2tKcjl0TkhoeUNOWlVlTnhMU3lEWlZMeVh2cXIxa1Bl?=
 =?utf-8?B?Zmc4azhaM3daNHAxV0J6VkpUVnkxd3lvbTBMYUh0aTdwMUdtbW9ZWk44OXVL?=
 =?utf-8?B?bHpSajFYczJpWEJwcXMyNmxmd1M3ZE0rSVBvbkNsZlFEWlRMQVB5VXNQM0d6?=
 =?utf-8?B?WTcvUWloUm5SMWVEbUw3RDI0RHZVMGNId2U2Z2lhZjVRM0pPOXJLOVc1ZTlH?=
 =?utf-8?B?cHZjMWtSdUUyampvZXJFOVc4NmE0QzBjSU85QzNLVFNkc210OC9pc1NsN3ov?=
 =?utf-8?B?M0dWU250YTVQSGMwVmhZdDIyRjgvOXVkZzZxZ2pNN085MWp0WFRSS25zUEJk?=
 =?utf-8?B?eGFGSWVQRE5PREE5ZDBjcm1mZUlUbm5yTUh5S0dTSlVwU21LMUk1QWVSVktK?=
 =?utf-8?B?eVVHVkhocEJFR0N6VDBZaGhhbk5aTHNiWXFoQi8yd04zZ0JiZXlXSzNLZUpI?=
 =?utf-8?B?OWtQOURhRTNOaFBtR2x2eExIY3dqV3pzS0hCQkhCVFo5V3V5RVJveDN2alVk?=
 =?utf-8?B?RWc3WGFSSmgzanN5amlSYi92SkFyOGlvc0pBTTJLUnc0ZHBMTEJNazI0bU1J?=
 =?utf-8?B?VTdHQ2VaZTVxa3ZjeXZLem8wYU1HWm5tcStXZmlhTk9aa3Bhd1hwSmdRL1ZP?=
 =?utf-8?B?K0xkN1g2bTliMWp1YkZvcGZ5TjdNSFZxdnBJQkZYZnhFUktEVVN6QzVmWTZh?=
 =?utf-8?B?K05obUlIMUhpRldDVXQyTDQxQjdjT1Y0VEJEUzgybXp3NEFHdldwb2ZrSlE5?=
 =?utf-8?B?am5ZK0IrM2VHWnpQZ0o5QUE3UVZBY2ZOd0FrSHNST04yTUNrTEZLWiszYVB4?=
 =?utf-8?B?aUw1aXp2WW5DRkNUdFZLR0M4NUd0cXVTWlROMmJqaHFiMkRxVnJ1TlR0K2FN?=
 =?utf-8?B?Q3kxaHhtY2dCVW5aZUZzaHJZT0RFck1wUzhOQUgwdE1NNUZvTkpBOTU4RFYz?=
 =?utf-8?B?TVpJbU4wdXhtSjhNVGRwU0I3WkUrVGZFZ2x5cmhDbTZKRXBsak96KzFsNHJo?=
 =?utf-8?B?WmI1clZJcVZpeWg5Mi8rV0E3aVdBbEIydkRVUUJsTGVTVFdaRkc3WXkyNVhV?=
 =?utf-8?B?QjBjUTJpRVQ2di9PT2V6aVFKUE5GNXV3dEEzVjBqdFVONEJLNWhLWXpteFlo?=
 =?utf-8?B?SGxyOTNJZUx5d3BaMEVhK1NrS25LTlZaQWhvRFErQ3llbldZenNyZU5aZGNL?=
 =?utf-8?B?Vi8yVXVoWlhlbzFVcWJ2R3k2YktKR005UFdWVXo3VkZRN2JvQ09FQjNkd3Rm?=
 =?utf-8?B?aUVWamlLNnBvcjdDMVVUeTJySjJBSE9USnpsRWJsM0lJV1V5bUpXbm1NREN4?=
 =?utf-8?B?Y1RyaDk5cVBOREI5UTkvVzMyV2VJOXJYMXcybzZVOFlvdFk4N0REVnlJMlFx?=
 =?utf-8?B?OFFxSGt4M1Y3bjF1NVRuM2dVUy82ZFRZT3lwenBhZ0lSb29BNVo5bVgzWkxU?=
 =?utf-8?B?dXdJV1RCa3dkRzVEZldqZ0lWK01NTUlscHFmTVBlQ1RWVmhCZE9zVHNiajZC?=
 =?utf-8?B?VXpEb2QxNlh2ckJtdkkyaGF5VW4wNU14QzVIYURXVi9PN0U0bk4xemRnRUF5?=
 =?utf-8?B?Q09FQ0FuQnh3bFNla201bjdPRENMb2lXTzYwY2VKUWR6d1BMOEFSMzJISTEr?=
 =?utf-8?B?aENlSkU4Mkl1ODluazgweWk5RW0xN3d0YVNvcThpZzJxTW1EMGhSanZSNldV?=
 =?utf-8?B?MStvdjRSbkNleFMzYStvYlhkZHMzV3k3TWs5WEpSdGZwNzdINU94Nmc0cGRD?=
 =?utf-8?B?ZzJiQmYxR0NSdENzMEx5OXYrNW9OOXJFaDd5RjBENStDclZ5UkRFL3RITnl4?=
 =?utf-8?B?MEFlZ1dLRlNRQktrOGZzaEpmYi9MWjZSN1VFelBxTkIyc3FTNzhaSFdFZXdE?=
 =?utf-8?B?Tk1qYUVOYlF5OU0vSlJCRHFzZXBmMjJaakNzSDI3TFdoR2JSSmNkalNTWWZC?=
 =?utf-8?B?WFNhTVdHeFo2ODVjdFQvYUZGV08wZW9tTisweGMrR2pRN0djSXVTUFZwWHJz?=
 =?utf-8?B?WEZjaEdsS3g5RDNYeE1vZEk4VDFVNFMyUFNjNk1obnplSU9uc3llRU9DOVRV?=
 =?utf-8?B?R0toZ0RNTVBzZWo4SVhSYjhxbmZQZ1NZZTlWNlo4WHBLeTM4V1F4cnI4ejlo?=
 =?utf-8?Q?6hfoWsTKjemEEJMSUR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1fae3e3-dbbc-45bd-4b21-08df4abfae13
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9723.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2026 06:45:23.2298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5UXAzdRsCEUMrMI4TWNTAbvKvM2PHGDhGttSYrKLIdgu6gtQzfv9/KTztdFJaNQx7k/aqV5RxNSXr8C5BWTPVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9226


On 31/10/2026 15:31, Vaibhav Gupta wrote:
> On Wed, 28 Oct 2026 at 7:29 AM, Carolina Jubran <cjubran@nvidia.com> wrote:
>
>> On 18/10/2026 22:41, netdev-bot+sashiko@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 1 potential
>>> issue(s) to consider.
>>>
>>> Critical: 0 · High: 0 · Medium: 1 · Low: 0
>>>
>>> If you believe none of the issues are legitimate, please reply to each
>>> issue of Medium severity or higher and explain why the AI is wrong.
>>> If any of them are legitimate and you plan to respin, please let
>> patchwork
>>> know by including "pw-bot: cr" as a separate line at the end of your
>> reply
>>> (one such reply per series is enough).
>>>
>>> - [Medium] After this patch, the PCI core puts the mlx5 function into
>>>     D3hot/D3cold in pci_pm_suspend_noirq() once mlx5_suspend() returns.
>>>
>>> --
>>>
>>> net/mlx5: Use generic power management
>>>
>>> This patch moves mlx5_core from the legacy pci_driver suspend and resume
>>> hooks to dev_pm_ops. It converts mlx5_suspend() and mlx5_resume() to take
>>> a struct device and registers them with DEFINE_SIMPLE_DEV_PM_OPS() and
>>> pm_sleep_ptr().
>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>> b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>>>> index 5f28d906c35b6..d8dba3328bb6a 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
>>> [ ... ]
>>>
>>>> @@ -2281,8 +2285,7 @@ static struct pci_driver mlx5_core_driver = {
>>>>       .id_table       = mlx5_core_pci_table,
>>>>       .probe          = probe_one,
>>>>       .remove         = remove_one,
>>>> -    .suspend        = mlx5_suspend,
>>>> -    .resume         = mlx5_resume,
>>>> +    .driver.pm      = pm_sleep_ptr(&mlx5_pm_ops),
>>> [Severity: Medium]
>>> With dev_pm_ops in use, the PCI core now calls pci_prepare_to_sleep()
>> from
>>> pci_pm_suspend_noirq() after mlx5_suspend() returns. That puts the
>> function
>>> into D3hot or D3cold. The legacy path did not do this.
>>>
>>> Can the PTP overflow worker still touch the device after that point? The
>>> suspend path is:
>>>
>>> mlx5_suspend()->mlx5_unload_one(dev,
>> true)->mlx5_unload()->mlx5_clock_unload()
>>> mlx5_clock_unload() unregisters the PPS notifier and cancels out_work:
>>>
>>>        mlx5_eq_notifier_unregister(mdev, &mdev->clock_state->pps_nb);
>>>        cancel_work_sync(&mdev->clock_state->out_work);
>>>
>>> It does not stop the PTP aux worker. That worker is started in
>>> mlx5_init_clock_dev():
>>>
>>>        if (clock->ptp)
>>>                ptp_schedule_worker(clock->ptp, 0);
>>>
>>> It only stops when ptp_clock_unregister() runs from
>>> mlx5_destroy_clock_dev() on the cleanup_once path, and suspend never
>> takes
>>> that path. The worker runs on a kthread worker from kthread_run_worker(),
>>> which is not freezable.
>>>
>>> mlx5_timestamp_overflow() re-arms itself every overflow_period. Its only
>>> guard is:
>>>
>>>        if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
>>>                goto out;
>>>
>>> mlx5_unload_one_devl_locked() leaves dev->state at MLX5_DEVICE_STATE_UP,
>> so
>>> the worker goes on to timecounter_read()->read_internal_timer()->
>>> mlx5_read_time(), which reads BAR0:
>>>
>>>        timer_h = ioread32be(real_time ? &dev->iseg->real_time_h :
>>>                             &dev->iseg->internal_timer_h);
>>>
>>> In s2idle, timekeeping comes back when s2idle_loop exits. A delayed work
>>> that expired during sleep then fires right away. That can happen before
>>> dpm_resume_noirq() returns mlx5 to D0. It can also happen in the window
>>> between mlx5's suspend_noirq and sleep entry.
>>>
>>> Would those reads then reach a function in D3hot, complete as Unsupported
>>> Request and return all-ones? They may also log AER errors.
>>>
>>> If so, timecounter_read() would take the all-ones value (masked by
>>> cc->mask) as a real counter value. It would move tc->nsec and cycle_last
>>> forward, and mlx5_update_clock_info_page() would publish the bad values
>> to
>>> the clock_info page that RDMA userspace maps.
>>>
>>> Nothing on the resume path (mlx5_load()->mlx5_clock_load()) appears to
>>> re-initialize the timecounter.
>>>
>>> Should the overflow worker be stopped in the unload path when suspending
>>> (for example with ptp_cancel_worker_sync()) and rescheduled on load?
>>
>> This is already being addressed here
>> https://lore.kernel.org/netdev/20261021105600.3481485-1-tariqt@nvidia.com/
>>
>>
>> We are preparing v2 of this fix. Could you please hold off on the
>> conversion until the fix is merged?
>>
>> Thanks,
>>
>> Carolina
>>
>>
>>>>       .shutdown       = shutdown,
>>>>       .err_handler    = &mlx5_err_handler,
>>>>       .sriov_configure   = mlx5_core_sriov_configure,
>
> Hello Carolina!
>
> There is no hurry from my side to apply this patch. So you can apply it
> later when are fix is in.
>
> Thanks,
> Vaibhav


Hi  Vaibhav,

The clock fix already landed in net-next, so you can re-spin your patch.

Thank you,
Carolina

