From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: How do I generate and set a GUID on an Ethernet VF with ConnectX-4?
Date: Wed, 31 May 2017 09:16:04 -0600
Message-ID: <CAANLjFpMXrO-QXiOmnCz=kKgf1mrsHRR_Xy6eido97gmU80SZQ@mail.gmail.com>
References: <CAANLjFoHJhCJpZ+9uogHE4nSLkrdTRbGgS4mO5un_M+mNYdmCw@mail.gmail.com>
 <847B5D33-D362-40F1-82B6-DB2F7B2BA1AA@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <847B5D33-D362-40F1-82B6-DB2F7B2BA1AA-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think there may be more than just changing the MAC. The Mellanox
documentation talks about unbinding and re-binding the VF. The odd
thing is that the MAC for the VF under the parent adapter is '0', but
the adapter itself has a MAC address. You had a good idea, but I think
we are still missing something. I do think that changing the MAC is
the right thing to get the GUID changed according to the Mellanox
documentation.

4: rs81p1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state
UP mode DEFAULT group default qlen 1000
   link/ether 24:8a:07:1e:7c:60 brd ff:ff:ff:ff:ff:ff
   vf 0 MAC 12:34:56:78:9a:bc, spoof checking off, link-state auto
   vf 1 MAC 00:00:00:00:00:00, spoof checking off, link-state auto
8: rs81p1v1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
   link/ether e6:17:5f:85:45:e6 brd ff:ff:ff:ff:ff:ff
17: rs81p1v0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq
state UP mode DEFAULT group default qlen 1000
   link/ether ee:af:9f:66:2b:0c brd ff:ff:ff:ff:ff:ff
# ibv_devices
   device                 node GUID
   ------              ----------------
   mlx5_0              248a0703001e7c60
   mlx5_2              0000000000000000
   mlx5_4              0000000000000000
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Wed, May 31, 2017 at 2:28 AM, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>
>> On May 30, 2017, at 8:55 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>
>> One problem we found with rping is that when the GUID is '0', it
>> fails. However, all of the VFs that are created are created with a '0'
>> GUID. How do I generate a GUID that will not conflict for the VFs?
> Hi Robert,
>
> IIRC, once you set a MAC address for a VF, the node guid will be derived automatically for it. Also, it can be controlled using iptool.
>
>
>> Once I have a generated GUID, how do I set it on a VF using the inbox
>> drivers? I can't find a /sys entry that will allow me to write it and
>> the one mentioned in the Mellanox OFED doesn't exist.
>>
>> I'll need to find a way to script this as part of my udev rules that
>> adds the VFs.
>>
>> Thank you,
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
