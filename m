From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv1 6/6] rdmacg: Added documentation for rdma controller.
Date: Thu, 7 Jan 2016 04:14:26 +0530
Message-ID: <CAG53R5WD18VK3sVuVnPR7yjEBqRjHAoUkCpZKzSd9-PYZrx-YA@mail.gmail.com>
References: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
	<1452020286-9508-7-git-send-email-pandit.parav@gmail.com>
	<20160105215309.GG5995@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160105215309.GG5995-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 6, 2016 at 3:23 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Jan 06, 2016 at 12:28:06AM +0530, Parav Pandit wrote:
>> +5-4-1. RDMA Interface Files
>> +
>> +  rdma.resource.verb.list
>> +  rdma.resource.verb.limit
>> +  rdma.resource.verb.usage
>> +  rdma.resource.verb.failcnt
>> +  rdma.resource.hw.list
>> +  rdma.resource.hw.limit
>> +  rdma.resource.hw.usage
>> +  rdma.resource.hw.failcnt
>
> Can you please read the rest of cgroup.txt and put the interface in
> line with the common conventions followed by other controllers?
>

Yes. I read through. I can see two changes to be made in V2 version of
this patch.
1. rdma.resource.verb.usage and rdma.resource.verb.limit to change
respectively to,
2. rdma.resource.verb.stat and rdma.resource.verb.max.
3. rdma.resource.verb.failcnt indicate failure events, which I think
should go to events.
I roll out new patch for events post this patch as additional feature
and remove this feature in V2.

rdma.resource.verb.list file is unique to rdma cgroup, so I believe
this is fine.

We will conclude whether to have rdma.resource.hw.<files> or not in
other patches.
I am in opinion to keep "resource" and "verb" or "hw" tags around to
keep it verbose enough to know what are we trying to control.

Is that ok?

> Thanks.
>
> --
> tejun
