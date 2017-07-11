From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH v7 for-4.13 4/7] RDMA/core: expose affinity mappings per
 completion vector
Date: Tue, 11 Jul 2017 22:07:01 +0000
Message-ID: <1499810819.2586.43.camel@wdc.com>
References: <1499671054-23899-1-git-send-email-sagi@grimberg.me>
         <1499671054-23899-5-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1499671054-23899-5-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <C43C585B3198A749AAB86F3FC01C621E-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-10 at 10:17 +0300, Sagi Grimberg wrote:
>  struct ib_client {
> @@ -3612,7 +3614,6 @@ static inline void rdma_ah_set_interface_id(struct =
rdma_ah_attr *attr,
> =20
>  	grh->dgid.global.interface_id =3D if_id;
>  }
> -
>  static inline void rdma_ah_set_grh(struct rdma_ah_attr *attr,
>  				   union ib_gid *dgid, u32 flow_label,
>  				   u8 sgid_index, u8 hop_limit,

Hello Sagi,

A nit: is it on purpose that this patch removes a blank line between the
definitions of rdma_ah_set_interface_id() and rdma_ah_set_grh()?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
