Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FE3EFD04;
	Fri, 16 Oct 2026 20:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792181960; cv=fail; b=pVbTjiPXQmzUYxDm4XTDUXlWMdquNaRjrBF9lVg3Jnqt5sut3ljEBiWbvJGlvO6UcPAwsUNKw6G1S5vnGBq4pnUViJihTS4Bu6m14AMqvEh6h4SAROmhTFBFbntJyiwTw2O0n3PY9sZT0U9Sq1a68YNUCIjXw9/O6CF4hP65Zkw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792181960; c=relaxed/simple;
	bh=3FA571KD1MXQk3Idfyy2qAMXHV/Nn3P4h95IAZEAvn0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z1PbSc9AvPEi9i26/sirK7X0T4vyLlvCnkV23RAeFKaoLNvI5acMQPFfdG0i1h2gfwafGf64FAOf+q6ufkjH9a4azvxt5pTeNn2rpeQrqTp5sQOKrk7CK7FF484+HfiIxs1Fw+fYwFGwKXOAkpDmDwiSNEl2oOFczUimA+0Anh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xsg8BoKc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nFZvNni+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xsg8BoKc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nFZvNni+"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GEsDhS872689;
	Fri, 16 Oct 2026 20:19:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=P/pAiuRhz8TsnMq6Qne+Ok4BfR+ynYXJxi1y/ZIM2yo=; b=
	Xsg8BoKcNxJ7DsUgwRr38gQsSRAgK8y4Kn9amfpagqx9QmZhSk7bioUp2zkwie/E
	y/2n195g08po3DlZlKXYitRgR7zprEH5v5/9gn6zkX7a4tWWmQozaKeqnHSufeVu
	TeYskJjahcsF+qYpKCO7OAlXi46VHPD7kCctaScgTm8aVz0gLRRUnO+guRs2G0Ai
	PxBa1ufX0rCjGNsXxY4pvQ6dRW9Rn19+KNvK7zdB6g3YbO3aKmbDg/iqt8virewB
	5rMbfUtxrowb/AuAT+gNo1mfygrL/bBmE+wWlud+qsbWod9QOBVuJgbeST/ZUzlm
	7NC6ahxG82AZLAyh0/Hn+Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h7dde3254-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 20:19:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69GK6rrb027440;
	Fri, 16 Oct 2026 20:19:05 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011047.outbound.protection.outlook.com [52.101.57.47])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btq8pqy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 16 Oct 2026 20:19:05 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g9FzH9FL1a3U0+qfqnh2BbzK6cl25RuWS135r4Yuz6DJefDqOZuYqG8Rn+kj0JackGoGKxWRn3GQDSHlTaRjJuj3MWuIq6n/ummkNhQbqaPxdZmPgXwHPOTo64RwdX2/9WUFw1nexopuFoEfNXkfPkrtQohjcaa8M40dGFkiBLZ0oi2ZrmW1DXd6qU2U1/3qTyYyUerevUvTZl5QA5Hx3n84pNrTYBiM6shu4ncoAJfYw/9nwlP1jpaUzJKiK40hsxoTz2EorK5F592/YmyQ2sCTBpSBaEvt4cTuvYCofSz4Sehn8Vn+vhyStEpeh/Qt+XWIZlBQRylwHFcHj2K7NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/pAiuRhz8TsnMq6Qne+Ok4BfR+ynYXJxi1y/ZIM2yo=;
 b=dFcJ0DRcoSe/IIYgNozg0PZ7Pbiep7aZRaxFSmEmtQDTi+oITDzGhjCJxD+g4Dhk1ATCaxNbmn7k36eQbVOEey5yMmGTMttWpZPDpW0ZQVxCUDSpoxAphO4tWrwiGV8N+nM+EOU5dTxKdr30oYe9Q7no/gKXyi2Hz0v64LL9gnPQpaDEk0QkbIOIsu5Gq21+RiJZR2X52u/9MElpiGMoBODNI6HFVuWjbZRV7yMXJmDn310qlNoyk88cinnF0BUebrTtqELiIyziST7UstFQS4D1CRRuFtC7HRZEpZmynY8EQysWAidgJ0wBU0TrnXHPVv4T1d39L4FdmJ9pr6vopA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/pAiuRhz8TsnMq6Qne+Ok4BfR+ynYXJxi1y/ZIM2yo=;
 b=nFZvNni+4dYFWG39LPkhGkPqs5mV91AMQJ4MabDjqj8Rxmp3CR1W11zXjnvye93JkuK9odhqxkGLTOUvEm94cNT+XWGFVb6smS/6ojr2ysI+Rove2r3FMsWrJCKlN3hNp1h0YJjVlS4QqDmYUAgV3rXrGddFajNgdfNAX231/OI=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16)
 by BLAPR10MB5026.namprd10.prod.outlook.com (2603:10b6:208:322::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.8; Fri, 16 Oct
 2026 20:19:01 +0000
Received: from IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f]) by IA1PR10MB6050.namprd10.prod.outlook.com
 ([fe80::645a:f184:3a35:ef9f%4]) with mapi id 15.21.0522.011; Fri, 16 Oct 2026
 20:19:01 +0000
