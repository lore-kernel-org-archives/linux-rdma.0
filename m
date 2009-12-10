From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [ewg] Re: [PATCH] rdmaoe/libibverbs: handle binary
	compatibility
Date: Thu, 10 Dec 2009 15:17:55 -0700
Message-ID: <20091210221755.GQ6188@obsidianresearch.com>
References: <20091210170536.GA3229@mtls03> <20091210173353.GW1966@obsidianresearch.com> <20091210211455.GA5166@mtls03> <20091210214945.GP6188@obsidianresearch.com> <adaein2lcg8.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaein2lcg8.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 10, 2009 at 01:57:11PM -0800, Roland Dreier wrote:

> Maybe I'm wrong but I don't like setting "don't know" magically to IB
> behind the scenes.

Well, it isn't just "don't know" it also means "the kernel doesn't
support the link_layer query". The kernels that don't support
link_layer also only support link_layer == IB for
IBV_TRANSPORT_IB. One proves the other..

So IBV_TRANSPORT_IB ports should always return
IBV_LINK_LAYER_INFINIBAND unless the kernel supports the new API and
says otherwise. You can still have IBV_LINK_LAYER_UNSPECIFIED, but it
can't be 0.

If this isn't done then again compatability with apps is compromised,
what should an app do when it sees IBV_LINK_LAYER_UNSPECIFIED due to
an older kernel and newer libibverbs?

> And there's no reason why iWARP has to run over ethernet in
> principle.

Right.. so existing kernels with the new library should return
IBV_LINK_LAYER_INFINIBAND for ports on IBV_TRANSPORT_IB devices and
IBV_LINK_LAYER_UNSPECIFIED for ports on everything else
(IBV_TRANSPORT_IWARP, IBV_TRANSPORT_UNKNOWN)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
