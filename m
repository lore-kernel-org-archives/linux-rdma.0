From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Tue, 19 Dec 2017 15:53:38 -0600
Message-ID: <017b01d37913$d36afce0$7a40f6a0$@opengridcomputing.com>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com> <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me> <018901d36d17$6a703410$3f509c30$@opengridcomputing.com> <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: 
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Sagi Grimberg' <sagi@grimberg.me>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
> Do you have any thoughts on debugging this?  Turning on isert debug is bad
> because the IO load is very high.  I sort of need something that I can do after it
> gets stuck.  So I can change the wait_for_completion() to a
> wait_for_completion_timeout() and if it times out, go figure out what it is stuck
> on.

This snipit from isert_put_cmd() looks interesting:

...
                        /*
                         * Check for special case during comp_err where
                         * WRITE_PENDING has been handed off from core,
                         * but requires an extra target_put_sess_cmd()
                         * before transport_generic_free_cmd() below.
                         */
                        if (comp_err &&
                            cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
                                struct se_cmd *se_cmd = &cmd->se_cmd;

                                target_put_sess_cmd(se_cmd);
                        }
...


---
This email has been checked for viruses by AVG.
http://www.avg.com
