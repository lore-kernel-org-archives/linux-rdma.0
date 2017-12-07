From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] rdma-core: Add missing systemd-devel dependency to the
 SUSE rdma-core.spec
Date: Thu, 7 Dec 2017 16:22:00 +0100
Message-ID: <b7452ea6-cef8-a9f7-66d7-621d7e12c64f@suse.de>
References: <20171205234005.10904-1-tatyana.e.nikolova@intel.com>
 <024a3b6a-2f04-36ee-5d4f-51f9e8cb719e@suse.de>
 <20171206171349.GF29197@mellanox.com>
 <c12fd49f-5dd3-1e33-d3ee-2b865527c8d6@suse.de>
 <20171207145951.GA18095@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171207145951.GA18095-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 07/12/2017 à 15:59, Jason Gunthorpe a écrit :
> On Thu, Dec 07, 2017 at 10:57:08AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>> On a recent systemd, systemd-devel provides all those (probably for compat reason during migration):
>> $ rpm -q --provides systemd-devel
>> pkgconfig(libsystemd) = 228
>> pkgconfig(libsystemd-daemon) = 228
>> pkgconfig(libsystemd-id128) = 228
>> pkgconfig(libsystemd-journal) = 228
>> pkgconfig(libsystemd-login) = 228
>>
>>
>> So I can porobably safely changes the BuildRequires to the libsystemd-XXXX.
>> If I'm not mistaken, we just need the -daemon and -journal ones.
> cmake checks for all id128 as well when it runs in compat mode, so you
> need all three to make it happy.
>
> I wouldn't change the main spec file, maybe protect the 2nd option
> with a ifdef for old suse versions?

I don't really mind either way.

However is there any chance that it will work ?
I'm pretty sure there are some (if not many) ABI changes from ibverbs 1.2.0 to rdma-core v16.
This means that all dependent packages needs to be rebuilt, and some probably updated too.

>From my SUSE package maintainer perspective, that is something that should not be done and SUSE will not provide any official support for that.
Regarding upstream we can't really forbid people to do this, just try to point them in a "sane" direction :)

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
