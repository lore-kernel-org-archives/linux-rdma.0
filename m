From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rfc 06/10] IB/cq: Don't force IB_POLL_DIRECT poll
 context for ib_process_cq_direct
Date: Thu, 9 Mar 2017 16:30:54 +0000
Message-ID: <1489077040.2597.3.camel@sandisk.com>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
         <1489065402-14757-7-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489065402-14757-7-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <F908348D7E7BA14A9AC0694C1A1D4369-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-03-09 at 15:16 +0200, Sagi Grimberg wrote:
> polling the completion queue directly does not interfere
> with the existing polling logic, hence drop the requirement.
>=20
> This can be used for polling mode ULPs.
>=20
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
> ---
>  drivers/infiniband/core/cq.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index 21d1a38af489..7f6ae0ecb0c5 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -64,8 +64,6 @@ static int __ib_process_cq(struct ib_cq *cq, int budget=
)
>   */
>  int ib_process_cq_direct(struct ib_cq *cq, int budget)
>  {
> -	WARN_ON_ONCE(cq->poll_ctx !=3D IB_POLL_DIRECT);
> -
>  	return __ib_process_cq(cq, budget);
>  }
>  EXPORT_SYMBOL(ib_process_cq_direct);

Using ib_process_cq_direct() for queues that have another type than
IB_POLL_DIRECT may trigger concurrent CQ processing. Before this patch
the completions from each CQ were processed sequentially. That's a big
change so I think this should be mentioned clearly in the header above
ib_process_cq_direct().

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
