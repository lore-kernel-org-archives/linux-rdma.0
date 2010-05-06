From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ibcheckerrors "Port All FAILED" reported
Date: Fri, 7 May 2010 00:11:24 +0300
Message-ID: <20100506211124.GH7099@me.iol.unh.edu>
References: <382A478CAD40FA4FB46605CF81FE39F45685DEAD@orsmsx507.amr.corp.intel.com>
	<20100505180943.a9bbb74e.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100505180943.a9bbb74e.weiny2-i2BcT+NCU+M@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, EWG <Openfabrics-ewg-0P3JtQMG0aQdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 18:09 Wed 05 May     , Ira Weiny wrote:
> 
> 14:29:03 > ./perfquery 40 255
> ./perfquery: iberror: failed: AllPortSelect not supported
> 
> It seems there is an issue with the CapabilityMask value...
> 
> 14:43:32 > ./perfquery 40 255
> cap_mask 0x400  <=== my debug output
> ./perfquery: iberror: failed: AllPortSelect not supported
> 
> 14:43:38 > ./saquery CPI 40
> SA ClassPortInfo:
> ...
>                 Capability mask..........0x2602
> ...
> 
> Those don't match because...  perfquery has a bug...
> 
> perfquery is issuing a PMA query when it should be issuing a SA query.

I'm not following. How should it be related to each other SA and PM
ClassPortInfo(s)?

Sasha
