From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC] IB/mlx4: Add sysfs entry for VF node_guid
Date: Thu, 21 Jul 2016 10:37:30 -0700
Message-ID: <c63f79fa-464f-ff97-d916-54bdbe250be2@oracle.com>
References: <1469093572-6793-1-git-send-email-yuval.shaia@oracle.com>
 <7129f7b7-1e33-c170-7ab7-56ab5e22ff48@oracle.com>
 <02d9149b-cddc-bc44-6284-67c249c97f69@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02d9149b-cddc-bc44-6284-67c249c97f69-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/21/2016 8:53 AM, Majd Dibbiny wrote:
> On 7/21/2016 6:12 PM, Santosh Shilimkar wrote:
>> On 7/21/2016 2:32 AM, Yuval Shaia wrote:
>>> Adding sysfs entries to read/write VF's Node GUID.
>>> This abbility will enable sys-admin to configure node GUID for VFs the
> typo
>>> same
>>> way it is done for VF's port GUIDs.
>>>
>
> Hi Yuval,
>
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
>
This could work as well. Does this has any dependency with
'iproute' version ? In other words does this kernel patch
needs any iproute patch ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
