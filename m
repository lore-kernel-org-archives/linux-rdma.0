From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V5 00/12] Move RoCE GID management to IB/Core
Date: Thu, 11 Jun 2015 12:51:21 +0300
Message-ID: <CAAKD3BBh7Zx4Lsaw+4ovaLr_sjG64KD_pooGVdhC9B3-jAGHAQ@mail.gmail.com>
References: <1433772735-22416-1-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A8FE5D17@ORSMSX109.amr.corp.intel.com>
	<55769561.8000300@mellanox.com>
	<5577FAFB.8020205@mellanox.com>
	<20150610150010.GA11243@obsidianresearch.com>
	<1433981756.71666.60.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433981756.71666.60.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-iNbyuHi0droAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 11, 2015 at 3:15 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Wed, 2015-06-10 at 09:00 -0600, Jason Gunthorpe wrote:
>> On Wed, Jun 10, 2015 at 11:53:15AM +0300, Or Gerlitz wrote:
>>
>> > Jason, can you ack that this post addressed your comments?
>>
>> Well, I asked for a cleanup series, multiple times, and this is the
>> closest things have got.
>>
>> It isn't really a cleanup because the whole gid table is new code and
>> has latent elements for rocev2 - this is why it is so much bigger than
>> it should be.
>
> I'm not sure the complexity here is "latent RoCEv2" stuff versus simple
> over-design.  I didn't see anything in the RoCEv2 that warranted this
> level of complexity either.
>
> Just to be clear, I'm currently reviewing the RCU usage here.  Jason has
> brought up specific issue, if I can't convince myself that his
> objections to the RCU usage are wrong, then I'm going to second his
> request that we go back to a more simplistic rwlock.
>

The RCU protects the ndev from being freed and not the table itself.

>> The other core parts have been mostly trimmed, so that is the specific
>> things discussed last round.
>>
>> Is it Ok to go ahead with the gid table as is? I don't know, I haven't
>> studied the patch in any detail. Technically, that is not best
>> practice for kernel development process.
>>
>> Jason
>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
