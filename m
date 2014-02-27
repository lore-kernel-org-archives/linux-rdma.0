From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v1 3/3] IB/srp: Protect free_tx iu list from concurrent
 flows
Date: Thu, 27 Feb 2014 15:22:28 +0100
Message-ID: <530F4A24.1000802@acm.org>
References: <1393252218-30638-1-git-send-email-sagig@mellanox.com> <1393252218-30638-4-git-send-email-sagig@mellanox.com> <530B677A.1040508@acm.org> <530F26CE.5070404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <530F26CE.5070404-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02/27/14 12:51, Sagi Grimberg wrote:
> Regarding in_scsi_eh, can you end-up still posting a send if you are in
> an interrupt context?
> it's just that we have a *very* rare case (not easy to reproduce) in
> RH6.5 where we end-up posting on a just destroyed QP
> (race right in between destroy_qp and assignment of new qp in
> srp_create_target_ib).
> We tested it with in_scsi_eh patch and it still happened.
> 
> As I see it, SRP problems comes in a distinct period when rport is in
> state BLOCKED.
> On one hand, all request processing are allowed (not failing commands),
> and on the other reconnect flow may be running in concurrently.
> Will it be acceptable to take the rport_mutex in queue_command if rport
> is in BLOCKED state?

Hello Sagi,

The issue you described is probably specific to the RHEL backport of the
SRP initiator and does not affect the upstream SRP initiator. The
function scsi_request_fn_active() in drivers/scsi/scsi_transport_srp.c
is used by srp_reconnect_rport() to wait until ongoing
srp_queuecommand() calls have finished after the SCSI host state has
been changed into BLOCKED. That function relies on a member variable of
struct request_queue that has been introduced upstream in kernel 3.7.0.
In other words, that function needs attention when porting the SRP
initiator to RHEL 6. A small delay is probably sufficient to wait until
ongoing srp_queuecommand() calls have finished.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
