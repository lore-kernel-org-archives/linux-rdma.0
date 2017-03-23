From: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/3] target: Fix queue-full callback error signaling
Date: Thu, 23 Mar 2017 11:06:03 +0530
Message-ID: <20170323053602.GA2323@chelsio.com>
References: <1477891554-26222-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1477891554-26222-1-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday, October 10/31/16, 2016 at 10:55:51 +0530, Nicholas A. Bellinger wrote:
>    From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Hi Nicholas,
This patch series fixes the post failures due to Send Queue overflow when
tested along with Sagi's "iser-target: avoid posting a recv buffer twice", which 
goes on top of these 3 patches.

Combined patches series(Nicholas's, Sagi's) works fine.
Tested with iWARP iser. 

As these changes are critical for devices with lower sg resources, hoping this 
series will be queued for next RC.

Reviewed-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Tested-by: Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

Thanks,
Bharat.
> 
>    Hi folks,
> 
>    This series contains target-core queue-full + iscsi-target
>    callback fixes for a bug reported by Steve and Potnuri
>    during recent v4.8.y iWARP/iser-target testing.
> 
>    The first patch fixes target-core queue-full handling response
>    leaks with non -EAGAIN / -ENOMEM errors.  It uses a new state
>    TRANSPORT_COMPLETE_QF_ERR to internally generate CHECK_CONDITION
>    for unknown fabric callback errors, to avoid attempting retry
>    of fabric data-transfer callbacks for this special case.
> 
>    This means all non -EAGAIN / -ENOMEM fabric callback errors
>    during target_core_fabric_ops for:
> 
>      *) ->write_pending()
>      *) ->queue_data_in()
>      *) ->queue_status()
> 
>    will result in CHECK_CONDITION + LOGICAL_UNIT_COMMUNICATION_FAILURE,
>    if no non-zero se_cmd->scsi_status was previously set.
>    It also means target-core ->queue_status() errors retry indefinately,
>    or until session shutdown explicitly stops outstanding I/O.
> 
>    The remaining changes are for propagating iscsit_transport
>    response failure back to target-core queue-full, and updating
>    iser-target to propagate isert_rdma_rw_ctx_post() errors from
>    RDMA R/W API back to target-core as well.
> 
>    Please review.
> 
>    --nab
> 
>    Nicholas Bellinger (3):
>      target: Fix unknown fabric callback queue-full errors
>      iscsi-target: Propigate queue_data_in + queue_status errors
>      iser-target: Fix queue-full response handling
> 
>     drivers/infiniband/ulp/isert/ib_isert.c      |  53 +++++++++-----
>     drivers/target/iscsi/iscsi_target.c          |   3 +-
>     drivers/target/iscsi/iscsi_target_configfs.c |  13 ++--
>     drivers/target/iscsi/iscsi_target_util.c     |   5 +-
>     drivers/target/iscsi/iscsi_target_util.h     |   2 +-
>     drivers/target/target_core_transport.c       | 102
>    ++++++++++++++++++---------
>     include/target/target_core_base.h            |   1 +
>     7 files changed, 114 insertions(+), 65 deletions(-)
> 
>    --
>    1.9.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