Message-ID: <7e69b862-7cad-443f-912b-ce2db7854d60@oracle.com>
Date: Fri, 16 Oct 2026 13:18:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [rds-devel] [External] : Re: [PATCH net] RDS/IB: validate receive
 completion payload length
To: Allison Henderson <achender@kernel.org>,
        sungbyeongchan <tjdqudcks0424@naver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet
 <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Andy Grover <andy.grover@oracle.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20261006205204.1322102-1-tjdqudcks0424@naver.com>
 <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
Content-Language: en-US
From: Gerd Rausch <gerd.rausch@oracle.com>
In-Reply-To: <c1efb25a93739dfe2c16828bbcdc9bd7535850c1.camel@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::26) To IA1PR10MB6050.namprd10.prod.outlook.com
 (2603:10b6:208:38a::16)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR10MB6050:EE_|BLAPR10MB5026:EE_
X-MS-Office365-Filtering-Correlation-Id: c1251db2-d7fb-4f8c-8beb-08df2bc2b745
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|366016|376014|6133799003|22082099003|18002099003|10067099003|3023799007|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	SVU1rzxaYokJvTYCZ7OesCGACyHS8pYFQ27D9h5gYZvD24ezppT7fMcqKCZNzOzw7tiN4V2Uq4GXA6L10kSXS1Gx6t90u+U8ZqNZAJ7oz6HjyGBdpkJ1lfQzakQRQf81V3epahOcmuSyKzfzm/U0rcSVoyQBNE4JHY40Yj/XER2g1cTSgfhbJ6AczOIoFfx8JSRnkukGSuWjQ/tMuuiSP9S9bYrrtyyi7WPXF/30vEmYPemDb/T0eNcjPRaj/G/3200yTEZGylztce2WxMBOzFtcTTjTiRzTCxUs/wxXcSUZMZqggLNfynsqlZH0rP7mlw2F1XxCY4KvK3Ibh42tncKOa2pLbGyPz6fuHVR5fDg2Cf/zcpEzebkMKofvesXxfEAeQYsUTLfjG+kn7pRgO8kwHGV7vVHm8VYk2Fr5HAI9NxaZUmpDf84Wy5qVWClOPUibM9DHNKez/pDtM7kJ/UM76tdSnSRtFDIhsaf2gaiRYH6lqC3SYplbN5NvhDGZvDuWCqojbdczMq3AdtlEU08fe1HJjPvnl2l3mC2N0dN4KXhY6cwQEAbKagaqm/MDpLSQUge2OLLCaZgwEBtqcMlPkwcGgO5LuePpVux91xG81CzTkDeMbb4wNbq6SpVO1sOqJlhxViIPvTnif5sB7WhP7nRO4TnxLyo78Dfqfz4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR10MB6050.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(366016)(376014)(6133799003)(22082099003)(18002099003)(10067099003)(3023799007)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q0Q0eDRIRm1sSncrNWp5a096MlA1aHppc3dYZHpoUjZCbTVWWHI2ZC9GYUww?=
 =?utf-8?B?by85bnY3aHlpcUs4Ulk0OTJZR3I1V1piU0g2eXZQbUNCci9PMVg4MW4vTDJx?=
 =?utf-8?B?THhlNEZNYjczK25BTVFwVGx2VDBuckZCY1ZVeTM5SThnWW5sazJVZXVqUmxp?=
 =?utf-8?B?TkU3T2lUaGcxaklrQzFyd1oweGtndmxGUjhHbmY4cU15bUFsNzlSN0wvZFVN?=
 =?utf-8?B?YWU1UitBQUF4cUxiOERKYWJJS2xuN1Q5d3c4NktXOGxjWUNXSjJVNVhMYm85?=
 =?utf-8?B?MGV6d2tLMUQ1YkgwS1I2RENQeUhuRnh6SEFXa1owUlBnektkR0lQdHZ3R3dK?=
 =?utf-8?B?UGFoNi8ySVNqbHVJWmU2Z09EdzVDc1ZVazJ5L1RDc25XNHRnTTN3K01zSnJQ?=
 =?utf-8?B?R1NGQkZoRFp4R1dsZ2lCVVRVbHBpQ3B5d0tIQThRNFpVTDUvK2dld1FtOVc2?=
 =?utf-8?B?VEIxbEg2TmFOSndPWW8zWGY3VXFwQ0V3ODB5MDVQRFg4TzF3YWpDVG52bjNX?=
 =?utf-8?B?SVFnZjhHRlo4NjRIakU1TkxiRGFiSllHWXlxUTBTZWZTWEpldzMrajMxVU1i?=
 =?utf-8?B?akYzOEJKMFpxOUNGMlN1bHY1Uy9WTHNQeU95bHNQb3l4cW12TlRvT0FpTW04?=
 =?utf-8?B?TWpGa2E4RW80YmY3ZGxOWXpVNTlHY2daVEN0TUVZcllLUHNlTU92MnQwYjBz?=
 =?utf-8?B?NDhYNStKTi8zTmY0WGdJdTNVeHB2TEdCdHhhM0FpcC9oNEl6ZkZkc1NJR2Zq?=
 =?utf-8?B?K0VuR2pJdWVQdVdaL1BVTWxjMjZpVWgrdTR3Y2tIU01hMkFLTUI3L0diV0Mr?=
 =?utf-8?B?RFFpamU1SUwzUzVSeUc4S3J2QW94WENVV0k2WVpObTdWWVlyUWthclMwTGp5?=
 =?utf-8?B?NUJjcmtrc0NvRzBKZlMrRW1wNTFWUXVobUVFQmVqSmIvVTNtMjhqNUJ1TE1K?=
 =?utf-8?B?UXBZTlZxMWIxVGpiRDI4Vk1NVk82enJLV3k1empJcEt4NEIyUllLM2xYMzlI?=
 =?utf-8?B?dklrTWNad0cxNTFHWllodnFvQTFORDQ2TlpQYXRjMWdHZGY5eklyVi9ybkR0?=
 =?utf-8?B?VWJiWE81Z0xKVDUxQlJWZG1tOS83NDU0cC9ScFNFRXE3RzZxckl1aHgvTlJr?=
 =?utf-8?B?aWVXaGdFVGxNZmFXRmpyZWFKSlB5eEVCR0FENWZuZk4wVXpKV3dWcm1ZVkRw?=
 =?utf-8?B?a1JLdVZpcWFHNk90T2pNNmZtSFFkODY4MXBSMFBjcDZENVhGZHZQNWlJUEIz?=
 =?utf-8?B?VTlrUk9ibzN2THNCQVl4S1FQbktBRjJuN2dLa2dQaXF6M3VmQ2lWd3ZrS2dG?=
 =?utf-8?B?SXM4bDdIbjRyVXFKR0lqbHYzem1SUnRKOHJiaGVDR3ljRFF5NlJBakUzVHk2?=
 =?utf-8?B?a1lqZTZtVTZSMEh4MHdlRnNsWDhrck81cWZLSDFVL3VadnR4WkZMNTVIbkVW?=
 =?utf-8?B?b1I4MTZoYVphalFNR0NjQWxWU3JXNUt5eit3RWRLUWp0OUZSN3F3MmZKTDZi?=
 =?utf-8?B?TUxwSVc1dUZzN0JsWTYwc2pSamVhdURVam52bi9FZUl2d3U1bGZOM29rb1Nq?=
 =?utf-8?B?bEpuRFR4ci9EWUtkR282Vmc1T3cwOWNKcVNCeTZLcmpidDJTdHltRDZHRkc5?=
 =?utf-8?B?MkdMeCtJaFN4UkpjL3o4T1N6U1FrTUMxQUtsMzRQYk1yOUNCZ2VDRXZtVmdv?=
 =?utf-8?B?R0plR3l5ZGVEVFlobUNoSEdIZDdnK09pK1dOYTdhV21LQmxZVFdBMFVGMGVx?=
 =?utf-8?B?dy96K0FFSERqcndHRFlNSUIwa2tVYVRKWkl6aklJME9YVWVuSHcvZTVNUFE3?=
 =?utf-8?B?V0dSN2VvcnhucUt3MEFDUXFVbi80cFJWdDgvZlBrRFJpaFNXQzJqdlZ2Ulo4?=
 =?utf-8?B?cXVtbHZhdG5oMmhuTko2UWtJTittb2hST1prazV1bUJmem9PQUkrNDZDM21r?=
 =?utf-8?B?VWs0YW5FbldTWHVyamg1Tk9TcEdPRU9GSHpJT3Jyd2xzajk5RlJ6SzlNRUZ4?=
 =?utf-8?B?akVZazhISVBIaHBGamdwWXVCVEEycWhPK0hyOHRhUlVvckZNaFB4WXIzbGlp?=
 =?utf-8?B?YUpFaHJEK2VmQWpIeEZkZ1F6WlFuQWdVRUR2K3YzRElDSG9McUkwTEhXY0RV?=
 =?utf-8?B?WXB6MmtSdzRBbnl5YXAxMC9aemhnMTRqM2t5d0sxTklNc2JmTVpMWXpCQzBF?=
 =?utf-8?B?andGdmtLb1ZKVFRlaEhqaEM1dE9zM2wxUWxKRy9LZWFpdU1wbVhTVXdkRzlU?=
 =?utf-8?B?VDVMdkhtd1k3c1hRbnN0emdSOXRTVFJGZU45eU1xaTloamJsVjdlV2xvZVdX?=
 =?utf-8?B?WVNldE56V0hpUVIvNFlhRGx1UTlpUTMyS2VOVmg3N3kzems2YmNwUT09?=
