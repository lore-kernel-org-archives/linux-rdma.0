Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85461C5F39;
	Thu, 14 May 2026 04:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778731321; cv=none; b=OmXLik8jI/IT3uQ9JCnkshzRLUTf0wyy8KvT/sEVFb0YnssZK3s2Ys6MP8LOSWrA1z5vsBpWNxSRR8fulPDTW6Xb2LirG3PmrsJMCXAJX/Jw/SYO8MJdmB4kpyGDxlnzx5JDwcrI49J8bsWFz7rDjU2OS/7yCYhgQ6hVOrjN4aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778731321; c=relaxed/simple;
	bh=Bbd8vVJZ//2NwMfFOZRBsondqAGpGgNOkGf6QSlDmQg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZXhCNU+wnpnCBg18kmM2N/3qLoB+u8nnl7trX0G5EqwxYYlt+9nwP2oemLWUhzj9yAggr0eR52x8l9q0DKef9WxpctoYDvmIjClqWBvlwm7EQ42l2PeulunhqdInlf4WAdumASgRMHs+3Wa637sAWJ42z2M2QSp4E+yhy0TN5wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=YSjOyI+S; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="YSjOyI+S"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64E3YS1b2086277;
	Wed, 13 May 2026 21:01:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=GCnA6WGm9jg8+3FQG6v3NQ+Px
	L2x+wKdPqqnK6ebDew=; b=YSjOyI+S/SUCNCPchdyWkTkADGtkdkF/SZqgvQuzj
	gwcc1WxNDCHrxz3UB4UgwCojrUp+MthFUPTsJkZAO4YSA1ooFBQtCEHGf4/6mfIV
	nusyaExCIgOqW6kg9UN5Ix2Ae+oHpjFcZzl+OKy5dkS1U1wUKGKGMXJWC+6uTcX0
	/lw/qKWBgGGgTq45pV4eIwrn5t8z4J4XKcD1bLbgLJX99NzBJqD243ThaJWSqOXb
	8TqZnsnXfbOvksz4FSxyIe4ooZhYPdtjQ4YIENvpgYOW0dEx8Y3oXDYHk8dLl+WT
	YO9SLen24m7Cv+KL4yzibC7Z49WZ09F8ohLGbc+Uwde6w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4e46epwh18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 May 2026 21:01:20 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 May 2026 21:01:20 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 13 May 2026 21:01:20 -0700
Received: from rkannoth-OptiPlex-7090 (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with SMTP id 24A905B6938;
	Wed, 13 May 2026 21:01:11 -0700 (PDT)
Date: Thu, 14 May 2026 09:31:11 +0530
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <oss-drivers@corigine.com>
CC: <akiyano@amazon.com>, <andrew+netdev@lunn.ch>,
        <anthony.l.nguyen@intel.com>, <arkadiusz.kubalewski@intel.com>,
        <brett.creeley@amd.com>, <darinzon@amazon.com>, <davem@davemloft.net>,
        <donald.hunter@gmail.com>, <edumazet@google.com>, <horms@kernel.org>,
        <idosch@nvidia.com>, <ivecera@redhat.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <leon@kernel.org>, <mbloch@nvidia.com>,
        <michael.chan@broadcom.com>, <pabeni@redhat.com>,
        <pavan.chebbi@broadcom.com>, <petrm@nvidia.com>,
        <Prathosh.Satish@microchip.com>, <przemyslaw.kitszel@intel.com>,
        <saeedm@nvidia.com>, <sgoutham@marvell.com>, <tariqt@nvidia.com>,
        <vadim.fedorenko@linux.dev>
Subject: Re: [PATCH v13 net-next 5/9] octeontx2-af: npc: cn20k: add subbank
 search order control
Message-ID: <agVJBxNJqFDm3nBu@rkannoth-OptiPlex-7090>
References: <20260511033923.1301976-1-rkannoth@marvell.com>
 <20260511033923.1301976-6-rkannoth@marvell.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260511033923.1301976-6-rkannoth@marvell.com>
X-Proofpoint-GUID: FfH5CAQjK4KUNmEGv9ZGR13aw_2HGVC7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE0MDAzNiBTYWx0ZWRfX/d2FC9q3maQc
 1Tekz3zonlDXEA/eUb2r3kJrQ3qvwi9Qfv2DgecvjbfjexPiyU1FHL1VrZ67csX+MrFiSfNVIAR
 mpercSOjeO+H/m4k965wqAQihWl/IdXcsPuIIWC284M7j0uFF++O/Y6za0m6QCeC+Mrt7HblSrQ
 /n8qnTmAAzjYKncdpV64kNFRdOmI11REtSoqmj/nfCDUVF/9szBcRaR9cbExDlwDpqs1CB7ug02
 0XpCnQ+tml8K8z3M7fwdnwBIfPcQTzKwYIZiKXzF8AKk6VNsD5bfwa3CiNRb/oBLZeSdOxLISuE
 vYEX8bIhbcLeHpmXmWRUmqmQWTxDER1s7q5H4ePaRSz/lovP0rsdlRMDHzr7XW0anv2X26MPdcv
 SilmubvQn7fPUlacv4vhXbkkSsxed+ic1P6UWmsskOrSjEPITh2A+i1LGetpV1LCwkS+X4JjYR+
 VGWTRkzjGu7yDK+4ehQ==
X-Authority-Analysis: v=2.4 cv=ApDeGu9P c=1 sm=1 tr=0 ts=6a054910 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l0iWHRpgs5sLHlkKQ1IR:22 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8
 a=osvtW2FR3m6xqmOo2_wA:9 a=CjuIK1q_8ugA:10 a=OBjm3rFKGHvpk9ecZwUJ:22
 a=Oh551-UHZqmTy8JkqTUo:22
X-Proofpoint-ORIG-GUID: FfH5CAQjK4KUNmEGv9ZGR13aw_2HGVC7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-14_01,2026-05-13_01,2025-10-01_01

On 2026-05-11 at 09:09:19, Ratheesh Kannoth (rkannoth@marvell.com) wrote:
> CN20K NPC MCAM is split into 32 subbanks that are searched in a
> predefined order during allocation. Lower-numbered subbanks have
> higher priority than higher-numbered ones.
>

>> +		if (rc) {
>> +			dev_err(rvu->dev,
>> +				"Setting arr_idx=%d for sb=%d failed\n",
>> +				sb->arr_idx, sb_idx);
>> +			goto fail;
>If xa_store() fails here, is there a risk of permanently corrupting the
>allocator state?
>If a failure occurs mid-loop, the function jumps to fail and returns without
>rolling back the applied changes. The subbanks processed before the failure
>retain their new arr_idx values and new XArray mappings, while the remaining
>subbanks retain their old configurations.
>Additionally, the global subbank_srch_order array is left un-updated,
>completely desynchronizing it from the XArrays. This leaves overlapping
>and missing subbank indices that could cause subsequent MCAM allocations
>to fail or corrupt hardware state.
There is no way we can rollback as rollback may also fail due to memory pressure.
So returning error in these cases.
