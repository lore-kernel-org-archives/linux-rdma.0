Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E7C23E330
	for <linux-rdma@vger.kernel.org>; Tue,  8 Sep 2026 23:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788910279; cv=none; b=JF0CCCMXXPwJeUKq4STEALVs8n9FR+Do0XFoTT/mvReatmZd9sItJ1XQn6hHDq7lC9Frx13i3t9r8kA30o7f04ECkTZE8gQVqNpHLHO1VldMokcvwgLXqg/+iLD2yoQnsxY16W6DMxXsctiyjnWayJAfQQi0s/sEgV8/lf/OUzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788910279; c=relaxed/simple;
	bh=lgK52YWEbmOHlLC5XhevTS6kX/pGRh0yPlV7xZbQ1f0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=r8MQWH6kGOuxY12W6pBh6g/3S3VhF+7212sPmQNb0yQlhIiAYcjaoFD2Vlg4vLVnBTiv+RJPXr21uYE68MD6suN176To/NibDoUQC/sVVd8jtNwG2cgn/jy+UDGp5Tn0XjShSAyiL1WzjXyuwjAEMCsVVDlP3JyZLK86tSFLDcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMUqpufU; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMUqpufU"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-9103f5b813aso42300716d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 08 Sep 2026 16:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788910277; x=1789515077; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Yq7lXkoWC5jfEWJMNBS6tBwhDj/bbJjyiLJq/Z7eNiQ=;
        b=eMUqpufUtakeZcaUo0NM8W4QbYk15mZl5vy0UDj4R2McNaJEoUur8T/m7FSwYfQe4o
         HVr2MZKCzKGgIfhlzQV2K+Tsycof34HGcUv7XI+zeTrq7+ahMvF316oUcCDtgr6JG20A
         SpGUNVge2hripIhw90sWNWu2HkKXxiwJYRAqn8znRt/eVBhn6c8wlZ/49AsmA3H3cl/b
         KJXCE39fBlAIf/jdkxt2sNTiva1RHEgQnk5XedHZsg5q1AnsYE/DzLPzJT2Z9I6HROKd
         xtXRd4o6Pi8Zww0vvKVBqzGrE0/6aQW6ZnEXxwrZZkYWAxhMpdAjqYahzK0i12evC7BT
         5AJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788910277; x=1789515077;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yq7lXkoWC5jfEWJMNBS6tBwhDj/bbJjyiLJq/Z7eNiQ=;
        b=Am4q2T0+KlfAb61IRaefkTZ5WQ5eXxh40Q6E56qrYZn2iJkXHdwaZ352n3dZmWORjP
         zfTZqcVVpAJisZdG8JagoUot17LnlKSRTdzxuOMCgOuuAA7AYYcNQsNtpQtAc+eeykEv
         k/RDoNGdTz+yR+xF9kq/Xrv92BHL3G+VBlLBnj4zDUvZm8nm1Eg+7MH+Jxwi/ODhL+ar
         6nIbPE2tAanufaM1JlWjDBUlgl6BF1SMF3GmSyC9aVFtaAjfOd3G1wj2YFDqHTQiDOdV
         heFDI5VBuGyRzOIUZ1QbzrL2SGKTO6nMbnVk/uLi6NC+qL2VV1hQSdZkCMO32RY4Jy9d
         lbLw==
X-Forwarded-Encrypted: i=1; AKwUvBwWKK+6h+UNPSVg7IPllg8J5l2aHb7NU3RG4S6XRgkf9JuSR7jIiIr2+IWzoi2t4gxAEl0zdPLMWa7w@vger.kernel.org
X-Gm-Message-State: AFuF++k5aqZDaAGSGWXL+3+/IWqdDUQxPogntv4ety4trv0pkwtB/TU4
	3VgmLERLyagP9wYIkzByFgLr6W4oSMiz/EH7e1Nj6p6Sbk7yQ/wZcN2/
X-Gm-Gg: AYBFou1XEQZmLqLwfKlr4+K3trVkpVXkuTOTQj4+riNEsTFWRCPSlEEj0Pr01xnqYJy
	qifyNM75d43e046q0jUeZ20LBY2WTpsvLIodQiBYkOR+6ikdS9lnKcp7bP5hvsQ3PhQh5uSgh7G
	Ew0MTtVpqdm7qLCYHfkWu+IcKeon3GDx3Tv8ik60WwGYWf/+83nVlrsZZzJ4MsglJurh1HKNKFa
	pTswxbc1q/g6GHbSiuI1H1l86Ik1u6vchDt0S4+PrtCmM44B4uM0F5w6i+qHOetbbnjAH0UbDaa
	KYnyGRoDQxyiGiKtatLVyppR2ztcMZ6gyLNihVOsMnXfUN0csDTv3bHldXsGn7Fg+0sxQPrj49N
	wOTsPizfFFBFjTfG2cy2Aff9yYcexvDZDvaNevGo1xnVwbWcxc6ss0GyDHo8dewhJ4Is1KI34Uj
	gGoFcxA4WkkMWd0EixMN0QZL7kGuxGD/Of8wGYqB9YqXCuWMUaujXR2rlWJf6lvQOJUQ==
