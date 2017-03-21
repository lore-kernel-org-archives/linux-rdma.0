From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: fc access control issue
Date: Tue, 21 Mar 2017 00:02:41 -0700
Message-ID: <1490079761.8236.94.camel@haakon3.risingtidesystems.com>
References: <6F7556A181C9E74390FFFEACC41B5ABB4C85A0F2@MX301CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <6F7556A181C9E74390FFFEACC41B5ABB4C85A0F2@MX301CL01.corp.emc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Lv, Shuo" <Shuo.Lv@dell.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shuo,

On Tue, 2017-03-21 at 00:41 +0000, Lv, Shuo wrote:
> Hi,
>       When I use tcm_qla2xxx target, I found that the granularity for
> the FC access control  is very large and it is target-level. The LUNS
> in the target could be all accessed by initiator or the LUNS in the
> target could not be accessed by initiator. I don't know If the
> tcm_qla2xxx could create multiple targets for the same port?

Multiple targets per port is accomplished with a FC switch feature
called N_Port ID Virtualization (NPIV).

This allows multiple virtual WWPNs to be configured on a single physical
FC port, each with it's LIO target configfs namespace residing
under /sys/kernel/config/target/qla2xxx_npiv/$NPIV_WWPN/, et al.

Support for tcm_qla2xxx/NPIV was added in mainline v4.1 here:

https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg25618.html

and although information is pretty scarce how to actually use
tcm_qla2xxx/NPIV, there was some discussion back in 2015 about how it
currently works from an end-user perspective here:

https://lists.fedorahosted.org/pipermail/targetcli-fb-devel/2015-May/000157.html

> Could we implement the group level access  control? Like a group in a
> target could be access by a initiator, another group in the same
> target could be access by other initiator?   Any suggestion is
> welcome.
> 

I assume you mean a initiator access group abstraction, eg: where a
initiator group is associated with a specific target endpoint, and all
initiators associated with the group have ACLs added to the endpoint.

targetcli itself doesn't support initiator access groups, but there are
multiple vendors who have built initiator access group constructs into
their products atop python-rtslib, using vanilla LIO kernel code.
