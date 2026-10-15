Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEC54D9F85
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 09:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792055100; cv=none; b=DDSP3zIL1ZplbNlb8v3m7hjiwNm3akZReG3TG3gVZ64+LKpWsf+TxyhdRm3y4BCIpkd51PgPb56+iEN0I9TYVtSPoXJEX+xJBPmSniMclub3E0dPxoFC16H8gCPykrdQS5spEduad9Ipaz07vyXC2ZrwooNTxCP67Ilb17MxOfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792055100; c=relaxed/simple;
	bh=0QAZacHpY7x7bNUlMg63AShglOMyvmFEaExWQiEPiTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ATiQ5hUDorkwbhZdvfGNaTPBfp7R4aVU86W3PQTqChfqm/PThlZtVejgY1VlRirF+L7yeYy5YTT7HH5f6KyfN2JimeooXe0pvxC59fERn5bnl8hJe0hdA5u1j/eu8tHoypjU1cdzFnkN9VDUr75yv0h+IHS5DYxPY84iTMAbJ2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Es3vzV6C; arc=none smtp.client-ip=209.85.215.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Es3vzV6C"
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd5cd8d89a7so1997968a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 02:04:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792055098; x=1792659898;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0QAZacHpY7x7bNUlMg63AShglOMyvmFEaExWQiEPiTY=;
        b=IuIvLrgI2UJuiIxKVWup/pFas6Ny1jTlgKGN+n49/iqR/QAKJiVJVz4pyXWDoL3h6Q
         bVttACTM8ahyid/TIUP5K1fM2AkutYF/cU9TOePRPQ9z1qJ0+5glIeuwQU7sEoUUUg9c
         UqCrv8IX2LlyzGi0NTbzxLEN4LwAjec2e/TrtuemASzOlSiEsV4bjO6Ik2Z06Ij/JigJ
         5vtXDKh/REwGFOPzPCSy1qRZbz20IksU9ptYOKcP6YSwNRsPLYOQw4T99EzWxrThgfsa
         ZJgxCIyzrBis4looMt0di7+q5AyeW5bVQzfT9/O9BS1i1AcRtQpBIHk5EA1QELCSLEY7
         9R2g==
X-Forwarded-Encrypted: i=1; AKwUvBx4IRDNjP2wCXtnP9R9aVHKEkfESaRQNc4RSce05483NnoJsrWiW2ilefai9hB2nfqyU2WMCsqpz21U@vger.kernel.org
X-Gm-Message-State: AFq9FYKOwLGVFydgV32JmyHYppDz92fz7GXnurqG2Of2g2n3gYP4HmQV
	tOAzN0zgkGiGtHR8nq+3Xe8uUzUXDiTuu479bTjlQAYQAysE/GbOtL629tG1mFJAZ00c6Ch4/rW
	w2T3hBjgnpnUw+1S8jDhnwlvUSii1IZs4sy6Y03rXJ+BgrWxVFqmy+bwfB4vXqGTLxNJEsPbRsX
	xocK2eaUkjbr51WvWAI47EFu14HPj3KfI6bk4F/aULolFK7hU/pxFeQNcKflCy0d5NM23oTUex2
	okwiZ8szPDPelRVc/MpTbCK8DsVmA==
X-Gm-Gg: AYBFou15ur05TDYxQw/gz234nwYfGFfE2VdV5hi9nWIxueoE8TatqBXENWcdp5/Izo1
	06iSWDSTMwogYflZrsz8TVcK6YRtP5xOMCuC4e+rjBmUxHijZOS6NEGlbAaPbendXREmLTfGbtu
	F9imve3wP4aIa4JrYVDIDaKd3TvX7Z5zWfdE5UB1jwDB2y66RJ9H/ihEgqFvzS2oUNEbLwVDgJR
	sHRn/IXD7KibShfZVxVB+nGB67yqsHD7lfKVjOURBLuLrTxWEiKvgWDCEJUWNXJFvn9xly57enU
	7YfwJiwd1eees3eOw7Kr/HAjZCmQohm6HQsnZUrQi3RfgDpjOQABI13vuen2TzCB3ykGuzPWzMY
	2KUucngaNu4kIngSAkuPsUxZcoxawgPgjNrVtGeN5RODceGh4Pc+EAm5qKR/9ARKgBeVnNmcHi6
	YUm/ENjlFaZH/RWFYy7tuHoIQUlBc71MrlQUInV1OXBtuMUoc3ZbY=
