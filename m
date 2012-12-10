From: Garrett Cooper <yanegomi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Avoid linker error with clang 3.0
Date: Sun, 9 Dec 2012 22:12:16 -0800
Message-ID: <CAGH67wQ9ER9JLHR9ZKmzwMaGuV4m_5LdsHbKZvfYw1ekojik2Q@mail.gmail.com>
References: <alpine.BSF.2.00.1212090306300.64779@toaster.local>
	<50C490D9.1000301@acm.org>
	<CAGH67wS1P43ssD+-VFyCupLw3CT8U73wT-aT6N2AS5ddWApAoA@mail.gmail.com>
	<CAGH67wQt48zEp0KiN44w=wfYZy+FA6oc=ehuAHUL2QBo=A1nhw@mail.gmail.com>
	<ABB9B291-3AB5-4AE6-8CE2-5FE691E1AE02@gmail.com>
	<20121210060600.GA30472@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121210060600.GA30472-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 9, 2012 at 10:06 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

...

> It is definately a bug in the code, it should be 'static inline' - the
> reason it doesn't blow up on gcc is most likely because nobody ever
> compiled it with a low enough optimization level to see it.
>
> Looks to me like clang is fine, no bug there.

I've been corrected by several people both in the FreeBSD and clang
projects today. The summary is:
1. What clang's doing is correct via c99. static inline is the most
correct way to do this while inline'ing the function per-c99 (which I
didn't understand until today because I was unaware of that point in
the standard). In particular:
    i. With -O0 and -O1 it will fail as noted before.
    ii. With -O2 and higher it will optimize out without error (which
could account for me not seeing this until I ran the build on Fedora
17 as I haven't installed a make.conf with non-default CFLAGS and
didn't call the Makefiles with any optimization settings).
2. gcc silently optimizes it out. This is a gcc extension to c89 and
c99 (aka gnu89 and gnu99).
Thanks!
-Garrett
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
