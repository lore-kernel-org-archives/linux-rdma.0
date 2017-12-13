From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Wed, 13 Dec 2017 16:34:24 -0600
Message-ID: <01c701d37462$87371f30$95a55d90$@opengridcomputing.com>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me> <01bd01d3745a$f4bc82f0$de3588d0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <01bd01d3745a$f4bc82f0$de3588d0$@opengridcomputing.com>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> > > [239800.115739] target_wait_for_sess_cmds: Waiting for se_cmd:
> > ffff88034082c998 t_state: 6, fabric state: 12
> >
> > Hmm, this means that the command was delegated to isert to send
> > data+response... Which means we lose a reference put somewhere here.
> >
> > I'm assuming that this happens before your changes to ib_drain_qp
> > correct? If this does not happen without your changes it might indicate
> > that drain_qp is missing an error (or successful?) completion which
> > would prevent a final reference drop (isert_completion_put).
> 
> Hey Sagi, I'm trying to reproduce this on CX4 cards with mlx5.  I have the two
> nodes setup via RoCEv2 and rping works over mlx5 fine, but when I try to
> discover the iSER targets, the initiator fails with:
> 
> [root@potato1 ~]# iscsiadm -m discovery -t sendtargets -p 172.16.99.239:3260
> -I iser
> iscsiadm: recv's end state machine bug?
> iscsiadm: Could not perform SendTargets discovery: iSCSI PDU timed out
> [root@potato1 ~]# uname -r
> 4.15.0-rc3+
> 
> And the target logs this:
> 
> [  873.240460] mlx5_0:dump_cqe:277:(pid 494): dump error cqe
> [  873.246665] 00000000 00000000 00000000 00000000
> [  873.251942] 00000000 00000000 00000000 00000000
> [  873.257214] 00000000 00000000 00000000 00000000
> [  873.262472] 00000000 00008a12 0a0000f6 00014bd2
> [  873.267711] isert: isert_print_wc: send failure: invalid request error (9)
> vend_err 8a
> 
> Any ideas?  I'm using straight 4.15.0-rc3 + a workaround to avoid crashing my
> x86 systems at bootup from here:
> 
> https://www.mail-archive.com/netdev@vger.kernel.org/msg203210.html'
> 

I tried with 4.14.0 and got the same results.  I then backed up to 4.9.44 and I can discovery/login again.  I'll see if I can bisect this out, unless somebody knows about current problems with iser?




---
This email has been checked for viruses by AVG.
http://www.avg.com
