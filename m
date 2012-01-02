From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Mon, 2 Jan 2012 17:34:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237325662BCE@ORSMSX102.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
 <201108011508.06521.jackm@dev.mellanox.co.il>
 <20110802053824.GA23512@obsidianresearch.com>
 <201108021053.05311.jackm@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com>
 <4EFC8A85.4020803@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFC8A85.4020803-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 1. for libibverbs some structures extended field is added at their end
> saying "Following fields only available if device supports extensions"e.g
> 
> > @@ -590,6 +634,13 @@ struct ibv_qp {
> >         pthread_mutex_t         mutex;
> >         pthread_cond_t          cond;
> >         uint32_t                events_completed;
> > +
> > +       /* Following fields only available if device supports
> > extensions */
> > +       union {
> > +               struct {
> > +                       struct ibv_xrcd *xrcd;
> > +               } xrc_recv;
> > +       } ext;
> >  };
> 
> but this field is a -- union -- how would that work if more than one
> extension is to be applied for a structure?

The fields at the end of the structure should only be accessed if the structure is of the correct type.  In this case, ext.xrc_recv is only available if the qp type is xrc recv.

> 2. indeed, reality wise, new features, much of the time will also
> interact with existing data structures... so what happens if we extend a
> structure but the the extended strucutre is actually a field within
> another existing structure e.g suppose we want to extend ibv_ah_attr
> which is within ibv_qp_attr e.g to be used for the RAW Ethernet QPs. I
> don't see how we can be backward compatible with apps linked against
> libibverbs with the internal structure size being smaller, correct? so
> extended fields must be on the END always - in the actual structure they
> are added and if this structure is a field of another structure then we
> can't just extend it and need to come up with new structure which is in
> turn used as the field?

New features want to interact with existing structures and functions, which is what makes providing a clean separation difficult.  We can extend the structures using the above method as long as we have some sort type field available.  Where one is not available, we need to add one.  See the proposed struct ibv_srq for an example.  The extended SRQ type is only available by calling ibv_create_xsrq(), since ibv_create_srq() cannot know whether the user supports the extended ibv_srq_init_attr or not.
 
> 3. The usage of "#ifdef IBV_NEW_FEATURE_OPS" (IBV_XRC_OPS) in libmlx4
> will become tireding to follow maybe and could be replaced by placing
> dependency on a version of libibverbs that supports IBV_NEW_FEATURE_OPS?

Yes, you could make that replacement, which will work in this case.

> 4. can we somehow come up with a method to avoid IBV_NEW_FEATURE_OPS for
> --every-- new feature?
> 
> > or call an existing function with some new enum value

This probably depends on the feature.

> 
> 5. what happens if we just want to enhance an -- existing -- function -
> suppose we want to enhance ibv_post_send / ibv_poll_cq to support
> features like LSO, checksum offload, masked atomic operations, fast
> memory remote invalidate, etc so we add IBV_WR_NEW_FEATURE /
> IB_WC_NEW_FEATURE enum values, this step is simple, again if we go the
> way of the applicayion ensuring through dependencies that they are
> loaded against libibverbs that supports IB_{WR,WC}_NEW_FEATURE.
> 
> Now we come up with a need to extend struct ibv_send_wr and struct
> ibv_wc - where we should be very careful - walking on glasses for the
> backward compatibility thing - so only adding at the end on as union
> field which doesn't change the size of the union, correct? for
> ibv_post_send we can rely on the provider library to return error if
> they don't support NEW_FEATURE, but this would happen in run time... is
> there a way to avoid that, should we better go and add
> ib_post_send_new_feature? this would be very tedious doing for each
> new_feature and not applicable to ibv_poll_cq - any idea what should be
> done here?

ibv_wc and ibv_send_wr are allocated by the caller, so those are more difficult to deal with.  I agree that the size of those structures cannot change.  It may be possible that some of the features you mentioned could be set as part of the qp attributes (ibv_modify_qp), and for the others, I'm not sure.  Run time checks shouldn't be a big deal, since we already have to check things like ibv_wr_opcode and ibv_send_flags anyway.  But it could be that we require a new function, similar to ibv_create_xsrq.

- Sean


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
