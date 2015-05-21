From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/IPoIB: Support SRIOV standard configuration
Date: Thu, 21 May 2015 15:21:00 -0600
Message-ID: <20150521212100.GA28758@obsidianresearch.com>
References: <1432225447-6536-1-git-send-email-ogerlitz@mellanox.com>
 <1432225447-6536-2-git-send-email-ogerlitz@mellanox.com>
 <20150521184613.GD6771@obsidianresearch.com>
 <1432242331.28905.67.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1432242331.28905.67.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 21, 2015 at 05:05:31PM -0400, Doug Ledford wrote:
> It has to be the 8byte guid, the next 8bytes are the subnet prefix which
> is set by the SM and not under driver control, and the final 4bytes are
> specific to the IPoIB connection.  You could pass in all 20bytes, but
> you would only be able to set 8 of them.

Of course you can't set all 20 bytes, but you still have to provide
them, that is the defined LLADDR format for this device.

1) Kernel demands immutable bits are zero and fills them in
   automatically
2) Userspace copies the current LLADDR and only modifies the 8 bytes
   of the GUID, kernel demands immutable bits are unchanged
3) Who is to say the QPN can't be made settable someday? People have
   complained about the unstable QPN in the past.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
