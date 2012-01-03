From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Tue, 3 Jan 2012 18:08:42 +0200
Message-ID: <4F03280A.80305@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com> <201108011508.06521.jackm@dev.mellanox.co.il> <20110802053824.GA23512@obsidianresearch.com> <201108021053.05311.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com> <4EFC8A85.4020803@mellanox.com> <1828884A29C6694DAF28B7E6B8A8237325662BCE@ORSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237325662BCE-P5GAC/sN6hlcIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/2012 7:34 PM, Hefty, Sean wrote:
>> this field is a -- union -- how would that work if more than one 
>> extension is to be applied for a structure? 
> The fields at the end of the structure should only be accessed if the structure is of the correct type.  In this case, ext.xrc_recv is only available if the qp type is xrc recv.


Maybe I wasn't clear enough, I was thinking on a case where one extends 
a structure and later
on a 2nd extension is applied to the same structure, but the 
functionality / list of use cased related to the 1st extension isn't 
disjoint with that of the 2nd, e.g the second extends the first... maybe 
generally we can have a union named ext and on rare cases added ext2, etc?


>
>> 2. indeed, reality wise, new features, much of the time will also interact with existing data structures... so what happens if we extend a structure but the the extended strucutre is actually a field within another existing structure e.g suppose we want to extend ibv_ah_attr which is within ibv_qp_attr e.g to be used for the RAW Ethernet QPs. I
>> don't see how we can be backward compatible with apps linked against libibverbs with the internal structure size being smaller, correct? so extended fields must be on the END always - in the actual structure they are added and if this structure is a field of another structure then we can't just extend it and need to come up with new structure which is in turn used as the field?
>
> New features want to interact with existing structures and functions, which is what makes providing a clean separation difficult.  We can extend the structures using the above method as long as we have some sort type field available.  Where one is not available, we need to add one. See the proposed struct ibv_srq for an example.  The extended SRQ type is only available by calling ibv_create_xsrq(), since ibv_create_srq() cannot know whether the user supports the extended ibv_srq_init_attr or not.

Yes, I understand that, in 2nd thought, for the case of extending a 
structure which sits within another structure, e.g ibv_ah_attr within 
ibv_qp_attr, maybe we don't have much choice and rather add 
ib_ah_ext_attr and place it in the end of ibv_qp_attr ---> and here's a 
case for double extensions... as we need the "ext" union of ibv_qp_attr 
to contain struct  ibv_ah_ext_attr prim , struct  ibv_ah_ext_attr alt 
and possibly also struct qp_attr_ext qp_ext...


> ibv_wc and ibv_send_wr are allocated by the caller, so those are more difficult to deal with.  I agree that the size of those structures cannot change.  It may be possible that some of the features you mentioned could be set as part of the qp attributes (ibv_modify_qp), and for the others, I'm not sure.  Run time checks shouldn't be a big deal, since we already have to check things like ibv_wr_opcode and ibv_send_flags anyway.  But it could be that we require a new function, similar to ibv_create_xsrq.

I'd like to better understand the "allocated by the caller ... are more 
difficult to deal with" part of your response -  for ibv_send_wr - if 
the caller have set a new IBV_WR_NEW_FEATURE value for the wr type, they 
surely aware to the new fields and actually the size of the structure 
can change as of structs allocated by the library. As for ibv_wc, yep, 
looks like we can't change the size unless we want to write a copatility 
layer that also comes into play in fast path calls, specifically 
ibv_poll_cq and translates from the new ibv_wc to the old ibv_wc structure.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
