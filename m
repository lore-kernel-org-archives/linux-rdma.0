From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V6 00/10] Move RoCE GID management to IB/Core
Date: Thu, 25 Jun 2015 11:34:43 +0300
Message-ID: <CAJ3xEMjZgMPWA0jm3ReM4Cb1Q-Gz-vXh=XguSYUMAVD+qPA6Zg@mail.gmail.com>
References: <1435150766-6803-1-git-send-email-matanb@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435150766-6803-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 24, 2015 at 3:59 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
[...]
> Changes from V5:
> (1) Incoporate the changes to cache.c so we use the same infrastructure
>     to manage both IB and RoCE (per Doug's request)
> (2) Replace the locking mechanism in the IB core GID cache from seqcount +
>     rcu to rwlock (addressing comments from Jason)
> (3) get_netdev returns a helded (dev_hold) device
> (4) Squashed the RocE GID table, RoCE GID management and default GID handling
>     code into one patch (per Doug's request).
> (5) Change modify_gid to add_gid and del_gid.
> (6) set the netdev related changes into three dedicated patches and make
>     them be 1st in the series.

Hi Jason, Doug,

So... are we finally OK wrt the feedback  you provided?

Matan and team have carefully addressed the review comments, let us
know how you see this
(same for Haggai's V1 series post, will love to get your feedback to
know where we are there too).

Or.

> Changes from V4:
> (1) Remove any API changes.
> (2) Fixed a bug regarding bonding upper devices.
> (3) Rebased ontop of Doug's k.o/for-4.2.
>
> Changes from V3:
> (1) Remove RoCE V2 functionality (it will be sent at later patchset).
> (2) Instead of removing qp_attr_mask flags, reserve them.
> (3) Remove the kref from IB devices in favor of rwsem.
> (4) Change the name of roce_gid_cache to roce_gid_table.
> (5) Fix a race when roce_gid_table is free'd while getting events.
> (6) Remove the roce_gid_cache active/inactive flag/API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
