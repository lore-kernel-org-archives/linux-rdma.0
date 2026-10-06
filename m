Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668814A3F1B;
	Tue,  6 Oct 2026 19:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791315766; cv=fail; b=qBqmlHmiZRrQ5HYFU/6Ut5NUhmAhiN2uQeRoxeZc5s//yzwlo71DfLcyWIMVK7ilDG41yb0QjOyKT5gcVzb35waHc71DpJnAp5T5auBh/Rji+j9+RNo/da44lbzqPgLnvHzA668P/fOSSlCsahMmHIjyUnKL1fF8RZjWAxDyke4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791315766; c=relaxed/simple;
	bh=lbXO7HfnpoZRGdfFEhOwg7XK6K+RBJMVGymUde6jChw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 MIME-Version:Content-Type; b=tOVJkFGlgmglU70nEmIKUf5NHaA6ID7k/pNnW9fsHielWJd+PSx30JwdYEWYSYst6lpzEBQIMdrOrhVrSApCLQvNXlkPLRUweARRBvxABg324da91xIe6sEFrhKSyXv5WxRvSdiMC0aox843vkKxZYyvLTTYF8Q07oxaZiMWBow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PN8JBmO8; dkim=fail (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WFhaJBx+ reason="signature verification failed"; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PN8JBmO8";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WFhaJBx+"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696FbsQK487281;
	Tue, 6 Oct 2026 19:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=+uMqX3b1CtC1GBmLMkF3WSbCeCAASOSQrPsZfB49jIc=; b=
	PN8JBmO86sc9YbpimlPqQkr1+9kZvkwVE8d31B28kYptr3fJn+LJQzr3LOHFw5xc
	FAFhOuHQM/YeAGxx7bq8u+gBPfkqAKhIDNRVXAeKdIb4jAvSctW1uJcdRBVVWK0p
	6POlfGMsLvFO43IGWK7Yhv5mpYKxKnmHlCbw3TOI1BSJaNsruvIm3v+rSSWQ6TAJ
	da5TOGgfWgj72uq2vjO+bs4qJB6qYGgI2Z8F8geqs1aDactJp6fbCtFKzzMBAKtF
	jcwut6LPuw2VL5f2Cxl2CbvNbVyAueFSrRzG24NY6iS8YUjf31SqRBh28wwV5HEI
	XroizJ7d1cXXMhbDnk3aDw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2sk7mf8r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Oct 2026 19:42:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 696JLHA4013528;
	Tue, 6 Oct 2026 19:42:39 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d003ap2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 06 Oct 2026 19:42:39 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yDLRdNUWKqMCXOFE0kOsxTrzxiQfHEL2J5fYNsvtxUJVv5nLBJxZ/WhwfAW3Lhus13Kq/hnrhiOIWyBbUALfgbnaYallVivBrJTEcJH08fdjEeKenr++2vHXyskmkJHCNVn3zhymBy0Bz+YOnDVxMyqBrzza9yCy05AKSOAcX9EQfn0+crG+mSaUUXc6pETJK57Df2gAQhKNzvIC8CPITH/x/JWPgRLa10h3Cziwvn0TiaKXsPwIJMIkVjWiOYzM/nDIglnLAglgbxhzGWVHEq4FYb4QD8PG0MsZo3nfE56RFQx9sZwsRVD9mflFE/0Qnp/pyfDxrVGKcLA9oGtLaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7gxbDVMj8Qsmy0dnihFRRloIU3giEPMjFfrRneqefsE=;
 b=QD3Zm42YwgxA/pN4aDHRyyneRF7ta3HlPy5Bv1ewfNehI1c7EDQ3sFeV9Ijqx+X8DiabUJJWzbV8vKCxPoejw7L9ygEmBtBH7klczWgahmsD+4/WYraz+qqR1stTQCRa+blN8szCAfWrE6M8Pb7bpFbu9bFiOlvJoGY1W1o7nihp/5HAgDiBw645gpnJdIllsVMLq8JV2820re+oT7rbN+TI3hCp7+grv5WoZ4h0jtlUgCNF6/qlJLOD55ykwGKGn93AH8JdGM5J1WRCMcJ7fR4TDrP31jzfyCzB1yGQ+k9QsUEeZ1nmuOshNj36tCsVJ4wIZpRbjTLUCEosY3BgCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gxbDVMj8Qsmy0dnihFRRloIU3giEPMjFfrRneqefsE=;
 b=WFhaJBx+7EUiwga4f9IEW27KfSnklZKYt2mcd3zHHjB/jtKnp85eYKzCqsyS4c41TYv1bg5Z5oy7JUB2zlDjU702RgJUduKO6/E2YzZ5wDOA93NZLHWIV5RfwUnL+ihdRpmKxPBX7PMSvAtECQO6Kl8g5hdRMyt6KeXzKyPQW2Q=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from LV3PR10MB7796.namprd10.prod.outlook.com (2603:10b6:408:1ae::6)
 by SN7PR10MB6405.namprd10.prod.outlook.com (2603:10b6:806:26b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Tue, 6 Oct
 2026 19:42:32 +0000
Received: from LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8]) by LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8%5]) with mapi id 15.21.0472.012; Tue, 6 Oct 2026
 19:42:32 +0000
