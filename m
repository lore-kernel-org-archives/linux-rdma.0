From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 for-next 0/4] Add receive Flow Steering support
Date: Mon, 5 Aug 2013 15:54:37 -0500
Message-ID: <20130805205437.GA7488@sbohrermbp13-local.rgmadvisors.com>
References: <1372873336-13694-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1372873336-13694-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 03, 2013 at 08:42:12PM +0300, Or Gerlitz wrote:
> Hi Roland, all
> 
> V3 addresses the comments made by Sean. There are still some concerns/questions posed 
> by Roland on the uverbs extensions element of the series. I have posted replies for
> them, but so far no further comments were made. 
> 
> V3 changes:
>   - Addressed comments from Sean:
>   - modified the change-log of patch #1 to be clearer on the priority and domain
>     semantics and usage
>   - re-arranged the fields of struct ib_flow_attr
>   - removed check from ib_flow_destroy
>   - removed the IB flow spec which wasn't inline with the L2/L3/L4 approach
>     done for Ethernet/IP/TCP|UDP, will use proper IB flow specs when adding
>     the support for IPoIB flow steering
> 
>      
> V2 changes:
>   - dropped struct ib_kern_flow from patch #3, this structure wasn't 
>     used and was left there by mistake (bug, thanks Roland)
>   - removed the void *flow_context field from struct ib_flow, this was 
>     pointing to driver private data for that flow, but doesn't belong here, 
>     i.e need not be seen by the verbs consumer but rather hidden.
>   - renamed struct mlx4_flow_handle to mlx4_ib_flow, a structure that contains 
>     the verbs level struct ib_flow and the mlx4 registeration ID for that flow
> 
> V1 changes:
> 
>  - dropped the five pre-patches which were accepted into 3.10
>  - rebased the patches against Roland's for-next / 3.10-rc4
>  - in patch #3, ib_uverbs_destroy_flow was returning too quickly when the driver
>    returned failure for ib_destroy_flow, need to free some uverbs resources 1st.
>  - in patch #4, check index before accessing the array at mlx4_ib_create/destroy_flow
> 
> These patches add Flow Steering support to the kernel IB core, to uverbs and 
> to the mlx4 IB (verbs) driver along with one patch to uverbs which adds 
> some code to support extensions.
> 
>   IB/core: Add receive Flow Steering support
>   IB/core: Infra-structure to support verbs extensions through uverbs
>   IB/core: Export ib_create/destroy_flow through uverbs
>   IB/mlx4: Add receive Flow Steering support
> 
> The main patch which introduces the Flow-Steering API is "IB/core: Add receive Flow 
> Steering support", see its change log. Looking on the "Network Adapter Flow Steering" 
> slides from Tzahi Oved which he presented on the annual OFA 2012 meeting could be helpful
> https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/518-network-adapter-flow-steering.html

I'd like to nudge this along and provide a little high-level feedback
to the Infiniband development/review process.  First I appreciate all
of the hard work that everyone does writing and reviewing code.  It
appears the review standards are very high and as a result it takes a
long time for some of these features to actually make it upstream.
While I certainly could help things along by reviewing the code I
suspect I could provide much more value by running and testing the
code.

The problem with running and testing this code is that many of these
features are posted in incomplete (from the user point of view)
chunks.  As an example I don't really see how anyone is currently
using raw QPs on upstream code since this flow steering patch set is
missing, I still haven't seen the corresponding patches to libibverbs,
and IP checksum support is still missing from the send side.

I would really love to see both the user and kernel sides of a feature
posted to the list at the same time so that I can easily test and
provide feedback on features that interest me.  I fully understand
that over the review process interfaces may change and that even with
testing the code will need proper review.  Unfortunately until there
is a full patch set to test I can't be very helpful.

Thanks,
Shawn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
