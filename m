Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795878433;
	b=RdZqULwqPzjFcvLOQhenoFvUddd6+NL91+n6Yuf1+FW1zvIse7/AGkhwgWH3cDmU/gvq
	 6zZ5d3c6Js0bFE70gXVwRjRmnBYSaqrT3DKvn4NzUxbtW0jkx0dfPi1tLL6IG0/YpFpS0
	 KFdVlJBdWLish9a04GZLDrdEQbCqoNgW5dAOrAb+4IxxnxK3uo8k68SRgfEIVbRkPsyDU
	 MOT9nb4Pdg1j6u5mytUAFxLen7VVZ5K7dE/j0CYChNUfNsy9Rko1ZDnBMNjUc3xBsuXy2
	 K6a46lfdy01ZlqhFTjWd/vxOhkpbPEH0LaqHHkoVwSGlv+1eyp6OfTWVjKIgIsPjuGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ClVtae2khtb19o1Dql7h8VoV1Wj0/r3koaDJkVoEQdU=;
	b=ZvP88k62+yhhz05aiiuYw6b2xSlN1TIEAv0jBndWvNIjLYRVbR9TWPCDJ571cEI/X7d8
	 AISZI+c3/rT3OtdfzPnJ+XQDCLSfzh7olakJmV5cFYJD2n+l19DtVGTrE3g2sQB2Jv0lb
	 AtBMS5lCJy6rhtyvdLD4E4D3YibeBEryrGlVy7L74yS+xZ1HkrmvYVHNPINYJaZllLp8W
	 RUNhJK9Y1eIKboR4c1AVYA8yru8Tc3um9slQIZskKmaNfHzIpb51b2mWh780ApOg4aArR
	 2ssDFDu9MrDK8KlJAYXx/weq8y81TVP8vxATCqreQAvmGwNfdgM4e9yF1hMRFffirWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=aDiuxX8W;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB97F606A31C
	for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 15:07:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB97F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=aDiuxX8W
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c51373ae637so510239766b.3
        for <linux-rdma@vger.kernel.org>; Sat, 28 Nov 2026 07:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1795878426; x=1796483226; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ClVtae2khtb19o1Dql7h8VoV1Wj0/r3koaDJkVoEQdU=;
        b=aDiuxX8W2+gteVCIUPG/FgvvNkM7Mmoj0rNnHSgJohxEqQJzvIbLfTx0PT3mHW/Y25
         TGN/ChZmozRhlPn+B7zhaDuFTbXHvKf42CD6eJwr6loO/mR7PdYlwhxM993dIbsHCZBq
         kdwmOqCAmLxRKMLOsaMEio51Dne5WhDXBU4hIKxLXALE0iajF2wAnqTIKZRppecVMIZA
         hk3hpnONDCMiDFfVrV5ikOyIAdz7LZ9HerEyq2PLh2/814ahKeRlAns1VJKX8cJVZtoJ
         pv1RtKe0VPbq46RR18/HFS16DxTZrxjXRXxKz9cqwX2Se56qKRqwk8Bj4kPX14r8cDt1
         LWOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795878426; x=1796483226;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ClVtae2khtb19o1Dql7h8VoV1Wj0/r3koaDJkVoEQdU=;
        b=VR6ynWsivpshl5Azygk1B/kkd47vGqINg+hwfNpunnMkfFeU3gBo4oi0+1K8FwgWWa
         uvJBp5gWHy9UlLBcrff5B3eTipeo16kYFzuqGcTzFS3PIrw7Y8cTz2yrxsoTdQb5qYNZ
         twj9dVjAz17FfVrb2XNXQeGR3ABPg6yN3c/+xz5iaaheMRUni055+8+c7GHRlqwDh4F3
         fp2Wp983aohYUkGF5K1oEQx+dGTq7b9CcONz2/0RSZAGJQ0acCh72sdNqu0el9KYBHR3
         7WbU6eMy4CFsv+uJT/hNONU1M508uv/Y1+aGilOUuk89q9ByV9jM2Y3PZjFi6EzkIlep
         brzA==
X-Forwarded-Encrypted: i=1; AL+hErHMdVLDDNF563KjnhHL2Z87fCBFo+DYrmmm+iodiQsBESjrRt07sSr8DbqiczRxGN+Vtsq4NCq/SVNU@vger.kernel.org
X-Gm-Message-State: APuU4Z8RizcX9IJnaTrqqAiefbFOWvEAEm5TiV8ztq2reHlGGP8XB4jx
	3Lbjw8nm3KSTxIfPCqzTGdixMuT0gT4zz1s0yxtI60xqp/oTEWzSGhyDSYkKCg4V6w==
