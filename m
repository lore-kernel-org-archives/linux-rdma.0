From: Paul Bolle <pebolle@tiscali.nl>
Subject: infiniband: cxgb4: GCC warnings for 32 bit
Date: Tue, 05 Feb 2013 11:15:58 +0100
Message-ID: <1360059358.1343.37.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

0) Compiling cm.o for 32 bit triggers these GCC warnings:
    drivers/infiniband/hw/cxgb4/cm.c: In function =E2=80=98passive_ofld=
_conn_reply=E2=80=99:
    drivers/infiniband/hw/cxgb4/cm.c:2803:12: warning: cast to pointer =
from integer of different size [-Wint-to-pointer-cast]
    drivers/infiniband/hw/cxgb4/cm.c: In function =E2=80=98send_fw_pass=
_open_req=E2=80=99:
    drivers/infiniband/hw/cxgb4/cm.c:2941:16: warning: cast from pointe=
r to integer of different size [-Wpointer-to-int-cast]
    [last line repeated a number of times]

1) These two lines were added in commit
1cab775c3e75f1250c965feafd061d696df36e53 ("RDMA/cxgb4: Fix LE hash
collision bug for passive open connection"). That commit was first
released in v3.8-rc1. It's not obvious to me how to fix these warnings,
since these lines are a bit puzzling.

2) These lines read:
   rpl_skb =3D (struct sk_buff *)cpu_to_be64(req->cookie);

and:
   req->cookie =3D cpu_to_be64((u64)skb);

3) It is odd that both use cpu_to_be64(). It seems the first one should
have been be64_to_cpu().

But 'cookie' is of type __u64 (see struct
cpl_fw6_msg_ofld_connection_wr_rpl in
drivers/net/ethernet/chelsio/cxgb4/t4_msg.h). So the use of both that
type and the cpu_to_be64() macro looks a bit odd too.

And why is 'cookie' __u64? Is struct cpl_fw6_msg_ofld_connection_wr_rpl
used in userspace code? Can't 'cookie' be of type "struct sk_buff *"? I=
s
there a requirement for it to be 64 bits wide on both 32 bit and 64 bit=
?


Paul Bolle
