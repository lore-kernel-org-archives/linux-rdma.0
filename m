Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013067.outbound.protection.outlook.com [40.107.201.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3294CDA3E;
	Mon,  5 Oct 2026 15:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791215083; cv=fail; b=rsNbZ0lGilWyXkxM3xuynj33Y/Zd/uqahlq+yIqCRKG1Q5DFv/5sD1QXjOXO7Fze+YcIKKdRG3IXLcZzonRnBRnFYtGz2nPR7I2sxDvPj9Slh1ua3KWWv5J+Ik4ErLg9fleUzj0chWUuYj6AjcBirpTodPkKFHiAgRB2o59uID0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791215083; c=relaxed/simple;
	bh=3hbX7jsQ22sPhk7kcGeV9SMyfkT8UAkpP/k3gwslW2U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=goYIjNgk03ld3Uzpee8ySfon4g27BX5eIEr/usZWc1kFjfDHbPuy9/RNFYSXV0bdJut8T789duYZQMOrOBaCaf4j4y9B1pL59zUtoUU/SRHCQ9wTd3c+LmKvz+DVU0dfwSYw+r7fpNvUgyZcEnZDTpiFZUJlUprb+vpr8HqAQwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kBtEC2EJ; arc=fail smtp.client-ip=40.107.201.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kBtEC2EJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aIJZv43Prg36m1YJUfwIPTqzPQKauCfJSN4CgMdm4XiNHVKxNlD4T2CYx7iaE4uL5iZMHMb4coyGmSsIp7cLJjSOoGM8ou9vD1RwxSRvAFDgy95LHI15w5PFTkIKlNJ4NGUBJEVUDZOjZzGh3j+oQ7m99FlfAIghKvLWT7n2lk+0NiX7jCCI/Dig+ooaWSs7EWmiXSq8lWnGmxuydCEUZIVwIsyJd/1vMojVSZ6WWElbohoPNygBOyhv3PpM23DsjQ3JCQmbRKjAordcg+5ZDzhD9lN5Qk3sw2rOfzIiGmesyjyu8Upd/wAwicnpbK2GAQAO3Le4JfBJx+oaibUn7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/oulLIW7yIBobshB8shFErViK2jq9RA74n6BCVI/HjA=;
 b=v6nBp3eZhvdDX+26DMvz6DV/EdbXAzr+6S95z/5JyJfJCianNT7qD3KwlM1FgTyM/NIM8Yyt+pB355bfD1cf+Aoryz7FCh0unpPFDsQPKAsbuso5kHVJenfy2zd7ObFiDQViUBQZAsEygxL3dHJq9oE5rBSjwmrfXArmg4+xyTkvbUudJEKhBVAjFLeL5ieFL5mgW9OKt9YTO9jX1xxXU3FCtn2SgZTbCv+Fb0pPImMoRc0WywQhopkJQ+J+3GfaSfmKiqDcHmK6QGLprwZPzDHIyjwpRBG9WakjqxoKOEjKZpmlIxbZ+/WPmvlYzhVmz1iB55Pa/Pb8+zrEW8I1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oulLIW7yIBobshB8shFErViK2jq9RA74n6BCVI/HjA=;
 b=kBtEC2EJthc3c9MwVAoNPZ7zDu/j8LJdi2j+gjWq6ASYEPRqLnBUqTm9Rn89NnCrBSfy5LmyTdj93O7ziruGW2zGSEBH85QV8YV0WDK/2Y5EDMfJBXQ6Tz57j2i1hYRtb/x2VSN2k6IfYe5AyxP2fmOO4Xl8Zod4ImOFSeVexY3+8QvuKePa+V713ZkLaWW22C6mxo/EsaTaJbdqVB05JI5zpQed9qY2H36CPhEUFW2cpFJuBc8VhtV4778Jyw8mJTXAOLqhSrkU5h7l/UuiUCXfQOAbZ+eCLG4qOgTnEBSYDXFpubion8wWorxhSI0FNavfBRoOjTHLudlZH/FSvA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7) by PH8PR12MB7445.namprd12.prod.outlook.com
 (2603:10b6:510:217::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Mon, 5 Oct
 2026 15:44:36 +0000
Received: from SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c]) by SA3PR12MB239779.namprd12.prod.outlook.com
 ([fe80::2ac4:299a:52e3:5d9c%6]) with mapi id 15.21.0472.016; Mon, 5 Oct 2026
 15:44:35 +0000
Message-ID: <0a1daf0f-a71c-4b06-bc7b-9a1a2d6d6d08@nvidia.com>
Date: Mon, 5 Oct 2026 18:44:23 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net V2] net/mlx5: Lag, split aggregate speed into oper and
 max helpers
To: netdev-bot+sinfo@kernel.org, Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Edward Srouji <edwards@nvidia.com>,
 Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 open list <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Shay Drori <shayd@nvidia.com>
References: <20260930170406.148548-1-tariqt@nvidia.com>
 <179078810510.31693.8484299734852796324@kernel.org>
