From: Gleb Natapov <gleb-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Date: Wed, 14 Apr 2010 11:52:28 +0300
Message-ID: <20100414085228.GL23554@redhat.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
 <20100412160359.1d9074dc.akpm@linux-foundation.org>
 <20100412235937.GF15629@obsidianresearch.com>
 <3251DDDA-D705-4B1E-9595-9C24709EF146@Sun.com>
 <adahbnfme0j.fsf@roland-alpha.cisco.com>
 <1271181774.4807.1868.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1271181774.4807.1868.camel@twins>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, =?utf-8?B?SMOla29u?= Bugge <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 13, 2010 at 08:02:54PM +0200, Peter Zijlstra wrote:
> On Tue, 2010-04-13 at 10:57 -0700, Roland Dreier wrote:
> > Are those system calls the only possible way that virtual to physical
> > mappings can change?  Can't page migration or something like that
> > potentially affect things?  And even if you did have hooks into every
> > system call that mattered (keep in mind that relying on glibc is not
> > enough, since an MPI application may not use glibc) would decoding them
> > and figuring out what happened really be preferable to a single event
> > type that tells you exactly what address range was affected? 
> 
> Yeah, virtual<->physical maps can change through swapping, page
> migration, memory compaction, huge-page aggregation (the latter two not
> yet being upstream).
> 
> Even mlock() doesn't pin virtual<->physical maps.
Pages registered for RDMA are GUPed so no method above should touch
them. Fork+cow or unmap/map on the other hand can change
virtual<->physical maps. GUPed pages are still GUPed, but they are no
longer mapped into process' virtual address space. MPI copes with
Fork+cow by marking registered memory as MADV_DONTFORK.

--
			Gleb.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
