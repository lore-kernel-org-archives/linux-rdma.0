From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Mon, 4 Dec 2017 20:40:31 +0200
Message-ID: <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
 <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me>
 <018901d36d17$6a703410$3f509c30$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <018901d36d17$6a703410$3f509c30$@opengridcomputing.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


>> Not for a while, can you turn the debug prints in
>> target_wait_for_sess_cmds so we can understand which commands are
>> hanging?
> 
> Here ya go:
> 
> [239800.115739] target_wait_for_sess_cmds: Waiting for se_cmd: ffff88034082c998 t_state: 6, fabric state: 12

Hmm, this means that the command was delegated to isert to send
data+response... Which means we lose a reference put somewhere here.

I'm assuming that this happens before your changes to ib_drain_qp
correct? If this does not happen without your changes it might indicate
that drain_qp is missing an error (or successful?) completion which
would prevent a final reference drop (isert_completion_put).
