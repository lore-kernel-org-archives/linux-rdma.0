From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH rfc 04/10] block: Add a non-selective polling interface
Date: Tue, 14 Mar 2017 21:21:59 +0000
Message-ID: <1489526506.2676.13.camel@sandisk.com>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
         <1489065402-14757-5-git-send-email-sagi@grimberg.me>
         <1489076712.2597.1.camel@sandisk.com>
         <b8124df3-bd09-2eb2-9899-3c9195605510@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b8124df3-bd09-2eb2-9899-3c9195605510-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Content-Language: en-US
Content-ID: <77969F01CE6DDD4196CE4CFEBAA4D99F-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-03-13 at 10:15 +0200, Sagi Grimberg wrote:
> > Additionally, I think making the hardware context an argument of this f=
unction
> > instead of using blk_mq_map_queue(q, smp_processor_id()) would make thi=
s
> > function much more versatile.
>=20
> What do you mean? remember that the callers interface to the device is
> a request queue, it doesn't even know if its a blk-mq device. Can you
> explain in more details what you would like to see?

Have you considered to make the CPU ID an argument instead of using the
smp_processor_id() result?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