Message-ID: <4a954b49-8883-4a3f-919c-8b72ed4f0eed@oracle.com>
Date: Tue, 6 Oct 2026 12:42:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/mlx5: retain command mailboxes after timeout
To: Moshe Shemesh <moshe@nvidia.com>, saeedm@nvidia.com
Cc: leonro@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20261002205649.2029588-1-manjunath.b.patil@oracle.com>
 <87d6f88d-e78a-4a32-a8ac-e9c68e3f2189@nvidia.com>
Content-Language: en-US
From: manjunath.b.patil@oracle.com
In-Reply-To: <87d6f88d-e78a-4a32-a8ac-e9c68e3f2189@nvidia.com>
X-ClientProxiedBy: BY5PR03CA0028.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::38) To LV3PR10MB7796.namprd10.prod.outlook.com
 (2603:10b6:408:1ae::6)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR10MB7796:EE_|SN7PR10MB6405:EE_
X-MS-Office365-Filtering-Correlation-Id: 2496040f-75ab-4b31-3f3f-08df23e1f659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|56012099006|5023799004|4143699003|4133799003|3023799007|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	5vURpcfC/S74FDOROS6uDfnfuH+dut6Ca89lA8VnnmGG/VqX11vF9zW/Z/IoCm1kULwDjA76lU4JHALEyhixgfLZr8JQsqjLbh+tsVgFqL3Ij6rXPca/Q/BZ0ifO1IK+ufhkpgY6e6A8YOYrWnxDgJz+o3BgtKHg8QXqhbUKBqy19qmro3DOBJ5h5DrehVLkn8zvjZf7K6RubPtx4g5Nccd4DqhegZ7QYeG+NYFzABS6+fc3bd13ghcRf8y/+d3TYaMi8JkWkT/EXooHCNTjkQpA330UtHZf9KH8I6NWCPLNsnyoBwn/i3Rz/lTw4NrQGI0RJxS2J7E7xkYgl+CqLHVOAfoNqeW76yz+/k1TON5AyA+Wim8YIDde2rnoJWU0SJvQ2zKnC+ZiwqDbZbcAM79QSHIhWL9euOYBFJmeGiq8d6y4SczlnNk5AfRsF8q+TgGlH0s7rg/Y+GHyIjWP9GfwzcDZh1F2GI62R60dTRmguNhtFe83ykz8kI/L8hv6RFHS/38UYUC6lTU/nYeg0w1XCUVm7DNdg67mSk6t87eeKJ7ELLzXkUk43yAhPTqqJ2ntr6nnHVm5QxcBVTYwfSUkrgmb1QdreDVGqGx0UFk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR10MB7796.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(56012099006)(5023799004)(4143699003)(4133799003)(3023799007)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVgycVlVYjhKZVlSSTJnMDR4cGlSS21jbEFFakhNSlBiYm9YTC9XUk53SWRj?=
 =?utf-8?B?WHNPLzQrY3psOE43bjRMOUMvMURSVTdUV3ZqQ2Z0VGNhOTh5RjhWWkFaeXdD?=
 =?utf-8?B?Ukl0ZHF4dVlnSDFpamxRcUtrZkhpZUFOdVZXMVJRZ1JrQUxjUDMyK24xVzhl?=
 =?utf-8?B?VGJQTDhiT0t0eDZ1MGRiSS9ZV3pRS0ZHNXV4QlZUK05ldHJYR3NPTC8zbU5M?=
 =?utf-8?B?eWdxU0JhQWpqNUVtTTdUUlBST2dnclJmMDcxdVcvNVp0dmcvcXlWQkxEUlZl?=
 =?utf-8?B?SE5ZQ3RON0Q3MWt3M2tobWdKNklvcm1hbVBocU11ZGZXR05VcjVLTmtDL1lz?=
 =?utf-8?B?NmNwZTE0WnBqYnRxcDNsdFcvZkRnd1ZuSCtDTnl0MzZ1M0FzWXNQUUJsRWRr?=
 =?utf-8?B?dEVTZ3RkNkZ5MWdtSjhubXAzQktINWM4dE12VVBKbHIwTGJtQXFWYk1HeTZv?=
 =?utf-8?B?M2VwWWliY0F4UVllUmJNNEw5aWFSVFI2NkRUSmhkTm5GU1VrTmxnbGVvL2xR?=
 =?utf-8?B?anIwREpZMzdhR1lndXp4NUJDSmxuNWhobVk2UWhHVmRReUxZREo2U0liUzk5?=
 =?utf-8?B?TWpCSm9STERwZS9VNU5Vb0ZvVXJIMzg2cUtuL2dVNC9wZ2FxYW5aYUFhV3VM?=
 =?utf-8?B?emFtSFdKcVNrUTRhUWFraFduOHFpR28wMmVkcnNmTy9LZG1Ga3R4dnBYS0Mw?=
 =?utf-8?B?YTBhUHE5Qk8xQ1QwbSthMFp6Mm1IQ3EvME53UGFRL0RMMDk1TUFKWm80Wmkx?=
 =?utf-8?B?SWlFVUR1dDJtaklmbktxc0x4a2taVjM0TzVLbGJNTnhoNk1JWkhxdFNER3BB?=
 =?utf-8?B?NE0zZXJldXZxRWsvSVhwdUpXek5mUGVDZjA3ZnJTQlF1S3I1aThqRjRGL1Bx?=
 =?utf-8?B?NXVDU1gvZHBRMXB3VE9EQ3BvVUE1SFMxL2l2aXdrUHZKWXVNNG1aNVV0dUZv?=
 =?utf-8?B?MzlrbFpJeHdsM3pnY0UzNk1Cdi82NEJ5OVl5enU3dmVXMG42TTVWTkRpTzVh?=
 =?utf-8?B?cUwxVk9Gc2ZQZlRHUjRwL3N5eTd2aEJLSjN3cUZJUjMvRyt4a1c4NW9CY0w4?=
 =?utf-8?B?bEV0TUYrbjh4ekFta0craTdkWU0rd1VCQW9rbUhNZjJrT0ZZZVdzMHY0RGpl?=
 =?utf-8?B?T3pYQzgzVmx4cU1QL285KzBEUDE1TDd6bFBvT2lxWDVKSE5nMUI5eDlrOEdP?=
 =?utf-8?B?T0d0SDhiTEx4a1JkRkxRZ1lSaGE5NVVvZHAxK2dnQ1BWOWpNZDN4TFJ3VTZX?=
 =?utf-8?B?dDA5S0ZPZTBZa3NHTll3WGU5RnBMRENqeUk3bU51Zm5kdnVLSEppaCtCUkZ2?=
 =?utf-8?B?dGtWejJVTTFXQkhqMGVSV3JrQlpIY0p1WTE3VGU3b3JVK2ZzSVRLY2orUTZF?=
 =?utf-8?B?ZjBvby96YjdXMlA2QVZ4VXkrenZaQXdVc1Z4UkU5Wi9va2xYSnRMQmxLOUh2?=
 =?utf-8?B?YktNZ0U0VjlYOVA0S2dBOHJ0ZkxMc21mRUI4OUZkTmJ1K1R1MWd4YmwxQkZF?=
 =?utf-8?B?LzhHQXpNdDY0aHRFQjBpM29mbGNHUURiOVU3Z1ZrNURXS3NxS0tnUEhHT1lF?=
 =?utf-8?B?RWhZMDluRU03SHBCdnBTeHNNLzYvUnRpTEZQeVEvNjFNdlRDSGlRUm8yd2Zw?=
 =?utf-8?B?NDM5a01ZN0E1VTk0SEYvdkZpcU5DODE3UjlqMUtyVGhpTDMzanFnK2U5STN5?=
 =?utf-8?B?ZmIzd2xNRUN0ekM5ZGxqWmo0WWFhbENVeE00THFDQmFvOU1ERnVpWHNlRDJs?=
 =?utf-8?B?S3MvTEgzUjZDWmE4SXNSRTZjY3BQNXBmakhYdlZiMEdWSHJLK1RFeVR1c1NW?=
 =?utf-8?B?YWtiMVMwQkVDellRdkxYeG1SMDVSMWFRMzBaajRXYXJLTHJHcDFQRCttcVhs?=
 =?utf-8?B?MklCS3V6NXdPRWJKUnErbVhFcUhXSTJpNWxqeVladURodFNlZzU3K1MrdjJF?=
 =?utf-8?B?YnNYNFZyc01CT0VkR3NPb29ib0hKRW96N2E4RG5HOUJHTk0vdjZUNGxSQldl?=
 =?utf-8?B?M3pNdExiVllvNmxhZnd6N28rSytibUltLzRPa0cxUDFiN2Z2ZTNQUmcyeU9T?=
 =?utf-8?B?RlhUeU84OThrUUdQNlhDNkZUdUJVdkdyY2tUTFpRUk5PZnZ3SXpHTWhmVVhC?=
 =?utf-8?B?WngyMWRQcDlsNFo0ZzRYbm1KcWppV1FWekZDbHBQZXlYWmFSNTdKS3c4T0tP?=
 =?utf-8?B?QTBEVTNNVzJWeWg0UDJHcHEzellmWWlkUS9wakszbnJwWDJwc1JGUmxIZExR?=
 =?utf-8?B?S2ROdWFqY0Q0aDBBRHh1dFVveEd3SjNYUU8xZkE3cE80V0cwcUE1MmYrT1Vx?=
 =?utf-8?B?ZzZKYVBPbUh3TUZJNXFhbGRsbHlBUDAvQWdqejMyblZKcVljZnliOWFGOEZl?=
 =?utf-8?Q?1SjafEapx/KAFne0=3D?=
