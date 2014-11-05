From: "zheng.li" <zheng.x.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] net/mlx4_core: Convert rcu locking to rwlock in CQ.
Date: Wed, 05 Nov 2014 16:47:36 +0800
Message-ID: <5459E428.5030004@oracle.com>
References: <1415093024-13041-1-git-send-email-zheng.x.li@oracle.com> <5458AFCA.8020309@dev.mellanox.co.il> <0d09d3ae52134cf4bfe4e8554eb34185@AM3PR05MB0935.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0d09d3ae52134cf4bfe4e8554eb34185-LOZWmgKjnYgQouBfZGh8ttqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "guru.anbalagane-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <guru.anbalagane-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

=E4=BA=8E 2014=E5=B9=B411=E6=9C=8804=E6=97=A5 19:32, Shachar Raindel =E5=
=86=99=E9=81=93:
>=20
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Sagi Grimberg
>> Sent: Tuesday, November 04, 2014 12:52 PM
>> To: Zheng Li; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Or Gerlitz; Yishai Hadas;
>> jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org; Eli Cohen
>> Cc: joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org; john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org;
>> guru.anbalagane-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
>> Subject: Re: [PATCH] net/mlx4_core: Convert rcu locking to rwlock in=
 CQ.
>>
>> On 11/4/2014 11:23 AM, Zheng Li wrote:
>>> The mlx4_ib_cq_comp dispatching was racy and this is fixed by using
>>> rcu locking. However, that introduced regression in ib port failure
>>> tests, so changing to rwlock.
>>> rcu_XXX api are used to synchronize threads and use
>> preempt_disable/enable
>>> to make sure that no thread cross other thread but is not safe for
>> interrupts
>>> routines. In this case we are in inteerupt context:
>> mlx4_msi_x_interrupt ->
>>> mlx4_eq_int -> mlx4_cq_completion, so can't use rcu_XXX to protect
>> this code.
>>
>> Did you check the performance (latency) implications of grabbing a
>> read_lock in the hot path?
>>
>> If I understand correctly, mlx4_cq_free is racing against
>> mlx4_cq_completion. What about dis-arming the cq (assuming that it i=
s
>> possible) after calling synchronize_irq()?
>>
>> I'm just not very happy with acquiring a lock (even a read_lock) in
>> such a critical path.
>>
>=20
> There are 2 separate issues here:
>=20
> a. The hot path in the linux kernel is currently missing a lock. The=20
> following race can occur with the current code:
>=20
> Thread 1                     | Thread 2
> -----------------------------+---------------------------------------=
-
> mlx4_cq_free(cq_1)           | mlx4_cq_completion(cq_2)
>                              |  radix_tree_lookup(cq_2) (in progress)
>  radix_tree_delete(cq_1)     |  (traversal is still ongoing)
>    free some radix tree nodes|  =20
>                              |     access free'd memory
>=20
> For this issue, there are 3 possible fixes:
> 1. The patch discussed here, performing an explicit read locking on t=
he
>    hot path and risking scalability issues due to cache line bouncing=
=2E
> 2. Similar, spin_lock based approach proposed 2 years ago:
>    http://marc.info/?t=3D134632316600001&r=3D1&w=3D2
> 3. A solution using RCU, included in Mellanox OFED.

Hi Shachar,
Our original patch is based on "3. A solution using RCU, included in
Mellanox OFED", our kernel merge it with rcu, finally found the hang
issue in free_cq(), then make the patch with rwlock instead of rcu to
fix the hang problem. I pull the latest upstream code and make a patch
based on it, send it to linux-rdma to review.


>=20
> b. The issue causing the stack trace below. Note that the stack=20
>    trace is not referring the upstream code, as there is no place in =
the
>    current mlx4_cq_free code that synchronizes the RCU. This indicate=
s
>    that the bug report is referring to the Mellanox OFED version of t=
his
>    code. However, the stack trace does not explain the regression
>    described above. Can you please provide:
>     - The exact details of the code base you are referring to in the =
report?
>     - A better description of the issue - you can use rcu_read_lock f=
rom
>       interrupt context, so something else is going on here.

Yes ,our original patch is based on the source code which merging "A
solution using RCU, included in Mellanox OFED", in order to send to
linux-rdma, we made a patch based on the latest upstream code and sent
it to  review.


