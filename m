From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH] infiniband: avoid overflow warning
Date: Mon, 31 Jul 2017 21:19:22 +0200
Message-ID: <CAK8P3a04DR6NT5jXJSmcw_cDjuKQ-y6f1SQz0cD9Bp=OaoaAhQ@mail.gmail.com>
References: <20170731065016.2947796-1-arnd@arndb.de> <CAG9sBKNaFTAuf2gL9QLOCwvH-xAq7SXfaMZxNMFo7d=6cH3TkQ@mail.gmail.com>
 <CAK8P3a2AP7WSF2HUe_4nxsNFqCit_djKdd3_5ab6P1YgP7bvJQ@mail.gmail.com>
 <1501515117.2466.9.camel@wdc.com> <CAK8P3a1r22C-Uxs93OSbS4_eRNhKUTv8xwc6wwGahE80whCjyA@mail.gmail.com>
 <1501517853.2466.12.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1501517853.2466.12.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org" <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 31, 2017 at 6:17 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
> On Mon, 2017-07-31 at 18:04 +0200, Arnd Bergmann wrote:
>> On Mon, Jul 31, 2017 at 5:32 PM, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org> wrote:
>> > So inetaddr_event() assigns AF_INET so .sin_family and gcc warns about code
>> > that is only executed if .sin_family == AF_INET6? Since this warning is the
>> > result of incorrect interprocedural analysis by gcc, shouldn't this be
>> > reported as a bug to the gcc authors?
>>
>> I think the interprocedural analysis here is just a little worse than it could
>> be, but it's not actually correct.  It's not gcc that prints the warning (if
>> it did, then I'd agree it would be a gcc bug) but the warning is triggered
>> intentionally by the fortified version of memcpy in include/linux/string.h.
>>
>> The problem as I understand it is that gcc cannot guarantee that it
>> tracks the value of addr->sa_family at  least as far as the size of the
>> stack object, and it has no strict reason to do so, so the inlined
>> rdma_ip2gid() will still contain both cases.
>
> Hello Arnd,
>
> Had you already considered to uninline the rdma_ip2gid() function?

Not really, that would prevent the normal optimization from happening,
so that would be worse than uninlining addr_event() as I tried.

It would of course get rid of the warning, so if you think that's a better
solution, I won't complain.

       Arnd
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