X-Received: by 2002:a17:90a:da85:b0:3ac:1c76:61c3 with SMTP id 98e67ed59e1d1-3ac1c767e3fmr8361316a91.27.1792055095544;
        Thu, 15 Oct 2026 02:04:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ac938038fbsm555293a91.3.2026.10.15.02.04.55
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Oct 2026 02:04:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cc4ac5feaa4so3449948a12.1
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 02:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792055094; x=1792659894; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0QAZacHpY7x7bNUlMg63AShglOMyvmFEaExWQiEPiTY=;
        b=Es3vzV6CPCJl4exSMTsgIyO7v0Pi6iNCpqW2pVO43ERFRl5pNG1LgWzpaZcGvfnNjV
         6UULTxf0oqF1/3ahr6UooiYvQXyjsXqLBYOnHCC+FnUP9i1Vp6jQzQlAdpop/GAIl11I
         XfJMaUY3W1DGBOEaq1ayCmNoq+dEQRMegYkBA=
X-Forwarded-Encrypted: i=1; AKwUvByiglnKjAmnqOqn819+gZLyAJ/5gPU15wDavFYXu9tYx8gDWh4fsEp+N5Dbzkxuf7NAl1EpCLMiswai@vger.kernel.org
X-Received: by 2002:a05:6a20:a125:b0:3df:c9eb:1281 with SMTP id adf61e73a8af0-3e16bb0af74mr13455560637.3.1792055093814;
        Thu, 15 Oct 2026 02:04:53 -0700 (PDT)
X-Received: by 2002:a05:6a20:a125:b0:3df:c9eb:1281 with SMTP id
 adf61e73a8af0-3e16bb0af74mr13455536637.3.1792055093391; Thu, 15 Oct 2026
 02:04:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261015080218.1102172-1-tariqt@nvidia.com>
In-Reply-To: <20261015080218.1102172-1-tariqt@nvidia.com>
From: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Date: Thu, 15 Oct 2026 14:34:38 +0530
X-Gm-Features: AclHuK-zWIgel_f0TcERdtOvtuYHYXvwJ3QlPaVGy1GOUdPEwgDQ6Qw4-ixrNek
Message-ID: <CAH-L+nPVwgf7PAXNec_1R15_yeq5FohUeNtbgq6J4aP9QVNMbg@mail.gmail.com>
Subject: Re: [PATCH net] net/mlx5e: Fix NULL deref in PTP TX timestamp
 recovery warn
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Paolo Abeni <pabeni@redhat.com>, Alex Lazar <alazar@nvidia.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, Gal Pressman <gal@nvidia.com>, Kees Cook <kees@kernel.org>, 
	Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>, 
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>, 
	Richard Cochran <richardcochran@gmail.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shahar Shitrit <shshitrit@nvidia.com>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000004e1382065ddd57b4"

--0000000000004e1382065ddd57b4
Content-Type: multipart/alternative; boundary="000000000000429875065ddd5702"

--000000000000429875065ddd5702
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2026 at 1:38=E2=80=AFPM Tariq Toukan <tariqt@nvidia.com> wr=
ote:

