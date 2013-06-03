From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH RESEND for-3.10 0/3] 2nd batch of iSER patches
Date: Mon, 3 Jun 2013 11:36:42 +0300
Message-ID: <51AC559A.3070706@mellanox.com>
References: <1368015679-15215-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1368015679-15215-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/05/2013 15:21, Or Gerlitz wrote:
> Here's a 2nd batch of iser patches for 3.10, with the hightlight being
> a fix to the device removal flow from Roi Dayan. For some reason the race
> this patch fixes doesn't hit on IB link layer as of different timings
> (e.g more modules that register with the IB core, such as IPoIB), but
> it was there, thanks for Sean we nailed down the problem and came up
> with a proper fix.

Hi Roland,

Are you getting there? (also I saw two rdma-cm patches from  Sean to 
3.10 that didn't make it for your 1st pull request) - we're @ 3.10-rc3 
and 3.11 materials start to knock on the door.

Or.

>
> Also, with the kernel now having iser target support through LIO and the
> increased use cases for iser, I added a MAINTAINERS entry to help people
> figure out who's involved (and send bugs and flames...) hope you're OK
> with that.
>
> Or.
>
> Or Gerlitz (2):
>    IB/iser: Add Mellanox copyright
>    MAINTAINERS: Add entry for iSCSI Extensions for RDMA (iSER) initiator
>
> Roi Dayan (1):
>    IB/iser: Fix device removal flow
>
>   MAINTAINERS                                  |   10 ++++++++++
>   drivers/infiniband/ulp/iser/iscsi_iser.c     |    1 +
>   drivers/infiniband/ulp/iser/iscsi_iser.h     |    1 +
>   drivers/infiniband/ulp/iser/iser_initiator.c |    1 +
>   drivers/infiniband/ulp/iser/iser_memory.c    |    1 +
>   drivers/infiniband/ulp/iser/iser_verbs.c     |   16 +++++++++-------
>   6 files changed, 23 insertions(+), 7 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
