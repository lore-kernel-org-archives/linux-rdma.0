From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ibv_post_send/recv kernel path optimizations
Date: Fri, 21 Jan 2011 11:41:44 +0000
Message-ID: <BE2BFE91933D1B4089447C644860408066F95285@irsmsx503.ger.corp.intel.com>
References: <20101013091312.GB6060@bicker> <20101123071025.GI1522@bicker>
	<adahbf6gytv.fsf@cisco.com>	<20101124221845.GH2369@obsidianresearch.com>
	<adad3pugi90.fsf@cisco.com>	<20101125041337.GA11049@obsidianresearch.com>
	<4CEE7A22.2040706@voltaire.com>
	<BE2BFE91933D1B4089447C644860408064B44854@irsmsx503.ger.corp.intel.com>
	<4CF60343.7050602@voltaire.com>
	<BE2BFE91933D1B4089447C644860408066ABCF66@irsmsx503.ger.corp.intel.com>
	<20101214181735.GA2506@obsidianresearch.com>	<4D1888CB.2010101@Voltaire.com>
	<BE2BFE91933D1B4089447C644860408066C547E0@irsmsx503.ger.corp.intel.com>
	<ada4o9nfc6e.fsf@cisco.com>
	<BE2BFE91933D1B4089447C644860408066DDDF31@irsmsx503.ger.corp.intel.com>
 <adawrmc7av2.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adawrmc7av2.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland, 

You are right that the idr implementation introduces insignificant change in performance. I made the version with idr and semaphores usage and I see a minimal change comparing to hash table. Now only a shared page is used instead of kmalloc and copy_to_user.

I simplified changes to uverbs and I achieved what I wanted in performance. Now the patch looks like below.

Are these changes acceptable for k.org

Regards,

Mirek

--- ../SOURCES_19012011/ofa_kernel-1.5.3/drivers/infiniband/core/uverbs_cmd.c	2011-01-19 05:37:55.000000000 +0100
+++ ofa_kernel-1.5.3_idr_qp/drivers/infiniband/core/uverbs_cmd.c	2011-01-21 04:10:07.000000000 +0100
@@ -1449,15 +1449,29 @@
 
 	if (cmd.wqe_size < sizeof (struct ib_uverbs_send_wr))
 		return -EINVAL;
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	if (!qp)
+		goto out_raw_qp;
+
+	if (qp->qp_type == IB_QPT_RAW_ETH) {
+		resp.bad_wr = 0;
+		ret = qp->device->post_send(qp, NULL, NULL);
+		if (ret)
+			resp.bad_wr = cmd.wr_count;
+
+		if (copy_to_user((void __user *) (unsigned long)
+				cmd.response,
+				&resp,
+				sizeof resp))
+			ret = -EFAULT;
+		put_qp_read(qp);
+		goto out_raw_qp;
+	}
 
 	user_wr = kmalloc(cmd.wqe_size, GFP_KERNEL);
 	if (!user_wr)
 		return -ENOMEM;
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
-	if (!qp)
-		goto out;
-
 	is_ud = qp->qp_type == IB_QPT_UD;
 	sg_ind = 0;
 	last = NULL;
@@ -1577,9 +1591,8 @@
 		wr = next;
 	}
 
-out:
 	kfree(user_wr);
-
+out_raw_qp:
 	return ret ? ret : in_len;
 }
 
@@ -1681,16 +1694,31 @@
 	if (copy_from_user(&cmd, buf, sizeof cmd))
 		return -EFAULT;
 
+	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
+	if (!qp)
+		goto out_raw_qp;
+
+        if (qp->qp_type == IB_QPT_RAW_ETH) {
+		resp.bad_wr = 0;
+		ret = qp->device->post_recv(qp, NULL, NULL);
+                if (ret)
+                	resp.bad_wr = cmd.wr_count;
+
+                if (copy_to_user((void __user *) (unsigned long)
+				cmd.response,
+				&resp,
+				sizeof resp))
+			ret = -EFAULT;
+		put_qp_read(qp);
+		goto out_raw_qp;
+	}
+
 	wr = ib_uverbs_unmarshall_recv(buf + sizeof cmd,
 				       in_len - sizeof cmd, cmd.wr_count,
 				       cmd.sge_count, cmd.wqe_size);
 	if (IS_ERR(wr))
 		return PTR_ERR(wr);
 
-	qp = idr_read_qp(cmd.qp_handle, file->ucontext);
-	if (!qp)
-		goto out;
-
 	resp.bad_wr = 0;
 	ret = qp->device->post_recv(qp, wr, &bad_wr);
 
@@ -1707,13 +1735,13 @@
 			 &resp, sizeof resp))
 		ret = -EFAULT;
 
-out:
 	while (wr) {
 		next = wr->next;
 		kfree(wr);
 		wr = next;
 	}
 
+out_raw_qp:
 	return ret ? ret : in_len;
 }




-----Original Message-----
From: Roland Dreier [mailto:rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org] 
Sent: Monday, January 10, 2011 9:38 PM
To: Walukiewicz, Miroslaw
Cc: Or Gerlitz; Jason Gunthorpe; Hefty, Sean; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: ibv_post_send/recv kernel path optimizations

 > You are right that the most of the speed-up is coming from avoid semaphores, but not only.
 > 
 > From the oprof traces, the semaphores made half of difference.
 > 
 > The next one was copy_from_user and kmalloc/kfree usage (in my proposal - shared page method is used instead)

OK, but in any case the switch from idr to hash table seems to be
insignificant.  I agree that using a shared page is a good idea, but
removing locking needed for correctness is not a good optimization.

 > In my opinion, the responsibility for cases like protection of QP
 > against destroy during buffer post (and other similar cases) should
 > be moved to vendor driver. The OFED code should move only the code
 > path to driver.

Not sure what OFED code you're talking about.  We're discussing the
kernel uverbs code, right?

In any case I'd be interested in seeing how it looks if you move the
protection into the individual drivers.  I'd be worried about having to
duplicate the same code everywhere (which leads to bugs in individual
drivers) -- I guess this could be resolved by having the code be a
library that individual drivers call into.  But also I'm not sure if I
see how you could make such a scheme work -- you need to make sure that
the data structures used in the uverbs dispatch to drivers remain
consistent.

In the end I don't think we should go too far optimizing the
non-kernel-bypass case of verbs -- the main thing we're designing for is
kernel bypass hardware, after all.  Perhaps you could make your case go
faster by using a different file descriptor for each QP or something
(you could pass the fd back as part of the driver-specific create QP path)?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
