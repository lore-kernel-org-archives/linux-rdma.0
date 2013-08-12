From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 0/4] Add receive Flow Steering support
Date: Mon, 12 Aug 2013 17:28:04 +0300
Message-ID: <5208F0F4.4060705@mellanox.com>
References: <1375873322-19384-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375873322-19384-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/08/2013 14:01, Or Gerlitz wrote:
> Hi Roland,
>
> V4 addresses further comments made by Sean.
>
> There are still some concerns/questions posed by Roland on the uverbs
> extensions element of the series. Both Tzahi Oved and myself have
> posted replies for them, but so far no further comments from you.
>
> This code is hanging out for pretty long time, and to make it for 3.12
> we need to re-new  the discussion on uverbs extensions, so please...

Roland, it seems now, good chance we will miss 3.12 too.

Its OK if you totally disagree with the commentsmade by Tzahi Oved on 
the uverbs extensions here 
http://marc.info/?l=linux-rdma&m=137338205511497&w=2but its totally fair 
to ask that this disagreement will be spelled out.

Or.
>
> There has been request from Shawn Bohrer to get the relevant userspace
> patches so he can test. I will provide him or anyone else who is interested
> to test with the latest cut of the userspace code.
>
> V4 changes:
>    - Addressed comments from Sean on the uverbs code that copies the
>      flow specifications from user space. Now we make sure that passed sizes
>      match the kernel flow specs, and in any case, don't look on addresses
>      which are beyond the overall size passed by the write system call.
>
> V3 changes:
>    - Addressed comments from Sean:
>    - modified the change-log of patch #1 to be clearer on the priority and domain
>      semantics and usage
>    - re-arranged the fields of struct ib_flow_attr
>    - removed check from ib_flow_destroy
>    - removed the IB flow spec which wasn't inline with the L2/L3/L4 approach
>      done for Ethernet/IP/TCP|UDP, will use proper IB flow specs when adding
>      the support for IPoIB flow steering
>
>       
> V2 changes:
>    - dropped struct ib_kern_flow from patch #3, this structure wasn't
>      used and was left there by mistake (bug, thanks Roland)
>    - removed the void *flow_context field from struct ib_flow, this was
>      pointing to driver private data for that flow, but doesn't belong here,
>      i.e need not be seen by the verbs consumer but rather hidden.
>    - renamed struct mlx4_flow_handle to mlx4_ib_flow, a structure that contains
>      the verbs level struct ib_flow and the mlx4 registeration ID for that flow
>
> V1 changes:
>
>   - dropped the five pre-patches which were accepted into 3.10
>   - rebased the patches against Roland's for-next / 3.10-rc4
>   - in patch #3, ib_uverbs_destroy_flow was returning too quickly when the driver
>     returned failure for ib_destroy_flow, need to free some uverbs resources 1st.
>   - in patch #4, check index before accessing the array at mlx4_ib_create/destroy_flow
>
> These patches add Flow Steering support to the kernel IB core, to uverbs and
> to the mlx4 IB (verbs) driver along with one patch to uverbs which adds
> some code to support extensions.
>
>    IB/core: Add receive Flow Steering support
>    IB/core: Infra-structure to support verbs extensions through uverbs
>    IB/core: Export ib_create/destroy_flow through uverbs
>    IB/mlx4: Add receive Flow Steering support
>
> The main patch which introduces the Flow-Steering API is "IB/core: Add receive Flow
> Steering support", see its change log. Looking on the "Network Adapter Flow Steering"
> slides from Tzahi Oved which he presented on the annual OFA 2012 meeting could be helpful
> https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/518-network-adapter-flow-steering.html
>
> Or.
>
> Hadar Hen Zion (3):
>    IB/core: Add receive Flow Steering support
>    IB/core: Export ib_create/destroy_flow through uverbs
>    IB/mlx4: Add receive Flow Steering support
>
> Igor Ivanov (1):
>    IB/core: Infra-structure to support verbs extensions through uverbs
>
>   drivers/infiniband/core/uverbs.h      |    3 +
>   drivers/infiniband/core/uverbs_cmd.c  |  214 ++++++++++++++++++++++++++++++
>   drivers/infiniband/core/uverbs_main.c |   42 +++++-
>   drivers/infiniband/core/verbs.c       |   27 ++++
>   drivers/infiniband/hw/mlx4/main.c     |  235 +++++++++++++++++++++++++++++++++
>   drivers/infiniband/hw/mlx4/mlx4_ib.h  |   12 ++
>   include/linux/mlx4/device.h           |    5 -
>   include/rdma/ib_verbs.h               |  122 +++++++++++++++++-
>   include/uapi/rdma/ib_user_verbs.h     |   99 ++++++++++++++-
>   9 files changed, 745 insertions(+), 14 deletions(-)
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
