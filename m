From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 1/3] IB/uverbs: Enable device removal when
 there are active user space applications
Date: Thu, 28 May 2015 00:36:46 +0300
Message-ID: <CAJ3xEMiYbrr2mkXuywNcyYu1v0dqeM+6Lks-CL0U6fSnx=DQ+Q@mail.gmail.com>
References: <1431515438-24042-1-git-send-email-yishaih@mellanox.com>
	<1431515438-24042-2-git-send-email-yishaih@mellanox.com>
	<20150525165449.GA4379@obsidianresearch.com>
	<1432742669.28905.228.camel@redhat.com>
	<20150527174332.GC9909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150527174332.GC9909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 27, 2015 at 8:43 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Wed, May 27, 2015 at 12:04:29PM -0400, Doug Ledford wrote:
>> On Mon, 2015-05-25 at 10:54 -0600, Jason Gunthorpe wrote:
>> > On Wed, May 13, 2015 at 02:10:36PM +0300, Yishai Hadas wrote:
>> >
>> > > + struct srcu_struct                      disassociate_srcu;
>> >
>> > There is no need for rcu for this, use a rw sem.
>>
>> The rcu was used becuase it's on the hot path I assume.
>
> Perhaps, I looked at that a bit, it was used on syscall paths, but
> that wasn't even the big reason I made the comment..

Doug, what hot path we have in uverbs?! IB's stack hot path goes from
user-space to the HW, right?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
