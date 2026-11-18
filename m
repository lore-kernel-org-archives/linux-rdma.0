Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036591;
	b=mwgVM3T13cG3YYdWo4oNPoB4KGeE3BFgxdkLVWohOWthMsIgbobS3NaDcMDDLrT5igZh
	 T2Kx4NBLg0w3+Rkz7/S14CC3dgqJiuiHmZTUImaAQcjQbfWjYTfv/vbNf8Z3yCRwXFL5R
	 0dXuRoiYaHleV5H9PrNZJhl/WxxCv4xWwNHwKWdOmsa1Y7I5ySNO7bI6UORVoqIoWKGxc
	 CnBWXqgTseIcILhSyNgsU1i5GOo5CXOMbs+0ivu6zmbn8KUFrLh7Zy3O0Pw8Wqqe8pPBq
	 zs5hwHApQNpyDH7QfTXT4GctxnCUypa9Yzf0olwhxqyp5hcJhGrYMRhMI9LH97V0S6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
	b=QocjJSre0P7hZSDZgN3K9cGoGQmmjq1Kqug/eL8PmMHjMevgH5sszGRMcM6CyaW9FyEv
	 4sJw2URONB5BgqIjkExx1fERn8o9AQTRiU2sjZzhyh7k+8ruywSd/sPcXixE/Hz3/VChd
	 DDmOkDjnCk+6rG1p2pbS9qfHiirnHat6ptVthFWtzIzEasDvfDeC0SS5/ooWSyBeNxRMG
	 jPRELBk8lI1r28BK5/fnPx7CfUXfB3S5S9V8igIlrrZeXNPfNI2nfpkGs2GFDZ7UtJgu9
	 Oak3+PBCS/rRhdlxODeUj70ZYSkSDOjH9PN4f+5BZ9xcmdVIG2IkEosx4bbXHkTQ7Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tAKIDOon;
	arc=none smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A94D606A338
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 21:16:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4A94D606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=tAKIDOon
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so932939b3a.2
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795036591; x=1795641391; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
        b=tAKIDOonM/7tAl+OKNOFPyXrRjlTvzxrmWiMXNZVhliT++H88DRZp4VsIUQSlAau47
         6Spe9kGkx/9/L36JcBVgrovt+2ZIS4Cr6mD4O+TqZXkb+Fs8d3BHkVFjNRYauw6KUOLW
         pdZMZkVm1dlo/rRzE7QAqZrltbbI/Gm+XgjCCSuf3kb6HHmDw61HbQhBPAfAaLim7kcd
         KHhTUjMGyljf1cYXetfpnx+xFF8C6Hzq5WQIa6scbKxA9JGH3dzX3M6mnJbWax5CbQgl
         rVV82iAcZE4+QNEKxL/Fr+9TjwXagcNwTZIGgDnvPrebuhix9W35IoBv55MqzEQgj6nh
         xwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795036591; x=1795641391;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y/YHJ2V7TLyLaA0CfPasf19cYxUxIPcmQV6VRFoc+cI=;
        b=vkRmQAoBM199ZMRSEQ9cM+sLHGypeKyZlW8BUkF92WXI9/f0SrBXGf6R54uYTIbWD5
         ybaTQEFD4QXc95YSoTuqqCaD9V79tC4Rl+SgNd7p5+UBHM6ASNkTiq5TyKqbu5z5FHY1
         4Wc6QqQYZGeC+Srkf69hmmJPFjPt2Z036GzDxpsZIvKRPoCML4xvyvYpIhvI/CKBViVF
         XlcdvcOwhnZH+uKSjXzAFjX/fXVuT57E65PUs+L8jLOkDk10w9tm+0ZuBU6Of0ycsy/b
         wgnxIOfYwRHvXuOXX7yPvsWYjdAj09gK9zJs/ki4gEoutJv6njC2gweayqx8yEjN44HL
         gUYw==
X-Gm-Message-State: APuU4Z8Q/stjZ+Zj5jqBYLkIz5/G7NHgAExf7u3BSjTaZVy8pr6ABJX1
	DpZe68b9TRSTUmxwoTb//wPI7wgTu3sYZa4YyqEMtEjlp7Ex4tFEhdEsQIkDB7TXAtE=
X-Gm-Gg: AZFdTZc2Of8BvkwMfAzfcmTdLDZoHPL17Y7YTF0NAgZO+/qUWbJtcuAYQN0CJ+BhwIc
	0T3jcXLMSvAYnBcrGjc9BM5KKJe2FI8tk6j4ROIBsg+WQ3rX9X/5BqIVa+kiD0/FWE9vdQxlFWF
	eKqdZgAx1eYz3SKALD9tChQgEqEcIJOrG5lU88Ny41tf4p5B8sSygVpMtFlotxV85U3impMzzsH
	Muu/Gzsa1J/su1RQcWH2fKW5788yz5DLHgDhLH0WjQiNZeZ+qfq3WF6nomZuyfcbJrZa5AAO+3q
	C6CPmRHI7vkPgCdWG3E2ahw02ojBPZWA2A0m3Zi0D988fyEdKkE/jclv/XkpXquWX+eV+/nDtFf
	o4IoI8abGHX8r0qbSEm3y8ctPlsTYP8aMSw6cVyLd4qebVFW+oNV1Fe9w3UzLpzody5CwM8wXeD
	2EoTT80VI6HOPdG3BekoT6Ec+vgHFlccQDnRXbwQgcsWAZJ9mzWcrfhTb+YQUELkWMQRYi6jF8H
	x6yG2JRq6oklDcbc5ZLV0VdhRXJGw5N/IohW2P7Znp+5yNtqT3ELmywHg5Y7I1gHhKMduMFM68l
	QwIou03X8RjqwDE7dQeayPpjbMS7y+bhCvnEJaLlk3xTUP2uAB3/TZ/4Ui3XH5sExQPoGbEeMu2
	+XZtFm1h+/ZhlO/SKElugsd1STaNwoDzx42Isrw==
X-Received: by 2002:a17:90b:5307:b0:3a8:545a:9e87 with SMTP id 98e67ed59e1d1-3b3d0759881mr3709135a91.15.1795036590739;
        Wed, 18 Nov 2026 13:16:30 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:e78e:f7f0:2120:34e7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f706dd83sm914903a91.14.2026.11.18.13.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 13:16:30 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sagi@grimberg.me,
	jgg@ziepe.ca,
	leon@kernel.org,
	mkp@kernel.org
Cc: linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] isert: the commands the target core allocates itself
Date: Thu, 19 Nov 2026 06:16:23 +0900
Message-ID: <20261118211623.2526894-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
References: <20261118113905.2361969-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v3:
  https://lore.kernel.org/all/20261118211503.2526705-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
