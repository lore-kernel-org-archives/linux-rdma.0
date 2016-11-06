From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Sat, 5 Nov 2016 18:31:29 -0700
Message-ID: <f67c81ff-d358-7242-dc52-e32dff252904@vmware.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
 <20161104004620.GA30318@obsidianresearch.com>
 <b88ad364-9d33-dd3e-a803-bb660de3b384@vmware.com>
 <20161105150307.GB23803@obsidianresearch.com>
 <20161105173815.GA28539@infradead.org> <581E4E01.5020405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <581E4E01.5020405-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat Nov 05 2016 14:24:17 GMT-0700 (PDT), Doug Ledford wrote:
> On 11/5/16 11:38 AM, Christoph Hellwig wrote:
> > On Sat, Nov 05, 2016 at 09:03:07AM -0600, Jason Gunthorpe wrote:
> > > Oh, I wanted to ask about the name - we have two 'pv' drivers now,
> > > should this be called pvrdma_vmware or something? Is there a
> > > convention for this in other parts of the kernel?
> > 
> > Yes, it should, even if we have no exact convention.
> > 
> 
> Agreed.  I hate how long the driver name will end up being, but pvrdma_
> as a prefix sounds appropriate.
> 

Hi Jason/Doug,

I wasn't aware that there was another paravirtual RDMA driver being upstreamed.
Maybe I missed it in the linux-rdma list?

Shouldn't this be a vendor choice since it would depend on how they want
to name their driver as long as it doesn't clash with any existing ones?

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
