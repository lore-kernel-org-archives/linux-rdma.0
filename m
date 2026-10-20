Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.161.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792493041;
	b=5J9QFiR5GRc/gpHgCwlxt4NvZgw5dyeeCXCSs9ftAt0AFMItuECL//6UknAoj2jzTLuu
	 vrZ8m2hsii2mDgaT19B0q8TtXJ3kx9IXmF0o/21ciclskyIEuGgXZXViJdGgGgdt3/R2S
	 XaJzGzGRJSvvq5nVrbqKGrQT3UraNSH7+K+SoQzYPh+Z3hwY8+UZIsDBSqwKv8EIsAFC/
	 9l9hmtGu+wfMgVtTabG3egFdMsZxJD6oYQsIb+WfwvdU5CGHEyaFjLbRVL2be9YL+A2LJ
	 jrk7E0qfMpai306NUbC+w6RTj7fEDpCgrMjHJYhFBan+Y2GLlhbi59wgZIplimKiepQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792493041;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=kqXlGHZK1pUqa9HpkjKcxAViOyKcyPiOJa87b6dOxE8=;
	b=Y7tJOYBzMhIoUwmpQDbQr0wiTuI8cbNQHdJ5dPPCGLbwp7oBeiXlrjJYJzZTaJ7RsTIF
	 KczkKE5F2CV7EzX52Wicw4BMoEyFLnOHPuRCxIe8GXesgVCAk8ZdMstIyRy1naCeohQ9W
	 wBFm/3EMuyEQXkncHRJa1RiSuxMIC/ORBsidAefI7morCDV6zxkMYK31jTZBaF6v5uDwz
	 eIzZwlGynEEMyaB/rurglbl99S9dDMTVqiKLLt0ZVKL9gW2uT0IUX9L7wXTwvhuEKB3JL
	 dZTAC85xjmyVHk9LuZsMq/Kp3cIu+EZ60yM9Kdrw39hQmZk+V/G6po3WDVALhyLFWaw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RV6keQhY;
	arc=fail smtp.remote-ip=209.85.161.50
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F57606A322
	for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 10:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5F57606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=RV6keQhY
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6b19e291cc6so3047639eaf.2
        for <linux-rdma@vger.kernel.org>; Tue, 20 Oct 2026 03:44:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792493040; cv=none;
        d=google.com; s=arc-20260327;
        b=fcVw/AYtgW43s4awxDJXm/0sUt746p1ABkcpoOJQNOmb5ELCTaIYVoOAQlXpNBQyk9
         tJit9H+yYS79EzowSjFgI1d2Z88zs/TpjiebWVP+xU0pudriT3IVt28rGDhonFsj6/+T
         +LSXzY7r4oCsQ+ftgAtwTDUazlbtmmkBVbx+ivwa3dhyLU++6zPtUq2LnOWMTCF7/0Ps
         B5RntT6JkSM94jXYN37FQPLMdQXLWk8onemqQY+pkXFVsQ4OSrBR2h7P/z+QyOyph82p
         kE4O/dZUWxBXt1LVQ+ZpX+LH1xIvTn4ge+kcXJUunWstLL6C72gGia9tk9m/rXm1pZZh
         MYSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kqXlGHZK1pUqa9HpkjKcxAViOyKcyPiOJa87b6dOxE8=;
        fh=1TDJ6uA4cuvsPN8xDWpRRTpjkNZMLKCtbG1gf4fg3qg=;
        b=qKDHE2DipjCmr6DIIER0ND6a1vEUxTZXS2H/nQsi/uIuMLhu1zmIToF/BuTDG7uxWj
         I/NlZYnnHN2PDy7adM7AEnhp6sEjlTYyekq1C1ql2TCsdyTYvJo5XjwRq8fsfRbesScN
         1EwWWgkun4s57H2+0wRZR8JoAhClf8cxVWsOqcuNVEmk8Z3pZyw8rVhL/vepLyaey8o8
         RZYAYbqhmrrQ3CKkbvYFRrb785VSmdfEQGw1lmPuaZVxMEwy/jjVAR0lGcpRyrATnXMR
         daqv24CzQJuiK279GwKUP9WgfTaEn6l6H0HgZFoOGdXwW/1AvkGA/MolxPO0YYbqkOOX
         wmyw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792493040; x=1793097840; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kqXlGHZK1pUqa9HpkjKcxAViOyKcyPiOJa87b6dOxE8=;
        b=RV6keQhYLZFKssPsWpA4J+SY4gQ8BJ6VCOIfVR6UTl4ZnQQJwqf3k3KMLqmxu5pEEs
         s1TfRAzYuBgXl/aLRTxQkJJxv3y9VzWb+Q8C9vFsD9ehMBhWPQjtMwUlStCsis745mex
         j5K3attOH7+XhCVf49Ap64Eht3YCGFRXc/i4G5/P3PKpHMhD5hDL84oZ5T/i1lTTDTbU
         cHo5sF87hWgDgV++9fWTyk0j1WsGGMRCBWoMqu05FfZD1KcJULMiZIhsE5kIxV6E0lYp
         nIdWW5byDkVLOjCcZ0z2HvCvSzzDyL9VvtdVFeR0chdt1NXkVxV7dfFkY+KZcpblx2Fs
         ulUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792493040; x=1793097840;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kqXlGHZK1pUqa9HpkjKcxAViOyKcyPiOJa87b6dOxE8=;
        b=OdKZORunYcU+lcOr3xSTVpGL7Whd6H+sJBORtiaBsLS62ytgczIdnIoZ/V+neiYzVp
         ZedyQSBL34JLQlqka4M4xqw0wXni4dSL3yKdEcw06AXmEilH/P0lFMaO1L2pnBUpW1n/
         HQHnVPKUOQ9S1vk7heVJTPoH+udm8sW+bqcthb31nq2Hip8lGAzmRmRyNrgYBnVqxSP5
         j99CE4wIq57GcSM42RkqnBOaSeMEJD0W5yGZUlmjmi0Y7NIE8N+1ecCBKye3KcWalhxV
         vuemNnvofkR752C6AtCoKZUR6CxdM07a/lW4WjzIpj+hbzdfZGheitNG0PaGeAzJgJhC
         ysWw==
