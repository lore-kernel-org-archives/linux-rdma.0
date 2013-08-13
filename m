From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH] IPoIB: Fix race in deleting ipoib_neigh entries
Date: Tue, 13 Aug 2013 10:11:12 +0200
Message-ID: <5209EA20.6000006@profitbricks.com>
References: <1376009062-3049-1-git-send-email-foraker1@llnl.gov> <5209E63F.8090509@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5209E63F.8090509-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/13/2013 09:54 AM, Or Gerlitz wrote:
> On 09/08/2013 03:44, Jim Foraker wrote:
>> In several places, this snippet is used when removing neigh entries:
>>
>>     list_del(&neigh->list);
>>     ipoib_neigh_free(neigh);
>>
>> The list_del() removes neigh from the associated struct ipoib_path, while
>> ipoib_neigh_free() removes neigh from the device's neigh entry lookup
>> table.  Both of these operations are protected by the priv->lock
>> spinlock.  The table however is also protected via RCU, and so naturally
>> the lock is not held when doing reads.
>>
>> This leads to a race condition, in which a thread may successfully look
>> up a neigh entry that has already been deleted from neigh->list.  Since
>> the previous deletion will have marked the entry with poison, a second
>> list_del() on the object will cause a panic:
>>
>>    #5 [ffff8802338c3c70] general_protection at ffffffff815108c5
>>       [exception RIP: list_del+16]
>>       RIP: ffffffff81289020  RSP: ffff8802338c3d20  RFLAGS: 00010082
>>       RAX: dead000000200200  RBX: ffff880433e60c88  RCX: 0000000000009e6c
>>       RDX: 0000000000000246  RSI: ffff8806012ca298  RDI: ffff880433e60c88
>>       RBP: ffff8802338c3d30   R8: ffff8806012ca2e8   R9: 00000000ffffffff
>>       R10: 0000000000000001  R11: 0000000000000000  R12: ffff8804346b2020
>>       R13: ffff88032a3e7540  R14: ffff8804346b26e0  R15: 0000000000000246
>>       ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
>>    #6 [ffff8802338c3d38] ipoib_cm_tx_handler at ffffffffa066fe0a
>> [ib_ipoib]
>>    #7 [ffff8802338c3d98] cm_process_work at ffffffffa05149a7 [ib_cm]
>>    #8 [ffff8802338c3de8] cm_work_handler at ffffffffa05161aa [ib_cm]
>>    #9 [ffff8802338c3e38] worker_thread at ffffffff81090e10
>>   #10 [ffff8802338c3ee8] kthread at ffffffff81096c66
>>   #11 [ffff8802338c3f48] kernel_thread at ffffffff8100c0ca
>>
>> We move the list_del() into ipoib_neigh_free(), so that deletion happens
>> only once, after the entry has been successfully removed from the lookup
>> table.  This same behavior is already used in ipoib_del_neighs_by_gid()
>> and __ipoib_reap_neigh().
>>
>> Signed-off-by: Jim Foraker<foraker1-i2BcT+NCU+M@public.gmane.org>
> 
> Hi Jim,
> 
> I have reviewed the patch with Shlomo who did the neighboring changes in
> IPoIB -- impressive analysis and debugging, a good and proper fix to the
> issue presented e.g here marc.info/?l=linux-rdma&m=136881939301117&w=2
> 
> 
> Or.
> 
> 
Looks nice for me too.

Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
