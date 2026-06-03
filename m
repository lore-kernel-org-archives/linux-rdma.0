Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A1E480965
	for <linux-rdma@vger.kernel.org>; Wed,  3 Jun 2026 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780491842; cv=none; b=kENa4lhGc2SQUzoEUnGOh+Sf5vaknxDUz1fK5JKaA9QY8ecU4d7XrCG7tJVy7kKURe5E2FDmIolAY2voGuQckNiqTEP6a5cND0ycWg7pS49UlYhmUX0+AmT9p+ZQ9xMfuSHtNuHvACRgaLi68NVOogRaVEgfrpb4SBWvz0k5Rj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780491842; c=relaxed/simple;
	bh=MBU7CS7WVwYwMOdcet6ICEOaUIj+8mKXQIBdEMW6F8k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5lQluuJIUpKY3PbIoQFBP6EC0DV8koICBM1hBuCnlijoDIOfbFf7NDgl2ECVI9OER6GJ6DabXbXTBl34oHFF93oZPsPReYPOAF8GvQqp7Ak7J+clPT9MZJvfxwjPZ4tCern1cIyHll+aTIBbiuNcGLHqwj1xtpPknqzIe15VW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S3sGvcpU; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S3sGvcpU"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-45ef1198766so428156f8f.0
        for <linux-rdma@vger.kernel.org>; Wed, 03 Jun 2026 06:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780491838; x=1781096638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npACNw5GZ77miqur21FanA4v5+vTppUVJOnuElrt9AM=;
        b=S3sGvcpU/jeOsGKM513xHUN2IPbJVouwCe4+ZZppPDYfGFGJSnZbCfImj4OLGXXdlh
         /7fGwZIAVmucyU6kIY9xK0MRpVeefw4qWD734Kpx9P2uCjAM4z4dlgUdMVunipVWwFqE
         fdqV4lFThsgkyvsUiQ6rPlEK77pr4Iap71PsNggEUY81aR0mU67yVocfFtk0VnAOgsdR
         cjlo8SGHBPgquF+2mjy3xjPg3pCkPWdX4TrJf2DpRjAmxgru2UljmmDJseV9ePk57r8K
         DwCfmeldb+PzUhYwGnU5k9RXTKDBbI9yBuZJUkF+ngKcO/evQ/GS4CqwHDFDj8xbAwVt
         Pdjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780491838; x=1781096638;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=npACNw5GZ77miqur21FanA4v5+vTppUVJOnuElrt9AM=;
        b=LaT2wz17lYrieppCef7PhoTcUe3VCHLYSOn2Flm2o27Gq4ypnXw7gtzOBDimODEjj5
         cBSxiCj6cCNErq98/xFQvN25hOJ3TI5q7xwx+PLYv9vSWqMLsU9sdr1odEYPSww8Wvrz
         IdUL2Q6zmnIqphWpHLKVF5TtsP9lavZnLERUEDnhXpdVsYjyDRfbL4Z5+pOfi6++oQue
         fZ3Jlqng9Be+P0aDL6sAeKwlo1dzpZ3VpfO7C8dVwPlX2O1WmrqJLRhYhUmRsE6HtoJK
         OjzMDDfrxtKnbbdThyevGFij98prtNcfQidG/EfIv32YY1gKMlcXWrQuJ95rkgGCUaH5
         i26g==
X-Forwarded-Encrypted: i=1; AFNElJ8l7+rPeV2dq/ys0jaNfhSzlFMU5aXCL4YyqZdkaO/rT5z2p0bvFnYrZYWQ0CwuX3hEtxsWEKfCwuea@vger.kernel.org
X-Gm-Message-State: AOJu0YyE6G9wMvQqKjtwAVWgIdyFmJBZgKezNesqunU7LeQiqj1Pv0gI
	EntMuIuyHw4pNsuBYCrWEOMkmh1gRMq97rHFs2LR+2CSwIeF0AGC1yAV
X-Gm-Gg: Acq92OHEpnFduXuxiLgDzSsH/brzxh6hdCymgTyBr6+V9wC4c78wjUju1tgED07P1ml
	yEy1U3/45AX/ObfQbiKvJVJoo0rgX25cKYZrIs50UslNsR4z9i2MqK0ectCdC+6S5OxcjTmXyEe
	yavqJQf8sV0GmMLCKkr9Ehf50wJxLlRFphg9G/u+b97Bu8X6B704jSz1Qi7voZ6ip32B9mU2Yi+
	wZK8E8rFzybQmFyah4KUmMeK0Sf5H2QE1xuirYyO0UNdy0jP3N2HU3uFS2Z7km+XyQNeXJR7Iih
	W3twBtbKi9fZpDptBsnmgCnWDUlx5AJNga8odzN95NoTo7PJg6ioLPojJfmKpPwhnDGOI/a+WXN
	JGljvZJvpcLzr2ik27mnYHQMtyk4jHPBVb3WSjVl1aNN+ceHtISvn2NEOoFyWlPbCkAXP1+n3Fl
	gU2hbTe6FL06CqP1yE8ZuV64QGcXkY+WwI5lEnotHNPXwANoF3E4bUJzA2vlUcBEeelB2J9bU=
