From: "Robert D. Russell" <rdr-zcUZCMB5SQOVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before
 destroying the CQ.
Date: Wed, 20 Oct 2010 17:05:00 -0400 (EDT)
Message-ID: <alpine.LNX.2.00.1010201704210.16382@postal.iol.unh.edu>
References: <20101020192859.1431.68877.stgit@build.ogc.int> <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com> <4CBF4D30.3050500@opengridcomputing.com> <AANLkTimTpM_h7P8tacZic2aP7i=dBiAquDN5S_D881ae@mail.gmail.com> <20101020203551.GO10362@obsidianresearch.com>
 <4CBF5786.2020203@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CBF5786.2020203-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 20 Oct 2010, Steve Wise wrote:

> On 10/20/2010 03:35 PM, Jason Gunthorpe wrote:
>> On Wed, Oct 20, 2010 at 10:23:25PM +0200, Bart Van Assche wrote:
>>
>> 
>>> Please keep in mind that glibc uses locking internally for many file
>>> I/O functions, e.g. printf() and fprintf().
>>> 
>> POSIX strictly defines what functions are, aren't and could be
>> cancellation points, yes it is a surprising list. But, glibc won't
>> break internally if you cancel any of its function calls. It has
>> cleanup handlers and what not to protect itself.
>> 
>> rping doesn't hold locks, or allocate memory in the cq_thread, so it
>> seems OK to me. My main question would be what happens internally to
>> ibverbs, and does it call any possible cancellation point while holding
>> locks - is it missing cleanup handlers? Etc.
>> 
>> Jason
>> 
>
> Hey Jason, do you have a pointer to the list of pthread cancellation points 
> for Linux?
>
> Steve.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Steve:

On a linux system, just try
man 7 pthreads
and scroll down to the cancellation points lists.

Bob

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
