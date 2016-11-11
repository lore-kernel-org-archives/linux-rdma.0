From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Fri, 11 Nov 2016 11:07:32 -0800
Message-ID: <a5c83231-3bd5-0217-1ee3-9545ef55a964@vmware.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
 <20161104004620.GA30318@obsidianresearch.com>
 <b88ad364-9d33-dd3e-a803-bb660de3b384@vmware.com>
 <20161105150307.GB23803@obsidianresearch.com>
 <20161105173815.GA28539@infradead.org> <581E4E01.5020405@redhat.com>
 <f67c81ff-d358-7242-dc52-e32dff252904@vmware.com>
 <20161109011715.GA29310@infradead.org>
 <b49161b1-75f6-6902-fced-355804b885bb@vmware.com>
 <20161109175142.GA13467@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161109175142.GA13467-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 09, 2016 at 10:51:42AM -0700, Jason Gunthorpe wrote:
> On Wed, Nov 09, 2016 at 09:39:49AM -0800, Adit Ranadive wrote:
> > On Tue, Nov 08, 2016 at 5:17:15PM -0800, Christoph Hellwig wrote:
> > > FYI, the convention used in scsi is vmw_pvscsi.c, so naming the
> > > RDMA equivalent vmw_pvrdma would make a lot of sense and still
> > > be reasonably short.
> > 
> > Thanks Christoph. We agree with that as well. Then the driver path
> > (drivers/infiniband/hw/vmw_pvrdma/...) and the module name would
> > reflect vmw_pvrdma.
> > What about the user library? libpvrdma -> libvmwpvrdma?
> 
> I am encouraging people to match the name of the module in the
> library.
>
> Jason
> 

Hi Doug,

We would like to get the driver in 4.10 if its possible. I can 
respin the patches (with the new driver name/location) based on your
for-4.10 branch or another branch if you prefer.

Thanks,
Adit
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
