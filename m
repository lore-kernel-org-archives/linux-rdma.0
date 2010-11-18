From: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma_lat whos
Date: Thu, 18 Nov 2010 12:36:00 +0200
Message-ID: <4CE50190.3080707@dev.mellanox.co.il>
References: <4CE3B455.4080003@Voltaire.com> <4CE3BCE3.7090107@Voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CE3BCE3.7090107-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Or ,

I will check the issue now.

The latest git tree is available at git://git.openfabrics.org/~shamoya/perftest.git ,
I've just checked it and it works.

Will get back to you soon

Ido

On 11/17/2010 1:30 PM, Or Gerlitz wrote:
> Or Gerlitz wrote:
>> Now, Jack, using this patch,
>> I could get rdma_lat which doesn't use the rdma-cm, which means setting all the low-level QP params
>> "by the hand" to produce the SAME result of 3.9us as with the rdma-cm, as you can see its one liner
>> patch which uses higher MTU of 2048 vs the hard coded MTU of 256 used in the code. This is quite counter
>> intuitive, for packets whose size is>  256, correct? is there any known issue that can
>> explain that?! The SA is convinced that 2048 (0x84) is the best MTU for that path, both nodes
>> have ConnectX DDR with firmware 2.7.0
> running with mtu=256 vs mtu=2048 on various msg size, you can see this phenomena in action
> 2.70us for 1k msg with LOWER mtu vs 3.54us with mtu=2048
>
>> # ib_send_lat -a -m 256 celery
>> ------------------------------------------------------------------
>>                      Send Latency Test
>> Inline data is used up to 400 bytes message
>> Connection type : RC
>>     local address: LID 0x04 QPN 0x4c004b PSN 0xf91b6e
>>    remote address: LID 0x04 QPN 0x4c004a PSN 0xb9e19a
>> Mtu : 256
>> ------------------------------------------------------------------
>>   #bytes #iterations    t_min[usec]    t_max[usec]  t_typical[usec]
>>        2        1000           1.04          10.33             1.06
>>        4        1000           1.03           9.80             1.07
>>        8        1000           1.03           7.89             1.07
>>       16        1000           1.05           7.81             1.09
>>       32        1000           1.09           7.77             1.11
>>       64        1000           1.18           7.99             1.21
>>      128        1000           1.48           8.05             1.51
>>      256        1000           2.06           8.67             2.19
>>      512        1000           2.31          14.38             2.38
>>     1024        1000           2.62          14.54             2.70
>>     2048        1000           3.26          14.90             3.36
>>     4096        1000           4.54          28.84             4.64
>>     8192        1000           7.19          18.48             7.30
>>    16384        1000          12.61          24.15            12.75
>>    32768        1000          23.46          34.77            24.30
>>    65536        1000          45.19          56.48            45.75
>>   131072        1000          88.64         102.99            89.22
>>   262144        1000         175.78         186.59           175.97
>>   524288        1000         349.16         359.92           349.35
>> 1048576        1000         695.80         706.90           696.22
>> 2097152        1000        1389.41        1400.87          1389.95
>> 4194304        1000        2777.21        2799.41          2778.08
>> 8388608        1000        5691.77        5752.48          5737.45
>> ------------------------------------------------------------------
>> All resources were Released successfully
>> # ib_send_lat -a -m 2048 celery
>> ------------------------------------------------------------------
>>                      Send Latency Test
>> Inline data is used up to 400 bytes message
>> Connection type : RC
>>     local address: LID 0x04 QPN 0x54004b PSN 0x59384f
>>    remote address: LID 0x04 QPN 0x54004a PSN 0xcac60e
>> Mtu : 2048
>> ------------------------------------------------------------------
>>   #bytes #iterations    t_min[usec]    t_max[usec]  t_typical[usec]
>>        2        1000           1.02          10.66             1.06
>>        4        1000           1.03          54.53             1.06
>>        8        1000           1.04          36.84             1.06
>>       16        1000           1.05          34.58             1.08
>>       32        1000           1.08          40.70             1.11
>>       64        1000           1.18          66.86             1.21
>>      128        1000           1.48          38.76             1.51
>>      256        1000           2.07          39.15             2.18
>>      512        1000           2.58          45.90             2.67
>>     1024        1000           3.46          38.07             3.54
>>     2048        1000           5.22          40.55             5.31
>>     4096        1000           6.53          39.17             6.61
>>     8192        1000           9.16          38.85             9.29
>>    16384        1000          14.52          50.14            14.99
>>    32768        1000          25.54          51.20            25.64
>>    65536        1000          47.18          59.76            47.30
>>   131072        1000          90.87          96.92            90.99
>>   262144        1000         178.22         183.27           178.37
>>   524288        1000         352.93         358.01           353.13
>> 1048576        1000         702.37         707.69           702.66
>> 2097152        1000        1401.30        1411.63          1401.66
>> 4194304        1000        2799.16        2845.59          2801.92
>> 8388608        1000        5833.30        5911.70          5886.55
>> ------------------------------------------------------------------
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
