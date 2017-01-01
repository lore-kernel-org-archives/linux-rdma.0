From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next V1 5/9] IB/ipoib: rtnl_unlock can not come after free_netdev
Date: Sun, 1 Jan 2017 09:19:43 +0200
Message-ID: <CAJ3xEMj-6aLraLqH+VBeyqTivSnB0hRo_Hzaiy_LChX8yXDjVg@mail.gmail.com>
References: <20161228124728.26619-1-leon@kernel.org> <20161228124728.26619-6-leon@kernel.org>
 <CAJ3xEMg+UuvUqqaFrBXa+S+S2qLg_FowZLrwvhYzaB7JTkn=pQ@mail.gmail.com> <20170101063945.GP26885@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170101063945.GP26885-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jan 1, 2017 at 8:39 AM, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On Thu, Dec 29, 2016 at 10:55:34PM +0200, Or Gerlitz wrote:
>> On Wed, Dec 28, 2016 at 2:47 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> > From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> >
>> > The ipoib_vlan_add function calls rtnl_unlock after free_netdev,
>> > rtnl_unlock not only releases the lock, but also calls netdev_run_todo.
>> > The latter function browses the net_todo_list array and completes the
>> > unregistration of all its net_device instances. If we call free_netdev
>> > before rtnl_unlock, then netdev_run_todo call over the freed device causes
>> > panic.
>>
>>
>> RU claiming that we are crashing 100.0% here? since when? ever?
>
> According to our internal bugtracker (see #131352), this bug was
> literaly forever (4 years old), and it was fixed internaly in
> MOFED 2.0.

Did you try it out? e.g to see that this crashes 100% as you claim?

I am pretty much sure this is not correct, and I'd like to see Erez commenting
on that and supporting your claim.

>> > To fix, move rtnl_unlock call before free_netdev call.
>> > Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
>> > Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
