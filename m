Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869865;
	b=KBEuCLDtsKGhIerC2yJ8ySQJVHKXQnwWgUi+P2QmNM6vg5zkVl3FTOllp6s0y041WYxJ
	 g1PtTH7GymkGfpYq74sVEkor4B0chm28XQMKzaQY4iV6Sivbfl8QrYD4fcwJJF/xxHbde
	 lUXVLz/ia4jrnNQtSgFx8gb0dfTF0V2aq/j/1AqTuLsoNApyuIOu1wCmpfAC2vPz4DBIU
	 IWYJU0Cmn9UOtZa8YV+NtnvynFkxKFWE7RAi4wRVZVmJmihVQQnpKGaGeJ1//APj2GUwy
	 AN+44qRl5Rjv75taoS8mFDqmIvs2rgwAjjnmCxldFrkxTERz2TBH3dV2j45n/FMX/CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869865;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=4+ZqNO1Uua075MEzu4+jAJNvV66dGvERxAz2lyx10y0=;
	b=EQALqiyayuNBmTN8boV2HNCCcGDn1wX9aBq5dBBqGICGt4N9Q3XzK/alKNJDfkDVnA/o
	 LhF5SyqE5OW92ENGg9xVRuwgsTWrXwF7saxWOAcMKogmXivxdUYYJXPAjxH+8j0DdJDbU
	 t4WZVMINKSHfAf+g1v86iMbjkLNtbHDfMX//Tg7pxVuBPr5wa3o8wGocIiGhfF9Hx/4Be
	 i87zIFgQVSD9p6OmAeshNToxaFtD98ZVir7Dxh85bFOpA8NMStYw8Vi+T3ySCcLVC/6Ll
	 Sn/t8k/SZeC4OgVqm4vcoWHdNnX1GduOPxJwK3v+kf7WqvD2hDVcfeZbj3bZQx21tgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UUyuMllB;
	arc=none smtp.remote-ip=74.125.224.99
Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D147606A328
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 09:11:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D147606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=UUyuMllB
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-67be5d0e9cbso1261704d50.3
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:11:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869864; x=1794474664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4+ZqNO1Uua075MEzu4+jAJNvV66dGvERxAz2lyx10y0=;
        b=zSy6XOXDDfhyHDVlXHkqegnwOoMXGszPqLjaIBfYMtbopj+4IzQISIc8i9uVpJEozJ
         6CgxfS1APLTzlK5mUviMgNC/VYG3BtDzP5/E9Nwth5FW8A7d0yPLEWgvmsRiIhcrrDLF
         e7xUEji3NysF2Hg8aHClmtoTHq7JatYJ3gk08LaBBI+8jjpe14gnh7XgTWUD2SL1Y5HG
         FkTMyECwBoYHbe8knp5FbSyqUjdETY1X1xRs5mxQAmaq0Pr+j5kNvEapwsREPTKla6Dn
         QfgkJcmwOw6lvmZmnHVVYoeusn1laz0whcmaNRD1aeDtgUqqJTfOjhMcRsGfhdOcf6YJ
         tIDQ==
X-Forwarded-Encrypted: i=1; AKwUvBw6ttHoS25ejGZOMrGv2Jp9gXJ5gUV0WDOjLoZSN6jNa+hRCQLUPnG1bEJernsflH9xN8xxKT/TO9le@vger.kernel.org
X-Gm-Message-State: APuU4Z/+9nrHQfTHFZICKQH7YSXflmYInTU08aJMEW0jL6f8BtwU3x2U
	TTOm0Vs2/T+tOZpLvjKef2GEtlxFVq3uPfhf3SK2AcLoF6SVuZ7HlM2EZI4FKOOeLszOrVxIGG9
	i6Or23f/HyCHjdWGtsGomuEcR8C2Nai+azF+PVraHnyWefMpQptx8BadsZ2vl8IPIYni8w2cHlu
	PSj9m8ST+v1fE9OFzIXC12AIHD8iVSzDATXTxa0uKXL8TrVhmy8XXxjMnYn7FO5Eoe1fUI3KubB
	6SRxCEoyaNN+H+w9A==
