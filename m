From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Mon, 28 Sep 2009 22:49:23 +0200
Message-ID: <20090928204923.GA1960@elf.ucw.cz>
References: <aday6omhz9d.fsf@cisco.com> <20090915113434.GF1328@ucw.cz> <ada7hw0gsqz.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada7hw0gsqz.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue 2009-09-15 07:57:56, Roland Dreier wrote:
> 
>  > I don't remember seeing discussion of this on lkml. Yes it  is in
>  > -next...
> 
> eg http://lkml.org/lkml/2009/7/31/197 and followups, or search for v2
> and earlier patches.

Well... it seems little overspecialized. Just modifying libc to
provide hooks you want looks like better solution.

>  > Basically it allows app to 'trace itself'? ...with interesting mmap()
>  > interface, exporting int to userspace, hoping it behaves atomically...? 
> 
> Yes, it allows app to trace what the kernel does to memory mappings.  I
> don't believe there's any real issue to atomicity of mmap'ed memory,
> since userspace really just tests whether read value is == to old read
> value or not.

That still needs memory barriers etc.. to ensure reliable operation,
no?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
