From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] Convert management helpers to Core Capability bits
Date: Thu, 14 May 2015 09:24:41 +0300
Message-ID: <CAJ3xEMjObg0edijGXQfxY_uBm4zU30N6ZroLc2pMscUMM6xSwA@mail.gmail.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 14, 2015 at 3:02 AM,  <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Ira Weiny (5):
>   IB/core: Create common start/end port functions
>   IB/user_mad: Remove local start/end port variable and use the new
>     common functions
>   IB/user_mad: Fix bug in ib_umad_remove_one when rdma_cap_ib_mad
>     implementation changed
>   IB/core: Formalize the creation of immutable per port data within the
>     ib_device object
>   IB/core: Convert management helpers to core capability bits

Hi Ira,

Just small feedback... commit titles needs to be (1) short (2) tell
the essence of
what you're doing e.g here are quick suggestions to few titles above which are
way too long:

IB/user_mad: Use the start/end port common helpers
IB/user_mad: Fix bug in remove_one
IB/core: Formalize immutable per port data creation within IB device

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
