From: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Wed, 14 Apr 2010 10:36:21 -0400
Message-ID: <7A16511A-25C7-4850-9E1A-2EFE53DAF6A4@cisco.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com> <20100412160359.1d9074dc.akpm@linux-foundation.org> <20100412235937.GF15629@obsidianresearch.com> <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com> <adahbnfme0j.fsf@roland-alpha.cisco.com> <20100414090623.GM23554@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100414090623.GM23554-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Apr 14, 2010, at 5:06 AM, Gleb Natapov wrote:

> > The Open MPI developers have spent a lot of effort trying to handle this
> > purely in userspace and still do not believe that a truly robust
> > solution is possible without kernel help.  Perhaps they can expand on
> > what the obstacles are.

By "truly robust" we mean that some other user-level code can't override the hooks installed by the MPI (user level) middleware.  All current glibc hooks are overridable by other user-level code -- and sometimes real applications do this (for their own good reasons).  Most of the time, apps blithely override our hooks because they either don't know or can't know that our hooks are installed.  It can be dicey to know what you can and cannot override pre-main(), for example (e.g., via the __malloc_initialize_hook).

Opening up a direct channel to the kernel and saying "hey, tell me when something changes" is robust because no other entity can hijack your notifications.  It also allows us to avoid using pre-main hooks, and makes it so that we don't have to hook into the memory subsystem (usually replacing it with our own).  Both of these things are extremely distasteful -- fixing these two things alone make doing something like ummunotify worthwhile, IMHO.

-- 
Jeff Squyres
jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
