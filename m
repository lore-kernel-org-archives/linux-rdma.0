Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E483238422E;
	Tue,  6 Oct 2026 20:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791316941; cv=fail; b=jTUY08mqAdxAqATB/tByaG2jLmM9y13qvggKUxTRAIXRz5YqE1WLFCJz3rWngu8ghes1FO9y9Mbny9Ar/QKJykH0rTVlMhxy7XgZubd98yEWpan9Yffm8t3YFZ3hk+PX2nGkYxEigIqsFbo7Xw49NcF4GMx/PDqS6j06h4T8lOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791316941; c=relaxed/simple;
	bh=Kl3MS13Y0yWaGDCxvjenf6H7TlWOqdGWPwtSuj6CGgk=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ALF0O5R9MNma42U7xQ3ASmOvSwlqYQiN8guFRg0DLU8WkvSe/DKQZtyipjQIo5S8k5Sf3kYMtTUW+/9NkshFh40VC5BJ70UWV5u1bcXUifw84mD5AAz04+KQh1FRck8NgsJkFbE2+e9DlUvavRn9XYpZNhesQsN7KufziJOyT9E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jHxQTaBD; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uXFZ2yZa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jHxQTaBD";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uXFZ2yZa"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 696Fbng1487204;
	Tue, 6 Oct 2026 20:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=m/NLH1TTqqX7gbMuQ/qcX6Z84JDNnIfX1h+xIFPeE7E=; b=
	jHxQTaBDTRthOXIsadff8jygxvTkAiVtI1uUMNvLgDAboeYIAnJacHQ0kUsMKv2h
	/92CVNmmdN3ubXs4y2AgB/elaRx0/Ydte2Rw6s4Cg5eJouEGudRRC3vYfehqQMK8
	yLqau4r7QR1p42DPMu4wkB49c9FSb12RDj4uNfnIeS3kzzossmXUExV6wBiT+IAm
	gZ2QbZeUfTI0bxeuJwy6lBqBotRucIzfpJqcrpTHjpq2VhD5zXrFNrzf25euHp2s
	CRKyljSai52xSZ0QiCZD7N3ypTDGM9IN75FLON2RAAT5XzsESzp9rr+0BYhCsM6Q
	HbSdx9WJVCNRqfG4xM36tg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4h2sk7mg1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Oct 2026 20:02:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 696JpLMn011354;
	Tue, 6 Oct 2026 20:02:01 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013059.outbound.protection.outlook.com [40.93.196.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h4d003uk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 06 Oct 2026 20:02:01 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I9G4kCIf09IsoeeoW/R9Iy1UXBeRtd/dBj752lmomzKDNbZ832r9jMQ30Yq/E6WiEdD/4rPfnpu7JS4Ru8dPfJsZgLnm5wAOjr8+cOKLN+oqms1oulFJXWs2v251SKhafe28cbrJXhSQAwMqHTHzbUFPnCt1Ud86XWefTaRecut8TbsT/qZ6+1ZpPTP1QdqK45at7FKKUZDKB7kuWEuKpQ3Gv4uNMC503tCbWeiIxYy3YmDP7KHmjPQOvElQmrdJlrJVeLKB7TF/PaQuAla25z3xdCYdmTReaOHcTD/kj4HQDxh8H8CRscupK04UoeMR9bN0+ceFKAIxLyDJjK6HJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m/NLH1TTqqX7gbMuQ/qcX6Z84JDNnIfX1h+xIFPeE7E=;
 b=xe3WeMz8zOpIOZkQsug4ZNvQbz2gPQbNsj/dZpBhdMzWLujyfDocNFZSJ9L6UELSVksE5RbzUbPUhpovtemfVQKZrDU7X0pp2/YnuA1MMwYA2eR3OP/Mi0x7zgOCQnYPNMBYtIvZYGAFjh7k7ZVonbbjZtFkyso2oFBKglVUjLCX1Upjg7UFcYwAaNUq3WXzR4VP8I+ApEYwPMklCEGlZ1SOxJzjdveYN62a1JBxdbvBD6vKRvz4OUayuo/REQCGxR5cGwcmB13otwlGGEZzb2WFAZd9xpj9jC7cSpCI81TEsAD0x5bHPBiq8CDJWxtkoMQmott5+o0mGc24bubNfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m/NLH1TTqqX7gbMuQ/qcX6Z84JDNnIfX1h+xIFPeE7E=;
 b=uXFZ2yZa6fnXagXi6ljtfveEvBitN+El4L258Yn5cG8yNFZ5qAzJH6zz4JMPBYv44ZYzT/Z97M4UzXi471Th9GVQLpBWe+yb1ghuCcjYEnsCHfsEg+BaMlVo2AsMaaHr4zpSbqSp6cyUF5PiaN+K7wKwjmyfrs0RvNjVBkILMFM=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from LV3PR10MB7796.namprd10.prod.outlook.com (2603:10b6:408:1ae::6)
 by SJ0PR10MB5744.namprd10.prod.outlook.com (2603:10b6:a03:3ef::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Tue, 6 Oct
 2026 20:01:55 +0000
Received: from LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8]) by LV3PR10MB7796.namprd10.prod.outlook.com
 ([fe80::a30e:ee88:c7b4:c0d8%5]) with mapi id 15.21.0472.012; Tue, 6 Oct 2026
 20:01:53 +0000
