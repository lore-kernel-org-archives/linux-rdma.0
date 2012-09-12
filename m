From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups to support full and partial membership for the same pkey
Date: Wed, 12 Sep 2012 10:56:00 +0300
Message-ID: <201209121056.00309.jackm@dev.mellanox.co.il>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-3-git-send-email-jackm@dev.mellanox.co.il> <504F6C4F.6050207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504F6C4F.6050207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tuesday 11 September 2012 19:52, Doug Ledford wrote:
> On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
> > Enhance the cached and non-cached pkey table lookups to enable limited and full
> > members of the same pkey to co-exist in the pkey table.
> > 
> > This is necessary for SRIOV to allow for a scheme where some guests would have the full
> > membership pkey in their virtual pkey table, where other guests on the same hypervisor
> > would have the limited one. In that sense, its an extension of the IBTA model for
> > non virtualized nodes.
> 
> OK, maybe I'm not getting something, but I'm curious why we always pick
> the full pkey in preference to the partial pkey.
> 
The pkey model that we are working with is the following:
- guests do NOT have both limited and full membership forms of a given pkey;
  they have either the limited member or the full member

- The guests will see a virtualized pkey table, where pkeys appearing in that table
  are "cherry-picked" by the administrator from the underlying physical (device) pkey
  table contents.  The slot (or index) occupied by a mapped pkey in the virtual table
  is also determined by the administrator.
  The Hypervisor (primary phys function or PPF), which sees the physical pkey table used
  for the mappings, will therefor have both forms of a given pkey -- with the limited form
  mapped to some slot in a guest's pkey table, and the full form mapped to some slot in
  a different guest's pkey table.

- The only reason that a pkey table would contain both full and limited membership versions
  of a given pkey is to support SRIOV guest pkey paravirtualization.  In "native" mode, there
  is no reason to have both forms in a given pkey table. (The driver clearly reflects this
  in its original implementation of "ib_find_cached_pkey" -- it returns the index of the first
  15-bit pkey it finds in the table, and assumes that these 15 bits are unique in the table).

Thus, on guests ib_find_cached_pkey will operate as before, since the 15-bit pkey in the guest
table will be unique.

On the Hypervisor, however, we assume that if both versions of the pkey are in its pkey table,
then for its own infiniband operation (as opposed to performing its pkey virtualizing function),
it should operate with the highest membership type in its table for a given 15-bit pkey.

> Shouldn't we pick the
> pkey that's appropriate for the vHCA sending the message?

We do. When QPs on the guests are created, the modify-qp commands are not executed on the guest,
but rather are passed to the PPF for processing. The PPF replaces the guest-provided virtual pkey-index
value with the appropriate physical pkey-index value.  See procedure "update_pkey_index" in file
resource_tracker.c, and all the places it is called (i.e., in the wrapper functions for the various
modify-qp firmware commands).

> Also, given the rule of least surprise, don't you think it would be best
> to rename this function ib_find_cached_full_or_parital_pkey and in your
> next patch instead of naming it ib_find_exact_pkey just call that one
> ib_find_cached_pkey?
The naming of "ib_find_cached_pkey" refers to the 15-bit pkey value. I also
did not want to change all the places that "ib_find_cached_pkey" is used, to
call "ib_find_cached_full_or_partial_pkey" instead.

I also think it is more confusing to use the old name "ib_find_cached_pkey" in
a completely new (and incompatible) way.

Maybe I can change "ib_find_exact_pkey" to "ib_find_16_bit_pkey" ?

In this case, "ib_find_cached_pkey" will be backwards compatible and will find the
appropriate 15-bit pkey of either form (with the proviso that if both forms of the
pkey are in the table, it will return the full membership pkey index).

The ib_find_16_bit_pkey() looks for the exact match, and returns error if it does not find
it (-- specifically, if it is looking for one membership form, and only the other form is in
the table, it will return error).

> > To accomplish this, we need both the limited and full membership pkeys to be present
> > in the master's (hypervisor physical port) pkey table.
> > 
> > The algorithm for supporting pkey tables which contain both the limited and the full
> > membership versions of the same pkey works as follows:
> > 
> > When scanning the pkey table for a 15 bit pkey:
> > 
> > A. If there is a full member version of that pkey anywhere
> >     in the table, return its index (even if a limited-member
> >     version of the pkey exists earlier in the table).
> > 
> > B. If the full member version is not in the table,
> >     but the limited-member version is in the table,
> >     return the index of the limited pkey.
> > 
> > Signed-off-by: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> > Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
