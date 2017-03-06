From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Fwd: mlx5_ib_post_send panic on s390x
Date: Mon, 6 Mar 2017 14:03:00 +0100
Message-ID: <491cf3e1-b2f8-3695-ecd4-3d34b0ae9e25@linux.vnet.ibm.com>
References: <56246ac0-a706-291c-7baa-a6dd2c6331cd@linux.vnet.ibm.com>
 <dcc90daa-b932-8957-d8bc-e1f02d04e03a@linux.vnet.ibm.com>
 <20e4f31e-b2a7-89fb-d4c0-583c0dc1efb6@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20e4f31e-b2a7-89fb-d4c0-583c0dc1efb6-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Matan Barak (External)" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Saeed Mahameed (saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org)" <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 02/26/2017 10:45 AM, Matan Barak (External) wrote:
> On 24/02/2017 12:27, Ursula Braun wrote:
>> sorry, typo in the mail address.
>>
>> -------- Forwarded Message --------
>> Subject: mlx5_ib_post_send panic on s390x
>> Date: Fri, 24 Feb 2017 10:51:32 +0100
>> From: Ursula Braun <ubraun-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>> To: matamb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
>> CC: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>
>> Hi Saeed and Matan,
>>
>> up to now I run SMC-R traffic on Connect X3, which works.
>> But when switching to Connect X4, the first mlx5_ib_post_send() fails:
>>
>> [  247.787660] Unable to handle kernel pointer dereference in virtual kernel address space
>> [  247.787662] Failing address: 000000010484a000 TEID: 000000010484a803
>> [  247.787664] Fault in home space mode while using kernel ASCE.
>> [  247.787667] AS:00000000011ec007 R3:0000000000000024
>> [  247.787701] Oops: 003b ilc:2 [#1] PREEMPT SMP
>> [  247.787704] Modules linked in: smc_diag smc xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc ip6table_filter ip6_tables iptable_filter rpcrdma rdma_ucm ib_ucm ib_uverbs rdma_cm configfs ib_cm iw_cm mlx5_ib ib_core mlx5_core xts gf128mul cbc ecb aes_s390 des_s390 des_generic ptp sha512_s390 pps_core sha256_s390 sha1_s390 sha_common eadm_sch nfsd auth_rpcgss oid_registry nfs_acl lockd vhost_net tun grace vhost sunrpc macvtap sch_fq_codel macvlan dm_multipath kvm dm_mod ip_tables x_tables autofs4
>> [  247.787738] CPU: 0 PID: 10498 Comm: kworker/0:3 Tainted: G        W       4.10.0uschi+ #4
>> [  247.787739] Hardware name: IBM              2964 N96              704              (LPAR)
>> [  247.787743] Workqueue: events smc_listen_work [smc]
>> [  247.787745] task: 00000000b4148008 task.stack: 0000000099c2c000
>> [  247.787746] Krnl PSW : 0404c00180000000 0000000000762412 (memcpy+0x22/0x48)
>> [  247.787751]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
>> [  247.787753] Krnl GPRS: 0000000000a7a100 0000000099c96414 0000000099c96414 000000010484afc8
>> [  247.787755]            000000000000002b 000000000076242e 000000000000002c 0000000099c96440
>> [  247.787757]            000000010484afc8 000000000000002c 0000000099c96414 0000000000000001
>> [  247.787758]            00000000ae8a75d0 000003ff8108aa50 000003ff8107cde6 0000000099c2fa38
>> [  247.787764] Krnl Code: 0000000000762404: b9040012        lgr    %r1,%r2
>>                           0000000000762408: a7740008        brc    7,762418
>>                          #000000000076240c: c05000000011    larl    %r5,76242e
>>                          >0000000000762412: 44405000        ex    %r4,0(%r5)
>>                           0000000000762416: 07fe        bcr    15,%r14
>>                           0000000000762418: d2ff10003000    mvc    0(256,%r1),0(%r3)
>>                           000000000076241e: 41101100        la    %r1,256(%r1)
>>                           0000000000762422: 41303100        la    %r3,256(%r3)
>> [  247.787780] Call Trace:
>> [  247.787785] ([<000003ff8107cdd4>] mlx5_ib_post_send+0x139c/0x1810 [mlx5_ib])
>> [  247.787789]  [<000003ff8047999a>] smc_wr_tx_send+0xd2/0x100 [smc]
>> [  247.787792]  [<000003ff8047a97a>] smc_llc_send_confirm_link+0x9a/0xd0 [smc]
>> [  247.787794]  [<000003ff804751ee>] smc_listen_work+0x24e/0x4e0 [smc]
>> [  247.787797]  [<00000000001659e8>] process_one_work+0x3d8/0x780
>> [  247.787799]  [<0000000000166044>] worker_thread+0x2b4/0x478
>> [  247.787801]  [<000000000016e62c>] kthread+0x15c/0x170
>> [  247.787803]  [<0000000000a115f2>] kernel_thread_starter+0x6/0xc
>> [  247.787804]  [<0000000000a115ec>] kernel_thread_starter+0x0/0xc
>> [  247.787806] INFO: lockdep is turned off.
>> [  247.787807] Last Breaking-Event-Address:
>> [  247.787811]  [<000003ff8106edc0>] 0x3ff8106edc0
>> [  247.787813]
>> [  247.787814] Kernel panic - not syncing: Fatal exception: panic_on_oops
>>
>> The problem seems to be caused by the usage of plain memcpy in set_data_inl_seg().
>> The address provided by SMC-code in struct ib_send_wr *wr is an address belonging to
>> an area mapped with the ib_dma_map_single() call. On s390x those kind of addresses
>> require extra access functions (see arch/s390/include/asm/io.h).
>>
> 
> So I guess memcpy_toio is required here, right?
> Since we don't have a s390 based system, could you please test this?
memcpy_toio() did not help. Then I replaced the memcpy-calls in set_data_inl_seg()
by this preliminary test code (just to give an idea, not a real patch proposal):

static void *memcpy_usc(void *dest, const void *src, size_t count)
{
        char *tmp_dest = (char *)dest;
        char *tmp_src = (char *)src;
        int copied = 0;
        u32 tmp_u32;

        while (copied < count) {
                tmp_u32 = __raw_readl(tmp_src);
                __raw_writel(tmp_u32, tmp_dest);
                copied += sizeof(tmp_u32);
                tmp_dest += sizeof(tmp_u32);
                tmp_src += sizeof(tmp_u32);
        }
        return dest;
}

This helped; the first mlx5_ib_post_send code initiated from SMC-code (type IB_WR_SEND,
flagged with IB_SEND_INLINE, length 44 bytes) run successful.

A following mlx5_ib_post_send call of type RDMA_WRITE seems to stall later on, but
this is something I have to analyze in more detail.

> 
>> Kind regards, Ursula Braun (IBM Germany)
>>
> 
> Thanks for notifying.
> 
> Matan
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
