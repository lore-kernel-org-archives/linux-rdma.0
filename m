From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/15] Dual Port mlx5 IB Device for RoCE
Date: Mon, 25 Dec 2017 11:24:32 +0200
Message-ID: <CAJ3xEMgpP0Sbj4vY3_pJDjrDqHLHmkaTSGLyVuBY+aoC6VUnHA@mail.gmail.com>
References: <20171224125741.25464-1-leon@kernel.org> <CAJ3xEMhZgEee+VLpV4bV150siOdXwpcp64AGqeqr5Y2o--WRdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhZgEee+VLpV4bV150siOdXwpcp64AGqeqr5Y2o--WRdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Dec 24, 2017 at 11:47 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky wrote:


>> SR-IOV devices follow the same pattern as the physical ones. VFs of a
>> master port can bind VFs of slave ports, if available, and operate as dual port
>> devices.


> We still have two mlx5 EN devices, right?! and from libvirt point of view
> business are just as usual,
> a VM will be assigned with one VF from any of the core devices (master only,
> slave only or both) and this will be an IB device with one port - correct?

what happens if the admin provisions two VF devices for each of the
following patterns:

(slave, slave)
(master, master)
(master, slave) <-- this one you were targeting
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
