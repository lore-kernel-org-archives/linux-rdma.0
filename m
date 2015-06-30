From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/5] IB/core: Introduce Fast Indirect Memory Registration
 verbs API
Date: Tue, 30 Jun 2015 15:59:58 +0300
Message-ID: <559292CE.9010303@dev.mellanox.co.il>
References: <1433769339-949-1-git-send-email-sagig@mellanox.com>
 <1433769339-949-2-git-send-email-sagig@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE5C7C@ORSMSX109.amr.corp.intel.com>
 <559281B4.6010807@dev.mellanox.co.il> <20150630121002.GA24169@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150630121002.GA24169-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/30/2015 3:10 PM, Christoph Hellwig wrote:
> On Tue, Jun 30, 2015 at 02:47:00PM +0300, Sagi Grimberg wrote:
>> Kernel 4.1 introduced the new pmem driver for byte addressable storage
>> (https://lwn.net/Articles/640115/). It won't be long before we see HA
>> models where secondary persistent memory devices will sit across an
>> RDMA fabric. (http://www.snia.org/sites/default/files/DougVoigt_RDMA_Requirements_for_HA.pdf)
>

Christoph,

> And what does this bullshitting slide have to do with our memory models?

It was just a slide-deck I found that talks about persistent memory in
combination with RDMA so people can learn more on this if they want to.

> In it's current form the pmem driver can't even be used as a (R)DMA
> target, so it's totally irrelevant for now.

I was referring to initiator mode. My understanding is that with
persistent memory the model changes from the traditional block storage
model.

>
> Let's get a proper in-kernel interface for generic memory registrations
> in place as a first step. le this will be a significant amount of work
> it'll help greatly with moving nasty implementation details out of
> the drivers.  Adding additional registrations methods will be easy
> behind the back of a proper abstraction.

This response is directed to Sean's comment on this being a vendor
specific knob rather than a real limitation in the stack.

As I said before, I'm willing to try and address the existing issues we
have in this area of the stack. However, this is a different discussion.

>
>> Do we want to live with this limitation forever?
>
> I don't think anyone has refused additional support.  Just the way how
> it's done in your patches is a giant nightmare.

Putting the generic API discussion aside for a moment. Indirect
registration just a generalizes FRWR for SG-lists. The API I
proposed is a completely symmetrical API for FRWR. So applications that
implements FRWR can very easily use indirect registration. So I don't
think it is "a giant nightmare".

A generic memory registration API would set as an abstraction layer
that just make the registration operation easier for ULPs. It will be
implemented above the core verbs layer (It wouldn't make sense to do
this abstraction below the verbs) so it will need this API in the core
verbs layer just as well.

Do you have another suggestion on how to expose this feature in the core 
layer?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
