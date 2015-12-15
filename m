From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Tue, 15 Dec 2015 15:01:03 -0500
Message-ID: <5670717F.9090701@dev.mellanox.co.il>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <566EEE69.5080906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151215195554.GA28167-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/15/2015 2:55 PM, Jason Gunthorpe wrote:
> On Tue, Dec 15, 2015 at 01:51:35PM -0600, Christoph Lameter wrote:
>> On Mon, 14 Dec 2015, Hal Rosenstock wrote:
>>
>>>> Mellanox should really confirm this for their hardware matrix.
>>>
>>> I am trying to get definitive answer to this.
>>
>> I was told today on a conf call with a couple of Mellanox employees that
>> extended counters are always available.
> 
> .. and every field is valid?
> 
> I would agree, from my observation, that the two main byte counters
> are always available.

The extended packet counts work but I thought there was a PMA with one
of the extended byte counts wired to 0.

> But not necessarily the others.

The unicast/multicast extended counters are not always supported -
depends on setting of PerfMgt ClassPortInfo
CapabilityMask.IsExtendedWidthSupportedNoIETF (bit 10).

-- Hal

> Jason 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
