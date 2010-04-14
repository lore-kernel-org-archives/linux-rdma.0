From: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Wed, 14 Apr 2010 12:06:23 +0300
Message-ID: <20100414090623.GM23554@redhat.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
 <adahbnfme0j.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=cp1255
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adahbnfme0j.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: =?utf-8?B?SMOla29u?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 13, 2010 at 10:57:32AM -0700, Roland Dreier wrote:
>  > It is further claimed that "=85 other tricks are not robust". I wr=
ote
>  > the code used in Scali/Platform MPI handling the issue. I do not
>  > think its fair to claim that this MPI is not robust in this matter
>  > nor that is performance is bad.
>=20
> The Open MPI developers have spent a lot of effort trying to handle t=
his
> purely in userspace and still do not believe that a truly robust
> solution is possible without kernel help.  Perhaps they can expand on
> what the obstacles are.
>=20
The problem is that glibc doesn't provide correct type of hooks for MPI
to use. You can hook into free(), but the hook is called when
application frees memory, not when memory is returned back to the kerne=
l
and since MPI wants to cache registration across free()/malloc() if
possible those hooks are not good enough. To overcome this MPI tries to
provide its own memory management library (luckily glibc defines
most/all memory management functions as weak) with proper hooks present=
, but
that poses a whole lot of other problems and memory management is reall=
y
not MPI's job. Even if glibc will provide proper hooks some day HPC use=
rs
may want to use other, more performance oriented, memory management
libraries instead of using build in glibc one. Relying on glibc hooks
will prevent them from doing so.

--
			Gleb.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
