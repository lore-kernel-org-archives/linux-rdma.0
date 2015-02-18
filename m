From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/core: Add support for extended query device caps
Date: Tue, 17 Feb 2015 22:21:59 -0800
Message-ID: <CAL1RGDU95-xh=KQwaXRGoHkZJjTkXGgT8Y0cwbWbHD8DEWAP=g@mail.gmail.com>
References: <1423394932-2965-1-git-send-email-haggaie@mellanox.com> <1423394932-2965-2-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423394932-2965-2-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The verb also checks the user-space provided response buffer size and only
> fills in capabilities that will fit in the buffer. In attempt to follow the
> spirit of presentation [2] by Tzahi Oved that was presented during OpenFabrics
> Alliance International Developer Workshop 2013, the comp_mask bits will only
> describe which fields are valid.

> +       if (ucore->outlen < resp.response_length)
> +               return -ENOSPC;

So is this really what we want?  A future kernel that adds new fields
will cause previously working userspace to get an error?

Or do we expect userspace to retry with a bigger buffer on ENOSPC,
without actually returning the required size back to userspace?

Is there anything wrong with truncating the response to only include
the fields that userspace asked for?  Is it just that this is the
initial implementation of the query_device_ex verb, so the current
size is also the minimum size?  If so I think we need at least a
comment here, so that we remember to fix the ENOSPC code when adding
more fields in the kernel.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
