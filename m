From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH/ibsim] Provide support for SubnSet(GUIDInfo)
Date: Wed, 21 Sep 2011 09:04:45 -0400
Message-ID: <CAKzyTswY3ebSgWMWhm7aV0n4PHa4O1qxuHu-EqnwER7b7o-=Dg@mail.gmail.com>
References: <20110916210611.GA6926@obsidianresearch.com>
	<CAKzyTsy6QsrufSAFrCDyUUZcZvQU+PHuPjEL7y9SrT3FuaD19Q@mail.gmail.com>
	<20110919155904.GA8113@obsidianresearch.com>
	<CAKzyTsw+VpLaz14eSLNED40QGN3GCeQ5xC7FZp59Da8C1xE3ww@mail.gmail.com>
	<20110919200637.GA28454@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110919200637.GA28454-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 19, 2011 at 4:06 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Mon, Sep 19, 2011 at 03:55:24PM -0400, Hal Rosenstock wrote:
>
>> >> Is this just to make the set of guidinfo simple ? Longer term, this
>> >> should support a GUIDCap > 1 but I suppose that could be a follow on
>> >> patch to this.
>> >
>> > It is to make the existing ibsim compliant with the spec.

You wrote that this was for spec compliance...

>> Yes, supporting set of guidinfo is compliant but I think your
>> treatment of guid 0 in block 0 is overzealous and non compliant.
>
> Having sim return an error if an invalid RO field is written
> is useful from a testing prespective, since nothing should do a set
> without the correct entry 0 GUID.

A correct block 0 entry 0 entry makes no difference on set. The get
response will have the correct value in that entry though regardless
of the value in the set request.

> A strict reading of the spec would say that no GUIDInfo set is
> invalid, even if it tries to set non-zero values for entries past the
> GUIDCap. I don't see how that is useful behavior for ibsim.

A compliant SMA would not have a problem with either of these things.
It wouldn't look at the read only block 0 entry 0 nor at any guids in
a valid block above the guid cap.

-- Hal

> Jason
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