X-Exchange-RoutingPolicyChecked:
	sMbeP8EYsL/sfYP3rI8CL3E10V4mV3XV3m1nI7ujhGuqRvKcsgf83anfQRzFPfWoA+E9buxDsYD5mW8fQJOvypLaVh9Zrhz+Q6J+1JSP9tY9MBU4p3JjGNVoIrENwxUgd6YTQO6HQwIRTyuNwXSqTb/GWkt21XjMpo4hi/039Q7q186H5k/jRDu3Kc7I9tLwZUchAQH1QKwW4zw/G+uo8LGc1zdhxUe/Fzs/5ZbdizphHhqQDeHLsoE8nkXxcFIVXIWaHZa6Ib6TBn334Cxc4ks+M70V1KbNoKLuUGzfe9xowmoaYtrVlCqjeUW8DTuOlL0YnSPygur2R/XTTZxsEA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	c0XhVZv4iziL1hmiXiEqrc9Dzd/BU+2z8UpDFSDmgN1ShahW0XP2WM+jMwgnMDlR/S9s9CAzZmzRf310PYq2O3Fuvm+tkxF9+zHfq+Arz9oo4RiJQb7dal6gtWEITMOGw6UpaR8fX3Hu1VuLSbF8hKrY8NrSR8nS29E+OSPuVD8BPZXkjT8fIjbBBTjeqisVOrRo3A2FOvtDpbY55jIip3FdtyhuNtGT2jZGLGhCNoDfgfFm6LOvqjBKYJwEQGIYt9sNFTNa/yqVhD69YixXbEYhOobSsdbU9ou/DZqYy8Lcspu1Z4oHMqRuTP+Mu38+dupMkYuYw8aykZt7weWa4OXLS6lhnvmiOhutnG6IUiARXdToPbrhVT78l0DR67tj7sriTNr/BAZZtu4cwANbhkCoBeYg8zdpVGtkHz8dxODezSuKLXAu1CaCL7IPZEWgwysd0V2/eb2Mw2C0aoXRS7soKuCT/X674lXUPsHK5E7yST5ziq2DcsYvKVRrzkJyUdnJmHLi+PW1+VmvRiV7oZSOHA1FxgmUwOsI/4LuQOsheiQNIW6KU1jHmktp+u9G1duUY/OLuSd4gTkHi0rPCVfAeMto2VqtZEuuY0uEWQ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1251db2-d7fb-4f8c-8beb-08df2bc2b745
