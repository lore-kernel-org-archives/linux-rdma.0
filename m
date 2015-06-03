From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V2 8/9] IB/mlx4: Support extended create_cq and
 query_device uverbs
Date: Wed, 3 Jun 2015 22:35:03 +0300
Message-ID: <CAJ3xEMiPkxf_Qu40AozMRWZaY-dAfEyAOZGyT9VYsNpQO1Q-Zw@mail.gmail.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
	<1433074457-26437-9-git-send-email-ogerlitz@mellanox.com>
	<20150601165649.GC14391@obsidianresearch.com>
	<CAAKD3BBsTFYKwOBK+6u04x6deRYzjYESJzbpyy83UtoChZhpOA@mail.gmail.com>
	<20150602170736.GA17776@obsidianresearch.com>
	<CAAKD3BARPocK1zZ2nYV0xWHqEASJTYbp1aQxwymi-TYTyK_vGA@mail.gmail.com>
	<20150603163146.GD12073@obsidianresearch.com>
	<CAJ3xEMhGdX-35WAjauKZE7+Wg39kbXP35UzYX33J6OB8g_9rYA@mail.gmail.com>
	<20150603191609.GB7902@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150603191609.GB7902-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 3, 2015 at 10:16 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Jun 03, 2015 at 09:58:25PM +0300, Or Gerlitz wrote:
>> On Wed, Jun 3, 2015 at 7:31 PM, Jason Gunthorpe
>> <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
>> > On Wed, Jun 03, 2015 at 11:57:12AM +0300, Matan Barak wrote:
>> >> That's a general comment regarding the extension mechanism.
>> >
>> > Yes, but it is also a specific comment about patch #4 which adds,
>> > ib_uverbs_ex_create_cq.
>> >
>> > Based on the implementation of create_cq, it is pretty clear that
>> > every driver supports ib_uverbs_ex_create_cq, so patch #4 should just
>> > force the flag in the device register function so it is globally enabled.

>> But the other drivers currently do not support any CQ creation flag
>> and hence no extended functionality, I don't see the point signaling
>> towards user-space that the verb is supported, please elaborate.

> They support the base functionality, the flags = 0 case.

which doesn't let consumers to use any new functionality.

> There is no reason to block access to the base functionality via the
> extended api. That just creates hassles for userspace.
> If userspace detects the extended API is present, it can just
> switch unconditionally all usage to that API.

This is user-space run time story, they don't have the knowledge that
all the LL drivers supports the extended api for CQ creation. We had
to check the flag and in all LL drivers since the in-kernel IB stack
has no (and need not to have any) notion of extended calls.

> This is how most new kernel syscalls are introduced (glibc
> does this transparently).

That's an interesting comment. And you know what, basically we can add
auto support for that call in uverbs.

But the point here is a bit different: I somehow have the feeling that
unless ~each and every one of your review comments are accepted to the
letter, no inclusion.

You are not the maintainer here, and even maintainers prefer not to
force each of their detailed comments on submitters.

This specific comment relates TINY in-kernel thing that can be changed later.

If from ten comments you give me I accept as is five, with the other
five I am trying to argue, on two of them we agree to my side, on two
we go your side and on the last one we let the maintainer to cut, this
is a healthy process that makes sense.

Currently it's feels like of either accepting 98% of the comments you
give or no acceptance.

> Detecting what flags a driver supports (if any) is any entirely
> different and orthogonal issue to introducing comp_mask/etc.

I didn't say that the which flags are supported detection relates to
exposing that extended uverbs call. I don't understand the "is any
entirely different" part of the sentence, is that as of me being
EMS-er?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
