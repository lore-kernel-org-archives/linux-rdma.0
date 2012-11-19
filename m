From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 407/493] infiniband: remove use of __devexit
Date: Mon, 19 Nov 2012 14:49:22 -0700
Message-ID: <20121119214922.GA5636@obsidianresearch.com>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
 <1353349642-3677-407-git-send-email-wfp5p@virginia.edu>
 <20121119200921.GD1556@obsidianresearch.com>
 <20121119201938.GA5614@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121119201938.GA5614-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Bill Pemberton <wfp5p-4Ng6DfrEGID2fBVCVOL8/A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 19, 2012 at 12:19:38PM -0800, Greg KH wrote:
> On Mon, Nov 19, 2012 at 01:09:21PM -0700, Jason Gunthorpe wrote:
> > On Mon, Nov 19, 2012 at 01:25:56PM -0500, Bill Pemberton wrote:
> > > CONFIG_HOTPLUG is going away as an option so __devexit is no
> > > longer needed.
> > 
> > I'm sad to hear this, it is an easy space saver on my non-modular
> > emebedded systems :(
> 
> Really?  I asked for details, and it was reported that this only saved
> 1-200 bytes or so.  See the lkml archives for the details of this.

I just checked for you:

Old 2.6.16 powerpc 32 kernel:

   text    data     bss     dec     hex filename
2399368  222224  156124 2777716  2a6274 build/vmlinux
2394634  221804  156124 2772562  2a4e52 build-nhp/vmlinux

That looks like around 5154 bytes to me

New 3.6 powerpc 32 kernel:

   text    data     bss     dec     hex filename
3352356  162812  218132 3733300  38f734 build/vmlinux
3347644  162648  217860 3728152  38e318 build-nhp/vmlinux

And that is about 5148 bytes.

In both cases the only difference is adding CONFIG_HOTPLUG=y to the
config.

5k isn't a lot, but in the context of 'I have to figure out how to
trim ~1MB off the 3.6 kernel to run it in our smallest hardware' it is
the wrong direction :(

Regards,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