X-Forwarded-Encrypted: i=1; AKwUvBzb/ys1rqyWSIheZetRziHQcYAO0228I5TCkbqZgUpf9pDDviINz+RaStzKM945DTry2d270OtnhlpS@vger.kernel.org
X-Gm-Message-State: AFq9FYK7Mn3mQPFCfsDoVYI23MoM2IEwZva1PcquMR3ZrKLY/tfS7Vvs
	RPiJWYEGz6BRanHwcrw8/VsqdlxDOsuyaXGq78TYUu3DtXlqMwFeaGMoTMD3K1U09OImiM85U8E
	SwndGLI4SVx2tYgFJpgHlI4cj8zC5bVQ=
X-Gm-Gg: AYBFou1rkFci+zmffYkK8hGvWTaeEXJ7nxvEhRcDSA4h4AadzCpWWmL/IAxfx0j/r/6
	81tQDY2oGhHB6gTJq8JTGk0J16BCQLUZMrcgNLf+vbJCToLlqWUHptDHfLBCus60j7R789RSQk/
	Gxl8CVSU/and0a5McMr+oQyFgH3IdpxCOCVor/89W/uZHq/wjgIFlXDOa029a1E2dGbQuBlwTq8
	nfO2RiTZHHkTJtlakzXn6x1r7u9Ouzn0Dz6bicjEh3KwgASYLT/QR4s+itK/z+jKzONs5YrVjpY
	iervgNQb2xLrQ8wg5GFR0ZObIG9fRqREd62R9qS/BCw7eSxWNPmGq+Cdh1GGnvrnoV0Pa32+JVG
	GiGL0KimcUWd9ZE2SN0VzaS0JbpoOwCNVCajMFrw3kgIAymDCgiTdIropX+xNmxiGbWJug7O19d
	xfxCQrBGYL32UF4rc5JuMP380zZZrrlRDTUHmEpPMQjgHQMToYyo10
X-Received: by 2002:a05:6820:60b:b0:6c4:50e0:4e0 with SMTP id
 006d021491bc7-70356492b06mr7440160eaf.32.1792493039924; Tue, 20 Oct 2026
 03:43:59 -0700 (PDT)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAFcZKTyCu7K=1OOETBvVrKf-9YKHRk7wXNRyZW7m5P0PEPg1zQ@mail.gmail.com>
In-Reply-To: <CAFcZKTyCu7K=1OOETBvVrKf-9YKHRk7wXNRyZW7m5P0PEPg1zQ@mail.gmail.com>
From: Peter Morrow <pdmorrow@gmail.com>
Date: Tue, 20 Oct 2026 11:43:49 +0100
X-Gm-Features: AclHuK_ZTJZ-MG-SKAI7eH3l_zmO7EZx-WhALvbMgrcFjsGx7J0OsMIcUbiXYiM
Message-ID: <CAFcZKTzkDzPXpjFqU8c3rpY3R_FpD_tWRu=PPtkar_LCn1AsxQ@mail.gmail.com>
Subject: Re: mlx4: no ib device for Ethernet ports without IBoE since v6.6
To: tariqt@nvidia.com
Cc: petr.pavlu@suse.com, yishaih@nvidia.com, leon@kernel.org, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
	regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#regzbot ^introduced: 7d22b1cb9d84
