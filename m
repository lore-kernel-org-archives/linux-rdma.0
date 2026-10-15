Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F203565119
	for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 17:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792085468; cv=none; b=YJ1AQYXZ1rZ1escnhywqJJ6H4LVO2S4KoTisL+Mv5pSB6EmSl9VVFu/cmZU7sJyz3ZUxAPB3pZUbMhIHFCGCvhxqyeIrfH7FLaJQ7iMLgiJyu7Rk1SoBfmC7yCk4U2MmZeTz04hYR4vdxZuAjcVcC0gaqLSIntc7Obcx0/9BZ/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792085468; c=relaxed/simple;
	bh=+6qqVI+UWHsu25cea9ZmYLujgZ7WSoMAKrVCzT4/W/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KsNOjHYk5QJAAMZw6r36xkSt1F1dOOleU+1VZ4wIgU24KNJHC1m+kun9KGAAzGdQrbXb1u9qXfjt8s3Esm4UD+nKdEj1NnY9oKOrhpW+dtmVwR/pENM9vErYfnkqMWoBWs4Rd9QCi7LpgMRijJJ/+fE8oXafExi6ZCuPbq1YChg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=keptUaK8; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="keptUaK8"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e6f83f0bbso499158685a.2
        for <linux-rdma@vger.kernel.org>; Thu, 15 Oct 2026 10:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792085457; x=1792690257; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rSU3k+XuYVS+a9J9Tl+KuvJO6amav+IGeClFbopt0w4=;
        b=keptUaK8VEOB5VyV3nFwdeMcMoepjH3eJOpPzrdf5nY48DjmlsWN590FHmKZGcLr+s
         XPJ7HIu/u1e4O0pI13dzlN6vD3HycrzJSNr6JS4bfBOp8kImgbiI/YhyO3EQzBeCpTPX
         lC7lYPZ4e3mL6JsmazXzvtb0iorRxQXdbzL/eLh5yLKV6fTTpKJ5Pbb39H19YgzVT3AO
         tQqImq/oXHLPz1RO1uocj0FAoIQOzn2Gu1q/FLXuU6N1qSopy4YkCDf4rlTwkoJnOhW7
         zdi/JyBGG3VEFgl55Bu6fNbYeaCrt0RjolqyqBGZ0rng4vW7JQviUcD9FBejMRk0WwPH
         udBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792085457; x=1792690257;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rSU3k+XuYVS+a9J9Tl+KuvJO6amav+IGeClFbopt0w4=;
        b=p4NeoDm2t+k29S6Ft0HUeF8FrtWFexBrsLkIdDBol77PvqryERvsOBo5oHpcMILQIw
         lGgnlBmfkbVCTFCR+Fy7TkwJCSjlQtCRvuGrAZavoMK7lX4bYeDv7hTqrG/PIg2Xxmib
         iW4OeqysalGiZiYr8yLnUPDM8JtdY1jS1R3sswvy8FKny2WAyohYFCFoZAUtFEBbNgCL
         OeSYmWyWxRS7n7CcTiw+trx+N8b2coDA/O6QvFH+q6wPVP45CPZlqG+5RNYejkxv5aFg
         AqYnSnWr8P+vwS3Y5RsF9lbIxWI6WyYPnlvuQKdu3ymUj7RSMgVc/AaiFtAQ7r7JVVSq
         GpJQ==
X-Forwarded-Encrypted: i=1; AKwUvBwOjzZQN8kHkimZ5rEGgpniLY6lxLQl3WuqNiWTsIQnl6ZL5p+Tsw9Vv6Tf2edUAwgYC+aCdzd2RuGX@vger.kernel.org
X-Gm-Message-State: AFq9FYItlMUCxb0FIM1tPgb1Nwv65XGKNm5GP5uo2vReSIqvSSbcvCTq
	eGTbRw2rGbpIXrGcDe+S+IFoEu3nrGUIR9xPd4/1oSLUQo9jM2NG5g8DRBn/ZXm+ELaa8LnRJha
	HXtLD
X-Gm-Gg: AYBFou1LixvRRtOrEa50603Z5nlFLv114GVesdYfnFsEgxmYBBgdCbAk1eOHS+WbjE0
	SqvVf34LIA71OhocYhFMFWaNS4+ndlx3ldX/C9IpR3zlNIYnEtsJoEIbOrC6Y/Kl8Ix33wsAPW5
	tRQklkpQrM/JWTIxvv/4fmN3DetfzDNOWwGistvhLAqiHoG5rL8YujWVXEGdjLyKTPhOS8n6//7
	w8fLOAaahEfl0uz0Hongf8VbWTSllZgv1GUgrVFQguIvZ7HqOgOBDBekEp5W4OFgXmClld8Dky1
	H8OcKbWB4q3MSNo9AcIJhxdHSdp/avSVToThbs9hlZZkib6H6e1NU6rLZtWb65INvhz4znY+Iqu
	3iICNRfAN0AtW6CO0Q9Fyl96Tnn1YQQlUCEywlHeBmV9Dyb6Si39N6fYGVauxgF4QVBrXZnM7+C
	DIgcENfKTFbxQe7MWjNal1g11oWsNv14owb+uPJgLNjXBD0R4rcPdf0y7qEVOcdi7ccIEYGmPiy
	m0GjZ0KXYKLxP4CF1FY41AVy7ggaFfUIyEMLt30s6nxiyaN3j+Qhg+c
X-Received: by 2002:a05:620a:4115:b0:93e:6c02:d181 with SMTP id af79cd13be357-93ebd1e23aamr3396316485a.14.1792085456943;
        Thu, 15 Oct 2026 10:30:56 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcbb1af26sm745476d6.33.2026.10.15.10.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 10:30:56 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xHPI7-0000000H5Tx-0ACq;
	Thu, 15 Oct 2026 14:30:55 -0300
Date: Thu, 15 Oct 2026 14:30:55 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Eric Davis <eric.davis@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-next 05/13] RDMA/core: extended address handle
 attributes
Message-ID: <20261015173055.GT14213@ziepe.ca>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-5-a0e626117113@broadcom.com>
 <sashiko-outbox-172008@kernel.org>
 <CAMouMYL6cw6uNMnd_Vjz5WnWypTq7iq-YXHhyk14_taBJhwuug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMouMYL6cw6uNMnd_Vjz5WnWypTq7iq-YXHhyk14_taBJhwuug@mail.gmail.com>

On Thu, Oct 15, 2026 at 09:15:56AM -0700, Eric Davis wrote:
> On Wed, Oct 14, 2026 at 3:50 PM <sashiko-bot@kernel.org> wrote:
> > Should this use uverbs_copy_from_or_zero() instead, to properly support
> > trailing zeros and allow future structure extensions?
> 
> Agreed, I will fix this in v2. Patch 7's JOB_ADDR_INSERT handler reads the same
> struct ib_uverbs_ah_attr_ex the same way. v2 will fix both.

Please go through all the uapi stuff and make sure it uses new
mechanisms and helpers all over. If this was written a while ago it is
probably out of date.

Jason