X-Gm-Gg: AYBFou1WXYJpcl2c+2Z5qVe2oEcf+0/9lREOGBLdGQFstSKAyPn1AY/5TZ9UOCKlgch
	0aFtz+xLeHkMnrf/5FOIy1cMmaZnvlMisPQe9ZRFoNTPRcbcVpxkV2tcbk9mrlhcL9zQl5XEUjw
	S9wHzX1+LS4j9EXEml4gCrc9kT2er7ZWde9JnGJrP7k7IkFt+Mj4K/XDH5+dydrKFP7bQNe0hxK
	L4M7M1TxEgrKBm7GH8k80yt4/tWnZCFa7/A34BOxb64h9RdXHuH1qz0bPF7ksptzm1ZTMHX7bVf
	O1f7Bn3NIqhPLjisX8HQflqOVdLYLPch1xhhmTB0q6GZ7K8pkKOJwLsMVBsjXbRrv+c9/rxYJNy
	YVqqNt6a5eRohaV7PmcbccLGbPj8dQ1FE9/1TSUkl42GWf1J0FVdPRy63TeOA3S11QZ1MS4MrBE
	zZMQ2RA0o8/qjcc8dYr5rW0To1lHYlp3OTHA==
X-Received: by 2002:a05:690e:134a:b0:67c:50d:aab1 with SMTP id 956f58d0204a3-67c050dacf1mr899912d50.28.1793869863913;
        Thu, 05 Nov 2026 01:11:03 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-67bee248a75sm56267d50.43.2026.11.05.01.11.03
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:11:03 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53664911d46so44997261cf.3
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793869863; x=1794474663; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4+ZqNO1Uua075MEzu4+jAJNvV66dGvERxAz2lyx10y0=;
        b=UUyuMllBWNBMjTXRRyz6Qq4H52mR0Hs6nSMXb+lB8GRVNLKQMVBrig3wiG9HGZoBe3
         Dq4PcCK4y39gG88HV2JIJ6BdIEqra5PL/gfz5nmgW5pzEQ5k4KFkjLlDUpFMgt9TcMyG
         bQTdkTSUeB4ashXuB8cm5+i30COn54ZyzFqK0=
X-Forwarded-Encrypted: i=1; AKwUvBw/lW9VPXOvDim95Mu/eFPuXwgbb1uHAIzlx7DMpnWgvREuVm4i1cf4KuY0mhcKCfvCkICBekyyKhzW@vger.kernel.org
X-Received: by 2002:a05:622a:1a97:b0:537:b9f5:e05 with SMTP id d75a77b69052e-542b82fa50fmr318543351cf.69.1793869863157;
        Thu, 05 Nov 2026 01:11:03 -0800 (PST)
X-Received: by 2002:a05:622a:1a97:b0:537:b9f5:e05 with SMTP id d75a77b69052e-542b82fa50fmr318543191cf.69.1793869862721;
        Thu, 05 Nov 2026 01:11:02 -0800 (PST)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100af507sm47298591cf.6.2026.11.05.01.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:11:02 -0800 (PST)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	vikas.gupta@broadcom.com,
	ajit.khaparde@broadcom.com,
	dharmender.garg@broadcom.com,
	sachin.holla@broadcom.com,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [net-next v3 0/3] bnge changes for RoCE driver
Date: Thu,  5 Nov 2026 01:01:51 -0800
Message-ID: <20261105090154.1293846-1-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add bnge specific changes needed for RoCE MPC channel
support.

v2->v3:
- Addressed Shasiko review comments

v1->v2:
- Created pull request for RoCE MPC channel changes
  of bnge driver 
- Addressed Shasiko review comments

The following are changes since
commit 05441d697f7f ("Merge tag 'cocci-7.4-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/jlawall/linux")
   Merge tag 'for_linus' in Linus's tree
and are available in the git repository at:
  https://github.com/siva-kallam/linux bnge-roce-v3
for you to fetch changes up to
commit d60317882851 ("bnge: Reserve ring resources for
upcoming RoCE MPC support")

Sachin Holla (1):
  bnge: Reserve ring resources for upcoming RoCE MPC support

Saswati Das (2):
  bnge: Pass BAR1 doorbell mapping to RoCE auxiliary device
  bnge: Update HSI

 .../net/ethernet/broadcom/bnge/bnge_auxr.c    |   1 +
 .../net/ethernet/broadcom/bnge/bnge_auxr.h    |   1 +
 .../net/ethernet/broadcom/bnge/bnge_core.c    |   9 +
 .../ethernet/broadcom/bnge/bnge_hwrm_lib.c    |   3 +-
 .../net/ethernet/broadcom/bnge/bnge_resc.c    |  56 +++++-
 include/linux/bnge/hsi.h                      | 161 ++++++++++++++++++
 6 files changed, 224 insertions(+), 7 deletions(-)

-- 
2.43.5

