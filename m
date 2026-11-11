Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.100
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415546;
	b=v8nkrvpmNJl8QTFSdZvCIg1of6+qNq6UYDmEp+pPO0/Ey4OvjmNKO0WOjwQ0JOaZ5259
	 ydGcv1vFRrGPRl01OsTh8SktktnP5VoBrOa6rT95yviqh7Cy6W3DDclCj63sBdgFMwabM
	 Z2DeDMaMVLn9ijUeRfU5dVhhdNYAH3dKCld1kfRv6oBeeBs9NEBY6L1qM41PbkgXQ5zNc
	 U+DtUldPAHR/kjx8SSHmVjcK1cSRwRt7syEwHjS6884zK0Om/CSZ1nbC5RTbwvzKJF+Jm
	 ZpUUff0vytEhugcvJrE+Ti1kgAGaEPzap1dWPHwx7bg92RBzYBe84tDMJUDdWpXi/nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415546;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 X-DetectorID-Processed:Content-Type;
	bh=i/JhY/DPRKUXwnm97GxHHFi0jtOKIa2qbrsaUWchw6Q=;
	b=vSAY8fKKutbyDYisxIXwS/Kg5hGBda66BK0WjErzycEvXsMZ+Xu2558rhThFG/xhYoMC
	 GFppvf/N75bS6wy3WapNHYtkJmbbWRAGBVtFWZQTNFT1ciy1hiPnJt/HrGncnrz8p9oP0
	 9FE/NcAUqnw8YM3tzNHQMdejnoJOjqIqjVz1wreyQQNB4S1NXaeXhR0/s+3pQBsY7lYzl
	 lRtAMEl0cjlxbkIniu4B67mAiFtM56MnTX4bv30dJPtJAnhqwTt3Nl3GQVEhD2Ui0NO0Q
	 mvibojFPwX2YvEuWrhuEd2A+VdcdFwLTGoqDp97LDQ3+xRuKyjfO/wZxtqGfcS2ERBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="T0/ZXPc0";
	arc=none smtp.remote-ip=209.85.216.100
Received: from mail-pj1-f100.google.com (mail-pj1-f100.google.com [209.85.216.100])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C8A606A321
	for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 16:45:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24C8A606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=T0/ZXPc0
Received: by mail-pj1-f100.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso1564510a91.2
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 08:45:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794415545; x=1795020345;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:dkim-signature:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=i/JhY/DPRKUXwnm97GxHHFi0jtOKIa2qbrsaUWchw6Q=;
        b=Zlx8FB/2V/413whYIcHwWJXZmKI5U3w0gon7rftpQeAPRXVs7U/ss8xyMzMXpejcd7
         FW/WpgGG3bEKTr48IrDr9W8pSLWPbz/fiYn5dCO8JREtMwClBZ5hH+pua8vib7PN6vR6
         KMfvlKV6LXJwlXbdN+54tDb8embSnj3sU7v8peVKQbzVVDRVHmW6MmPTY1+BqhsULpcD
         FMpHU4J4e3eXVs0WGHefNmmUGchNJPhQAFY0dE75jZVkw3602zDWoEQuArMXj0m/tRyD
         b8zJnU4ATMXKhiF0xXWC+t6cL+TDXFU4ZGISjCcV6zs4vudZdPFquqmJc+PrIUNBW6NG
         gYcQ==
X-Gm-Message-State: APuU4Z+TN4Rr4kTPE+OJtD7fkRH5n0v1DXUY3Pl91CiHcH5gmL2D/A87
	tRl9j5HAFKJ8zIouzKADrkHzfyvKOgLjxswwFaW+AXPSHqd4zQd/fmnVY+gQhOE8IU+lY2l+NNt
	Bi6B1Ucw4Jm9/JwrEjdxYOfilOY8GoLVGcFsvWLCUK7oxU+ddFxv3Zlrcu/uFM+PKawyXo2YMhO
	RwVisTqQn19R8St8HyLqXH0A3lrhneYgbIX2NPfu4Gt1RmouVPl0OgFURIsZRUBTwz4PQ/mBULF
	BJKSwHW6NrWTw==
