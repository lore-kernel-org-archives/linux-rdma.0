From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Issues with starting srp_daemon userspace for a 4.13 kernel
Date: Wed, 19 Jul 2017 13:49:24 -0600
Message-ID: <20170719194924.GA14799@obsidianresearch.com>
References: <b74ff7c3-734b-71ae-6b67-9a8ccf255bf6@redhat.com>
 <20170718194846.GA6048@obsidianresearch.com>
 <ef6d29a5-9632-bd9b-1113-1de6671031cc@redhat.com>
 <1500408333.2664.6.camel@wdc.com>
 <5ca055dc-199f-ee29-fc99-126db132df10@redhat.com>
 <8357b19a-26f4-4c27-1b61-b122d4d1a9fd@redhat.com>
 <026eedf1-175d-b8df-8396-2bc378e7a5df@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <026eedf1-175d-b8df-8396-2bc378e7a5df-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 19, 2017 at 03:40:06PM -0400, Laurence Oberman wrote:

> Jason did I misunderstand you.
> That you were saying this patch was the issue.
> I thought you were saying this was the fix.

Er, that isn't the patch I quoted, that is the broken patch the patch
I quoted fixes:

>> Subject: [PATCH v2 1/2] RDMA/uverbs: Fix the check for port number
>>
>> The port number is only valid if IB_QP_PORT is set in the mask.
>> So only check port number if it is valid to prevent modify_qp from
>> failing due to an invalid port number.
>>
>> Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v2.6.14+
>> Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

You need the above if you have 5ecce4c9b17b in your tree.

Not sure why it still doesn't seem to be in Linus's tree...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