X-Exchange-RoutingPolicyChecked:
	zLJ85MQlhFOhVHnIzB0F4NE/e1bXHdaeb+y0I/Y2RuX2xNWewuO9dBjiccn3L+f7us5O32olEug88ws/A8OfVaE3KddNUnqNAVyLPickTd7wM8maH97WNz8eIcEgvuLhvJfV6Qs5k3JwNGAVFs09Y8as9Hj1IqMI+otJeVhwCMFp+xdmcUnrL+aBA6paaBRYYiCoD6kV/KXDaeuFXfBPJtuDuuveVj+2ExePsnIf0RUBiz/YwThfP0psOrSsktYKgT1igR8GYpRc8+NXCE0Cy7ZqCkvt/QO4B35mOBX26w2j6Obz6V5hvrnhfFzPSdydXkReo/+LOWPfJUPDCpACJg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	aE/WRpGpqwf+wTNJtxpyrvzggsQ1h2Q9iXiwZH0OpTwunmw7IZa+UVROQt4lcjE3yFhy9NP5QIdBEKFM8WPjmw2+5npqZC8uL4YOSOU4OdhOMdIA+h6MnmqViivGDn7pQDegofM1dbu2pUqx6Yop1LFM1q+p5KxgB9itsvexbc7cEN9eO3YgT3k21jU8diXlM6k5Ms75TsE4S2o/aqYSt4gqrAo8HfaB1oHtntvbr3HAmc1egbZ/c/fY0qxUCb0twWT+0331dZn5CXwo2sa5oSmW+jBkGAE2cBRenKjpttNVOttLIRjXjZPZ6vyX7vCrio/3c4+sAcuHcQgg2ane6kTDPKt+CPzfZwc6o7ko+mTwMwApfxiqHrz49+fNKRvFTMZABss3RwEMVDghyuf/RY8JFiLd7px8eCss8x/vWX0Kr9FHuEB2xyO1dYOejhNxmKBu3GomTJb42nEOmJN6bVX7zohJdVuIejb/aP/lDCkot3AclwFvpMFRhRsliow1hGJsnj42y7Xe42YMlgqqI8/QYF6Z0V7v3iR7nFadWPiGOdTF4F+rB4TVfwpIN7+xsa5A1mx7XAMVbenkjRy7YhVwSdxxT4H1iKJFU6+5fh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2496040f-75ab-4b31-3f3f-08df23e1f659
