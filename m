From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/15] Dual Port mlx5 IB Device for RoCE
Date: Fri, 29 Dec 2017 14:52:18 -0600
Message-ID: <9d102fb2-122c-d7e9-2521-cf61b708d8c0@mellanox.com>
References: <20171224125741.25464-1-leon@kernel.org>
 <CAJ3xEMhZgEee+VLpV4bV150siOdXwpcp64AGqeqr5Y2o--WRdw@mail.gmail.com>
 <382ba516-bf7b-0a0b-7a9f-604cbf805c80@mellanox.com>
 <CAJ3xEMi3CvATj-vpfy8E89=ZoPL1mmoiu8HWea_NEwfV2++ZpQ@mail.gmail.com>
 <a3cf271c-f66c-074a-88bd-b48b39959e6b@mellanox.com>
 <20171229180313.GD6513@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171229180313.GD6513-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/29/2017 12:03 PM, Jason Gunthorpe wrote:
> On Wed, Dec 27, 2017 at 05:20:26PM -0600, Daniel Jurgens wrote:
>> On 12/27/2017 3:22 PM, Or Gerlitz wrote:
>>> On Wed, Dec 27, 2017 at 5:22 PM, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>> If the PCI device were a slave there would be no IB device for it in the VM.
>>> This creates a regression for users that update their kernel and now
>>> their VMs stop working
>> The feature is not enabled by default.
> You never described how it is enabled in the commit messages either..

It's enabled vi FW ini file/PSID or mlxconfig.  Do we ever describe that?

>
> Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
