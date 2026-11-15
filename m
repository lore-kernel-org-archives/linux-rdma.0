Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746076;
	b=TtIHddzlCLG7V3CUk2gyOdzi/O/1N3gZ0RdL3k82AQKlWaSajecsUyZNiUHKvsWa0h8o
	 s+M9SrVdWssjuQ95eXVhMKPTc7ws93pOXMF7R06QQm6i6ksHYk9OmkAZLbhTXRlBtWp9v
	 XWCT/luBL6bx8BljaGnsXAQKsn2NpyWLN7ewtymz5rkUvTuZrfaa2u8VHxiwG8ZNK1Wv8
	 fMVyKUrMCz9IZ/e1bP9Mtl1le9pRnS9aLLo0ZEYyrZb0ORLl0WZa6QhOtbijB3hlr1Ikz
	 Gl1mJGmMnKHt7HQO00H6321/YEzb1tjq/V8tBw4q0dd3GXnv7/iuHE1tZvEClsUE2cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746076;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=6ZuGypfKU9M/I1I0dsVF8O1vxsEDxzcGg61IEASb7d0=;
	b=mLeuww6zxiN26KJVKtrszuIXpIGa0CkchfF+ijyhzWPrGC1glm4DTLG9euruEibMEC4U
	 eRr8C4S5AO9dIEZz/bi+29IQv4ryBWQQFi4zr//3bNW19QAzLGyQ6h/dMV0NPw3pr1cvs
	 C+CRHOhSR7Ibxww3xrRzsGdTzm9sYofPSOUxhdNSg+7W/pyyns1Sql6OtwKp/inzxS3L2
	 rT9e7Rnm19/+EokDwY4zarJemrBxkqofHbWTJCZSoYWUdlEBJleQgfC74uDyHmb6yhkOZ
	 l1zHdjRawibr5L4aR7QUkzLC81LH241KKlA8O2JtuSTkYyjGwjq+MXgbsd4TXjRhFkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=UgJZpXmr;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A802606A89B;
	Sun, 15 Nov 2026 12:34:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0A802606A89B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=UgJZpXmr
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5DB3C20B716B;
	Sun, 15 Nov 2026 04:34:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5DB3C20B716B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794746065;
	bh=6ZuGypfKU9M/I1I0dsVF8O1vxsEDxzcGg61IEASb7d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgJZpXmrNgfxqgAWIpsCELQYaavhVxvzxkyN54/GZANktDuqlxdidvxDEMjVwJlUt
	 gWEJAgpLFS+rclqadtF0Jf0ITsvZAtix49KcsyFO116aF8FMgxmzGXy+6Ev4etHDbU
	 ZmtwwPkXgvsi3OHn4wQ12hl4CtdJ+q4FLrBjFbcc=
From: Wei Hu <weh@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: Re: [PATCH net-next v10 4/4] net: mana: add dynamic HWC queue depth with reinit path
Date: Sun, 15 Nov 2026 12:34:13 +0000
Message-ID: <179457550423.109246.1861974882571766890.hwc-v10-all-reviews-p4@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179455240227.2199510.2666165032389090040@kernel.org>
References: <aa4e08e8bc9a7139778b11875e41921d2d813712.1794208055.git.weh@linux.microsoft.com>  <179455240227.2199510.2666165032389090040@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Thanks for the review.=0D
=0D
> Which direction does the PF mean by HWC_INIT_DATA_MAX_REQUEST?=0D
=0D
The driver uses MAX_REQUEST for the RQ and MAX_RESPONSE for the SQ, and=0D
the host-to-PF request budget follows the SQ. That allocation convention=0D
already exists in mana_hwc_init_queues(). The new mapping is also stated=0D
explicitly in mana_hwc_finish_channel() and the request-budget helper.=0D
=0D
I agree that the names alone are not sufficient protocol documentation.=0D
However, the suggested opposite interpretation is not established by the=0D
review either. A protocol reference defining the PF's directional meaning=0D
would be needed before concluding that these limits are reversed.=0D
=0D
I plan to preserve the mapping, not swap the fields or impose the minimum=0D
of both directions on that assumption. The latter could reject valid=0D
asymmetric traffic. I will clarify the existing RQ/SQ convention in the=0D
description without claiming a new firmware guarantee.=0D
=0D
> How does the PF learn the ring sizes of the rebuilt channel?=0D
=0D
The PF specifies the HWC queue depth and corresponding ring sizes. It=0D
reports the required depth via HWC_INIT_DATA_QUEUE_DEPTH, and the VF=0D
rebuilds the rings to implement that PF requirement.=0D
=0D
The PF therefore already knows the required geometry; the absence of size=0D
fields in ESTABLISH_HWC does not mean that it must keep assuming bootstrap=
=0D
sizes. I plan to keep the sizing protocol unchanged and make this PF-driven=
=0D
contract explicit in the description.=0D
=0D
> Can a PF that leaves out any of these HWC_INIT_DATA types, or reports 0,=
=0D
> still bring up the HWC? It looks like HWC creation now fails with -EPROTO=
=0D
> even in the depth-1 setup that used to work, with no fallback.=0D
=0D
The new nonzero-report validation does apply before the decision to keep=0D
the bootstrap queues, and to the restored bootstrap report. I will=0D
document that behavior and its -EPROTO result explicitly in the message.=0D
=0D
That documentation omission is a small follow-up. It does not establish=0D
that absent or zero maxima are valid PF reports. I will not add a fallback=
=0D
to guessed limits without that contract.=0D
=0D
> This isn't a bug in the new code, but this check fixes an existing=0D
> out-of-bounds MMIO write, together with the INVALID_DOORBELL early return=
=0D
> added to mana_gd_ring_doorbell().=0D
=0D
Agreed that this also hardens a baseline path. I checked the original=0D
driver's unchecked doorbell assignment and MMIO address calculation. I=0D
will make the existing bug and applicable Fixes lineage explicit for=0D
dependency-aware backports. This is a metadata clarification, not another=0D
MMIO behavior change or a wholesale split of the feature series.=0D
=0D
Regards,=0D
Wei=0D