X-Gm-Gg: AYBFou0AyJEQ8rsxy3lhvtim/HqUzJHodC7EzwaQxhw1eXZeZ8oWgGayKBJPXcW+1Yn
	a4nVOqBmLwnoGN/7+ys1bNPBJ1E+T1UrTjnxopdLRKqd5ry5sWROB37EVqSX74s1Shrvdn8UD8S
	nEr+C8djbQGZp/XdUQ1sKtn9avbRuLCXX7T/Ic6zOQ5pTStQRIZhJ9X0xF31vCPiXGVXwUMf4Ze
	MfMFuUzUoDnxt49yA26do7gigVYdG+/ZPeINNBHZEn+A1zrPTSASXq0mK4pLMRmLNEDA5WnRfzZ
	bMazXebhTuK4hzyXhDZZPZxZIi+diR15A4qFckniwPiBa00aIeEfpdONyPEU+48JWNnl3UzHlcn
	1JjbliwA5jFZ0+4tPc2UnqHfVHq1ma8QNMv+uaepHvPZgMpC/GjdqlUW0nQpc/av14PSrydbwgY
	aYXspk0NlSLaXEmr9IwFG53HmuA9dF1eLz
X-Received: by 2002:a17:90a:af82:b0:3b1:8300:f48e with SMTP id 98e67ed59e1d1-3b18300f510mr2265554a91.49.1794415545170;
        Wed, 11 Nov 2026 08:45:45 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b182daf497sm846593a91.2.2026.11.11.08.45.37
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Nov 2026 08:45:45 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c505f26e9e1so2337766b.0
        for <linux-rdma@vger.kernel.org>; Wed, 11 Nov 2026 08:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794415536; x=1795020336; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i/JhY/DPRKUXwnm97GxHHFi0jtOKIa2qbrsaUWchw6Q=;
        b=T0/ZXPc0hp30qfcg0l1JousPeadr+IgMQBVfIlmIAWxba6NFSuNuVeaXXwhNzWkZj/
         uUUdRrqrj+ZfofqpqH/Qm9l7nRV78x2SZ9eHZu4JAquQalqiJfYHGgg69i1cAOqEgVlw
         Z9YdaPM0u3j9Om09Jv9KVnOLzgirI9o8S/rng=
X-Received: by 2002:a17:907:968f:b0:c48:a838:c17e with SMTP id a640c23a62f3a-c507beb9d7bmr333966b.14.1794415535550;
        Wed, 11 Nov 2026 08:45:35 -0800 (PST)
X-Received: by 2002:a17:907:968f:b0:c48:a838:c17e with SMTP id
 a640c23a62f3a-c507beb9d7bmr295466b.14.1794415533460; Wed, 11 Nov 2026
 08:45:33 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-10-3e7e7ffed2e9@broadcom.com> <sashiko-outbox-206295@kernel.org>
In-Reply-To: <sashiko-outbox-206295@kernel.org>
From: Eric Davis <eric.davis@broadcom.com>
Date: Wed, 11 Nov 2026 08:45:04 -0800
X-Gm-Features: AclHuK_zk5fGF7F5JcHcXH2jvh53R9zGJ1qlYQ5QPhowCLVs5EHuLxh5tO15w_A
Message-ID: <CAMouMY+ZBuH2Jz95hyGePx5xbzw0rT4Wj-ZswuF=U2caOF4t+Q@mail.gmail.com>
Subject: Re: [PATCH rdma-next v3 10/13] RDMA/core: queue pair attributes for
 unconnected transports
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000009b2599066002ecf3"

--0000000000009b2599066002ecf3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 9:29=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> Can userspace bypass this zero-size ordering check by omitting
> IB_UVERBS_QP_SEMANTICS_MASK_MSG_ORDER from comp_mask?

Yes. The check reads the requested msg_order, which is 0 when it isn't
selected, while the driver keeps its advertised order for an
unselected field. Nothing is unsafe, but the driver can be handed an
ordering with a size of 0. If there is another revision, it will test
the effective order and size in create_qp_semantics_check(), taking
the advertised value for whichever of the two isn't selected.

> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-uet-ib-c=
ore-v3-0-3e7e7ffed2e9@broadcom.com?part=3D10

Thanks,
- eric

