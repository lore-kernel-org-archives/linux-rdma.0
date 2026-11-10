Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794279689;
	b=UesUf/qwQNCAIJQa0IXzbZ6TF37ImwVEeL7PZLTnK246EchHFDLcHfiExM1s8lQ0nAsi
	 amvX3TzmY46MWIG7gIK4uzHUjlapqoVCOiVV6NF7upKwhF8xTFJCRLH4vtt9RsJgQFc/v
	 legB0edc93TTq6/NvzJ9rEdFvOgLdWV1SjupVwx7jEqhrc/48SrVEfFvF9Rq/DclrTlM2
	 OIFXRo7P4TZcS5KWbjGzgt3L9yNVIL/xryf4SxaWVMxJeyQMAAcfT4B/LSlv8V2/lPahI
	 +F2ValAZ8zfqkbgalPHNgPyskFri4MXwkyo7YYAfXmOkbV7RCE2NK9+W/RgfmOvrsDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794279689;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=p/ReStnRc9OUunfFdndowEQFizV364wmOLTYwIJ5Z90=;
	b=HIKiwJrPCESr1LMoU1VCVLML3nOCr2tQWba5SZW5yp59B4MnuBFH31Ib+Vw5B3rRkjAT
	 bNuFEDLFSgno6e7TMbwxROSRPe7YIOHCJ1/S8GYwRMz2ertqk5k2hXDW49sb59TF2JGou
	 iQWfhmFlnI1tY20zOQHAClJBbdJSt1XHsCndxpCUQXNXRQSjJZuSYwXOpxowhOuR0Rdmf
	 bUdce+TEggvbDxWzUuHeH6ZWKISt0Hucok0tqcbZ04ItbQMAK6qD6DuAQTwbhXR1vjLxh
	 NZS0uGAAntwdkMRWoZmpXoBuT/JycbPFsmFXuA2/8Is2LVsPC3HdIzTZwlqQGbp5D2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="jgczV0W/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4D8606A33E;
	Tue, 10 Nov 2026 03:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jgczV0W/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CF71F008A5;
	Tue, 10 Nov 2026 03:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794279688;
	bh=p/ReStnRc9OUunfFdndowEQFizV364wmOLTYwIJ5Z90=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jgczV0W/A/UGzEqU3FfR/nHqrVg7jLFBtOlU+uwDe+E3dXVZbR4thei/FI/C0BkDa
	 bKY1IKiRqwDrPeNlcUBL6qjdPXRVSFTIHNLpnkfG5JmQXAn4Erq5MqpWHIGlvDMxon
	 hVm/NTli4ecD1E4/kcUnk1okoGCnx1TdkNayR7wBfIewpM9NXuCQW15G+TAZLVnkUO
	 ZJJyonGmi8g+rjk5jawpZ/y/HyK2C0UHBotmi2mmrXoBGuvAc+F4OqNnPb/02Mp/ap
	 I5+zZKifOgCTL3eB0BTutZ+3I7vVYF8VNPv8fYAsBRAHPgP6ZPkLSDufduRsScIgmS
	 Q6E4hdXlYVaVw==
Message-ID: <sashiko-outbox-206080@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 07/14] mptcp: annotate data-races around pernet
 sysctls
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Cc: linux-security-module@vger.kernel.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261109025425.328445-8-jiayuan.chen@linux.dev>
References: <20261109025425.328445-1-jiayuan.chen@linux.dev>
 <20261109025425.328445-8-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 03:01:28 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Medium] mptcp: torn read in mptcp_get_path_manager() [1]
--

commit 320fdfa473078fc92c3d7c8719ab1b53608f74ae
Author: Jiayuan Chen <jiayuan.chen@linux.dev>

mptcp: annotate data-races around pernet sysctls

This commit adds READ_ONCE() and WRITE_ONCE() annotations to pernet sysctl
fields and their accessors in net/mptcp/ctrl.c to avoid lockless data races.

> diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
> index 63c5747f0f63c..164f79b9deb0e 100644
> --- a/net/mptcp/ctrl.c
> +++ b/net/mptcp/ctrl.c

[ ... ]

> @@ -230,7 +230,7 @@ static int proc_path_manager(const struct ctl_table *=
ctl, int write,
>  				pm_type =3D MPTCP_PM_TYPE_KERNEL;
>  			else if (strncmp(pm_name, "userspace", MPTCP_PM_NAME_MAX) =3D=3D 0)
>  				pm_type =3D MPTCP_PM_TYPE_USERSPACE;
> -			pernet->pm_type =3D pm_type;
> +			WRITE_ONCE(pernet->pm_type, pm_type);
>  		}
>  	}

[Severity: Medium]
This problem wasn't introduced by this patch, but can concurrent sysctl
accesses cause a torn read of pernet->path_manager [1]?

proc_path_manager() updates the inline path_manager buffer in place via
mptcp_set_path_manager() without synchronization against concurrent readers:

CPU0                              CPU1
proc_path_manager()               proc_path_manager()
  mptcp_set_path_manager()
    strscpy(path_manager, ...)
                                    strscpy(pm_name, *path_manager, ...)
                                      <-- torn read

A concurrent sysctl read or a caller of mptcp_get_path_manager() can
therefore observe a partially written path manager name.

[1] https://sashiko.dev/#/bug/linux-276f38f8-a836-44bc-9e44-c537511752aa

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109025425.3284=
45-1-jiayuan.chen@linux.dev?part=3D7
