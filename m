From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Thu, 13 May 2010 16:07:52 +0300
Message-ID: <20100513130752.GK16073@mtldesk030.lab.mtl.com>
References: <20100218172403.GE12286@mtls03>
	<adaocgkubbq.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adaocgkubbq.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 12, 2010 at 01:14:33PM -0700, Roland Dreier wrote:
>  > Multicast GIDs are always mapped to multicast MACs
>  > as is done in IPv6. Some helper functions are added to ib_addr.h.  IPv4
>  > multicast is enabled by translating IPv4 multicast addresses to IPv6 multicast
>  > as described in
>  > http://www.mail-archive.com/ipng-Va8kgSFw1KyzQ7sTrsxvMkEOCMrvLtNR@public.gmane.org/msg02134.html.
> 
> I guess it's a bit unfortunate that the RoCE annex completely ignored
> how to map multicast GIDs to ethernet addresses (I suppose as part of
> the larger decision to ignore address resolution entirely).  Anyway,
> looking at the email message you reference, it seems to be someone
> asking what the right way to map IPv4 multicast addresses to IPv6
> addresses is.  Is there a more definitive document you can point to?

I am not aware of any definitive document that addresses this issue.

> 
> It seems that unfortunately the way the layering of addresses is done,
> there's no way to just use the standard mapping of IPv4 multicast
> addresses to Ethernet addresses (since IBoE is does addressing via
> the CMA mapping to GIDs followed by an unspecified mapping from GIDs to
> Ethernet addresses).
> 

It is natural to treat gids as IPv6 addresses, so using the standard
mapping from IPv6 multicast addresses to mac addresses seems reasonable.
