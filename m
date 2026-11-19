Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795098942;
	b=D5gcaC29frUp85VLj5qhQP4Zq8KLvZzkRt8rZmxvMHx6vfx0bmt6RambTrQUHoTIcnc+
	 DqM052zfT/3n9KVhyQal50Pr1c46Tc4siUU/h3FCxZADrSgne8qRYSRvOrOTnOWBUMWA6
	 m4Sc9cJefb5IX6eFdZnm4Zl5zA52rJeX+o/ispzpBwZ7yq6/9JB5XVPBwOY6Bt3gbXcey
	 xU4c2PqTxBX3THDv5xRQ9irL8U0fMT4bFE0fV+fKlMMPnYTJxr2ZMa6JidPBSWJQhRyYb
	 +1GtEbuHRcVF0II7P2L4B0r67vX0tKYE5pWXpMt2ziHhF87B/lZEWwtyvTlBHWwDasg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795098942;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fwc9Vs0eCwtckZGOJ96a7MsJ3RS29UxqFWSheZDmdJQ=;
	b=stndNRPPBRmBoH8nnSAiYgOBtatltBDxAZ/HMXjeFF8+q/Do4QBgN3AxdWkiz+3yzjgG
	 pK0MJfayxvESsces6E7pcj7RaYWq6vyVWgVyahRnRyxNN8G9ouHN9q6ZCNLw74Lur4Wf5
	 d4JCJqrxSGCL8Dy+35SH7bkWXRFCn46GTWy5w7fLMrWNaD9yLQzos3sZd378izPJ5tca0
	 IMcNFrEtkh/ItRT28Zxmwjke7Ue3yZ3DjoMUA5G/HySS6slE4wyFz4FmRrf2UOPm5ZRcc
	 XXpExbcKnYLBeMNSgdSAGX+PFplX7xCSdlfdFIXSPmOJssCWxmIOf23z5VMMGUmioDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=NhOZekIj;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D877C606A320
	for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 14:35:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D877C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=NhOZekIj
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b8977f2785so3002122a12.3
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 06:35:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795098935; cv=none;
        d=google.com; s=arc-20260327;
        b=fblnj25LTR1jrqXYbIgrKS7JhoKTuBw2HoYZx5Nh7SnjaYmiJBJmtNt+Bjf0UsxviT
         1tdG5Ce0beVtq80ZfH8WYHGLwe2pJ/jSviva4cCk5PgsR6bbZ9FlH7VPaC4ydPPk28UO
         t1wrynIP9rbOBkWDZkyIq/drLMujpu1OkDq/gQrOMR5GhK2Xw7zD8/Qw+hUtshPWOvuo
         awJzYBGuaKcISsC0IelXZHclU/VLoNQRqszOOltIgXziMI6vNZ88x9vDSc5dXsPE61EZ
         HXp1g4curxJC1Rkq6BsctWWQX9whruFX1UDoveIKthF9pyodk7ofgfbr7fxEKU7uKg91
         V83A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fwc9Vs0eCwtckZGOJ96a7MsJ3RS29UxqFWSheZDmdJQ=;
        fh=hOHnzrvMe2qyPQPaaTl4InbMCFS5SGK40Nh4kOzhY6c=;
        b=k5C8q0CK+GfFLls9Nq/9GeZFg2Nsk0WtMStjEA3vNywFArro5wUx2PmzT9bSXygQyE
         Iqf1zuXphlmeXMlETpO0ytcwICJNoj+wB18GMbMD5jYyx+sHOqMLFGC0a5hNRXW7nJxD
         HKOrLfU9F+vK+RT3YZPI6zxyLkK1UAgH1xo4AQcpTM3rmj/SZlhj0xrp73XUOLIuApYh
         GAmuY5qpNGNkzBteTJyAsuCg0ogNpNpQ9qVnRBNReGQKHfnzC6UUdH86iT/badoH+NBr
         qD1XvM05dJNBdE+RD9obqKqvp+9tFEfXoa3ZyUpNcGga9IdBCQ2kfpqsTfISNoK3yK2k
         486w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1795098935; x=1795703735; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fwc9Vs0eCwtckZGOJ96a7MsJ3RS29UxqFWSheZDmdJQ=;
        b=NhOZekIjKl+gZPOJkVw1+HzMbctt5GPFnFQMSIHry8p29Xw5DKPG2gE/PmTV7ECZrH
         /oXFDRFf/BW+XNp33vjHJo9ZshhlcZAq+fVT1pn5tWXzptpfVkqALva3cBnpL0JcQn8u
         n+CW1+z448/pzfdgYk6qjSbSLzZsGNUAnAs+wZbUZg8t7zVhKjjTFyBsB2oODMGLvFxq
         EQ9ir4URj/VNwkx8yAMbiddJPiXEIqgU94LSVZBqxSJZKMbz7kEIzZPnnF5E4mxQ6mGa
         TTqAXnW09x1CIO3BIKsguu2CTx2p1NJzioujg0nAc4Bqp4tk17RkD0iwxmmUUHd2OHSB
         /GYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795098935; x=1795703735;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fwc9Vs0eCwtckZGOJ96a7MsJ3RS29UxqFWSheZDmdJQ=;
        b=NPFz1wzSEnQnyQ6Sn8hM7ehTveNgW2s5Xt9i9KgaHmd/ujU89oDAH/f7nXXiScQknj
         zcO/QNY+K7+fptkhspIszlXfPLnPN8mL5D82Wynvr7uA5dQT3bH5hMNmSioQtHBISyit
         Ng/iFM9gEPcOaz2pDhB35V6SL8DndMWEs/dtDecVlsM5fpWd6x+TzkToRK+pZV2uMZ6u
         SSIIrz9ePMxETSfPsdFCsEhzQ/Mdy7P0IquN8GomgLtN8Jaeb+lzf53/iN4+LC1NUkZF
         gyM9Ex0iFx6xr/xXrpjFZAkUuAo4qL2bTmJfPImYgpjeOgWalECtY5oypmiNjAuqWCKa
         oHYQ==
