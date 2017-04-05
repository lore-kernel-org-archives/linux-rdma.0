From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/5] IB/qib: Adjust two size determinations in
 qib_init_pportdata()
Date: Wed, 5 Apr 2017 15:10:14 +0000
Message-ID: <1491405013.2787.3.camel@sandisk.com>
References: <c16b18ac-287f-5faf-b79a-c86e2adfa22c@users.sourceforge.net>
         <b5bc4160-aace-b919-7fe2-a4742d03c4ba@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b5bc4160-aace-b919-7fe2-a4742d03c4ba-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-US
Content-ID: <659B944AA8F79448A4379644FCE0ADAE-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-04-05 at 15:55 +0200, SF Markus Elfring wrote:
> -	size =3D sizeof(struct ib_cc_congestion_setting_attr);
> -	ppd->congestion_entries_shadow =3D kzalloc(size, GFP_KERNEL);
> +	ppd->congestion_entries_shadow =3D kzalloc(sizeof(*ppd
> +							->congestion_entries_shadow),
> +						 GFP_KERNEL);

The way how the above line has been split looks really weird. Please
move the entire kzalloc() call to the next line such that "*ppd" and
"->congestion_entries_shadow" appear on the same line.

Thanks,

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
