From: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM Failover
Date: Mon, 12 Oct 2009 09:41:31 -0400
Message-ID: <eafd71280910120641k516ee74bm7e99d1b9935aba8@mail.gmail.com>
References: <B1EF3F77-622B-40DA-BB3D-DC35973B60A6@gmail.com>
	 <CBC039F5-9019-436D-AF6D-F887E860D07B@gmail.com>
	 <4AD2D75A.2020403@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD2D75A.2020403-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Alright I'm sending this for the 3rd time in plain text because
apparently vger wont' take html mail. Fair 'nuff.


I double checked and firmware version 2.6.648 is in use on the cluster
with the failover issue. The cluster that doesn't have the issue is
running a MT25204 Mellanox HCAs with firmware 1.1.0. I'm also curious
about the initial 30 second delay if the active subnet manager is shut
down gracefully. The OpenSMs on the cluster with the MT25204 HCAs
failover instantly when one disappears. I ran opensm with the options
you provided and re-created the failover failback scenario.

On Mon, Oct 12, 2009 at 3:14 AM, Yevgeny Kliteynik
<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
> Aaron,
>
> Aaron Knister wrote:
>>
>> I just stumbled across this in the release notes for opensm 3.2.6-
>>
>> "* SMs do not hand-over when running on ConnectX in a switch-based t=
opology."
>>
>> So I guess that answers the question of whether or not what I'm seei=
ng is "expected behavior". Out of curiosity what are the technical reas=
ons for this? I just tried opensm 3.3.2 and I still experience the same=
 behavior.
>
> There was a hand-over problem in OFED 1.4, but later it turned
> out to be FW issue. The thing is, FW version 2.6.648 doesn't
> have this bug any more...
>
> The 30 seconds for the initial failover is expected, but the 40 secon=
d failback when the original master comes back is a problem.
>
> Can you please double check that the FW version 2.6.648 is used on
> both HCAs that run OSM?
> And what is the FW version of HCAs that don't have this problem?
>
> Also, can you please reproduce the issue running OSM as follows:
> =A0 =A0 =A0 =A0opensm -V -e -s 0
> on both nodes and attach the /var/log/opensm.log files?
>
> -- Yevgeny
>
>
>> On Oct 10, 2009, at 7:38 PM, Aaron Knister wrote:
>>
>>> I'm not sure if this is the right place to post about this issue, b=
ut here goes-
>>>
>>> I'm having problems with OpenSM failover.
>>>
>>> I have two nodes running opensmd version "3.2.6_20090317" from RHEL=
 5.4. I'm using a configuration file on both generated using opensm -c.=
 When I start the subnet manager on node a, everything is fine. It appe=
ars to reassign itself a lid of 1 which I think is expected. When I sta=
rted the subnet manager on node b everything is fine. If you query its =
lid it shows the subnet manager in a standby state. Now for the fun. If=
 I stop opensmd on node a (service opensmd stop) then all of the traffi=
c on the fabric stops. It takes node b's OpenSM instance about 30 secon=
ds to realize that node a's subnet manager is dead and come up in the m=
aster state. Now when node a's subnet manager comes back (service opens=
md start), all traffic on the fabric stops and node b's subnet manager =
goes into the standby state...but node a's subnet manager doesn't take =
over the fabric and come up as master for about another 40 seconds (dur=
ing this time the no traffic passes over the fabric). The below logs sh=
ould help illustrate what I'm seeing
>>>
>>>
>>> Oct 10 19:14:14 node-a OpenSM[14132]: Entering DISCOVERING state
>>> Oct 10 19:14:14 node-a OpenSM[14132]: Entering MASTER state
>>> Oct 10 19:14:14 node-a OpenSM[14132]: SUBNET UP
>>>
>>> Oct 10 19:14:25 node-b OpenSM[11197]: /var/log/opensm.log log file =
opened
>>> Oct 10 19:14:25 node-b OpenSM[11197]: OpenSM 3.2.6_20090317
>>> Oct 10 19:14:25 node-b OpenSM[11197]: Entering DISCOVERING state
>>> Oct 10 19:14:26 node-b OpenSM[11197]: Entering STANDBY state
>>>
>>> Oct 10 19:15:44 node-a OpenSM[14132]: Exiting SM
>>> Oct 10 19:16:16 node-b OpenSM[11197]: Entering DISCOVERING state
>>> Oct 10 19:16:16 node-b OpenSM[11197]: Entering MASTER state
>>>
>>> Oct 10 19:18:52 node-a OpenSM[14213]: /var/log/opensm.log log file =
opened
>>> Oct 10 19:18:52 node-a OpenSM[14213]: OpenSM 3.2.6_20090317
>>> Oct 10 19:18:52 node-a OpenSM[14213]: Entering DISCOVERING state
>>> Oct 10 19:18:53 node-b OpenSM[11197]: Entering STANDBY state
>>> Oct 10 19:18:53 node-a OpenSM[14213]: Entering STANDBY state
>>> Oct 10 19:19:33 node-a OpenSM[14213]: Entering DISCOVERING state
>>> Oct 10 19:19:33 node-a OpenSM[14213]: Entering MASTER state
>>> Oct 10 19:19:33 node-a OpenSM[14213]: SUBNET UP
>>>
>>> We have opensm 3.2.5_20081207 (ofed 1.4) on another cluster and it =
fails over and fails back almost instantly with seemingly no traffic in=
terruption if you gracefully stopped the active opensmd instance (servi=
ce opensmd stop). Is the behavior I'm seeing considered normal? I can u=
nderstand the 30 seconds for the initial failover but why the 40 second=
 failback when the original master comes back? Any help is appreciated =
:)
>>>
>>> BTW my switch is a Qlogic 12800-180 with the latest firmware and th=
e HCAs are Mellanox MT26428 running firmware version 2.6.648.
>>>
>>> Thanks!
>>>
>>> -Aaron
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
