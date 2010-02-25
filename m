From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/2] mlx4/IB: Add support for enhanced atomic operations
Date: Thu, 25 Feb 2010 15:44:25 -0800
Message-ID: <adahbp4x4me.fsf@roland-alpha.cisco.com>
References: <20100214135426.GA7666@vlad-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100214135426.GA7666@vlad-laptop> (Vladimir Sokolovsky's
	message of "Sun, 14 Feb 2010 15:54:26 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > | atomic_response = *va
 > | if (((cmp XOR *va) AND cmp_mask) is ZERO) then
 > |     *va = (*va AND NOT(swap_mask)) OR (swap AND swap_mask)
 > |
 > | return atomic_response

This is a great, terse description of the masked compare and swap
operation.  Do you think it would be more readable with C operations (ie
^ for XOR, & for AND, ~ for NOT, and | for OR)?  Also, I think it would
be good to use the exact field names as the work request field you add
(ie compare_add and compare_add_mask instead of cmp and cmp_mask).

(And as I said before, this belongs with the generic patch, not the mlx4
patch description)

 > Masked Fetch and Add (MFetchAdd)
 > The MFetchAdd Atomic operation extends the functionality of the standard IB
 > FetchAdd by allowing the user to split the target into multiple fields of
 > selectable length. The atomic add is done independently on each one of this
 > fields. A bit set in the field_boundary parameter specifies the field
 > boundaries. The pseudo code below describes the operation:

This is a bit harder to read, but I guess the operation is harder to
describe.  But what is really missing is the statement that the relevant
fields in the wr are compare_add and compare_add_mask.  Failing that,
it's really hard to know how to use this operation without looking at
the mlx4 source code.

 > +	props->device_cap_flags |= IB_DEVICE_MASKED_ATOMIC;

Is there no firmware dependency here?  If this really should be set
unconditionally, then please just roll it into the other flags that get
set for all devices.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
