From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
 calls
Date: Wed, 07 Jul 2010 14:24:45 -0700
Message-ID: <4C34F09D.6080908@redhat.com>
References: <1278527821-14804-1-git-send-email-sdake@redhat.com> <20100707185257.GJ4630@obsidianresearch.com> <4C34D208.1000705@redhat.com> <20100707204712.GK4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707204712.GK4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/07/2010 01:47 PM, Jason Gunthorpe wrote:
> On Wed, Jul 07, 2010 at 12:14:16PM -0700, Steven Dake wrote:
>
>>> But, you surely could not have seen a bug on Linux that was caused by
>>> this - so why was this patch prepared?
>
>> We redefine all the non-thread-safe posix calls in our package (such as
>> readdir) to assert(0).  This prevents their usage in our app.  The
>> reason we do this is to prevent plugin developers from writing plugins
>> that use non-thread-safe posix APIs.  Our app is portable, where the
>> glibc semantics you describe above are not present.  POSIX is blank on
>> this issue, and was addressed in readdir_r.
>
> Well, if you are already creating wrappers, wouldn't it be better to
> provide wrappers that provide the glibc functionality on platforms you
> port to that don't already do that, rather than forbid a perfectly
> functional, and thread safe, call?
>

Not sure how to map a readdir to readdir_r on a thread unsafe system... 
  perhaps with thread keys.  In any regard, seems pointless, readdir_r 
is there and what POSIX specifies for this purpose.

> FWIW, I've always considered readdir_r to be broken, you pass in a
> buffer without passing in a size and hope everything works out. Your

I also have objections to some POSIX standard APIs - however, using 
non-reentrant POSIX apis when reentrant POSIX APIs are available seems 
counterproductive.

> proposed patch to libibverbs is also not-portable because it uses
> NAME_MAX, not pathconf.. Sigh POSIX.
>

On bsd/solaris/darwin/linux, NAME_MAX is defined.  Not sure which other 
POSIX systems one would care about..

> I guess, as a general question, do you know of any libc
> implementations that actually use a static buffer for readdir and
> would require readdir_r to function properly?

I have not looked at each libc's implementation to see if it matches the 
glibc behaviour.  The resolution provided by glibc seems like an 
enhancement over POSIX, where the behaviour is unspecified.

Regards
-steve
>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
