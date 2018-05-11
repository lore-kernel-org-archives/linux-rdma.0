From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: null-ptr-deref Read in rds_ib_get_mr
Date: Fri, 11 May 2018 09:58:54 -0700
Message-ID: <86dab6f3-aa60-699f-da77-581359a6475f@oracle.com>
References: <20180511052056.GA10547@dragonet.kaist.ac.kr>
 <fa3461d4-8872-48af-9b67-be0affd16bbd@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <fa3461d4-8872-48af-9b67-be0affd16bbd@oracle.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Yanjun Zhu <yanjun.zhu@oracle.com>, DaeRyong Jeong <threeearcat@gmail.com>, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org, byoungyoung@purdue.edu, kt0755@gmail.com
List-Id: linux-rdma@vger.kernel.org

On 5/11/2018 12:48 AM, Yanjun Zhu wrote:
> 
> 
> On 2018/5/11 13:20, DaeRyong Jeong wrote:
>> We report the crash: KASAN: null-ptr-deref Read in rds_ib_get_mr
>>
>> Note that this bug is previously reported by syzkaller.
>> https://syzkaller.appspot.com/bug?id=0bb56a5a48b000b52aa2b0d8dd20b1f545214d91 
>>
>> Nonetheless, this bug has not fixed yet, and we hope that this report 
>> and our
>> analysis, which gets help by the RaceFuzzer's feature, will helpful to 
>> fix the
>> crash.
>>
>> This crash has been found in v4.17-rc1 using RaceFuzzer (a modified
>> version of Syzkaller), which we describe more at the end of this
>> report. Our analysis shows that the race occurs when invoking two
>> syscalls concurrently, bind$rds and setsockopt$RDS_GET_MR.
>>
>>
>> Analysis:
>> We think the concurrent execution of __rds_rdma_map() and rds_bind()
>> causes the problem. __rds_rdma_map() checks whether rs->rs_bound_addr 
>> is 0
>> or not. But the concurrent execution with rds_bind() can by-pass this
>> check. Therefore, __rds_rdmap_map() calls rs->rs_transport->get_mr() and
>> rds_ib_get_mr() causes the null deref at ib_rdma.c:544 in v4.17-rc1, when
>> dereferencing rs_conn.
>>
>>
>> Thread interleaving:
>> CPU0 (__rds_rdma_map)                    CPU1 (rds_bind)
>>                             // rds_add_bound() sets rs->bound_addr as 
>> none 0
>>                             ret = rds_add_bound(rs, 
>> sin->sin_addr.s_addr, &sin->sin_port);
>> if (rs->rs_bound_addr == 0 || !rs->rs_transport) {
>>     ret = -ENOTCONN; /* XXX not a great errno */
>>     goto out;
>> }
>>                             if (rs->rs_transport) { /* previously 
>> bound */
>>                                 trans = rs->rs_transport;
>>                                 if 
>> (trans->laddr_check(sock_net(sock->sk),
>>                                                sin->sin_addr.s_addr) 
>> != 0) {
>>                                     ret = -ENOPROTOOPT;
>>                                     // rds_remove_bound() sets 
>> rs->bound_addr as 0
>>                                     rds_remove_bound(rs);
>> ...
>> trans_private = rs->rs_transport->get_mr(sg, nents, rs,
>>                      &mr->r_key);
>> (in rds_ib_get_mr())
>> struct rds_ib_connection *ic = rs->rs_conn->c_transport_data;
>>
>>
>> Call sequence (v4.17-rc1):
>> CPU0
>> rds_setsockopt
>>     rds_get_mr
>>         __rds_rdma_map
>>             rds_ib_get_mr
>>
>>
>> CPU1
>> rds_bind
>>     rds_add_bound
>>     ...
>>     rds_remove_bound
>>
>>
>> Crash log:
>> ==================================================================
>> BUG: KASAN: null-ptr-deref in rds_ib_get_mr+0x3a/0x150 
>> net/rds/ib_rdma.c:544
>> Read of size 8 at addr 0000000000000068 by task syz-executor0/32067
>>
>> CPU: 0 PID: 32067 Comm: syz-executor0 Not tainted 4.17.0-rc1 #1
>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 
>> rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x166/0x21c lib/dump_stack.c:113
>>   kasan_report_error mm/kasan/report.c:352 [inline]
>>   kasan_report+0x140/0x360 mm/kasan/report.c:412
>>   check_memory_region_inline mm/kasan/kasan.c:260 [inline]
>>   __asan_load8+0x54/0x90 mm/kasan/kasan.c:699
>>   rds_ib_get_mr+0x3a/0x150 net/rds/ib_rdma.c:544
>>   __rds_rdma_map+0x521/0x9d0 net/rds/rdma.c:271
>>   rds_get_mr+0xad/0xf0 net/rds/rdma.c:333
>>   rds_setsockopt+0x57f/0x720 net/rds/af_rds.c:347
>>   __sys_setsockopt+0x147/0x230 net/socket.c:1903
>>   __do_sys_setsockopt net/socket.c:1914 [inline]
>>   __se_sys_setsockopt net/socket.c:1911 [inline]
>>   __x64_sys_setsockopt+0x67/0x80 net/socket.c:1911
>>   do_syscall_64+0x15f/0x4a0 arch/x86/entry/common.c:287
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x4563f9
>> RSP: 002b:00007f6a2b3c2b28 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
>> RAX: ffffffffffffffda RBX: 000000000072bee0 RCX: 00000000004563f9
>> RDX: 0000000000000002 RSI: 0000000000000114 RDI: 0000000000000015
>> RBP: 0000000000000575 R08: 0000000000000020 R09: 0000000000000000
>> R10: 0000000020000140 R11: 0000000000000246 R12: 00007f6a2b3c36d4
>> R13: 00000000ffffffff R14: 00000000006fd398 R15: 0000000000000000
>> ==================================================================
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index e678699..2228b50 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -539,11 +539,17 @@ void rds_ib_flush_mrs(void)
>   void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
>                      struct rds_sock *rs, u32 *key_ret)
>   {
> -       struct rds_ib_device *rds_ibdev;
> +       struct rds_ib_device *rds_ibdev = NULL;
>          struct rds_ib_mr *ibmr = NULL;
> -       struct rds_ib_connection *ic = rs->rs_conn->c_transport_data;
> +       struct rds_ib_connection *ic = NULL;
>          int ret;
> 
> +       if (rs->rs_bound_addr == 0) {
> +               ret = -EPERM;
> +               goto out;
> +       }
> +
No you can't return such error for this API and the
socket related checks needs to be done at core layer.
I remember fixing this race but probably never pushed
fix upstream.

The MR code is due for update with optimized FRWR code
which now stable enough. We will address this issue as
well as part of that patchset.

Thanks for looking into it.

Regards,
Santosh