X-Forwarded-Encrypted: i=1; AL+hErGOv2PEBSjnEfq3IwOYHlyZLUW3Z3CXtgA1ijhP/zYV0btZ3U9w8a0aU24X07tWHc1LRMpPzibvksNa@vger.kernel.org
X-Gm-Message-State: APuU4Z9rB0cTjq5RxOg+XEvs/RXtUToQigkXo6LXabTsySBdLe6/7ayJ
	C45YFN4YUICOERlPdUWYNdyARRPBTdSQQD0LelXO90hmGUovmy4QPuJm+K5by0IIStViv391IUe
	2ZO9nITlbz9tk/YA5WxXKl+2Xrduypbes+faGJ97UEw==
X-Gm-Gg: AYBFou0/+aJNkKwFW6N77aeqvNwn9PVRSyHz7BgDinMUe+ovgGV1v38TCP58oTsDfnF
	vndXV9txbgXscuy43iAkRd4TJkcCjv/8cWEB6gY3x6juw15NHjMhG7w5gGK9nAVQT0DsyzTOBUX
	dhoU9SAW9MDpUQRWMRg2iFiDmHldZCrMV+02+v1OdE+H6xj8+fkORSwB0taFP3M1gXtdZ9tPvmJ
	9cGGREUjBFz9rp8x+wwF2qkg2tkx99UXHKZgyZn7jWIk+HwPbaGvUxCYMeFXLuB7nnWf/HuH269
	XGxbiDRkyxRLn43YmkETIEg/f7gnaswhKvu7aVWN0mkiJA0SBjZqvBdO6XfYcLRc1zGC7oLYSFi
	zxX1H925sRB+a4wEnNum5nZ81VviSZvsO/5KJd/n5hDpeTHqc+7+rKn134F1C8Z0wkWnEBH0WRo
	L6fxo7UrPI5yuYqWBvoiGbUSV9TaF0AsbFwB4lcibDDXtxDPB2SmokXSc8JRgJRwumERqAUSGuK
	shHYAtukpGdVFdAbE/nPJfC
X-Received: by 2002:a05:6402:321f:b0:6ba:12e2:4701 with SMTP id
 4fb4d7f45d1cf-6ba12e24bb7mr1989016a12.14.1795098935183; Thu, 19 Nov 2026
 06:35:35 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>
 <20261109111652.GD8635@unreal> <APEA3wD5LFuJxkDei2Ikqqq4.3.1794229006784.Hmail.202321181@mail.sdu.edu.cn>
 <20261112190948.GV8635@unreal> <AJcAXwCpLMe4Pb1NjRYKDqpi.3.1795092059235.Hmail.202321181@mail.sdu.edu.cn>
In-Reply-To: <AJcAXwCpLMe4Pb1NjRYKDqpi.3.1795092059235.Hmail.202321181@mail.sdu.edu.cn>
From: Haris Iqbal <haris.iqbal@cloud.ionos.com>
Date: Thu, 19 Nov 2026 15:35:23 +0100
X-Gm-Features: AclHuK-dPTcWt0IIuZ2rE6NHM7-T7hU0j5p8pba_SiQNJGR2-xv8Hf6i-TIdF0w
Message-ID: <CAJpMwyg1iPJUzMYRz-3rWjnRr=9n=rQrii7x-FMmFMS7Wn5OZA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH] RDMA/rtrs: Fix potential use-after-free on client
 sysfs setup failure
