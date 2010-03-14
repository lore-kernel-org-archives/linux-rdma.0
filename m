From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ipoib: Fix lockup of the tx queue
Date: Sun, 14 Mar 2010 08:52:38 +0200
Message-ID: <20100314065238.GA23263@mtldesk030.lab.mtl.com>
References: <20100303122752.GA29784@mtldesk030.lab.mtl.com>
 <adaiq92czdt.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiq92czdt.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Mar 11, 2010 at 01:38:38PM -0800, Roland Dreier wrote:
> 
> I do worry (as Moni mentioned) that this doesn't explain why you would
> get send failures in this case, but the patch itself is well-explained
> and looks "obviously correct" so I think we should apply it.

It could be a problem in the hardware driver.
Josh, can you tell what kind of hardware you were using?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
