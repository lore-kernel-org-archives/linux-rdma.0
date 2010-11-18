From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: RE: RDMA with multiple read/write
Date: Thu, 18 Nov 2010 16:50:47 +0100 (CET)
Message-ID: <3625421.1290095447257.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <5781964.1289558094205.SLOX.WebMail.wwwrun@imap.lnl.infn.it> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B852239F@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B852239F-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Nov 12, 2010 06:23 PM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > I would like to perform test about RDMA server/client about multiple
> > reads or/and writes.
> > Can server/client store few memory regions? If yes, how?
> 
> An app can register multiple memory regions. Just call register mr for
> each region that you want to register.
> 
> > Client writes on different MRs with only one send WR. Is that
> > possible?
> 
> No - an RDMA write targets a single remote MR.
> 
> > The goal is: build an array of addresses (MRs) and write (or read)
> > with
> > a First Input Fist Output (FIFO) model using RDMA.
> > 
> > Any ideas?
> 
> If you have an array of addresses, you can register each address and
> store the mr handle with each. The address, rkey associations must be
> transferred to the remote peer, so it can issue the RDMA operations.
> 
> Unless the addresses are scattered, you could also look at registering
> a single, larger memory region, with each RDMA operation targeting
> only a portion of that region.


--> I register a single larger memory region with rdma_reg_msgs.
What are parameters in rdma_post_recv function to use these "big" memory
regions few times? In other words, on that MR can I write/read different
smaller messages?

Andrea Gozzelino


> Although, based on this brief description of having a FIFO, posted
> receive buffers may work just as well for you. And a receive would
> allow incoming data to be scattered to different memory buffers.
> 
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 	

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
