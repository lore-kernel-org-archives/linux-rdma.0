From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/5] ib/core: add support for extended performance
 counters in sysfs
Date: Mon, 31 Oct 2011 12:38:32 -0700
Message-ID: <CAL1RGDXdkiZNtAsnqDtgbCJGLXLFvk8s-YA5mR189kmg6FkabQ@mail.gmail.com>
References: <alpine.LRH.2.00.1110101047420.10901@ogerlitz.voltaire.com> <alpine.LRH.2.00.1110101055570.11243@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1110101055570.11243-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2011 at 1:56 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
> +static struct attribute_group pma_ext_group =3D {
> + =A0 =A0 =A0 .name =A0=3D "counters_ext",
> + =A0 =A0 =A0 .attrs =A0=3D pma_attrs_ext
> +};

Sorry for the late review here, but does it seem like the best
approach to have a separate "counters_ext" directory for
some subset of performance counters?  Instead we could
have two attribute_groups, one the basic counters and one
the basic and extended counters, and basically do

        if (is_pma_class_cap_ext_width(device, port_num) =3D=3D 0)
                sysfs_create_group(...basic and extended counters...)
       else
                sysfs_create_group(...basic counters...)

(by the way, is_pma_class_cap_ext_width() seems backwards
since it returns 0 for true.  How about bool pma_has_ext_width()
and have it return true if the extended counters ARE supported?)

Or is there some reason why users would want to make the
distinction between basic and extended counters?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