--0000000000009b2599066002ecf3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
THSLCC9N61nO6/woOMp7U0lttATSMIeibGPNnU8AizWyI5DxXKkIG5jv1EosjdJwBsJ8ZntvpfIx
+KplEkYfqN7Sy+7LOzXXkl5KhTkDELRuftv+sahPNzVHW1cJgj0HjMb1sCrFjzcAuO27JA4geQXW
cl+gyZDv53xtHnMSNmIoqDEINo4yoSHYPGK+cTtGC4K9a6yCXdP2zyLkkSQtZ+hEUOru4dQ1gIZf
4bWVHOILQGaMbqVAVA1OrjpUNGktgz0CAwEAAaOCAdswggHXMA4GA1UdDwEB/wQEAwIFoDAMBgNV
HRMBAf8EAjAAMIGTBggrBgEFBQcBAQSBhjCBgzBGBggrBgEFBQcwAoY6aHR0cDovL3NlY3VyZS5n
bG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyNnNtaW1lY2EyMDIzLmNydDA5BggrBgEFBQcwAYYt
aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyNnNtaW1lY2EyMDIzMGUGA1UdIAReMFww
CQYHZ4EMAQUDAzALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgoDAjA0MDIGCCsGAQUFBwIBFiZodHRw
czovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzBBBgNVHR8EOjA4MDagNKAyhjBodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjZzbWltZWNhMjAyMy5jcmwwIgYDVR0RBBswGYEX
ZXJpYy5kYXZpc0Bicm9hZGNvbS5jb20wEwYDVR0lBAwwCgYIKwYBBQUHAwQwHwYDVR0jBBgwFoAU
ACk2nlx6ug+vLVAt26AjhRiwoJIwHQYDVR0OBBYEFIjgxJwMJZ5pkTAB1796PUvJ+W7DMA0GCSqG
SIb3DQEBCwUAA4ICAQCM/INVouXcD/gHdJNCPtF31BpLUwHGTj4BlO4083w8xuxt0iSjyb0EKv7S
LBz29Dw9scSTMRS/sY9dotjJ03vVvzceiGB4FbMIZNSKHTy1PTNu0oZR7TwhBEEZHC4RtST9S2hU
MvDagOAWRM/56PG6FH2i7dnhwtcnsBX8CMeVJQc6SB21LuxJVqgULli/kbrkr1DBVMh2f7oCFHVu
0VgtvRtACeQVi7ny8wspKNV/WXN2IqT06c0vtUmFUPkidlgGxMzYCfQXbXcE3YvA7+xYqmCY0zdQ
f/ira3VJoAytznhfRSBRV4gmlChdSg8yoaM6LHNE7igDDqhVFT2QCqkRkIcPOCQYxNE4kViiDKKo
3VFnREnYmLzRbJkdGY4X3m+N7HOU8R99Zeatx6hN02eJQH1vZ1J9cH4SqxuqDxKi05n3SGE7J4Wc
oNsgfaIDL28JX+2JBG+gKr/vvjocja5y9G43gvIOs9yEzGBt91FCuuwPedXIIREUcqJtq6+MOvAq
ZMEsct9jQXibihTD7z9wLTIkXqOHumCc6f53zhsQCRofr8m7Tm0YrckGCHd0BowU12A6oVax5xEQ
6j1hyszkhFPrlLKAlaFU7VuIwlcjKvN9XYrmOfXfTnYoVV6f1IDwhgbtJNlKnJksqoCzfsbAVd0e
usA704DOznTCfAYJqjGCAlcwggJTAgEBMGIwUjELMAkGA1UEBhMCQkUxGTAXBgNVBAoTEEdsb2Jh
bFNpZ24gbnYtc2ExKDAmBgNVBAMTH0dsb2JhbFNpZ24gR0NDIFI2IFNNSU1FIENBIDIwMjMCDFfq
Ldxf930IzIe8izANBglghkgBZQMEAgEFAKCBxzAvBgkqhkiG9w0BCQQxIgQgiRdYGKYeLFG5lA1U
qJ2t4RA18d3inhVwy6TmS14wJBUwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0B
CQUxDxcNMjYxMTExMTY0NTM2WjBcBgkqhkiG9w0BCQ8xTzBNMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBBzALBglghkgBZQMEAgEw
DQYJKoZIhvcNAQEBBQAEggEAQSTZgazZKns14kj/5MnCPNvjoTyul+qbq69A7zGWISpU9+NWuu8n
cZ7c2TQ1Mti+sZFDdNiw5mS5HkFrFiACG6Z1jlQz5ja8JRxxUVNQ7ee81oujPDgZKdzfI0JR8inO
WQHOznWhAfdZdgf50qiAP22qIzgeya+1CSBQft7N2SGXGVBbpJtv174gfmH+cX8nJIJ6Wrky+j4y
susdjGeO7ZDXQ0yg/8ucXTwyGv8u86Y6LTyb8SQyxV0VHu42uFQDoyVAeVuquBBTXF3BOT1eQgMH
xM3Ycwnt4p/Dfa4+m0+xQzfg1QsWdj77Xtv3H69hVGeDMrLIC005dCElKROKIw==
--0000000000009b2599066002ecf3--