Message-ID: <665d6445-8efc-4874-8e86-e4f4085aa826@oracle.com>
Date: Tue, 6 Oct 2026 13:01:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] net/mlx5e: Report link down on administrative
 close
From: manjunath.b.patil@oracle.com
To: Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org
Cc: saeedm@nvidia.com, mbloch@nvidia.com, leon@kernel.org,
        andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260608234223.3731557-1-manjunath.b.patil@oracle.com>
 <9845fd42-e84f-43d7-98d3-9b2d0d1f23d9@nvidia.com>
 <3806aa95-fbf7-4713-8013-6dcf81d31535@oracle.com>
 <af46fce4-1d13-4d62-a627-acb837386634@oracle.com>
Content-Language: en-US
In-Reply-To: <af46fce4-1d13-4d62-a627-acb837386634@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0035.namprd18.prod.outlook.com
 (2603:10b6:610:55::15) To LV3PR10MB7796.namprd10.prod.outlook.com
 (2603:10b6:408:1ae::6)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR10MB7796:EE_|SJ0PR10MB5744:EE_
X-MS-Office365-Filtering-Correlation-Id: 835308cc-e247-4398-ef83-08df23e4aac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|56012099006|10067099003|4143699003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	u9fCaZCE7/5CmxuM3W4pueRM0zqv7lv4qMB6PGYBQpM8M95ThPBarD0tLLoIVa7x15Qy4WxBHs4VnpYpx/mnwxxAJgC0JqJyPsWAkj4snnk6tTU7fDfBrBrJC8pH3oQSmmR2Ip4i1Ty3bAUvuFs8hltqskZZ6G3ix8HPhcTx+D3PcyeDq3hrP7GbN3kDqjZH1q9/RM6MjiyrrE9g0v74eL1sEi8ZAdgqMb/LdblTr9pQkjVLFfe80J7QhQFyopWt3lwPD/fHNAKKDLWGCj9ExcNn+F6wu9xXAQpdcRdyl400qdLMiyLVeB+Nbjj37JK9XtUV90CVkfGc6+3uVildbECIMncK+obSUF624DkyBJX9ZLwcGxZPo51OaFQri4WTjJrq7bVKocl2c/bKqpJmPfl67JoxEKVywe7tMgElvKJXiM7ch9Vs7Ud1vpCLWC1RfOwt281SE+gQS0/R5jO4UBIvItsCxKp2LbF6jfzolk2/aUTpAy9H0/O/UZijlOGCqv/HPtcsBmhxZ+q5X5OyNV+Cpaxelw7Jc4IkekWLC4sDJAc+t3iKl7AMKgBtED/KQwSexHnm3m8rpGVmsXNFhxtJA9Xf2uix1ELK2RDATGUdE15/B3z0V4wa0mxdcWxZnFSSrgFwE+Lvaw49MVv5291u82wvCZhDWWb2/rjkYUY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR10MB7796.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(56012099006)(10067099003)(4143699003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RGRyTE1sSTR2dFViS2tYSzFvRE5SeSt5Ulg1c1JlWXJ5Rzh5U3J1NDFVU1hm?=
 =?utf-8?B?YloyakVaWWFFNVl1WENKTW1NNDJjeE80MXU0WEppcHZUdk13ZkJnWmtEMzYx?=
 =?utf-8?B?endtYk1QcWNXL2lPUGMrbGFENk5VR09tMk9aeFVSR0dLbDQwZkViSDNYUWt2?=
 =?utf-8?B?c3p2a1lxNXU5b2V1YXFUMmJpZ1pqbEN6MnJGa2Z1T1NTa05rR2Z1bmg4WU5u?=
 =?utf-8?B?a24zdmY4cGVYY2d4QnRmY3cyUEZQUDI5aXF6RXN6cjc0MDhNSVNSb3ViRXpz?=
 =?utf-8?B?TGJ6UDl5L1FBajROS1VsdkNRUEkwU3dTS0VLRExrT1REN1A2Uk4yUGdreEM3?=
 =?utf-8?B?TENNYlRtU1dZQ0dpamxCVkRPQUIya1crbk5FaXZUbzBTZDZJVmlQd1RjVGln?=
 =?utf-8?B?UGtQdHU5NzdpeTAxWTlFdUovREJXNGc3OUdkU01Yb2ViK0QvbWgyMTRGREJy?=
 =?utf-8?B?K09LSk1Tb0hqaVhMVjBER3kzNzJTcW42Z2M0KzAxN0RpMEgyeVMwRUtXbUVO?=
 =?utf-8?B?N0RhWHlmaG95a3Z0NkVKMFlKNjA4cXRkaklBRHZzSWQ1VDdTc2l3Kys5VzVJ?=
 =?utf-8?B?RUNVRXVIbzBucXJkdXNPUzZEOW9KQjZ4TmNEdTBWRE1PblJ5OUQwQzVmVmlY?=
 =?utf-8?B?ZHFGUXRCMWpQYUUwQ2pWY1VEbnFYZG1mTVJFRVFEWkMzbGZFZ2FrS2I1Vm5K?=
 =?utf-8?B?ZGdSeE5VSWc4SUROenQ4dnYrM1JEUk81SDNLUW4yMHFNSnQ5OGZKejluaHlp?=
 =?utf-8?B?RndNTVdwSkJuU0JhTDl6ek04QzNiWGU2MlBLS01lZ0pFbEQ3bklyd1pqVmJ4?=
 =?utf-8?B?U2lRK0kwcFFXRTJ4eHgxTGVTb01rb3d6VUZXRmhpcHpXaytRcjNVWU5aWW1h?=
 =?utf-8?B?eFhaSHR1NW5wbzA1TURlUnV0by9XQjZneFNHanBLRmNBZThKSDFJd2RvUUQw?=
 =?utf-8?B?QXp6K1dMWDJJWUwrSDFYdWVkUDFYaTZldFRjWVJqWlRTbk8vTUpSbU1FY1Nn?=
 =?utf-8?B?STgyZytiVGFXVWlQaTN4Tmg3ZmFqMmFaZk9lOW53K0xGd3N4NklZYmdOdlE5?=
 =?utf-8?B?TW1WRE5oU3N5Z2RWRnBDaHhUOGdDMTB5dmV6MGZacXlaWE1JU3E1TjlmaU5o?=
 =?utf-8?B?WDdwaEdhN2M4R3NzSURSOGd3bDFXNHc2Q0dUMWliZDlWVE5SOGl6QnFpVmdM?=
 =?utf-8?B?cUJwVWVoYUFOVXRFZEZZYVN4ZlhLWVR4Y05SL3hNZ3BmR3c2c0VLN1BaVDJh?=
 =?utf-8?B?RVRGbEx6UjM5Rk5vVmp1SVE1S1U0Q0lVQnNaRDZqUExwcUxEek9JUkM2a3dW?=
 =?utf-8?B?dFEzMFFISzQvNVNlajNoT3Zza2NvT1FuQkNMMExSaXRkRkRDejNTM2hCS2tr?=
 =?utf-8?B?ZGJSOWkwaVdvZFBoM0dyQlMwVTZEblRZcFJOOUphVUs5QnIveFNheEovNlZm?=
 =?utf-8?B?c2Zic2JSdVhVSHBPdTVXSlVsRjRpd09wczFGcWRNS09iNko5RWk2eDlNRGRW?=
 =?utf-8?B?cERvV3dRWUV2VStod3pLQkdnRDV0eW83WlovNE0zVXI3SVBGR0k1S3RwMk91?=
 =?utf-8?B?TjBoSHlkV0tHaEVNTG41QnFXS2ZlellnbXEwTWdnWnFxSHQzTzlEa2ZaUVZh?=
 =?utf-8?B?b2xRdmpUQ2ZUSG9KKzUzaEdjdEIvR3ZyUWp3a3o4NlR5bmV6QWNORm5CMk9J?=
 =?utf-8?B?b0pNSHlBanEwc0xld2U4dTNkZjRnVEdCWHMrYmxxckRxL3JyL3JDMGNvUHNa?=
 =?utf-8?B?RXBGYmJWZ1JwN25MY0dxL0k1M0xZL2F2SXZlb3B6bjZHdlNidGJMajlaaXdy?=
 =?utf-8?B?OHp3VWdkcGl2WDIydU5oaXM0TVRVdTFZR0czWHBCZ0p2T1ltVERvQnBjb24v?=
 =?utf-8?B?VHhHOGdUMXNRaXpkcHhVclFQUi9ZS0VNZUJlaGRKN0ttWlBDZlVwWWhPVUJX?=
 =?utf-8?B?b0cycE9XMHFwcFBWVmVVRmpjNmQrQzUxK0R3WUEranlTVVBuanBjWk12Yldx?=
 =?utf-8?B?WDVEeE81aDVHMys5d01vNTQ3ZVB3WTcxVWhXMVovMzBPNGFVZWlIaDdCSWFv?=
 =?utf-8?B?NUN3TGFpeDc1SnFmSXJxL2ljRWNpWnY3UW1HZHNOWE5DbSt0VEJiUlpRMWFm?=
 =?utf-8?B?bWRUTVNiTUN4Zy94amdIWUlCWVJFeGNnOWQxOFNVTXUyRDBlUkd6L3pQQ1hR?=
 =?utf-8?B?eDc1VzZ2SnBGVXdZSDBES2lKZ1VwbkdKTHRiQXd6RkRGb1h3N2hvc0kwWGhP?=
 =?utf-8?B?VVF4RW9tZW8zY0U0WFFDVlAyd0F1cko1T1dncEhVWEJleWwxMWFyQnNDZ0xx?=
 =?utf-8?B?c292dWZFdmhMMTYzN1hZWmJyaDZvWmV0Wm4zdS9JY2RZVzlKbHIzY2p4eEZE?=
 =?utf-8?Q?WNUOxRZUeZhnT660=3D?=
X-Exchange-RoutingPolicyChecked:
	Dwb26s38z7ygjaQwsxlB5/lGZ1Luq9VW1kOebzjFG4MkbpmZrgLlOKEo194K43HQVDK2XM1MAbTyxKzpnTuRgYDHcygELw9CuxmIHsQzqj0L8PzZa0369hOh5Buy1N4/Ljx0pdGZX4EwZVONmK2aVh3MHDhgW9fmCRQF8jPW6WmbKRQ6GyXTybEFs1vjH0BNZhOA3kFKzN2y2jmx/tg5w9d8uLOx1P/rRh4uFJuznaAwjjvo6T+1P6rR/s8l92OylNJlgwAaJ2uN6j6P7Mego73ZUHkTBj6yOU1QRhVN8kJ/MNAyYIrobrkqLy19tagkrF6rfTwMDiI7VBIZDk6HVw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rhHaGB7UtLemxkj/aNkmcw2/6uJdnv1pH1Te7rMIG7ZXzAzyxjCyBfN0DiBFpEr1moqExMazKlyw4ukwl/APnetjn/K2Kn5nzqYtv64IelDDzN/ZSnfDR2NL8EGMLu/Om4aS3Ad8FJ5dNGN48CO822cx9kSVM5ERgK/N1I/XduHciqWxNKzVZou4e9LmQdlXYpxzqmrBB2LMSZuKMdaPbwQnH6KEUn/O7ay+W/HfFRzC9zYjuS7Np6QzdcCuDHFLw3Q7AWVuKXImUZ5ZgvvOPG7pJ4Jq3MDXS7cZRHca+c0BZYNJ+bE9mgFRtPKqz1rseDQTaNknbGbTEXRAOOr4ZuOHRpdk0VKJlJLHE8cyLH6/gEddSWjuMoA5XPazVwLFxC+ey0ZhV0054sPFHhy37o6zKfN1bsyjE9CpH696daRyuvIaU5vZT5RxO5O9mSbzmUX6YDuU530CGIDEwaqxoLoEvTlVicJRheWkRMhwSKGHM3KcZOQybRFS5a3Ru4XW0bjV0sI41AXqHhHbPZV5gOdWB6Wk/HiG/BOsXgLY3/G/RStyU0lgximDblSBJ4MtpZBReyCCQqsjsUBQPPVfaMS33sUmo1w2vuNCPI4ViuE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 835308cc-e247-4398-ef83-08df23e4aac4
X-MS-Exchange-CrossTenant-AuthSource: LV3PR10MB7796.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2026 20:01:53.7473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjegZ5fA5G9+MX7xAbWfx+sYxoZG6v+nR2NxDTEfWJYeyOtnplZ35V1alIiUmjPn6fg233oxFYqL/aTP6EMaMPTkFd7zL7hClxiYGcrPe54=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5744
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-06_05,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2609040000 definitions=main-2610060079
X-Authority-Analysis: v=2.4 cv=Cpsq4X4D c=1 sm=1 tr=0 ts=6ac553bb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=yPCof4ZbAAAA:8
 a=9xjIcLrfNv3MFfX6abAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: eTH02zPlmG31r8vxpuDcImSl1Hq_Seh_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA2MDA3OSBTYWx0ZWRfX2M+W/ym0/5H+
 /+kb+sabW6wdGy2WiKK1AUT8K66U7KCfeGXn7AgGPAHdnzeqHg2hu2yFwhIkRUNq29ldJYUzinL
 nA9vNDzadUooyKFFXqgUWG5H8bgpSuIfGJ9XV313lc/JqakLXpVg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA2MDA3OSBTYWx0ZWRfX4Ve6Q6cpxj6p
 SYIeb8oW+G519dRjpTB9s7Yt294tfbZX4ebExmVXsnYYMKLa4SQI7nTFMuJuCMVq/srh67ynVYm
 FXHDmmzpLYmkRbXe4aq1/vGGquJTMnZlIaUBmZSRZq7eZINHIdtTnCpSnwFCLwGGBHbOnJs0Z0h
 8wQCxlChaTWVytZY9uRKG6p6XuvdD//8kriHw3Z2/6Ym34rKye9jiS8n5gR5gjIVdb+osk+OHdq
 YaehPr4fubBwh7c6yWGsp4MeMJVd0PHC66ef1x1xaluAYwtp2DrdGjAyLPXg9WrxN9WKUSdT5mq
 bWIpMWquD1Tw8G/+nqlztL0k0o/fdxeD3xDNleZG3S43QLh7A+hnNRmjiT1t9Pxyvb/2XDQAVZr
 usPZw4vrdfIpG03uZH1YDFWR4ONPw1prdWGd2lWRWNTEp+I+OoZmCiPZNduq5WXvA1e1WzIpCH2
 XlT5U+nOY8L5mlu0WNg==
X-Proofpoint-GUID: eTH02zPlmG31r8vxpuDcImSl1Hq_Seh_

On 8/19/26 10:35 AM, manjunath.b.patil@oracle.com wrote:
> 
> On 6/11/26 1:13 PM, manjunath.b.patil@oracle.com wrote:
>> On 6/10/26 5:06 AM, Tariq Toukan wrote:
>>>
>>>
>>> On 09/06/2026 2:42, Manjunath Patil wrote:
>>>> mlx5e_update_carrier() reports both link-up and link-down carrier
>>>> changes, but an administrative down does not reach it in practice. The
>>>> close path first changes the port admin state and then clears
>>>> MLX5E_STATE_OPENED and drops carrier silently in mlx5e_close_locked().
>>>> Any queued carrier worker will skip update_carrier() once the device is
>>>> no longer opened.
>>>>
>>>> This leaves "ip link set dev <dev> down" without a matching netdev
>>>> "Link down" message, while reopening the device still reports "Link 
>>>> up".
>>>>
>>>> Report the link-down transition in mlx5e_close() before the common 
>>>> close
>>>> helper clears the opened state and drops carrier. Guard the message 
>>>> with
>>>> the current opened and carrier state to avoid duplicates when the 
>>>> netdev
>>>> is already closed or carrier is already down.
>>>>
>>>> Assisted-by: Codex:gpt-5
>>>> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
>>>> ---
>>>> Validation:
>>>> - Built an OL8 mainline test kernel from this change.
>>>> - Booted 7.1.0-rc6.bug123456.el8.v1.x86_64 on an mlx5-backed VM.
>>>> - Confirmed `ip link set dev re0 down/up` and `re1 down/up` now emit
>>>>    netdev `Link down` and `Link up` messages, alongside the existing 
>>>> RDMA
>>>>    port state notifications.
>>>>
>>>>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
>>>>   1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/ 
>>>> drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>>> index 8f2b3abe0092..a04a89f0eddf 100644
>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
>>>> @@ -3628,6 +3628,9 @@ int mlx5e_close(struct net_device *netdev)
>>>>       mutex_lock(&priv->state_lock);
>>>>       mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_DOWN);
>>>> +    if (test_bit(MLX5E_STATE_OPENED, &priv->state) &&
>>>> +        netif_carrier_ok(netdev))
>>>> +        netdev_info(netdev, "Link down\n");
>>>>       err = mlx5e_close_locked(netdev);
>>>>       mutex_unlock(&priv->state_lock);
>>>>
>>>> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
>>>
>>> Thanks for your patch.
>>>
>>> I wouldn't print "Link down" as part of the "close" callback. I'd 
>>> rather get it printed in the event handler. Currently there is a 
>>> print there, but the callback is masked by the OPENED bit.
>>>
>>> This made me revisit this area, and it surely needs some more 
>>> interesting enhancements.
>>> I'll probably come up with some changes soon.
>>
>> thank for you taking a look at this patch.
>> I will hold on and wait for your changes.
> 
> Any update on this?
> 
> I checked a v7.2-rc6 based kernel. That still showed the old behavior - 
> 'fup re0' reports 're0: Link up', while a successful 'ifdown re0' 
> remains silent.
> 
> -Manjunath

Hi Tariq,

Any update on this? Should we put in the proposed change until you come 
up better solution?

-Thanks,
Manjunath
> 
>>
>> -Manjunath
> 

