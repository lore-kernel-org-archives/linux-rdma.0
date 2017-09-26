From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core] Verbs: Introduce resource domain
Date: Tue, 26 Sep 2017 12:09:12 +0300
Message-ID: <CAFgAxU-FPTNM99iTACmw5yeW1zyv+7g+KC2jigj4DXiervyjdA@mail.gmail.com>
References: <1505648922-21346-1-git-send-email-yishaih@mellanox.com>
 <20170918205411.GB7059@obsidianresearch.com> <CAFgAxU9M0MXw371Nh2tviuQHXCJxnFLPtaAcsevigEMMWjUPhA@mail.gmail.com>
 <20170921014146.GA4041@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170921014146.GA4041-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 21, 2017 at 4:41 AM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> But, as you say, you'd have to solve the MR sharing problem at least
> to make PD workable. Perhaps some kind of 'child' PD that was only for
> threading..

OK, this definitely sounds like an interesting approach.
// alloc a child ibv_pd, which inherits the parent properties and adds
some limitations (e.g. thread domain, memory domain)

Two options I'm thinking in this spirit:

1) Extend the original alloc PD API (stay with a single PD alloc entry point):
struct ibv_pd *ibv_alloc_pd_ex(
        struct ibv_context *my_ctx,
        struct ibv_pd_init_attr {
                ibv_pd* parent_pd = my_pd, // use NULL to alloc a
parent PD, or use a parent pd to alloc a child PD
                int flags = IBV_PD_PARENT | IBV_PD_INIT_ATTR_THREAD_DOMAIN)
        } );

2) New dedicated alloc Child PD API:
struct ibv_pd *ibv_alloc_child_pd(struct ibv_pd *pd, int flags =
IBV_PD_INIT_ATTR_THREAD_DOMAIN);


> That goes both ways, a single 'max' does not make sense if there are
> multiple different sorts of objects being controlled (eg UAR and
> something else). It only works well in your context of having a single
> constrained UAR.
I agree.


> Probably the better option is to introduce something like a 'struct
> verbs_locking_domain *' input which is a proper object and can have a
> range of operators.

I did not understand how the 'struct verbs_locking_domain' comes into play here.
In regards to the child PD, I'm assuming the 'struct ibv_pd' will be
encap in a 'struct verbs_pd', and/or maybe encap in a 'struct
provider_pd'. Any linkage and dedicated resource should be stored in
the internal structures.


> I would say each creating locking domain objects is just strided
> across the various limited resources in the device.

With the above verbs API for child PD on dedicated thread, user gets a
best effort allocation of thread resource. I agree that striding
across resources sounds good.


> 'dv' accessors, eg mlxdv_set_locking_uar() can be provided to directly
> assign specific limited resources under the control of the
> application. 'dv' query functions can be used to directly learn the
> specific limits for each specific thing.

int mlx5dv_set_pd_uar_index(struct ibv_pd* pd, int uar_index);
So with DV API, application can selectively choose a UAR index for
Mellanox HW for a child (or parent) PD.
All objects created with this PD will use the chosen UAR index or
other thread options.
max_uar_index will be expose by the DV device caps via
'mlx5dv_query_device()'. If user exceeds the max_uar_index, the above
function call will fail.


Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