To: =?UTF-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org, 
	Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 1:41=E2=80=AFPM =E6=9D=8E=E5=B9=BF=E7=A1=95 <liguan=
gshuo@mail.sdu.edu.cn> wrote:
>
>
> Hi Leon,
>
> Thanks for the review.
>
> =E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9ALeon Romanovsky <leon@kernel.org>
> =E5=8F=91=E9=80=81=E6=97=A5=E6=9C=9F=EF=BC=9A2026-11-13 03:09:48
> =E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A"=E6=9D=8E=E5=B9=BF=E7=A1=95" <liguan=
gshuo@mail.sdu.edu.cn>
> =E6=8A=84=E9=80=81=E4=BA=BA=EF=BC=9AJason Gunthorpe <jgg@ziepe.ca>,stable=
@vger.kernel.org,"Md. Haris Iqbal" <haris.iqbal@ionos.com>,Jack Wang <jinpu=
.wang@ionos.com>,linux-rdma@vger.kernel.org,linux-kernel@vger.kernel.org
> =E4=B8=BB=E9=A2=98=EF=BC=9ARe: Re: [PATCH] RDMA/rtrs: Fix potential use-a=
fter-free on client sysfs setup failure>On Mon, Nov 09, 2026 at 08:56:46PM =
+0800, =E6=9D=8E=E5=B9=BF=E7=A1=95 wrote:
> >> Hi Leon,
> >>
> >> Thanks for reviewing.
> >>
> >> From: Leon Romanovsky <leon@kernel.org>
> >> Date: 2026-11-09 19:16:52
> >> To:  Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> >> Cc:  Jason Gunthorpe <jgg@ziepe.ca>,stable@vger.kernel.org,"Md. Haris =
Iqbal" <haris.iqbal@ionos.com>,Jack Wang <jinpu.wang@ionos.com>,linux-rdma@=
vger.kernel.org,linux-kernel@vger.kernel.org
> >> Subject: Re: [PATCH] RDMA/rtrs: Fix potential use-after-free on client=
 sysfs setup failure>On Sat, Oct 31, 2026 at 10:14:46PM +0800, Guangshuo Li=
 wrote:
> >> >> rtrs_clt_create_path_files() drops the path reference on failure, b=
ut
> >> >> its callers still close connections and free the path. This can acc=
ess
> >> >> freed memory and free the path twice.
> >> >
> >> >Sorry, but how?
> >> >
> >> Consider an allocation failure while setting the name of the path
> >> kobject in rtrs_clt_create_path_files(). kobject_init_and_add() has
> >> already initialized the reference count to one when setting the name
> >> fails with -ENOMEM. The stats kobject has not been created yet, and
> >> adding the path to clt->paths_list did not take a kobject reference.
> >>
> >> The error branch then calls kobject_put(&clt_path->kobj). This drops
> >> the only reference. With CONFIG_DEBUG_KOBJECT_RELEASE=3Dn,
> >> rtrs_clt_path_release() runs synchronously and calls free_path(), whic=
h
> >> does kfree(clt_path).
> >>
> >> Back in rtrs_clt_open(), the first statement on that error path is:
> >>
> >>         list_del_rcu(&clt_path->s.entry);
> >>
> >> That accesses the list node embedded in the path that was just freed.
> >> This is the use-after-free I meant.
> >
> >The error handling appears to be incorrect. rtrs_clt_create_path_files()
> >should undo only the changes it made internally and error handling of
> >call to rtrs_clt_create_path_files() should undo what was done in
> >rtrs_clt_open().
> >
> >Thanks
> >
> >>
> >> Thanks,
> >> Guangshuo
> >
>
> My understanding is that rtrs_clt_create_path_files() should undo its
> own sysfs setup on failure. The caller still needs the path to unlink
> it and close the connections, so it should hold its reference until
> both are done.
>
> Is that the split you meant? If so, I'll send a v2 using it in both
> rtrs_clt_open() and rtrs_clt_create_path_from_sysfs().

Thank you Guangshuo for the patch and Leon for the review.
The bug is real. We verified it internally, and somewhere between this
patch and the first one Guangshuo sent in May, we solved this
internally but missed sending it upstream. It was a miss from us,
apologies for that.

We will send the version we have soon, alongside with other fixes.

>
> Thanks,
> Guangshuo



--=20

Regards
-Haris
