From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Sun, 20 May 2012 19:35:30 -0700
Message-ID: <CAG4TOxPpNxFvR_8GkAJ6erDBHBUQzQe3ReFKnK6gBkfAYhRMeQ@mail.gmail.com>
References: <1337562868-9887-1-git-send-email-roland@kernel.org> <20120521120526.fcd34b38fa4d21fdfd28728b@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120521120526.fcd34b38fa4d21fdfd28728b-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, May 20, 2012 at 7:05 PM, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org=
> wrote:

>> Vipul Pandya (10):
>> =A0 =A0 =A0 cxgb4: Detect DB FULL events and notify RDMA ULD
>> =A0 =A0 =A0 cxgb4: Common platform specific changes for DB Drop Reco=
very
>> =A0 =A0 =A0 cxgb4: DB Drop Recovery for RDMA and LLD queues
>> =A0 =A0 =A0 RDMA/cxgb4: Add debugfs RDMA memory stats
>> =A0 =A0 =A0 RDMA/cxgb4: Add DB Overflow Avoidance
>> =A0 =A0 =A0 RDMA/cxgb4: Disable interrupts in c4iw_ev_dispatch()
>> =A0 =A0 =A0 RDMA/cxgb4: DB Drop Recovery for RDMA and LLD queues
>> =A0 =A0 =A0 RDMA/cxgb4: Use vmalloc() for debugfs QP dump

> This commit breaks (at least) powerpc builds and has not bee in linux=
-next
> before today.

Sorry about that. Which commit in particular?  The vmalloc one?
What's the error?

(I did add this patchset to my for-next branch on Friday at the
latest, but I understand if you didn't do a linux-next build over the
past 48 weekend hours :)

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
