From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rfc 04/10] block: Add a non-selective polling interface
Date: Thu, 9 Mar 2017 16:25:26 +0000
Message-ID: <1489076712.2597.1.camel@sandisk.com>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
         <1489065402-14757-5-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489065402-14757-5-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <CA00FD33E80F6047AF40CDD9F49D4982-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 15:16 +0200, Sagi Grimberg wrote:
> +int blk_mq_poll_batch(struct request_queue *q, unsigned int batch)
> +{
> +	struct blk_mq_hw_ctx *hctx;
> +
> +	if (!q->mq_ops || !q->mq_ops->poll_batch)
> +		return 0;
> +
> +	hctx =3D blk_mq_map_queue(q, smp_processor_id());
> +	return q->mq_ops->poll_batch(hctx, batch);
> +}
> +EXPORT_SYMBOL_GPL(blk_mq_poll_batch);

A new exported function without any documentation? Wow. Please add a header
above this function that documents at least which other completion processi=
ng
code can execute concurrently with this function and from which contexts th=
e
other completion processing code can be called (e.g. blk_mq_poll() and
.complete()).

Why to return if (!q->mq_ops || !q->mq_ops->poll_batch)? Shouldn't that be =
a
WARN_ON_ONCE() instead? I think it is an error to calling blk_mq_poll_batch=
()
against a queue that does not define .poll_batch().

Additionally, I think making the hardware context an argument of this funct=
ion
instead of using blk_mq_map_queue(q, smp_processor_id()) would make this
function much more versatile.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
