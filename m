Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795356408;
	b=B7v/KF+qTVcwUZyodFHeEBrA2XuoT0mY7n+BiDebYSH284IUiY0alIdURo5gkG6QdGQs
	 q3z/JM6FfgKW2ysvwPmqI4Gjd2Grs+Vn+kvV9mK156M5la7wQfzMpH22YGkMIH7DTIVsA
	 vYTIJI7Y1XV3NL+AI8lB9PmKyathmdpE9IglOj1gl64eQ9WxNVagd9PgJ/hbsfU5BXQvi
	 uPqG3colJAh/1xLPzHrOmQX7oEfgUmuMyoClTE7jY5nR8cFbzeNBme5HeYX6YP7skv/K1
	 RYFnA9E6B2HUK56r2rgHrOq6ucwzX4vgQYAhiRiONt9FYGi3+HROuI6WTf8ECbZxmLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795356408;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2P7NnlFD6hf0e/Q9nUMush5WduoVnm93NdkP6w446kQ=;
	b=QdEIlXPQOHL85DE9xtEEN5USV2gcL9TlIyqgOsAGnkb0W0RoHdcV9Bs2W10u4CNsr3uD
	 XsZPE9gLzg9L20ru5c+Qv2NWSk6VtVJIAwvMqSAKTqkJbMKqKnoPUnOZ1LUeooao5YdxP
	 gNxm7xP6ShWQ0QPq7yfprgPibVEw7kCSCZ+Jvh7hILCnfj4qtdpf3FrkrhtZMQCF06+y2
	 C1kDbhHkbX/Sf2KmBK+TG1F+/9EnGU+qhPVAEuabCS9wmPs03jtLwaoIqbX05KcoSdxNU
	 B8yqMSjWbcG2xuCVOK9SXminW/X4wJfNwTHhnYgJ2Hscvx98KKnbLJRuyk6FvVEbZJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=jd6ioXn8;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B52F606A32A
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 14:06:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B52F606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=jd6ioXn8
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b8a52db5f9so2710814a12.3
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 06:06:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795356402; cv=none;
        d=google.com; s=arc-20260327;
        b=cfVSp9xovnKTUd5eHjCQtOPW71nkOcv70zsCJxnstMQmGLXxMO9qeNg0bKiBigS7jD
         EMacU/5fM9ayQCU96QAmWnnJMJy4Rw+FrgS9R137a7xByJY2ZdTL3pBBC9k1LafCyHNb
         A2MSAcVVxCmHRvUZvBN9saFy/FExeVsUbDsx3s+L59q8KtDGj2GMokhnwB/rnHD6lOvb
         OLSWM6XL3HnMy/lb1GABc8eTRymwU/zsYljgcnTvNRlvClSFBSwUfwKVhQ2tSleyZXZB
         KDPYjAo/q440E6SKcyLfNSL1Hpx5KV+6JtlJw4OuPjY5//Ic4/tDAKBKUU6HqUFIk+An
         /G/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2P7NnlFD6hf0e/Q9nUMush5WduoVnm93NdkP6w446kQ=;
        fh=njVdtrvWd+l8UxLYbxOKZ7ITmKrcuHQfPWxDURL6DOU=;
        b=JZViS6czydgEbUO4jAlvrgVdef3zIXkLzUnP10MTgWbwn0cc6oFyeSnduZxwhXB/bi
         DiXk3la+aNDA29b2/i+4ilRwOvuWQBk0wLFS6FG1MIACS28iyKgHp7KZbxRiKs03nVG3
         eOPAomSgnhs8BgjB/mbQ5Z4sIbKisQOmQCrcwyK2BR5+mdNrtYAR88YqfT30/1com9QE
         tNb9XoaA7haeC0C0xjBL2bU8Sjgi2Y5R4TxpTMdLHEeCJRc3RNw5xerUFiUrnp7QynwZ
         SodqnOh8W4+svwjLpdSKy4dTArb1pXqMFSGLrrBH7Cb+iw0zY5mnjZ9OSK0guZkiYuRa
         qY8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795356402; x=1795961202; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2P7NnlFD6hf0e/Q9nUMush5WduoVnm93NdkP6w446kQ=;
        b=jd6ioXn8/jtSW042HF6KtWbUIW3aLVlunRvtvFxC7uBtabqLQOB56p7GCu61HgF+jL
         4ERHRbTjMX6muoegMifIFXfcQpMaYLcR9pm4TCKCc9aC1Ms59nBdWl4/K4XAtvpmeVvU
         7vZ2oZxiLbMOCF+o/7WrDrg7xXGtpTH1ohREQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795356402; x=1795961202;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2P7NnlFD6hf0e/Q9nUMush5WduoVnm93NdkP6w446kQ=;
        b=vqYpdcNJZE/m6fvAzKyhqawS8qBbzPaVY/8NEK4vNWTLBwyAExMaOtQ+B952I6aCv/
         dlSA5QxFt21e4BtIllhVZ/2nV/vYsFKi7TgI9lS/digjCbsQ3N128Ki48jUGC37yJS8s
         OYyGxEXVMlwdX1Vf1z4NULjS6MNk55w2BNyIunL8L0dbTeKFM4Duxz9io82fIpBbLP9e
         3kbD/6nqzP7Ux1U8P7UyjuD/PjF58LRqryYkcU1Fe8Uh1rWtSqZM7AkMTIhDtuLZTq82
         6DWCxjLoshrZyunyGZ20LGXwIpkWwPYTLxqMPX2AK3RUdiTv1k3Y304Ga/KBJgPGCZGz
         b7ig==
