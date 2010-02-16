From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: [ewg] MLX4 Strangeness
Date: Tue, 16 Feb 2010 09:53:24 +0200
Message-ID: <4B7A4EF4.9090209@mellanox.co.il>
References: <4B79AD88.8000101@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B79AD88.8000101-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2/15/2010 10:24 PM, Tom Tucker wrote:
> Hello,
>
> I am seeing some very strange behavior on my MLX4 adapters running 2.7
> firmware and the latest OFED 1.5.1. Two systems are involved and each
> have dual ported MTHCA DDR adapter and MLX4 adapters.
>
> The scenario starts with NFSRDMA stress testing between the two systems
> running bonnie++ and iozone concurrently. The test completes and there
> is no issue. Then 6 minutes pass and the server "times out" the
> connection and shuts down the RC connection to the client.
>
>   From this point on, using the RDMA CM, a new RC QP can be brought up
> and moved to RTS, however, the first RDMA_SEND to the NFS SERVER system
> fails with IB_WC_RETRY_EXC_ERR. I have confirmed:
>
> - that "arp" completed successfully and the neighbor entries are
> populated on both the client and server
> - that the QP are in the RTS state on both the client and server
> - that there are RECV WR posted to the RQ on the server and they did not
> error out
> - that no RECV WR completed successfully or in error on the server
> - that there are SEND WR posted to the QP on the client
> - the client side SEND_WR fails with error 12 as mentioned above
>
> I have also confirmed the following with a different application (i.e.
> rping):
>
> server# rping -s
> client# rping -c -a 192.168.80.129
>
> fails with the exact same error, i.e.
> client# rping -c -a 192.168.80.129
> cq completion failed status 12
> wait for RDMA_WRITE_ADV state 10
> client DISCONNECT EVENT...
>
> However, if I run rping the other way, it works fine, that is,
>
> client# rping -s
> server# rping -c -a 192.168.80.135
>
> It runs without error until I stop it.
>
> Does anyone have any ideas on how I might debug this?
>
>
>    
Tom
What is the vendor syndrome error when you get a completion with error?

Does the issue occurs only on the ConnectX cards (mlx4) or also on the 
InfiniHost cards (mthca)

Tziporet

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
