From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Wed, 10 Jun 2015 18:08:30 +0300
Message-ID: <557852EE.5030107@mellanox.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
 <55769561.8000300@mellanox.com> <5577FAFB.8020205@mellanox.com>
 <20150610150010.GA11243@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150610150010.GA11243-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-xCNTGe7nOvUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 6/10/2015 6:00 PM, Jason Gunthorpe wrote:
> On Wed, Jun 10, 2015 at 11:53:15AM +0300, Or Gerlitz wrote:
>
>> Jason, can you ack that this post addressed your comments?
>
> Well, I asked for a cleanup series, multiple times, and this is the
> closest things have got.
>
> It isn't really a cleanup because the whole gid table is new code and
> has latent elements for rocev2 - this is why it is so much bigger than
> it should be.
>

I disagree. Could you please point on anything that is RoCE V2 specific?
The essence of RoCE V2 in the previous series was the gid_type part.
This is now completely removed.

> The other core parts have been mostly trimmed, so that is the specific
> things discussed last round.
>
> Is it Ok to go ahead with the gid table as is? I don't know, I haven't
> studied the patch in any detail. Technically, that is not best
> practice for kernel development process.
>
> Jason
>

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