Content-Language: en-US
From: Or Har-Toov <ohartoov@nvidia.com>
In-Reply-To: <179078810510.31693.8484299734852796324@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0449.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:c6::9) To SA3PR12MB239779.namprd12.prod.outlook.com
 (2603:10b6:806:5a5::7)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB239779:EE_|PH8PR12MB7445:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d229093-aca3-4f69-1219-08df22f78eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|22082099003|18002099003|6133799003|10067099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	YEoAbkJvw6pIawYLA1XLbo5UYa0h9zNNb+eQe4l2b7qQ6aa4hFErfhunjdOokWmm8D7J/UawPE81r1PdvhXtxZOhr2RmCEyw0ysb9Uf53EOR7+EzkMubSwqUM3ZtrnJ2IbVDAB26+6s3RzUivx78gWlY7ZFOkNXUWPOEzpAa5rEw1AxfL8qdLC4KraLAKrwZDyv2kBSVb83NT8RSXybSPBxOdAbQaelmnQH1r/F+8n40vJfrR2psu3MnaGD7MWeT1V35/rw8rfngBoArTBoSyyvEXzv3vIBDNpAXE0bzzG3Vh9/aEB6i4EN1PRzAdqOU6OiGMPPdhwusJGfBitpQB/vACKIyT+Win2jGhMJcfteiItm8ywEGsvoL2USawJTHBRFPyy3cn8AX44oPWomlH0HYVkA5gGX0u/LEQAHjp2zT4/vzYyQUbJfe0A6d+XZwuzlw2/CnMCE500rmslznBZMwedEabNzGcaSJqU8V27L+mfw8PnENc7LXpsRuZ3KooBQrznU6H7aiw1WYuhRQ7OWgVi3OxFpOf5fcr/U3kdSTJDCf/DQBrsiydknOMUqX2y7l7/WWXBwW1OgfywmdonGgYJ1M4LJHvab3SRxU3be+fR5iJOE5NL/P2IAJ1kMJv8/9FHrSxA3myK1GDZ0eWrccPPLV6gKMSb+FtE2A4/4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB239779.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(22082099003)(18002099003)(6133799003)(10067099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0l3VnhoTXMrZ1gzRjFvSGlJOGo1L0VORGNDNGwvaCtXMENSWGVIemNlSTZG?=
 =?utf-8?B?Qk4rNFIwL3REWjBqUnBFUTMvU0FHN3RaSmRXT1laeDJmak5rWUQyeUI1dTdE?=
 =?utf-8?B?eHZ5RDlDYVN0bGxFQUdTOVdIQ2s5dFJmWGRBNEF3M29Zc0t1OTFza2M5bDl0?=
 =?utf-8?B?WmNXMzBkV0hkR1A2Q3VxQUFCNWU1L2VyZVZHSVVnajRMczBQQTJFYWVpM1M5?=
 =?utf-8?B?MFpWMy9oNFhibEdxRndpa2xObUJIclVGNWlmMjltUzJ1SURkSGxxVnlzSzdw?=
 =?utf-8?B?MktWT2lUSGZUUXd1dDUvNzl1OVZnWCt0T2tQZkRHM0dmZEtjbmVFVWJuQUE1?=
 =?utf-8?B?c0R3ZStpQzBTdmtZcHdIc2NUZk15Smw0UHJhZ2cyYmwzdDJQcVlWeW9XbS9n?=
 =?utf-8?B?Rkp4dm1UNi80S0xLNlhmUmNJSDZKSWNjYjZIRUJ6bm84YjF3aUJoTGpZZUI2?=
 =?utf-8?B?MUI5b1FockNFNmsvU01pTlNUV0JLTk5XUU9ESUZpV09HVldOeU9ldmxHdU9K?=
 =?utf-8?B?alZhQ1J2Vmp6ZHd1U1g0ZndPU1lmOXM4bG53ZUlmSVNoclJMV0x0UHh5MWxV?=
 =?utf-8?B?ZFk3SzRSRi9OU3hoMUZmZUpsZnNyQWd2dUV3a2V1ZlBvUFpIVzcvamR0Q3Bi?=
 =?utf-8?B?Y2NZeFBjNEgvV2NCdUVuOHJ2eFhNdVFjSU5kRUU3alh6NFQ2d214WTJwL3Y3?=
 =?utf-8?B?YzNrOFQ2bzFiR3NvYWR2TjBCUnBOd2ZWVDFPZjZnK3hpNnArTmJTOVJKaEpF?=
 =?utf-8?B?Um1nVkFYNzVDSEQvNXc5Ym5rdnJMZWFPUmJrajMxOG9wOWJLQ05CK1BZWS8v?=
 =?utf-8?B?T21SS3pkM3gyT1p6VlZoZXR5N2ZOZTBIdC9xa2tXU3lzeGFBMkN5dDBkVEVK?=
 =?utf-8?B?Rk5GT1VmY0R2Wm1Oby9JVXdySnpGRjlrRUpCclJyRSsrL0dNTklqdUl4OVNV?=
 =?utf-8?B?am5EOS9FUEtDenJRTkUwcFJUSWtlY1Y3aW91S0NCdkZFZFgraGh1WDdIaVlN?=
 =?utf-8?B?cHdNMTh3c0ZFTWdTNGFwbytEUEVHSDRsZ1dXZVNGa1FWS25seVZFSVU4KzVr?=
 =?utf-8?B?d3piSlp5L2NYVlVnMEJMRldsTllobzl5VCsxd3FvUy92d1BCdW1SZkxUTURv?=
 =?utf-8?B?NXpPL3ZBZzlHZFpXTTV4VTZRczlScHdMcUJEc1FtQ1lmZ0NxWmt1UERTN0Fr?=
 =?utf-8?B?R1VyWGJtYnR5MWVib2JjWFBjREdiSzA5S0E1Kytvem80blBCQVNSVzFWcHJr?=
 =?utf-8?B?SkV0Nnhyd3I0SlhiUWRKa3IyUGM1SEl0RlUrODE5bTFiMUR5M0FIdllpOVdY?=
 =?utf-8?B?TERPenJFeDFTSnJTWlRkc0dzbmRpUThUd0VOdVBxajNMbUxrellLSWxsbEdm?=
 =?utf-8?B?cmdMNHlvUmxsT01KZ3owR2JKcHdhNUxOKy85a3IyZW03WThlZmJ2OU4yRFhS?=
 =?utf-8?B?Nm95RjJvS0VBV3BDSkFPUmc0V0wwdmJ6Q1NrdEpDVEN4ZFRFREoyQXdJQWl3?=
 =?utf-8?B?MU9EWWtySUxXWlZRMXhNRzlPU0VqbDY1eWRBZFZKS3lEVld3ZUpSczZOd2JK?=
 =?utf-8?B?a0JwQng3dVZVMEQ0Mi9TbFRPMkE2MUJCU3RwWDY1citoMk9qN1hVSVY3M0dY?=
 =?utf-8?B?WWFuaFUwQlFCVjZLVDZqUm1YbGZHbUI5aEUySEhRd1drZEgrUktvQlRrRUEw?=
 =?utf-8?B?elVtZGtTMFJFbjFNUDJxSW8rN2dJd3dOUnhrSEFiUitwb05xVnN5Rlc3L3Jl?=
 =?utf-8?B?T1huNUJLK0xpYktTcU1BSURJUlVjRWhCSSt5V2VFd1VIY01hZktBV1kyNllt?=
 =?utf-8?B?VkF0cFJNczN3bnpKaWhudlZtT3hLUUZUdVZzeHBZclBaU2hFZjF1ajV5TUdV?=
 =?utf-8?B?R3ZMalBCajdZZ2dIeWppaXpXc2tUMTFVVTBTejRmQjQ5QVF6SXNXdWRCWmRn?=
 =?utf-8?B?aFZ5bUdwLy90RDlpYUxEakxEdkxNSUxzZFZTU2tVTWpkVmlPYTNZd1UwR2pi?=
 =?utf-8?B?Nm1YK0prTUc5UURSTWl1bE1MQ3BDaHlYTVZPa3ZoK0dSU2tqbFZLQ05TeWJJ?=
 =?utf-8?B?a2kyMjBrL1F1elRjR1pQQkVxczdoN2F2c0Y3V21MR25QbkNJdG1nZDR0a3ZM?=
 =?utf-8?B?dXhuMW5oMzhVYkJOS1FSOVhjN0hYemxDMW45WXlnV0NkcFV0N1JxYzBPM1dW?=
 =?utf-8?B?MWV1TnZySkVQNlh2OTEwcE1uZGsxTHArRTVueXlFbS9QWVRPNTVVSUo2Slhk?=
 =?utf-8?B?Wm5DdE9rRHZPbFZPODA0cUkzMzBFaVcwY29wY21QS2xpZWkvZXhFa3ZHd2c5?=
 =?utf-8?B?QVZ5aXFIQ0crTUYvOEtIaTBhRU11cTFNQzVUVFUrWXJBRkdvTm9Ydz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d229093-aca3-4f69-1219-08df22f78eb9
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB239779.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 15:44:35.9099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1xQIYC0v/GWLDz7mjWNNJOnD4DnRahOHRxd6AEWWwICOey2C+CVZVUdvxeDBVG/4awRFq+a546NHkH3BsTJiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7445



On 30/09/2026 20:08, netdev-bot+sinfo@kernel.org wrote:
> External email: Use caution opening links or attachments
> 
> 
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.
> 
>   - Whether the issue was actually triggered, or is only theoretical
>     (e.g. found by code inspection). If it was triggered please include
>     the symptoms, like the stack trace or error messages.
> 
>   - What hardware the change was tested on. For driver fixes please
>     mention the device (and if relevant firmware version) used for
>     testing, or say that the change was not tested on real hardware.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

The bugs were discovered during integration and reproduced on a 
back-to-back ConnectX-8 setup.

The first bug (stale oper speed when link goes down) was observed: after 
the link partner disconnected, the aggregate TX speed reported to vports 
remained full speed because firmware still returned the last oper speed, 
causing vports to be rate-limited to the old aggregate speed.

The second bug (active-backup summing all port speeds instead of the 
active port's speed) was also triggered: in active-backup mode the 
computed aggregate was double the expected value since both port speeds 
were summed even though only one port was active.
