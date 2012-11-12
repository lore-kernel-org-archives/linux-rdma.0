From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/19, v5] Make ib_srp better suited for H.A. purposes
Date: Tue, 13 Nov 2012 00:51:00 +0200
Message-ID: <CAJZOPZLHg84M3RUV00itGSGUZsigW0yw=TLOe6K63mUXH5v1pQ@mail.gmail.com>
References: <508A85BB.1000505@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <508A85BB.1000505-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> This patch series makes the ib_srp driver better suited for use in a H.A. setup because:
> - multipathd is notified faster about transport layer failures.
> - Transport layer failures reliably result in SCSI host removal.
> - Switchover can be triggered explicitly by deleting an initiator device.
> - Disconnecting from a target without unloading ib_srp is now possible.

Hi Bart,

Few more questions/comments,

> The individual patches are:
> 0001-ib_srp-Enlarge-block-layer-timeout.patch
> 0002-ib_srp-Eliminate-state-SRP_TARGET_CONNECTING.patch
> 0003-ib_srp-Introduce-srp_handle_qp_err.patch
> 0004-ib_srp-Suppress-superfluous-error-messages.patch
> 0005-ib_srp-Avoid-that-SCSI-error-handling-causes-trouble.patch
> 0006-ib_srp-Introduce-the-helper-function-srp_remove_targ.patch
> 0007-ib_srp-Eliminate-state-SRP_TARGET_DEAD.patch
> 0008-ib_srp-Keep-processing-commands-during-host-removal.patch
> 0009-ib_srp-Make-srp_disconnect_target-wait-for-IB-comple.patch
> 0010-ib_srp-Document-sysfs-attributes.patch
> 0011-srp_transport-Fix-atttribute-registration.patch
> 0012-srp_transport-Simplify-attribute-initialization-code.patch
> 0013-srp_transport-Document-sysfs-attributes.patch
> 0014-ib_srp-Allow-SRP-disconnect-through-sysfs.patch
> 0015-ib_srp-Maintain-a-single-connection-per-I_T-nexus.patch
> 0016-srp_transport-Add-transport-layer-error-handling.patch
> 0017-ib_srp-Add-dev_loss_tmo-support.patch
> 0018-ib_srp-Remove-SCSI-devices-upon-port-down-event.patch
> 0019-scsi_transport_srp-Fail-I-O-faster.patch

I understand that as a whole, this series makes SRP to function better
in HA schems, however, can you break this list of patches to cleanups,
new functionality and actual HA related bug fixes and concrete
improvements. Also, if you can spare some high level words on the
design directions/decisions taken as the patch series evolved, as this
effort in underway for some time now.

Also for V6 -- next-time -- etc, please make sure to have Vn to appear
in the [PATCH] brackets, as it critical when folks browse between
different versions/postings of your to the same patch set, if you use
git format-patch, this is easily achieved with --subject-prefix="PATCH
Vn"

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
