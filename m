From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/5] ib/mad: update module to pr_* style print messages
Date: Wed, 7 May 2014 09:32:46 -0600
Message-ID: <20140507153246.GB20689@obsidianresearch.com>
References: <1399340690-27677-1-git-send-email-ira.weiny@intel.com>
 <1399340690-27677-3-git-send-email-ira.weiny@intel.com>
 <20140506025356.GB2307@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E04B82C73@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E04B82C73-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 07, 2014 at 02:30:04PM +0000, Weiny, Ira wrote:
> > 
> > On Mon, May 05, 2014 at 09:44:47PM -0400, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > >
> > > Also combine previously line broken user-visible strings as per
> > > Documentation/CodingStyle
> > 
> > These seem like nice cleanups, however it would be much nicer to use the
> > dev_* versions when a struct device is available, I think many of these cases
> > can reach the /dev/umadX struct device..
> 
> Ok, this works nice for ib_umad:
> 
> infiniband_mad umad1: ib_umad_reg_agent2 failed: invalid registration flags specified 0x2; supported 0x1
> vs.
> user_mad: ib_umad_reg_agent2 failed: invalid registration flags specified 0x2; supported 0x1

Right..

> However in ib_mad I'm not so sure.  The error now implies it is the
> driver which is flagging the error, _not_ ib_mad.

Does it matter? ib_mad is a kernel implementation detail, and a kernel
consumer could trigger the debugging print as well. The function name
is a big enough clue that the problem is ib_mad related, IMHO.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
