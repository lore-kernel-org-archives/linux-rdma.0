From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB core: Fix locking on device numbers allocation
Date: Thu, 25 Mar 2010 09:36:35 +0200
Message-ID: <20100325073635.GF12224@mtldesk030.lab.mtl.com>
References: <20100323191317.GA14496@mtldesk030.lab.mtl.com>
	<adaiq8l1uwp.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaiq8l1uwp.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 24, 2010 at 10:39:18AM -0700, Roland Dreier wrote:
> 
> Looks like a good catch.  I assume you found this through inspection and
> not hitting it practice?
Correct, I caught this from inspecting the code.

>  Also it seems user_mad.c would need the same fix.
Yes, I missed that.

> 
> Although looking at this I wonder if we do need that lock... we don't
> seem to do any locking when we do the clear_bit in the dev_map, and all
> of this is done through the device add/remove callback, which seems to
> be serialized by the device_mutex in device.c.  But we probably don't
> want to make that a requirement in case we parallelize in the future.
> 
I missed the fact the clear_bit is not atomic. So to make this
complete I will send a new patch with protection on the clear bit.
Would you like me to send a patch for user_mad too or would you push
that?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
