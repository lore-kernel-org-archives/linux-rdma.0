From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Connect-IB not performing as well as ConnectX-3 with iSER
Date: Wed, 8 Jun 2016 16:52:54 +0300
Message-ID: <57582336.10407@mellanox.com>
References: <CAANLjFoL5zow4f4RXP5t8LM7wsWN1OQ-hD2mtPUBTLkJ7UZ5kA@mail.gmail.com>
 <5756B7D2.5040009@mellanox.com>
 <CAANLjFq4CoOSbng=aPHiSsFB=1HMSwAhhLiCjt+88dzz24OT9w@mail.gmail.com>
 <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFoLJNQWtHHqjHmhc0iBq14NAV_GgkbyQabjzyeN56t+Ow-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 6/8/2016 1:37 AM, Robert LeBlanc wrote:
> On the 4.1.15 kernel:
> sdc;10.218.128.17;3971878;992969;21120
> sdd;10.218.202.17;3967745;991936;21142
> sdg;10.218.203.17;3938128;984532;21301
> sdk;10.218.204.17;3952602;988150;21223
> sdn;10.219.128.17;4615719;1153929;18174
> sdf;10.219.202.17;4622331;1155582;18148
> sdi;10.219.203.17;4602297;1150574;18227
> sdl;10.219.204.17;4565477;1141369;18374
> sde;10.220.128.17;4594986;1148746;18256
> sdh;10.220.202.17;4590209;1147552;18275
> sdj;10.220.203.17;4599017;1149754;18240
> sdm;10.220.204.17;4610898;1152724;18193
>
> On the 4.6.0 kernel:
> sdc;10.218.128.17;3239219;809804;25897
> sdf;10.218.202.17;3321300;830325;25257
> sdm;10.218.203.17;3339015;834753;25123
> sdk;10.218.204.17;3637573;909393;23061
> sde;10.219.128.17;3325777;831444;25223
> sdl;10.219.202.17;3305464;826366;25378
> sdg;10.219.203.17;3304032;826008;25389
> sdn;10.219.204.17;3330001;832500;25191
> sdd;10.220.128.17;4624370;1156092;18140
> sdi;10.220.202.17;4619277;1154819;18160
> sdj;10.220.203.17;4610138;1152534;18196
> sdh;10.220.204.17;4586445;1146611;18290
>
> It seems that there is a lot of changes between the kernels. I had
> these kernels already on the box and I can bisect them if you think it
> would help. It is really odd that port 2 on the Connect-IB card did
> better than port 1 on the 4.6.0 kernel.
> ----------------
> Robert LeBlanc
> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1

so in these kernels you get better performance with the C-IB than CX3 ?
we need to find the bottleneck.
Can you increase the iodepth and/or block size to see if we can reach 
the wire speed.
another try is to load ib_iser with always_register=N.

what is the cpu utilzation in both initiator/target ?
did you spread the irq affinity ?

>
>
> On Tue, Jun 7, 2016 at 10:48 AM, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org> wrote:
>> The target is LIO (same kernel) with a 200 GB RAM disk and I'm running
>> fio as follows:
>>
>> fio --rw=read --bs=4K --size=2G --numjobs=40 --name=worker.matt
>> --group_reporting --minimal |  cut -d';' -f7,8,9
>>
>> All of the paths are set the same with noop and nomerges to either 1
>> or 2 (doesn't make a big difference).
>>
>> I started looking into this when the 4.6 kernel wasn't performing as
>> well as we were able to get the 4.4 kernel to work. I went back to the
>> 4.4 kernel and I could not replicate the 4+ million IOPs. So I started
>> breaking down the problem to smaller pieces and found this anomaly.
>> Since there hasn't been any suggestions up to this point, I'll check
>> other kernel version to see if it is specific to certain kernels. If
>> you need more information, please let me know.
>>
>> Thanks,
>> ----------------
>> Robert LeBlanc
>> PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
>>
>>
>> On Tue, Jun 7, 2016 at 6:02 AM, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>>
>>>
>>> On 6/7/2016 1:36 AM, Robert LeBlanc wrote:
>>>>
>>>> I'm trying to understand why our Connect-IB card is not performing as
>>>> well as our ConnectX-3 card. There are 3 ports between the two cards
>>>> and 12 paths to the iSER target which is a RAM disk.
>>>
>>>
>>> <snip>
>>>
>>>>
>>>> When I run fio against each path individually, I get:
>>>
>>>
>>> What is the scenario (bs, numjobs, iodepth) for each run ?
>>> Which target do you use ? backing store ?
>>>
>>>
>>>>
>>>> disk;target IP;bandwidth,IOPs,Execution time
>>>> sdn;10.218.128.17;5053682;1263420;16599
>>>> sde;10.218.202.17;5032158;1258039;16670
>>>> sdh;10.218.203.17;4993516;1248379;16799
>>>> sdk;10.218.204.17;5081848;1270462;16507
>>>> sdc;10.219.128.17;3750942;937735;22364
>>>> sdf;10.219.202.17;3746921;936730;22388
>>>> sdi;10.219.203.17;3873929;968482;21654
>>>> sdl;10.219.204.17;3841465;960366;21837
>>>> sdd;10.220.128.17;3760358;940089;22308
>>>> sdg;10.220.202.17;3866252;966563;21697
>>>> sdj;10.220.203.17;3757495;939373;22325
>>>> sdm;10.220.204.17;4064051;1016012;20641
>>>>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
