From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Wed, 18 Jan 2012 11:56:20 -0700
Message-ID: <20120118185620.GJ2892@obsidianresearch.com>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org>
 <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
 <4F169940.5090007@mellanox.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB5CD590F65E@MNEXMB1.qlogic.org>
 <CAL1RGDUh1AEMdok69RJP1cTchvCW7C7HJFTmYm=kUNu7hWA_5Q@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823732DC00DEE@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC00DEE-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 18, 2012 at 05:20:13PM +0000, Hefty, Sean wrote:
> > Surely we should be picking the response status based on the IB spec
> > rather than on the error message that some arbitrary tool prints?
> 
> agreed - these are the basic choices:
> 
> Code for invalid field
> 0 - no invalid fields
> 1 - Bad version. Either the base version, or the class version, or the
> combination of the two is not supported.
> 2 - The method specified is not supported
> 3 - The method/attribute combination is not supported
> 
> none of which seem that great...  IMO, unsupported class version
> seems as good as any.

Figure 169 specifies the validation flow. 1 is the correct reply for
'Management class is not supported on this port'.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
