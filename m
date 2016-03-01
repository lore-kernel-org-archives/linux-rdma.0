From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/core: Support accessing SA in
 virtualized environment
Date: Tue, 1 Mar 2016 21:07:42 +0200
Message-ID: <20160301190742.GC19366@x-vnc01.mtx.labs.mlnx>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
 <1456851143-138332-4-git-send-email-eli@mellanox.com>
 <20160301174401.GC25176@obsidianresearch.com>
 <20160301181742.GB19366@x-vnc01.mtx.labs.mlnx>
 <20160301183256.GB12495@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160301183256.GB12495-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 01, 2016 at 11:32:56AM -0700, Jason Gunthorpe wrote:
> 
> How does this interact with the existing SRIOV stuff? It is already
> very annoying that mlx5 is incompatible with the old scheme. Is the
> proposal to shift all IB to this new scheme, or still keep mlx4/mlx5 with
> different approaches?

Now we have proper interfaces so we can use these interfaces to
implement the same functionality in mlx4 which is there but accessible
in a different manner.
> 
> We can't just have the kernel become incompatible with existing
> SMs. Eg opensm only supports the old scheme last I looked.
> 
You need a SM which support virtualizaion to have virtualization
supported but if you don't you can still work with physical functions
in the same way you did before so we don't break anything, we just
adding new functionality.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
