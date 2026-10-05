Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7308C4DA540;
	Mon,  5 Oct 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791220999; cv=fail; b=Tp+RPbok4zLcs3Jxo66gSXUGQ9/OV6bSjJ27y/AsLwaf5ritMtKQUcJFlKUHWPjbbgoUSUohrtICEVIKSWWmamSaY9D+4vDWD0yoalCMkXH1/pidEO/xajbEV9aP8erDLUppGEMC1XAyLsMwG+XhcEfTxmGdL4XfuJ4/Q2Yh57Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791220999; c=relaxed/simple;
	bh=0/HckRWW0nXj2z1f/8BL3HnuTtqrRoQpa4YtNKisN1s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GJDtvzML4ZTL2S8zbCxthT7PgcsQcEsLB3tLB+iMXOhXw6aoEGnSMpCPogeDFMFJ7FTWoeD2tLCmUCl4xTAUBdOj+JK+ggqNgNbNqghMQ5LvSO9uaaEXgUei1XQhJqMmHd/tCIgZrK6HJd4fuoHhqmMZU5FWVthwPZbk+schWOw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZHviFhLe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kdx19DRU; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZHviFhLe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kdx19DRU"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 695DUh4V1856127;
	Mon, 5 Oct 2026 17:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=xoNHkfqV9RY6W8BvNpPRj44ReapFFPSzOIrmSzb9Qcg=; b=
	ZHviFhLeBVrC7dWHvFAYidt3UXgRvowSKnV4h0cfX57etKqjgVCk10oTZYJZOoNi
	GZ9iBT9N+M8VCwF4JPb+2/gOXIusTFmsKgGuTge75IXecaXx+g/FY3+FXxkeqssv
	ljU7ZPlmlW5stge2kVo54JLnMAXeF+8II7sp99hLLnEpv35B7vGaZsKfRZcDKOiF
	hbZZgbbMn/bupLEB1MAWC9Q5KqAvT1WDtrhbdark7qy6Z3y9GrLNG+9YQtav51yU
	TQQc9Q37qtQi0uVDztSfIzGeskmDYjURC8MHOBPwGG+S2gb6zZmxZH+Gbhnf6iXJ
	W9zBFbPSPyHhHo/64RcmkA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2sas2frf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Oct 2026 17:23:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 695HM3Yd008709;
	Mon, 5 Oct 2026 17:23:10 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d1pqbwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 05 Oct 2026 17:23:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PgW8pcic5EtS9uv4zYNTm8Umt/x0DIujK3XqaZPUChF6dcj5SXKQlvy0TYGnp1/N1f0/jTlR+QMLH9MwYaEj2V0roL8kA1dzrWq/t86x1YEKSwJmf/IzqDHKG7p3SVTNJgIcJJopvz99twO7K14MUEhEpzJWylKwItU4HDMBKvFCEcUcRH7szo9P+bidxJSHOZJpvdo0lwZ3Oc3kkCKqnuKzzX7IxXpYaQDkujDuQ3oAhasAe8nEeBSRdV0U7aaPLj8i2YEyLoALAS4aYX2kHfOtAzJsy9Czc2yaH6od2iLXe05dd4a0ZyZjuWAKxYaIK7RzOtouxJeKc56nAiu/yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xoNHkfqV9RY6W8BvNpPRj44ReapFFPSzOIrmSzb9Qcg=;
 b=U2wrChbs7g7MO0uLODZHjGRQutm+oJB2WdBQYQ0IZJuk/o9DGdoV8D7m/4BvtvOUc3X7gwFey2wDB22ARpxV6Nae0h/BNFtRfkc/yQ3mpSklqk8scoKHhJ+Q/iA3WgDWTWX6RhenZt08UbZAFpXnMz2K3IRm+MAfME8MAHrac3qdxwE6wR0iQT8O7hFOGVyOqelveMGSMQ/9eHb66FytZQj29oFJ9ZUEVNeMBPXb1CVSwRfv5PXZcxQ0g/9IGwUPpQgdV5P+mcGXyWxQr5WLucuR+vwOQnmc6wz6srI/jPDV1LEGMiSiDq2v2lqfWsbI4HePM62FmsOSccOrRWkdhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xoNHkfqV9RY6W8BvNpPRj44ReapFFPSzOIrmSzb9Qcg=;
 b=kdx19DRUeBPTkmOTaFMTT6/vryz6jtrHnBshSLpK/Zj2G5y4hd6ZokSJRFt7CBSei+Yh6iqO8Nm/u/olGb/YSbAoPIMN8PFJ1f/PU6xjHHSJWXl0GZDqr0r34aNXVZzi3LCplChczOAs0pDxWs/qSp1B143MX9UGWNrvWJypg6M=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from LV3PR10MB7796.namprd10.prod.outlook.com (2603:10b6:408:1ae::6)
 by SA2PR10MB4618.namprd10.prod.outlook.com (2603:10b6:806:11f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.12; Mon, 5 Oct
 2026 17:23:04 +0000
Received: from LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8]) by LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8%5]) with mapi id 15.21.0472.012; Mon, 5 Oct 2026
 17:23:03 +0000