X-MS-Exchange-CrossTenant-AuthSource: IA1PR10MB6050.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 20:19:00.9818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Or1nxpWV5eXxROez4xqpwOQX3Qnm49hGn3KvHx2W7EbpLvHry/fszEOR6bBCZMv9U8/eLzmBRcqkIsgNHZ95ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5026
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_03,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 adultscore=0 mlxscore=0 mlxlogscore=967 bulkscore=0 lowpriorityscore=0
 spamscore=0 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610160080
X-Proofpoint-GUID: UyOuIIjMI0b3sWrJxXekb0YZqLnriS1s
X-Proofpoint-ORIG-GUID: UyOuIIjMI0b3sWrJxXekb0YZqLnriS1s
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA4MCBTYWx0ZWRfXwIh0hokjp/5C
 yhjlemUgN46MURazlMBB5QArHfhCwY7mWvfpJcOO812j8ssv31/0aGKyw0l/kbsj89rAjs0VNDK
 78wSPLpBRok5RJUk9niqisCC8EnLMKf/Rk2cLEsoWnzQ0Y7KlHwd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA4MCBTYWx0ZWRfX3Nt+LTHRwD9u
 uWsot4hPqR6zK98zuEU9GylgEcJ+JKsy/SdEsh/8OkGB0MY8bo070QUXTpsZcr36Lop73E7W/2a
 DElR6lwfFb+D6LKRIWXFxNWB7KV0P6U06pkrOdq5MV8iSV9MLezfm93TxNdUIo1d8Xc4UJFVDzM
 f6p5F4ce9fYAmGWejvQhe0TkHJpFdQxIUJrOSw8sXMscVhFPi+XspnjHPU2kB4KAAE3aemLS/Oz
 dq0rEyvifHjkBEOukFF+SVfqGufD/BVuoxtm0npOa8tg5S6J9u9gZ/HQDrSM4BnZrtl7UCSoeWy
 zeMC+chwwZ8mvg8t6zs1EKy5QjdZCJ3HPrRWlFwg9YzQxTeEcoxhNZMKtBKYRRnylWMRzFTlnoZ
 7C0QOjuI+UpJvwNbwdlH1jK7NGaXi3bIoiKpoApQIKxGcmPWSGctcWdFTGhrygahv/zwbJXF3FL
 XtUoZd4QOszEfSWFeFiKfCeeYdqA44rhkxbJFYtA=