X-Forwarded-Encrypted: i=1; AL+hErGsooSVhz2sLqj04jBVwnqJxCCgMI3+3uy8fzCpilkkWVmnNLX14om2MQ1EytZjFqce0j2Mcoq9Zjsz@vger.kernel.org
X-Gm-Message-State: APuU4Z+OHTlsLEeeTCDQioG/y6OmRwJsscIxuovG9Iv+wuNlDc+JuYEF
	gVrKYy1OGGtN+8y4hh8sOv7Gu9op0YzrTLqeCnqRQtvF/sMnGZvbg/91N2dXMkwEPOGXJi31SOr
	uq6jZ+xUwlI9E9VTP6uXYEOdc+iAbvNa95JKxMO+11w==
X-Gm-Gg: AZFdTZemkppYiktAfi2tX3hFHaIM1uGiba+NEfLxQRNx4sFpF+AuxqwgJ3wdPtUREh8
	YlaMEzP+pmAs5LB88iOinVLurBFd39dGEpVriwBfaZyQArajTrbJvQ3OAu4bBPDzzwcwtg7G0Fm
	5sFbSd60CFAX+TKsf95r3K4i7A5cFiJfSTDVG//l8VkI9RFe/4jOkGBWhEmBaSFyJoqtdyGF591
	j1crwRDhRRCpz29pXihEpetmo/Xg8fZYVHM+e8fQ0yuQYMAYf0BkW3F0tXGbEIfNcWHBvgbQRzx
	NQbjGILgdFTMQa/B9ZkjtNtTscuacfSUH0QMrDL20TbPi70QQSE7fS+Plh3jmwq06TW4K5RFPaw
	zwIWMItIPftQ+nFTYalQ5WJ0MtPQoPYrW1IQuWk7s49xAPfFUvo0S8GCqokGVYlTpdUYFNzLwrc
	jbPSikX/mZvq3wQzcNk54V6+Wi0FKcHCSSe5O6SzzqsVGWET1rhZWh5cQ=
X-Received: by 2002:a05:6402:274d:b0:6ba:92c3:fef7 with SMTP id
 4fb4d7f45d1cf-6ba92c4088cmr1355074a12.19.1795356402046; Sun, 22 Nov 2026
 06:06:42 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122042120.2430434-1-piyus@iiitd.ac.in> <awLwiDzVpdJOr6BZ@linux.alibaba.com>
In-Reply-To: <awLwiDzVpdJOr6BZ@linux.alibaba.com>
From: Piyus Kedia <piyus@iiitd.ac.in>
Date: Sun, 22 Nov 2026 19:36:31 +0530
X-Gm-Features: Aa3M54pNcRlGq48LgyU0hvUMf93COD0ltrBkDDB650T83qW9BEt14_13yQ0gDU8
Message-ID: <CADq=QSyGfZBpziK7r6KD8mm1_0LRO4r4tAKe8gU52Fm-V+DHsQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net/smc: validate the peer's CDC cursors against
 our own buffers
To: dust.li@linux.alibaba.com
Cc: alibuda@linux.alibaba.com, Sidraya Jayagond <sidraya@linux.ibm.com>, 
	Mahanta Jambigi <mjambigi@linux.ibm.com>, netdev@vger.kernel.org, 
	Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, 
	linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Kapil Vaswani <kapil@presceralabs.ai>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Dust,

Thanks for pointing this out. I checked that Bryam's patch indeed
fixes the same issue. Please drop this patch.

Best,
Piyus


On Sun, Nov 22, 2026 at 7:09=E2=80=AFPM Dust Li <dust.li@linux.alibaba.com>=
 wrote:
>
> On 2026-11-22 09:51:20, Piyus Kedia wrote:
> >A peer's CDC message carries two cursors that are offsets into buffers
> >described on this side: the producer cursor counts the bytes the peer ha=
s
> >written into the RMB we published to it, and the consumer cursor the byt=
es
> >it has taken from the RMB it published to us.  Neither is checked, on ei=
ther
> >transport.
> >
> >smcr_cdc_msg_to_host() and smcd_cdc_msg_to_host() copy both into the
> >connection as they arrive, and every later user treats them as trustwort=
hy:
> >
> > - smc_cdc_msg_recv_action() adds the producer difference to
> >   conn->bytes_to_rcv under a comment asserting
> >   "guarantee 0 <=3D bytes_to_rcv <=3D rmb_desc->len", which nothing enf=
orces;
> > - smc_cdc_handle_urg_data_arrival() reads
> >   *(base + conn->urg_curs.count - 1), an unbounded index into the RMB;
> > - smc_rx_recvmsg() clamps only the first of its two ring chunks
> >   (rmb_desc->len - cons.count) and uses the remainder unclamped for the
> >   second, so bytes_to_rcv becomes a copy length;
> > - smc_rx_splice() walks PAGE_ALIGN(len + offset) / PAGE_SIZE pages call=
ing
> >   vmalloc_to_page() without checking the result, and get_page() then
> >   dereferences NULL once the walk passes the end of the RMB.
>
> I think Bryam's patch is solving the same problem here:
> https://lore.kernel.org/netdev/20261112-b4-disp-0287c16e-v9-0-e5e8fa68817=
7@proton.me
>
> Best regards,
> Dust
>
