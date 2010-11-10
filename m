From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: ib0: failed send event
Date: Wed, 10 Nov 2010 14:17:36 +0200
Message-ID: <4CDA8D60.8030006@mellanox.co.il>
References: <4CD31B61.5090605@hpc.ufl.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD31B61.5090605-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Craig Prescott <prescott-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  On 11/4/2010 10:45 PM, Craig Prescott wrote:
> Hi,
>
> We have a new-ish node whose IPoIB access was interrupted last night;
> last message in the syslog was:
>
> ib0: failed send event (status=2, wrid=74 vend_err 67)
>
> The node has a Mellanox ConnectX HCA (MHQH19-XTC).
>
> I understand the status corresponds to IB_WC_LOC_QP_OP_ERR.  What does a
> vendor error code of 67 mean?
>
> Thanks,
> Craig Prescott
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Error is: Bus error reading WQE.

Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
