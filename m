From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] nvme-rdma: Add remote_invalidation module parameter
Date: Mon, 30 Oct 2017 14:18:42 -0400
Message-ID: <2FB68C09-F811-44C9-9F48-826C074DDE14@oracle.com>
References: <1509295101-14081-1-git-send-email-idanb@mellanox.com> <1509295101-14081-3-git-send-email-idanb@mellanox.com> <87A0B150-CE67-4C8C-914E-53F66411E1BB@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87A0B150-CE67-4C8C-914E-53F66411E1BB-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hch <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On Oct 29, 2017, at 2:24 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> 
> 
>> On Oct 29, 2017, at 12:38 PM, idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org wrote:
>> 
>> From: Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> 
>> NVMe over Fabrics in its secure "register_always" mode
>> registers and invalidates the user buffer upon each IO.
>> The protocol enables the host to request the susbsystem
>> to use SEND WITH INVALIDATE operation while returning the
>> response capsule and invalidate the local key
>> (remote_invalidation).
>> In some HW implementations, the local network adapter may
>> perform better while using local invalidation operations.
>> 
>> The results below show that running with local invalidation
>> rather then remote invalidation improve the iops one could
>> achieve by using the ConnectX-5Ex network adapter by x1.36 factor.
>> Nevertheless, using local invalidation induce more CPU overhead
>> than enabling the target to invalidate remotly, therefore,
>> because there is a CPU% vs IOPs limit tradeoff we propose to
>> have module parameter to define whether to request remote
>> invalidation or not.
>> 
>> The following results were taken against a single nvme over fabrics
>> subsystem with a single namespace backed by null_blk:
>> 
>> Block Size       s/g reg_wr      inline reg_wr    inline reg_wr + local inv
>> ++++++++++++   ++++++++++++++   ++++++++++++++++ +++++++++++++++++++++++++++
>> 512B            1446.6K/8.57%    5224.2K/76.21%   7143.3K/79.72%
>> 1KB             1390.6K/8.5%     4656.7K/71.69%   5860.6K/55.45%
>> 2KB             1343.8K/8.6%     3410.3K/38.96%   4106.7K/55.82%
>> 4KB             1254.8K/8.39%    2033.6K/15.86%   2165.3K/17.48%
>> 8KB             1079.5K/7.7%     1143.1K/7.27%    1158.2K/7.33%
>> 16KB            603.4K/3.64%     593.8K/3.4%      588.9K/3.77%
>> 32KB            294.8K/2.04%     293.7K/1.98%     294.4K/2.93%
>> 64KB            138.2K/1.32%     141.6K/1.26%     135.6K/1.34%
> 
> Units reported here are KIOPS and %CPU ? What was the benchmark?
> 
> Was any root cause analysis done to understand why the IOPS
> rate changes without RI? Reduction in avg RTT? Fewer long-
> running outliers? Lock contention in the ULP?
> 
> I am curious enough to add a similar setting to NFS/RDMA,
> now that I have mlx5 devices.

I see the plan is to change the NVMeoF initiator to wait for
invalidation to complete, and then test again. However, I am
still curious what we're dealing with for NFS/RDMA (which
always waits for invalidation before allowing an RPC to
complete).

I tested here with a pair of EDR CX-4s in RoCE mode. I found
that there is a 15-20us latency penalty when Remote Invalid-
ation is used with RDMA Read, but when used with RDMA Write,
Remote Invalidation behaves as desired. The RDMA Read penalty
vanishes after payloads are larger than about 8kB.

Simple QD=1 iozone test with direct I/O on NFSv3, and a tmpfs
share on the NFS server. In this test, memory registration is
used for all data payloads.

Remote Invalidation enabled, reclen in kB, output in
microseconds:

              kB  reclen    write  rewrite    read    reread
          131072       1       47       54       27       27
          131072       2       61       62       27       28
          131072       4       63       62       28       28
          131072       8       59       65       29       29
          131072      16       67       66       31       32
          131072      32       75       73       42       42
          131072      64       92       87       64       44

Remote Invalidation disabled, reclen in kB, output in
microseconds

              kB  reclen    write  rewrite    read    reread
          131072       1       43       43       32       32
          131072       2       45       52       32       32
          131072       4       48       45       32       32
          131072       8       68       64       33       33
          131072      16       74       60       35       35
          131072      32       85       82       49       41
          131072      64      102       98       63       52

I would expect a similar ~5us latency benefit for both RDMA
Reads and RDMA Writes when Remote Invalidation is in use.
Small I/Os involving RDMA Read are precisely where NFS/RDMA
gains the most benefit from Remote Invalidation, so this
result is disappointing.

Unfortunately, the current version of RPC-over-RDMA does not
have the ability to convey an Rkey for the target to invalid-
ate remotely, though that is one of the features being
considered for the next version.

IOPS results (fio 70/30, multi-thread iozone, etc) are very
clearly worse without Remote Invalidation, so I currently
don't plan to submit a patch that allows RI to be disabled
for some NFS/RDMA mounts. Currently the Linux NFS client
indicates to servers that RI is supported whenever FRWR is
supported on the client's HCA. The server is then free to
decide whether to use Send With Invalidate with any Rkey
in the current RPC.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
