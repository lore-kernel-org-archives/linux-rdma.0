From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Possible process deadlock in RMPP flow
Date: Wed, 23 Sep 2009 09:08:28 -0700
Message-ID: <7A32EEE20DF5432CADB60B8F8B1E0093@amr.corp.intel.com>
References: <20090923150454.GA26150@mtls03>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090923150454.GA26150@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Eli Cohen' <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, general-list <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>ibnetdiscover D ffffffff80149b8d     0 26968  26544
>(L-TLB)
> ffff8102c900bd88 0000000000000046 ffff81037e8e0000 ffff81037e8e02e8
> ffff8102c900bd78 000000000000000a ffff8102c5b50820 ffff81038a929820
> 0000011837bf6105 0000000000000ede ffff8102c5b50a08 0000000100000000
>Call Trace:
> [<ffffffff80064207>] wait_for_completion+0x79/0xa2
> [<ffffffff8008b4cc>] default_wake_function+0x0/0xe
> [<ffffffff882271d9>] :ib_mad:ib_cancel_rmpp_recvs+0x87/0xde
> [<ffffffff88224485>] :ib_mad:ib_unregister_mad_agent+0x30d/0x424
> [<ffffffff883983e9>] :ib_umad:ib_umad_close+0x9d/0xd6
> [<ffffffff80012e22>] __fput+0xae/0x198
> [<ffffffff80023de6>] filp_close+0x5c/0x64
> [<ffffffff800393df>] put_files_struct+0x63/0xae
> [<ffffffff80015b26>] do_exit+0x31c/0x911
> [<ffffffff8004971a>] cpuset_exit+0x0/0x6c
> [<ffffffff8005e116>] system_call+0x7e/0x83
>
>From the dump it seems that the process is waits on the call to
>flush_workqueue() in ib_cancel_rmpp_recvs(). The package they use is
>OFED 1.4.2.

Roland just submitted a patch in this area yesterday.  I don't know if the patch
would fix their issue, but it may be worth trying.  What kernel does 1.4.2 map
to?

What RMPP messages does ibnetdiscover use?  If the program is completing
successfully, there may be a different race with the rmpp cleanup.  I'll see if
anything else stands out in that area.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
