From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 18 Nov 2016 00:24:40 +0200
Message-ID: <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw@mail.gmail.com>
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu> <582E089A.3040106@redhat.com> <20161117200203.GQ4240@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161117200203.GQ4240-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 17, 2016 at 9:44 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 11/17/16 1:49 PM, Leon Romanovsky wrote:
>> On Thu, Nov 17, 2016 at 07:13:54AM -0500, Doug Ledford wrote:
>>> Hi Linus,
>>>
>>> Due to various issues, I've been away and couldn't send a pull request
>>> for about three weeks.  There were a number of -rc patches that built up
>>> in the meantime (some where there already from the early -rc stages).
>>> Obviously, there were way too many to send now, so I tried to pare the
>>> list down to the more important patches for the -rc cycle.

Hi Doug,

Except for the hfi1 patches, all the rest (core, mlx5, mlx4 and rxe)
are marked now as only 21 hours old in your 4.9-rc branch and they
seems be made from you picking partial subsets of multiple series,
with none of them acked by you on the list.

If you agree that I am describing things correctly - how are we
expected to follow on your patch picking? I find it sort of impossible
and error prone.

>> Are you adding the rest to your for-next branch? We would like to have
>> enough time to check that nothing is lost.

> Yes, it's already there in the mlx-next branch on github.

Re the patches there, this one

IB/mlx4: Set traffic class in AH

"Set traffic class within sl_tclass_flowlabel when create iboe AH.
Without this the TOS value will be empty when running VLAN tagged
traffic, because the TOS value is taken from the traffic class in the
address handle attributes.

Fixes: 9106c41 ('IB/mlx4: Fix SL to 802.1Q priority-bits mapping for IBoE')"

claims to fix my commit, I have approached Leon and Co for
clarifications/questions over the list on the patch and nothing was
answered.

Please do not send it to Linus and wait for them to respond. I
disagree that it fixes my commit b/c my commit was prior to when
route-able RoCE  was introduced and on that time TOS had no relation.

and this one

"IB/mlx4: Put non zero value in max_ah device attribute

Use INT_MAX since this is the max value the attribute can hold, though
hardware capability is unlimited.

Fixes: 225c7b1 ('IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters')"

does a tiny enhancement for a 10y old commit of Roland, why you think
we need it in 4.9-rc6 or 7??

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
