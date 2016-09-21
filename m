From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Wed, 21 Sep 2016 21:32:16 +0530
Message-ID: <CAG53R5WMuojhzFGmqk6nHfypd9Hq4dGsWRKjtUyMZ=RezU-LhQ@mail.gmail.com>
References: <20160910170151.GA5230@obsidianresearch.com> <20160911133421.GA23384@lst.de>
 <20160911143522.GL6415@leon.nu> <20160911171409.GA13442@obsidianresearch.com>
 <20160911172445.GA25953@lst.de> <20160911175235.GB13442@obsidianresearch.com>
 <20160912050717.GE8812@leon.nu> <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu> <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
 <20160921142645.GB10734@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160921142645.GB10734-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Tejun,

On Wed, Sep 21, 2016 at 7:56 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Parav.
>
> On Wed, Sep 21, 2016 at 10:13:38AM +0530, Parav Pandit wrote:
>> We have completed review from Tejun, Christoph.
>> HFI driver folks also provided feedback for Intel drivers.
>> Matan's also doesn't have any more comments.
>>
>> If possible, if you can also review, it will be helpful.
>>
>> I have some more changes unrelated to cgroup in same files in both the git tree.
>> Pushing them now either results into merge conflict later on for
>> Doug/Tejun, or requires rebase and resending patch.
>> If you can review, we can avoid such rework.
>
> My impression of the thread was that there doesn't seem to be enough
> of consensus around how rdma resources should be defined.  Is that
> part agreed upon now?
>

We ended up discussing few points on different thread [1].

There was confusion on how some non-rdma/non-IB drivers would work
with rdma cgroup from Matan.
Christoph explained how they don't fit in the rdma subsystem and
therefore its not prime target to addess.
Intel driver maintainer Denny also acknowledged same on [2].
IB compliant drivers of Intel support rdma cgroup as explained in [2].
With that usnic and Intel psm drivers falls out of rdma cgroup support
as they don't fit very well in the verbs definition.

[1] https://www.spinics.net/lists/linux-rdma/msg40340.html
[2] http://www.spinics.net/lists/linux-rdma/msg40717.html

I will wait for Leon's review comments if he has different view on architecture.
Back in April when I met face-to-face to Leon and Haggai, Leon was in
support to have kernel defined the rdma resources as suggested by
Christoph and Tejun instead of IB/RDMA subsystem.
I will wait for his comments if his views have changed with new uAPI
taking shape.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