X-MS-Exchange-CrossTenant-AuthSource: LV3PR10MB7796.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 19:42:31.9519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V4zYWkO2k3MzigwygNRo2o/0ovlHsJJWHEJQXQiInJQbEeCDq1vH8d1fSASCvuWNAwX98q6LEYLQyxCQeFwTkkt4b0HvJPqvwIslByitVqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6405
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610060077
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=Cpsq4X4D c=1 sm=1 tr=0 ts=6ac54f30 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=RpNjiQI2AAAA:8
 a=uherdBYGAAAA:8 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8 a=yPCof4ZbAAAA:8
 a=3hNQ85F7K5Yr40HkrYwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-ORIG-GUID: AcPtd-_kWZv7HrWlq8SUk-8PnSc_x-h3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA3OCBTYWx0ZWRfX8+gnjTHSwej+
 nspqubL62bJMm5MkWcn0OfYkR8rhcy359fgGCmiglhheWekpaNFYgn2G0QRg+pzGh2RZL80S8dX
 fqZXaPwyG4roxwbznhRdXuY6bV2phMc6P+u/BPzqdQP6+afNmQvd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA3OCBTYWx0ZWRfX5ndyv/Gbg80S
 JjTLKKUsb/GYfuSG0jCfI8fSK3tY9HL60BnxlZCUOy863uKPc879Dwx1/ba8AfbP+yg+zQPC4fo
 1NWmj840swVCy8/4EHk03wSE+ZcixOZcKVlBkoXeqOiN2Bm7gngbOHmBskzEIouImgXzRAmuhnW
 szUDyk/DinvTK/nUHR5n2Gk1EGklODIkJKVogHQpV4m+TskLT86kumsoEHsVwgfqlA5FJWZuRiQ
 0tXkc0cRWonB+5MesW+KwgvmXosMw6L6UXlzmvlZMQ0iRmReEYgVpc9Dxf7NfOeW/j2k9j69IGF
 M/UGRFVAGsr/iPeh2EwUfcm4P0sk0v3BurUaXmwDmmGWmDd3KO8Ue7xfSzpqeqHSly0ya4GJ7+8
 +SX48iBqhBoAMAenCi4s/eftFTJCqsuKBVqSKBS4zQFqy2S567GH/gP9/nQTsyQ8jqTvxDq4W48
 ZWhdmpy8sBRxZdqBtag==
