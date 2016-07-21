From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] IB/mlx4: Add sysfs entry for VF node_guid
Date: Fri, 22 Jul 2016 01:58:20 +0300
Message-ID: <CAJ3xEMj9e6S9Jd6FU2iMircz0A-QwDUP6qG3iQPzvt6BSMBGQQ@mail.gmail.com>
References: <1469093572-6793-1-git-send-email-yuval.shaia@oracle.com>
 <7129f7b7-1e33-c170-7ab7-56ab5e22ff48@oracle.com> <02d9149b-cddc-bc44-6284-67c249c97f69@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02d9149b-cddc-bc44-6284-67c249c97f69-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 21, 2016 at 6:53 PM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 7/21/2016 6:12 PM, Santosh Shilimkar wrote:
>> On 7/21/2016 2:32 AM, Yuval Shaia wrote:

>>> Adding sysfs entries to read/write VF's Node GUID.
>>> This ability will enable sys-admin to configure node GUID for VFs the

> Hi Yuval,
> The following commit in iproute2 by Eli Cohen added a standard way to
> configure node/port GUID using IPoIB netdev:
>
> d91fb3f4c7e4 Add support for configuring Infiniband GUIDs
>
> The configuration will be done in the following way:
>     ip link set dev ib0 vf 0 node_guid 00:02:c9:03:00:21:6e:70
>     ip link set dev ib0 vf 0 port_guid 00:02:c9:03:00:21:6e:78
>
> Can't this be used here as well?

correct, NAK for adding more proprietary sysfs entries here, use the
standard rtnl way as in mlx5

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
