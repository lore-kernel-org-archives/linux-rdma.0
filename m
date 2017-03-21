From: "Lv, Shuo" <Shuo.Lv@dell.com>
Subject: fc access control issue
Date: Tue, 21 Mar 2017 00:41:03 +0000
Message-ID: <6F7556A181C9E74390FFFEACC41B5ABB4C85A0F2@MX301CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hi,
      When I use tcm_qla2xxx target, I found that the granularity for the F=
C access control  is very large and it is target-level. The LUNS in the tar=
get could be all accessed by initiator or the LUNS in the target could not =
be accessed by initiator. I don't know If the tcm_qla2xxx could create mult=
iple targets for the same port? Could we implement the group level access  =
control? Like a group in a target could be access by a initiator, another g=
roup in the same target could be access by other initiator?   Any suggestio=
n is welcome.

Regards
Shuo