Message-ID: <e5c3ab5d-f949-4df0-9aa5-757fb2806546@oracle.com>
Date: Mon, 5 Oct 2026 10:23:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
To: netdev-bot+sashiko@kernel.org
Cc: saeedm@nvidia.com, leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org, kuba@kernel.org
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
 <179106228380.434549.9362571159733636097@kernel.org>
Content-Language: en-US
From: manjunath.b.patil@oracle.com
In-Reply-To: <179106228380.434549.9362571159733636097@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:610:1f4::10) To LV3PR10MB7796.namprd10.prod.outlook.com
 (2603:10b6:408:1ae::6)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR10MB7796:EE_|SA2PR10MB4618:EE_
X-MS-Office365-Filtering-Correlation-Id: cc2c5683-dcf2-48d6-32a5-08df23055025
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|56012099006|5023799004|4143699003|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8PSy1IpIscr7FhXZTQjafU7HoA5G/c2CbEwYm/uoYtB+cYcIOL+6807ie1+sLbAd5yHNTcXbLlP6IJWJyBGYtSUIbYsnLqNMlJzw4gxPLXDcvRFGRWfP+1ehj2apnxELNl5cOTwzCnfXVhADUffb8IZ7ye1I2XhogaR7B3Jb0oGa6PsBADqkV8wG9dGDmkPifhsulBC5GsOaye/u+J09yJr1yY5ZtOgynxNNQqYPo3K4K+gT9p69k/3yj0E+pd02aZtTqJqJ9CYnHYkqgmHpNO0psmdIWaN1kUkiWrs897t/RQrmgVJWMKnrI9J9K3pIYT3rraOe0MrWZzzenHmwDcJ60vvhSduBPj7CuXKiar8nR3sQEp+ZhgLg1hSJOiL93L9AOyr28RBjgzrD3qPWVrbsLxafh+9JKmTp9sEJSjrSzq1oYm8oyooKuqP5TDYkH2AQfiWqoGnKo6jz15MCDpJvIKMw0wsuOyAToU7/+7Vc+nUtssJg9ahbIduYv2Iqp4BO15n09tityyxM+kLmkVvo+9+c/ZvKgDZ0ciBJU7dMPK3yNAkjSMCaT9modUvDqLn3arXVtWA43hTiyHIP6FF5I985Ex2t88wFKqIdQWRTdxZBFlVYL4w7GWYLiZ8pNerJL/8yqmt712zRCnMrZPW8ZsCGfRpwP1/Gyst5FNk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR10MB7796.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(5023799004)(4143699003)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VHZzSUkyY0NQY0RWK014QzhVVXNaaU93UUtKSTc4dkptRVdRVkhMNGYyaUVV?=
 =?utf-8?B?NU0ybnhyd3g5YzIxYVBPaGtXR04vYUdlYVFHQTJhdnY5dHZzQm85YUc1Ni95?=
 =?utf-8?B?RHduVWIyb3d0ZHcvVW0yVXhZbVdSMTkxK1l6T3MrYVduR2IxRU1ETE4zZHNQ?=
 =?utf-8?B?NzFZTWpITWNOcWtvZ1R5VWkzTzRydVhCOVpRNVhKK2Z6Tkx5eXZWeVo0R2Zq?=
 =?utf-8?B?L0pTb0N6YmpwaEZLVHFYTUxTbnBjcS95aVp0cDVoUUI1WmY4VmNDc1FqL09I?=
 =?utf-8?B?bzZlMEJVTkRqVG5mVWVsa1c2aW53RU9nWlBhYXlibmdqQkVqRUpMNnZ1U2Zq?=
 =?utf-8?B?L1hNeTkrVWZEdERETGpqWElXVm9IRkgvMWVDNWUwQjVZSmNwUFhGQit2ZXVp?=
 =?utf-8?B?Rm03ZzlyaSswL0gyQUdEcU1RV0s2Qm9ZcmNHcGZLL0VHUFNoY1Y1SGJDTTI1?=
 =?utf-8?B?ZDBnall4N1NqdEJyRUlhbmp1SGFsaTZDekpqVWdWeEN6MGdrVmZJekRnbk83?=
 =?utf-8?B?cXVMaEdpL3JZQmdvMFMvS2dSRno2bEpUVVpZK2d5eXp3RlRjRi9HZituS1dF?=
 =?utf-8?B?QksyYXZWOU52VVU5d3AySWFkWHNUTjRRUERkWkR4ajVUbUo2bTFmZklSWU8y?=
 =?utf-8?B?S3Y3bzlFYmdaL3lFN1JmMmRiVWFLWWpoZTBOcVJrUk55d2xzaC9nQ08xZEcy?=
 =?utf-8?B?eFVQc3E3b3FsMlkxclJPSG1iV1E3czdORGRDRi9SSUVGM2dNNTJJNjR3NEo4?=
 =?utf-8?B?QjF0Zm5MMTYySTE1S1ZJQmxlOEVsMXRLYUZoUTc4NGhRMUdrVXp5L211TWpz?=
 =?utf-8?B?VElsYWs0WkZCZmtLcnYwMDR6YkphOHZLenZ6Z25nenlaeGtPUlFEcVNKbXNn?=
 =?utf-8?B?WU91Qm1NczR4QlRURTVwRk50eGFyQmR6ejkwUHJWR0sycktTNzhSbWJDbFlK?=
 =?utf-8?B?UWI1clIwb1k5VkppY09UYWF1RU5EZG9LMGQxMzZyQ1hWWWpndUhJaUtMY3h2?=
 =?utf-8?B?VEdxTWRzOUx6OFdHbDFvcVBxNVFkTjdOVGtxaHJXUkxiM1FGdWRlNzBsblFG?=
 =?utf-8?B?NjNyS2xWTzM2ejBWTExQR2FGMm5iVzVLc1dGRk1xOXZITE5teWN1STBXTHl0?=
 =?utf-8?B?K0syV01mZk5YMEN0aE11ZHpsK291Mk8vaE8zbEZMZEJpSFlhVWo5VDZqYUFO?=
 =?utf-8?B?WldPSWVZWWN0NUE0aG92Ump3bTQ5RXRiRnVIZUFPVHlyc1c3aDU2OHVsL1RD?=
 =?utf-8?B?K21VRy9WRzBQTjhaN1IveTVZQmZTSGdQVXFUTUxvaDBSWHc5QWJ5MmxuenNr?=
 =?utf-8?B?alhYOWFLd2NmN21pK2ZQZVZoc3gybHVPVkwyY2RtVFdjd1BsUU5STU52UnN6?=
 =?utf-8?B?SWpveUtRSVhDaURyUVp1MDZ0UjltdE9DdVJNRFd5RWptcC9oZm1RVEFhZkhz?=
 =?utf-8?B?bktaRDE0V2s4LzgwZTJJNjcyZ3A2eUNhblpYaVJoNDNzdEx4NysrZ2dXeU85?=
 =?utf-8?B?VllRUEVDc0phamJpbWdxdnQ1ZWMxMHVPc1prWmxLei9FQjUwcFN0MHRwdEw2?=
 =?utf-8?B?ZGdhd3RFWVRYbXB5dFczMEFrWEFJd1FjQXAvMWwyWXhNUHhjYkZSZWE2bVRU?=
 =?utf-8?B?UTFLdXE1cm0vM240REFQZGlmelFMWDJsRDBMcU15Z2pZdnE3bDMxanZZVXBo?=
 =?utf-8?B?dHduWllBYnAySG5BWXcrc04xaEd5QjA1U2RDUUFibllkUWE3QzR3Q01UTUxh?=
 =?utf-8?B?QVVqam93UUFQbGV5MGt5U29uRHU0cTl6Q0xlUGhlUjlHUmlEbzZzbXhWOUFN?=
 =?utf-8?B?MTRBQXErK1NrUTEwL0ZTOHZiMm5uWVp4WmRwQWMydkljNXp4UjF1dDlYUjZZ?=
 =?utf-8?B?VVdMWk5GWHhRN0xqYVduR0RGWVhxUzhrdzVSdHR4Sy9uU0NTa2FMb3ZqMytS?=
 =?utf-8?B?SlNFS25yRGlZdTFxN00wbWpWcUc0bnpKV2JZd3hpaHZlL3ZPZmZoT1R6bXNJ?=
 =?utf-8?B?ZGNoc0RuZkdtSFhCclZDRHprTDdLeTJsZ3d1TVAvN3ZSajl0d2FGYmxiV2di?=
 =?utf-8?B?NE9aTW9zOVpuRmJxSUR3Z1lpWjRjZXRqWGVQajRxOGpOcDh6SitqcENEejR3?=
 =?utf-8?B?aFB3UVhEY1l3ZmNIYW5NUlpLYmJjTWpXVDMxbnRwbTM3KytwMWhaSCtUbXR3?=
 =?utf-8?B?T1VvY3dZZUREbEljbUkwTkZpT1lVUEgzUXEzYkoxLzAwYmpKMkcxRnh1M0lX?=
 =?utf-8?B?aklGT0R3bEhxRGtqNlZveFpiV21qWkZoRzBGVFBLZkxUUFhUN3luZ2t3ZUVE?=
 =?utf-8?B?dEJwa0N0Z3JyT29vclJ0amxzTFhVcGl5L2xMK0tGSitoR1YyczIrRm9abUdr?=
 =?utf-8?Q?dxDZm8AtT2alYRZU=3D?=
