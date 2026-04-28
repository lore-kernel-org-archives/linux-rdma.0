Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE0037E319
	for <linux-rdma@vger.kernel.org>; Tue, 28 Apr 2026 22:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777416591; cv=none; b=hHTYZzPWn4C/+NjwGp4GuG96gcCdaD+58LDcnIse+BQfBGZ0uXU0yLS+KfEUPRVKOnq5SodmnWSWkr1RHbX1yElFb3eJpKoAwj7IkywHyU+LlEpONvckYri3WXkmTNt2JmfP6lNSV2yUmPUCHWkeyN1uDAC6BjXrBwgbPwy/8Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777416591; c=relaxed/simple;
	bh=OQEv3vECksF1yg5m1J9iB4Qygwv4grU+j2uR7n6iAuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ImXHU9/5+vbZPDU03eF3EbYNdlq18oBnVkA9YVeqXtkqKFRwbLvy4fwfahWqiea/3UobDcxPfQqNgqQXQUXTb7l1miwiDjIg1/4iAsClnM9u9ikenqUbYPY4FexoorjmnnrwTxnLEM8km6b9l4wrqzYKkDrRRIj9dHCgVhUMiXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BaMwRH+a; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BaMwRH+a"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b0046078so107226915e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 28 Apr 2026 15:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777416589; x=1778021389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OQEv3vECksF1yg5m1J9iB4Qygwv4grU+j2uR7n6iAuE=;
        b=BaMwRH+aHymVnwGfm1l/wIKQDUlKGNyIngtdKBwfbP0TngQI6th+iLD2482rG7jE6r
         2Z5FwF4Qo3Unt1DV4qDiuMzQTgIKNfdd8Ad0cVrMkmmqyJqNVb4FjWnOvw9O5RwAJNcK
         73nzfljYcFegUE2LZ9RpXPhnQ4WXQCoq4r7t8YBNpd3ORFHfeiJNb8OAkuWdPpbPd6I1
         LacDMnI99MWml/HvLsAdw8r0QqTWPVL2Is6VATym4C80MbAu+rlIqLp6y5Pp+l5s+I18
         hL49d5wsG0k+qXhG9xvc7IN8/YwXf+fZp3MJtr9NKQEQvvNtpfYO8RM8ioeYRPYpmwyf
         8AJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777416589; x=1778021389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OQEv3vECksF1yg5m1J9iB4Qygwv4grU+j2uR7n6iAuE=;
        b=SiKkI/V3TARbhVaBNfxmoFhwMEvVjVEpWr2Sa6Wo+AMIpJWmaVb+LpX2ly6F88apKF
         Wi12xToaWU4DnCqxHti7q3wmlGXS98v/s9ooofFASwNwxuwR0JuT6pqNOy2vYs2k3VPz
         O5n8XB6IPzrgtUrFUbkPkz17eq36PUUMURNjx+vRLwJnwfq3EiqrtZxZ+KF/Hp84UArK
         w59f8CXZGmn1+1Y5A0FTYIiGDLN6glDm5/szRPWcpmTKjIzJaz0GemIj0y6FhjGOo+Os
         bYItppponxByibKdA4baahUyWxXZa4UsPP+XB83DD9bbWnkY/F6fz5b/JujPAdD+Znbp
         8qiw==
X-Forwarded-Encrypted: i=1; AFNElJ9ifM5cZYgOykW8GpdrNPkDqa9M6nIA1S62jA3NnHDIoLzyGAsHG0mtiaw77Op12OjkMkvIuc5gugq8@vger.kernel.org
X-Gm-Message-State: AOJu0Yzfs3yK8NL1layGzwIGpzwIDCsn1m2JjBkxPROQp7MTI9TUXR2H
	8id3JfYlEqgQPkotwULdYeUsbM5rcocOGBpsPh1TL+jXBTxHfrwqpcN0
X-Gm-Gg: AeBDievMPAx7C1hEi7qiDWERty3+yMblZvduSixZKRn/oEGLWj1TZhuqMo2+IQeLamH
	Z6l4IzT9HRU8EKNTmFVFz+/vaAkLHjdv8xd/0rHnnrQogSXE1JUvx/aZolikGmQpSVTZTrliGdd
	ITN3PM113UGJvQzJDLrxyeziquFnCrQ0FznK52YhRyqKN1MPLnn+/Ku8c1PKqeiFKnecG1yYi/o
	Hcng7LiljcfPWufk89QjScvszTZcOmphjRXRJdePIkgZg0qsquQxbBl2Dj84NcjpngU81r6WtGh
	sPo60+bGxeapqDDoAPmmJlm9/4FWnFy33sacHOHrzhRKSiQHZx2lwEFxuJmEromqYVkgcbx2CWj
	VGL6FCVA5eGu3u6vNjCZ5mgtWWxWUvZoDX0pn5RvE4Rbdd92Fw4MzzNmApin+8evBg7PiPi3At7
	VEGkD/T3gHBQZrcTJfRH/Wk0Nn4ZCNzcqntUDuna/XCdN3u8h16b7g2ifXrfZahoBc/i72B2xws
	Houf6uhCBxvtrHuabjV6454bcwPIPXf/gE1Uu2wGQ==
X-Received: by 2002:a05:6000:200e:b0:43f:dd94:3c30 with SMTP id ffacd0b85a97d-44648b51105mr9146088f8f.14.1777416588909;
        Tue, 28 Apr 2026 15:49:48 -0700 (PDT)
Received: from SD.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b4216ed6sm1276715f8f.16.2026.04.28.15.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 15:49:48 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: yishaih@nvidia.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	prathameshdeshpande7@gmail.com
Subject: Re: [PATCH rdma v1] RDMA/mlx5: Fix devx subscribe-event unwind NULL dereference
Date: Tue, 28 Apr 2026 23:49:27 +0100
Message-ID: <20260428224932.37778-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <4cdbb076-59c8-4ed8-b182-2ec644fd97e8@nvidia.com>
References: <4cdbb076-59c8-4ed8-b182-2ec644fd97e8@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 28 Apr 2026 17:55:22 +0300, Yishai Hadas wrote:
> Can you please come with V2 while addressing it ?

Thanks for the feedback, Yishai. I have sent v2 which addresses these points.
