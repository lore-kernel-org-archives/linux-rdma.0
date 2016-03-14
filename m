From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 7/9] IB/core: generic RDMA READ/WRITE API
Date: Sun, 13 Mar 2016 18:04:15 -0700
Message-ID: <56E60E0F.7060900@sandisk.com>
References: <1457461000-24088-1-git-send-email-hch@lst.de>
 <1457461000-24088-8-git-send-email-hch@lst.de> <56DF44FC.8070103@sandisk.com>
 <20160309130723.GD31210@lst.de> <20160309155457.GA1898@lst.de>
 <56E071B6.8060809@sandisk.com> <20160310075722.GA551@lst.de>
 <56E1931C.1040206@sandisk.com> <20160310162150.GA9544@lst.de>
 <56E34914.2020108@sandisk.com> <20160312061232.GA15236@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160312061232.GA15236-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03/11/16 22:12, Christoph Hellwig wrote:
> On Fri, Mar 11, 2016 at 02:39:16PM -0800, Bart Van Assche wrote:
>> The above is fine with me. But when I ran a test with rdma_rw_use_mr()
>> changed into "return true" the following error messages appeared in the
>> kernel log:
>>
>> [  364.460709] ib_srpt 0x1: parsing SRP descriptor table failed.
>> [  383.604809] ib_srpt 0x0: parsing SRP descriptor table failed.
>> [  383.605627] ib_srpt 0x2: parsing SRP descriptor table failed.
>> [  386.702905] ib_srpt 0x3: parsing SRP descriptor table failed.
>> [  386.703092] ib_srpt 0x4: parsing SRP descriptor table failed.
>> [  386.703242] ib_srpt 0x5: parsing SRP descriptor table failed.
>> [  386.703411] ib_srpt 0x6: parsing SRP descriptor table failed.
>>
>> Is this expected? I ran this test on a server equipped with two mlx4 HCAs
>> with latest firmware (2.36.5000). I installed git commit
>> c4c65482b56a433a82bc5b63db8ba125727e9f80 of the rdma-rw-api merged with
>> v4.5-rc7. Initiator and target drivers were running on the same server and
>> were communicating with each other via loopback. Before I modified
>> rdma_rw_use_mr() the same test passed on the same setup.
> 
> I think this might be the case when SRP gets multiple SGL entries.
> In this case the number of MRs allocated is limited and srpt should
> handle rdma_rw_ctx_init failures due to the lack of MRs.  If you add
> the ib_mr_pool_get failure printk back that you asked me to remove
> I bet it's going to trigger.

Hello Christoph,

After having applied the following patch:

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index c6e8483..940dee8 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -64,6 +64,8 @@ static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 
 		reg->mr = ib_mr_pool_get(qp, &qp->rdma_mrs);
 		if (!reg->mr) {
+			pr_debug("failed to allocate MR %d/%d from pool (in use: %d)\n",
+				 i, ctx->nr_ops, qp->mrs_used);
 			ret = -EAGAIN;
 			goto out_free;
 		}

and after having run:

echo 'module ib_core +pmf' > /sys/kernel/debug/dynamic_debug/control

the following output appeared:

[ 1104.391493] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.391621] ib_srpt 0x0: parsing SRP descriptor table failed.
[ 1104.391762] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.391864] ib_srpt 0x1: parsing SRP descriptor table failed.
[ 1104.391987] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.392085] ib_srpt 0x2: parsing SRP descriptor table failed.
[ 1104.392208] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.392306] ib_srpt 0x3: parsing SRP descriptor table failed.
[ 1104.392427] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.392525] ib_srpt 0x4: parsing SRP descriptor table failed.
[ 1104.392647] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.392745] ib_srpt 0x5: parsing SRP descriptor table failed.
[ 1104.392867] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.392965] ib_srpt 0x6: parsing SRP descriptor table failed.
[ 1104.393089] ib_core:rdma_rw_init_mr_wrs: failed to allocate MR 0/1 from pool (in use: 2048)
[ 1104.393189] ib_srpt 0x7: parsing SRP descriptor table failed.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