X-Proofpoint-GUID: AcPtd-_kWZv7HrWlq8SUk-8PnSc_x-h3


On 10/6/26 6:01 AM, Moshe Shemesh wrote:
> On 10/2/2026 11:=E2=80=8A56 PM, Manjunath Patil wrote: > Firmware can acc=
ess=20
> command DMA mailboxes after the driver times out. > The command entry=20
> already keeps a reference for a possible firmware > completion, which=20
> keeps its slot allocated,
>=20
>=20
> On 10/2/2026 11:56 PM, Manjunath Patil wrote:
>> Firmware can access command DMA mailboxes after the driver times out.
>> The command entry already keeps a reference for a possible firmware
>> completion, which keeps its slot allocated, but the blocking caller
>> and async callback can still free their input and output mailboxes on
>> timeout. A late firmware access can therefore hit reallocated DMA
>> pool memory.
>>=20
>> Give the entry ownership of the mailboxes on timeout and free them when
>> its final reference is dropped. If timeout claims PENDING_COMP first,
>> retain the firmware-event reference while a real completion remains
>> possible; a late completion drops it.
>>=20
>> The real EQ handler may instead claim PENDING_COMP before the blocking
>> timeout handler runs and still be reading the mailboxes. Set
>> RETAIN_MSGS before forcing timeout completion in the blocking path.
>> The EQ handler holds its entry reference through its last mailbox
>> access and done notification, so the caller can return on timeout
>> without freeing memory beneath it.
>>=20
>> Serialize completion claims and firmware-reference handoffs under
>> alloc_lock. The existing reset/error flush marks synthetic
>> completions with MLX5_TRIGGERED_CMD_COMP and treats them as terminal
>> for firmware ownership; only such a triggered completion drops a
>> reference retained by an earlier timeout. Normal command EQ teardown
>> and its slot-drain policy are unchanged.
>>=20
>> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
>> Assisted-by: Codex:gpt-5
>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 127 ++++++++++++++----
>>   include/linux/mlx5/driver.h                   |   1 +
>>   2 files changed, 103 insertions(+), 25 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/cmd.c
>> index 84583dc5eb1c..22508b26972d 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
>> @@ -142,8 +142,19 @@ cmd_alloc_ent(struct mlx5_cmd *cmd, struct mlx5_cmd=
_msg *in,
>>   	return ent;
>>   }
>>  =20
>=20
> Hi Manjunath, thanks for your patch.
> Danielle Costantino has sent recently a patch for the same bug.
> See v2 on
> https://urldefense.com/v3/__https://lore.kernel.org/=20
> netdev/20260923190542.848049-1-dcostantino@meta.com/__;!!=20
> ACWV5N9M2RV99hQ!LQVo_l7643-=20
> HwAmD_d3InRHBlzl8puobw7CVp0ZFW54BELP7w6vbSl8fhcrFiNZFNC5pLUsSffv1l2oebXq9=
$ <https://urldefense.com/v3/__https://lore.kernel.org/netdev/2026092319054=
2.848049-1-dcostantino@meta.com/__;!!ACWV5N9M2RV99hQ!LQVo_l7643-HwAmD_d3InR=
HBlzl8puobw7CVp0ZFW54BELP7w6vbSl8fhcrFiNZFNC5pLUsSffv1l2oebXq9$>
> Please follow on that thread.