> From: Carolina Jubran <cjubran@nvidia.com>
>
> PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets
> sq->channel. The excessive port timestamp delta recovery path
> incorrectly used sq->channel->netdev for netdev_warn(), causing a NULL
> pointer dereference. Use sq->netdev instead.
>
> Fixes: 391dad2e686f ("net/mlx5e: Recover SQ on excessive PTP TX timestamp
> delta")
> Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
> Reviewed-by: Alex Lazar <alazar@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>
> LGTM,
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>


--=20
Regards,
Kalesh AP

--000000000000429875065ddd5702
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Thu, Oct 15,=
 2026 at 1:38=E2=80=AFPM Tariq Toukan &lt;<a href=3D"mailto:tariqt@nvidia.c=
om">tariqt@nvidia.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_qu=
ote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,20=
4);padding-left:1ex">From: Carolina Jubran &lt;<a href=3D"mailto:cjubran@nv=
idia.com" target=3D"_blank">cjubran@nvidia.com</a>&gt;<br>
<br>
PTP SQs are allocated via mlx5e_ptp_alloc_txqsq(), which never sets<br>
sq-&gt;channel. The excessive port timestamp delta recovery path<br>
incorrectly used sq-&gt;channel-&gt;netdev for netdev_warn(), causing a NUL=
L<br>
pointer dereference. Use sq-&gt;netdev instead.<br>
<br>
Fixes: 391dad2e686f (&quot;net/mlx5e: Recover SQ on excessive PTP TX timest=
amp delta&quot;)<br>
Signed-off-by: Carolina Jubran &lt;<a href=3D"mailto:cjubran@nvidia.com" ta=
rget=3D"_blank">cjubran@nvidia.com</a>&gt;<br>
Reviewed-by: Alex Lazar &lt;<a href=3D"mailto:alazar@nvidia.com" target=3D"=
_blank">alazar@nvidia.com</a>&gt;<br>
Signed-off-by: Tariq Toukan &lt;<a href=3D"mailto:tariqt@nvidia.com" target=
=3D"_blank">tariqt@nvidia.com</a>&gt;<br>
<br></blockquote><div>LGTM,</div><div>Reviewed-by: Kalesh AP &lt;<a href=3D=
"mailto:kalesh-anakkur.purayil@broadcom.com">kalesh-anakkur.purayil@broadco=
m.com</a>&gt;=C2=A0</div></div><div><br clear=3D"all"></div><div><br></div>=
<span class=3D"gmail_signature_prefix">-- </span><br><div dir=3D"ltr" class=
=3D"gmail_signature"><div dir=3D"ltr">Regards,<div>Kalesh AP</div></div></d=
iv></div>

--000000000000429875065ddd5702--