X-Gm-Gg: AZFdTZfNpZjhZ6AQEBjS6mY4QS5E0cmZyURWkZxF/e/F82JC3Qy3wWT+dndAvUPSn6d
	p+tRKXVwnY1aulpxgT2zIPEyDKzW5nH0s/cfpri7WAgVF28IIfmB8T6T4BUksMtE026PyV91gOj
	YvbenoybDDZHZqiwKxGhPRtX0uGldVXpbWmgv9Y/ffLuLJvjFBYeSLEp3BAtUD+/IFaDOK7dky0
	8CXGYi/kiYC8saoPtJoQDABUFuDXVFweizsGaDpCnJ2P0yCvTgKshjM9uO7vmvT1lFqhayGzhSU
	eueIdCtfQwbdljsl+IE1QJ/oys5XEpnjdfkrNbf7iiPCFkmKYMtoyu46JYGE7nrZ7SUbEdVb+h0
	GIXBZbxVYVR2E7unG4jFC8XoUhOUJ4Ci2LraxngHsmizbAdCHNVklxAoCkEEWa2kUQKFj5ry22Z
	5djgfFwyaAonnYf1w/Bm5ydK5lAQWiG5Bvr2hFWuiLFteRvgG5D7XgFtdMcgWPkYmf/PYFgcGfe
	eqTzQnaEqeWUtp2nR+U/m4Acd17IQbQxLw5OZXjKmA9RkdaLNdlfA/ddYFcPTg3rPYUaYJCut85
	5GShKrS4VxHzWkYVIjttCmRguXIjPadXLMy9cbk6O5Vr45d1YTb/L31adWFqzDt7mVJ8dgVI/aX
	aGk5WDPV46qNxm98iP9HVsyw6qbeVaEKHSOflxDCBwcK5XXXmX1PR107o8W/TD9mLd9Xxm4Jl1U
	hzmTwiio5pTip5PyOxV/AfdLsm5U225LVc+Cw3bHu7ThbDwIay0mqm9SR1uaSu+NZahL3nrX6ft
	O4+Dyjkt9dQPCrPmXIl99XccZnWHpmJgl8bqrG67vG9eyxUZoTrIqbAbu84fdBv6lC/9DNyWbAU
	OL6tQU2WKdrVtw==
X-Received: by 2002:a17:906:f8d2:b0:c50:bf14:8eb1 with SMTP id a640c23a62f3a-c513a84d84emr1751678766b.14.1795878426093;
        Sat, 28 Nov 2026 07:07:06 -0800 (PST)
Received: from Desktop.tail070c67.ts.net ([185.152.145.248])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae8ce16sm965372266b.37.2026.11.28.07.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Nov 2026 07:07:05 -0800 (PST)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pabeni@redhat.com
Cc: netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	willemb@google.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	dsahern@kernel.org,
	idosch@nvidia.com,
	ncardwell@google.com,
	kuniyu@google.com,
	steffen.klassert@secunet.com,
	herbert@gondor.apana.org.au,
	richardbgobert@gmail.com,
	ecree.xilinx@gmail.com,
	andy.moreton@amd.com,
	alex.austin@amd.com,
	linux-net-drivers@amd.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leon@kernel.org,
	linux-rdma@vger.kernel.org,
	alexei.starovoitov@gmail.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	izaiahsun@gmail.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	shuah@kernel.org,
	bpf@vger.kernel.org,
	ipsec@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] selftests: net: check TCP IP IDs across tunnels after GRO and GSO
Date: Sat, 28 Nov 2026 16:07:08 +0100
Message-ID: <20261128150708.2702219-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <e07adc3e-838a-4c46-a56c-eb47bb9e77f4@redhat.com>
References: <cover.1795284858.git.julius@bairaktaris.de> <2f75527eb49d7d4ffec32a61fd7dd080673dc57f.1795284858.git.julius@bairaktaris.de> <e07adc3e-838a-4c46-a56c-eb47bb9e77f4@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/26/26 10:51, Paolo Abeni wrote:
> This test is very unstable:
> https://netdev.bots.linux.dev/flakes.html?tn-needle=tcp-fixed

Every failing run reports missing segments; no ID check failed. The
receiver read a plain AF_PACKET socket with the default receive buffer,
and packet_rcv() dropped the frames that no longer fit when a burst
arrived while the receiver was not scheduled. v4 reads a PACKET_RX_RING
with room for all frames of a case and fails the case if the socket
drops a frame:
https://lore.kernel.org/netdev/cover.1795869698.git.julius@bairaktaris.de/

pw-bot: cr

Julius
