Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfRLzyXi"
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE48D5
	for <linux-rdma@vger.kernel.org>; Wed, 13 Dec 2023 08:07:32 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-54c4f95e27fso6701780a12.1
        for <linux-rdma@vger.kernel.org>; Wed, 13 Dec 2023 08:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702483651; x=1703088451; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bJCfDWC2EFhLReWxLdBYM+2cIxiaH3BWxURDUTjfE6o=;
        b=OfRLzyXi1Ww71K2IMwY+aORKkpMuTfKTkZwCi+5utMMsaTDQ5nPmsK5I69z+OUuBWi
         IvYiy3sNxyQHG3dDJDQhq9ZIXvPag5rfqOwLmxDes3KTJ6Rs8FQYDgICWJxHs/weAnmV
         aQY75gQ+JROodI9bdAb+bAXiWLPf1OLqH/aA/Cjiwn8Y2Asox+HLoBh9znHgfA5xG1tA
         KyNSmfCyGOcQ34+iLBZzYcprmcN3+c7rDdSCx2iKNkl8MNHAuuh4IFMsCObJkk3/cnM+
         dFUnLx31g2kX7GrcSX7yD+ixjg7u08nPIDT39ai696K4z+0l85abH9qLUc0dRXvl2Rbi
         8SRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702483651; x=1703088451;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJCfDWC2EFhLReWxLdBYM+2cIxiaH3BWxURDUTjfE6o=;
        b=YhhBJdSGSvortqwMfYPOOJ5tBS5Qw43HfLNOetILaVHAeJRhEDEGPmnXEovaYk5isD
         OIQZUpw2nCIIk6SXXcnqmnd7toTtm6AaGCCthqcpkM81DelTcdQWy3RhfVIPpxGCSYIt
         T2WqOp1LAJme/9GJdhG/cA7bi3oFYj/dCpZqAvwKJ/1J5qatsJjWgyjPZbuAxoU7fJ3l
         c22juzz2GCxe7275G1YQEZHMAUcqKyGlwBWXPS65mNhHjNDCph8hWgto/kZG2BjGPFHy
         /HkDDLUMrJe/H4TfXQX6ME2QvInQpN4QvnArLyjKzlLTcXatJPxEQlkFymdalDjNDIes
         1Ocw==
X-Gm-Message-State: AOJu0YzFx7acmpjBCyI3VIgY96t0fqO0nT0K/qz1m92CehjVlQm0UFWc
	s2WvcNVzQ5oTM74/BRs0gct48EMdxMw9LXzKOKvZ0VdpMVM=
X-Google-Smtp-Source: AGHT+IFfsQtOnr7SUqqLJtZW2K5PWHdE/0myQMi5Q/pLII2vwDgRDiOxC3bKCEmZevE/lxXVIrUZjT8JtSgJDZ4rJ1U=
X-Received: by 2002:a50:cd11:0:b0:552:5c27:38c5 with SMTP id
 z17-20020a50cd11000000b005525c2738c5mr54637edi.38.1702483650546; Wed, 13 Dec
 2023 08:07:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Arka Sharma <arka.sw1988@gmail.com>
Date: Wed, 13 Dec 2023 21:37:19 +0530
Message-ID: <CAPO=kN2giA5U9kkmag_jXHP-WAUquWktqa_arVdrRRqY0XTXSg@mail.gmail.com>
Subject: ENOMEM returned by ibp_post_recv
To: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am using MT28908 Connectx-6, and running on Ubuntu 22.04 with
libmlx.so.1.22.39. From my application which is posting a receive work
request I have no outstanding requests with the rnic, and I am
attempting to post a receive work request, I sometimes get ENOMEM,
which based on the verbs docs indicates queue full. I tried running
dump from the mellanox firmware tool but couldn't get much hint. Any
pointers would be appreciated.

Regards,
Arka
