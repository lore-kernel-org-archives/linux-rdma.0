From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/15] net/mlx5: Set software owner ID during
 init HCA
Date: Wed, 27 Dec 2017 12:06:53 -0600
Message-ID: <37588052-e7cd-b2ad-b2e0-91e03a9401d1@mellanox.com>
References: <20171224125741.25464-1-leon@kernel.org>
 <20171224125741.25464-3-leon@kernel.org>
 <CAJ3xEMiq-4DGFW-Z3hX3NfsSGXD6bm_uarGF_cm6K7+YuutJBQ@mail.gmail.com>
 <b329f348-2462-2bf4-ee06-064e798c9b86@mellanox.com>
 <20171227175208.GD31310@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171227175208.GD31310-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/27/2017 11:52 AM, Jason Gunthorpe wrote:
> On Wed, Dec 27, 2017 at 09:27:20AM -0600, Daniel Jurgens wrote:
>> On 12/24/2017 4:00 PM, Or Gerlitz wrote:
>>> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>> From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>>>
>>>> Generate a unique 128bit identifier for each host and pass that value to
>>>> firmware in the INIT_HCA command if it reports the sw_owner_id
>>>> capo ability. This value is used by FW to determine if functions are in
>>>> use by the same host.
>>> "capo ability"?
>>>
>>> did you want to say the same driver instance? b/c multiple instances
>>> of the driver can run on a host
>> No, we want to set the same SW owner ID set for all devices for that
>> host. Not per driver instance.
> This commit message is confusing, can you explain it better please?
>
> I'm guessing the owner_id is used to match individual port's PCI
> functions?
>
> So, any 'host' that can see multiple PCI function and share ports
> should set the same ID?
Right, ports can only be bound if they have the same software owner ID set. If the ID is not the same the bind command will fail.
> What happens when a driver is detached? Eg I rebind the PCI function
> to VFIO. Does something reset the ID?
Yes, next time INIT_HCA is called the owner ID is set again.
> Not entirely sure why this is being done at all, shouldn't the PCI
> functions be rather un-ambiguous?
It's to prevent binding a device as a slave port if it's passed through to a different VM.
> Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
