From: Max Gurtovoy <maxg@mellanox.com>
Subject: Re: stuck iscsi/iser target with linux-4.15.0-rc1
Date: Mon, 18 Dec 2017 18:32:44 +0200
Message-ID: <cbe1b731-8e37-884a-1406-6a7ca1f6a0be@mellanox.com>
References: <000801d36ac6$9e9f5f70$dbde1e50$@opengridcomputing.com>
 <0ba7e891-f020-26fb-9945-9e824332593c@grimberg.me>
 <018901d36d17$6a703410$3f509c30$@opengridcomputing.com>
 <1dee9f68-a81b-b7b8-9e70-e0ef5c63c520@grimberg.me>
 <01bd01d3745a$f4bc82f0$de3588d0$@opengridcomputing.com>
 <01c701d37462$87371f30$95a55d90$@opengridcomputing.com>
 <01c901d37462$be431240$3ac936c0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <01c901d37462$be431240$3ac936c0$@opengridcomputing.com>
Content-Language: he
Sender: target-devel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Sagi Grimberg' <sagi@grimberg.me>, 'target-devel' <target-devel@vger.kernel.org>
Cc: linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

hi Steve,

On 12/14/2017 12:35 AM, Steve Wise wrote:
>>
>> I tried with 4.14.0 and got the same results.  I then backed up to 4.9.44 and I can
>> discovery/login again.  I'll see if I can bisect this out, unless somebody knows
>> about current problems with iser?
> 
> Actually, 4.9.44 has the same issue.  It works with iscsi/tcp, not iser. I must be doing something wrong in my setup.

can you run "targetcli ls" on your target side ?
also "iscsiadm -V" on the initiator side ?
can you try running with ib link layer ?

I'll try to find similar setup to repro in our labs.

> 
> 
> ---
> This email has been checked for viruses by AVG.
> https://emea01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.avg.com&data=02%7C01%7Cmaxg%40mellanox.com%7C30b666b3fb324c3e678608d54279df3e%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636488013569543438&sdata=w2S1quZYnMQmzXuQJuRvdEJBvyCGQ9Fbm6MGOrRD6Pw%3D&reserved=0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://emea01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fvger.kernel.org%2Fmajordomo-info.html&data=02%7C01%7Cmaxg%40mellanox.com%7C30b666b3fb324c3e678608d54279df3e%7Ca652971c7d2e4d9ba6a4d149256f461b%7C0%7C0%7C636488013569543438&sdata=cf3SNf3pqSvPKz4xkQSzUS8r4I3AY7%2Bj5EYmI5khDP4%3D&reserved=0
> 
