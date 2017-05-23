From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: iSER with policy based routing error
Date: Tue, 23 May 2017 17:17:16 -0600
Message-ID: <CAANLjFqhPUd=kyuv0CBR69KuAwGZzne8ZY3-1J6YiNHuWqZBZA@mail.gmail.com>
References: <CAANLjFoB3V6_exH8TnQQobaHkz2K1Lxj0sVOVa2Q+MKAsCqCKQ@mail.gmail.com>
 <CAJ3xEMiYwGDott_gLrh7e4tG9Ti71vftMPuvyT3+czu7jWwqFA@mail.gmail.com>
 <CAANLjFqNkNVDiGr-yW9y6XCiWE_O7+OewmxWM+xmWHQ39n4wkw@mail.gmail.com> <CAANLjFpKGoruxvwhtHwF-fBH+dLT9RKqkd3POYwLVK856WEfFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFpKGoruxvwhtHwF-fBH+dLT9RKqkd3POYwLVK856WEfFA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I could not replicate ping6 working today without passing the -I
parameter. I created https://github.com/linux-rdma/rdma-core/pull/136
and now you can pass -I to rping to have it bind to a source address
just like ping and the rules and additional routing table works for
rping.

However, iSER is not able to find a network route. Where do you think
I should look next? It seems that RDMA_CM is able to work properly if
given the right information.

Thanks,
Robert
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, May 18, 2017 at 12:52 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
> On Thu, May 18, 2017 at 12:51 PM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> On Sat, May 13, 2017 at 11:55 AM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> On Sat, May 13, 2017 at 12:02 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>>> [...]
>>>> If we put a default gateway for IPv6 in the 'default' table, then iSER
>>>> is able to make a connection, but we can only use one port. It looks
>>>> as if iSER is not following the rules in the default routing table to
>>>> find the appropriate default gateway in a different table.
>>>
>>> can you just try to make rdma connection with the rping utility? do
>>> you see the same problem/s?
>>
>> Using mlx4 cards with IB/RoCE, I am seeing the same connection problem
>> with rping. There seems to be a bug that prevents rping from working
>> with RoCE on mlx5.
>>
>> I also found a thread between you and Mike Christie
>> https://groups.google.com/forum/#!topic/open-iscsi/IywifztV7Xs. It
>> doesn't say that things were all worked out about binding to dev/ip
>> address. Should iSER be able to bind to ip address (my preference), or
>> by device name (workable) to provide multipathing? Should this binding
>> be able to work with additional tables for finding the proper gateway?
>> We are intending to route all RoCE traffic over L3 boundaries as it
>> greatly simplifies the network configuration.
>>
>> Here is the test that I ran to show the problem (it is also in the
>> "rdma_cm unable to find route on sub-table" thread):
>
> Test #1
> -------
> Using ConnectX-3 and Infiniband with two hosts back to back.
>
> Server
> ------
>
> # systemctl start opensm
>
> # ip -6 addr add dev ib0 fd00::13/64
>
> # ip link set ib0 up
>
> # rping -s -a ::0
> server DISCONNECT EVENT...
> wait for RDMA_READ_ADV state 10
>
>
> Client
> ------
>
> # ip -6 addr add dev ib0 fd00::14/64
>
> # ip link set ib0 up
>
> # ping6 fd00::13
> PING fd00::13(fd00::13) 56 data bytes
> 64 bytes from fd00::13: icmp_seq=1 ttl=64 time=0.927 ms
> 64 bytes from fd00::13: icmp_seq=2 ttl=64 time=0.134 ms
> ^C
> --- fd00::13 ping statistics ---
> 2 packets transmitted, 2 received, 0% packet loss, time 1002ms
> rtt min/avg/max/mdev = 0.134/0.530/0.927/0.397 ms
>
> # rping -c -a fd00::13
> ^C
>
> Results #1
> ----------
> Tests complete successfully
>
>
> Test #2
> -------
> Built upon the configuration of Test #1
>
> Server
> ------
> # rping -s -a ::0
>
> Client
> ------
> # echo "100 r0" >> /etc/iproute2/rt_tables
>
> # ip -6 route del fd00::/64 dev ib0
>
> # ip -6 rule add from fd00::14 table r0
>
> # ip -6 route add fd00::/64 dev ib0 table r0
>
> # ping6 fd00::13
> PING fd00::13(fd00::13) 56 data bytes
> 64 bytes from fd00::13: icmp_seq=1 ttl=64 time=0.158 ms
> 64 bytes from fd00::13: icmp_seq=2 ttl=64 time=0.136 ms
> ^C
> --- fd00::13 ping statistics ---
> 2 packets transmitted, 2 received, 0% packet loss, time 1020ms
> rtt min/avg/max/mdev = 0.136/0.147/0.158/0.011 ms
>
> # rping -c -a fd00::13
> rdma_resolve_addr: Network is unreachable
>
> Results #2
> ----------
> rping is unable to find a route to use
>
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
