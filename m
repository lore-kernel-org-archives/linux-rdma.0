From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 2/6] IB/uverbs: Enable QP creation which is
 associated to underlay QP
Date: Sun, 04 Jun 2017 09:43:14 -0400
Message-ID: <1496583794.7171.134.camel@redhat.com>
References: <20170530071602.8139-1-leon@kernel.org>
         <20170530071602.8139-3-leon@kernel.org> <20170530073352.GA1838@nanopsycho>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170530073352.GA1838@nanopsycho>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Pirko <jiri-rHqAuBHg3fBzbRFIqnYvSA@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-05-30 at 09:33 +0200, Jiri Pirko wrote:
> Tue, May 30, 2017 at 09:15:58AM CEST, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org wrote:
> > 
> > From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > 
> > Enable QP creation which is associated to underlay QP. This comes
> > as a
> > pre-patch for downstream patches in this series to enable flow
> > steering
> > from user space application on the underlay IPoIB QP.
> > 
> > Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> 
> [...]
> 
> 
> > 
> > diff --git a/include/uapi/rdma/ib_user_verbs.h
> > b/include/uapi/rdma/ib_user_verbs.h
> > index 477d629f539d..422b20456975 100644
> > --- a/include/uapi/rdma/ib_user_verbs.h
> > +++ b/include/uapi/rdma/ib_user_verbs.h
> > @@ -578,7 +578,7 @@ struct ib_uverbs_ex_create_qp {
> > 	__u32 comp_mask;
> > 	__u32 create_flags;
> > 	__u32 rwq_ind_tbl_handle;
> > -	__u32  reserved1;
> > +	__u32  associated_qpn;
> 
> This breaks uapi...

We don't really care about this particular uapi breakage.

First, this is the ib_uverbs_*ex*_create_qp struct, so this is already
part of the "extensible uAPI" we created back when we included XRC
support into the mainline kernel.  A fundamental part of that uAPI was
that we were allowed to extend structs (but not reorganize them) so
that we could add new stuff to the end as we added features, but old
apps would continue to work.  As a result, it was understood that the
uapi structs would continue to grow.

Given that fact, if we put a reserved1 element into a struct to pad it
out to a given size (which we did roughly 1 year ago with
commit c70285f880e88 (IB/uverbs: Extend create QP to get RWQ
indirection table) which made this change to the ex_create_qp struct:

        __u32 create_flags;
+       __u32 rwq_ind_tbl_handle;
+       __u32  reserved1;
 };

that doesn't mean a user of the uapi should directly reference this
element, it means we added 32 bits out of a 64 bit line and we'll add
the other 32 bits later, so don't reference that pad element by name,
use the preferred means of clearing the struct prior to use:
memset(sizeof(struct)) or calloc or equivalent.  Given that only user
space verbs providers that have been updated to support the RWQ
indirection table would possibly ever even have seen this API element,
and given that those should be fairly rare at this point (I doubt that
any exist besides possibly libibverbs or rdma-core, I'm not sure if
this support went into libibverbs before we merged it into rdma-core,
but if it didn't, then only rdma-core would have been updated to know
about these last two struct elements), I'm not going to have Mellanox
put a bunch of ugly cruft in here for probably non-existent, but very
recently updated if it even exists, consumers that don't follow best
practice when accessing/clearing elements of an extensible struct.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