X-Exchange-RoutingPolicyChecked:
	BgJLE2W/q3CXYumUeC+puxXkF4eoHxjbShhGQB2n+CEWQYwIxYGMBNMGJsViHcUmDmBIxxcyPAoa0Fn8C9H8NUgpl/zm/GIpXCARNvG7jsqO3D0Jt7tYYwqPA3XxLki15p07+VnELYpYDocxitFkMwOl+K6n0ilX2CHTnwGK6f7U9ATJ7IiIjeRuACq6ibVAlbv8KUDepN+IUrdeE2TpZojZPcX35RBKrcPi/NSlMVmYQIW2lerw8337gZ6fVRSa/wRsDCauV+aUrSDgzTqnuPx3sn+kjRH7YSqrtCoChbhset+l52eApXHQuL0gvNb/NsVUtAvdQOvN2TYmK68/KA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vrfqarkHBq9S0SL/oIP/SyDi8+cWKIC9FIBl5ezVVqbaugCPo1tV+zjQJ7Tl/1l4Nu8aMLzALLAAuqxHmoY2BguAGgmwxhHYxdTJWeWgnbMX8HThNHG3vzxhdAZ68U+pQdfb9nFOtaCg/6XRdsKzgzGoQdtWmHf0OqFOqkMhmi12l7F1dRDBYnPchaEWLA7/q6xEeOuhEOUyoQSMxyxjTP8QiWTTDVlXVZkFfB5X9txK3H7SFTpvrZkXmTb4s4kKiULO0AwlFUXO3k0KA70+Tt8zB0X1uIxbQVgX9lWplmRn+ZUVEAS2N7ndu5QPMzg8taajKM0n3R3Av940e+/54VdA54K4a8DskYeo3Z4y90aM/6NKzuVQxHhLIAt+o80aCbCdp3q6y3GQ8QSCMqIxtmz/QEMopPqnpJwTP0wqN69ch+8fRdjW2g2KDRc5fdv3PXiXl9WUvddfL3M5lgKqeezhmmf6d0Q0GexMmHvmsr+rjZaOfSq2Wpy/M4jfQW2hJe3FsvQI2F6F8hymakEGx6TbwdSMERYontdXDaZZeyjM956An6ftlUacsO2L3iOGpSPMw9fFNvJsVFOJH2i/qjE/teO928BygN0sZOCvv8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc2c5683-dcf2-48d6-32a5-08df23055025
