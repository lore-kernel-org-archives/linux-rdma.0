From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Sat, 5 Nov 2016 09:01:36 -0600
Message-ID: <20161105150136.GA23803@obsidianresearch.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
 <20161104004620.GA30318@obsidianresearch.com>
 <b88ad364-9d33-dd3e-a803-bb660de3b384@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b88ad364-9d33-dd3e-a803-bb660de3b384-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 04, 2016 at 02:00:37PM -0700, Adit Ranadive wrote:
> I commented on most of the notes and I'll post a fix to address them.
> Do I have re-issue the pull request or would it pick it automatically
> after I push it?

No just keep pushing, Doug can squash everything into one commit when
applying.

> > The big item is that the shared ABI file must be byte for byte
> > identical to the kernel version, and it looks to me like it was
> > changed?
> > 
> > We still do not have a general solution to the need to add the header
> > struct in user space but not in kernel space, so you will need to
> > continue to get your enums from the kernel header but still have a
> > 'copy' with the modified structs.
> > 
> > Does that make sense?
> 
> Not entirely. You want me to keep the ABI file from the kernel in the
> fix up folder and also keep a file with the modified structs in
> providers/pvrdma?

Yes, and the file with the modified structs should include the kernel
header and duplicate it minimally. This will make it simpler for us to
eventually get rid of it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
