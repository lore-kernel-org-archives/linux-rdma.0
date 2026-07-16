Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C116F25B0B8;
	Thu, 16 Jul 2026 08:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784190828; cv=fail; b=VLVG8+5FyzFzeq38UaxGmOVqV8zt2d3dkxvKfEDPLlL03U7qnwI+zvjZ+X4QLl9L+EEXk07O7QvXScAIKIFCJd8fG/QVL0RbVQ1UxSf5cIALMGSpXHb+E6eLr4VXuPkCYKZBSHnnfdhSwmiRscEJSDuegK4jltZtLSMNJXjm1g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784190828; c=relaxed/simple;
	bh=oPTN44Jt9hRKeEga4mbSXs4Z2fr/B+sSIqK/o+oSIgE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ECPV//PKArlUn1ccKQhi9/j+rZcaI79uaPQJWrn0lidkvddlHgNXPm8mYvA/8OzHB953dGAEDY8upy0AwwM8Cxgto7L70dExbDKMR9kao+cPxyvkJ9zRyzglTZuvo/rT0jf6UaiElVuImzGb7uMU4kqjIEMOVB9810dgTGyEM4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JemBpzAA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=smUairAa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JemBpzAA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="smUairAa"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66G4k1oa3965345;
	Thu, 16 Jul 2026 08:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xt95j7tKdDR/Za+r436LG869Ee4A4oPaMQXv5W845tE=; b=
	JemBpzAA6G3StqcptW4VkngrkV+FZL90BnOqL4HYQHXL2g8gnF77vF1rBIMZ04zb
	8bQnhit2kEW/oeTfjO9YWUfgbFg+8WDaJHidODeksSkTj6bx8c4acqxbkGXatYE3
	fmglsvQRkBlr0/d0VWTwK+/R3s04zz+ih9PFkA3vID26saCB1OzENaO5Es/35Srn
	LVi8p602GsAGxuJxEbpNSd9jdoLOpd3CLCQ6lSr+SkO3aiFgy4SkFMN2ummE89gW
	ny89nyObfHtH/ov6oRxa2zf3ZSqQXZIwyE6L7igRJY8Mzi+YVqwXCW0e6QtMRUvJ
	vVm2MO6yMFLBDTerk9epfw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed2g9rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jul 2026 08:33:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66G8SdmP035898;
	Thu, 16 Jul 2026 08:33:41 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9kkwe6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 16 Jul 2026 08:33:41 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iP+EzpgCE5nCJhDARmnL8ueDKRJ12POw7ZL5Fw7IJLyXO465dSnelkrGENgU+UV39/v3f431A2nt6l8BGQzY8MXb4+ZinTBQnoJFJEhicViV9wwUcjJCpEEJmw/BmxYwbtGmUIYl21/pL+U3yop2LQLjRxYdO95PQcRu/CZlkmgLbPIFMEn3xgNjFu4sXhVzjlL+X12dFP5S7AlPdL+SGk1V+nWV6C1ju3r/g6g/7Y5MW6ip8Dnj/xHCpECeGVmYDOlItFQNEgKIRj+e0ptcMCtTHmGtc8NqlY304i4pSQgQ9k5WrYKNQW2AhsJ1wqA4jfVA/r25BPZMglxki4hmrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xt95j7tKdDR/Za+r436LG869Ee4A4oPaMQXv5W845tE=;
 b=Db8AbXYG1HG88Z5V0BDMky71a8wzcDwvjk/IyaccfhHG0yqtHUMEGuq24zIZr/aV7Q23BqK3wsB7Y3BiK2FEYoz84qGUUbmBZLzF7mPt104NsP3dtXsl49eEdfivPptU8P50yvPp8s3wwdOTrKKuyCQkEziaPq3kje6SguS9AyZaLTrqeB8Mn4lzQGReuhTi4cPLaJeRO/KJJwAWBGEyXOjMc3NIecV02MrdzyV88EEeGMsVF5xEyrsw2F2tEmafHA3UQFU8pGsk1vagebvUbeJ5tjfO4WeoQ3RaIoaJBCHYkw9C5aongpj+w1VGNKTehqh4G7wdOAzNgPl4UAMk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xt95j7tKdDR/Za+r436LG869Ee4A4oPaMQXv5W845tE=;
 b=smUairAakxisC37MoS53L6cAm2WN7NJf02VhBlkurwcKt+jnPWzb+CCsAsM+Oz09x+RFWgdl2824uIIPuYQOme/ZjLLOuFn9xFy7YU7rR4sOsy5V0NjgbuEaxEyi1jzMAGaWiVCfwvhJ6rarync9/JwUa0ASQU9e8r+nIVjCROI=
