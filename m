From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Add missing systemd-devel dependency to the
 SUSE rdma-core.spec
Date: Wed, 6 Dec 2017 18:24:20 +0100
Message-ID: <c6d617e2-a531-b159-c67a-ddd9179ff424@suse.de>
References: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
 <024a3b6a-2f04-36ee-5d4f-51f9e8cb719e@suse.de>
 <20171206171349.GF29197@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171206171349.GF29197-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 06/12/2017 à 18:13, Jason Gunthorpe a écrit :
> On Wed, Dec 06, 2017 at 09:00:50AM +0100, Nicolas Morey-Chaisemartin wrote:
>>
>> Le 06/12/2017 à 00:40, Tatyana Nikolova a écrit :
>>> Without systemd-devel, all rdma-core daemons are using shim version of
>>> systemd include file (in-turn, shim version of systemd functions)
>>> causing them to not communicate with systemd.
>>>
>>> Add the missing required systemd-devel package to SUSE's rdma-core.spec
>>> so the correct header file is used and correct functions are linked
>>> with the daemons.
>>>
>>> Fixes: 8854eefa60b5 ("suse: Add spec file for SUSE")
>>> Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>>  suse/rdma-core.spec | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/suse/rdma-core.spec b/suse/rdma-core.spec
>>> index 0eba0507..912a77c5 100644
>>> +++ b/suse/rdma-core.spec
>>> @@ -57,6 +57,7 @@ BuildRequires:  pkgconfig
>>>  BuildRequires:  pkgconfig(libsystemd)
>>>  BuildRequires:  pkgconfig(libudev)
>>>  BuildRequires:  pkgconfig(systemd)
>>> +BuildRequires:  pkgconfig(systemd-devel)
>>>  BuildRequires:  pkgconfig(udev)
>>>  BuildRequires:  python3-base
>>>  %ifnarch s390 s390x
>> You should not need that.
>> This is what this line is for:
>>
>>  BuildRequires:  pkgconfig(systemd)
> I actually think pkgconfig(systemd) is a mistake in the spec file..
>
> This brings in the libraries:
>
>   BuildRequires:  pkgconfig(libsystemd)
>
> This is does something else and isn't needed, AFAIK:
>
>   BuildRequires:  pkgconfig(systemd)

This was requested by the main OpenSUSE maintainer so I blindly trusted him with this :)
I'll still ask him if both are really needed (and if yes, what's the diff)
> Same with udev:
>   BuildRequires:  pkgconfig(libudev)
> vs
>   BuildRequires:  pkgconfig(udev)
>
> But you explained in the past suse needed actual udev installed for some
> reason I can't remember..
Our build systems checks that scriptlets call existing binaries.
Without udev, udevadm does not exists which gets some errors in the build logs.

>> We don't expressly name systemd-devel and use the pkgconfig macro to
>> allow building using systemd-mini-devel when needed.
> I suspect Tatyana has an old version of suse where
> 'pkgconfig(libsystemd)' doesn't do the right thing.
>
> I suspect the issue is that old versions of suse probably have the old
> arrangement of systemd libraries that were split into three libraries
> (libsystemd-journal, libsystemd-id128, and libsystemd-daemon)
> so pkgconfig(libsystemd) isn't going to work (and rpmbuild should fail
> fail, why doesn't it??)

The current works with version down to SLE12. I doubt anyone would run rdma-core on older releases as it very ancient.
Tatyana, could you give some more info on what prompted this patch ?
> Probably something like
>
> BuildRequires:  pkgconfig(libsystemd) | (pkgconfig(libsystemd-journal), pkgconfig(libsystemd-id128), pkgconfig(libsystemd-daemon))
>
> If RPM can do that, otherwise a suse version conditional?

Version conditionnal is better. But I'd like to know what the exact problem is before tweaking that.

rdma-core is at the middle of huge build dependencies that involve systemd, boost and a bunch of other stuff. I have to be very careful with these dependencies not to mess everything up.

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
