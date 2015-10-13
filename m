From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Create a common verbs transport library
Date: Tue, 13 Oct 2015 08:32:25 +0300
Message-ID: <CAG9sBKPqXk671c7obj4wd8drNaxPU3gue428y3Es_BJfuC-sVQ@mail.gmail.com>
References: <20150929125648.GA3433@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150929125648.GA3433-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Denny,



We initially thought to implement a shared library that contains the
transport logic.

However, it seems that a SW Verbs transport driver would allow better
code sharing.

In fact, the VT driver would need only a single user-space driver for
all "backends". Any direct HW access from user-space should be exposed
by the corresponding backend driver and accessed by a different
library (e.g., psm).



At a high-level, it seems that we should do as follows:

- Decide on an initial code base for VT (rxe/hfi/qib), clone it, and
rename to VT

- Split the code to VT and backend and create the initial backend APIs, e.g.:

-- Send packet

-- Deliver packet (receive)

-- Attach multicast

-- Packet buffer allocation

-- Notify when more send space is available

- In parallel, prepare the backends of other drivers while enhancing
VT as needed.



Do you have any preferences to the initial code base?

Do you already have some code that we can look at?



Please advise as we are starting to develop a VT driver for RoCE now.

I suggest that we set up common user+kernel git repos for the initial work.



Thanks,

-Moni

On Tue, Sep 29, 2015 at 3:56 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi All,
>
> One of the conditions to move the hfi1 driver from staging into the normal
> drivers/infiniband/hw directory is to handle the code duplication in our
> verbs layer. This is going to be done by creating a new kmod which we will
> call rdmavt, for RDMA verbs transport. This will eventually live in the
> existing drivers/infiniband tree in a new sw directory:
> drivers/infiniband/sw/vt. This new directory can serve as a home for soft
> roce when its ready as well.
>
> The verbs library will start out life in drivers/staging/rdma/vt alongside
> hfi1. We (Intel) will push incremental patches to keep the community
> apprised of the development and allow for early and more continuous
> feedback. Once complete the plan would be to move out of staging along with
> hfi1.
>
> The current verbs support in the IB core should not need to be modified,
> rdmavt is just another verbs provider. Drivers will not use rdmavt directly.
> Rather, rdmavt will use the drivers to abstract away the hardware
> differences. Here is a diagram of what this will look like.
>
>   +-------+
>   |Ib Core|
>   +-------+
>       +
>       |
> +------v--------+
> |Verbs Transport|
> +-+----------+--+
>  |          |
>  |          |
> +-v--+     +-v--+
> |qib |     |hfi1|
> +----+     +----+
>
> -Denny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
