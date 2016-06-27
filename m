From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Upcoming libibverbs release
Date: Mon, 27 Jun 2016 12:17:58 -0600
Message-ID: <20160627181758.GD23540@obsidianresearch.com>
References: <3b89c411-72be-ddc5-5ebf-009eeee29692@redhat.com>
 <4ec1d8e6-a908-bb49-a137-415856ec6faa@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ec1d8e6-a908-bb49-a137-415856ec6faa-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jun 26, 2016 at 07:54:21PM +0300, Yishai Hadas wrote:
> > I'm still very much of the opinion that extended CQs should only allow
> > compatible QP's to be added.
> 
> Application may create a CQ with large subset of flags that may fit some of
> its attached QP types. Semantically, it is similar to what we have today, it
> allows to put different QP types on the same CQ and by thus allow
> application to have ordered completion events.

This is repeating your argument, I disagree, it is a horrible API
design, you need to defend this with an actual use case.

> We don't see a good reason to change from current behavior and hurt
> applications that expect that valid behavior.

Safety for the API consumer.

> > Add a compatibility layer
> 
> A real application wants to achieve performance, to use a compatibility
> layer over a vendor that doesn???t support the new API, might be a very bad
> idea as of below.

Well, NAK on this from me then.

Doug and I have both stated we don't want to see so many
single-provider APIs and churn in libibverbs. This was designed to be
a generic API that all providers can implement.

The responsibility falls on you to make sure that it works
universally. Compat is one option.

This is also why it is necessary to get the other provider authors to
say this works on their hardware, because they *all* ultimately have
to implement it.

I don't think many people realize this yet.

> > Exact set of access flags
> 
> Application can ask for subset of the available bits, in addition, it has an
> option to ask for all legacy ones (i.e. IBV_WC_STANDARD_FLAGS) for a case
> that a CQ needs to support all legacy attribute and could be attached to
> both RC and UD QPs.

Again, this is pretty much nonsense. Asking for data that can't be
returned is just an insane API design.

> Low priority issue that can be added in the future based on users demand.

No it can't, the enum and flags are part of the API and have to be
designed correctly from the start.

> From bench mark testing, we found that gathering few fields in one
> ibv_wc_read_xxx has low benefit comparing the case that each field is read
> by itself.

This might be a good argument.

> If you still think that adding some extra ibv_wc_read_xxx groups from day
> one is really needed, let's define it and add now by an incremental patch.
> Till now didn't see any user specific request for.

What? 'user request' for a just designed API? How is that even
possible?

> > Minor coding issues and micro optimizations
> 
> Not sure what exactly that point refers to from API point of view, assuming
> that it relates to few comments given on libmlx5 as of below.

I vaugely remember there being lots of comments, you guys basically
abandoned the whole discussion once Doug merged it, so I don't really
recall anymore. 

> > +static inline uint32_t mlx5_cq_read_wc_qp_num(struct ibv_cq_ex *ibcq)
> > +{
> > +	struct mlx5_cq *cq = to_mcq(ibv_cq_ex_to_cq(ibcq));
> 
> > You might want to look at having the caller pass in 'cq' from a member
> > in ibv_cq_ex. That way the caller can hold the cq in a register
> > instead of constantly reloading it like this - I'm assuming to_mcq is
> > not just an container_of??
> 
> The assumption is *incorrect*, the internal access from ibv_cq_ex to driver
> CQ is done via offsetof/container_of which is done in compile time, no need
> to have some change from the clean usage of the API to that mode.

Fine on cq, but the wqe pointer may benifit, and other drivers may
benifit. It still needs to be studied.

> > *ibcq)
> > You need to go through everything you've written and make sure it is
> > const-correct.
> > You should also annotate with restrict.
> > Doing this properly can increase performance by allowing the caller to
> > avoid reloads.
> 
> From performance point of view we don't expect a change here, we followed
> the created assembly code and saw no difference even when it was annotated
> with 'restrict'.

The annotations help the caller.

> In addition, please note the 'restrict' notation was only became standard as
> part of C99, in previous compilers it may not work at all or requires
> different key word to be defined as part of the CONFIG step.

Use __restrict like glibc does.

> We can go ahead and define the ibv_wc_read_xxx with const qualifier on its
> input struct ibv_cq_ex *ibcq in some extra incremental patch if makes sense.

Of course it makes sense, you need to fix all of this stuff in all
the patches you wrote.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
