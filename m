From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/9] IB/ipoib: fixup multicast locking issues
Date: Tue, 31 Mar 2015 23:42:29 +0300
Message-ID: <CAJ3xEMhXSTmAEDfn-H808OiSKHtTjS8J0=e8B_98w3Estm_pyw@mail.gmail.com>
References: <cover.1424562072.git.dledford@redhat.com>
	<CAJ3xEMjHrTH_F=zPDsH9A9qRWo=AYN4sgbsdDKV62nzBkB5kXA@mail.gmail.com>
	<F42024C5-60A5-4B92-B4AC-4D225E2C0FC3@redhat.com>
	<20150331170452.GA6261@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150331170452.GA6261-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 31, 2015 at 8:04 PM, ira.weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Mar 15, 2015 at 11:52:44AM -0700, Doug Ledford wrote:
>>
>> > On Mar 13, 2015, at 1:41 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> > On Sun, Feb 22, 2015 at 2:26 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> This is the re-ordered, squashed version of my 22 patch set that I
>> >> posted on Feb 11.  There are a few minor differences between that
>> >> set and this one.  They are:
>> > [...]
>> >
>> > Doug, you wrote here a very detailed listing of the changes from
>> > earlier posts and the testing the patches went through, which is
>> > excellent. It would be very good if you can also post few liner
>> > telling the changes done by the series in high level, so we can have
>> > this test as part of a "merge" commit that says in the kernel logs.
>>
>> OK.  I would take what I had in the original message and expand upon it then:
>>
>> This entire patchset was intended to address the issue of ipoib
>> interfaces being brought up/down in a tight loop, which will hardlock
>> a standard v3.19 kernel.  It succeeds at resolving that problem.
>
>
> I pulled this series and did some medium weight testing on 3.19 (module
> reloads, insmod/rmmod, opensm restarts (client re-register)).  IPoIB recovered
> without issue on each of the tests.
> Tested-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Yep, here too. We tested upstream + this series and it works well.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
