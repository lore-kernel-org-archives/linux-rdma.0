From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Make multicast and path record queue flexible.
Date: Tue, 12 Oct 2010 14:47:15 -0600
Message-ID: <20101012204715.GQ24268@obsidianresearch.com>
References: <4CAB4D49.9090107@voltaire.com>
	<20101005162833.GC5967@obsidianresearch.com>
	<alpine.DEB.2.00.1010051410370.7065@router.home>
	<1286900993.31931.4.camel@alst60.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1286900993.31931.4.camel-uOVkuFIEnOODI2cvxHXf6UEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Alekseys Senin <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 12, 2010 at 06:29:53PM +0200, Alekseys Senin wrote:
> On Tue, 2010-10-05 at 14:12 -0500, Christoph Lameter wrote:
> 
>     On Tue, 5 Oct 2010, Jason Gunthorpe wrote:
> 
>     > On Tue, Oct 05, 2010 at 06:07:37PM +0200, Aleksey Senin wrote:
>     > > When using slow SM allow more packets to be buffered before answer
>     > > comming back. This patch based on idea of Christoph Lameter.
>     > >
>     > > http://lists.openfabrics.org/pipermail/general/2009-June/059853.html
>     >
>     > IMHO, I think it is better to send multicasts to the broadcast MLID than to
>     > queue them.. More like ethernet that way.
> 
>     I agree. We had similar ideas. However, the kernel does send igmp
>     reports to the MC address not to 244.0.0.2. We would have to redirect at
>     the IB layer until multicast via MLID becomes functional. We cannot tell
>     when that will be the case.
> 
> But what if it will not be available from some reason? How long
> should we wait?  Do we need implement another queue/counter/timeout?

If you follow the scheme I outlined - where traffic to a MGID that
doesn't yet have a MLID is routed to the broadcast MLID then you do it
until you get a MLID, with periodic retries/refreshes of the SA
operation.

This is similar to how ethernet works, and is generally
harmless. Better to have a working, but suboptimal network, than one
that is busted.

Jason
