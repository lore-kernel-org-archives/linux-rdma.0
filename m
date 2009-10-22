From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 2/4] SRP fail-over faster
Date: Thu, 22 Oct 2009 16:08:54 -0700
Message-ID: <4AE0E606.6090805@mellanox.com>
References: <4AD3B443.7040107@mellanox.com> <ada63aham2r.fsf@cisco.com>	<4AD62D9D.1020900@mellanox.com> <adatyy190ti.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090006050500010308040905"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatyy190ti.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------090006050500010308040905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Roland Dreier wrote:
>  > >  > -	wait_for_completion(&target->done);
>  > >
>  > > How do you avoid leaking connection on module unload etc?  Don't we have
>  > > to wait for the disconnect to finish somewhere?
>  > >
>  > >  - R.
>  > >   
>  > Are you talking about cm_id?
>  > I think that we wait because we want to reuse cq/qp associate with the
>  > connection.
>  > On module unload, we destroy cm_id, cq, qp altogether.
>
> OK, I think I understand this piece locally (although if you delete the
> wait_for_completion() it would probably make more sense to delete the
> init_completion() just before it as well).
>
> However is it really a correct to reuse a cm_id that is in state
> timewait to initiate a new connection?  That seems pretty fragile to me.
>   
Here is the updated patch to remove both init_completion() and 
wait_for_completion()


--------------090006050500010308040905
Content-Type: text/plain;
 name="srp_2_disconnect_without_wait.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="srp_2_disconnect_without_wait.patch"

Disconnect the connection without waiting (1 << max(timeout -8),0) ms

Signed-off-by: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

 drivers/infiniband/ulp/srp/ib_srp.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 54c8fe2..dfa14de 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -415,13 +415,11 @@ static void srp_disconnect_target(struct srp_target_port *target)
 {
 	/* XXX should send SRP_I_LOGOUT request */
 
-	init_completion(&target->done);
 	if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
 		shost_printk(KERN_DEBUG, target->scsi_host,
 			     PFX "Sending CM DREQ failed\n");
 		return;
 	}
-	wait_for_completion(&target->done);
 }
 
 static void srp_remove_work(struct work_struct *work)
@@ -1301,7 +1299,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
-		comp = 1;
 		target->status = 0;
 		break;
 

--------------090006050500010308040905--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
