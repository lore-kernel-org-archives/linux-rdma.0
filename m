From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: Re: [PATCH 1/1] Revert "rds: ib: add error handle"
Date: Tue, 24 Apr 2018 13:10:24 +0200
Message-ID: <66130D36-2987-416A-AF31-2BB9001E0036@oracle.com>
References: <1524533941-4072-1-git-send-email-yanjun.zhu@oracle.com>
 <4e17b3f0-94b4-6038-419d-68657027f331@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 11.3 \(3445.6.18\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <4e17b3f0-94b4-6038-419d-68657027f331@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: Zhu Yanjun <yanjun.zhu@oracle.com>, OFED mailing list <linux-rdma@vger.kernel.org>, rds-devel@oss.oracle.com, davem@davemloft.net, netdev@vger.kernel.org, Dag Moxnes <dag.moxnes@oracle.com>
List-Id: linux-rdma@vger.kernel.org



> On 24 Apr 2018, at 05:27, santosh.shilimkar@oracle.com wrote:
>=20
> On 4/23/18 6:39 PM, Zhu Yanjun wrote:
>> This reverts commit 3b12f73a5c2977153f28a224392fd4729b50d1dc.
>> After long time discussion and investigations, it seems that there
>> is no mem leak. So this patch is reverted.
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
>> ---
> Well your fix was not for any leaks but just proper labels for
> graceful exits. I don't know which long time discussion
> you are referring but there is no need to revert this change
> unless you see any issue with your change.

As spotted by Dax Moxnes, the patch misses to call rds_ib_dev_put() when =
exiting normally, only on err exit.


Thxs, H=C3=A5kon

>=20
> Regards,
> Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
