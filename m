From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: rdma kernel tree
Date: Tue, 19 May 2015 21:47:06 +0300
Message-ID: <CAJ3xEMjkECDrbCFksSMMTSUusOhrU+qvMnXjkg=OuFaeYKoT0Q@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A82373A8FD8CF5@ORSMSX109.amr.corp.intel.com>
	<1431485563.43876.93.camel@redhat.com>
	<CAJ3xEMhRY6nLPFR8qT8S7KJvxRDmw6JwhsSKw7pTvFc5PpnrhQ@mail.gmail.com>
	<1431530845.2377.30.camel@redhat.com>
	<5554B7E8.4020902@mellanox.com>
	<1431615776.3276.14.camel@redhat.com>
	<CAJ3xEMjgpegf+D2BBZ8RPERkdUO3yH4U1LjiK+i4iF=_PtpQkA@mail.gmail.com>
	<555ABD9D.3080303@mellanox.com>
	<1432038160.3114.16.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432038160.3114.16.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 3:22 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 2015-05-19 at 07:35 +0300, Or Gerlitz wrote:
>> >> I pulled that via a bundle from patchworks.  I'll double check it.
>> > Did  you check it out? fixed it out?
>>
>> I took a look now, you've rebased to-be-rebased/for-4.2 to 4.1-rc4 and
>
> Correct.
>
>> it seems this is what you are going to push into the kernel.org treem
>
> Correct.
>
>> but this series is still there with the zillion tested/reviewed/etc
>> signature per one 2-3 patch, I think we've agreed this needs to be
>> addressed prior to the upstream push, right?
>
> Incorrect.  What you objected to before was the large Cc: list in the
> patches.  That is gone.  What is there now is just the reviewed-by: list
> of three people, and the tested-by list of two people.  As the entire
> patch set as a whole was reviewed and tested by those people, it seems
> accurate to me.

Doug, I have never ever seen a patch set (specifically the 15~23 part
of it) with that level of simplicity and
signature/reviewers/tested-by/etc inflation. It's just eye burner.
Maybe that long list is OK for patch #1 but very much not to these
bunch of 1-2 liner downstream patches.

AFAIK, this is Michael's 1st upstream contribution and there's no
reason for him to think something here is deeply wrong and/or should
have been done differently if we let it go that way into the kernel
logs forever.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