Received: from BL0PR10MB2820.namprd10.prod.outlook.com (2603:10b6:208:75::10)
 by DS7PR10MB5040.namprd10.prod.outlook.com (2603:10b6:5:3b0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Thu, 16 Jul
 2026 08:33:38 +0000
Received: from BL0PR10MB2820.namprd10.prod.outlook.com
 ([fe80::e0d8:3402:3fa7:260]) by BL0PR10MB2820.namprd10.prod.outlook.com
 ([fe80::e0d8:3402:3fa7:260%5]) with mapi id 15.21.0223.008; Thu, 16 Jul 2026
 08:33:38 +0000
From: Praveen Kannoju <praveen.kannoju@oracle.com>
To: Leon Romanovsky <leon@kernel.org>,
        "yishaih@nvidia.com"
	<yishaih@nvidia.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Anand Khoje <anand.a.khoje@oracle.com>,
        Manjunath Patil
	<manjunath.b.patil@oracle.com>
Subject: RE: [PATCH v4] IB/mlx4: Fix stale CM id_map entries when RTU is never
 received
Thread-Topic: [PATCH v4] IB/mlx4: Fix stale CM id_map entries when RTU is
 never received
Thread-Index: AQHdFDEJVeD1iFyl3kiLxx0HM8mLfLZv0i+AgAAA6cA=
Date: Thu, 16 Jul 2026 08:33:38 +0000
Message-ID:
 <BL0PR10MB282081675D85A0852A82FF198CC72@BL0PR10MB2820.namprd10.prod.outlook.com>
References: <20260715080738.1357072-1-praveen.kannoju@oracle.com>
 <178419059769.297515.12559710952711271768.b4-ty@kernel.org>
In-Reply-To: <178419059769.297515.12559710952711271768.b4-ty@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_Enabled=True;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_SiteId=4e2c6054-71cb-48f1-bd6c-3a9705aca71b;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_SetDate=2026-07-16T08:33:12.0000000Z;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_Name=Restricted-Including
 External
 Recipients;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_ContentBits=3;MSIP_Label_94b7886c-3e74-443c-a58e-890de065ec46_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR10MB2820:EE_|DS7PR10MB5040:EE_
x-ms-office365-filtering-correlation-id: c23772e6-83fb-406d-1e01-08dee314ef0c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|18002099003|22082099003|38070700021|6133799003|56012099006|4143699003|5023799004|10067099003;
x-microsoft-antispam-message-info:
 BzM5p2ZGvRoAUEWXuH68CMgCFKLYW7G5wbD5kQmcdyc/pvhReFQLoL9L4wJ7GW+2RmgK3+sXAwIky7cuB2Rs3k9/YD4a7JV91teGsKIan4t2qsxQy5Hf5L4tL+83v0mNmGnMWB8N7FjPyNSmQe+jwOY8BG+WUudOj35Mgb01jvgXSQIUTvaaVmkensbxqBJplKOLBhOMDL2cQKUB1CVxEv8EVcFljIR10wF7FDGVNYyLb3GxspDTnIzUp3EDr+tgROqYU3j2GxBRkrqE0fdyIr3jaP/1j3UIzmxOS798fZ7C9m38+dBJBgJgzy6aCqd1ZXoFPnbDkGR2yDG6wLJNwCQMzn0PfLZ4q+Xrt8NM6/H161SAkl+0N8smh4Mm0v6mIzki5Yqk20NMF/emAsnl+qcfEaYdLDhBwP1o2B8JoPX633Qk9ZzZWg1eRzSv+HE//aAEg42EJyovxo0I521MlCpTzJLyoksCrSuUk5uw/BkPHikJ/QV0StET+TisRK3SPRZ+DpijJruKbuKQ0idk+sLYWBQubmVm5jI1kBDHe6CQ012+ARgGRX2ygE8Cm3tggbWRz3FO2/+UdOjnaqWiwmoPVWC+h7boxkHgHFKzlFl/AJ6c1npV+LDKl9xkp8rL1cfGqTAEHe5qniPqxNK88TyI4CcQi6ROb92SWlwU4ckO83EWo5nlBwEh0NESCmk+EB2ZftliV3KiSUEYPzYZZrU8i/xCyOAY0WvTlUl5Oas=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2820.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(18002099003)(22082099003)(38070700021)(6133799003)(56012099006)(4143699003)(5023799004)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-7?B?NE1JN3FPRndUbXhsb25hMThhUXZoZDJ6L0x5WTQ3TU5pSUVhVnVDWXhBSUJG?=
 =?utf-7?B?RjhOVWxmYTB6clpsNVhvdUN0MDl0RFF6Z0tzNmN2VHFqNjdCaHpsUVdSbHdw?=
 =?utf-7?B?RkRMU2ZvR2FESkV4OHM4Nm01MWUzWXRGeHF0YUpDeVZoc1dOTDNKSTFtYXpX?=
 =?utf-7?B?R1J0RXFWbVJ5ejhWbHR3SUsxRU1NS0JUdDJGYzNPTzl4MHdqVTZMNHljejRQ?=
 =?utf-7?B?ZS9SaC9CVWxyQmNWL09JbHliUjEwZmhlUmlWNk9TeWJlaHlNektWWlJxakpm?=
 =?utf-7?B?aS95cVZoZ0g2eW5XZTk1aCstM0hoeW5PN1ZBclBqaERJSVlQZVlFMGxEaEZy?=
 =?utf-7?B?c0hGRVA5UnZpeldiTmdJRVJDeURYY1NTS3ZsbmZ3b2E0a2RyeDRaOTNwOFNr?=
 =?utf-7?B?NTZ1VjlHT3BBNHdoNnJaQ2RWd3Z0M0ZSdS82TC9XSUNLQ3o2Z0dpTXJRd1Qx?=
 =?utf-7?B?QWZjQUMzek9XYkFyL3pkbnNkR2dGVGdpRDM0MFF2QXNxemNiUHIyQlZ4cnBr?=
 =?utf-7?B?WktKejJ3YXM5T21PV1N5VnVEN01xTWVXLzFZSVo0Tk5Fek9sTjhzaHlhb1lk?=
 =?utf-7?B?VEMxODJZZXIvbVphamo5Z080REtDb0VVbWkrLVhocURoSjRUSzhKRWVINGhU?=
 =?utf-7?B?MHhNR1NsNmdKbVJWV2NucTYzODV4bDlvQ1J0WWptMjlXS0RkSGlOQ09mdHpN?=
 =?utf-7?B?NDZQV2FQcGJkSXVudmM3cistRnlhcFhpZnZFNkp5THVHc2Yya2Y2RXp6WWVO?=
 =?utf-7?B?Smg3eGppNDZpUFBKZHNRNWF6OWM2MjQ2UTcyWGtXTzNpV1d5SEl5VVNQL1F4?=
 =?utf-7?B?a1lQZlBXTkw2UDhtNmhZei90YTdPcDQ3NW9lMjBubzQxZHVqdmhaN0JjKy1T?=
 =?utf-7?B?eGx1RmZuR0lVbnl0cC9lUUQrLUlXM3lPOHpKT3dVNFUxTzd1M1U3RlpVNVdB?=
 =?utf-7?B?UkVXVHFDNkpZTGlBQy9nTVNscEkxSTNBRzhMNEV5UDVIblgzYzlmcUhYdUx3?=
 =?utf-7?B?TzlTWEFLTk8waWhUUFBIMEpaQWlYRElRNFNGV0Y2MWtKWjZnMTREbUhwbGRl?=
 =?utf-7?B?d2xXWWRWaU5vVWhZbDNtcHRWYkRoRzZVRW1Sam01RHZFQVdYaVkyL1F5OEw4?=
 =?utf-7?B?bkVob0o1djladDZCZFBrQ3NkQ1Q2c24weENPRThFKy1PUE9ka2tZVjc4d1BM?=
 =?utf-7?B?NC9OcTQwcWZpTmhMUTNIcFBIazQ0QWIzemRjcWxaVE8xbloxQTdiNjhSN2x1?=
 =?utf-7?B?TmY0T3kyczI4TnpSeTVCWG5XNGEwTkJoNlA5ZlJsRjFWRnQvakJBUWQ3YVVE?=
 =?utf-7?B?VXdxN1ZQY2xVZlpIYmRpYUMxYXpOSDl4RW10dVpyd1hDVFZPQlc5Sm5laHMx?=
 =?utf-7?B?UHpJWnRPVllDVFB6VCstcWUxQkg3OEZzVkF1bXZYeFk5RE1yYVlwVHFWM0dz?=
 =?utf-7?B?dWRHQ0hzVlRrdXlRUG1tUktkUnd3NWhoeVpucmQvR0lEYUk0VVNIL2pISUxx?=
 =?utf-7?B?T3NvRG9WMUZHSnVRamdOYm4wV3hnalVuUElhSWxYWU5iY3A5dHZ4d0RUYWhB?=
 =?utf-7?B?Y2VLNzluamp0L3VVVUVOdzNOd01nKy1HYVE3NTFsSGFST25naFFsYVNZKy12?=
 =?utf-7?B?RUl1Z085dG5ZV1RTUmkrLUZ1Ky1LbHRuWE0rLVdKOU10YnFOTlRRdjd4RUdU?=
 =?utf-7?B?am9yeXlYMjZPTm1Da0Z5TG1ldjRLQWtCdistMGhLejVSODNBN0JLdnROaUZQ?=
 =?utf-7?B?c0U1S0lwTENMekhsM0ZFMmtZU2oxa01Cc3Z2R2FoNjF0NER5TlB3VFM5WW9G?=
 =?utf-7?B?NEtCaEswclVnVFFjc3R2Sm1zSE95VUhrSEliVHZDYlFYT21wT056bkxoVjNr?=
 =?utf-7?B?bCstYWVtN1ltSWxFZ1E1L2JKNXNoZnFBNkw4VGtpQ1R4S1JqUEZ0QjlBdkxo?=
 =?utf-7?B?STlVbGlKRUVCUG5TUldBQlhvbElEZjVOOVdGSGxIUG5ESGg0NHVpV09jY2Q2?=
 =?utf-7?B?Y2NnU0IxTTRwR2tOWkhGU2xLZFpNUHc1TnlralJzdllhQU05YVBHOThQSkxQ?=
 =?utf-7?B?MzJmT1J4M0xPRkxmZ01QaWpYMk4xeHU1bVNsamE0MXlIUGQrLVhpQzdHWDVB?=
 =?utf-7?B?bHU0RFo3UGxxUnpMRm44Z1JXcFp2bEQwOFNjQndqcFFXaVUzdnJIUGJ1L1Jm?=
 =?utf-7?B?TVFmU0plSVQ2Wk1KRW9oUVNFZVZOOWZES0JYTU0vSkxJeDhYa3htTkFWNTJB?=
 =?utf-7?B?SlNtcG1tdmpPc2ZHdER5VXFPYmhSd0ZmWWc5ejh0RUl6MUVpZURJeXRaVERG?=
 =?utf-7?B?Sm1tbDdEeWJuTmhEcistQWhwaVYyWnhlT0V0dWJldFpvSHcxY3hneHZsdzBQ?=
 =?utf-7?B?RklkZ0x3SWMwRVErQUQwQVBRLQ==?=
Content-Type: text/plain; charset="utf-7"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	A/zaAGhjcCxMhOA++s22NMLsxMnsjiQYVeqLEiA08jPI22af1FicFElcPLRcyw0Hcs0klaCH2Sv8otDWhO4krBG26VYfu26C3dFYQpYAsUh4hMOIjHqbiYCP8uM17tCSB4/OXTzWBpvKVKgk8OBsO4vdaAULSQLu7LsA44pSTd6L+sjseFZQj0UvtKKCl90/bb3pEzetuykvTZhAdk13qaNtyEMEj0OINqdU2CjBagiHZJJSekvY6y+DaGQSiVCMFjFfqfyJUT05KN346UxT2E+hoHg2d9Soro3JCWJkCqsTyrxkmEDCDFIRHEa7XM+KFyof+dQfcMCn+FVFj6ZBSw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6G4rZHunXsZoBiukvNpmgpbk918MeQbFl86fPnYgd/Tv/xTnqUAQobPFygT9f36NJ0D5pMujLUT4JubiCnPtaQe/mjUn6aPTG2pU7wIq+vit2kMzbMD6zaZETUFSSPIpJ7zwQduDfl/WLD6xhkM20u1sxGHUL9jZjBloLHOhtD1KHuMGyLlxAhT8jGm03FcLfm+fImPSWVPMe89qX4XxMAv0bVu2ACunV1NH2lFERC0+uKxN5wuXme6dbdWbwvr5uVNqsCFv9BmMNAZJnWL+y/YE4tSXCAXSIyQudefcJKJtRKdtuuCPztQ5It7uyV45hdTVW0W41qBO6UTJiXHk/0S6kM/HKZPACfgkHoxErlGgNNUagM3/7dJzvZ7+4fz1Lin4yh/yXJsDK4sozaoygY9iGIgMPo8Y3xA05EioByLsskhw6X1/c1okqWq2rHJncxKe/NqxQeQ9egn8Hc9+h4CqF0U1kBlKUZs2o5f/G7YtPH1RYOoDnfRZPepVBA+uK7okNttf98P/Lyvz3MJpTSxTYJ0h8Cqa4ARZONnioG7yRxFa5pYJJQPer8PH7yM16w938HC+Ocy6SEp35DLqiTearl+lI3lqWZPkP5jF7Fc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2820.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c23772e6-83fb-406d-1e01-08dee314ef0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2026 08:33:38.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 83xSVOcb9qQczKp+pFVdJamPdFMAMtcrYvx+drDkKPKdaJnySDwZKPageuQ9GYu8km20HeAD+A9Ra6EUjGCq+cgSihKa1hyAoNoPJ80qOxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5040
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_03,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607160086
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDA4NyBTYWx0ZWRfXyayIs0VQkf7G
 crvQI95d3TPRk6RaItEXbpGFaOwX6NkokxnxUTH8Q4V/Kfwh2gBGkki1chIogLCkqrvxuqu9f4k
 i4ZPTnFfC31rue889iVEZbjaGqJ7+anus4aMQw9N+gTkCIRSZiEZszYkebe8eNjkSgl8ebc1QYw
 7XPQ3LxD1yiSRdLkUNP7c3HRTR8LgIdLuYl2Kec1jSSj/sPkFJo4fRAHeJS8obURxkGczqeMISh
 BnR6X+Dhmm1KUm+EQaWI0NZYc82HyFxUxGQ6DsZKOC1qH4r1osPCAV070dCSdnjJQg7MDRapU+b
 Fd0QS+x/eruRE44f7rxybJtQ3LQ9gDCPZafr0EPxqV6zXllXLxvVZ2KDjKelf5FRFiyNVPxV3jj
 ZLgZG2c8IkScZHQWSEFrMiXjEI8wiZwA2IxXUCclzy1Lh5zNl+EWeNrBJcP+PU/ywdijupHODWI
 d5FH9iv0VSU2TeWnghcGDWCS5x1+Q7JzQiJ5WaY0=
X-Authority-Analysis: v=2.4 cv=GcknWwXL c=1 sm=1 tr=0 ts=6a589767 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wzW8d0FwaosA:10 a=YU3QZWNX-B8A:10 a=RAioF0-LDSMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=9jRdOu3wAAAA:8
 a=yPCof4ZbAAAA:8 a=c1PdSmG1AAAA:8 a=BXszkKfDAAAA:8 a=Fofg-9D3AAAA:8
 a=mQvHCebiAAAA:8 a=D4P_kDAA7m4TzQ0CLHsA:9 a=avxi3fN6y70A:10
 a=ZE6KLimJVUuLrTuGpvhn:22 a=4iM0TfZbaBQr0p37pvCp:22 a=duu7wrcty9prphiCz_fF:22
 a=Xbaoi9ZUBzzYp91LqZJF:22 a=wsrb8zZI_WQ3QAEBCXTy:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12218
X-Proofpoint-GUID: r8yTU2rSI7YK5MA32RSkecHCckuXJlmg
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDA4NyBTYWx0ZWRfX/+eg4K9n7s+p
 oJJ3Gehi3eLA0zAiipEh9s+SWCEbFYQtapNw9zliy1liuEm5vOs0ejyJ3HEgug8A/ccIqlk6K0i
 m2JnAkeXdhDRfAoPcDrr8C8QILP5QFuSjBbcS7ok1ut2hln3UtO5
X-Proofpoint-ORIG-GUID: r8yTU2rSI7YK5MA32RSkecHCckuXJlmg

Oracle Confidential

Thank you very much, Leon.

-
Praveen.


Oracle Confidential
+AD4- -----Original Message-----
+AD4- From: Leon Romanovsky +ADw-leon+AEA-kernel.org+AD4-
+AD4- Sent: Thursday, July 16, 2026 2:00 PM
+AD4- To: yishaih+AEA-nvidia.com+ADs- jgg+AEA-ziepe.ca+ADs- linux-rdma+AEA-=
vger.kernel.org+ADs- linux-
+AD4- kernel+AEA-vger.kernel.org+ADs- Praveen Kannoju +ADw-praveen.kannoju+=
AEA-oracle.com+AD4-
+AD4- Subject: Re: +AFs-PATCH v4+AF0- IB/mlx4: Fix stale CM id+AF8-map entr=
ies when RTU is
+AD4- never received
+AD4-
+AD4-
+AD4- On Wed, 15 Jul 2026 08:07:38 +-0000, Praveen Kumar Kannoju wrote:
+AD4- +AD4- mlx4+AF8-ib+AF8-multiplex+AF8-cm+AF8-handler() allocates an id+=
AF8-map+AF8-entry for CM
+AD4- +AD4- transactions, but the entry is normally released only on DREQ o=
r REJ
+AD4- +AD4- flows.
+AD4- +AD4-
+AD4- +AD4- In the duplicate REP handling scenario, cm+AF8-dup+AF8-rep+AF8-=
handler() may be
+AD4- +AD4- invoked when the remote side receives a REP for which no matchi=
ng
+AD4- +AD4- cm+AF8-id+AF8-priv exists. In such cases the CM handshake never=
 reaches RTU,
+AD4- +AD4- and the sender side may never receive either DREQ or REJ cleanu=
p events.
+AD4- +AD4-
+AD4- +AD4- +AFs-...+AF0-
+AD4-
+AD4- Applied, thanks+ACE-
+AD4-
+AD4- +AFs-1/1+AF0- IB/mlx4: Fix stale CM id+AF8-map entries when RTU is ne=
ver received
+AD4-       https://git.kernel.org/rdma/rdma/c/548897f0f78837
+AD4-
+AD4- Best regards,
+AD4- --
+AD4- Leon Romanovsky +ADw-leon+AEA-kernel.org+AD4-

