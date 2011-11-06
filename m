From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] ib_srpt: Make srpt_srq_size module parameter use S_IRUGO|S_IWUSR
Date: Sun, 6 Nov 2011 12:40:50 +0100
Message-ID: <CAO+b5-pvgAkCxU=+sSXRLGjBU-bsC=q8-O9qHTQJg9L8P=W_9g@mail.gmail.com>
References: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
	<1320578141-27048-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1320578141-27048-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-rdma@vger.kernel.org

On Sun, Nov 6, 2011 at 12:15 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> This patch converts the srpt_srq_size module parameter to R/W access
> so that it's accessable when built as CONFIG_INFINIBAND_SRPT=3Dy. =A0=
This
> parameter is only referenced within srpt_add_one() directly to set
> srpt_device->srq_size.
>
> Reported-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Roland Dreier <roland@purestorage.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
> =A0drivers/infiniband/ulp/srpt/ib_srpt.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniba=
nd/ulp/srpt/ib_srpt.c
> index 94e6aff..43a17e3 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -84,7 +84,7 @@ MODULE_PARM_DESC(srp_max_req_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Maximum size of SRP request messages=
 in bytes.");
>
> =A0static int srpt_srq_size =3D DEFAULT_SRPT_SRQ_SIZE;
> -module_param(srpt_srq_size, int, 0444);
> +module_param(srpt_srq_size, int, S_IRUGO|S_IWUSR);
> =A0MODULE_PARM_DESC(srpt_srq_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Shared receive queue (SRQ) size.");

This patch makes it possible to set srpt_srq_size to values that are
so low that communication becomes impossible. Attempts to set
srpt_srq_size below MIN_SRPT_SRQ_SIZE should either be blocked or the
modification shown should be added to the above patch:

-sdev->srq_size =3D min(srpt_srq_size, sdev->dev_attr.max_srq_wr);
+sdev->srq_size =3D min(max(srpt_srq_size, MIN_SRPT_SRQ_SIZE),
sdev->dev_attr.max_srq_wr);

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
