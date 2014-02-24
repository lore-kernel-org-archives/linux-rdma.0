From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Mon, 24 Feb 2014 20:58:46 +0100
Message-ID: <530BA476.7040005@acm.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>	 <1392954937.26557.3.camel@haswell.thedillows.org>	 <53071B2E.2050302@acm.org> <1393047697.12377.11.camel@haswell.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393047697.12377.11.camel-a7a0dvSY7KqLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/22/14 06:41, David Dillow wrote:
> I didn't suggest that -- I'm saying add a common functionality to turn
> on/off the message printing for commands that failed due to a dead
> transport. If it is useful for SRP initiators, it is probably useful for
> SAS and iSCSI imitators as well.
> 
> At a quick look, it seems you need to add a new value to the
> rq_flag_bits enum in include/linux/blk_types.h, __REQ_FAILED_TRANSPORT,
> somewhere before __REQ_NR_BITS. And a #define in the style of those
> following it. Use that flag instead of REQ_QUIET in the patch we are
> discussing, and change the code in scsi_lib.c to check
> 
>   ((req->cmd_flags & REQ_FAILED_TRANSPORT) && $user_wants_this_knob) || !(req->cmd_flags & REQ_QUIET)
> 
> before calling scsi_print_sense(), with appropriate naming, of course.
> This gives you a central place to control it, and allows for consistency
> between initiators.
> 
> I agree it is much easier to just fix it in SRP, especially given the
> glacial rate of change for the SCSI mid-layer, but I really think a
> central control and driver-by-driver enablement would be the best
> approach. YMMV.

Hello Dave,

That makes sense to me. Do you think the (untested) patch below could
be a valid alternative to the above proposal ?

---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bd7f0d..124ab53 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -857,7 +857,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 */
 		if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
 			;
-		else if (!(req->cmd_flags & REQ_QUIET))
+		else if (cmd->device->sdev_state != SDEV_TRANSPORT_OFFLINE &&
+			 !(req->cmd_flags & REQ_QUIET))
 			scsi_print_sense("", cmd);
 		result = 0;
 		/* BLOCK_PC may have set error */
-- 
1.8.4.5


Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
