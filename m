From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2 00/12] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Mon, 3 Aug 2015 11:33:51 -0700
Message-ID: <55BFB40F.8000500@sandisk.com>
References: <1438298547-21404-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55BBF4B8.2050700@sandisk.com> <20150803152420.GA24193@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150803152420.GA24193-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Yen <chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dominique Martinet <dominique.martinet-KCE40YydGKI@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Van Hensbergen <ericvh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ido Shamay <idos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Latchesar Ionkov <lucho-OnYtXJJ0/fesTnJN9+BGXg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ron Minnich <rminnich-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Simon Derr <simon.derr-6ktuUTfB/bM@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org" <rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/03/2015 08:24 AM, Christoph Hellwig wrote:
> On Fri, Jul 31, 2015 at 03:20:40PM -0700, Bart Van Assche wrote:
>> SRP login fails with this patch series applied on top of Linux kernel
>> v4.2-rc4. At the target side the following message appears every time the
>> SRP initiator tries to log in: "ib_srpt: RDMA t 5 for idx 0 failed with
>> status 10" (10=remote access error). That causes the initiator to receive a
>> flush error (5).
>
> Could this be caused because srp_map_sg_entry falls back to the phys
> mapping for unaligned large requests in line 1389 in Dougs tree:
>
> 	if ((!dev->use_fast_reg && dma_addr & ~dev->mr_page_mask) ||
> 	    dma_len > dev->mr_max_size) {
> 		ret = srp_finish_mapping(state, ch);
> 		if (ret)
> 			return ret;
>
> 		srp_map_desc(state, dma_addr, dma_len, target->rkey);
> 		srp_map_update_start(state, NULL, 0, 0);
> 		return 0;
> 	}

This morning I added WARN_ON_ONCE(!target->rkey) statements in the code
paths that use target->rkey and that revealed that the above code
was indeed the culprit. Changing the default registration method from 
FMR into FR should be sufficient to avoid that the above code is 
triggered for HCA's that support FR (e.g. ConnectX-3 and ConnectX-4). 
For HCA's that support FMR but not FR, how about telling the block layer 
that data for the SRP initiator driver should be aligned at a 4KB 
boundary ? In srp_add_one() one can see that the finest granularity the 
SRP initiator driver supports for memory registration is 4KB 
(mr_page_shift = ...).

> Bart, do you know what hardware this workaround is for?

I hope the HW vendors can comment on this. Sorry but I'm not sure which 
HCA models and/or firmware versions do not support FMR mapping with a 
non-zero offset.

 > Also the SRP driver still falls back to phys registrations if the
 > better MR methods fail, something that will stop working with
 > Jasons patch.  It's something that looks a little questionable
 > and which other ULDs don't do either, so it would be good time
 > to review this practice.

Agreed.

> Additionally the SRP_DATA_DESC_INDIRECT case always uses the global
> rkey, so whenever we hits this things are going to break.

Indeed ... I think avoiding passing the global rkey over the wire in 
this case means registering the indirect table explicitly. Some SRP 
target implementations (e.g. the upstream ib_srpt driver) do not support 
partial indirect tables and fetch the indirect table from the SRP_CMD 
information unit. This means that the upstream ib_srpt driver never uses 
the rkey that is passed in the indirect data buffer descriptor. Although 
the upstream SRP target driver would keep working fine if an invalid 
rkey would be passed in the indirect data buffer header, I haven't found 
any clause in the SRP specification that allows to do this even if the 
entire indirect descriptor is passed in the SRP_CMD IU.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
