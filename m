From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/mad: Clean up ib_find_send_mad to use only the ib_mad_hdr
Date: Tue, 19 May 2015 14:27:31 -0400
Message-ID: <20150519182730.GA6737@phlsvsds.ph.intel.com>
References: <CAJ3xEMjtndfHJOh-JSTzaXuXTNrx2wzDkBcS67T6AwFztcckgQ@mail.gmail.com> <20150514173557.GB10941@phlsvsds.ph.intel.com> <555ABF9E.6010502@mellanox.com> <1432054868.3114.67.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432054868.3114.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > 
> > 6f430b IB/mad: Add const qualifiers to query only functions
> Ok
> > 67b3b05 IB/mad: Clean up rcv_has_same_class
> Ok
> > fcd6ebf IB/mad: Change ib_response_mad signature to take const 
> > ib_mad_hdr rather than ib_mad
> IB/mad: Change ib_response_mad signature arguments
> > 3b53339 IB/mad: Change validate_mad signature to take const ib_mad_hdr 
> > rather than ib_mad
> IB/mad: Change validate_mad signature arguments
> > b78d28a IB/mad: Clean up comments in smi.c
> Ok
> > c597eee IB/mad: Rename is_data_mad to is_rmpp_data_mad
> Ok
> > 81836bc IB/core: Change rdma_protcol_iboe to roce
> Ok
> > 6f9ab33 IB/core: Convert management helpers to core capability bits
> IB/core: Convert core to use bitfield for caps
> > 23ceb15 IB/core: Formalize the creation of immutable per port data 
> > within the ib_device object
> IB/core: Add per port immutable struct to ib_device
> > cb3ed7b IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad 
> > implementation changed
> IB/user_mad: Fix buggy usage of port index
> > 42997f2 IB/user_mad: Remove local start/end port variable and use the 
> > new common functions
> IB/user_mad: Use new start/end port functions
> > 0cf18d7 IB/core: Create common start/end port functions
> Ok
> > 
> > Maybe submit them all again with more proper commit titles? it's not too 
> > late, Doug, what's your
> > thinking here?
> 
> I try to stick within the recommended length of git log subject as
> indicated to me by vim when I'm editing my commit messages.  Whatever
> happens to fit inside that limit (or at least close to it, I'm not a
> real stickler on it) I go with unless you really need to capture some
> important detail in the subject.
> 
> However, there's no need to resubmit these.  I can always edit the
> subjects in place.  Ira are you OK with the changes I made above?

Yes thank you.  I will do better in the future.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
