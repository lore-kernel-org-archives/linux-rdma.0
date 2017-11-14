From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC rdma-core 0/5] Add thread domain support
Date: Tue, 14 Nov 2017 22:14:18 +0200
Message-ID: <CAFgAxU-sRYPU83kpcgg=BVi2x5LtdetzjCEcKdCivUcoRqg9Mw@mail.gmail.com>
References: <1510522903-6838-1-git-send-email-yishaih@mellanox.com>
 <20171113200651.GG22610@ziepe.ca> <CAFgAxU9Svu8jKBMzY91cOUFF9wngowbFZd+yKUBz9M60rcWfkg@mail.gmail.com>
 <20171114025745.GO22610@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114025745.GO22610-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Alex @ Mellanox" <Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

oops, I did not reply-all...  adding the ML back
although Yishai replied/answered most of this anyway.


On Tue, Nov 14, 2017 at 4:57 AM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
>
> On Mon, Nov 13, 2017 at 10:32:06PM +0200, Alex Rosenbaum wrote:
>
> > > I assume you'll also add a create_cq_ex to accept a PD instead of a
> > > device?
>
> > currently we're mainly focusing on improving the inter-QP locks.
> > we did not plan to improve the CQ related locking at this point so we
> > did not plan to add parent domain to the create CQ in this series.
> > once Mellanox (or someone else) will improve the CQ related locks it
> > will definitely be the first step.
>
> I would like to see the evolve into a more complete solution, not just
> for simple locking but also NUMA issues as well.
>
> Eg I would like to see it replace the rather limited comp_vector in the
> CQ.
>
> Adding APIs like
>
> ibv_td_set_cpuset()
>  * Tell the library the application has bound the calling threads to
>  certain CPU(s). This may help the library & kernel make a NUMA
>  decision, eg by choosing the right MSI-X or memory allocation strategy.
>
> ibv_td_set_locking_mode()
>  * Disable locking inside the library assuming the caller guarentees
>    external locking or single-threaded operation.
>
> etc
>
> And given Doug's preference to keep the API style, lets use some
> comp_mask approach and a ib_td_modify & create whatsit.
>
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
