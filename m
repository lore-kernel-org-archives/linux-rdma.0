From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH V2] libibverbs: Allow arbitrary int values for MTU
Date: Fri, 5 Jul 2013 12:11:02 -0700
Message-ID: <CAL1RGDVU9otyMtoit1PJR5JkVy4XvU=4xjL1rN1QB7pq0rVcxA@mail.gmail.com>
References: <1372768306-6786-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1372768306-6786-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 2, 2013 at 5:31 AM, Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> Keep IBV_MTU_* enums values as they are, but pass MTU values around as
> a struct containing a single int.
>
> Per lengthy discusson on the linux-rdma list, this patch introdces a
> source code incompatibility.  Although legacy applications can
> continue to use the enum values, they will need to be updated to use
> the struct.  Newer applications are encouraged to use arbitrary int
> values, not the MTU enums (e.g., 1024, 1500, 9000).

So what happens if I have an old application binary, and I run against
a new libibverbs without recompiling?

Also it seems that I'm forced to change my source code to be able to
compile against new libibverbs?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
