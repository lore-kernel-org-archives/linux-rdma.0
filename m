From: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Mon, 8 Jul 2013 16:26:27 +0000
Message-ID: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com>
 <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <A2E4D36871A8F9479E263854377F0B84-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Jul 5, 2013, at 3:11 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:

> So what happens if I have an old application binary, and I run against
> a new libibverbs without recompiling?
> 
> Also it seems that I'm forced to change my source code to be able to
> compile against new libibverbs?


I previously sent an ABI-preserving version of this patch, but it was hated by Doug Ledford and (eventually) Jason Gunthorpe.  

After long discussion (see thread starting here: http://www.spinics.net/lists/linux-rdma/msg15951.html), they decided that they wanted a clean break that forces both source code and ABI changes, which resulted in this patch.

I personally don't care which way this goes; I just want the ability to have non-enum MTU values.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to: http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
