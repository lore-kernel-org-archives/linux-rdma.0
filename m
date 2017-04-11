From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v2] nvme-rdma: support devices with queue size < 32
Date: Tue, 11 Apr 2017 15:10:27 +0000
Message-ID: <1491923426.2654.1.camel@sandisk.com>
References: <1519881025.363156294.1491837154312.JavaMail.zimbra@kalray.eu>
         <1491838338.4199.5.camel@sandisk.com>
         <1807354347.364485979.1491900728245.JavaMail.zimbra@kalray.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1807354347.364485979.1491900728245.JavaMail.zimbra-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Content-Language: en-US
Content-ID: <5F4D30721932BB44BE5B3A0C1C46FD6F-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <mrybczyn-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>
Cc: "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>, "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org" <samuel.jones-FNhOzJFKnXGHXe+LvDLADg@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-04-11 at 10:52 +0200, Marta Rybczynska wrote:
> I think that we can remove the division (the modulo sig_limit). The sig_c=
ount
> is an u8 so it is really a type of variable you propose. It isn't used an=
ywhere
> it seems so we can change the way it is used in the snippet to count unti=
l the
> signaling moment. It will give something like:
>=20
> static inline nvme_rdma_queue_sig_limit(struct nvme_rdma_queue *queue)
> {
>        int sig_limit;
>=20
>        /* We signal completion every queue depth/2 and also
>         * handle the case of possible device with queue_depth=3D1,
>         * where we would need to signal every message.
>         */
>        sig_limit =3D max(queue->queue_size / 2, 1);
>        queue->sig_count++;
>        if (queue->sig_count < sig_limit)
>            return 0;
>        queue->sig_count =3D 0;
>        return 1;
> }

Hello Marta,

Thank you for having addressed my feedback. Although this is not important,=
 I
think it is possible to optimize the above code further as follows:
* Instead of initializing / resetting sig_count to zero, initialize it to s=
ig_limit.
* Instead of incrementing sig_count in nvme_rdma_queue_sig_limit(), decreme=
nt it.
* Instead of comparing sig_count against sig_limit, compare it against zero=
.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
