From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 6/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 10:56:44 -0700
Message-ID: <CAL1RGDXaV5nWoa5eHBHPCAomx04NHK2bA+yuuf4cqmF6RodrkQ@mail.gmail.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-5-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-6-git-send-email-parav.pandit@emulex.com>
 <5abe3043-81f8-448a-9e55-b29e23f4eb9a@exht1.ad.emulex.com> <4F6A130E.2030602@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F6A130E.2030602-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 21, 2012 at 10:42 AM, frank zago
<fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> On 03/20/2012 05:39 PM, parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:
>> +struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *ibpd, int acc)
>> +{
>> + =A0 =A0 struct ocrdma_mr *mr;
>> +
>> + =A0 =A0 mr =3D ocrdma_alloc_lkey(ibpd, acc, 0, OCRDMA_ADDR_CHECK_D=
ISABLE);
>> + =A0 =A0 if (!mr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
>
> ocrdma_alloc_lkey does not return NULL on error.

Good catch!  Even more to the point, ocrdma_alloc_lkey() doesn't return=
 a
struct ocrdma_mr* on success.  So this function is totally broken.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
