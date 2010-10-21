From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 1/2] RPING: Make sure CQ event thread exits before
 destroying the CQ.
Date: Thu, 21 Oct 2010 12:16:33 +0200
Message-ID: <AANLkTi=eJdjgQ4MKPxddUA2eBOswf-5fo5wm=JzX=Hib@mail.gmail.com>
References: <20101020192859.1431.68877.stgit@build.ogc.int>
 <AANLkTi=uAuXT1RMEQ+vsA4FkN2828mZ2q0KPKXxpb6H0@mail.gmail.com>
 <4CBF4D30.3050500@opengridcomputing.com> <AANLkTimTpM_h7P8tacZic2aP7i=dBiAquDN5S_D881ae@mail.gmail.com>
 <20101020203551.GO10362@obsidianresearch.com> <4CBF5786.2020203@opengridcomputing.com>
 <20101020211617.GP10362@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101020211617.GP10362-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 20, 2010 at 11:16 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Oct 20, 2010 at 03:56:38PM -0500, Steve Wise wrote:
>
>> Hey Jason, do you have a pointer to the list of pthread cancellation
>> points for Linux?
>
> Sure do
>
> http://www.kernel.org/doc/man-pages/online/pages/man7/pthreads.7.html
>
> POSIX:2008 is a more authoritative source, the above is cribbed from
> there.
> [ ... ]

The IEEE Std 1003.1, 2004 Edition list of cancellation points is available here:
http://www.opengroup.org/onlinepubs/000095399/functions/xsh_chap02_09.html

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
