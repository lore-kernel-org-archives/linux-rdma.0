From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-rc 5/6] IB/core: Save QP in ib_flow structure
Date: Fri, 18 Nov 2016 00:41:46 +0200
Message-ID: <CAJ3xEMh1DE-Dahup_gZ=k7S5sB1cKN+p9xy5dP-fuN3DrWQvNw@mail.gmail.com>
References: <1477575391-20134-1-git-send-email-leon@kernel.org>
 <1477575391-20134-6-git-send-email-leon@kernel.org> <CAJ3xEMg=3eOqsKcrfcOoBkdpjiCmEAcPfNixHeLfVy45v_uvnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMg=3eOqsKcrfcOoBkdpjiCmEAcPfNixHeLfVy45v_uvnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 12:40 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Fixes: 319a441d1361 ("IB/core: Add receive flow steering support")
>
> same comment as the other two, probably applies some, most or all
> patches on your git hub branch, lets use what was submitted and not
> something else, okay?

Also, as I commented and you didn't respond, this fix protects against
**future** bug and has nothing to do with intree code. As such there's
no point to put it
into rc fix, it's a -next thing
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
