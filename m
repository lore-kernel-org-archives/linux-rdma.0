From: Dag Moxnes <dag.moxnes@oracle.com>
Subject: Re: [PATCH 1/1] Revert "rds: ib: add error handle"
Date: Tue, 24 Apr 2018 13:25:08 +0200
Message-ID: <373de57c-4cab-0d04-0021-57b566cefe0d@oracle.com>
References: <1524533941-4072-1-git-send-email-yanjun.zhu@oracle.com>
 <4e17b3f0-94b4-6038-419d-68657027f331@oracle.com>
 <66130D36-2987-416A-AF31-2BB9001E0036@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------DA4DDDE500B379E4755D8A94"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <66130D36-2987-416A-AF31-2BB9001E0036@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>, OFED mailing list <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com, davem@davemloft.net, netdev@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------DA4DDDE500B379E4755D8A94
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

I was going to suggest the following correction:


If all agree that this is the correct way of doing it, I can go ahead 
and an post it.

Regards,

-Dag


On 04/24/2018 01:10 PM, Håkon Bugge wrote:
>
>> On 24 Apr 2018, at 05:27, santosh.shilimkar@oracle.com wrote:
>>
>> On 4/23/18 6:39 PM, Zhu Yanjun wrote:
>>> This reverts commit 3b12f73a5c2977153f28a224392fd4729b50d1dc.
>>> After long time discussion and investigations, it seems that there
>>> is no mem leak. So this patch is reverted.
>>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>>> ---
>> Well your fix was not for any leaks but just proper labels for
>> graceful exits. I don't know which long time discussion
>> you are referring but there is no need to revert this change
>> unless you see any issue with your change.
> As spotted by Dax Moxnes, the patch misses to call rds_ib_dev_put() when exiting normally, only on err exit.
>
>
> Thxs, Håkon
>
>> Regards,
>> Santosh
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------DA4DDDE500B379E4755D8A94
Content-Type: text/x-patch;
 name="0001-rds-ib-Fix-missing-call-to-rds_ib_dev_put-in-rds_ib_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-rds-ib-Fix-missing-call-to-rds_ib_dev_put-in-rds_ib_.pa";
 filename*1="tch"

>From 9d8e7c568485b1b10ccdfa02305c6fa284f42d8f Mon Sep 17 00:00:00 2001
From: Dag Moxnes <dag.moxnes@oracle.com>
Date: Tue, 24 Apr 2018 13:14:48 +0200
Subject: [PATCH] rds: ib: Fix missing call to rds_ib_dev_put in rds_ib_setup_qp

The function rds_ib_setup_qp is calling rds_ib_get_client_data and
should correspondingly call rds_ib_dev_put.  This call was lost in
the non-error path with the introduction of error handling done in
commit 3b12f73a5c2977153f28a224392fd4729b50d1dc.

Signed-off-by: Dag Moxnes <dag.moxnes@oracle.com>
---
 net/rds/ib_cm.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index eea1d86..3193249 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -547,7 +547,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	rdsdebug("conn %p pd %p cq %p %p\n", conn, ic->i_pd,
 		 ic->i_send_cq, ic->i_recv_cq);
 
-	return ret;
+	goto out:
 
 sends_out:
 	vfree(ic->i_sends);
@@ -572,6 +572,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		ic->i_send_cq = NULL;
 rds_ibdev_out:
 	rds_ib_remove_conn(rds_ibdev, conn);
+out:
 	rds_ib_dev_put(rds_ibdev);
 
 	return ret;
-- 
1.7.1


--------------DA4DDDE500B379E4755D8A94--
