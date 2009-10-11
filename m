From: Aaron Knister <aaron.knister-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: OpenSM Failover
Date: Sat, 10 Oct 2009 20:02:42 -0400
Message-ID: <CBC039F5-9019-436D-AF6D-F887E860D07B@gmail.com>
References: <B1EF3F77-622B-40DA-BB3D-DC35973B60A6@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B1EF3F77-622B-40DA-BB3D-DC35973B60A6-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I just stumbled across this in the release notes for opensm 3.2.6-

"* SMs do not hand-over when running on ConnectX in a switch-based  
topology."

So I guess that answers the question of whether or not what I'm seeing  
is "expected behavior". Out of curiosity what are the technical  
reasons for this? I just tried opensm 3.3.2 and I still experience the  
same behavior.

On Oct 10, 2009, at 7:38 PM, Aaron Knister wrote:

> I'm not sure if this is the right place to post about this issue,  
> but here goes-
>
> I'm having problems with OpenSM failover.
>
> I have two nodes running opensmd version "3.2.6_20090317" from RHEL  
> 5.4. I'm using a configuration file on both generated using opensm - 
> c. When I start the subnet manager on node a, everything is fine. It  
> appears to reassign itself a lid of 1 which I think is expected.  
> When I started the subnet manager on node b everything is fine. If  
> you query its lid it shows the subnet manager in a standby state.  
> Now for the fun. If I stop opensmd on node a (service opensmd stop)  
> then all of the traffic on the fabric stops. It takes node b's  
> OpenSM instance about 30 seconds to realize that node a's subnet  
> manager is dead and come up in the master state. Now when node a's  
> subnet manager comes back (service opensmd start), all traffic on  
> the fabric stops and node b's subnet manager goes into the standby  
> state...but node a's subnet manager doesn't take over the fabric and  
> come up as master for about another 40 seconds (during this time the  
> no traffic passes over the fabric). The below logs should help  
> illustrate what I'm seeing
>
>
> Oct 10 19:14:14 node-a OpenSM[14132]: Entering DISCOVERING state
> Oct 10 19:14:14 node-a OpenSM[14132]: Entering MASTER state
> Oct 10 19:14:14 node-a OpenSM[14132]: SUBNET UP
>
> Oct 10 19:14:25 node-b OpenSM[11197]: /var/log/opensm.log log file  
> opened
> Oct 10 19:14:25 node-b OpenSM[11197]: OpenSM 3.2.6_20090317
> Oct 10 19:14:25 node-b OpenSM[11197]: Entering DISCOVERING state
> Oct 10 19:14:26 node-b OpenSM[11197]: Entering STANDBY state
>
> Oct 10 19:15:44 node-a OpenSM[14132]: Exiting SM
> Oct 10 19:16:16 node-b OpenSM[11197]: Entering DISCOVERING state
> Oct 10 19:16:16 node-b OpenSM[11197]: Entering MASTER state
>
> Oct 10 19:18:52 node-a OpenSM[14213]: /var/log/opensm.log log file  
> opened
> Oct 10 19:18:52 node-a OpenSM[14213]: OpenSM 3.2.6_20090317
> Oct 10 19:18:52 node-a OpenSM[14213]: Entering DISCOVERING state
> Oct 10 19:18:53 node-b OpenSM[11197]: Entering STANDBY state
> Oct 10 19:18:53 node-a OpenSM[14213]: Entering STANDBY state
> Oct 10 19:19:33 node-a OpenSM[14213]: Entering DISCOVERING state
> Oct 10 19:19:33 node-a OpenSM[14213]: Entering MASTER state
> Oct 10 19:19:33 node-a OpenSM[14213]: SUBNET UP
>
> We have opensm 3.2.5_20081207 (ofed 1.4) on another cluster and it  
> fails over and fails back almost instantly with seemingly no traffic  
> interruption if you gracefully stopped the active opensmd instance  
> (service opensmd stop). Is the behavior I'm seeing considered  
> normal? I can understand the 30 seconds for the initial failover but  
> why the 40 second failback when the original master comes back? Any  
> help is appreciated :)
>
> BTW my switch is a Qlogic 12800-180 with the latest firmware and the  
> HCAs are Mellanox MT26428 running firmware version 2.6.648.
>
> Thanks!
>
> -Aaron

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
