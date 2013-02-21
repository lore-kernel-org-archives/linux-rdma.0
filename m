From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next v2] IB/ipath: use GFP_NOWAIT under spin lock
Date: Thu, 21 Feb 2013 07:34:48 -0800
Message-ID: <CAOS58YOHt7OaBHRwwqjLF8xZtVaj=BeFUXFAxW0owb4_BxC3Rg@mail.gmail.com>
References: <CAPgLHd965-++Kj6HE-wjHqpZjortmmCAvApSSwiXaX6YwWncHQ@mail.gmail.com>
	<CAOS58YNcJ0gDmoR4M1tgJbqqzv0i=5EkoAr=OhoTSrozfw-ZtQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOS58YNcJ0gDmoR4M1tgJbqqzv0i=5EkoAr=OhoTSrozfw-ZtQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 21, 2013 at 7:33 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Just noticed akpm isn't cc'd.  Can you please repost w/
akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org cc'd? All related patches are going through
-mm.

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
