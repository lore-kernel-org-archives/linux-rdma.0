From: Olga Kornievskaia <aglo-63aXycvo3TyHXe+LvDLADg@public.gmane.org>
Subject: Re: krping problem on 4.15-rc4
Date: Fri, 12 Jan 2018 17:06:07 -0500
Message-ID: <CAN-5tyGq=hmXY9HZYXpfaytOUV=gb0fri69gj69WKbbYtW3nTQ@mail.gmail.com>
References: <CAN-5tyH1HO7yzzQLyb5z5Pq=OrHnKzmCrR2MffLguqsEA-mwWg@mail.gmail.com>
 <00ff01d38a4f$1a979eb0$4fc6dc10$@opengridcomputing.com> <CAN-5tyEwdSOiAk04xjfazxBqwkkTiCjr2dVcCoYLQJw8f37U=w@mail.gmail.com>
 <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <017d01d38b14$cbe95670$63bc0350$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 11, 2018 at 2:45 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
>> > Hey Olga,
>> >
>> > Are the machines the same kernel version / distro sw / and hw -
>> cpu/motherboard/memory/etc?  If not, what is different about them?  Is it the
>> krping server that sees the CQ error?  Do other rdma devices work on these
>> systems?
>>
>> Hi Steve,
>>
>> Machines software is the same kernel version (4.15-rc4) / distro sw
>> (RHEL7.4). Hardware of those machines the same (PRIMERGY RX200 S7) but
>> one machine has 8G less memory than the other (64G vs 56G). kpring
>> error was on the server. These machines only have 1 CX-5 no other RDMA
>> devices.
>>
>
> Ok.  The memory probably doesn't matter.  Maybe run krping client and server on the same host (to use hw-loopback), and see if it works on both, one, or neither systems when they are both the client and server.

Loopback on the original "server" machine produces the same failure.
Jan 12 17:05:40 localhost kernel: mlx5_0:dump_cqe:277:(pid 0): dump error cqe
Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
Jan 12 17:05:40 localhost kernel: 00000000 00000000 00000000 00000000
Jan 12 17:05:40 localhost kernel: 00000000 93003204 1000017c 0005e1d2
Jan 12 17:05:40 localhost kernel: krping: cq completion failed with
wr_id 0 status 4 opcode 0 vender_err 32
Jan 12 17:05:40 localhost kernel: krping: cq completion in ERROR state
Jan 12 17:05:40 localhost kernel: krping: wait for RDMA_READ_COMPLETE state 10
Jan 12 17:05:40 localhost kernel: krping: DISCONNECT EVENT...
Jan 12 17:05:40 localhost kernel: krping: wait for RDMA_WRITE_ADV state 10
Jan 12 17:05:40 localhost kernel: krping: cq completion in ERROR state


Loopback on the original "client" machine runs successfully.
Jan 12 17:04:26 localhost kernel: krping: server ping data (64B max):
|rdma-ping-0: ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqr|
Jan 12 17:04:26 localhost kernel: krping: ping data (64B max):
|rdma-ping-0: ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqr|
Jan 12 17:04:26 localhost kernel: krping: server ping data (64B max):
|rdma-ping-1: BCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrs|
Jan 12 17:04:26 localhost kernel: krping: ping data (64B max):
|rdma-ping-1: BCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrs|
Jan 12 17:04:26 localhost kernel: krping: server ping data (64B max):
|rdma-ping-2: CDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrst|
Jan 12 17:04:26 localhost kernel: krping: ping data (64B max):
|rdma-ping-2: CDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrst|
Jan 12 17:04:26 localhost kernel: krping: server ping data (64B max):
|rdma-ping-3: DEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstu|
Jan 12 17:04:26 localhost kernel: krping: ping data (64B max):
|rdma-ping-3: DEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstu|
Jan 12 17:04:26 localhost kernel: krping: server ping data (64B max):
|rdma-ping-4: EFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuv|
Jan 12 17:04:26 localhost kernel: krping: ping data (64B max):
|rdma-ping-4: EFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuv|
Jan 12 17:04:27 localhost kernel: krping: server ping data (64B max):
|rdma-ping-5: FGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvw|
Jan 12 17:04:27 localhost kernel: krping: ping data (64B max):
|rdma-ping-5: FGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvw|
Jan 12 17:04:27 localhost kernel: krping: server ping data (64B max):
|rdma-ping-6: GHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwx|
Jan 12 17:04:27 localhost kernel: krping: ping data (64B max):
|rdma-ping-6: GHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwx|
Jan 12 17:04:27 localhost kernel: krping: server ping data (64B max):
|rdma-ping-7: HIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxy|
Jan 12 17:04:27 localhost kernel: krping: ping data (64B max):
|rdma-ping-7: HIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxy|
Jan 12 17:04:27 localhost kernel: krping: server ping data (64B max):
|rdma-ping-8: IJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz|
Jan 12 17:04:27 localhost kernel: krping: ping data (64B max):
|rdma-ping-8: IJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz|
Jan 12 17:04:28 localhost kernel: krping: server ping data (64B max):
|rdma-ping-9: JKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzA|
Jan 12 17:04:28 localhost kernel: krping: ping data (64B max):
|rdma-ping-9: JKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyzA|
Jan 12 17:04:28 localhost kernel: krping: DISCONNECT EVENT...
Jan 12 17:04:28 localhost kernel: krping: wait for RDMA_READ_ADV state 10
Jan 12 17:04:28 localhost kernel: krping: cq completion in ERROR state

What does this means?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
