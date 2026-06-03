Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551B480DD5;
	Wed,  3 Jun 2026 13:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780492233; cv=none; b=lr5Eb/KIgIbsf+23BqAaA4087GSSU+wJeGKF7boqsw398Ny41KigfBi28gwsFDAjLBQazDnIopQqr5VbCTunPJue26BLVZ1db4bX1ZykgCV/XsNEPE2reNPZqLmCYtC/TBcF5VgqvknjCPx4D79B+lf77bV93PHQElP1+vvDB0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780492233; c=relaxed/simple;
	bh=lP5QJJuOKglyx6J1a/8UfKNOxuYG5diuFX02YWZfKq8=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=pep3LK9pL7WFoSZhteO8TifYGwlgR6eP9YHiAgX8hAIFZIja4V5Lb1C+Jzon21KnCeRIQI/vOczuTQYj3/QZBv3wnLaXLS4C543n2HzuoRNrHogvbN00mZGR5sc5o4h3AIUZsyMVwowgbxfvitSiiSZ9IXZMxPuGR4IAVNWPs0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=F3KciT6N; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Mff/BpCg; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="F3KciT6N";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Mff/BpCg"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id B60D11D00128;
	Wed,  3 Jun 2026 09:10:29 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-04.internal (MEProxy); Wed, 03 Jun 2026 09:10:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1780492229;
	 x=1780578629; bh=hpoZBeoqCBQo7mAwIGX+VUpxekz9pKp5gQJBK1lkg8o=; b=
	F3KciT6NrD+ji5UyE7NaDKKwT6UK82bXiTiXFjsndeUfsTMobOfKq0l1D67QYNEy
	2NPwnO6ciwqBwpqBqY4sqvtO1TVKpj9IZAma2lSLtoAH5E8XOtRVBf8KlrEZ1yEE
	8lN6LUELviBRHnePhmpfSlGrke84iY+j7L72TNdZOFHFWNpvz2O7tfZIe0p6kua5
	bUTmc/Q7QGm/HqKD11lifrFEj/jxx7gB8gixe2aVY3Hl5FECFSn1Z+ikr+mYJo5C
	BlThVfY71bZuTJEW4SuiIUXZH2xC+CpwYDRDBk0fokg28HaHNgtJcwY4AojMXHb5
	F3V9KKEM0KgcZBoiwAITog==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780492229; x=
	1780578629; bh=hpoZBeoqCBQo7mAwIGX+VUpxekz9pKp5gQJBK1lkg8o=; b=M
	ff/BpCgKMM1gIOV5TbDg9K7LrT87oRexzi3PLrMsfd9iz8SGLH1RMPwvrq4NT3Og
	QuCKsFMz/Jmpqs2lQVLV/i8mk2r0wJH0UuzwIKX38HvNsdaxVipXEWrSqlgUgWec
	gL0oALRMOxHyNU+C9MW4InRC7cPTy7CeVH9nWYFSN9MBBT2BY9EfayXvdHzL0ew+
	zk3rJ/pze6Qy0ocjYn0YbJIwGaGJwQZ1EckdJf8t64hr0+6dslMNrroqfhgr+fXG
	T69DBZ8oppJ/lWbZDuoOtnxlU78NnycizjpngtlOwN0eM4Pti7Xt654mo31A+fEv
	AevPWXBZgU3nNz9Hsut9w==
X-ME-Sender: <xms:xCcgancbYdIJxA2kLOi-Yrv5wSyUnpVlkJVhzh0-wuwY0IIBFGKZAw>
    <xme:xCcgaoBvSDGwrpu8DShO4mxcB7GnrrZKV3idLJiL1LQAyktqGo_Q8F5V9rWw74zQu
    rQcHj5y32C2wqnc4it-pSvBdLTuCvLYiS70xQftoySFkvs4vwoGdTlm>
