From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core make install failing
Date: Fri, 24 Feb 2017 11:25:48 -0700
Message-ID: <20170224182548.GF22491@obsidianresearch.com>
References: <20170223230008.GA546@phlsvsds.ph.intel.com>
 <20170223231247.GB18086@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E3C6513E7@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E3C6513E7-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 24, 2017 at 02:41:22AM +0000, Weiny, Ira wrote:
> Ok I see...
> 
> The issue is that there is a bug in libibmad/infiniband-diags when
> building against the changes you made to the libibumad headers and
> using "make install" seemed easier than trying to set up building
> against my home dir...

CPPFLAGS=-I.../rdma-core/build/include/ LDLFLAGS=-L.../rdma-core/build/lib/ ./configure

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
