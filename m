Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794146456;
	b=4HNC1jL5AusVjrj60edFRCrLQoDBmvtu/zVAUoZMOXIOTCDne288OLF1fjrNsf5NFCAJ
	 pVx1OGdm/pGbGXjRQWz3esQUANQMYVsxtkWhinGEM0X7F+qwzsQHDjvW3OCVIwH9+5Xq+
	 DlxSr3zNTlKfF5qWIPU0nLSlhI+OxAXeyKfUoxXG9WSFrAsKs5YvByHCjHG6C4CaWMRyP
	 e90FUNHw5yuOFRc9T4t8tUlaMPylmH6gvemr0iWzUIPH6qDxt+zlC7GwWXEUo8psogB16
	 Nh8mVDVpUBKYPe0R7OtetUmPFrqU7sZYQoessRosJU3MEILdizBq4WQvWEk78CII5hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794146456;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:To:Cc:References:Subject:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=kXk+gUbs8YL1AEpHZQuaMkYpmitFgawjbvaFKvsibII=;
	b=Ip+iPdz2SfS7JD6VLQnQ9nV+qAnnFRwiS/y6mSlcM7gSyXjgv4CBczyZGac76SBbn+la
	 HSB+q3PuUdgpWZtrME0KiQGRqVYoRDrq9cLwx6/lMVMc2b4t4Z3DgOqRvCOnBVRGhtWMT
	 ZtYu6bgzaEgIlMKN2Az5yqjSREB0o0GdTvXOb7pawRnbQIynne6Xm+hOX2J0hFs2fXviY
	 z+puLkq5DQab1fHcAWi7IIqJyeQfYHFsM0Fo+lBkd5CV/iiL9q9wciMkRE/2VweBcjAHw
	 U1uSdraoqIVEUHTzlg9AG7AZj6akPmJb4+z2msEoMvabtzDl+1Pq6w0/aLB5ePsrHBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=web.de;
	spf=pass smtp.mailfrom=web.de;
	dkim=pass header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=IOZJ8xP5;
	arc=none smtp.remote-ip=212.227.15.3
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F966606A31C;
	Sun,  8 Nov 2026 14:00:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0F966606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=IOZJ8xP5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1794146446; x=1794751246; i=markus.elfring@web.de;
	bh=kXk+gUbs8YL1AEpHZQuaMkYpmitFgawjbvaFKvsibII=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=IOZJ8xP5TE9Tys9krpKXdk31WnH/r/eIUQk3e9ii+oQACQ1itVeLBRV6dkG6DVm2
	 /bfCSsrp1g+CIigghqL/eT/siDoUE2llFKcs2JtyvccW5P/8hijpaB6DtxB4uLMYU
	 QCDOfMoSiPBspzMOESwYk2hdkWM+i/O2QFD0oRVnUSF7lBFcp9u0q06ZzlzxaHdJ9
	 S4G2kyWE4TYh+CjrbazAGh596iF/xxSuF6pEsB68UtdVwXm/YlzPJh+2TuTSRBc9A
	 To1A5LGM0goUbXB13nkK/oDGaJ+zR/dfWJUaB1oYCvidT7jklUY8RHIpgVwmvWgpj
	 ZFbSde4AzWWbYptOrQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MOUxu-1x80Uy0B0o-00PpXH; Sun, 08
 Nov 2026 15:00:46 +0100
Message-ID: <ae14012f-a516-4a3e-84ab-d5f3ddbffa1f@web.de>
Date: Sun, 8 Nov 2026 15:00:31 +0100
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: vulab@iscas.ac.cn, netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>,
 Mark Bloch <mbloch@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20261108132100.315011-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH v2] net/mlx5e: TC, fix internal port leak when a flow is
 reoffloaded
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261108132100.315011-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:M75IMMv+g5VvPCyoBzAJ5kckcBhtCPkxVnLvG5bcY5jpUGK/LmC
 mx8ot6neEka0sYq7GjX8EFip+Nb8j/BXcNBE5x7vAiCzjWLqpORNmYpQC8kZe0kzSOkgDRS
 NXCQl/0oJUjmFoC9RCcxzc4MUC83V+utt+NOa1uLVaYQ6ZoLNZ+oHWDTur1OZdJ63/vsE14
 zeV8CpmObLX38g8hNfCCQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:R+RzXk2RbTA=;MX6ZepcF5yunRKwCQod7IlyQNc4
 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
 F3wlT

=E2=80=A6
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>

Is there a need to reconsider also the mail address identifier once more?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.4-rc1#n396

Regards,
Markus