X-ME-Proxy-Cause: dmFkZTF4ka3SKL2vrKeBSM9FPU0Ph/VV7ezdSdxFeAlzlFV55Klqpm6ZoGacaFoc7M82f5
    jSMoYK02niDMu41PFS5tOBUIRTq8DGsnl+kYTBT2+HORgCtExVQYwu6wxu5po7XVBukCRQ
    29SLEbyCLD7Hu6ISZm3wJZZy4cOz5x7g3Q/2kqaa78yfzUfxtoww6NB2GTfHC7Q10Qau10
    dSwQsfCYLl5UHZlsoLdQ5h/Xv94PQuBm6uA/QUqE00uDiogCSatz/eLdXghfD6/F9/oZYl
    GToWb6Z0tyi7XTWeCDC+wFr1Fxkv0vfv2GrwVkBBiz0U6wbA4So+dbmM/nRArlaseBfIDi
    DKJIrfdWCXHJFTM0xrU6jArXzIt6T46ho3j9kWvWjFBaDeyAWeKGQ91Oy87Hlk1KEoXxss
    7Blw89fUCkrSwnnsJvB91K7KyWhkQKhVygB2i6gzzLKEF5W5c/4LBYzjJjEdKHUt/SxAUM
    FfjGrEyG3qvangKeiHcn0tlQC6cyDgZOyfhQE6vLLN6GMF4k+9NbexQmKCQ9G15UMxEUoa
    tRSBC2RtXNtvY5/axdoL7HdGDhAzcaUX3CQ5up0V0Y8ysxsTDjKh7FwPNcZSkd+h2BBnN3
    f7+LJpeUQl2PmrAFvnnM7eaEQ3+kGVyxx56n0aGDc9IZ1HKmdA+WzQ+1IoJQ
X-ME-Proxy: <xmx:xCcgaofSDyLnnnmE-mie8dWjmd7X3SW7l-VdL6N64NbAy6nN5N1tsw>
    <xmx:xCcgajgftM9BAeD_-K_XBFKzszaDTuxHSkcVeT-Wjw1fTqbv2wohRA>
    <xmx:xCcgahgEL-VGOfzztO1j90UsaTncaJPjG_x2_BlxN0WNabSurUomNQ>
    <xmx:xCcganqt4ax3RT6HA5JGuPcDkpukiqvIJWYln3HLDMLo_r_foGzuyQ>
    <xmx:xScgaiKUnLEa6xEnE_yCG4oimQnaJDbN-amSkJ1LFukCkv6LBj4_BwLp>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 55D041820082; Wed,  3 Jun 2026 09:10:28 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AAuCPBQLA6as
Date: Wed, 03 Jun 2026 15:10:08 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Rasmus Villemoes" <ravi@prevas.dk>
Cc: "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
 "Arnd Bergmann" <arnd@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Petr Mladek" <pmladek@suse.com>,
 "Nathan Chancellor" <nathan@kernel.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Arend van Spriel" <arend.vanspriel@broadcom.com>,
 "Miri Korenblit" <miriam.rachel.korenblit@intel.com>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "Nick Desaulniers" <nick.desaulniers+lkml@gmail.com>,
 "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev
Message-Id: <e2445810-20ae-4384-a485-259651143f05@app.fastmail.com>
In-Reply-To: <87zf1bhjqp.fsf@prevas.dk>
References: <20260602150904.2258624-1-arnd@kernel.org>
 <ah8n-Nk305S5hRwN@ashevche-desk.local>
 <WPQQfPHOiGJbSxrXRdFDy9jURhS7JMpNu9sD54Vfe5wB-JOjyGY6xPQyACz3MSGg0xGp79eOYCyZ2Hi2CsPeUg==@protonmail.internalid>
 <35c1ba62-e74d-4abc-aa73-ccd35968ff89@app.fastmail.com>
 <875x40hz7k.fsf@prevas.dk>
 <cODLVx6ZlerCiOgdpsG7OSsC2YRA6pXmq2jBdTjRB2UQoTIY4hI-yhV1lrumRNBH1hTT2aJRS-MgtlbhNWUTEw==@protonmail.internalid>
 <aafe201a-64a6-438f-89a3-d1cd10a357a7@app.fastmail.com>
 <87zf1bhjqp.fsf@prevas.dk>
Subject: Re: [PATCH 1/2] tracing: work around -Wmissing-format-attribute warning
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Jun 3, 2026, at 14:49, Rasmus Villemoes wrote:
> On Wed, Jun 03 2026, "Arnd Bergmann" <arnd@arndb.de> wrote:
>> On Wed, Jun 3, 2026, at 09:15, Rasmus Villemoes wrote:

> I don't remember what minimum gcc we currently require, but gcc 9
> introduced another attribute that is apperently meant for cases like
> this: 'copy'.

The minimum version is gcc-8.

> This seems to build:
>...
> +int __vsnprintf(char *buf, size_t size, const char *fmt_str, va_list args)
> +       __alias(vsnprintf) __attribute__((__copy__(vsnprintf)));
> +
>
> That at least should handle any future "gcc knows this-or-that about the
> vsnprintf function". But I don't know if clang supports that copy
> mechanism or if the minimum supported gcc is too old.

clang-22 and gcc-8 don't like the attribute, but also don't complain
about the other mismatched attributes, so simply using the __copy()
macro we already have will work on all currently supported
compilers and likely all future ones as well.

      Arnd