X-MS-Exchange-CrossTenant-AuthSource: LV3PR10MB7796.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 17:23:03.8832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ivxO8xjVI8RNlGYfIPV8smy7Rmvkf2B94ewpJUM/H9EBBCQQUd78CHYXYZeZwyIpYlyMgVdWrX/kHKVfVnjKSEr09jHw6TE4Oxn32bpwTE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4618
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-05_05,2026-10-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2610050068
X-Proofpoint-ORIG-GUID: 0cbZfiof9C68_XaMS-tonOVrgmivoSSO
X-Authority-Analysis: v=2.4 cv=RIMmjIi+ c=1 sm=1 tr=0 ts=6ac3dcff b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=3I1J8UUJPc9JN9BFgKH3:22 a=VwQbUJbxAAAA:8
 a=XU_zA_dO_1fH9AboP1oA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-GUID: 0cbZfiof9C68_XaMS-tonOVrgmivoSSO
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA1MDA2OCBTYWx0ZWRfXyGSIuzUc4IYT
 HwucW62l8YDU05Xj+eGIRNwmzEz8UcG0e/EX9GSLtAoipnMYU5Z7IfDI/4Z8AqFMk+JOb36OtAP
 3dDlPD12/3sCqexK7CMOsSAD+XVJZbqZ4r+Dm/UQy+9lsfPeGOp/
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA1MDA2OCBTYWx0ZWRfX4ypLk58q0Pvi
 LO8kkQq5iFQ6iLJKqC6YpslLLjyWO7Lxp4HgA2cyq2oTTxj06RENioLlsoxkcW+7WN8U6YVSlmI
 f1dd2ZetE6GznGOoJotHsGttdhtBkXR8qncUa6KtaQXi5riiJYh5jHmulspKQjbdNRaA4MFbZyA
 zcaoTuGUtX/hYpTE74rWpuGqOznYQyHzrnqfgLHSN6oCq0/WjVC9G7StkLd0B9aLy0gUIY3iP0c
 AKPcxvsnb8zBdtyZOEkWY0oZdI/iQbh1vkej+vOSHvnPcmBHRK6/lwRgeD9b1CUvY4+SlwRnEti
 qCHxe42MtZZJoeW6V5NcwF3yBkxHwuUB3SGgiJ8mZOcV3dNzk/5QlXPWn8bp3r6ZdHtUECUI/hH
 tGAuK8lTvMNZagjA/Cffg8CyDqKA/ugplBUjknxe8rCZofTzSQr+BKmQtPrfr/gJDv0YaU+c5VC
 vSxbWG72WSAI9BcFJWw==


