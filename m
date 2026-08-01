Received: from mail-lr2-f7.google.com (mail-lr2-f7.google.com [74.125.230.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A404384250
	for <linux-rdma@vger.kernel.org>; Sat,  1 Aug 2026 15:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.230.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785597987; cv=pass; b=Z4YmFisVMajDdQo8p+VtQDLo3ENC1Vk6M7WR4o3gdm1FgOXmt+H3BDfcqFeN2MZMmQ/tPCZE0+ZqwKjjREj4NuWtZH2o+i8+Rfs6ZQtMynZabC9rKmu6ATisfWAPECAaR19N9VhBZHLoIXdvR7zalgEWM0mdua1xzaom+jImVMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785597987; c=relaxed/simple;
	bh=hqMGXBauZwF9RlzHCbamAJPIDmhh25RDupjSoy7HvCk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=tEzNxlsmbVLrU30NAptQJylcIlYWfJ04aOMg5QbKMrhzRD/UZHLflrFAZRcx/UVXAgnk9a6fQPmPWflV1TRziLU1haOHy5o6G8c6pYodfWafaXe9VGx0jgqOLkCpbyXTAS6f+/IkJiYwcZwkDjZWePDuR8tsBUrJvBMDhPSWfrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WEmTGI1Q; arc=pass smtp.client-ip=74.125.230.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEmTGI1Q"
Received: by mail-lr2-f7.google.com with SMTP id 38308e7fff4ca-39c689d1d48so9356621fa.1
        for <linux-rdma@vger.kernel.org>; Sat, 01 Aug 2026 08:26:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785597983; cv=none;
        d=google.com; s=arc-20260327;
        b=a0eZc1d5KEUgAvv55axokrRUh7NXF9qJZflC0zOrhASXaVGCKORaeTLwllpmR5Zewa
         kDnEqPgu/Qw89ptf9N/q9HIQp8cgmgU/oIBH0M/gOIpAlW9aW5qPNBsIqr5vrv9Hs9DV
         JbMA80SK0XdEUwyaSpsrr5CoiaJgscYrzv869hPo+2YStsJAfrly+9cEA+ZptgOasSv2
         wUFkqnsXOS2p7dZjHC7t6OHTf97beJxhl0MwH5MBCZV8XuBcoLhDLEFXZ27cQlq3+XaU
         G5/TWzz2tgvSV3I6IU0ZJf6DXRfge4IeTOu/UtCvV8vrZlllx5nR1KOj37b6WIUTkBuV
         77lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=hqMGXBauZwF9RlzHCbamAJPIDmhh25RDupjSoy7HvCk=;
        fh=kKD4ZcK7EiBbpPvy8fBui+gbh4y+MCKzWSOkLnEd924=;
        b=M3vMEWjUwxpPcHLOsMSakvbk4G+n1ax2p4tKez7mJ49kfY6OjA6KwfAdOHYTAZMzmk
         0fYueuRQjuGzHqCYN2y93iRZn87RLelQRevM4LFz4oSbgyETvf6ttYEmEVYhL5utfePV
         DKUyi0nuTqshsBmlQRXVPcYOOEOFQIEu7f2pdvMqXPk6ScZsGwsvbqAFiWKit0LB8dQf
         d9PAInR/D15lD3pBhO9+g6egu9Va4TRtih8mzL7dQAbeoBuLqtllJWzVjJLon0qknPie
         28799TBnLszAC87QXf/I3SIu+OuxPej9K5rEwtMeL4dCdSAU3tU45q2tgRefp601Vo/6
         WeHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785597983; x=1786202783; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hqMGXBauZwF9RlzHCbamAJPIDmhh25RDupjSoy7HvCk=;
        b=WEmTGI1QxjJwaq/ul1H0YjnLxLRxMD2JZapY/5lkZxUPt19iWzYJUZmjohMZryskra
         6is5i9UZcM5DRWJ26FFeScQ3e9HEX/O+7TWX+fyH9QlXhkwyG57qJ5o3l8BwJMxzQk11
         rGxqfN0xlPWm8tQ38lkBGC3Qzq1ZzHliYjE6yeLmTzxHpeFkYiAa9b4+xqc7PO83m5AQ
         kn3DFR6IN5nDHqayh9US9VhpbyU1ahzVsQcrGeLZX8iNk16/97u5PZHtn9m60C1PI8Id
         t+toSPR8XP5D+2K4Ip/2E/1A9jyCMsygbRZsMqMINL6E6Hb1fihmtT0K8X5ufOYVMuWA
         e8vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785597983; x=1786202783;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqMGXBauZwF9RlzHCbamAJPIDmhh25RDupjSoy7HvCk=;
        b=NMYAB7o4ZtH0DiDl3B+2rYsy6Poue0L9ja1dVvvgdaUEBloZQ2dr8rm5Rw4q4BLVsk
         36fmG/Kc0jHcpI8pF3tUPFAcjKZ46ngwQ1b39AAZwpF6eEfXKRsHNS3v5wA9l6B9EkeX
         ChlzWvdpFLRBtsRiF3edIueuMMllM6APELbPMh8THvj/egGlZl3ZKCAx2B6MrCTdur8K
         /9qp1wAj5dRWOnh2I3qRaU1pAsPgpxslW3T4P7Yt+KTudvTWy97z7GkclVV/vAuKyy3v
         wNrW8J6fnFrEFFZfNkkXvY+QuHyIZ32brUFdwe8VkCCl7Xx+IhVVsEuVz6DxjOksQl3y
         7XQQ==
X-Gm-Message-State: AOJu0Yy4k13zbh6vb/tqSI7y4B8U2YHo5CC/E/SR/yQ14nqFmQudFo6P
	6AjHtUUSQH/mzT7nTmPh/w4Co0os7yIlJoyXwSrUPG2re6Xa16UI0qRPLvXzBa2H4Zd/tR9H/JO
	DCGMj8+stUS5uDRCePZDWpyMc1C2cu4XlJwYO
X-Gm-Gg: AR+sD12bh35kAe6nnI/NFKzQSwODBRLKOY93xT2dM6fLNUlk+jpascKQUxb77zA8epp
	KGMXTjC0FuTi2Q/GinTjdXQRVmKbO7uV7njrueDmVzncw1jvq006+TCUSTRsRurio4X7djCgCKq
	3naK20LaqgWYt+9nz7DuJiSVCes77YA0wpseOUia/jM6fxA5tf+NyioU9dNnJkiN9HtigZoCgp7
	1W/vJflwehHRBfQNXYRRMEstqceJYXPzJqXbrr6kv/nD9Ur1xD6PSrJ8WilKOxI1p+zjWKqhoHk
	bZQZSrtJenKGHFEdIMnEY36ObYjEqgFIFQ2BRRq+9XEDBOO5uT0roRkPrc9xTUD/1oS7BNX3N/3
	uh+v5T0bSx/Y2qkkpq7kdOKJtFLBgSl6KzozH
X-Received: by 2002:a05:6512:33c6:b0:5b2:a321:94d5 with SMTP id
 2adb3069b0e04-5b2e4f7d9e9mr887096e87.42.1785597983258; Sat, 01 Aug 2026
 08:26:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: alu a <alu021031@gmail.com>
Date: Sat, 1 Aug 2026 23:26:12 +0800
X-Gm-Features: AUfX_mw0NmJAZw03o_JlwcFsxr0GoRfbokf0Dk1pUrPUgqqvcoo7HkLKZBprCGc
Message-ID: <CAH+L_5b2KKrm=BaNeUhWGTBkC-8U8JydMS4f5K4+13YbRgT+Vg@mail.gmail.com>
Subject: [RFC5040 question] siw: RREQ with payload is dropped without Terminate
To: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

Resending in plain text because the previous copy was rejected by the
mailing list.

RFC 5040 Figure 5 says that an RDMA Read Request cannot carry ULP payload.

On Linux master commit 8ba098e6b6ff0db8edf28528d1552be261af30d4, when
the MPA length leaves bytes after the fixed RREQ header:

- siw_proc_rreq() returns -EPROTO without calling siw_init_terminate():
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L624-L638

- the error reaches the RREQ case in siw_rdmap_complete(), which also
does not initialize a Terminate, and the receive path then schedules
the LLP close:
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L1318-L1323
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp_rx.c#L1460-L1470

The close worker calls siw_send_terminate(), but that function returns
immediately because term_info.valid was never set:
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_qp.c#L340-L378
https://github.com/torvalds/linux/blob/8ba098e6b6ff0db8edf28528d1552be261af30d4/drivers/infiniband/sw/siw/siw_cm.c#L1119-L1129

RFC 5040 Section 7.1, case 3, says that an error detected on an
incoming RDMA Read Request after DDP delivery MUST be reported with a
Terminate Message:
https://www.rfc-editor.org/rfc/rfc5040.html#section-7.1

Based on static source analysis, this appears to close the connection
without sending the required Terminate. Could you please confirm
whether the bare LLP teardown is intentional because SIW considers
this condition to be detected before formal DDP delivery, or whether
this path should initialize a Terminate before closing?

I have not reproduced this at packet level.

This finding came from an academic source-level RFC consistency review.

Best regards