Thank you for pointing me to Danielle's v2. I'll hold off on sending a=20
v2 of my patch and follow Danielle's series through review.

-Manjunath>
> Thanks,
> Moshe.
>=20
>> +static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *ms=
g);
>> +static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
>> +			      struct mlx5_cmd_msg *msg);
>> +
>>   static void cmd_free_ent(struct mlx5_cmd_work_ent *ent)
>>   {
>> +	if (test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state)) {
>> +		struct mlx5_core_dev *dev =3D container_of(ent->cmd,
>> +							  struct mlx5_core_dev, cmd);
>> +
>> +		mlx5_free_cmd_msg(dev, ent->out);
>> +		free_msg(dev, ent->in);
>> +	}
>>   	kfree(ent);
>>   }
>>  =20
>> @@ -958,10 +969,6 @@ static void cb_timeout_handler(struct work_struct *=
work)
>>   	cmd_ent_put(ent); /* for the cmd_ent_get() took on schedule delayed w=
ork */
>>   }
>>  =20
>> -static void free_msg(struct mlx5_core_dev *dev, struct mlx5_cmd_msg *ms=
g);
>> -static void mlx5_free_cmd_msg(struct mlx5_core_dev *dev,
>> -			      struct mlx5_cmd_msg *msg);
>> -
>>   static bool opcode_allowed(struct mlx5_cmd *cmd, u16 opcode)
>>   {
>>   	if (cmd->allowed_opcode =3D=3D CMD_ALLOWED_OPCODE_ALL)
>> @@ -1163,6 +1170,10 @@ static void wait_func_handle_exec_timeout(struct =
mlx5_core_dev *dev,
>>   		       mlx5_command_str(ent->op), ent->op);
>>  =20
>>   	ent->ret =3D -ETIMEDOUT;
>> +	/* The real handler may have claimed the completion but still be using
>> +	 * the mailboxes. Keep them with the entry until its last reference.
>> +	 */
>> +	set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
>>   	mlx5_cmd_comp_handler(dev, 1ULL << ent->idx, true);
>>   }
>>  =20
>> @@ -1260,7 +1271,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *d=
ev, struct mlx5_cmd_msg *in,
>>   			   struct mlx5_cmd_msg *out, void *uout, int uout_size,
>>   			   mlx5_cmd_cbk_t callback,
>>   			   void *context, int page_queue,
>> -			   u8 token, bool force_polling)
>> +			   u8 token, bool force_polling, bool *retain_msgs)
>>   {
>>   	struct mlx5_cmd *cmd =3D &dev->cmd;
>>   	struct mlx5_cmd_work_ent *ent;
>> @@ -1313,6 +1324,7 @@ static int mlx5_cmd_invoke(struct mlx5_core_dev *d=
ev, struct mlx5_cmd_msg *in,
>>   		return 0; /* mlx5_cmd_comp_handler() will put(ent) */
>>  =20
>>   	err =3D wait_func(dev, ent);
>> +	*retain_msgs =3D test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
>>   	if (err =3D=3D -ETIMEDOUT || err =3D=3D -ECANCELED || err =3D=3D -EBU=
SY)
>>   		goto out_free;
>>  =20
>> @@ -1732,6 +1744,66 @@ static void free_msg(struct mlx5_core_dev *dev, s=
truct mlx5_cmd_msg *msg)
>>   	}
>>   }
>>  =20
>> +/*
>> + * cmd_work_handler() takes an entry reference for the firmware event a=
nd
>> + * sets PENDING_COMP before ringing the command doorbell. Firmware can =
still
>> + * use the input and output DMA mailboxes after the caller times out.
>> + *
>> + * Claim PENDING_COMP under alloc_lock so exactly one handler makes the
>> + * mailbox and firmware-reference decisions:
>> + *
>> + * - A timeout that wins retains the mailboxes in the entry. If the com=
mand
>> + *   interface is still up and the opcode is allowed, firmware can still
>> + *   generate a real completion, so TIMEDOUT retains the firmware-event=
 ref.
>> + * - A real completion that wins consumes its firmware-event ref normal=
ly.
>> + * - A real completion that loses is the late event after a timeout. It=
 drops
>> + *   the ref retained by TIMEDOUT; RETAIN_MSGS stays set until entry te=
ardown.
>> + * - A reset completion cannot be followed by a real firmware event. It=
 drops
>> + *   a ref only when TIMEDOUT says the timeout retained one.
>> + *
>> + * A blocking timeout retains the mailboxes even when a real completion=
 has
>> + * claimed PENDING_COMP. That handler keeps its firmware-event referenc=
e until
>> + * it finishes using the mailboxes. Keeping the reference transitions u=
nder
>> + * alloc_lock prevents timeout, firmware, and reset from consuming the =
same
>> + * reference.
>> + */
>> +static bool mlx5_cmd_claim_completion(struct mlx5_core_dev *dev,
>> +				      struct mlx5_cmd_work_ent *ent, u64 vec,
>> +				      bool forced, bool *drop_fw_ref)
>> +{
>> +	struct mlx5_cmd *cmd =3D &dev->cmd;
>> +	unsigned long flags;
>> +	bool timed_out =3D forced && ent->ret =3D=3D -ETIMEDOUT;
>> +	bool pending;
>> +
>> +	*drop_fw_ref =3D false;
>> +	spin_lock_irqsave(&cmd->alloc_lock, flags);
>> +	pending =3D test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP,
>> +				     &ent->state);
>> +	if (pending) {
>> +		if (timed_out)
>> +			set_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS, &ent->state);
>> +
>> +		if (timed_out && !mlx5_cmd_is_down(dev) &&
>> +		    opcode_allowed(cmd, ent->op)) {
>> +			set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
>> +		} else {
>> +			clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
>> +			*drop_fw_ref =3D true;
>> +		}
>> +	} else if (!forced) {
>> +		clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT, &ent->state);
>> +		*drop_fw_ref =3D true;
>> +	} else if (vec & MLX5_TRIGGERED_CMD_COMP) {
>> +		/* Reset cannot receive a late firmware completion. */
>> +		*drop_fw_ref =3D test_and_clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
>> +						  &ent->state);
>> +	}
>> +	spin_unlock_irqrestore(&cmd->alloc_lock, flags);
>> +
>> +	return pending;
>> +}
>> +
>>   static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, =
bool forced)
>>   {
>>   	struct mlx5_cmd *cmd =3D &dev->cmd;
>> @@ -1744,38 +1816,33 @@ static void mlx5_cmd_comp_handler(struct mlx5_co=
re_dev *dev, u64 vec, bool force
>>   	struct mlx5_cmd_stats *stats;
>>   	unsigned long flags;
>>   	unsigned long vector;
>> +	bool pending;
>> +	bool drop_fw_ref;
>>  =20
>>   	/* there can be at most 32 command queues */
>>   	vector =3D vec & 0xffffffff;
>>   	for (i =3D 0; i < (1 << cmd->vars.log_sz); i++) {
>>   		if (test_bit(i, &vector)) {
>>   			ent =3D cmd->ent_arr[i];
>> -
>> -			if (forced && ent->ret =3D=3D -ETIMEDOUT)
>> -				set_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
>> -					&ent->state);
>> -			else if (!forced) /* real FW completion */
>> -				clear_bit(MLX5_CMD_ENT_STATE_TIMEDOUT,
>> -					  &ent->state);
>> +			pending =3D mlx5_cmd_claim_completion(dev, ent, vec, forced,
>> +							    &drop_fw_ref);
>>  =20
>>   			/* if we already completed the command, ignore it */
>> -			if (!test_and_clear_bit(MLX5_CMD_ENT_STATE_PENDING_COMP,
>> -						&ent->state)) {
>> -				/* only real completion can free the cmd slot */
>> +			if (!pending) {
>>   				if (!forced) {
>> -					mlx5_core_err(dev, "Command completion arrived after timeout (entr=
y idx =3D %d).\n",
>> +					mlx5_core_err(dev,
>> +						      "Command completion arrived after timeout (entry idx =3D %d=
).\n",
>>   						      ent->idx);
>> -					cmd_ent_put(ent);
>>   				}
>> +				if (drop_fw_ref)
>> +					cmd_ent_put(ent);
>>   				continue;
>>   			}
>>  =20
>>   			if (ent->callback && cancel_delayed_work(&ent->cb_timeout_work))
>>   				cmd_ent_put(ent); /* timeout work was canceled */
>>  =20
>> -			if (!forced || /* Real FW completion */
>> -			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
>> -			     !opcode_allowed(cmd, ent->op))
>> +			if (drop_fw_ref && ent->callback)
>>   				cmd_ent_put(ent);
>>  =20
>>   			ent->ts2 =3D ktime_get_ns();
>> @@ -1816,17 +1883,23 @@ static void mlx5_cmd_comp_handler(struct mlx5_co=
re_dev *dev, u64 vec, bool force
>>   								 ent->out,
>>   								 ent->uout_size);
>>  =20
>> -				mlx5_free_cmd_msg(dev, ent->out);
>> -				free_msg(dev, ent->in);
>> +				if (!test_bit(MLX5_CMD_ENT_STATE_RETAIN_MSGS,
>> +					      &ent->state)) {
>> +					mlx5_free_cmd_msg(dev, ent->out);
>> +					free_msg(dev, ent->in);
>> +				}
>>  =20
>>   				/* final consumer is done, release ent */
>>   				cmd_ent_put(ent);
>>   				callback(err, context);
>>   			} else {
>> -				/* release wait_func() so mlx5_cmd_invoke()
>> -				 * can make the final ent_put()
>> +				/* No mailbox accesses after done. If the caller timed out,
>> +				 * the firmware reference keeps ent and its mailboxes alive
>> +				 * until this handler has finished.
>>   				 */
>>   				complete(&ent->done);
>> +				if (drop_fw_ref)
>> +					cmd_ent_put(ent);
>>   			}
>>   		}
>>   	}
>> @@ -1965,6 +2038,7 @@ static int cmd_exec(struct mlx5_core_dev *dev, voi=
d *in, int in_size, void *out,
>>   	gfp_t gfp;
>>   	u8 token;
>>   	int err;
>> +	bool retain_msgs =3D false;
>>  =20
>>   	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, opcode))
>>   		return -ENXIO;
>> @@ -2008,9 +2082,12 @@ static int cmd_exec(struct mlx5_core_dev *dev, vo=
id *in, int in_size, void *out,
>>   	}
>>  =20
>>   	err =3D mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, cont=
ext,
>> -			      pages_queue, token, force_polling);
>> +			      pages_queue, token, force_polling, &retain_msgs);
>>   	if (callback && !err)
>>   		return 0;
>> +	/* The entry releases retained DMA mailboxes with its final reference.=
 */
>> +	if (retain_msgs)
>> +		goto out_up;
>>  =20
>>   	if (err > 0) /* Failed in FW, command didn't execute */
>>   		err =3D deliv_status_to_err(err);
>> diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
>> index 83d0a83bbfbc..99cabe13e6c1 100644
>> --- a/include/linux/mlx5/driver.h
>> +++ b/include/linux/mlx5/driver.h
>> @@ -829,6 +829,7 @@ typedef void (*mlx5_cmd_cbk_t)(int status, void *con=
text);
>>   enum {
>>   	MLX5_CMD_ENT_STATE_PENDING_COMP,
>>   	MLX5_CMD_ENT_STATE_TIMEDOUT,
>> +	MLX5_CMD_ENT_STATE_RETAIN_MSGS,
>>   };
>>  =20
>>   struct mlx5_cmd_work_ent {
>=20