On 10/3/26 2:18 PM, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 2 · Medium: 1 · Low: 0
Hi,

Thank you for the review. We have examined the three reported issues and
will address the command-entry teardown ordering, the race between 
software EQ recovery and reset-triggered completion, and retained 
mailbox ownership during polling-mode teardown. We will validate those 
changes and return with a v2 patch.

Thanks,
Manjunath

pw-bot: cr
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] Retained mailboxes are freed after cmd_ent_put() has already
>    released the slot.
> - [High] A reset flush can now consume the retained FW reference while a
>    software EQ-recovery pass is processing the late real completion for…
> - [Medium] Mailboxes now owned by the entry are never released on normal
>    command-interface teardown, so dma_pool_destroy() finds the pool busy…
> 
> --
> 
> net/mlx5: retain command mailboxes after timeout
> 
> After a command timeout, this patch gives the command entry ownership of
> its input and output mailboxes, and cmd_free_ent() frees them on the final
> reference. A new helper, mlx5_cmd_claim_completion(), takes the
> PENDING_COMP claim and hands off the firmware reference under alloc_lock.
> Triggered (reset) completions now drop a reference that an earlier timeout
> kept.
> 
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> index 84583dc5eb1c0..22508b26972de 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> @@ -142,8 +142,19 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd_msg *in,
>>   	return ent;
>>   }
>>   
>> +static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg);
>> +static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
>> +			      struct mlx5_cmd_msg *msg);
>> +
>>   static void cmd_free_ent(struct mlx5_cmd_work_ent *ent)
>>   {
>> +	if (test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state)) {
>> +		struct mlx5_core_dev *dev = container_of(ent->cmd,
>> +							  struct mlx5_core_dev, cmd);
>> +
>> +		mlx5_free_cmd_msg(dev, ent->out);
>> +		free_msg(dev, ent->in);
>> +	}
>>   	kfree(ent);
>>   }
> 
> [Severity: High]
> Can these retained mailboxes be freed after the command DMA pool has
> already been destroyed?
> 
> cmd_ent_put() releases the slot and the semaphore under alloc_lock. It
> then drops the lock and only after that calls cmd_free_ent():
> 
> cmd_ent_put() {
>      ...
> 	if (ent->idx >= 0) {
> 		cmd_free_index(cmd, ent->idx);
> 		up(ent->page_queue ? &cmd->vars.pages_sem : &cmd->vars.sem);
> 	}
> 	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
> 
> 	cmd_free_ent(ent);
> }
> 
> With this patch, cmd_free_ent() calls dma_pool_free() on cmd->pool
> through mlx5_free_cmd_msg(). free_msg() can also list_add the input msg
> back onto msg->parent->head.
> 
> For an async command, cb_timeout_handler() runs on system_wq and holds its
> own reference. Its forced mlx5_cmd_comp_handler() call sets RETAIN_MSGS and
> TIMEDOUT and runs the user callback, so mlx5_async_ctx teardown stops
> waiting. Only after that does it call cmd_ent_put().
> 
> The firmware reference can be dropped first, either by a late real
> completion or by mlx5_cmd_trigger_completions(), which drops both the
> firmware reference and its own temporary one. In that case the put in
> cb_timeout_handler() is the final one.
> 
> Once that put calls up(), the down_trylock() loop in mlx5_cmd_flush() can
> succeed. Error recovery or unload can then continue into
> mlx5_cmd_disable():
> 
> 	flush_workqueue(cmd->wq);
> 	clean_debug_files(dev);
> 	destroy_msg_cache(dev);
> 	free_cmd_page(dev, cmd);
> 	dma_pool_destroy(cmd->pool);
> 
> This flushes only cmd->wq. It does not flush system_wq or the
> cb_timeout_work items.
> 
> Suppose the timeout worker is preempted after it drops alloc_lock and
> resumes after this point. Would cmd_free_ent() then call dma_pool_free() on
> a freed struct dma_pool, or add the input msg to a destroyed cache list?
> 
> Before this patch, this window only covered kfree(ent), which never
> touched the pool.
> 
> [ ... ]
> 
>> @@ -1732,6 +1744,66 @@ static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *msg)
>>   	}
>>   }
>>   
>> +/*
> 
> [ ... ]
> 
>> + * A blocking timeout retains the mailboxes even when a real completion has
>> + * claimed PENDING_COMP. That handler keeps its firmware-event reference until
>> + * it finishes using the mailboxes. Keeping the reference transitions under
>> + * alloc_lock prevents timeout, firmware, and reset from consuming the same
>> + * reference.
>> + */
>> +static bool mlx5_cmd_claim_completion(struct mlx5_core_dev *dev,
>> +				      struct mlx5_cmd_work_ent *ent, u64 vec,
>> +				      bool forced, bool *drop_fw_ref)
>> +{
> 
> [ ... ]
> 
>> +	} else if (!forced) {
>> +		clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
>> +		*drop_fw_ref = true;
>> +	} else if (vec & MLX5_TRIGGERED_CMD_COMP) {
>> +		/* Reset cannot receive a late firmware completion. */
>> +		*drop_fw_ref = test_and_clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
>> +						  &ent->state);
>> +	}
> 
> [Severity: High]
> Can a reset flush and a late real completion both drop the same retained
> firmware reference here?
> 
> Start with entry A, which has already timed out (PENDING_COMP clear,
> TIMEDOUT set). Only its firmware reference keeps it alive.
> 
> Thread R: another command's timeout calls mlx5_cmd_eq_recover(). That runs
> mlx5_eq_async_int(ASYNC_EQ_RECOVER) in process context. cmd_comp_notifier()
> passes its INTERNAL_ERROR check, and mlx5_cmd_comp_handler(dev, vec, false)
> reads ent = cmd->ent_arr[i] without taking a reference.
> 
> Thread F: enter_error_state() sets INTERNAL_ERROR and calls
> mlx5_cmd_flush()->mlx5_cmd_trigger_completions().
> mlx5_eq_synchronize_cmd_irq() does not wait for R, because R is not running
> in IRQ context.
> 
> The sequence would be:
> 
> F: cmd_ent_get(cmd->ent_arr[i])          /* temporary ref */
> F: mlx5_cmd_claim_completion()
>       vec & MLX5_TRIGGERED_CMD_COMP
>       test_and_clear_bit(TIMEDOUT) -> true
>     cmd_ent_put(ent)                      /* drops fw ref */
> R: mlx5_cmd_claim_completion()
>       !forced
>       *drop_fw_ref = true                 /* unconditional */
>     cmd_ent_put(ent)                      /* drops F's temp ref */
>       -> refcount 0, ent_arr[i] = NULL, cmd_free_ent()
> F: cmd_ent_put(cmd->ent_arr[i])          /* NULL or a new entry */
> 
> Would the trailing put in mlx5_cmd_trigger_completions() then dereference
> NULL? Or would it drop a reference on an unrelated entry that has reused
> slot i?
> 
> If F finishes completely first, R's claim would touch the freed entry
> instead.
> 
> The comment above says:
> 
>      Keeping the reference transitions under alloc_lock prevents timeout,
>      firmware, and reset from consuming the same reference.
> 
> The !forced branch does not check whether TIMEDOUT is still set, so does
> the helper actually enforce this?
> 
> In the baseline, the triggered path never dropped the reference of an
> entry with TIMEDOUT set, so this sequence stayed balanced.
> 
> [ ... ]
> 
>> @@ -2008,9 +2082,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
>>   	}
>>   
>>   	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
>> -			      pages_queue, token, force_polling);
>> +			      pages_queue, token, force_polling, &retain_msgs);
>>   	if (callback && !err)
>>   		return 0;
>> +	/* The entry releases retained DMA mailboxes with its final reference. */
>> +	if (retain_msgs)
>> +		goto out_up;
> 
> [Severity: Medium]
> What releases these retained mailboxes on a normal command interface
> teardown?
> 
> Take a command that times out while the interface is up and its opcode is
> allowed. mlx5_cmd_claim_completion() sets RETAIN_MSGS and TIMEDOUT and
> keeps the firmware reference. cmd_exec() now skips freeing inb and outb.
> 
> Only two things drop that reference: a later real completion, or a
> MLX5_TRIGGERED_CMD_COMP flush. The flush only runs from
> enter_error_state().
> 
> mlx5_function_disable() and the err_cmd_cleanup path in
> mlx5_function_enable() call mlx5_cmd_disable() without either:
> 
> err_cmd_cleanup:
> 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
> 	mlx5_cmd_disable(dev);
> 
> mlx5_cmd_disable() then runs destroy_msg_cache() and
> dma_pool_destroy(cmd->pool) while the retained blocks are still allocated.
> dma_pool_destroy() sees nr_active != 0, prints "dma_pool_destroy mlx5_cmd
> busy", and skips dma_free_coherent() for every page.
> 
> Does this leak all of the pool's coherent pages, including the ones backing
> the whole message cache?
> 
> A retained cached input msg is also not on ch->head, so destroy_msg_cache()
> never frees it.
> 
> Polling mode is active during mlx5_function_enable(), and it seems to reach
> this easily:
> 
> cmd_work_handler() {
>      ...
> 	if (cmd_mode == CMD_MODE_POLLING || poll_cmd) {
> 		poll_timeout(ent);
> 		/* make sure we read the descriptor after ownership is SW */
> 		rmb();
> 		mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, !!ent->ret);
> 	}
> }
> 
> There is no command EQ yet, so no late completion can arrive. If
> MANAGE_PAGES, SET_ISSI or QUERY_ISSI times out and mlx5_function_enable()
> then fails, the pool leaks.
> 
> Before this patch, cmd_exec() freed the mailboxes at timeout, so only the
> ent struct and its slot leaked.
> 
> A less certain follow-on: if a triggered flush drops the retained
> reference after mlx5_cmd_disable() has run, would cmd_free_ent() call
> dma_pool_free() on the destroyed pool? cmd->pool is not cleared.
> 
>>   
>>   	if (err > 0) /* Failed in FW, command didn't execute */
>>   		err = deliv_status_to_err(err);
> 

