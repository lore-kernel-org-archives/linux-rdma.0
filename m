From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 1/2] IB/core: Add support for enhanced atomic operations
Date: Thu, 25 Feb 2010 15:38:40 -0800
Message-ID: <adaljegx4vz.fsf@roland-alpha.cisco.com>
References: <20100214135128.GA7607@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100214135128.GA7607@vlad-laptop> (Vladimir Sokolovsky's
	message of "Sun, 14 Feb 2010 15:51:28 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think I'd be OK adding this for 2.6.34, if there were some case made
that this would be useful for someone working on code that used this.
So what case can be made for adding this to 2.6.34 without an in-tree user?

 > - Add a new IB_WR_ATOMIC_MASKED_CMP_AND_SWP and IB_WR_ATOMIC_MASKED_FETCH_AND_ADD send
 > opcodes that can be used to mark a "masked atomic compare and swap" and
 > "masked atomic fetch and add" work request correspondingly.
 > - Add IB_DEVICE_MASKED_ATOMIC capability bit.
 > - Add mask fields to atomic struct of ib_send_wr
 > - Add new opcodes to ib_wc_opcode

The description of these operations from the mlx4 patch really belongs
here.

 > +	IB_WR_ATOMIC_MASKED_CMP_AND_SWP,
 > +	IB_WR_ATOMIC_MASKED_FETCH_AND_ADD,

Even in your description you talk about "masked atomic..." which makes
the ATOMIC_MASKED read a little strangely.  These enum values would make
more sense as:

	IB_WR_MASKED_ATOMIC_CMP_AND_SWP,
	IB_WR_MASKED_ATOMIC_FETCH_AND_ADD,

 >  			u64	swap;
 >  			u32	rkey;
 > +			u64	compare_add_mask;
 > +			u64	swap_mask;

It doesn't make any practical difference here, but it would be cleaner
to add the new fields before the rkey field, so that we don't leave a
hole due to padding.

 - R.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
