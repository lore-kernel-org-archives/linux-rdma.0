From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Fri, 12 Jun 2015 15:29:25 +0300
Message-ID: <CAJ3xEMiXWN9wC5u6iapKMVb4=bfzdnuy3CaZryV0nOFL_Cgmhw@mail.gmail.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
	<55769561.8000300@mellanox.com>
	<5577FAFB.8020205@mellanox.com>
	<20150610150010.GA11243@obsidianresearch.com>
	<557852EE.5030107@mellanox.com>
	<20150610184954.GA26404@obsidianresearch.com>
	<CAAKD3BB90iZ98B2ADG+=ZYuEVtLq26a99BEjQCR8U1vzvcG+Gw@mail.gmail.com>
	<20150610220154.GA4391@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150610220154.GA4391-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 1:01 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, Jun 10, 2015 at 11:19:03PM +0300, Matan Barak wrote:
>
>> > Sure gid_type is gone, but I didn't say roceve2 specific, I said
>> > latent elements. ie I'm assuming reasons for the scary locking are
>> > because the ripped out rocev2 code needed it?  And some of the
>> > complexity that looks pointless now was supporting ripped out rocev2
>> > elements? That is not necessarily bad, but the code had better be good
>> > quailty and working..
>>
>> Why do you think the locks have anything to do with roce v2?
>
> What else could they be for? The current mlx4 driver doesn't use use
> aggressive performance locking.
>
> After writing this email, I am of the opinion that the locking should
> be simplified to rwsem and mutex, and every use of rcu, READ_ONCE and
> seqlock should be ditched.

Hi Jason,

I understand the email thread went down into further details from this
point and on, but still, I'd like to stop here and ask for short
clarification -- my understanding of things re this reader-writer
scheme is the following:

1. some reader/s can't be made to sleep as they make calls in atomic context
and hence it wouldn't be correct to use RW semaphore

2. some writers go to sleep (invoke driver call to the firmware) and
hence they can't be holding RW spinlock

Agree? if not, can you shortly say what's wrong in these assumptions,
or I should just deeply read the thread.

B/c if these assumptions are correct, seqlock/seqcount seem to me very
much like the right approach. It addresses the constraints 1 and 2
above, simple/robust to implement/use

so?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
