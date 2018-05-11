From: Yanjun Zhu <yanjun.zhu@oracle.com>
Subject: Re: [rds-devel] KASAN: null-ptr-deref Read in rds_ib_get_mr
Date: Fri, 11 May 2018 22:07:45 +0800
Message-ID: <7ee8589c-97ab-6843-3095-f735040b6f13@oracle.com>
References: <20180511052056.GA10547@dragonet.kaist.ac.kr>
 <fa3461d4-8872-48af-9b67-be0affd16bbd@oracle.com>
 <20180511104630.GD14952@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180511104630.GD14952@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: DaeRyong Jeong <threeearcat@gmail.com>, santosh.shilimkar@oracle.com, davem@davemloft.net, rds-devel@oss.oracle.com, kt0755@gmail.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, byoungyoung@purdue.edu
List-Id: linux-rdma@vger.kernel.org



On 2018/5/11 18:46, Sowmini Varadhan wrote:
> On (05/11/18 15:48), Yanjun Zhu wrote:
>> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
>> index e678699..2228b50 100644
>> --- a/net/rds/ib_rdma.c
>> +++ b/net/rds/ib_rdma.c
>> @@ -539,11 +539,17 @@ void rds_ib_flush_mrs(void)
>>     void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
>>                                          struct rds_sock *rs, u32 *key_ret)
>>     {
>> -             struct rds_ib_device *rds_ibdev;
>> +             struct rds_ib_device *rds_ibdev = NULL;
>>                  struct rds_ib_mr *ibmr = NULL;
>> -             struct rds_ib_connection *ic = rs->rs_conn->c_transport_data;
>> +             struct rds_ib_connection *ic = NULL;
>>                  int ret;
>>
>> +             if (rs->rs_bound_addr == 0) {
>> +                             ret = -EPERM;
>> +                             goto out;
>> +             }
>> +
>> +             ic = rs->rs_conn->c_transport_data;
>>                  rds_ibdev = rds_ib_get_device(rs->rs_bound_addr);
>>                  if (!rds_ibdev) {
>>                                  ret = -ENODEV;
>>
>> I made this raw patch. If you can reproduce this bug, please make tests
>> with it.
> I dont think this solves the problem, I think it
> just changes the timing under which it can still happen.
>
> what if the rds_remove_bound() in rds_bind() happens after the check
> for if (rs->rs_bound_addr == 0) added above by the patch
>
> I believe you need some type of synchronization (either
> through mutex, or some atomic flag in the rs or similar) to make
> sure rds_bind() and rds_ib_get_mr() are mutually exclusive.
Sure. I agree with you. Maybe mutex is a good choice.

Zhu Yanjun
>
> --Sowmini
>   
>
>
