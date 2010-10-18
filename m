From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
Date: Mon, 18 Oct 2010 12:11:54 +0200
Message-ID: <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov> <1287285925-11710-3-git-send-email-dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287285925-11710-3-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 17, 2010 at 5:25 AM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
> [ ... ]
> +static int srp_response_common(struct srp_target_port *target, s32 r=
eq_delta,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0void *rs=
p, int len)
> +{
> + =A0 =A0 =A0 struct ib_device *dev;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 struct srp_iu *iu;
> + =A0 =A0 =A0 int err =3D 1;
> +
> + =A0 =A0 =A0 dev =3D target->srp_host->srp_dev->dev;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(target->scsi_host->host_lock, flags);
> + =A0 =A0 =A0 target->req_lim +=3D req_delta;
> +
> + =A0 =A0 =A0 iu =3D __srp_get_tx_iu(target, SRP_IU_RSP);
> + =A0 =A0 =A0 if (!iu) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 shost_printk(KERN_ERR, target->scsi_hos=
t, PFX
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"no IU avail=
able to send response\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DE=
VICE);

Hi Dave,

As far as I can see the above sync call applies to a buffer in the
tx_ring[]. Data in that buffer is only modified by the CPU and never
by the HCA. So why is the above sync call present ? Is that call
necessary ?

> + =A0 =A0 =A0 memcpy(iu->buf, rsp, len);
> + =A0 =A0 =A0 ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO=
_DEVICE);
> [ ... ]

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
