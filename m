Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793421386;
	b=haKEFO93GssLCmrbe8mDNkSSrzkL1kYYSYvM6BVJpiLzeCysBXyrEBmcbY7rPQTFoNyk
	 y+JWkzhBHUUf/wOD6CiE8PMG6UWF5pcR78i21+x48chfwkG1Z0XWW1dDPrgtmhVWnJGgg
	 TPBgoqRLxDodX0tMunk2EWNo3LvEP8Z4WWPOBEGLbOTOsipwUQfYOMvCYnlamCWnh43ca
	 RDuJ9SHQKm3588jVjka+TB84aWiP03406OlPAD/yEHI+1O2vhW0hRDBGNgUqwBSsRRgkx
	 2AJBhudqrLL74UTJsEtXEi9RkeX9znEzJrOtwXE9sSo2YfymV7ZhojhSAZeH2Zk5YOw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793421386;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:
	 Received:Received:Received:Received:From:Date:Subject:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:CC:
	 X-Mailer:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-LD-Processed:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Info:X-HPE-SCL:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=hbaj3Ct3ps8wBiutJ9MOAZGoJl5sk+kpIb0VOnT1vkg=;
	b=KkXRidTSJ3Qpkt7VkSConGygvGbvsxMpsW56H59pQatqKH9Z4ekoUUB1ZSeWTp9lxvu2
	 H2FxMhUBg9xAjk27XgOU0yi3mrv/uVW6bZfdIMKyJnt6P3jYVQKR9lBgjU70bBHGVWVGa
	 +bNQJ9Jtu9pWQfQNHLsmv19sfc1/BqVSE3oE78E2sBdk6dsQH2TLUNag2ZJj3pv9AEiko
	 PaJvju+LKle5dwd9eab4dGFzACtKoUUkgGyj8YCwzSTVrkLmyb6MdAS4D6gBlP8cw/i8A
	 IeNopbotOsbogPpeKhQ9VHEMEdQYVI+4oCiiUx2spuRnrIIdQfHHRqgF2FRA4lTmhvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=hpe.com;
	spf=pass smtp.mailfrom=hpe.com;
	dkim=pass header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=K4hBzT8B;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.143.35
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D76606A31E;
	Sat, 31 Oct 2026 04:36:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32D76606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=hpe.com header.i=@hpe.com header.a=rsa-sha256 header.s=pps0720 header.b=K4hBzT8B
Received: from pps.filterd (m0134424.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69V2ALaF2221350;
	Sat, 31 Oct 2026 04:36:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=hb
	aj3Ct3ps8wBiutJ9MOAZGoJl5sk+kpIb0VOnT1vkg=; b=K4hBzT8Bthi6mKJhux
	WIy9DVeewn/cm95YssesL9qJRn8CvxDvKngqNOmM7MfkSCxz8pi9Xm9in4wRcSbZ
	QJves/Cyp0s6QU8CKNfGGS2PItFwUbXbSl9YTw7wUPua1KWclxQVB59/afxAue+9
	UOOemTx4IC7Cqv+D6Lml9YlJmZaB4L7O0eE2L8Zq+uLe8AF4TG6p1fqwMYycueHe
	+/nRChDndy0JlK8h0gzkRX7lIpZWHsoX1rIsADVeTN5LCwrtAoIoE6+sqtEHTBhx
	XmZSvDjocMuAq+N2JT1ziqGSJDesgCAFpwliieYasHaeiIeOxiEZPocaK4XUfMB0
	Mvzg==
Received: from p1lg14880.it.hpe.com (p1lg14880.it.hpe.com [16.230.97.201])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 4hn7ajh1hs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 31 Oct 2026 04:36:14 +0000 (GMT)
Received: from p1wg14924.americas.hpqcorp.net (unknown [10.119.18.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14880.it.hpe.com (Postfix) with ESMTPS id D5615800EC4;
	Sat, 31 Oct 2026 04:36:13 +0000 (UTC)
Received: from p1wg14928.americas.hpqcorp.net (10.119.18.116) by
 p1wg14924.americas.hpqcorp.net (10.119.18.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:13 -1200
Received: from p1wg14919.americas.hpqcorp.net (16.230.19.122) by
 p1wg14928.americas.hpqcorp.net (10.119.18.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Fri, 30 Oct 2026 16:36:13 -1200
Received: from DM2PR0701CU001.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Fri, 30 Oct 2026 16:36:13 -1200
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwmIlQdTqUi2eNMDXZ3ofjzxApCMXsviMO+brm5Ybt7POVYckmSAsQAUO8/5QDT/wHLogYFPDV7UvnDyoChYbeeQL6j6SLRtoSJ5tQAgR77ebhRbQjB0RTyZBlqbXkZ28WgtieJNtHAZYs8EDzxLPZ6epQ3gR+OoOl9Yuufcf3HDJpRb2bVx/Mf4RGpUKb/UGXA8UEyAFCcz0NMo2TC1N/4OD5YVmLiRfmVVDQsR+Wtycw6uSGRaY0/ZHlDiFBmZJzEWuFlcK4el3K7k4bV7R1WffAu21NCfNE1EuDtssN4zkGWyLGkBNqfO4OXnsaCG1P7Awo7g7t7u8I81jasN8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbaj3Ct3ps8wBiutJ9MOAZGoJl5sk+kpIb0VOnT1vkg=;
 b=ZcyDO4yE7yKTQhll80pHCdlpzocuFCZF8DeXVwYbUZxQiikyyMHtlpzibyF65Vg2blQ+YiofXFeuDz3Ra5UCsRmRITDfcq6M6NtOB6F3GfcQ3bmP30VKs4xhOTO3cGPffybeO/iksyW+olGZoTyn5Y0jYYj38DHwaIF7PVrvBDpevMcXVCrGB1ZBsyl2tI+SagT2wLZjmZSfCe5lxlkX2Mbu4xHlT4foam3hVelsn7e/JBfUNBev/GWC9jU97rFz7FrmLRW1M4PNP06P6b+mADcHMgP2RyX4QNu2JAr95Io8YnV/cJCAyHTtCED7KG9jMpFJlSfEwOqratPhp4q7Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=hpe.com;
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:8:225::20)
 by MW4PR84MB2091.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Sat, 31 Oct
 2026 04:36:09 +0000
Received: from DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8]) by DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::d136:e75e:53c5:73d8%6]) with mapi id 15.21.0569.009; Sat, 31 Oct 2026
 04:36:09 +0000
