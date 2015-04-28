From: "Dave Goodell (dgoodell)" <dgoodell@cisco.com>
Subject: Re: [PATCH v6 01/26] IB/Verbs: Implement new callback
 query_transport()
Date: Tue, 28 Apr 2015 19:50:48 +0000
Message-ID: <C8AE8850-C411-4805-95C2-6884669D92CF@cisco.com>
References: <1429878230-11749-1-git-send-email-yun.wang@profitbricks.com>
 <1429878230-11749-2-git-send-email-yun.wang@profitbricks.com>
 <DB4PR05MB086367DF92CEE1977D8EB0AEB1EC0@DB4PR05MB0863.eurprd05.prod.outlook.com>
 <553DE799.5050608@profitbricks.com>
 <20150427215229.GD5347@phlsvsds.ph.intel.com> <553ED159.2090006@talpey.com>
 <1430181360.44548.35.camel@redhat.com> <553EDA01.9040708@talpey.com>
 <1430184275.44548.44.camel@redhat.com> <553EE718.1030502@talpey.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FC819C@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC819C@ORSMSX109.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <AAAA9E209052CA45B4BE88769008ED94@emea.cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>
Cc: Tom Talpey <tom@talpey.com>, Doug Ledford <dledford@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, Michael Wang <yun.wang@profitbricks.com>, Liran Liss <liranl@mellanox.com>, Roland Dreier <roland@kernel.org>, Hal Rosenstock <hal@dev.mellanox.co.il>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Steve Wise <swise@opengridcomputing.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Tom Tucker <tom@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, "raisch@de.ibm.com" <raisch@de.ibm.com>, infinipath <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, "Latif, Faisal" <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On Apr 28, 2015, at 1:14 AM, Hefty, Sean <sean.hefty@intel.com> wrote:

>>> Keep in mind that this enum was Liran's response to Michael's original
>>> patch.  In the enum in Michael's patch, there was both USNIC and
>>> USNIC_UDP.
>> 
>> Right! That's why I'm confused. Seems wrong to drop it, right?
> 
> I think the original USNIC protocol is layered directly over Ethernet.  The protocol basically stole an Ethertype (the one used for IBoE/RoCE) and implemented a proprietary protocol instead.  I have no idea how you resolve that, but I also don't think it's used anymore.  USNIC_UDP is just UDP.

Sean is correct. The legacy RDMA_TRANSPORT_USNIC code used a proprietary protocol over plain Ethernet frames.  The newer RDMA_TRANSPORT_USNIC_UDP code is just standard UDP/IP/Ethernet packets exposed to user space via the uverbs stack.  The current kernel module will support both formats, it just depends on which user space requests at create_qp time.  From the kernel point of view there is no common protocol between the two TRANSPORTs (other than sharing partially similar Ethernet frames at L2).

I posted last week to clarify some of this: http://marc.info/?l=linux-rdma&m=142972177830718&w=2

>> Well, if RoCEv2 uses the same protocol enum, that may introduce new
>> confusion, for example there will be some new CM handling for UDP encap,
>> source port selection, and of course vlan/tag assignment, etc. But if
>> there is support under way, and everyone is clear, then, ok.
> 
> RoCEv2/IBoUDP shares the same port space as UDP.  It has a similar issues as iWarp does sharing state with the main network stack.  I'm not aware of any proposal for resolving that.  Does it require using a separate IP address?  Does it use a port mapper function?  Does netdev care for UDP?  I'm not sure what USNIC does for this either, but a common solution between USNIC and IBoUDP seems reasonable.

Is the concern here about CM issues or the UDP ports used by the actual usNIC RQs?  CM is not used/supported for usNIC at this time.

-Dave