>=20
>=20
>>>
>>> The stack is below:
>>> crash> bt
>>> PID: 32068  TASK: ffff880ed14405c0  CPU: 20  COMMAND: "kworker/u:1"
>>>   #0 [ffff880ec7c01a00] __schedule at ffffffff81506664
>>>   #1 [ffff880ec7c01b18] schedule at ffffffff81506d45
>>>   #2 [ffff880ec7c01b28] schedule_timeout at ffffffff8150719c
>>>   #3 [ffff880ec7c01bd8] wait_for_common at ffffffff81506bcd
>>>   #4 [ffff880ec7c01c68] wait_for_completion at ffffffff81506cfd
>>>   #5 [ffff880ec7c01c78] synchronize_sched at ffffffff810dda48
>>>   #6 [ffff880ec7c01cc8] mlx4_cq_free at ffffffffa027e67e [mlx4_core=
]
>>>   #7 [ffff880ec7c01cf8] mlx4_ib_destroy_cq at ffffffffa03238a3
>> [mlx4_ib]
>>>   #8 [ffff880ec7c01d18] ib_destroy_cq at ffffffffa0301c9e [ib_core]
>>>   #9 [ffff880ec7c01d28] rds_ib_conn_shutdown at ffffffffa041cf5d
>> [rds_rdma]
>>>   #10 [ffff880ec7c01dd8] rds_conn_shutdown at ffffffffa02b7f18 [rds=
]
>>>   #11 [ffff880ec7c01e38] rds_shutdown_worker at ffffffffa02bd14a [r=
ds]
>>>   #12 [ffff880ec7c01e58] process_one_work at ffffffff8108c3b9
>>>   #13 [ffff880ec7c01ea8] worker_thread at ffffffff8108ccfa
>>>   #14 [ffff880ec7c01ee8] kthread at ffffffff810912d7
>>>   #15 [ffff880ec7c01f48] kernel_thread_helper at ffffffff815123c4
>>>
>>> Signed-off-by: Zheng Li <zheng.x.li-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Joe Jin <joe.jin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: Guru <guru.anbalagane-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> Signed-off-by: John Sobecki <john.sobecki-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>   drivers/net/ethernet/mellanox/mlx4/cq.c   |   26 +++++++++++++++-=
---
>> -------
>>>   drivers/net/ethernet/mellanox/mlx4/mlx4.h |    2 +-
>>>   2 files changed, 16 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c
>> b/drivers/net/ethernet/mellanox/mlx4/cq.c
>>> index 56022d6..8b3b849 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/cq.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
>>> @@ -54,15 +54,19 @@
>>>
>>>   void mlx4_cq_completion(struct mlx4_dev *dev, u32 cqn)
>>>   {
>>> +	struct mlx4_cq_table *cq_table =3D &mlx4_priv(dev)->cq_table;
>>>   	struct mlx4_cq *cq;
>>>
>>> -	cq =3D radix_tree_lookup(&mlx4_priv(dev)->cq_table.tree,
>>> -			       cqn & (dev->caps.num_cqs - 1));
>>> +	read_lock(&cq_table->lock);
>>> +
>>> +	cq =3D radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_cq=
s -
>> 1));
>>>   	if (!cq) {
>>>   		mlx4_dbg(dev, "Completion event for bogus CQ %08x\n", cqn);
>>>   		return;
>>>   	}
>>>
>>> +	read_unlock(&cq_table->lock);
>>> +
>>>   	++cq->arm_sn;
>>>
>>>   	cq->comp(cq);
>>> @@ -73,13 +77,13 @@ void mlx4_cq_event(struct mlx4_dev *dev, u32 cq=
n,
>> int event_type)
>>>   	struct mlx4_cq_table *cq_table =3D &mlx4_priv(dev)->cq_table;
>>>   	struct mlx4_cq *cq;
>>>
>>> -	spin_lock(&cq_table->lock);
>>> +	read_lock(&cq_table->lock);
>>>
>>>   	cq =3D radix_tree_lookup(&cq_table->tree, cqn & (dev->caps.num_c=
qs -
>> 1));
>>>   	if (cq)
>>>   		atomic_inc(&cq->refcount);
>>>
>>> -	spin_unlock(&cq_table->lock);
>>> +	read_unlock(&cq_table->lock);
>>>
>>>   	if (!cq) {
>>>   		mlx4_warn(dev, "Async event for bogus CQ %08x\n", cqn);
>>> @@ -256,9 +260,9 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nen=
t,
>>>   	if (err)
>>>   		return err;
>>>
>>> -	spin_lock_irq(&cq_table->lock);
>>> +	write_lock_irq(&cq_table->lock);
>>>   	err =3D radix_tree_insert(&cq_table->tree, cq->cqn, cq);
>>> -	spin_unlock_irq(&cq_table->lock);
>>> +	write_unlock_irq(&cq_table->lock);
>>>   	if (err)
>>>   		goto err_icm;
>>>
>>> @@ -297,9 +301,9 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nen=
t,
>>>   	return 0;
>>>
>>>   err_radix:
>>> -	spin_lock_irq(&cq_table->lock);
>>> +	write_lock_irq(&cq_table->lock);
>>>   	radix_tree_delete(&cq_table->tree, cq->cqn);
>>> -	spin_unlock_irq(&cq_table->lock);
>>> +	write_unlock_irq(&cq_table->lock);
>>>
>>>   err_icm:
>>>   	mlx4_cq_free_icm(dev, cq->cqn);
>>> @@ -320,9 +324,9 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct
>> mlx4_cq *cq)
>>>
>>>   	synchronize_irq(priv->eq_table.eq[cq->vector].irq);
>>>
>>> -	spin_lock_irq(&cq_table->lock);
>>> +	write_lock_irq(&cq_table->lock);
>>>   	radix_tree_delete(&cq_table->tree, cq->cqn);
>>> -	spin_unlock_irq(&cq_table->lock);
>>> +	write_unlock_irq(&cq_table->lock);
>>>
>>>   	if (atomic_dec_and_test(&cq->refcount))
>>>   		complete(&cq->free);
>>> @@ -337,7 +341,7 @@ int mlx4_init_cq_table(struct mlx4_dev *dev)
>>>   	struct mlx4_cq_table *cq_table =3D &mlx4_priv(dev)->cq_table;
>>>   	int err;
>>>
>>> -	spin_lock_init(&cq_table->lock);
>>> +	rwlock_init(&cq_table->lock);
>>>   	INIT_RADIX_TREE(&cq_table->tree, GFP_ATOMIC);
>>>   	if (mlx4_is_slave(dev))
>>>   		return 0;
>>> diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>> b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>>> index de10dbb..42e2348 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
>>> @@ -642,7 +642,7 @@ struct mlx4_mr_table {
>>>
>>>   struct mlx4_cq_table {
>>>   	struct mlx4_bitmap	bitmap;
>>> -	spinlock_t		lock;
>>> +	rwlock_t		lock;
>>>   	struct radix_tree_root	tree;
>>>   	struct mlx4_icm_table	table;
>>>   	struct mlx4_icm_table	cmpt_table;
>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
