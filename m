From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/8] libpvrdma: userspace library for PVRDMA
Date: Wed, 9 Nov 2016 10:56:06 -0700
Message-ID: <20161109175606.GB13467@obsidianresearch.com>
References: <1478216677-6150-1-git-send-email-aditr@vmware.com>
 <20161104004620.GA30318@obsidianresearch.com>
 <b88ad364-9d33-dd3e-a803-bb660de3b384@vmware.com>
 <20161105150136.GA23803@obsidianresearch.com>
 <20161109012335.GA29658@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161109012335.GA29658-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, pv-drivers <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 08, 2016 at 05:23:35PM -0800, Christoph Hellwig wrote:
> On Sat, Nov 05, 2016 at 09:01:36AM -0600, Jason Gunthorpe wrote:
> > > Not entirely. You want me to keep the ABI file from the kernel in the
> > > fix up folder and also keep a file with the modified structs in
> > > providers/pvrdma?
> > 
> > Yes, and the file with the modified structs should include the kernel
> > header and duplicate it minimally. This will make it simpler for us to
> > eventually get rid of it.
> 
> Can we just automate generating the user header, e.g. have a sed script
> that recognized a magic comments ala
> 
> 	/* LIBIBVERBS PREAMBLE (DO NOT REMOVE) */
> 
> and just insers the needed fields?

Yah, something like that is a maybe, but if the drivers are going to
be small like pvrdma, I think we are OK with this approach.. I haven't
had time to audit what is needed beyond knowing that the uverbs header
is actually quite big.

Adit, make sure you push your patch to github too..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
