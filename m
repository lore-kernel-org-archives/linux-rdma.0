From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core] Verbs: Introduce resource domain
Date: Sat, 30 Sep 2017 09:59:11 -0600
Message-ID: <20170930155911.GB14777@obsidianresearch.com>
References: <1505648922-21346-1-git-send-email-yishaih@mellanox.com>
 <20170918205411.GB7059@obsidianresearch.com>
 <CAFgAxU9M0MXw371Nh2tviuQHXCJxnFLPtaAcsevigEMMWjUPhA@mail.gmail.com>
 <20170921014146.GA4041@obsidianresearch.com>
 <CAFgAxU-FPTNM99iTACmw5yeW1zyv+7g+KC2jigj4DXiervyjdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU-FPTNM99iTACmw5yeW1zyv+7g+KC2jigj4DXiervyjdA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Sep 26, 2017 at 12:09:12PM +0300, Alex Rosenbaum wrote:

> 2) New dedicated alloc Child PD API:
> struct ibv_pd *ibv_alloc_child_pd(struct ibv_pd *pd, int flags =
> IBV_PD_INIT_ATTR_THREAD_DOMAIN);

I think I prefer this one.

This sounds like a nice idea, but I wonder what a provider
implementation will look like now that there are two types of PD
objects and so forth.

The providers will need helpers 'get_pd()' to return the top level pd
struct that has the driver data and 'get_locking()' that returns
the thread properties associated with that PD. All accesses to the PD
will have to go through those accessors.

> > Probably the better option is to introduce something like a 'struct
> > verbs_locking_domain *' input which is a proper object and can have a
> > range of operators.
> 
> I did not understand how the 'struct verbs_locking_domain' comes into play here.
> In regards to the child PD, I'm assuming the 'struct ibv_pd' will be
> encap in a 'struct verbs_pd', and/or maybe encap in a 'struct
> provider_pd'. Any linkage and dedicated resource should be stored in
> the internal structures.

This was intented as an alterantive. If the PD approach is no good,
then use this instead of just an integer.

In the PD case this object exists but is hidden from the
uapi. 'get_locking()' returns it. eg a child pd would have a struct
verbs_locking_domain and the driver specific version as the driver
data of a pd object.

> int mlx5dv_set_pd_uar_index(struct ibv_pd* pd, int uar_index);
> So with DV API, application can selectively choose a UAR index for
> Mellanox HW for a child (or parent) PD.
> All objects created with this PD will use the chosen UAR index or
> other thread options.
> max_uar_index will be expose by the DV device caps via
> 'mlx5dv_query_device()'. If user exceeds the max_uar_index, the above
> function call will fail.

Yes.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
