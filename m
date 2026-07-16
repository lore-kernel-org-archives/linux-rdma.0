Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013051.outbound.protection.outlook.com [40.93.201.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F426379C2F;
	Thu, 16 Jul 2026 03:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784173816; cv=fail; b=DRbo6luaFKSKMRV8gR5AufctSem9q3CPwgK9xR7V84ILM7XPAGvDvrAyDxPmZgcYr70BWkabZ6dUBzxD9jI+vRpB3jVIxSFJs7ki5aZkTFf8YP7siCRB6VNqwPntapycb+3jpB/Did5ZER+ctayzLjkyhZZz4jW2Vl+DaGDQC9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784173816; c=relaxed/simple;
	bh=ivgSGOWkRivFOQ9U6QYzIxue0PcH0S2Fg8thKBEbSSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l+uCeHSMb+4yRUorCAD2kmGddWnWzJmrBtlgm97yb1mTGNVWbKLwGdrICY+ip+XEoVkS1KRvakg1mvpoxvOPgOLWWAf3IalNKtPwZ9YrNbuspLTgNs4c60SBaQ5JoyU6YjPNvzDJfI+uIDPjrzqxCyXFdtYYw4p4cRe+FIGw658=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DL4HGkZy; arc=fail smtp.client-ip=40.93.201.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DL4HGkZy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bQ7q4QqPc4j0OKVoz+4VLYDgTN0a0Vtg8swV/b2ecGfD9h1SxJzH7demkmIX6HHP1BmjSuV6UhxvXxAejWilSswgwQ4sX2qMcMYzUv3m1Twm4SWi35PHX58DfEhH4y9Km3TpZzuf7fSj1Z9K+B9r8RPTSiECl3AXMXjWYKgV4RX8TNXMg/DNa45LEhSE6E+A9ZAmvvfFnBgZIHqo0Zo57MJrKf/54TOxKCktY4u1pCoDknAnFSDejHCqh+EeU93AxL1ISNNkS3qyasPpYD1ltBFhlxvdcsrquOq80IxZXU0lx26/QuTDA+Oi66EsgSdR5M9dkbqWeWPJBmCHB76+/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hrvQfb7xDKycJGFgY8pOB7p9mCKwmob4IWITAXsnP+o=;
 b=pPKdMznuG7c8TW0RB7uz69JOIi+hYeI3onxrAUts+06O+nmaS569HnRKwP5m43w+8uhLFDCz7imaQUu1jh/5urNTKQo1fRerItCu8xbOUkhMGNXL1bNg+t/Tkii7Foe7QZhdfPj5bKFOwmn7/ZPN6K56Kj0MAc7HqAcSH/yOJFrhzL76ChLMGEsbIbgJzZbKJlnj6BzA6V0pp7kW8Rscc2bMxFvMJusYaY7+7ALmN3PX8/GZG94TPtoSfD4zqi/9TyUH672fN30SyuMPqzfLXBotEUw1Ws0+F5YbJ7/zOiMXtwSszMiiDaRgPgY1ZxoSP7XA5GcWwt3vaw1gClRoAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hrvQfb7xDKycJGFgY8pOB7p9mCKwmob4IWITAXsnP+o=;
 b=DL4HGkZySWcjOVs2iJsbkUfWw+gtitE9kQxcL9didbXnu9WkqaRGMiPVSxij0ZrbaVhKXWRTJHVixEa98f2aK4XBW+nMU1NpxGroFMEwj+crSzJAzaKrJ0XZ9REV4Kb/1CvZM76/xs6dD+yHoaomYc1AXnII/V3X2aSQVji02p8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) by
 LV2PR12MB5725.namprd12.prod.outlook.com (2603:10b6:408:14c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Thu, 16 Jul
 2026 03:50:10 +0000
Received: from DM4PR12MB6302.namprd12.prod.outlook.com
 ([fe80::32ee:badd:60da:3db9]) by DM4PR12MB6302.namprd12.prod.outlook.com
 ([fe80::32ee:badd:60da:3db9%4]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 03:50:10 +0000
Date: Wed, 15 Jul 2026 22:50:06 -0500
From: Wei Huang <wei.huang2@amd.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Zhiping Zhang <zhipingz@meta.com>, Bjorn Helgaas <bhelgaas@google.com>,
	linux-pci@vger.kernel.org,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI/TPH: fold reserved completer encoding in
 get_rp_completer_type()
Message-ID: <alhU7lktqNxAPB4E@weiserver>
References: <20260715202409.3767494-1-zhipingz@meta.com>
 <20260715231525.GA224907@bhelgaas>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260715231525.GA224907@bhelgaas>
X-ClientProxiedBy: CH0PR03CA0368.namprd03.prod.outlook.com
 (2603:10b6:610:119::17) To DM4PR12MB6302.namprd12.prod.outlook.com
 (2603:10b6:8:a4::21)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6302:EE_|LV2PR12MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: ada08f5d-7c42-4165-5a99-08dee2ed553c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|4143699003|3023799007|6133799003|10067099003|56012099006|18002099003|22082099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	FC+J02NXJtHiKwpQlONNBI9Kc2DhOn8B4NQUeYAT4uTbcfm6ha9gE8TKnK2MVS4xOiGDRz6XkXhmbR+E17yfPtDdRGo901NVwIdhZDzcsJtKvc/9af2QzR83ShugyyVxgff1cZ9MpBMmeZqjGgqjTYy5PgEGegC5+XiUqHzPKwfw9ur7oE7mms7adEDTHXktuhxwp4uOXP50puEtmeEQfC3paDf6CELXZHp3TA/dbyhefr3Kdm+Vj9L3VEH2lfM1lgP5RNNEIYpNGAmcFy8w339XxfHG+PhxsdFz8sOmuJWPkwkjb0CtBZIEuZ4+kmER/PZqayK9oiUZI7vd1unRXt45JhGEUbOcA0AU5v7To/ZfVvLssQdFmiV1whHKXLfPuDH65wR+Q+chgqoXPLN5MD6TPNJ6Z9h2/ad+QISoM+MTiaASTgSrmCAicvADwZzqtkFwWMJHPZeQ04eg6ELlVIxwCHJ+Amg/dnojNH2dvQWMNUXsKuDvC5aG/J9nGXiKDj/XKx1nyZL/K8nkVSx4G/b8qJj20K504CT9/o33tqSHrK8wsbOMQdCdpdsFuLLUQZ+Y2e46Mw4J5XvBonu0jAHEr2cgMyvaYhYUf5r5Vq+hCj859hRfo+Dj+ntTcuv9IOKJdmj1KhjrZFAgIfe4V5N3iEHHVOVx6tnEw9S/KtQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6302.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(4143699003)(3023799007)(6133799003)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bW9QYm5XVFdncXM4YmZGNmtRK1VJc2k2aWlKOUl5K0tUT2UvM2pOWmdOTEMy?=
 =?utf-8?B?c3VicHRGTEpXaDF3N3duR2xhTkdYc0ZpN2tydjgzZUZpdUN6YitZOVFyaHh6?=
 =?utf-8?B?NmtEVnJ6c0hPczE1YXhzQkNTSHp3TWNQTEtpYjl4TEhsRjBUTTM4akM4OVg3?=
 =?utf-8?B?Lzh1c3pkNmpDSHZ1TW9kQ1NjeVVtVG9NREY4UjV4WWc2czdOWHFUV2YydU54?=
 =?utf-8?B?ZWRBQ2s2b0toamhwZzJqR0NFdVExckdCcUxObGZKRVpuWUxSa0JHc2c3dCtq?=
 =?utf-8?B?ZklyZlJ0WHZmbTdPOE9DMTZWOEJUVERnU3djYmNBT1JCYTRYanEreVAzUldw?=
 =?utf-8?B?N051dVFyUzFBcGVNZHU5ZGQ4elBtZjFSZS9XcUszclNsYVpwMWRIUmNsbnFE?=
 =?utf-8?B?cUZYUE9IcG1yeDgrL1dSTnExS2VMTFBmb3ZtMFpsYlhtZVNZelloZDBvcUxL?=
 =?utf-8?B?UEVUc1NWNmIrcWZMQjg0d0hkN3hxa250V0JpMERIQmFFZkliUFhJL0pkQ1p6?=
 =?utf-8?B?T1RDQWQ2MTNnUU9paGd4eE5kdWFrbVE4UEx0OVpkdmdUanNLT2RUcmxFbWhN?=
 =?utf-8?B?eDBWMWdNVERLbWxYZkJUaSs2N1JVVjBLYmliSTFPWVBMbjBDaW8zeTQ2bzlp?=
 =?utf-8?B?YmpIY2p5WG9SOGtqVktQR1U4WEJnZ1hGZDlPWk5XRzJJcVl4ekdPcUFLMEw1?=
 =?utf-8?B?NWpyenlucWI1ZUdoSDgrZFllYXJHdW9HS2Ura1lxdFRERlg1OGFZQmJxLzl5?=
 =?utf-8?B?eHdnVWgzUkZCRmdsSzZOS1FodjQ2d3M0Q3BoNk93YWRVK05ISDRXdWxlSDJu?=
 =?utf-8?B?SWhNbytwZXNUU1YySi9kNG1WZzQxYnJGOFhMcjdJNk81TG95a001WWRub3l5?=
 =?utf-8?B?V291K1RySlBEUWEvYnZPaU1oVGtDZlpqWGNHbUJKOVBjV1c4QU9sdk9pWElR?=
 =?utf-8?B?a2ZZUTk5UFV1TGZCZTRGZVFpVzAyRkNBMHBEd1NlK2Rxb3p2T1VXdVkwM3Iz?=
 =?utf-8?B?TXJyU3JvRGMwQlJ2bGNhSDZlSjdLTTNRVm5RTHUxZ3FXMkcrTE5xR2VNdHFr?=
 =?utf-8?B?Wno1aUI5ZGxhMmMxZEgzZGRDZUJ6ZzVpaDRWNEt6dktkWmFyQURNT1J1bVRr?=
 =?utf-8?B?ZzdMQVpyTE1rMm13cXd3RWw3SDBsSmUzT2lVQjljdXJsUy81QWZJMnJlZFpG?=
 =?utf-8?B?RWwwMjAzcFBUZVVCRkEzU2RNVms0eFZDSS94aE1GQXQ0M2kzdmhUYi9UMkQx?=
 =?utf-8?B?SDFDWFRqT3ErQVBSenJHQ3JTZGc5RGlwYjhFanpUKytFRk4zQWNzdXl1Zmhk?=
 =?utf-8?B?NDVqd2NBRFBpWmhsbWRjMko5R2R5aTFDNmljeGVsRDBtZ256Ri9DTXgzS0Rs?=
 =?utf-8?B?SkkvOWlaaUZXbEw1SlQ2WDd2MVFIZHRmTDIzN2NabDcyd3F2U00zOHVnaFFk?=
 =?utf-8?B?RjF6dEk2TmVGd2w1Um9DK3diWWlMckV4a21IY0ZBR29aSHV5RW5IcStZTHhI?=
 =?utf-8?B?RXBwY3B6RXIrd2h5ZEdEbWI0QmpQS2lqT0E4dGo1OEQvN2ZWWkczMGVZNGRO?=
 =?utf-8?B?ay9DYU91ZjRpWnRHQ3FmMnU5Q09SV1A4QU1ZNU93VlBUOWtrU0x5ZUk4b29j?=
 =?utf-8?B?YkRLamcxYzhMUCtGbHdza25MRG5UcEdmSEJiTGxEUHBFMlF4cXRPdWRIMUN2?=
 =?utf-8?B?YjdxZnpaNURRanhXamJodDZ5aGc2Wk5mUDhkOUo4QlJGSG1JZUp4cDFpQVMy?=
 =?utf-8?B?bG5wRnRpY29HL3p1Mi9tc1FZMi9QcHBEVmJyLzVHSHl1djdMdlRwaFhQc1Bk?=
 =?utf-8?B?T1R0UXBESHZkaVplK0xHdFBHQXJVMG04T2VkSTE3cXhCUDRyekpQOGJlMnM4?=
 =?utf-8?B?UmlhOG4rVFI0dkI1Nll2VGt3UU91T1hPTmxPRGhJMUl2YjU3WGZRdXZWTFRy?=
 =?utf-8?B?OFJvbEZ5SXpyaHNFWmNSeTd6WWpXS3BNcU1tVWo1ald2RTBXYnJLcUxNa2Uy?=
 =?utf-8?B?bTZta2FYSVB1dTIrV0JBbExXVGhSREpuR29HTWpySjB6cHlGZWFsWndRTnky?=
 =?utf-8?B?Nm5LLzNRR3lUUm0vY2RjSFlhWG11K2RsTE9lSXd2b2dUU3RqNjhlUVl2TUht?=
 =?utf-8?B?VFp5a0lYN0VIdDNBeDAxU0p5QzlBVUI3UjFPWklyclRtTjBwT2FTaTZiMzVy?=
 =?utf-8?B?dnFvZDhxRVJiS0RWY3pWL1lDaXRBWGVreGhzK29NSnVOL0F6TVo2WlZtM2Nv?=
 =?utf-8?B?Mk1SdXg0TFJhTXRETStBWGhYNFNZdXZnNlViYS9GNU9EcURWbVY3UkgxQWd0?=
 =?utf-8?Q?G9ZYqHKzJJ2BW8dpWJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ada08f5d-7c42-4165-5a99-08dee2ed553c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6302.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2026 03:50:09.9851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ciTU3iyvHXuUOx4kqPXhi+mT1RsFOih11RZO1EzYoWxCusdiaDeIYZmPO9pBO1V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5725

On Wed, Jul 15, 2026 at 06:15:25PM -0500, Bjorn Helgaas wrote:
> [+cc Wei, author of f69767a1ada3]
> 
> On Wed, Jul 15, 2026 at 01:24:00PM -0700, Zhiping Zhang wrote:
> > get_rp_completer_type() returns the Root Port's "TPH Completer
> > Supported" field (bits 13:12 of Device Capabilities 2) verbatim. The
> > 0b10 encoding is reserved, but pcie_enable_tph() feeds the raw value
> > into the requester type:
> > 
> > 	pdev->tph_req_type = min(pdev->tph_req_type, rp_req_type);
> > 
> > and later writes tph_req_type to the TPH Requester Enable field, which
> > only defines 0b00 (disable), 0b01 (TPH only) and 0b11 (extended TPH).
> > If a Root Port ever presents the reserved 0b10, that value could be
> > written back to hardware, risking undefined behavior.
> > 
> > Fold the reserved encoding into "not supported" so only the three
> > defined values can propagate.
> > 
> > Fixes: f69767a1ada3 ("PCI: Add TLP Processing Hints (TPH) support")
> > Signed-off-by: Zhiping Zhang <zhipingz@meta.com>
> > ---
> >  drivers/pci/tph.c | 18 +++++++++++++++++-
> >  1 file changed, 17 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
> > index 655ffd60e62f..ebe1aa5ba5eb 100644
> > --- a/drivers/pci/tph.c
> > +++ b/drivers/pci/tph.c
> > @@ -196,6 +196,21 @@ u16 pcie_tph_get_st_table_size(struct pci_dev *pdev)
> >  }
> >  EXPORT_SYMBOL(pcie_tph_get_st_table_size);
> >  
> > +/*
> > + * Fold the reserved 0b10 "TPH Completer Supported" encoding into
> > + * "not supported" so only the three defined values propagate.
> > + */
> > +static u8 tph_completer_type_fold(u8 comp)
> > +{
> > +	switch (comp) {
> > +	case PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY:
> > +	case PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH:
> > +		return comp;
> > +	default:
> > +		return PCI_EXP_DEVCAP2_TPH_COMP_NONE;
> > +	}
> > +}
> > +
> >  /* Return device's Root Port completer capability */
> >  static u8 get_rp_completer_type(struct pci_dev *pdev)
> >  {
> > @@ -211,7 +226,8 @@ static u8 get_rp_completer_type(struct pci_dev *pdev)
> >  	if (ret)
> >  		return 0;
> >  
> > -	return FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);
> > +	return tph_completer_type_fold(FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK,
> > +						 reg));
> 
> Is this just defensive programming, or is there some hardware out
> there that uses this reserved value?  It's kind of an ugly wart to add
> just for theoretical spec conformance testing.

I’m not aware of any hardware that actually uses this reserved value. While
being cautious is great, my view is that such RP is bad — arguably to the
point where writing 0b10 straight to the device might be a right response
(kidding).

> 
> If we really need it, I'd rather read something like this:
> 
>     tph_comp = FIELD_GET(PCI_EXP_DEVCAP2_TPH_COMP_MASK, reg);

This looks reasonable to me. It might help to add a one-line comment
explaining why tph_comp is sanitized here?

>     if (tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_TPH_ONLY ||
> 	tph_comp == PCI_EXP_DEVCAP2_TPH_COMP_EXT_TPH)
> 	    return tph_comp;
> 
>     return 0;

