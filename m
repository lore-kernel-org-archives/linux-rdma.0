From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libibverbs: A possible solution for allowing arbitrary
 MTU values.
Date: Wed, 5 Jun 2013 18:02:25 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F65DB61@xmb-rcd-x01.cisco.com>
References: <1370437223-14171-1-git-send-email-jsquyres@cisco.com>
 <20130605164639.GA30184@obsidianresearch.com>
 <EF66BBEB19BADC41AC8CCF5F684F07FC4F65D690@xmb-rcd-x01.cisco.com>
 <20130605171916.GD30184@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130605171916.GD30184-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <E6A237AC0217464D81E4C8CD2A764490-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jun 5, 2013, at 10:19 AM, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> The concept of a libibverbs 2.0 has been NAK's by pretty much everyone
> involved. This is why we are suffering with the complex extension
> mechanism.

Are you saying that libibverbs must always always always be backwards compatible, and there will never be an ABI break at any version in the future?

> The mixed approach that was brought up, where values like 1500 were
> passed as 1500, and values like 1024 were passed as 3 seemed doable to
> me. Did you see a problem with it for your use?

It just seems overly complex in terms of implementation.

> Thoughts:
> - 1024 and 3 both mean 1024, the library must accept both values,
>   it should only ever return 3 though.

Why?  If the caller can pass in 1024, it seems like 1024 should be able to be passed out, too.

> - 1500/etc means 1500, the libray can return that.
> - Make a ibv_from/to_mtu inline function to translate from bytes to
>   the encoded MTU value.
> - Switch ibv_mtu from a enum to a typedef int ibv_mtu

That also breaks ABI, doesn't it?

> Jason


-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
