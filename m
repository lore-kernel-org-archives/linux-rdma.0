From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] [for-2.6.33] rdma/cm: disallow loopback address
 for	iwarp devices
Date: Mon, 08 Feb 2010 08:29:58 -0600
Message-ID: <4B701FE6.60302@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com>	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>	<4B6D9948.6040007@opengridcomputing.com>	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>
	<79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>
	<4B6FFB1B.40905@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
In-Reply-To: <4B6FFB1B.40905-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org, "Roland Dreier (rdreier)" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch doesn't solve the openmpi/IB regression.   So for OFED, IMO, 
we need a different patch...


Tziporet Koren wrote:
> On 2/8/2010 8:02 AM, Sean Hefty wrote:
>> Since iWarp devices are not guaranteed to support loopback connections,
>> prevent rdma_bind_addr from associating the loopback address with
>> an iWarp device.
>>
>> Signed-off-by: Sean Hefty<sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>    
>
> Steve
> Have you tested this patch?
> When accepted to kernel can you prepare a patch for OFED 1.5.1 under 
> fixes
>
> Thanks
> Tziporet
