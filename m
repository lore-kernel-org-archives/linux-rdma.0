From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 11:29:53 -0600
Message-ID: <20100323172953.GI29129@obsidianresearch.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com> <20100323165920.GH29129@obsidianresearch.com> <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D7DCABC9-4BB2-4FBA-A7B3-C06F4A848467-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 23, 2010 at 01:17:40PM -0400, Jeff Squyres wrote:
> On Mar 23, 2010, at 12:59 PM, Jason Gunthorpe wrote:
> 
> > The main reason for the new FD is so it can be polled on..
> 
> What do you poll on the fd for?
> 
> With ummunotify, you only read() from the fd when (counter !=
> last_counter).  Were you thinking that the poll() would be for
> something else?

poll() is for apps that want to get the notifications without
spinning on the counter. If you don't think that is worth doing it
does simplify things alot, just add two new verbs calls:

ibv_set_mmu_counter(verbs, &my_counter);
ibv_get_mmu_notifications(verbs, &my_list, sizeof(my_list));

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
