From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp warning
Date: Thu, 13 Jan 2011 12:19:34 +0100
Message-ID: <AANLkTi=RP74hwT5nEr7XHyADPoE-7LKs8ECT_5QfS4pZ@mail.gmail.com>
References: <adalj2q587i.fsf@cisco.com> <1294854748.15826.26.camel@lap75545.ornl.gov>
 <ada8vyq57bq.fsf@cisco.com> <1294861341.15826.38.camel@lap75545.ornl.gov>
 <adaoc7l52hy.fsf@cisco.com> <adak4i952bk.fsf@cisco.com> <1294866460.15826.41.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294866460.15826.41.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 12, 2011 at 10:07 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrot=
e:
> On Wed, 2011-01-12 at 14:50 -0500, Roland Dreier wrote:
>> > Attached -- I'm using kind of a minimal config for build testing, =
so
>> =A0> maybe I have some strange optimization enabled (CONFIG_CC_OPTIM=
IZE_FOR_SIZE=3Dy?)
>>
>> Indeed... unsetting CONFIG_CC_OPTIMIZE_FOR_SIZE seems to get rid of =
the warning.
>
> Pushed the uninitialized_var change to
>
> git://git.kernel.org/pub/scm/linux/kernel/git/dad/srp-initiator.git s=
rp-lock-scaling-warning

Hello Dave,

I found this patch in the above location:

IB/srp: surpress uninitialized variable warning with -Os

Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index 4b62105..cc29d57 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1113,7 +1113,7 @@ static void srp_send_completion(struct ib_cq
*cq, void *target_ptr)
 static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd =
*scmnd)
 {
 	struct srp_target_port *target =3D host_to_target(shost);
-	struct srp_request *req;
+	struct srp_request *uninitialized_var(req);
 	struct srp_iu *iu;
 	struct srp_cmd *cmd;
 	struct ib_device *dev;

While I don't doubt that that patch has been tested properly and that i=
t has
been carefully selected over the possible alternatives, I have been won=
dering
why an approach like the one below (patch has not been tested) has not =
been
chosen ? Not only should that patch avoid triggering a warning about th=
e
variable 'req' not being initialized but it also eliminates an if-state=
ment
and hence might improve performance a little.

Bart.

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
b/drivers/infiniband/ulp/srp/ib_srp.c
index 4b62105..3164c4d 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1132,16 +1132,12 @@ static int srp_queuecommand(struct Scsi_Host
*shost, struct scsi_cmnd *scmnd)

 	spin_lock_irqsave(&target->lock, flags);
 	iu =3D __srp_get_tx_iu(target, SRP_IU_CMD);
-	if (iu) {
-		req =3D list_first_entry(&target->free_reqs, struct srp_request,
-				      list);
-		list_del(&req->list);
-	}
+	if (unlikely(!iu))
+		goto err_unlock;
+	req =3D list_first_entry(&target->free_reqs, struct srp_request, list=
);
+	list_del(&req->list);
 	spin_unlock_irqrestore(&target->lock, flags);

-	if (!iu)
-		goto err;
-
 	dev =3D target->srp_host->srp_dev->dev;
 	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
 				   DMA_TO_DEVICE);
@@ -1185,6 +1181,7 @@ err_iu:

 	spin_lock_irqsave(&target->lock, flags);
 	list_add(&req->list, &target->free_reqs);
+err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);

 err:
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
