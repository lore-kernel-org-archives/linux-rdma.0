From: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 11 May 2016 03:47:14 +0000
Message-ID: <HE1PR05MB164274F171401FC5B21B2474AA720@HE1PR05MB1642.eurprd05.prod.outlook.com>
References: <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org>
 <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
 <20160510044107.GU29160@leon.nu> <20160510170739.GA2879@obsidianresearch.com>
 <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
 <20160511020429.GA32766@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/10/2016 9:04 PM, Jason Gunthorpe wrote:
> On Tue, May 10, 2016 at 07:29:42PM -0500, Christoph Lameter wrote:
>>> This was tried at the Collab summit and I heard several representatives
>>> strongly say no.
>> Hardware standards? I thought we were talking about software and APIs.
> The LSO, RSS and Timestamp patches all demand very specific hardware
> functionality for a device to implement the API. It is fundamentally
> not a 100% software API.
>
> Look at the patches. The LSO patch is so bad Sean and Steve couldn't
> even figure out what the heck the HW feature does. I know what it
> does, but I can't tell you the fine details of the actual required
> hardware behavior.
>
> How on earth is someone else supposed to ever implement hardware that
> does this?
>
> I still don't understand why this is being forced into
> libibverbs. dpdk would seem to be the prefered way to access these
> sorts of features and there is no technical reason why the mlx
> dpdk provider needs to use libibverbs. Talk directly to /dev/uverbs0
> and use udata to enable the universe of nic specific features.
There are other user space libraries which are build on top of libibverbs rather than DPDK. E.g, VMA.

>
> For instance, the dpdk community has already done the hard work to
> figure out how to expose things like LSO to their users - and they
> actually have multiple vendors providing these features...
>
> http://dpdk.org/ml/archives/dev/2014-May/002537.html
>
> I guess you are going to tell me you want these features on IB UD
> transport and dpdk has no support for L2's other than ethernet?
>
> Jason
>
The patches from kernel are purely for hardware capabilities report. The policy and logic about how to implement the LSO are living in libibverbs and hardware related libraies(e.g, libmlx5). Review these patches together might make things more clear. They're not pushed to community for review yet because we still can't reach the agreement from this very first step.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