X-Received: by 2002:a5d:5f8c:0:b0:460:133f:2a4e with SMTP id ffacd0b85a97d-460212df7e6mr4465185f8f.13.1780491837758;
        Wed, 03 Jun 2026 06:03:57 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f368e9fsm7576265f8f.37.2026.06.03.06.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 06:03:56 -0700 (PDT)
Date: Wed, 3 Jun 2026 14:03:54 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "Andy Shevchenko"
 <andriy.shevchenko@linux.intel.com>, "Arnd Bergmann" <arnd@kernel.org>,
 "Steven Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu"
 <mhiramat@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Petr
 Mladek" <pmladek@suse.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>, "Arend van
 Spriel" <arend.vanspriel@broadcom.com>, "Miri Korenblit"
 <miriam.rachel.korenblit@intel.com>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "Nick Desaulniers"
 <nick.desaulniers+lkml@gmail.com>, "Bill Wendling" <morbo@google.com>,
 "Justin Stitt" <justinstitt@google.com>, "Vlastimil Babka (SUSE)"
 <vbabka@kernel.org>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
 linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/2] tracing: work around -Wmissing-format-attribute
 warning
Message-ID: <20260603140354.6744499b@pumpkin>
In-Reply-To: <aafe201a-64a6-438f-89a3-d1cd10a357a7@app.fastmail.com>
References: <20260602150904.2258624-1-arnd@kernel.org>
	<ah8n-Nk305S5hRwN@ashevche-desk.local>
	<WPQQfPHOiGJbSxrXRdFDy9jURhS7JMpNu9sD54Vfe5wB-JOjyGY6xPQyACz3MSGg0xGp79eOYCyZ2Hi2CsPeUg==@protonmail.internalid>
	<35c1ba62-e74d-4abc-aa73-ccd35968ff89@app.fastmail.com>
	<875x40hz7k.fsf@prevas.dk>
	<aafe201a-64a6-438f-89a3-d1cd10a357a7@app.fastmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 03 Jun 2026 10:41:18 +0200
"Arnd Bergmann" <arnd@arndb.de> wrote:

> On Wed, Jun 3, 2026, at 09:15, Rasmus Villemoes wrote:
> > On Tue, Jun 02 2026, "Arnd Bergmann" <arnd@arndb.de> wrote:  
> >> On Tue, Jun 2, 2026, at 20:59, Andy Shevchenko wrote:  
> >>> On Tue, Jun 02, 2026 at 05:07:05PM +0200, Arnd Bergmann wrote:  
> >
> > May I suggest a different approach, that avoids having that extra
> > function emitted (which presumably compiles to a single jump
> > instruction, but still, with retpoline and CFI and all that it all adds
> > up): Keep the declaration of __vsnprintf() in the header without the
> > __print() attribute, but then do
> >
> > int __vsnprintf(char *buf, size_t size, const char *fmt_str, va_list args) 
> >    __alias(vsnprintf);
> >
> > in vsprintf.c. Aside from reusing the same entry point, I could well
> > imagine a compiler some day complaining about seeing the printf
> > attribute applied in a local extra declaration but not having it in the
> > header file.
> >
> > Presumably it will need its own EXPORT_SYMBOL if any of the intended
> > users are modular, and it certainly still needs a comment.  
> 
> I had tried that earlier but given up because the attributes have to
> match exactly.
> 
> This definition works with all currently supported versions of gcc,
> but may have to change when the there is a new version that adds
> even more attributes:
> 
> int
> __printf(3, 0)
> __attribute__((nothrow))
> __attribute__((nonnull(1)))
> __vsnprintf(char *__restrict buf, size_t size,
>             const char * __restrict fmt_str, va_list args)
>                __alias(vsnprintf);
> 
> We'd probably want to also add __nothrow and __nonnull macros
> in linux/compiler-attributes.h if we do this.
> 
> For reference, see below for the alternative idea I had
> that avoids adding the __vsnprintf() alias altogether by
> passing down the va_format using "%pV".
> 
> I don't think I actually got this one right in the end
> since I only build-tested it, but I expect it could be done
> if someone is able to test and fix all the corner cases
> properly.
> 
>        Arnd
> 
> diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
> index 4715330c7b6b..8e44fc3e60b0 100644
> --- a/include/linux/trace_events.h
> +++ b/include/linux/trace_events.h
> @@ -956,14 +956,11 @@ perf_trace_buf_submit(void *raw_data, int size, int rctx, u16 type,
>   * gcc warns that you can not use a va_list in an inlined
>   * function. But lets me make it into a macro :-/
>   */
> -#define __trace_event_vstr_len(fmt, va)			\
> +#define __trace_event_vstr_len(vf)			\
>  ({							\
> -	va_list __ap;					\
>  	int __ret;					\
>  							\
> -	va_copy(__ap, *(va));				\
> -	__ret = __vsnprintf(NULL, 0, fmt, __ap) + 1;	\
> -	va_end(__ap);					\
> +	__ret = snprintf(NULL, 0, "%pV", vf) + 1;	\

This adds an extra snprintf call - non-trivial and more stack.
Can't you just use the old code with vf->fmt and vf->ap ?

And does the %pV" include the va_copy()?
It isn't normally needed.
Any scheme for avoiding doing the printf processing twice
is likely to be a gain.

-- David

