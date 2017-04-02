From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: fc access control issue
Date: Sun, 02 Apr 2017 14:37:32 -0700
Message-ID: <1491169052.8846.12.camel@haakon3.risingtidesystems.com>
References: <6F7556A181C9E74390FFFEACC41B5ABB4C85A0F2@MX301CL01.corp.emc.com>
         <1490079761.8236.94.camel@haakon3.risingtidesystems.com>
         <6F7556A181C9E74390FFFEACC41B5ABB4C85A7D4@MX301CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6F7556A181C9E74390FFFEACC41B5ABB4C85A7D4@MX301CL01.corp.emc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Lv, Shuo" <Shuo.Lv@dell.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shuo,

On Sat, 2017-03-25 at 09:58 +0000, Lv, Shuo wrote:
> Hi, In LIO FC target, has  the Access and devices visibility
> management (LUN masking) function been implemented? Access and devices
> visibility management allows for an initiator or
> group of initiators to see different devices with different LUNs with
> necessary access permissions. If have not, do we have any plans?
> 

The NodeACLs + MappedLUNs logic as-is allow for different initiators to
see different LUN masking views on the same storage endpoint.

Eg, a single FC WWPN and it's default LUN layout under configfs
/sys/kernel/config/target/qla2xxx/$WWPN/$TPGT/lun/$LUN_ID/ can appear to
each $HOST_WWPN with any arbitrary mapping under
/sys/kernel/config/target/qla2xxx/$WWPN/$TPGT/acls/$HOST_WWPN/$LUN_ID/
