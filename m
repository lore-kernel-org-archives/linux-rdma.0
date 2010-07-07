From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] change thread-unsafe readdir to thread-safe readdir_r
 calls
Date: Wed, 07 Jul 2010 15:17:12 -0700
Message-ID: <4C34FCE8.4070208@redhat.com>
References: <1278527821-14804-1-git-send-email-sdake@redhat.com> <20100707185257.GJ4630@obsidianresearch.com> <4C34D208.1000705@redhat.com> <20100707204712.GK4630@obsidianresearch.com> <4C34F09D.6080908@redhat.com> <20100707214920.GN4630@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100707214920.GN4630-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/07/2010 02:49 PM, Jason Gunthorpe wrote:
> On Wed, Jul 07, 2010 at 02:24:45PM -0700, Steven Dake wrote:
>
>> Not sure how to map a readdir to readdir_r on a thread unsafe system...
>> perhaps with thread keys.  In any regard, seems pointless, readdir_r is
>> there and what POSIX specifies for this purpose.
>
> Override opendir and allocate the buffer then and return a pointer to it
> through a custom 'DIR *'.
>
>>> FWIW, I've always considered readdir_r to be broken, you pass in a
>>> buffer without passing in a size and hope everything works out. Your
>>
>> I also have objections to some POSIX standard APIs - however, using
>> non-reentrant POSIX apis when reentrant POSIX APIs are available seems
>> counterproductive.
>
> Well, if the non-reentrant ones are badly designed I'm not sure it is
> a good trade.. Ie Solaris's man pages say:
>
>   It is safe to use readdir() in a threaded application, so long as only
>   one thread reads from the directory stream at any given time. The
>   readdir() function is generally preferred over the readdir_r()
>   function.
>
> Also see
>
> http://lists.grok.org.uk/pipermail/full-disclosure/2005-November/038295.html
>
> The horribleness of readdir_r is well documented, and is partly why
> libc's advocate thread safe readdir() desipte the existence of
> readdir_r.
>
>>> proposed patch to libibverbs is also not-portable because it uses
>>> NAME_MAX, not pathconf.. Sigh POSIX.
>
>> On bsd/solaris/darwin/linux, NAME_MAX is defined.  Not sure which other
>> POSIX systems one would care about..
>
> If all you care able is bsd/solaris/darwin/linux then this is a
> non-problem, AFAIK they have sane libc's :) Ie I just checked and
> openbsd libc has been using a dynamic buffer allocated at opendir
> since 1996.
>
> If you care about theortical portability then you have to worry about
> NAME_MAX too..
>

Thanks I'll look into NAME_MAX for my server.

Regards
-steve
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
