From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3] IB core: Display 64 bit counters from the extended
 set
Date: Thu, 17 Dec 2015 14:47:17 -0500
Message-ID: <56731145.5010402@dev.mellanox.co.il>
References: <20151211182532.332343651@linux.com>
 <20151211182543.329283794@linux.com>
 <20151211235630.GG7855@phlsvsds.ph.intel.com>
 <20151212000047.GA9961@obsidianresearch.com>
 <566EEE69.5080906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512151351050.3509@east.gentwo.org>
 <20151215195554.GA28167@obsidianresearch.com>
 <5670717F.9090701@dev.mellanox.co.il>
 <20151215212035.GD28167@obsidianresearch.com>
 <alpine.DEB.2.20.1512161000150.17457@east.gentwo.org>
 <alpine.DEB.2.20.1512161332200.10147@east.gentwo.org>
 <5672F47F.9060806@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512171252200.2954@east.gentwo.org>
 <5673097D.8050906@dev.mellanox.co.il>
 <alpine.DEB.2.20.1512171321110.8087@east.gentwo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1512171321110.8087-wcBtFHqTun5QOdAKl3ChDw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 12/17/2015 2:21 PM, Christoph Lameter wrote:
> On Thu, 17 Dec 2015, Hal Rosenstock wrote:
> 
>>> I thought a port is always supplied since we get the info for a particular
>>> port and the directory only exists if there is a port?
>>
>> Yes, but there is no port (PortSelect) field in ClassPortInfo attribute
>> unlike the PortCounters and PortExtendedCounters attributes.
> 
> Ok but its valid for all ports on that class right? Then this does not
> matter?

It would be queried for each end port LID but should provide same
response on each port. Note that switch only has port 0 as end port.

It looks to me that in the query that the port supplied overwrites
ClassVersion field in supplied ClassPortInfo attribute which is MAD data
offset 41 where PortSelect goes. ClassPortInfo.ClassVersion is a RO
field and should be ignored by the PMA in the query and set properly in
the response so yes, you're right that it should not matter.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
