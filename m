From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Wed, 14 Oct 2009 11:40:17 -0600
Message-ID: <20091014174017.GM5191@obsidianresearch.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	<20091013231234.GK5191@obsidianresearch.com>
	<1255537437.14513.28.camel@wilder.ibm.com>
	<20091014170155.GL5191@obsidianresearch.com>
	<1255541405.5111.14.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255541405.5111.14.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 10:30:05AM -0700, David J. Wilder wrote:

> This looks good. Once concern, it may be obtuse, but if both the src and
> dst are link-local addresses should only one need to be scoped?  This
> patch will required the src to always be scoped when using link local.  

The TCPv6 code requires the src to be scoped (or SO_BINDTODEVICE to be
used prior). If src is scoped then it is optional to scope dest, but
if dest is scoped then it must match. I intended to capture that logic..

Can you give a quick test and send a git format-patch/checkpatch'd
patch to Roland, with your signed off line, etc. You can put a
Reviewed-by line from me as well if you like.

Thanks,
Jason
