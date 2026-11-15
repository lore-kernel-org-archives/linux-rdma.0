Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794753039;
	b=OpgGFXldtlZKFeRuO9mQaydPBEexMkIndFj/pmfK/EcdeHaS7Jr6e8vtdhInrEMeoJj0
	 idP7ln25X2nYV5cd/+TywfcLPBDaG6iCRXtXQ2CJIYk7UHWDtWKqzWxHGWHom+UyB2GCV
	 0Kwy1AsdpBuD7OetwpA89tRW8lMkQ4U7HO4rSgnVFIHNj2IQbmCfCyaUQQ4E20xlHJH/P
	 ZnZTU0CPW9xH9GMmtux+FWpI45ZNlaeptIxrk5gEDEZ0vjO2/th7YhWfA9uHc0LvmSAhy
	 UJDJjEIScC2E6t/4Ba3ZbAA/+u60M+Xhddz5kYBg3b0NuBSTIFwc8ey/RvXdGyB34EA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794753039;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Gf5ixW35iJp73VYSRJwntaX5qMLRQm8Tp7N7vAg02kw=;
	b=U4OT9Mfdv1pnQzO0SAwPpNqLw8WEXdXjZ2GY/MD8awa+4SOybr68n/GVmA2XNkXzTOjp
	 PDx1O1DOiFiK5oBKEm9VOhMCFSD9RPRmG/CiJRiN8UsF2g5kKSvm3uurhYUtNBeJdHJk4
	 nIHdxAmH+u7lvrJMszTIiv7ulj/eJCUU6f6U84MAtvob1BtB0eKT/GZu5z1Bpt0OcvuLy
	 q8R3bkFoN+UH+ysP5DAZ/opFdM3hq0pSVKdEb01tJ+CR5DJ/2t85WzUV7Dzxx90bJc0Wn
	 GhJua+D76KPZefhWfOMyIjvLTi58TXsO7Cx3AL78VU3VH1LjK8LLa2h1wJHPFWvB01A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Oly7qmtB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.47
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75B6606A31E
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 14:30:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D75B6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Oly7qmtB
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-67c6a0abc2eso2700993d50.0
        for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 06:30:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794753038; cv=none;
        d=google.com; s=arc-20260327;
        b=Ku2AQdX7WCHuEJbdcBQQvYIl22T543Ls62qz9Ro88GeTSWUsl8WiNDbwaZCFy49o+U
         tkzJigCqkcDJIOWD554EXXjzuvuDz8b8gQPyMPvbf1Q/sPoZGSzS9MULk9QRRG0QDSej
         ZbFo4A24cRb6/Nm14OTqp/0pOsDQx0+dkDRzDpJIK6i31e0uFC3ec/x62DMQnve/P0pW
         l8ZEr6+6SNlEltixXGOK8mmBGQ+PhSHPCxwRH/66q5Z5QmxOSIHLsIzJJAOKZhrZZre+
         KkkWrZ+XXec+R1Yt406FDoQ3i6MrfSz7Gick6DlhEej1d/LqCKgS3MRoZeMVregrmzZf
         JM0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gf5ixW35iJp73VYSRJwntaX5qMLRQm8Tp7N7vAg02kw=;
        fh=Pw+9fgJjii3v/o0CC/atArUv329KWKCfnSj4Ijf4o74=;
        b=p53gMWwvQuxRwyG/uEq6IKInnxy4tKO8MDJ8Qpa2yjk+nJMKAu3+fToWHyjqKg7Hhe
         E5egrcYFAt7pLY28/srhcH6F0rL+MD0KdR4IMiJmkLyAJciSXBnrpB57JtlZnZ9VK06v
         aV4s62spfC8vdt7EVoBGOc//w1gFkwM67gqqFz01+u/242LkcWeFbjHfdLYVXV+luc+o
         p+cFO0sndUvJ6DYtfy3IAzE/Iz1J/jOdEKKzTmcwmQqD2dT7w1rQGTBm2us3s17PSUQn
         c7d1hYVWq87VTiGiMPvvPFgJnfRI8YFrr/oxeNKcHa6USavh/qcXX7NmXADL0BRT2lm1
         hUSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794753038; x=1795357838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Gf5ixW35iJp73VYSRJwntaX5qMLRQm8Tp7N7vAg02kw=;
        b=Oly7qmtB90UPqgZDcVJiKirQy+3q/p0GvQ8s1jCD86TPt3O+P/N3y7kP43yOfrSxqx
         tBXx/vUz7aet1rWiMbrNntFeZWgSfyBiGkB8HGvkpVoM9EOBHjvu/Y/wGQVGhMErXL4Z
         4VtOiiHk1NF/iVkW9xyL0eKYawgKPLxVVi2w8tM+xdqOlPtQQ7dyxl9UPkuO/1l7VYHV
         +uFJatJ/M/vwOfl+2cQrEXEdSsyrhedqYi2JXrsHFwHqXjlsTpXdcDZGv3IaTl2McA1Y
         vEAgra/P4CqLet4bm4xlqdHWqhbdrrHOJxpjA9cwWKeELyjwLf3OhxEbIufEVmXOoIqT
         tx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794753038; x=1795357838;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gf5ixW35iJp73VYSRJwntaX5qMLRQm8Tp7N7vAg02kw=;
        b=nSvc31RAqbg8SbWAEGZRlIPChd+k1Cct82a+kbUXsitXBOsaWEOwF61pQEVpKUzey2
         lnXRi3ypIS0hmB7FCwy5P+I0hTaRi5iWdpxU/LdN2RKrtJ+xBCCw6C+ns0JPlKFdzFSI
         np6iLm4c8vzdsd04hMga1fQxuG2lTttKP0R3aefLzwEB/jOS4icV25CxQ3kFYnJk9n+o
         61ryssJ9oyiyS6RgjmL1tNcUzAQQbHcDVTbd0FrhlWOoU6ZSjq1ZyF7FU7B+jeF84yNv
         FTtECukGWpOMq6JAYZ1QeNzh0++iP6F1ti+nHYQCYDmfP08rOZ8IR5KU+9oNfrPEtgRL
         tS2g==
