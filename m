From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH-v2] ib_srpt: Initial SRP Target merge for v3.2-rc1
Date: Mon, 24 Oct 2011 18:45:09 +0200
Message-ID: <CAO+b5-rch-mPgXKjs4=t4ubfb9SFhDiR26EoeJgyZjWfhRJ9DA@mail.gmail.com>
References: <1319435841-19046-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319435841-19046-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 24, 2011 at 7:57 AM, Nicholas A. Bellinger
<nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org> wrote:
> This v2 patch adds the kernel module ib_srpt SCSI RDMA Protocol (SRP) target
> implementation conforming to the SRP r16a specification for the mainline
> drivers/target infrastructure.
>
> This driver was originally developed by Vu Pham and has been optimized by
> Bart Van Assche and merged into upstream LIO based on his srpt-lio-4.1 branch.
> This patch is made against the current pending target-core changes for
> v3.2-rc1, the full tree is available here:

Maybe you remember that the reason why I developed this patch was to
be able to run performance measurements ? The following changes are
necessary to convert this patch into a robust kernel driver:
- Handle the case where the last WQE event arrives before the
corresponding queue pair is reset (r3870 in the SCST SVN repo).
- Handle IB completion timeouts. Although the InfiniBand Architecture
Manual specifies that a HCA must generate an error completion for each
pending work item when a queue pair reset is issued, an important
class of HCAs doesn't do this (that includes the HCA in your test
setup). In the SCST version of this driver such timeouts are handled
by the function srpt_pending_cmd_timeout().

Both issues mentioned above can lead to sessions not being cleaned up
properly and hence all future logins from the initiator associated
with that session to be blocked.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
