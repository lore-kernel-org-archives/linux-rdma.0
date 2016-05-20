From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 02/10] IB/core: Introduce Work Queue object and its verbs
Date: Fri, 20 May 2016 01:30:52 -0400
Message-ID: <20160520053051.GA15274@phlsvsds.ph.intel.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com> <1460903237-16870-3-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1460903237-16870-3-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Apr 17, 2016 at 05:27:09PM +0300, Yishai Hadas wrote:
> Introduce Work Queue object and its create/destroy/modify verbs.
> 
> QP can be created without internal WQs "packaged" inside it,
> this QP can be configured to use "external" WQ object as its
> receive/send queue.
> WQ is a necessary component for RSS technology since RSS mechanism
> is supposed to distribute the traffic between multiple
> Receive Work Queues.

I'm confused by what a WQ actually is.  Does a QP contain a WQ ("'packaged'
inside it")?  Or is a set of WQ's associated with a single QP?  What is meant
by "internal" and "external" WQ?

Can a WQ be associated with more than 1 QP?  I'm thinking not, except
indirectly when it is associated with a single SRQ.

It looks like the user configures a set of WQs which will get wrs.  What types
of QPs can be associated with a IB_WQT_RQ?

Does the user post Recv WR's to the QP or the WQs?  Looks like to the QP/SRQ.
So are their ordering expectations here or can WRs posted to the QP get
processed out of order depending on which WQ they get sent to?  It seems that
then the user is responsible for dealing with out of order messages or
hopefully does not care?

Given the hash fields specified in the patch series and the information
discussed on the last verbs call it seems like only Raw Ethernet QPs are
supported.  Or can IPoIB UD QPs work as well.  If so how does a low level
driver know where to look for the IP headers?

Shouldn't the size of the indirection table determine the number of WQs or vice
versa?  It seems like the user has to do a lot of work here to make that
association.  What types of errors occur if the indirection table/hash
specifies a WQ which does not exist?

Maybe I'm just confused about the differences between the indirection table and
the hash function?

> 
> WQ associated (many to one) with Completion Queue and it owns WQ
> properties (PD, WQ size, etc.).
> WQ has a type, this patch introduces the IB_WQT_RQ (i.e.receive queue),
> it may be extend to others such as IB_WQT_SQ. (send queue).
> WQ from type IB_WQT_RQ contains receive work requests.
> 
> PD is an attribute of a work queue (i.e. send/receive queue), it's used
> by the hardware for security validation before scattering to a memory
> region which is pointed by the WQ. For that, an external WQ object
> needs a PD, letting the hardware makes that validation.
> 
> When accessing a memory region that is pointed by the WQ its PD
> is used and not the QP's PD, this behavior is similar
> to a SRQ and a QP.
> 
> WQ context is subject to a well-defined state transitions done by
> the modify_wq verb.
> When WQ is created its initial state becomes IB_WQS_RESET.
> From IB_WQS_RESET it can be modified to itself or to IB_WQS_RDY.
> From IB_WQS_RDY it can be modified to itself, to IB_WQS_RESET
> or to IB_WQS_ERR.
> From IB_WQS_ERR it can be modified to IB_WQS_RESET.
> 
> Note: transition to IB_WQS_ERR might occur implicitly in case there
> was some HW error.
> 
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/verbs.c | 82 +++++++++++++++++++++++++++++++++++++++++
>  include/rdma/ib_verbs.h         | 56 +++++++++++++++++++++++++++-
>  2 files changed, 137 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 15b8adb..c6c5792 100644
> --- a/drivers/infiniband/core/verbs.c
> +++ b/drivers/infiniband/core/verbs.c
> @@ -1516,6 +1516,88 @@ int ib_dealloc_xrcd(struct ib_xrcd *xrcd)
>  }
>  EXPORT_SYMBOL(ib_dealloc_xrcd);
>  
> +/**
> + * ib_create_wq - Creates a WQ associated with the specified protection
> + * domain.
> + * @pd: The protection domain associated with the WQ.
> + * @wq_init_attr: A list of initial attributes required to create the

Is this really a list of attributes?

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
