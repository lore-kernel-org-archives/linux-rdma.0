From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: v4.10-rc SRP + mlx5 regression
Date: Mon, 13 Feb 2017 21:19:54 -0500 (EST)
Message-ID: <568916592.30910570.1487038794766.JavaMail.zimbra@redhat.com>
References: <20170210235611.3243-1-bart.vanassche@sandisk.com> <20170213141724.GQ14015@mtr-leonro.local> <225897984.30545262.1486995841880.JavaMail.zimbra@redhat.com> <1971987443.30613645.1487002375580.JavaMail.zimbra@redhat.com> <21338434.30712464.1487004451595.JavaMail.zimbra@redhat.com> <1301607843.30852658.1487021644535.JavaMail.zimbra@redhat.com> <898197116.30855343.1487022400065.JavaMail.zimbra@redhat.com> <1487022735.2719.7.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487022735.2719.7.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: hch-jcswGhMUV9g@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Sent: Monday, February 13, 2017 4:52:28 PM
> Subject: Re: v4.10-rc SRP + mlx5 regression
> 
> On Mon, 2017-02-13 at 16:46 -0500, Laurence Oberman wrote:
> > I will have to run through this again and see where the bisect went wrong.
> 
> Hello Laurence,
> 
> If you would be considering to repeat the bisect, did you know that a bisect
> can be sped up by specifying the names of the files and/or directories that
> are suspected? An example:
> 
> git bisect start */infiniband */net
> 
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Bart, 

Much better news this time :), worked late on this but got it figured out.

OK, so we got to this one, which makes a lot more sense and is right in the area where we are having issues.
I must have answered wrong to one of the steps the first time I did the bisect.

Reverted this in the master tree of rc8 and rebuilt the kernel
Now all tests pass on Linus's tree - 4.10.0_rc8+

The interesting point here is that this commit is in rc5 but rc5 was not failing so we have an interoperability issue with this commit


[loberman@ibclient linux]$ git bisect good
Bisecting: 0 revisions left to test after this (roughly 1 step)
[ad8e66b4a80182174f73487ed25fd2140cf43361] IB/srp: fix mr allocation when the device supports sg gaps

[loberman@ibclient linux]$ git show ad8e66b4a80182174f73487ed25fd2140cf43361
commit ad8e66b4a80182174f73487ed25fd2140cf43361
Author: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Wed Dec 28 12:48:28 2016 +0200

    IB/srp: fix mr allocation when the device supports sg gaps
    
    If the device support arbitrary sg list mapping (device cap
    IB_DEVICE_SG_GAPS_REG set) we allocate the memory regions with
    IB_MR_TYPE_SG_GAPS.
    
    Fixes: 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
    Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.7+
    Signed-off-by: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
    Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
    Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 8ddc071..0f67cf9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -371,6 +371,7 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
        struct srp_fr_desc *d;
        struct ib_mr *mr;
        int i, ret = -EINVAL;
+       enum ib_mr_type mr_type;
 
        if (pool_size <= 0)
                goto err;
@@ -384,9 +385,13 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
        spin_lock_init(&pool->lock);
        INIT_LIST_HEAD(&pool->free_list);
 
+       if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
+               mr_type = IB_MR_TYPE_SG_GAPS;
+       else
+               mr_type = IB_MR_TYPE_MEM_REG;
+
        for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
-               mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
-                                max_page_list_len);
+               mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
                if (IS_ERR(mr)) {
                        ret = PTR_ERR(mr);
                        if (ret == -ENOMEM)
(END)


So here is the revert patch, but you need to decide how you want to deal with this.

    Revert "IB/srp: fix mr allocation when the device supports sg gaps"
    Laurence Oberman
    Traced after bisection to a cause for this failure

Tested-by:     Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

commit 90d169d312a173d5350c1bb36d6daab04c592127
Author: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Mon Feb 13 20:33:32 2017 -0500

    Revert "IB/srp: fix mr allocation when the device supports sg gaps"
    Laurence Oberman
    Traced after bisection to a cause for this failure
    
    [  130.437603] mlx5_0:dump_cqe:262:(pid 3812): dump error cqe
    [  130.437682] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f0edbfb0
    [  130.510899] 00000000 00000000 00000000 00000000
    [  130.536455] 00000000 00000000 00000000 00000000
    [  130.561878] 00000000 00000000 00000000 00000000
    [  130.585904] 00000000 0f007806 2500002a db0ec4d0
    [  145.842925] fast_io_fail_tmo expired for SRP port-1:1 / host1.
    [  146.530439] scsi host1: ib_srp: reconnect succeeded
    [  146.566629] mlx5_0:dump_cqe:262:(pid 3293): dump error cqe
    [  146.597635] 00000000 00000000 00000000 00000000
    [  146.623545] 00000000 00000000 00000000 00000000
    [  146.649599] 00000000 00000000 00000000 00000000
    [  146.673938] 00000000 0f007806 25000032 000c46d0
    [  146.697969] scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff88
    [  162.225247] fast_io_fail_tmo expired for SRP port-1:1 / host1.
    [  162.256337] scsi host1: ib_srp: reconnect succeeded
    [  162.293396] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f0412ef0`
    
    This reverts commit ad8e66b4a80182174f73487ed25fd2140cf43361.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 79bf484..01338c8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -371,7 +371,6 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
        struct srp_fr_desc *d;
        struct ib_mr *mr;
        int i, ret = -EINVAL;
-       enum ib_mr_type mr_type;
 
        if (pool_size <= 0)
                goto err;
@@ -385,13 +384,9 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
        spin_lock_init(&pool->lock);
        INIT_LIST_HEAD(&pool->free_list);
 
-       if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
-               mr_type = IB_MR_TYPE_SG_GAPS;
-       else
-               mr_type = IB_MR_TYPE_MEM_REG;
-
        for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
-               mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
+               mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+                                max_page_list_len);
                if (IS_ERR(mr)) {
                        ret = PTR_ERR(mr);
                        if (ret == -ENOMEM)



Now moving on to what got me here in the first place.
Bart, let me know if the 7 of the 8 patches in your most recent series are all still valid after this revert 
Otherwise let me know which ones you want me to apply.

patch 6 - I am thinking i sno longer valid.
"
If a HCA supports the SG_GAPS_REG feature then a single memory
region of type IB_MR_TYPE_SG_GAPS is sufficient. This patch
reduces the number of memory regions that is allocated per SRP
session.
"

Thanks
Laurence
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
