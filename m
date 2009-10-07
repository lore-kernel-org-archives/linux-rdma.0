From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Tue, 6 Oct 2009 23:30:16 -0600
Message-ID: <20091007053016.GC18578@obsidianresearch.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <20091005175656.GK5191@obsidianresearch.com> <F7D418716F3A4A0DACE42CC449624298@amr.corp.intel.com> <20091005181525.GL5191@obsidianresearch.com> <5AEC2602AE03EB46BFC16C6B9B200DA8168EFD82BA@MNEXMB2.qlogic.org> <D61F37041B6F49ACB0AC64FBF2DC4D00@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D61F37041B6F49ACB0AC64FBF2DC4D00-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: 'Todd Rimmer' <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 06, 2009 at 12:05:02PM -0700, Sean Hefty wrote:
> >Ideally the best approach would be to have a mux at the ib_mad level.  We could
> >allow a user space application to intercept all outbound MADs for a given class
> >and/or attribute.  Unlike the present "snooping" of mads, this would literally
> >be a interception.  This would provide a number of key advantages:
> 
> I agree that this is a good idea, and I mentioned something similar to this
> before on the list.  The idea was rejected in favor of using standard SA
> redirection.

Actually, I think MAD capture is much too low level.

As in the other message, if we could have a rdma_get_addr_info style
API then it would wonderful to do as glibc does and trap that out via
a socket to a nscd-like caching/whatever daemon.

If the kernel was also fixed up to be able to take addressing data (ie a
IB PR set) for NFS and SDP connection setup then this same API could
be used to provide caching/whatever for the majority of cases..

Maybe someday? :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
