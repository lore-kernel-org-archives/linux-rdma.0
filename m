From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 39/43] IB/core: Add arbitrary sg_list support
Date: Wed, 22 Jul 2015 20:29:44 +0300
Message-ID: <55AFD308.1070104@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-40-git-send-email-sagig@mellanox.com>
 <20150722172255.GD26909@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150722172255.GD26909-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 8:22 PM, Jason Gunthorpe wrote:
> On Wed, Jul 22, 2015 at 09:55:39AM +0300, Sagi Grimberg wrote:
>> +enum ib_mr_flags {
>> +	IB_MR_MAP_ARB_SG = 1,
>> +};
>
> Something about this just seems ugly. We are back to what we were
> trying to avoid: Adding more types of MRs..
>
> Is this really necessary? Do you really need to know the MR type when
> the MR is created, or can the adaptor change types on the fly during
> registration?
>
> iSER for example has a rarely used corner case where it needs this,

I can tell you that its anything but a corner case. direct-io, bio
merges, FS operations and PI are examples where most of the sg lists
*will* be "gappy".

Trust me, it's fairly common to see those...

> but it just turns on the feature unconditionally right away. This
> incures 2x the overhead in the MR allocations and who knows what
> performance impact on the adaptor side.

I ran various workloads with this, and performance seems to sustain.

>
> It would be so much better if it could switch to this mode on a SG by
> SG list basis.

It would, but unfortunately it can't.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