From: Doug Ledford <doug.ledford@hpe.com>
Date: Fri, 30 Oct 2026 21:35:34 -0700
Subject: [PATCH 06/11] RDMA/cxi: add explicit context LNI and PID lifetimes
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261030-cxi-for-next-v1-6-bc6e49e07037@hpe.com>
References: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
In-Reply-To: <20261030-cxi-for-next-v1-0-bc6e49e07037@hpe.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Slingshot Open Source Team <slingshot-os-team@groups.ext.hpe.com>
CC: <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Doug Ledford
	<doug.ledford@hpe.com>,
        Iraimani P <iraimani.pavadai@hpe.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: SA9P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::30) To DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:8:225::20)
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
X-MS-TrafficTypeDiagnostic: DM4PR84MB3970:EE_|MW4PR84MB2091:EE_
X-MS-Office365-Filtering-Correlation-Id: 72059050-69eb-4f5a-af17-08df37087c59
X-LD-Processed: 105b2061-b669-4b31-92ac-24d304d195dc,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|6133799003|10067099003|18002099003|22082099003|3023799007|56012099006|261021121427099003|5023799004|261021130227099003|261021135927099003|261021123027099003|261022105027099003|261022113327099003|261026135527099003|261026140227099003|261021133027099003|261026121527099003|261026130827099003|261022115727099003|261028144727099003|261022075727099003|261009223027099003;
X-Microsoft-Antispam-Message-Info: 8+a9S6NNFkXLfN0+dwk8EPMsGncvVoaDWv1CN2XDUIWEpBkeQpYROh9AUs2f0IN0j5SKVtlleXA61zr7r18SD40wplBYh2QojbDnvLq4EscJoied+LXQMzmD2+3oKyHeBiD0rostn2QWTVz6U9MjNWkHc6f7n9IDSu1LIs6qGg3E/G/aYmzVtWaaWQZGFPwb0AADaqOytc2Td3gGdtEyXgIz6/3H8K1r6yKCrlAr78h4KYr+PRvnqZ6ufuyeqDf6Fb3VnrH5PA6OZV1R+TLCjkFKm8fDemt4f7C6s7a2yoUW7bUuAtZhmh2++44Hsfla5I/gnS2yHIh5Z0LOzkbE0+5Mx4giOvKjT19qst2vfgDirLIHESkFASmxOVwsFAsIySwz57i0cAliFjOKWCuhJts2npTlM+L9CTugURq9zArka9khcskIAOPi09rkosIhTZaR3dVjFQA/VbE8zzzvzfQPwJmTBXroldfNJ95+m1f6OnCQgFta6mScfgReTWcXEXSqa8L0v+zggm1UQsF+MDk/dEB7RnkV8VJNStq073EWvnDoQdqcRtCtyeI1iBZPXpRQsrGzpMIHc0FXMYMRxLsM91q+rKh4+SO10t9H2P7k4QeuaLR0g2vBYnCS5nfP49lajdPheEbUi8Vmp9GLUtaiZyWbgTNvXxupxJbojB8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(6133799003)(10067099003)(18002099003)(22082099003)(3023799007)(56012099006)(261021121427099003)(5023799004)(261021130227099003)(261021135927099003)(261021123027099003)(261022105027099003)(261022113327099003)(261026135527099003)(261026140227099003)(261021133027099003)(261026121527099003)(261026130827099003)(261022115727099003)(261028144727099003)(261022075727099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODA2YS9tZlB6Mk1Gc0JzVFpucFE2U3ZsbU8vMGoweE1sbk5pNnhOSnZONGVv?=
 =?utf-8?B?MlE1N3hhVzFNT1krUG5wVWlhOURONkVMVWdUQlFTZ3NYb2t2Smc4cndML3pi?=
 =?utf-8?B?UkFGb0cvTmxtUmhNRnhBbnVxYWZyYk9CWEh3U2RwTHJCNVBvQXpvdU5jMlRn?=
 =?utf-8?B?aWpoTVU1UDl6MGtxbEdnUC92RFNPWndyc0c4blkrVW96dmRmTHNDc1UyQnZQ?=
 =?utf-8?B?cXI5OHJhbjBvMXZyWnpjYzg4Q3FEbkhIS3JYY0NIanFjZEdjeHgwa1E5YnBr?=
 =?utf-8?B?WTdBWFBPbFNXcUMvVHRBQmN2TzV0LzVJWTIvMXpjN0lRdDFTZVdHRS9OdGtk?=
 =?utf-8?B?M0F6ZXY1ZjdqcEUxb1Vvd3ZobFBKNWQ0cjIrSUxFMG1la0p2dFp6TVI3KzJX?=
 =?utf-8?B?Y3o1UUN0ZkJOUWt0a2JXek4yR0JwS1VJWndNM0U0M0ZTY0ppbHArV2kzMFBh?=
 =?utf-8?B?WjRlVWxXMjhrcUdrbDVlMEp1bWdjeUIxRFVYMHd6T1hPWlJVVzhHdFdQc0VZ?=
 =?utf-8?B?cWhXamN6UWxremdOSUJEUFRseWt6Zk5PUEM2c3lsRU5FRnUzYUllZklaLyt2?=
 =?utf-8?B?RUhZVXlLSCtWRnFtZGN2VFBScGpUZjM5dENiQ2RlMjM4RlphbXBjWmEvazdG?=
 =?utf-8?B?Q1RqV3hOT3F1WnJHbk4raHp0M1RJRktmMlZ2Qm1URXMxd08wKzQ3ZTg3SXVD?=
 =?utf-8?B?TjZqQ1UxSWQ1VUlGVjJVa25jS0c4aXN3RlJjRjdDcURkQ3ZkVjM5azhITmUv?=
 =?utf-8?B?ZEkyOENSMzFZMUM4aHBPcnN0L1hzcDVDZm9jVEtheE42MEtYSWtITmNpVWdI?=
 =?utf-8?B?bXRXMU1LRVVZME84KzNsTTVXMlpjY1B3VkVUZnNzRmZ2cWlHbHZVK3YxbUVQ?=
 =?utf-8?B?SnBwdVpVUzZzRk9uc3dKQW1MV3pHMmpoc2xDeDFiNE15R1RYdDRBZzZjbi9i?=
 =?utf-8?B?d1lOcXZOeEthbGZxZ2pReVUvQ3dUV0hLVkd5L3ZiQVBqbExwVHJmQUE2bUhZ?=
 =?utf-8?B?ZkkzMFdrSzJaTWhZbVZpR2h2N0Z4bkFEU295L201VkJUY3pRZldiUGc1QXZE?=
 =?utf-8?B?SFpENU5HemR1b1lSZnhvMTJUUWl6QU5xZXdJSWU2ZmozcEFOb0FpM3Nlb2RS?=
 =?utf-8?B?ZlZLM3JRdXlPSVVMSGQvcnFnOFZwV2QvaHl2OW5TbmZ2U2p3MCtPYlplT1k2?=
 =?utf-8?B?ZC9uR0JSKzN3Vi9wTFQwSXlaSkdpVDNIZEsxcldCaTBvTG95NGJjSmk2ZkhT?=
 =?utf-8?B?UG5oNjV1NGIyaDlycHI3L0JmNnpEWUM5YWhlNFZlRkM4MWw3NWRyQlJ6MmxC?=
 =?utf-8?B?VSs1aWlpUkVjS1YxZTJDdmlBM0VaRzJXU0NlaTBxdDM0a0xBSmhleVVETEg3?=
 =?utf-8?B?RGN2bThsNHpmL1VUMk16Y2w2TGlFajR6SU1LM1B2VFVNY2w5Ti9jSXRIQ2Zu?=
 =?utf-8?B?anY2YmNpbUlLN2p1TnBjWmZuNjZkbUtDelRVdk93OERRUjlUYjZjLzV4KzZt?=
 =?utf-8?B?a0FxdjFBNjJMYXBRWVlzcWZ4Y1VVTGlXc3NxUGtwejlPVkNYZXRRR2ZOZEZV?=
 =?utf-8?B?SFNGWE5Ya0hJY0FzZWNhSjgzaURXb3I2MUNsRUNjTVNINjBUNWs4c0NOa2l3?=
 =?utf-8?B?YkIycWFsczQzSWMySUdiRHBVQ1dCemxuTXlVQUd1bXFvZFdXK0gzZ1FTYXZh?=
 =?utf-8?B?YVptNlhleHhyQm5sb05wdXlrTytPNWVBVEN1ZVlGMHA0L3RsUVQwSVkra3hr?=
 =?utf-8?B?cHhCVG9xbTlQTUpTcWtFUlJNejUwdDVKejdqZmt3aGV4QUFIc21pbjNHT1gz?=
 =?utf-8?B?M21ybUl3UTgva2oxL084UjNMcU5ramh4L0JsUi9hUkIrUnRhUHNZS2U4Z2hk?=
 =?utf-8?B?MmFLeTBHV1kzSFdMbWl2VVQ3ditpL0FNdk1USENyRnRFK2wvRlFQM0dVWU16?=
 =?utf-8?B?QjdqejVYYkNLYjQrVEZMWkFwWHJ0WlZ5RktZaWpXb0R6d3IvUWxYOTNSNG1V?=
 =?utf-8?B?bjQrWmMwRUdISUs4a3J4b3Bob2ZLVUlxeWNJdEwxN05JTU5MVXQyY0p4aGhv?=
 =?utf-8?B?WnJIWGFWWmNXMWMyR3dlOVpjdjFQci8xRVRaL2xwN3AvRmcwOFNuaWpnYyth?=
 =?utf-8?B?UW5NZmNTMDg3S0VxZXpyWW03YTlQZXluN2hIS2F1MUNTTThTWFdCTzFzTmlC?=
 =?utf-8?B?ZitpZUZ6QWc5WFVUYjJjYzNid2w1eGh1ajhFdk9BMVMxL3lPNjhSdDAzYlRi?=
 =?utf-8?B?ZndBUWdFa0ZlNE93WG00Mm5MbUFxdTJwaGdNOGt5YnY5ODVaVzg4bktvNDhv?=
 =?utf-8?B?aUpBOTlUUGMxRlY5cE5MMHN5N0lBT1Q2RkJmVEVlSmx1Q1J0OUhIdz09?=
X-Exchange-RoutingPolicyChecked: hYMM9Y7yjHcabbxpEXZ3Kgjojx5xMVbvSE32QFagzZsuWtkiXzuJb1tzJSRNo+BRm8Uo98zdDv+VaTTh+AxwiMovN/Hb8sbUQVB3QHiB70/2KF72Rv1PuAKxKTlI213G7psSC5LBdta5AGQZRMHDJQ3561Bv0AoEa8Yb47GNBvrNb37JORw4OPXzmFJ+ZCL6XI1uy4crkIf/A2QQBEM5DjQRsRDaTdijB/UhCu9zEfTp45abOnqfr0OtDAvKDcBVlXVnMEw2BAf8B4o3FMU0GGKF/wYtaR6V99OhTWozWnKNUNRbyyNKr56q/EPVyVdq2LVoj1Uy3coHU8p+ZWuOBg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 72059050-69eb-4f5a-af17-08df37087c59
X-MS-Exchange-CrossTenant-AuthSource: DM4PR84MB3970.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2026 04:36:09.7455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JbuqqXJfpJoArNzjo0fQ5mjLaMGSLvzb8uIWsWu76GI79c9YdXsqpTCsYIM0Q9DaQnsrHoLz+U1MEOG5Is96eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR84MB2091
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: 8ZODIoGgbh_rXa-0n39XClvwrM80ZXLU
X-Authority-Analysis: v=2.4 cv=O+asLx9W c=1 sm=1 tr=0 ts=6ae5703e cx=c_pps
 a=A+SOMQ4XYIH4HgQ50p3F5Q==:117 a=A+SOMQ4XYIH4HgQ50p3F5Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=gQcMVamqm3wCPoSYhaRC:22
 a=3haJ9R1Aw3gUfsUHDaCR:22 a=MvuuwTCpAAAA:8 a=LbMNpL0TmfN9__oXkIIA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX3FJvzHpARbhG
 d/qQ7Ww2zf9F6xnYHkaS1v2j8fw64QJmmAKn1hWJF2Fk6W6PJJ2q5gS/9+FpbEAawIxup3fomoX
 zZI0bah/Wy7dq3wkih2rgYv1qsjuPghD1BxkejoSR8HrQZ6fCtxpL4aKyQIirSXn0dNDCX3+5zf
 PiT4EL2OEVHWko0xdvVfpNFArb6ebPr6gCeWWmNiPBGJrGYToEijxwONB9U33gSWN2xGFaFZ50c
 vP1YEHivzRLkig6PZgIe6oN/kIBTQSZwpaNoYMKfJO3hEg04Iwfv3dOyrRfFKLmQz7w1TWZK+iG
 V8+3MBxXGtGTJshybEGBfUCRFZIwMYDJb1hhRKsr+Uvs1Yx+7xGBw2YXegNn+N1XuaejI3eHMcY
 M5JkZsJbyrBL1c8i+wxVkfmCcWfflN5dTb2iSgoz0RDhjyItOlmhSNNerfqrF86Nk+0D98/phXM
 LRKDUUQyQQhRLiG1H8g==
X-Proofpoint-GUID: 8ZODIoGgbh_rXa-0n39XClvwrM80ZXLU
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDMxMDAxNyBTYWx0ZWRfX2W8WjCKbl2K0
 9i54SUUj1+hQvEIV5yX4CBVyOu+LASzAXmKafXHp4sl6EOdJzzibgZW0SpUtryBZofGo0ZBSWJ7
 ZB91DfRhlQ077xDWRgrPUOKYJCinHFw=
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-10-31_01,2026-10-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2610310017

Add the context and device-level verbs: ucontext allocation, jobs and
job keys, protection domains, completion queues, address handles,
GIDs, device/port queries and the mmap entries for doorbells and
queues.

An LNI and a PID are never created implicitly.  They are bound to the
context or PD by explicit methods added with the object patch, and
are released in an order the mmap entries enforce: a mapping holds
the resource it maps until the last VMA goes away.

Shared RAM buffers are mapped with rdma_user_mmap_io(), as for
device memory, rather than remap_pfn_range() directly.  The helper
registers the VMA with the mmap entry, so the owning CT or queue and
its LNI stay allocated until the last mapping is unmapped; mapping
RAM directly released them when the owning object was destroyed while
a mapping still existed.

Replies to user space use ib_respond_udata() so that a short response
buffer is truncated and a long one is zero filled, as the ib_udata
compatibility rules require.

The CSR aperture mapping is privileged and publishes the mmap entry
only after its permission flags are set, so the entry is never
visible half initialised.  Privileged mappings (CSR, PCT EQ doorbell)
require CAP_SYS_ADMIN when created and when mapped.  These mappings
are specifically for use by the card's Retry Handler (to be introduced
in the rdma-core submission).  The existing Cassini hardware does not
handle retries in hardware, and these CAP_SYS_ADMIN mapping is needed
for the Retry Handler to be able to directly program the card's CSRs
for the necessary packet resends.

