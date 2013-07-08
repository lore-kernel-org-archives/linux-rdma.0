From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Mon, 8 Jul 2013 10:19:33 -0700
Message-ID: <CAL1RGDU+4CSJyF0TAfAv-YYcjA4FG+XNeg5pGCHPeW5iqhvwpA@mail.gmail.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com>
 <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com> <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6@xmb-rcd-x01.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <EF66BBEB19BADC41AC8CCF5F684F07FC4F6F31A6-nsZYYkk5h5QQ2GdVW7+PtKBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

[resending to reply-all, sorry Jeff]

On Mon, Jul 8, 2013 at 9:26 AM, Jeff Squyres (jsquyres)
<jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>> So what happens if I have an old application binary, and I run against
>> a new libibverbs without recompiling?

>> Also it seems that I'm forced to change my source code to be able to
>> compile against new libibverbs?

> I previously sent an ABI-preserving version of this patch, but it was hated by Doug Ledford and (eventually) Jason Gunthorpe.

> After long discussion (see thread starting here: http://www.spinics.net/lists/linux-rdma/msg15951.html), they decided that they wanted a clean break that forces both source code and ABI changes, which resulted in this patch.

> I personally don't care which way this goes; I just want the ability to have non-enum MTU values.

So I guess I need to go back and read all of that thread carefully,
but I don't think that silently breaking old binaries and also
breaking sources is the right way to go.  What about preserving the
behavior of the existing API / ABI and then adding a new function to
return the size of the maximum datagram for a device?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