X-Forwarded-Encrypted: i=1; AL+hErEl8EjsO7e1qJewYdpLkyqkH4PwD7t3o8urmylywrhh0EVnF7G6llFWTLW7o/QKUTxdINW28NI3Etjw@vger.kernel.org
X-Gm-Message-State: APuU4Z+HMm0Sf+8Vk2HrXJLflaHKFBNR6K7jP8BTygmLo8HEKtRMGfP/
	nOyTmKsoPPmCXJGiWvfNSYubDFlb/dhlQ1vHjJrcwoz1YpilavdBiNxKb5d7HQ01vC8XrHCMd0s
	8NAcXu0GEZM9xlyerR+vZFOHdEFbj6m0=
X-Gm-Gg: AYBFou2jHAQf2kwzdOX+ivaPnMwEayXCnGbs9Ly/jocOtB1cToHW0NtwsLC9LCs5Mbd
	VaqpJiRk9UJEWL/aQbXwHw49izsMJW/s/gh+3RYPMnUbNqUilmtNI4PJARmNDzJlRIRhLUgTEJU
	V+giSf9f3gD240i7a6Il83Rp3CvPr6zeUKns1FNSqcH17z18LpbHg4pInOgg0ouISStCCTDIRq1
	fejncHsVZeIRgZc2J5PDQ43++yhszTIIM/cVwcffghF/xBXhelc1AvDtHMm0L8Y8l5ct77x26zd
	J3CZQ51WwwNyjF3HIOhf3sLbQGFsCSnpnwVSvilT2LLeobPoiZUe2CyGw7y8NjQybbhNc7BTRbr
	Nx1iZTjTH2rTDEPlAJDFVkZslpJNBJn/v6Vns3Ya/YnYl4IJ9N4AMg5t06YbVhwLnaMe0WxayGh
	/9Wm0rBDBpfneVpWWQHuyPBHXg4YgJ4p7DGpxSxsIwcIZvO7uI9Rx34uumMw9sxVUEpClCJYRdH
	Azl7KinuQ==
X-Received: by 2002:a05:690e:4087:b0:67c:2a61:ac2b with SMTP id
 956f58d0204a3-67d895e448amr4573986d50.34.1794753037737; Sun, 15 Nov 2026
 06:30:37 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106013908.21789-1-kartikey406@gmail.com> <20261110004550.GT663069@ziepe.ca>
In-Reply-To: <20261110004550.GT663069@ziepe.ca>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sun, 15 Nov 2026 20:00:25 +0530
X-Gm-Features: AclHuK_sOxDehipD86J_QkU3K8KpVc6AEMCghy-pUvcXaUGF8BCqoYCDgCavHOo
Message-ID: <CADhLXY7HKNvAM9=2J+VOVynDW39_PU=ohUKZkvwsqj=ZxSLbrw@mail.gmail.com>
Subject: Re: [PATCH] RDMA/uverbs: Fix radix tree node leak in uapi_add_elm()
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: leon@kernel.org, hemanth.selam@gmail.com, yishaih@nvidia.com, 
	edwards@nvidia.com, mrgolin@amazon.com, michael.j.ruhl@intel.com, 
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+d60be66dd00b4490fa96@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 6:15=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wrot=
e:
>
> On Fri, Nov 06, 2026 at 07:09:08AM +0530, Deepanshu Kartikey wrote:
> > syzbot reported a memory leak of radix_tree_node objects allocated
> > while registering a siw device:
> >
> >   unreferenced object 0xffff88810d78f488 (size 576):
> >     radix_tree_node_alloc+0x81/0x1a0 lib/radix-tree.c:276
> >     radix_tree_insert+0x140/0x390 lib/radix-tree.c:712
> >     uapi_add_elm+0x61/0x140 drivers/infiniband/core/uverbs_uapi.c:41
> >     uverbs_alloc_api+0x85/0xc50 drivers/infiniband/core/uverbs_uapi.c:6=
59
> >     ib_uverbs_add_one+0x1b1/0x350 drivers/infiniband/core/uverbs_main.c=
:1196
> >     ib_register_device+0x4fe/0x7f0 drivers/infiniband/core/device.c:150=
3
> >     siw_newlink+0x36a/0x3f0 drivers/infiniband/sw/siw/siw_main.c:433
> >
> > radix_tree_insert() can fail with -ENOMEM after __radix_tree_create()
> > has already linked intermediate nodes into the tree, leaving them with
> > no entries. uapi_add_elm() frees the element on failure, but nothing
> > frees these empty nodes: uverbs_destroy_api() only removes populated
> > slots, and radix tree nodes are freed only as a side effect of
> > deleting an entry. The nodes are therefore leaked when the uapi is
> > destroyed.
> >
> > On -ENOMEM, populate the same key with a dummy entry and delete it
> > again so that radix_tree_delete() reclaims the empty node chain.
>
> That seems like an absurd thing to do, can we fix
> uverbs_destroy_api() to free the entire tree rather just populated
> slots somehow?
>
> Jason

Hi Jason,

Agreed. Since radix_tree_root is now an alias for struct xarray,
uverbs_destroy_api() can call xa_destroy() after removing the
populated slots, which frees all remaining nodes. I'll send a v2
with that and drop the dummy insert/delete.

Thanks,
Deepanshu
