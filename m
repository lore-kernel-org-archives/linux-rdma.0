From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Thu, 3 Nov 2016 18:46:20 -0600
Message-ID: <20161104004620.GA30318@obsidianresearch.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1478216677-6150-1-git-send-email-aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 03, 2016 at 04:44:29PM -0700, Adit Ranadive wrote:
> 
> I have included the shared ABI file here based on the RDMA fix up stuff 
> that Jason pointed me to.

I left you some trivial notes on github.

The big item is that the shared ABI file must be byte for byte
identical to the kernel version, and it looks to me like it was
changed?

We still do not have a general solution to the need to add the header
struct in user space but not in kernel space, so you will need to
continue to get your enums from the kernel header but still have a
'copy' with the modified structs.

Does that make sense?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
