From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Tue, 13 Apr 2010 10:57:32 -0700
Message-ID: <adahbnfme0j.fsf@roland-alpha.cisco.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
	<20100412160359.1d9074dc.akpm@linux-foundation.org>
	<20100412235937.GF15629@obsidianresearch.com>
	<3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3251DDDA-D705-4B1E-9595-9C24709EF146-U0mLk4xYmo8@public.gmane.org> (=?utf-8?Q?=22?=
 =?utf-8?Q?H=C3=A5kon?= Bugge"'s
	message of "Tue, 13 Apr 2010 10:29:41 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?utf-8?Q?H=C3=A5kon?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > I am not sure I agree with the premises here. ptMalloc and malloc
 > hooks are not related to the issue in my opinion. User space library
 > calls do not change virtual to physical mapping, system calls do. Th=
e
 > following sys calls might change virtual to physical mapping:
 > munmap(), mremap(), sbrk(), madvice(). What we need is glibc to
 > provide hooks for these 4 sys calls and the general syscall() when
 > its argument is one of the four mentioned syscalls. To me, that is
 > what is needed, and the ummunotify direction seems way too
 > complicated to me.

Are those system calls the only possible way that virtual to physical
mappings can change?  Can't page migration or something like that
potentially affect things?  And even if you did have hooks into every
system call that mattered (keep in mind that relying on glibc is not
enough, since an MPI application may not use glibc) would decoding them
and figuring out what happened really be preferable to a single event
type that tells you exactly what address range was affected?

 > It is further claimed that "=E2=80=A6 other tricks are not robust". =
I wrote
 > the code used in Scali/Platform MPI handling the issue. I do not
 > think its fair to claim that this MPI is not robust in this matter
 > nor that is performance is bad.

The Open MPI developers have spent a lot of effort trying to handle thi=
s
purely in userspace and still do not believe that a truly robust
solution is possible without kernel help.  Perhaps they can expand on
what the obstacles are.

 - R.
--=20
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go=
 to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
