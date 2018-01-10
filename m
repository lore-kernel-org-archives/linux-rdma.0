From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-core 0/8] Revise provider initialization
Date: Wed, 10 Jan 2018 16:05:50 -0600
Message-ID: <013401d38a5f$2d352460$879f6d20$@opengridcomputing.com>
References: <20180108212632.5183-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-1-jgg-uk2M96/98Pc@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgg-uk2M96/98Pc@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: 'Jason Gunthorpe' <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This make all the context creation uniform by having every driver create a
> struct verbs_context using the same startup flow.
> 
> Long ago we had a new and old flow, where the new flow was intended to
> support
> a stable provider ABI, but now that the ABI is private we do not need
that.
> 
> By having every single provider having a verbs_context we can now rely on
> things like the priv existing and a sane init ordering where the priv can
> exist even before the first command runs.
> 
> Having priv always available is a necessary component to introduce support
for
> the new ioctl kabi.
> 
> Finally, the last three patches rework the ops setup to use a struct of
> function pointers scheme and provides defaults for every function. The
> defaults return ENOSYS which fixes a bunch of cases where the user could
have
> called a function without driver support and got a crash.
> 
> This is github PR:
> 
> https://github.com/linux-rdma/rdma-core/pull/281
> 
> Jason Gunthorpe (8):
>   verbs: Always allocate a verbs_context
>   bnxt_re: Convert from init_context to alloc_context
>   mlx4: Convert from init_context to alloc_context
>   mlx5: Convert from init_context to alloc_context
>   verbs: Remove init_context/uninit_context
>   verbs: Provide a default implementation for every verbs op
>   verbs: Convert all providers to use verbs_set_ops
>   verbs: Remove tests for NULL ops

Hey Jason,

For what it's worth, I built your ops_fix branch and tested over cxgb4.
Working worked, no problems.

Tested-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
