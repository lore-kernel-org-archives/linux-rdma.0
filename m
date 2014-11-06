From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 2/5] IB/core: Add support for extended query
 device caps
Date: Thu, 6 Nov 2014 10:54:05 +0200
Message-ID: <20141106085405.GE742@mtldesk30>
References: <1415001766-8366-1-git-send-email-eli@mellanox.com>
 <1415001766-8366-3-git-send-email-eli@mellanox.com>
 <5458C7FD.7070400@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5458C7FD.7070400-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 04, 2014 at 02:35:09PM +0200, Haggai Eran wrote:
> On 03/11/2014 10:02, Eli Cohen wrote:
> > +
> > +	if (ucore->outlen < sizeof(resp))
> > +		return -ENOSPC;
> 
> This check may cause compatibility problems when running a newer kernel
> with old userspace. The userspace code will have a smaller
> ib_uverbs_ex_query_device_resp struct, so the verb will always fail. A
> possible solution is to drop this check, and modify ib_copy_to_udata so
> that it only copies up to ucore->outlen bytes.
> 
Makes sense. Will fix that in V1.

> > +
> > +	if (cmd.comp_mask)
> > +		return -EINVAL;
> 
> This check may make it difficult for userspace to use this verb. If
> running an older kernel with a newer userspace, the userspace will need
> to run the verb multiple times to find out which combination of
> comp_mask bits is actually supported. I think a better way would be to
> drop this check, and let userspace rely on the returned comp_mask in the
> ib_uverbs_ex_query_device_resp struct to determine which features are
> supported by the current kernel.
>
Agree - this should hold true for any extended query. Will fix in v1.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
