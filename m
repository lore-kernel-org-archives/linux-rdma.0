From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Tue, 13 Apr 2010 10:29:41 +0200
Message-ID: <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20100412235937.GF15629-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Apr 13, 2010, at 1:59 , Jason Gunthorpe wrote:

> On Mon, Apr 12, 2010 at 04:03:59PM -0700, Andrew Morton wrote:
>=20
>>> As discussed in <http://article.gmane.org/gmane.linux.drivers.openi=
b/61925>
>>> and follow-up messages, libraries using RDMA would like to track
>>> precisely when application code changes memory mapping via free(),
>>> munmap(), etc.  Current pure-userspace solutions using malloc hooks
>>> and other tricks are not robust, and the feeling among experts is t=
hat
>>> the issue is unfixable without kernel help.

I am not sure I agree with the premises here. ptMalloc and malloc hooks=
 are not related to the issue in my opinion. User space library calls d=
o not change virtual to physical mapping, system calls do. The followin=
g sys calls might change virtual to physical mapping: munmap(), mremap(=
), sbrk(), madvice(). What we need is glibc to provide hooks for these =
4 sys calls and the general syscall() when its argument is one of the f=
our mentioned syscalls. To me, that is what is needed, and the ummunoti=
fy direction seems way too complicated to me.

It is further claimed that "=85 other tricks are not robust". I wrote t=
he code used in Scali/Platform MPI handling the issue. I do not think i=
ts fair to claim that this MPI  is not robust in this matter nor that i=
s performance is bad.


Thanks, H=E5kon


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
