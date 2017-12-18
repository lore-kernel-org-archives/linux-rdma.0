From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Mon, 18 Dec 2017 15:43:44 -0600
Message-ID: <03bd01d37849$47497ae0$d5dc70a0$@opengridcomputing.com>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> > [239800.115739] target_wait_for_sess_cmds: Waiting for se_cmd:
> ffff88034082c998 t_state: 6, fabric state: 12
> 
> Hmm, this means that the command was delegated to isert to send
> data+response... Which means we lose a reference put somewhere here.
> 
> I'm assuming that this happens before your changes to ib_drain_qp
> correct? If this does not happen without your changes it might indicate
> that drain_qp is missing an error (or successful?) completion which
> would prevent a final reference drop (isert_completion_put).

The issue doesn't happen on 4.15-rc4 with mlx4, but it does with cxgb4.  There have been some bad problems with cxgb4's drain logic, so I need to just root cause this, because backing up to see if it used to work is problematic and will hit other issues with drain.  The qp does get drained, and I confirmed it has no pending send or recv wrs.  The associated cq's last 2 completions are from the ib_drain_qp() logic, so I need to somehow determine what completion got lost/dropped/whatever. 

Do you have any thoughts on debugging this?  Turning on isert debug is bad because the IO load is very high.  I sort of need something that I can do after it gets stuck.  So I can change the wait_for_completion() to a wait_for_completion_timeout() and if it times out, go figure out what it is stuck on.  



---
This email has been checked for viruses by AVG.
http://www.avg.com