Implement optional, sparse per-job address tables with device-capacity
and per-operation index bounds. Explicit-AH callers may allocate jobs
with zero entries; release stored addresses when the job is destroyed.

checkpatch --strict (100 columns) still reports the following in this
patch. They need coordination with the internal repositories this code
is maintained in and will be fixed in V2:
- CHECK: PARENTHESIS_ALIGNMENT (13), OPEN_ENDED_LINE (3), LINE_SPACING
  (1)

Co-developed-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Iraimani P <iraimani.pavadai@hpe.com>
Signed-off-by: Doug Ledford <doug.ledford@hpe.com>
---
 drivers/infiniband/hw/cxi/cxiverbs_main.c | 1105 +++++++++++++++++++++++++++++
 1 file changed, 1105 insertions(+)

diff --git a/drivers/infiniband/hw/cxi/cxiverbs_main.c b/drivers/infiniband/hw/cxi/cxiverbs_main.c
new file mode 100644
index 000000000000..19a796cd5c27
--- /dev/null
+++ b/drivers/infiniband/hw/cxi/cxiverbs_main.c
@@ -0,0 +1,1105 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * CXI InfiniBand RDMA driver — Phase 0-3 and Phase 5 implementations.
+ * Copyright 2022-2025 Hewlett Packard Enterprise Development LP
+ *
+ * Covers:
+ *   Phase 0: query_device, query_port, get_port_immutable, query_pkey
+ *   Phase 1: alloc/dealloc_ucontext, alloc/dealloc_pd
+ *   Phase 3: create/destroy_cq, poll_cq, req_notify_cq, mmap/mmap_free
+ *   Phase 5: create/destroy_ah, add/del_gid
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/gfp.h>
+#include <linux/random.h>
+#include <linux/mm.h>
+#include <linux/vmalloc.h>
+#include <linux/io.h>
+#include <net/net_namespace.h>
+
+#include <rdma/ib_verbs.h>
+#include <rdma/ib_mad.h>
+#include <rdma/uverbs_ioctl.h>
+
+#include "cxiverbs.h"
+
+/* =======================================================================
+ * Phase 0: Device and port query
+ * =======================================================================
+ */
+
+int cxiverbs_query_device(struct ib_device *ibdev, struct ib_device_attr *props,
+			 struct ib_udata *udata)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibdev);
+	const struct cxi_properties_info *p = &dev->cdev->prop;
+
+	memset(props, 0, sizeof(*props));
+
+	props->vendor_id      = dev->cadev->pdev->vendor;
+	props->vendor_part_id = dev->cadev->pdev->device;
+	props->hw_ver         = dev->cadev->pdev->subsystem_device;
+	props->fw_ver         = 0;
+
+	props->max_mr_size    = ~0ULL;
+	props->page_size_cap  = PAGE_SIZE;
+
+	/* Queue pair limits (bounded by portal table entries) */
+	props->max_qp     = min_t(u32, p->rsrcs.ptes.max, 1024);
+	props->max_qp_wr  = 1024;
+	props->device_cap_flags =
+		IB_DEVICE_MEM_MGT_EXTENSIONS | IB_DEVICE_RU |
+		IB_DEVICE_KEY64 | IB_DEVICE_USER_RKEY | IB_DEVICE_IMM64;
+	/*
+	 * No CXI initiator command carries a gather list and a list entry
+	 * describes one buffer, so a work request maps to exactly one segment.
+	 */
+	props->max_send_sge = 1;
+	props->max_recv_sge = 1;
+
+	/* Completion queue limits (bounded by event queue count) */
+	props->max_cq  = min_t(u32, p->rsrcs.eqs.max, 2048);
+	props->max_cqe = 65536;
+
+	/* Memory registration limits */
+	props->max_mr  = 32768;
+	props->max_pd  = 1024;
+	props->max_job_ids = CXI_IBV_JOB_ID_MAX;
+	props->max_job_keys = props->max_qp;
+	/* The table is sparse and software-managed; the API uses u32 indices. */
+	props->max_addr_entries = U32_MAX;
+
+	/* RDMA atomics */
+	props->max_qp_rd_atom      = 1;
+	props->max_qp_init_rd_atom = 1;
+	props->max_res_rd_atom     = 1024;
+	props->atomic_cap          = IB_ATOMIC_GLOB;
+
+	/* Pkeys / GIDs */
+	props->max_pkeys          = 1;
+	props->local_ca_ack_delay = 0;
+	props->max_sge_rd         = 1;
+
+	/* On-Demand Paging capabilities */
+	props->odp_caps.general_caps = IB_ODP_SUPPORT;
+	props->odp_caps.per_transport_caps.rc_odp_caps =
+		IB_ODP_SUPPORT_WRITE | IB_ODP_SUPPORT_READ | IB_ODP_SUPPORT_SEND;
+
+	/* Driver-specific UEC / vendor capabilities via udata */
+	if (udata) {
+		const struct cxi_dev_info_use *di = &dev->devinfo;
+		struct cxi_ibv_query_device_resp vresp = {
+			.features = CXI_DEVICE_CAP_UEC_QPN |
+				    CXI_DEVICE_CAP_TRIGGERED_OPS |
+				    CXI_DEVICE_CAP_ODP,
+			.max_ctn  = 1024,
+		};
+
+		/*
+		 * Device-wide properties normally read from native's
+		 * DEV_INFO_GET ioctl / sysfs tree — neither exists on the
+		 * RDMA path, so hand them back here instead (see the
+		 * cxi_ibv_devinfo comment in the uapi header).
+		 */
+		vresp.devinfo.nid                 = READ_ONCE(di->nid);
+		vresp.devinfo.pid_bits            = di->pid_bits;
+		vresp.devinfo.pid_count           = di->pid_count;
+		vresp.devinfo.pid_granule         = di->pid_granule;
+		vresp.devinfo.min_free_shift      = di->min_free_shift;
+		vresp.devinfo.rdzv_get_idx        = di->rdzv_get_idx;
+		vresp.devinfo.vendor_id           = di->vendor_id;
+		vresp.devinfo.device_id           = di->device_id;
+		vresp.devinfo.device_rev          = di->device_rev;
+		vresp.devinfo.device_proto        = di->device_proto;
+		vresp.devinfo.device_platform     = di->device_platform;
+		vresp.devinfo.pct_eq              = di->pct_eq;
+		vresp.devinfo.uc_nic              = di->uc_nic;
+		vresp.devinfo.link_mtu            = di->link_mtu;
+		vresp.devinfo.link_speed          = di->link_speed;
+		vresp.devinfo.link_state          = di->link_state;
+		vresp.devinfo.num_ptes            = di->num_ptes;
+		vresp.devinfo.num_txqs            = di->num_txqs;
+		vresp.devinfo.num_tgqs            = di->num_tgqs;
+		vresp.devinfo.num_eqs             = di->num_eqs;
+		vresp.devinfo.num_cts             = di->num_cts;
+		vresp.devinfo.num_acs             = di->num_acs;
+		vresp.devinfo.num_tles            = di->num_tles;
+		vresp.devinfo.num_les             = di->num_les;
+		vresp.devinfo.cassini_version     = di->cassini_version;
+		vresp.devinfo.vni_matching        = p->vni_matching;
+		vresp.devinfo.system_type_identifier = di->system_type_identifier;
+		BUILD_BUG_ON(sizeof(vresp.devinfo.fru_description) !=
+			     sizeof(di->fru_description));
+		memcpy(vresp.devinfo.fru_description, di->fru_description,
+		       sizeof(di->fru_description));
+
+		return ib_respond_udata(udata, vresp);
+	}
+
+	return 0;
+}
+
+int cxiverbs_query_port(struct ib_device *ibdev, u32 port,
+		       struct ib_port_attr *props)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibdev);
+
+	if (port != 1)
+		return -EINVAL;
+
+	memset(props, 0, sizeof(*props));
+
+	props->state  = dev->cadev->is_link_up(dev->cdev) ? IB_PORT_ACTIVE
+						   : IB_PORT_DOWN;
+	props->phys_state = (props->state == IB_PORT_ACTIVE) ?
+		IB_PORT_PHYS_STATE_LINK_UP : IB_PORT_PHYS_STATE_POLLING;
+	props->max_mtu       = IB_MTU_4096;
+	props->active_mtu    = IB_MTU_4096;
+	props->gid_tbl_len   = 1;
+	props->pkey_tbl_len  = 1;
+	props->max_msg_sz    = 0x80000000U;
+	props->active_width  = IB_WIDTH_4X;
+	props->active_speed  = IB_SPEED_HDR; /* nearest IB speed for 200 Gbit */
+	props->port_cap_flags = IB_PORT_CM_SUP;
+
+	return 0;
+}
+
+struct net_device *cxiverbs_get_netdev(struct ib_device *ibdev, u32 port)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibdev);
+
+	if (port != 1 || !dev->cdev->eth_name[0])
+		return NULL;
+
+	return dev_get_by_name(&init_net, dev->cdev->eth_name);
+}
+
+int cxiverbs_get_port_immutable(struct ib_device *ibdev, u32 port_num,
+			       struct ib_port_immutable *immutable)
+{
+	struct ib_port_attr attr;
+	int ret;
+
+	if (port_num != 1)
+		return -EINVAL;
+
+	ret = cxiverbs_query_port(ibdev, port_num, &attr);
+	if (ret)
+		return ret;
+
+	immutable->core_cap_flags = RDMA_CORE_PORT_SLINGSHOT;
+	immutable->gid_tbl_len    = attr.gid_tbl_len;
+	immutable->pkey_tbl_len   = attr.pkey_tbl_len;
+	immutable->max_mad_size   = 0;
+
+	return 0;
+}
+
+int cxiverbs_query_pkey(struct ib_device *device, u32 port_num,
+		       u16 index, u16 *pkey)
+{
+	if (index != 0)
+		return -EINVAL;
+	*pkey = 0xffff;
+	return 0;
+}
+
+int cxiverbs_query_gid(struct ib_device *device, u32 port_num, int index,
+		      union ib_gid *gid)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(device);
+
+	if (port_num != 1 || index != 0)
+		return -EINVAL;
+
+	memset(gid, 0, sizeof(*gid));
+	gid->global.interface_id = cpu_to_be64(READ_ONCE(dev->nid));
+	return 0;
+}
+
+/* =======================================================================
+ * Phase 1: User context  ->  one JobID-anchored CXI LNI per process open
+ *
+ * GET_CONTEXT opens an unbound context. A later privileged Job allocation gets
+ * or creates the device-wide JobID entry and binds this context to that entry's
+ * LNI. Services are selected later, when QPs are created.
+ * =======================================================================
+ */
+
+static int cxiverbs_parse_ucontext_cmd(struct cxi_ibv_alloc_ucontext_cmd *cmd,
+					     struct ib_udata *udata)
+{
+	static const u32 known_mask = CXI_IBV_ALLOC_UCONTEXT_PIDONFEP;
+	size_t copy_len;
+	int ret;
+
+	if (!udata || !udata->inlen)
+		return 0;
+
+	copy_len = min_t(size_t, udata->inlen, sizeof(*cmd));
+	ret = ib_copy_from_udata(cmd, udata, copy_len);
+	if (ret)
+		return ret;
+
+	if (cmd->comp_mask & ~known_mask)
+		return -EOPNOTSUPP;
+	if ((cmd->comp_mask & CXI_IBV_ALLOC_UCONTEXT_PIDONFEP) &&
+	    cmd->pidonfep > CXI_IBV_PIDONFEP_MAX)
+		return -EINVAL;
+
+	return 0;
+}
+
+int cxiverbs_alloc_ucontext(struct ib_ucontext *uctx, struct ib_udata *udata)
+{
+	struct ib_device *ibdev   = uctx->device;
+	struct cxiverbs_dev *dev    = to_cxiverbs_dev(ibdev);
+	struct cxiverbs_ucontext *ctx = to_cxiverbs_ucontext(uctx);
+	struct cxi_adev *cadev    = dev->cadev;
+	struct cxi_ibv_alloc_ucontext_cmd  cmd  = {};
+	struct cxi_ibv_alloc_ucontext_resp resp = {};
+	int ret;
+	int i;
+
+	ctx->cadev = cadev;
+	xa_init(&ctx->lnis);
+	mutex_init(&ctx->resource_lock);
+	ctx->lni = NULL;
+	ctx->job_id = 0;
+	ctx->default_pidonfep = 0;
+	ctx->default_pidonfep_valid = false;
+
+	/* Parse launch defaults; jobs and LNIs are allocated explicitly. */
+	ret = cxiverbs_parse_ucontext_cmd(&cmd, udata);
+	if (ret) {
+		mutex_destroy(&ctx->resource_lock);
+		xa_destroy(&ctx->lnis);
+		return ret;
+	}
+
+	if (cmd.comp_mask & CXI_IBV_ALLOC_UCONTEXT_PIDONFEP) {
+		ctx->default_pidonfep = cmd.pidonfep;
+		ctx->default_pidonfep_valid = true;
+	}
+
+	/* Initialize TC limits (placeholder; typically populated by service query) */
+	mutex_init(&ctx->tc_lock);
+	ctx->num_tc_limits = 0;
+	/* TODO: Query service for TC limits and populate tc_limits[] */
+	for (i = 0; i < CXIVERBS_TC_MAX; i++) {
+		ctx->tc_limits[i].tc = i;
+		ctx->tc_limits[i].max_ptes = 0;	/* will be filled by service query */
+		ctx->tc_limits[i].max_cps = 0;
+		ctx->tc_limits[i].max_qps = 0;
+	}
+
+	/* Populate response */
+	resp.nid         = READ_ONCE(dev->nid);
+	resp.pid_bits    = dev->pid_bits;
+	resp.pid_count   = dev->pid_count;
+	resp.pid_granule = dev->pid_granule;
+	resp.lni_id      = ctx->lni ? ctx->lni->id : 0;
+	resp.num_tc_limits = ctx->num_tc_limits;
+
+	if (udata) {
+		ret = ib_respond_udata(udata, resp);
+		if (ret)
+			goto err_destroy_context;
+	}
+
+	return 0;
+
+err_destroy_context:
+	xa_destroy(&ctx->lnis);
+	mutex_destroy(&ctx->resource_lock);
+	mutex_destroy(&ctx->tc_lock);
+	return ret;
+}
+
+int cxiverbs_alloc_job(struct ib_job *job, struct ib_job_attr *attr,
+		       struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(job->device);
+	struct cxiverbs_job_entry *entry =
+		container_of(job, struct cxiverbs_job_entry, ibjob);
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+	if (!attr->job_id || attr->job_id > CXI_IBV_JOB_ID_MAX ||
+	    attr->port_num != 1 || attr->sgid_index)
+		return -EINVAL;
+	if (attr->max_addr_entries > dev->ib_dev.attrs.max_addr_entries)
+		return -EINVAL;
+
+	entry->job_id = attr->job_id;
+	entry->attr = *attr;
+	mutex_init(&entry->addr_lock);
+	xa_init(&entry->addr_table);
+	mutex_lock(&dev->jobs_lock);
+	ret = xa_insert(&dev->jobs, entry->job_id, entry, GFP_KERNEL);
+	mutex_unlock(&dev->jobs_lock);
+	if (ret) {
+		xa_destroy(&entry->addr_table);
+		mutex_destroy(&entry->addr_lock);
+	}
+	return ret;
+}
+
+int cxiverbs_query_job(struct ib_job *job, struct ib_job_attr *attr)
+{
+	struct cxiverbs_job_entry *entry =
+		container_of(job, struct cxiverbs_job_entry, ibjob);
+
+	*attr = entry->attr;
+	return 0;
+}
+
+int cxiverbs_job_addr_insert(struct ib_job *job, u32 index,
+			     struct rdma_ah_attr_ex *ah_attr)
+{
+	struct cxiverbs_job_entry *entry =
+		container_of(job, struct cxiverbs_job_entry, ibjob);
+	struct rdma_ah_attr_ex *copy;
+	int ret;
+
+	if (!ah_attr || index >= job->max_addr_entries)
+		return -EINVAL;
+	copy = kmemdup(ah_attr, sizeof(*copy), GFP_KERNEL);
+	if (!copy)
+		return -ENOMEM;
+
+	mutex_lock(&entry->addr_lock);
+	ret = xa_insert(&entry->addr_table, index, copy, GFP_KERNEL);
+	mutex_unlock(&entry->addr_lock);
+	if (ret)
+		kfree(copy);
+	return ret;
+}
+
+int cxiverbs_job_addr_remove(struct ib_job *job, u32 index)
+{
+	struct cxiverbs_job_entry *entry =
+		container_of(job, struct cxiverbs_job_entry, ibjob);
+	struct rdma_ah_attr_ex *addr;
+
+	if (index >= job->max_addr_entries)
+		return -EINVAL;
+	mutex_lock(&entry->addr_lock);
+	addr = xa_erase(&entry->addr_table, index);
+	mutex_unlock(&entry->addr_lock);
+	if (!addr)
+		return -ENOENT;
+	kfree(addr);
+	return 0;
+}
+
+int cxiverbs_job_addr_query(struct ib_job *job, u32 index,
+			    struct rdma_ah_attr_ex *ah_attr)
+{
+	struct cxiverbs_job_entry *entry =
+		container_of(job, struct cxiverbs_job_entry, ibjob);
+	struct rdma_ah_attr_ex *addr;
+
+	if (!ah_attr || index >= job->max_addr_entries)
+		return -EINVAL;
+	mutex_lock(&entry->addr_lock);
+	addr = xa_load(&entry->addr_table, index);
+	if (addr)
+		*ah_attr = *addr;
+	mutex_unlock(&entry->addr_lock);
+	return addr ? 0 : -ENOENT;
+}
+
+void cxiverbs_dealloc_job(struct ib_job *job)
+{
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(job->device);
+	struct cxiverbs_job_entry *entry =
+		container_of(job, struct cxiverbs_job_entry, ibjob);
+	struct cxiverbs_tc_entry *tc_entry;
+	struct cxiverbs_job_tc_binding *binding, *tmp;
+	struct rdma_ah_attr_ex *addr;
+	unsigned long index;
+
+	mutex_lock(&dev->jobs_lock);
+	xa_erase(&dev->jobs, entry->job_id);
+	xa_for_each(&dev->tcs, index, tc_entry) {
+		list_for_each_entry_safe(binding, tmp, &tc_entry->job_list, entry) {
+			if (binding->job != entry)
+				continue;
+			list_del(&binding->entry);
+			kfree(binding);
+		}
+	}
+	mutex_unlock(&dev->jobs_lock);
+	mutex_lock(&entry->addr_lock);
+	xa_for_each(&entry->addr_table, index, addr)
+		kfree(addr);
+	xa_destroy(&entry->addr_table);
+	mutex_unlock(&entry->addr_lock);
+	mutex_destroy(&entry->addr_lock);
+}
+
+void cxiverbs_dealloc_ucontext(struct ib_ucontext *uctx)
+{
+	struct cxiverbs_ucontext *ctx = to_cxiverbs_ucontext(uctx);
+
+	xa_destroy(&ctx->lnis);
+	mutex_destroy(&ctx->resource_lock);
+	mutex_destroy(&ctx->tc_lock);
+}
+
+/* =======================================================================
+ * Protection domain -> selected explicit LNI + RGID
+ *
+ * PDs select an LNI from the ucontext's handle table and carry PD-local
+ * defaults such as preferred service ID and PIDonFEP.
+ * =======================================================================
+ */
+
+
+int cxiverbs_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
+{
+	struct cxiverbs_ucontext *uctxt;
+	struct cxiverbs_pd *pd          = to_cxiverbs_pd(ibpd);
+	struct cxi_ibv_alloc_pd_cmd  cmd  = {};
+	struct cxi_ibv_alloc_pd_resp resp = {};
+	int ret;
+
+	if (!ibpd->uobject)
+		return -EOPNOTSUPP;
+	uctxt = to_cxiverbs_ucontext(ibpd->uobject->context);
+
+	/* Parse optional preferred_svc_id from user */
+	if (udata && udata->inlen >= sizeof(cmd)) {
+		ret = ib_copy_from_udata(&cmd, udata, sizeof(cmd));
+		if (ret)
+			return ret;
+	}
+
+	if (cmd.comp_mask & ~(CXI_IBV_ALLOC_PD_LNI |
+			      CXI_IBV_ALLOC_PD_SVC_ID_PREFERRED))
+		return -EOPNOTSUPP;
+	pd->lni_ref = cxiverbs_lni_get(uctxt,
+		(cmd.comp_mask & CXI_IBV_ALLOC_PD_LNI) ?
+		cmd.lni_handle : CXI_IBV_LNI_ANY);
+	if (IS_ERR(pd->lni_ref))
+		return PTR_ERR(pd->lni_ref);
+
+	if ((cmd.comp_mask & CXI_IBV_ALLOC_PD_SVC_ID_PREFERRED) &&
+	    cmd.preferred_svc_id &&
+	    cmd.preferred_svc_id != pd->lni_ref->svc_id) {
+		cxiverbs_lni_put(pd->lni_ref);
+		return -EINVAL;
+	}
+
+	pd->job_id = uctxt->job_id;
+	pd->preferred_svc_id = pd->lni_ref->svc_id;
+	pd->rgid = pd->lni_ref->lni->rgid;
+	pd->pd_id = pd->lni_ref->lni->id;
+	pd->qpn_addr_mode = 0;
+
+	/* Inherit PIDonFEP defaults from ucontext if available */
+	pd->default_pidonfep = uctxt->default_pidonfep;
+	pd->default_pidonfep_valid = uctxt->default_pidonfep_valid;
+	pd->pidonfep_valid = false;
+
+	mutex_init(&pd->resource_lock);
+	xa_init_flags(&pd->qpns, XA_FLAGS_ALLOC);
+
+	resp.pd_id = pd->pd_id;
+	if (udata) {
+		ret = ib_respond_udata(udata, resp);
+		if (ret) {
+			mutex_destroy(&pd->resource_lock);
+			xa_destroy(&pd->qpns);
+			cxiverbs_lni_put(pd->lni_ref);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+int cxiverbs_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
+{
+	struct cxiverbs_pd *pd = to_cxiverbs_pd(ibpd);
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(ibpd->device);
+
+	if (pd->pidonfep_valid)
+		dev->cadev->pid_free(pd->lni_ref->lni, pd->pidonfep);
+	xa_destroy(&pd->qpns);
+	mutex_destroy(&pd->resource_lock);
+	cxiverbs_lni_put(pd->lni_ref);
+	return 0;
+}
+
+int cxiverbs_create_jkey(struct ib_jkey *jkey,
+			 struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_jkey *key =
+		container_of(jkey, struct cxiverbs_jkey, ibjkey);
+	struct cxiverbs_pd *pd = to_cxiverbs_pd(jkey->pd);
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(jkey->device);
+	struct cxi_ibv_create_jkey_cmd cmd = { .tc = CXI_TC_BEST_EFFORT };
+	int ret;
+
+	if (!pd->lni_ref)
+		return -EINVAL;
+	if (attrs->driver_udata.inlen >= sizeof(cmd)) {
+		ret = ib_copy_from_udata(&cmd, &attrs->driver_udata, sizeof(cmd));
+		if (ret)
+			return ret;
+	}
+	key->cp = dev->cadev->cp_alloc(pd->lni_ref->lni, jkey->job->job_id,
+				     cmd.tc, CXI_TC_TYPE_DEFAULT);
+	if (IS_ERR(key->cp))
+		return PTR_ERR(key->cp);
+	jkey->jkey = key->cp->lcid;
+	return 0;
+}
+
+int cxiverbs_destroy_jkey(struct ib_jkey *jkey,
+			  struct uverbs_attr_bundle *attrs)
+{
+	struct cxiverbs_jkey *key =
+		container_of(jkey, struct cxiverbs_jkey, ibjkey);
+	struct cxiverbs_dev *dev = to_cxiverbs_dev(jkey->device);
+
+	dev->cadev->cp_free(key->cp);
+	return 0;
+}
+
+/* =======================================================================
+ * Phase 3: Completion queue  →  CXI Event Queue (EQ)
+ *
+ * The EQ ring buffer is allocated from compound pages, pinned in RAM, and
+ * registered with the ATU so hardware can write events directly.  Both the
+ * ring buffer and the doorbell CSR are exposed to user-space via mmap.
+ * =======================================================================
+ */
+
+/*
+ * EQ event callback — called from the CXI interrupt handler.
+ * Notifies the RDMA core that new completions are available.
+ */
+struct cxiverbs_cq_resources {
+	refcount_t refs;
+	spinlock_t callback_lock; /* protects cq during callback delivery */
+	struct cxiverbs_cq *cq;
+	struct cxiverbs_lni *lni;
+	struct cxi_adev *cadev;
+	struct cxi_eq *eq;
+	struct cxi_md *eq_md;
+	struct page **pages;
+	unsigned int order;
+};
+
+static void cxiverbs_eq_event_cb(void *cb_data)
+{
+	struct cxiverbs_cq_resources *resources = cb_data;
+	struct cxiverbs_cq *cq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&resources->callback_lock, flags);
+	cq = resources->cq;
+	if (cq && cq->ibcq.comp_handler)
+		cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+	spin_unlock_irqrestore(&resources->callback_lock, flags);
+}
+
+/*
+ * Allocate a heap-allocated cxiverbs_mmap_entry and register it for mmap.
+ * Returns ERR_PTR on failure.
+ */
+static struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_create(struct ib_ucontext *ibctx, bool is_io,
+			  bool admin_only, phys_addr_t phys,
+			  struct page *first_page, size_t size, u64 *offset_out,
+			  void *owner, void (*release_owner)(void *))
+{
+	struct cxiverbs_mmap_entry *ent;
+	int ret;
+
+	ent = kzalloc_obj(*ent);
+	if (!ent)
+		return ERR_PTR(-ENOMEM);
+
+	ent->is_io      = is_io;
+	ent->admin_only = admin_only;
+	ent->phys       = phys;
+	ent->first_page = first_page;
+	ent->owner = owner;
+	ent->release_owner = release_owner;
+
+	ret = rdma_user_mmap_entry_insert(ibctx, &ent->rdma_entry, size);
+	if (ret) {
+		kfree(ent);
+		return ERR_PTR(ret);
+	}
+
+	*offset_out = rdma_user_mmap_get_offset(&ent->rdma_entry);
+	return ent;
+}
+
+struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_alloc(struct ib_ucontext *ibctx, bool is_io,
+			 phys_addr_t phys, struct page *first_page,
+			 size_t size, u64 *offset_out)
+{
+	return cxiverbs_mmap_entry_create(ibctx, is_io, false, phys, first_page,
+					  size, offset_out, NULL, NULL);
+}
+
+struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_alloc_owned(struct ib_ucontext *ibctx, bool is_io,
+			       phys_addr_t phys, struct page *first_page,
+			       size_t size, u64 *offset_out, void *owner,
+			       void (*release_owner)(void *))
+{
+	return cxiverbs_mmap_entry_create(ibctx, is_io, false, phys, first_page,
+					  size, offset_out, owner,
+					  release_owner);
+}
+
+struct cxiverbs_mmap_entry *
+cxiverbs_mmap_entry_alloc_admin(struct ib_ucontext *ibctx, phys_addr_t phys,
+			       size_t size, u64 *offset_out)
+{
+	return cxiverbs_mmap_entry_create(ibctx, true, true, phys, NULL,
+					  size, offset_out, NULL, NULL);
+}
+
+static void cxiverbs_cq_free_ring(struct page *first, unsigned int order)
+{
+	unsigned long i;
+
+	for (i = 0; i < (1UL << order); i++)
+		__free_page(first + i);
+}
+
+static void cxiverbs_cq_resources_put(void *owner)
+{
+	struct cxiverbs_cq_resources *resources = owner;
+
+	if (!refcount_dec_and_test(&resources->refs))
+		return;
+	if (resources->eq && WARN_ON(resources->cadev->eq_free(resources->eq)))
+		return;
+	if (resources->eq_md &&
+	    WARN_ON(resources->cadev->cxi_unmap(resources->eq_md)))
+		return;
+	if (resources->pages) {
+		if (resources->pages[0])
+			cxiverbs_cq_free_ring(resources->pages[0], resources->order);
+		kfree(resources->pages);
+	}
+	cxiverbs_lni_put(resources->lni);
+	kfree(resources);
+}
+
+static void cxiverbs_cq_release(struct cxiverbs_cq *cq)
+{
+	struct cxiverbs_cq_resources *resources = cq->resources;
+	unsigned long flags;
+
+	spin_lock_irqsave(&resources->callback_lock, flags);
+	resources->cq = NULL;
+	spin_unlock_irqrestore(&resources->callback_lock, flags);
+
+	if (cq->db_mmap)
+		rdma_user_mmap_entry_remove(&cq->db_mmap->rdma_entry);
+	if (cq->buf_mmap)
+		rdma_user_mmap_entry_remove(&cq->buf_mmap->rdma_entry);
+	cq->resources = NULL;
+	cxiverbs_cq_resources_put(resources);
+}
+
+int cxiverbs_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
+		      struct uverbs_attr_bundle *bundle)
+{
+	struct cxiverbs_cq *cq      = to_cxiverbs_cq(ibcq);
+	struct cxiverbs_dev *dev    = to_cxiverbs_dev(ibcq->device);
+	(void)dev; /* reserved for future use */
+	struct ib_udata *udata;
+	struct cxi_ibv_create_cq_cmd cmd = { .lni_handle = CXI_IBV_LNI_ANY };
+	struct cxi_ibv_create_cq_resp resp = {};
+	struct cxiverbs_ucontext *ctx;
+	struct cxi_eq_attr eq_attr = {};
+	unsigned int n_entries     = attr->cqe;
+	unsigned int cpu_aff       = 0;
+	size_t buf_sz;
+	unsigned int npages;
+	int order, i, ret;
+	phys_addr_t db_phys;
+	size_t db_size;
+
+	/* Kernel CQs are not yet supported */
+	if (!bundle || !bundle->context)
+		return -EOPNOTSUPP;
+	udata = &bundle->driver_udata;
+	ctx = to_cxiverbs_ucontext(bundle->context);
+
+	cq->cadev = ctx->cadev;
+
+	/* Optional driver-private fields from user-space */
+	if (udata && udata->inlen >= sizeof(cmd)) {
+		ret = ib_copy_from_udata(&cmd, udata, sizeof(cmd));
+		if (ret)
+			return ret;
+		if (cmd.n_entries)
+			n_entries = cmd.n_entries;
+		cpu_aff = cmd.cpu_affinity;
+	}
+	cq->lni_ref = cxiverbs_lni_get(ctx, cmd.lni_handle);
+	if (IS_ERR(cq->lni_ref))
+		return PTR_ERR(cq->lni_ref);
+
+	cq->resources = kzalloc_obj(*cq->resources);
+	if (!cq->resources) {
+		ret = -ENOMEM;
+		goto err_put_lni;
+	}
+	refcount_set(&cq->resources->refs, 1);
+	spin_lock_init(&cq->resources->callback_lock);
+	cq->resources->cq = cq;
+	cq->resources->lni = cq->lni_ref;
+	cq->resources->cadev = cq->cadev;
+
+	/* Clamp and round up to hardware constraints */
+	n_entries = min_t(unsigned int, n_entries, 65536);
+	n_entries = max_t(unsigned int, n_entries, 64);
+	n_entries = roundup_pow_of_two(n_entries);
+
+	/* Each event slot is C_EE_CFG_ECB_SIZE bytes */
+	buf_sz  = (size_t)n_entries * C_EE_CFG_ECB_SIZE;
+	buf_sz  = PAGE_ALIGN(buf_sz);
+	npages  = buf_sz >> PAGE_SHIFT;
+	order   = get_order(buf_sz);
+	cq->resources->order = order;
+
+	/* Allocate and zero the event ring buffer */
+	cq->pages = kcalloc(npages, sizeof(*cq->pages), GFP_KERNEL);
+	cq->resources->pages = cq->pages;
+	if (!cq->pages) {
+		ret = -ENOMEM;
+		goto err_release;
+	}
+
+	cq->pages[0] = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	if (!cq->pages[0]) {
+		ret = -ENOMEM;
+		goto err_release;
+	}
+	split_page(cq->pages[0], order);
+	for (i = 1; i < (int)npages; i++)
+		cq->pages[i] = cq->pages[0] + i;
+
+	cq->eq_buf      = page_address(cq->pages[0]);
+	cq->eq_buf_size = buf_sz;
+	cq->npages      = npages;
+
+	/* Register with the ATU so hardware can DMA events into the buffer */
+	cq->eq_md = ctx->cadev->cxi_map(cq->lni_ref->lni,
+			    (uintptr_t)cq->eq_buf,
+			    buf_sz, CXI_MAP_PIN | CXI_MAP_WRITE | CXI_MAP_READ,
+			    NULL);
+	if (IS_ERR(cq->eq_md)) {
+		ret = PTR_ERR(cq->eq_md);
+		cq->eq_md = NULL;
+		goto err_release;
+	}
+	cq->resources->eq_md = cq->eq_md;
+
+	/* Configure and allocate the EQ */
+	eq_attr.queue               = cq->eq_buf;
+	eq_attr.queue_len           = buf_sz;
+	eq_attr.cpu_affinity        = cpu_aff;
+	eq_attr.status_thresh_base  = 95;
+	eq_attr.status_thresh_delta = 15;
+	eq_attr.status_thresh_count = 2;
+
+	cq->eq = ctx->cadev->eq_alloc(cq->lni_ref->lni, cq->eq_md, &eq_attr,
+			      cxiverbs_eq_event_cb, cq->resources, NULL, NULL);
+	if (IS_ERR(cq->eq)) {
+		ret = PTR_ERR(cq->eq);
+		cq->eq = NULL;
+		goto err_release;
+	}
+	cq->resources->eq = cq->eq;
+
+	/* Get the doorbell CSR address for user mmap */
+	ret = ctx->cadev->eq_user_info(cq->eq, &db_phys, &db_size);
+	if (ret)
+		goto err_release;
+	cq->db_phys = db_phys;
+	cq->db_size = db_size;
+
+	/* Register mmap entry for the event ring buffer (normal pages) */
+	refcount_inc(&cq->resources->refs);
+	cq->buf_mmap = cxiverbs_mmap_entry_alloc_owned(bundle->context,
+						       false, 0, cq->pages[0], buf_sz,
+						       &resp.eq_buf_offset, cq->resources,
+						       cxiverbs_cq_resources_put);
+	if (IS_ERR(cq->buf_mmap)) {
+		ret = PTR_ERR(cq->buf_mmap);
+		cq->buf_mmap = NULL;
+		refcount_dec(&cq->resources->refs);
+		goto err_release;
+	}
+	resp.eq_buf_size = buf_sz;
+
+	/* Register mmap entry for the doorbell CSR (IO memory) */
+	refcount_inc(&cq->resources->refs);
+	cq->db_mmap = cxiverbs_mmap_entry_alloc_owned(bundle->context,
+						      true, db_phys, NULL, db_size,
+						      &resp.eq_db_offset, cq->resources,
+						      cxiverbs_cq_resources_put);
+	if (IS_ERR(cq->db_mmap)) {
+		ret = PTR_ERR(cq->db_mmap);
+		cq->db_mmap = NULL;
+		refcount_dec(&cq->resources->refs);
+		goto err_release;
+	}
+	resp.eq_db_size = db_size;
+	resp.eqn        = cq->eq->eqn;
+
+	if (udata) {
+		ret = ib_respond_udata(udata, resp);
+		if (ret)
+			goto err_release;
+	}
+
+	return 0;
+
+err_release:
+	cxiverbs_cq_release(cq);
+	return ret;
+err_put_lni:
+	cxiverbs_lni_put(cq->lni_ref);
+	return ret;
+}
+
+int cxiverbs_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
+{
+	struct cxiverbs_cq *cq = to_cxiverbs_cq(ibcq);
+
+	cxiverbs_cq_release(cq);
+	return 0;
+}
+
+/*
+ * Translate a CXI return code to an IB work completion status.
+ */
+static enum ib_wc_status cxi_rc_to_wc_status(int rc)
+{
+	switch (rc) {
+	case C_RC_OK:			return IB_WC_SUCCESS;
+	case C_RC_PERM_VIOLATION:
+	case C_RC_OP_VIOLATION:		return IB_WC_REM_ACCESS_ERR;
+	case C_RC_NO_MATCH:		return IB_WC_REM_OP_ERR;
+	case C_RC_NO_TRANSLATION:
+	case C_RC_PAGE_PERM_ERROR:	return IB_WC_LOC_PROT_ERR;
+	case C_RC_DROPPED:
+	case C_RC_UNDELIVERABLE:	return IB_WC_RETRY_EXC_ERR;
+	case C_RC_AMO_INVAL_OP_ERROR:
+	case C_RC_AMO_ALIGN_ERROR:
+	case C_RC_AMO_FP_INVALID:	return IB_WC_LOC_QP_OP_ERR;
+	default:			return IB_WC_GENERAL_ERR;
+	}
+}
+
+int cxiverbs_poll_cq(struct ib_cq *ibcq, int ne, struct ib_wc *wc)
+{
+	struct cxiverbs_cq *cq = to_cxiverbs_cq(ibcq);
+	const union c_event *ev;
+	bool consumed = false;
+	int npolled = 0;
+
+	while (npolled < ne) {
+		ev = cq->cadev->eq_get_event(cq->eq);
+		if (!ev)
+			break;
+
+		consumed = true;
+		memset(&wc[npolled], 0, sizeof(wc[npolled]));
+
+		switch (ev->hdr.event_type) {
+		case C_EVENT_SEND:
+		case C_EVENT_ACK:
+		case C_EVENT_REPLY:
+			/* Initiator completion (post_send) */
+			wc[npolled].wr_id  = ev->init_short.user_ptr;
+			wc[npolled].status = cxi_rc_to_wc_status(
+				cxi_init_event_rc(ev));
+			if (ev->hdr.event_type == C_EVENT_REPLY)
+				wc[npolled].opcode = IB_WC_RDMA_READ;
+			else
+				wc[npolled].opcode = IB_WC_SEND;
+			if (wc[npolled].status == IB_WC_SUCCESS)
+				wc[npolled].byte_len =
+					(ev->hdr.event_size == C_EVENT_SIZE_16_BYTE) ?
+					ev->init_short.mlength : 0;
+			break;
+
+		case C_EVENT_PUT:
+		case C_EVENT_GET:
+			/* Target completion (post_recv) */
+			wc[npolled].wr_id  = 0;
+			wc[npolled].status = cxi_rc_to_wc_status(
+				cxi_tgt_event_rc(ev));
+			wc[npolled].opcode = IB_WC_RECV;
+			if (wc[npolled].status == IB_WC_SUCCESS &&
+			    ev->hdr.event_size >= C_EVENT_SIZE_32_BYTE)
+				wc[npolled].byte_len = ev->tgt_short.length;
+			break;
+
+		case C_EVENT_ATOMIC:
+		case C_EVENT_FETCH_ATOMIC:
+			wc[npolled].wr_id  = ev->init_short.user_ptr;
+			wc[npolled].status = cxi_rc_to_wc_status(
+				cxi_init_event_rc(ev));
+			wc[npolled].opcode = IB_WC_FETCH_ADD;
+			break;
+
+		case C_EVENT_COMMAND_FAILURE:
+			wc[npolled].status     = IB_WC_LOC_QP_OP_ERR;
+			wc[npolled].vendor_err = ev->cmd_fail.return_code;
+			wc[npolled].opcode     = IB_WC_SEND;
+			break;
+
+		default:
+			/* Administrative / unknown event: consume and skip */
+			continue;
+		}
+
+		npolled++;
+	}
+
+	if (consumed)
+		cxi_eq_ack_events(cq->eq);
+
+	return npolled;
+}
+
+int cxiverbs_req_notify_cq(struct ib_cq *ibcq, enum ib_cq_notify_flags flags)
+{
+	/*
+	 * The EQ interrupt is wired via event_cb in create_cq; the RDMA core
+	 * will re-check the queue after arming.  Always report success.
+	 */
+	return 0;
+}
+
+/* =======================================================================
+ * Phase 3: mmap  —  map EQ ring buffer and doorbell to user space
+ * =======================================================================
+ */
+
+int cxiverbs_mmap(struct ib_ucontext *ibctx, struct vm_area_struct *vma)
+{
+	struct rdma_user_mmap_entry *rdma_entry;
+	struct cxiverbs_mmap_entry *ent;
+	unsigned long size = vma->vm_end - vma->vm_start;
+	int ret;
+
+	rdma_entry = rdma_user_mmap_entry_get(ibctx, vma);
+	if (!rdma_entry)
+		return -EINVAL;
+
+	ent = container_of(rdma_entry, struct cxiverbs_mmap_entry, rdma_entry);
+
+	if (ent->admin_only && !capable(CAP_SYS_ADMIN)) {
+		ret = -EPERM;
+		goto out;
+	}
+
+	if (ent->is_io) {
+		/* Doorbell CSR: uncached IO mapping */
+		ret = rdma_user_mmap_io(ibctx, vma,
+					ent->phys >> PAGE_SHIFT,
+					size,
+					pgprot_noncached(vma->vm_page_prot),
+					rdma_entry);
+	} else {
+		/* Ring buffer: normal page mapping */
+		ret = rdma_user_mmap_io(ibctx, vma,
+					page_to_pfn(ent->first_page), size,
+					vma->vm_page_prot, rdma_entry);
+	}
+
+out:
+	rdma_user_mmap_entry_put(rdma_entry);
+	return ret;
+}
+
+void cxiverbs_mmap_free(struct rdma_user_mmap_entry *rdma_entry)
+{
+	struct cxiverbs_mmap_entry *ent =
+		container_of(rdma_entry, struct cxiverbs_mmap_entry, rdma_entry);
+	if (ent->release_owner)
+		ent->release_owner(ent->owner);
+	kfree(ent);
+}
+
+/* =======================================================================
+ * Phase 5: Address handle  —  NID resolution from GID
+ * =======================================================================
+ */
+
+/*
+ * Extract the Cassini NID from a GID. Anything set outside CXI_IBV_NID_MASK
+ * belongs to some other fabric's addressing, so reject it rather than
+ * truncating it into a NID that names a different node.
+ */
+static int cxi_gid_to_nid(const union ib_gid *gid, u32 *nid)
+{
+	u64 id = be64_to_cpu(gid->global.interface_id);
+
+	if (gid->global.subnet_prefix || (id & ~CXI_IBV_NID_MASK))
+		return -EINVAL;
+
+	*nid = (u32)id;
+	return 0;
+}
+
+int cxiverbs_create_ah(struct ib_ah *ibah, struct rdma_ah_init_attr *init_attr,
+		      struct ib_udata *udata)
+{
+	struct cxiverbs_ah *ah             = to_cxiverbs_ah(ibah);
+	const struct rdma_ah_attr *attr  = init_attr->ah_attr;
+	const struct ib_global_route *grh = rdma_ah_read_grh(attr);
+	int ret;
+
+	if (!grh)
+		return -EINVAL;
+
+	ret = cxi_gid_to_nid(&grh->dgid, &ah->nid);
+	if (ret)
+		return ret;
+
+	ah->dscp = rdma_ah_get_sl(attr); /* SL used as DSCP / TC class index */
+	ah->vni  = 0;                    /* resolved from QP at post_send time */
+	return 0;
+}
+
+int cxiverbs_destroy_ah(struct ib_ah *ibah, u32 flags)
+{
+	/* Nothing to free; struct is embedded in the slab allocation */
+	return 0;
+}
+
+int cxiverbs_add_gid(const struct ib_gid_attr *attr, void **context)
+{
+	/* Accept any GID; no hardware GID table maintenance at this layer */
+	return 0;
+}
+
+int cxiverbs_del_gid(const struct ib_gid_attr *attr, void **context)
+{
+	return 0;
+}

-- 
2.56.0