X-Received: by 2002:ad4:5ce2:0:b0:908:958f:4db with SMTP id 6a1803df08f44-9103eefd24fmr369191086d6.3.1788910276570;
        Tue, 08 Sep 2026 16:31:16 -0700 (PDT)
Received: from localhost ([2600:4040:9399:4000:e553:72e5:7d37:c7ef])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91040694c35sm129077696d6.36.2026.09.08.16.31.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2026 16:31:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 08 Sep 2026 19:31:14 -0400
Message-Id: <DLABRMYUL6Y5.2AH8IHHONR58N@gmail.com>
Cc: "Bobby Eshleman" <bobbyeshleman@meta.com>, "Boris Pismenny"
 <borisp@nvidia.com>, "Carolina Jubran" <cjubran@nvidia.com>, "Cosmin Ratiu"
 <cratiu@nvidia.com>, "Daniel Zahka" <daniel.zahka@gmail.com>, "Doruk Tan
 Ozturk" <doruk@0sec.ai>, "Dragos Tatulea" <dtatulea@nvidia.com>, "Gal
 Pressman" <gal@nvidia.com>, "Jianbo Liu" <jianbol@nvidia.com>, "Kees Cook"
 <kees@kernel.org>, "Leon Romanovsky" <leon@kernel.org>, "open list"
 <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, "Mark Bloch" <mbloch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Raed Salem" <raeds@nvidia.com>, "Rahul
 Rameshbabu" <rrameshbabu@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>,
 "Shuah Khan" <shuah@kernel.org>, "Shuah Khan" <skhan@linuxfoundation.org>,
 "Simon Horman" <horms@kernel.org>, "Willem de Bruijn" <willemb@google.com>,
 "Willem de Bruijn" <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next V4 09/14] net/mlx5e: psp: Add an rx_decap
 steering table
From: "Daniel Zahka" <daniel.zahka@gmail.com>
To: "Tariq Toukan" <tariqt@nvidia.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>
X-Mailer: aerc 0.21.0-threadmapfix
References: <20260908065244.3799142-1-tariqt@nvidia.com>
 <20260908065244.3799142-10-tariqt@nvidia.com>
In-Reply-To: <20260908065244.3799142-10-tariqt@nvidia.com>

On Tue Sep 8, 2026 at 2:52 AM EDT, Tariq Toukan wrote:
> From: Cosmin Ratiu <cratiu@nvidia.com>
> =20
> +static void accel_psp_fs_rx_reconfigure(struct mlx5e_psp_fs *fs,
> +					bool decap_wanted)
> +{
> +	bool decap_supported =3D
> +		MLX5_CAP_FLOWTABLE(fs->mdev,
> +				   flow_table_properties_nic_receive.reformat_del_psp_transport);

not for this series, but this makes me think having some way of letting
the user know whether or not psp with hw gro is enabled would be nice,
so that they don't wonder why stuff isn't coalescing when they have old
fw like I do :) I could see a similar thing being useful for gso
features if the psp device can't segment something that it otherwise can
for non-psp.

> +	bool decap_enable =3D decap_wanted && decap_supported;
> +	struct mlx5_flow_destination dest =3D {};
> +	int err;
> +
> +	if (decap_enable =3D=3D fs->decap_enabled)
> +		return;
> +
> +	/* Create the decap table if needed. */
> +	if (decap_enable && !fs->decap.ft) {
> +		err =3D accel_psp_fs_rx_decap_ft_create(fs, &fs->decap);
> +		if (err)
> +			goto out_err;
> +	}
> +
> +	/* Redirect traffic to the correct table. */
> +	dest.type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
> +	dest.ft =3D decap_enable ? fs->decap.ft : fs->rx.ft;
> +	err =3D mlx5_modify_rule_destination(fs->check.rule, &dest, NULL);
> +	if (err)
> +		goto out_err;
> +
> +	fs->decap_enabled =3D decap_enable;
> +	return;
> +
> +out_err:
> +	mlx5_core_warn(fs->mdev,
> +		       "Failed to create/modify PSP decapsulation rules (err %d), HW G=
RO for PSP unavailable\n",
> +		       err);
> +}
