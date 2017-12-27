From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/15] net/mlx5: Set software owner ID during
 init HCA
Date: Wed, 27 Dec 2017 23:28:35 +0200
Message-ID: <CAJ3xEMiGRZPkC-rFVaPDmp8tjmRfYtnDn2rJeYSaUFSsdgEK=g@mail.gmail.com>
References: <20171224125741.25464-1-leon@kernel.org> <20171224125741.25464-3-leon@kernel.org>
 <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ@mail.gmail.com> <20171225053534.GT2942@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171225053534.GT2942-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 25, 2017 at 7:35 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Mon, Dec 25, 2017 at 12:00:43AM +0200, Or Gerlitz wrote:
>> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >
>> >
>> > +#define MLX5_ARRAY_SET(typ, p, fld, idx, v) do { \
>> > +       BUILD_BUG_ON(__mlx5_bit_off(typ, fld) % 32); \
>> > +       MLX5_SET(typ, p, fld[idx], v); \
>> > +} while (0)
>> > +
>>
>> Parav, Dan, we I pointed to you during the dscp trust mode work, changes
>> to this area of the code should have the RB sig of Eli Cohen or Saeed if you
>> can't get Eli, please do that.

> This patch and other patches in this series were seen by Saeed during
> preparation to shared code pull request. In addition, he was being added
> as an reviewer for the months.

The upstream way to approach a reviewer which is not responsive enough
is to put a

Cc:

line for them in the signatures area of the change log

but you can simply give them a call or shout over the cubicle or near
the coffee machine,
it will just work, I can assure you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
