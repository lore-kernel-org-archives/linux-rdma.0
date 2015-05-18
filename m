From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH RFC v2] Documentation/infiniband: Add docs for rdma-helpers
Date: Mon, 18 May 2015 12:06:15 +0200
Message-ID: <5559B997.1030502@profitbricks.com>
References: <1431938505-31779-1-git-send-email-yun.wang@profitbricks.com> <CAJ3xEMgkrUgSvRV7m_M9CE4w66Wyk-Svnfejvavj38iTNyH9HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CAJ3xEMgkrUgSvRV7m_M9CE4w66Wyk-Svnfejvavj38iTNyH9HQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Or Gerlitz <gerlitz.or@gmail.com>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
List-Id: linux-rdma@vger.kernel.org

Hi, Or

On 05/18/2015 11:47 AM, Or Gerlitz wrote:
[snip]
>> Highlights:
>>   There could be many missing/mistakes/misunderstanding, please don't
>>   be hesitate to point out the issues, any suggestions to improve or
>>   complete the description are very welcomed ;-)
> 
> Michael, none of what you wrote above belongs to the change-log which
> is going to stay for-ever in the upstream git repo. You should put it
> all belong the --- line after your S.O.B and add proper change log
> telling what this patch is about

Thanks for point out this for me :-)

I'll put the highlights and changelog under '---' in next version, is it
looks like this?


Subject: [PATCH RFC v3] Documentation/infiniband: Add docs for rdma-helpers

This is the following patch for:
  https://lkml.org/lkml/2015/5/5/417
which try to document the settled rdma_cap_XX().

Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
Highlights:
  There could be many missing/mistakes/misunderstanding, please don't
  be hesitate to point out the issues, any suggestions to improve or
  complete the description are very welcomed ;-)

v2:
  * Merge the descriptions from Doug:
    http://www.spinics.net/lists/linux-rdma/msg25172.html

v3:
  ...

 Documentation/infiniband/rdma_helpers.txt | 79 +++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)
 create mode 100644 Documentation/infiniband/rdma_helpers.txt

diff --git a/Documentation/infiniband/rdma_helpers.txt b/Documentation/infiniband/rdma_helpers.txt
new file mode 100644
index 0000000..be9416d
--- /dev/null
+++ b/Documentation/infiniband/rdma_helpers.txt

Regards,
Michael Wang

> 
>>
>> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
>> ---
>>  Documentation/infiniband/rdma_helpers.txt | 79 +++++++++++++++++++++++++++++++
>>  1 file changed, 79 insertions(+)
>>  create mode 100644 Documentation/infiniband/rdma_helpers.txt
>>
>> diff --git a/Documentation/infiniband/rdma_helpers.txt b/Documentation/infiniband/rdma_helpers.txt
>> new file mode 100644
>> index 0000000..be9416d
>> --- /dev/null
>> +++ b/Documentation/infiniband/rdma_helpers.txt
>> @@ -0,0 +1,79 @@
>> +RDMA HELPERS
>> +
>> +  The following helpers are used to check the specific capabilities of a
>> +  particular port before utilizing those capabilities.
>> +
>> +    rdma_cap_ib_mad            - Infiniband Management Datagrams.
>> +    rdma_cap_ib_smi            - Infiniband Subnet Management Interface.
>> +    rdma_cap_ib_cm             - Infiniband Communication Manager.
>> +    rdma_cap_iw_cm             - IWARP Communication Manager.
>> +    rdma_cap_ib_sa             - Infiniband Subnet Administration.
>> +    rdma_cap_ib_mcast          - Infiniband Multicast Join/Leave Protocol.
>> +    rdma_cap_read_multi_sge    - RDMA Read Work Request Support Multiple SGE.
>> +    rdma_cap_af_ib             - Native Infiniband Address.
>> +    rdma_cap_eth_ah            - InfiniBand Transport With Ethernet Address.
>> +
>> +USAGE
>> +
>> +  if (rdma_cap_XX(device, i)) {
>> +       /* The port i of device support XX */
>> +       ...
>> +  } else {
>> +       /* The port i of device don't support XX */
>> +       ...
>> +  }
>> +
>> +  rdma_cap_ib_mad
>> +  ---------------
>> +    Management Datagrams (MAD) are a required part of the InfiniBand
>> +    specification and are supported on all InfiniBand devices.  A slightly
>> +    extended version are also supported on OPA interfaces.
>> +
>> +  rdma_cap_ib_smi
>> +  ---------------
>> +    Subnet Management Interface (SMI) will handle SMP packet from SM
>> +    in an infiniband fabric.
>> +
>> +  rdma_cap_ib_cm
>> +  ---------------
>> +    Communication Manager (CM) service, used to ease the process of connecting
>> +    to a remote host.  The IB-CM can be used to connect to remote hosts using
>> +    either InfiniBand or RoCE connections, iWARP has its own CM.
>> +
>> +  rdma_cap_iw_cm
>> +  ---------------
>> +    iWARP Communication Manager (CM), Similar to the IB-CM, but only used on
>> +    iWARP devices.
>> +
>> +  rdma_cap_ib_sa
>> +  ---------------
>> +    Subnet Administration (SA) is the database built by SM in an
>> +    infiniband fabric.
>> +
>> +  rdma_cap_ib_mcast
>> +  ---------------
>> +    InfiniBand (and OPA) use a different multicast mechanism rather than
>> +    traditional IP multicast found on Ethernet devices.  If this is true, then
>> +    traditional IPv4/IPv6 multicast is handled by the IPoIB layer and direct
>> +    multicast joins and leaves are handled per the InfiniBand specifications.
>> +
>> +  rdma_cap_read_multi_sge
>> +  ---------------
>> +    Certain devices (iWARP in particular) have restrictions on the number of
>> +    scatter gather elements that can be present in an RDMA READ work request,
>> +    this is true if the device does not have that restriction.
>> +
>> +  rdma_cap_af_ib
>> +  ---------------
>> +    Many code paths for traditional InfiniBand and RoCE links are the same,
>> +    but need minor differences to accommodate the different addresses on the
>> +    two types of connections.  This helper is true when the address of the
>> +    specific connection is of the InfiniBand native variety.
>> +
>> +  rdma_cap_eth_ah
>> +  ---------------
>> +    Queue Pair is InfiniBand transport, but uses Ethernet address instead
>> +    of native InfiniBand address (aka, this is a RoCE QP, and that means
>> +    ethertype 0x8915 + GRH for RoCEv1 and IP/UDP to well known UDP port for
>> +    RoCEv2), this is true when the address family of the specific queue pair
>> +    is of the Ethernet (RoCE) variety.
>> --
>> 2.1.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