--0000000000004e1382065ddd57b4
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
tJVewHuOmXgWQxNWV7Oiszu1d9xAcqyj65s1PrEIIaHnxEM3eTK+teecLEy8QymZjjDTrCHg4x36
2AczdlQAIiq5TSAucGja5VP8g1zTnfL/RAxEZvLS471GABptArolXY2hMVHdVEYcTduZlu8aHARc
phXveOB5/l3bPqpMVf2aFalv4ab733Aw6cPuQkbtwpMFifp9Y3s/0HGBfADomK4OeDTDJfuvCp8g
a907E48SjOJBGkh6c6B3ace2XH+CyB7+WBsoK6hsrV5twAXSe7frgP4lN/4Cm2isQl3D7vXM3PBQ
ddI2aZzmewTfbgZptt4KCUhZh+t7FGB6ZKppQ++Rx0zsGN1s71MtjJnhXvJyPs9UyL1n7KQPTEX/
07kwIwdMjxC/hpbZmVq0mVccpMy7FYlTuiwFD+TEnhmxGDTVTJ267fcfrySVBHioA7vugeXaX3yL
SqGQdCWnsz5LyCxWvcfI7zjiXJLwefechLp0LWEBIH5+0fJPB1lfiy1DUutGDJTh9WZHeXfVVFsf
rSQ3y0VaTqBESMjYsJnFFYQJ9tZJScBluOYacW6gqPGC6EU+bNYC1wpngwVayaQQMIIGtzCCBJ+g
AwIBAgIMEvVs5DNhf00RSyR0MA0GCSqGSIb3DQEBCwUAMFIxCzAJBgNVBAYTAkJFMRkwFwYDVQQK
ExBHbG9iYWxTaWduIG52LXNhMSgwJgYDVQQDEx9HbG9iYWxTaWduIEdDQyBSNiBTTUlNRSBDQSAy
MDIzMB4XDTI1MDYyMDEzNDI1N1oXDTI3MDYyMTEzNDI1N1owgfUxCzAJBgNVBAYTAlVTMRMwEQYD
VQQIEwpDYWxpZm9ybmlhMREwDwYDVQQHEwhTYW4gSm9zZTEZMBcGA1UEYRMQTlRSVVMrREUtNjYx
MDExNzEYMBYGA1UEBBMPQW5ha2t1ciBQdXJheWlsMQ8wDQYDVQQqEwZLYWxlc2gxFjAUBgNVBAoT
DUJST0FEQ09NIElOQy4xLDAqBgNVBAMMI2thbGVzaC1hbmFra3VyLnB1cmF5aWxAYnJvYWRjb20u
Y29tMTIwMAYJKoZIhvcNAQkBFiNrYWxlc2gtYW5ha2t1ci5wdXJheWlsQGJyb2FkY29tLmNvbTCC
ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOG5Nf+oQkB79NOTXl/T/Ixz4F6jXeF0+Qnn
3JsEcyfkKD4bFwFz3ruqhN2XmFFaK0T8gjJ3ZX5J7miihNKl0Jxo5asbWsM4wCQLdq3/+QwN/xAm
+ZAt/5BgDoPqdN61YPyPs8KNAQ8zHt8iZA0InZgmNkDcHhnOJ38cszc1S0eSlOqFa4W9TiQXDRYT
NFREznPoL3aCNNbDPWAkAc+0/X1XdV1kt4D9jrei4RoDevg15euOaij9X7stUsj+IMgzCt2Fyp7+
CeElPmNQ0YOba2ws52no4x/sT5R2k3DTPisRieErWuQNhePfW2fZFFXYv7N2LMgfMi9hiLi2Q3eO
1jMCAwEAAaOCAecwggHjMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMIGTBggrBgEFBQcB
AQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQv
Z3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYtaHR0cDovL29jc3AuZ2xvYmFsc2ln
bi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFwwCQYHZ4EMAQUDAzALBgkrBgEEAaAy
ASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNv
bS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29t
L2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwLgYDVR0RBCcwJYEja2FsZXNoLWFuYWtrdXIucHVyYXlp
bEBicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAUACk2nlx6ug+v
LVAt26AjhRiwoJIwHQYDVR0OBBYEFJ/R8BNY0JEVQpirvzzFQFgflqtJMA0GCSqGSIb3DQEBCwUA
A4ICAQCLsxTSA9ERT90FGuX/UM2ZQboBpTPs7DwZPq12XIrkD58GkHWgWAYS2xL1yyvD7pEtN28N
8d4+o6IcPz7yPrfWUCCpAitaeSbu0QiZzIAZlFWNUaOXCgZmHam8Oc+Lp/+XJFrRLhNkzczcw3zT
cyViuRF/upsrQ3KY/kqimiQjR9BduvKiX/w/tMWDib1UhbVhXxuhuWMr8j8sja2/QR9fk670ViD9
amx7b5x595AulQfiDhcN0qxG4fr7L22Y/RYX8fCoBAGo0SF7IpxSukVsp6z5uZp5ggdNr2Cq88qk
if7GG/Oy1beosYD9I5S5dIRcP25oNbcJkbCb/GuvWegzGfxCCBuirb09mTSZRxaBmb1P6dANmPvh
PdqGqxfFrXagvwbO15DN46GarD9KiHa8QHyTtWghL3q+G6ZHlZUWnyS4YMacrx8Ngy0x7HR4dNdT
pqAqOOsOwDmQFBNRYomMdAaOXm6x6MFDnp51sIWVNGWK2u4le2VI6RJMzEqLzMZKL0vTW+HPqMaT
hWv2s5x6cJdLio1vP63rDxJS7vH++zMaY0Jcptrx6eAhzfcq+y/TkHJaZ4dWrtbof1yw3z5EpCvT
YDxV0XFQiCRLNKuZhkVvQ8dtmVhcpiT/mENrWKWOt0DwNEeC/3Fr1ruoyriggbnRmBQt1bC5uxfv
+CEHcDGCAlcwggJTAgEBMGIwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2JhbFNpZ24gbnYt
c2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gR0NDIFI2IFNNSU1FIENBIDIwMjMCDBL1bOQzYX9NEUsk
dDANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQg7tn9hUj/uH25fn98VCiBKfIxLSSe
HyRZMJ5rW4nrURgwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjYx
MDE1MDkwNDU0WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgBZQMEARYwCwYJ
YIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEwDQYJKoZIhvcN
AQEBBQAEggEA2PKa9p1bEzS8MduOL58alOy130RwnSMwh7kNh03Yj2HLAp3a6uhla97LUJKLoxxe
mSKQWiOxzZZp9L9uf/FUVZqEL66O9Rppw8US75Ztu9oqzenJMRtETU3A9crsDcp4rUv85EzlHbeq
QB/jHLQ2BFF9zpy1Mm3JY8mVE7NWJeKouJ7d733a8A2Nh91tm9fTlZQW7tmov8lx0T67MO6Bpes8
2aMdFskbfXHBMuDHClTdhxt+TpT5NW+KkG+YBLh3onxGO0ceeh2PdWA6TzfxyOeZhcO+U7LhnxNk
BDXggAOXWPsX7huZF3QFso3JzsgT6TweoXXHhpS04/sNYzR5Sw==
--0000000000004e1382065ddd57b4--
