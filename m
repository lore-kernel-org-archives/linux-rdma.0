From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb routines
Date: Thu, 29 Dec 2011 17:43:01 +0200
Message-ID: <4EFC8A85.4020803@mellanox.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com> <201108011508.06521.jackm@dev.mellanox.co.il> <20110802053824.GA23512@obsidianresearch.com> <201108021053.05311.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373136F935C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373136F935C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/2/2011 7:28 PM, Hefty, Sean wrote:
>> If I understand correctly, the various additions which would normally be made
>> to libibverbs would then be made by third-party libraries which extend libibverbs to support their additions.
>
> It may help to read about extensions in opengl: http://www.opengl.org/registry/doc/rules.html
> Additions can be made to both.  Obviously Roland has the final say on any changes to ibverbs, but what I envision is:
>
> If a feature is based on an industry standard and all necessary kernel changes are upstream, then the feature should be integrated into ibverbs.  An application would simply call ibv_new_feature() to make use of the feature (or call an existing function with some new enum value).  Internally, ibverbs may need to obtain a new interface from the provider library.
>
> If there is no published specification for a feature (maybe it's still under development), kernel patches are needed, and there are customers who want to use the feature immediately, then a vendor can define an extension.  In this case, the application may call vendor_ops = ibv_get_ext_ops(), followed by vendor_ops->new_feature().  Or the app may call ibv_some_existing_function() using a vendor specific enum value.

Sean, All,

"Allow 3rd party extensions to verb routines" was posted couple of times 
over the last months, I'm replying here @ 
http://marc.info/?t=130815687800001&r=1&w=2 since there has been few 
emails exchanges with Q&A so maybe would be better to continue that, 
anyway,

I would suggest that we first and most see that the selected method to 
add extensions addresses the 1st use case, e.g a feature which is in the 
kernel, standard, etc and now needed to be added user space wise such 
that all parties involve in that game: libibverbs, provider libraries 
and 3rd party code which links against libibverbs (application and 
libraries) are okay:

So for new feature that uses new verb, new data structures, new kernel 
uverbs calls - the application would call ibv_new_feature() to make use 
of the feature - applications can require libibverbs version > X in 
their install RPM dependencies mechanism such that when the application 
is installed its ensured that it could load libibverbs they w.o hitting 
a failure. Provider libraries which issue ibv_cmd_new_feature() calls 
can (should?!) apply that mechanism, looking on libmlx4 rpm spec file 
I'm not sure this is done there - still, ibv_cmd_new_feature() could 
fail if the kernel doesn't support that feature yet, but assuming uverbs 
return a known/documented value e.g -ENOSYS on that case, someone up 
there application/system would realize that the kernel has to be updated 
or they can tweak the app to give up using on ibv_new_feature() calls.

AND, we are remained with the libibverbs --- new_feature() ---> provider 
library trail. Here since
the provider library is plugin, we can't add/track strict dependencies 
to libibverbs for all provider libraries. Sean, my understanding is that 
for the 1st case (feature in kernel,etc) - the essence of your 
suggestion is to address that.

Looking on the suggestion, it states that for each new_feature, 
libibverbs defines "struct ibv_new_feature_ops" and issues "n_f_ops_p = 
ibv_get_ext_ops(context, IBV_NEW_FEATURE_OPS)" call each time it needs 
to call into the provider library for that new feature.

Looking closely on applying that method for XRC extensions as use case, 
namely commit 563fb8c3e "Using extensions to define XRC support" on your 
libibverbs/xrc git tree/branch and commit 5c01e9f40c "mlx4: Add support 
for XRC extension" on your libmlx4/xrc git - this gets a bit more 
complicated (git://git.openfabrics.org/~shefty/libibverbs.git xrc and 
libmlx4.git xrc) here's some feedback:

1. for libibverbs some structures extended field is added at their end 
saying "Following fields only available if device supports extensions"e.g

> @@ -590,6 +634,13 @@ struct ibv_qp {
>         pthread_mutex_t         mutex;
>         pthread_cond_t          cond;
>         uint32_t                events_completed;
> +
> +       /* Following fields only available if device supports 
> extensions */
> +       union {
> +               struct {
> +                       struct ibv_xrcd *xrcd;
> +               } xrc_recv;
> +       } ext;
>  };

but this field is a -- union -- how would that work if more than one 
extension is to be applied for a structure?

2. indeed, reality wise, new features, much of the time will also 
interact with existing data structures... so what happens if we extend a 
structure but the the extended strucutre is actually a field within 
another existing structure e.g suppose we want to extend ibv_ah_attr 
which is within ibv_qp_attr e.g to be used for the RAW Ethernet QPs. I 
don't see how we can be backward compatible with apps linked against 
libibverbs with the internal structure size being smaller, correct? so 
extended fields must be on the END always - in the actual structure they 
are added and if this structure is a field of another structure then we 
can't just extend it and need to come up with new structure which is in 
turn used as the field?

3. The usage of "#ifdef IBV_NEW_FEATURE_OPS" (IBV_XRC_OPS) in libmlx4 
will become tireding to follow maybe and could be replaced by placing 
dependency on a version of libibverbs that supports IBV_NEW_FEATURE_OPS?

4. can we somehow come up with a method to avoid IBV_NEW_FEATURE_OPS for 
--every-- new feature?

> or call an existing function with some new enum value

5. what happens if we just want to enhance an -- existing -- function - 
suppose we want to enhance ibv_post_send / ibv_poll_cq to support 
features like LSO, checksum offload, masked atomic operations, fast 
memory remote invalidate, etc so we add IBV_WR_NEW_FEATURE / 
IB_WC_NEW_FEATURE enum values, this step is simple, again if we go the 
way of the applicayion ensuring through dependencies that they are 
loaded against libibverbs that supports IB_{WR,WC}_NEW_FEATURE.

Now we come up with a need to extend struct ibv_send_wr and struct 
ibv_wc - where we should be very careful - walking on glasses for the 
backward compatibility thing - so only adding at the end on as union 
field which doesn't change the size of the union, correct? for 
ibv_post_send we can rely on the provider library to return error if 
they don't support NEW_FEATURE, but this would happen in run time... is 
there a way to avoid that, should we better go and add 
ib_post_send_new_feature? this would be very tedious doing for each 
new_feature and not applicable to ibv_poll_cq - any idea what should be 
done here?

This is for now...

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