X-Authority-Analysis: v=2.4 cv=J/8/fwnS c=1 sm=1 tr=0 ts=6ad286ba b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=BqU2WV_vvsyTyxaotp0D:22 a=HDotkElSBX-5Y37iUzwA:9
 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf
 awl=host:12108

Hi,

On 2026-10-06 18:13, Allison Henderson via rds-devel wrote:
>> --- a/net/rds/ib_recv.c
>> +++ b/net/rds/ib_recv.c
>> @@ -949,6 +949,15 @@ static void rds_ib_process_recv(struct rds_connection *conn,
>>  		}
>>  	}
>>  
>> +	if (data_len != min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE)) {
>> +		rds_ib_conn_error(conn,
>> +				  "incoming fragment payload length %u, expected %u; "
>> +				  "disconnecting and reconnecting\n",
>> +				  data_len,
>> +				  min_t(u32, ic->i_recv_data_rem, RDS_FRAG_SIZE));
>> +		goto done;
>> +	}
>> +
>>  	list_add_tail(&recv->r_frag->f_item, &ibinc->ii_frags);
>>  	recv->r_frag = NULL;
>>  
How does forcing a reconnect help this situation?

After the reconnect, the sender submits the exact same (incorrect) message again,
which it kept in "cp_retrans".

Therefore, the exact same conditional triggers again.

All but the last fragment of an RDS/IB message are expected to be of RDS_FRAG_SIZE.

While there's no good protocol specification (to the best of my knowledge),
posting an insufficiently large message can be seen as protocol violation.

Therefore, apart from security concerns, the previous behavior of garbage-in / garbage-out
is IMO better than this behavior of just endlessly forcing a reconnect.

If there's a strong desire to address this issue, the sender should be
told to discard the message. A reconnect doesn't address this issue.

Thanks,

   Gerd

