From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Status of RXE/Soft-RoCE driver?
Date: Mon, 2 May 2016 12:40:05 -0600
Message-ID: <20160502184005.GA32613@obsidianresearch.com>
References: <20160428115653.GB21343@leon.nu>
 <CAJ3xEMjz-VLvaRvVFBtNc+9GDppW6qjw_5KwZvPRDi1RdUnsgQ@mail.gmail.com>
 <5722C24B.6020108@redhat.com>
 <20160429051755.GC774@leon.nu>
 <a1d504ff-716c-210a-7114-517577d2e0fa@redhat.com>
 <20160429205434.GA11286@obsidianresearch.com>
 <20160430072847.GB25593@leon.nu>
 <572725E0.4090303@dev.mellanox.co.il>
 <20160502175709.GA31976@obsidianresearch.com>
 <20160502183151.GA6462@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502183151.GA6462-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Tzahi Oved (tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 02, 2016 at 11:31:51AM -0700, Christoph Hellwig wrote:
> On Mon, May 02, 2016 at 11:57:09AM -0600, Jason Gunthorpe wrote:
> > The other take away from the Collab discussion is that there is a
> > reasonable opinion that linux-rdma is not the right forum to decide if
> > major changes to the multi-vendor common-verbs APIs are
> > OK. I don't know if we reached a consensus on this or not.
> 
> Who had that discussion, and why do you believe it's viable?  In fact
> I'd like to state that any other forum than linux-rdma simply is not
> credible, just like the relevant list is the only credible place to
> discuss the ABIs for any other Linux subsystem.

I would say mostly from people looking at it from a hardware design
perspective.

The unique issue with verbs is that nearly all the APIs match directly
to some feature in silicon, and cross-vendor silicon focused agreements
are rarely done on Linux focused mailing lists. Particularly when
these features are expected to be multi-operating system.

That is my fundamental concern every time a uAPI change comes up:
These proposed API changes *directly* require other vendors to
implement very specific things in their sillicon. This is not a
software-only discussion, as the majority of other Linux uAPI things
are.

* And I specifically separate the nitty gritty details of the API/ABI
from the overarching ideas: eg, introducing a dis-aggregated QP
concept with WQ objects, and defining it how that interacts with
everything else.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
