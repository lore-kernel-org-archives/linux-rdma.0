From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/15] Dual Port mlx5 IB Device for RoCE
Date: Wed, 27 Dec 2017 17:20:26 -0600
Message-ID: <a3cf271c-f66c-074a-88bd-b48b39959e6b@mellanox.com>
References: <20171224125741.25464-1-leon@kernel.org>
 <CAJ3xEMhZgEee+VLpV4bV150siOdXwpcp64AGqeqr5Y2o--WRdw@mail.gmail.com>
 <382ba516-bf7b-0a0b-7a9f-604cbf805c80@mellanox.com>
 <CAJ3xEMi3CvATj-vpfy8E89=ZoPL1mmoiu8HWea_NEwfV2++ZpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi3CvATj-vpfy8E89=ZoPL1mmoiu8HWea_NEwfV2++ZpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/27/2017 3:22 PM, Or Gerlitz wrote:
> On Wed, Dec 27, 2017 at 5:22 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> If the PCI device were a slave there would be no IB device for it in the VM.
> This creates a regression for users that update their kernel and now
> their VMs stop working

The feature is not enabled by default.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
