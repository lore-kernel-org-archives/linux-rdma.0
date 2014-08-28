From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: mlx5 + SRP: max_qp_sz mismatch
Date: Thu, 28 Aug 2014 17:58:54 +0200
Message-ID: <53FF51BE.1080103@acm.org>
References: <CADvaNzWGThMx1gMYfheFVwHzk10+8KWmAPkYZ1_FxArhdmri8Q@mail.gmail.com>	<53F36420.3060607@dev.mellanox.co.il>	<CADvaNzVkKuvHw58meQD962VSm4Y-QZoHC3ndsYSBW8rw7S68cw@mail.gmail.com> <CADvaNzWAZiNiwBAVYVA5it7K3A4CAozkeHn8SowYNT7iE6YykA@mail.gmail.com> <53FCB18F.5030608@dev.mellanox.co.il> <53FDBED2.2060707@acm.org> <CFE9BFE80FFE4D4892AA5D31387E310F014FC414E5@MTLDAG02.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CFE9BFE80FFE4D4892AA5D31387E310F014FC414E5-LSMZvP3E4uyuSA5JZHE7gA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/27/14 13:28, Eli Cohen wrote:
> On 08/26/14 18:10, Sagi Grimberg wrote:
>>
>> Since I don't know how true send queue size can be computed from the 
>> device capabilities at the moment -I can suggest a fix to srpt to 
>> retry with srp_sq_size/2 (ans so on until it succeeds...)
>>
> The device capabilities provide the maximum number of send work
> requests that the device supports but the actual number of work
> requests that can be supported in a specific case depends on other
> characteristics of the work requests. For example, in the case of
> Connect-IB, the actual number depends on the number of s/g entries,
> the transport type, etc. This is in compliance with the IB spec:
> 
> 11.2.1.2 QUERY HCA
> Description:
> Returns the attributes for the specified HCA.
> The maximum values defined in this section are guaranteed
> not-to-exceed values. It is possible for an implementation to allocate
> some HCA resources from the same space. In that case, the maximum
> values returned are not guaranteed for all of those resources
> simultaneously.
> 
> So, a well written application should try smaller values if it fails
> with ENOMEM.
 
Hello Mark,

It would help if you could test the patch below. Sorry but I don't
have access to a ConnectIB setup myself.

Thanks,

Bart.

Reported-by: Mark Lehrer <lehrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fe09f27..3ffaf4e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2091,6 +2091,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	if (!qp_init)
 		goto out;
 
+retry:
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
 			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
@@ -2114,6 +2115,13 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
 	if (IS_ERR(ch->qp)) {
 		ret = PTR_ERR(ch->qp);
+		if (ret == -ENOMEM) {
+			srp_sq_size /= 2;
+			if (srp_sq_size >= MIN_SRPT_SQ_SIZE) {
+				ib_destroy_cq(ch->cq);
+				goto retry;
+			}
+		}
 		printk(KERN_ERR "failed to create_qp ret= %d\n", ret);
 		goto err_destroy_cq;
 	}
-- 
1.8.4.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
