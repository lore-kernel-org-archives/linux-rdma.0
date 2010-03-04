From: Mahesh Siddheshwar <siddheshwar.mahesh-xsfywfwIY+M@public.gmane.org>
Subject: Re: [ewg] nfsrdma fails to write big file,
Date: Thu, 04 Mar 2010 08:43:35 -0800
Message-ID: <4B8FE337.7050001@sun.com>
References: <9FA59C95FFCBB34EA5E42C1A8573784F02662E58@mtiexch01.mti.com> <4B82D1B4.2030902@opengridcomputing.com> <9FA59C95FFCBB34EA5E42C1A8573784F02662EA8@mtiexch01.mti.com> <9FA59C95FFCBB34EA5E42C1A8573784F02663166@mtiexch01.mti.com> <ada3a0q1mje.fsf@roland-alpha.cisco.com> <4B89EF88.1030903@opengridcomputing.com> <4B8EC600.9050101@sun.com> <4B8EE813.2010205@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B8EE813.2010205-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Tom Tucker wrote:
> Mahesh Siddheshwar wrote:
>> Hi Tom, Vu,
>>
>> Tom Tucker wrote:
>>> Roland Dreier wrote:
>>>>  > +               /*  > +                * Add room for frmr 
>>>> register and invalidate WRs
>>>>  > +                * Requests sometimes have two chunks, each chunk
>>>>  > +                * requires to have different frmr. The safest
>>>>  > +                * WRs required are max_send_wr * 6; however, we
>>>>  > +                * get send completions and poll fast enough, it
>>>>  > +                * is pretty safe to have max_send_wr * 4.  > 
>>>> +                */
>>>>  > +               ep->rep_attr.cap.max_send_wr *= 4;
>>>>
>>>> Seems like a bad design if there is a possibility of work queue
>>>> overflow; if you're counting on events occurring in a particular order
>>>> or completions being handled "fast enough", then your design is 
>>>> going to
>>>> fail in some high load situations, which I don't think you want.   
>>>
>>> Vu,
>>>
>>> Would you please try the following:
>>>
>>> - Set the multiplier to 5
>> While trying to test this between a Linux client and Solaris server,
>> I made the following changes in :
>> /usr/src/ofa_kernel-1.5.1/net/sunrpc/xprtrdma/verbs.c
>>
>> diff verbs.c.org verbs.c
>> 653c653
>> <               ep->rep_attr.cap.max_send_wr *= 3;
>> ---
>> >               ep->rep_attr.cap.max_send_wr *= 8;
>> 685c685
>> <       ep->rep_cqinit = ep->rep_attr.cap.max_send_wr/2 /*  - 1*/;
>> ---
>> >       ep->rep_cqinit = ep->rep_attr.cap.max
>>
>> (I bumped it to 8)
>>
>> did make install.
>> On reboot I see the errors on NFS READs as opposed to WRITEs
>> as seen before, when I try to read a 10G file from the server.
>>
>> The client is running: RHEL 5.3 (2.6.18-128.el5PAE) with
>> OFED-1.5.1-20100223-0740 bits. The client has an Sun IB
>> HCA: SUN0070130001, MT25418, 2.7.0 firmware, hw_rev = a0.
>> The server is running Solaris based on snv_128.
>>
>> rpcdebug output from the client:
>>
>> ==
>> RPC:    85 call_bind (status 0)
>> RPC:    85 call_connect xprt ec78d800 is connected
>> RPC:    85 call_transmit (status 0)
>> RPC:    85 xprt_prepare_transmit
>> RPC:    85 xprt_cwnd_limited cong = 0 cwnd = 8192
>> RPC:    85 rpc_xdr_encode (status 0)
>> RPC:    85 marshaling UNIX cred eddb4dc0
>> RPC:    85 using AUTH_UNIX cred eddb4dc0 to wrap rpc data
>> RPC:    85 xprt_transmit(164)
>> RPC:       rpcrdma_inline_pullup: pad 0 destp 0xf1dd1410 len 164 
>> hdrlen 164
>> RPC:       rpcrdma_register_frmr_external: Using frmr ec7da920 to map 
>> 4 segments
>> RPC:       rpcrdma_create_chunks: write chunk elem 
>> 16384@0x38536d000:0xa601 (more)
>> RPC:       rpcrdma_register_frmr_external: Using frmr ec7da960 to map 
>> 1 segments
>> RPC:       rpcrdma_create_chunks: write chunk elem 
>> 108@0x31dd153c:0xaa01 (last)
>> RPC:       rpcrdma_marshal_req: write chunk: hdrlen 68 rpclen 164 
>> padlen 0 headerp 0xf1dd124c base 0xf1dd136c lkey 0x500
>> RPC:    85 xmit complete
>> RPC:    85 sleep_on(queue "xprt_pending" time 4683109)
>> RPC:    85 added to queue ec78d994 "xprt_pending"
>> RPC:    85 setting alarm for 60000 ms
>> RPC:       wake_up_next(ec78d944 "xprt_resend")
>> RPC:       wake_up_next(ec78d8f4 "xprt_sending")
>> RPC:       rpcrdma_qp_async_error_upcall: QP error 3 on device mlx4_0 
>> ep ec78db40
>> RPC:    85 __rpc_wake_up_task (now 4683110)
>> RPC:    85 disabling timer
>> RPC:    85 removed from queue ec78d994 "xprt_pending"
>> RPC:       __rpc_wake_up_task done
>> RPC:    85 __rpc_execute flags=0x1
>> RPC:    85 call_status (status -107)
>> RPC:    85 call_bind (status 0)
>> RPC:    85 call_connect xprt ec78d800 is not connected
>> RPC:    85 xprt_connect xprt ec78d800 is not connected
>> RPC:    85 sleep_on(queue "xprt_pending" time 4683110)
>> RPC:    85 added to queue ec78d994 "xprt_pending"
>> RPC:    85 setting alarm for 60000 ms
>> RPC:       rpcrdma_event_process: event rep ec116800 status 5 opcode 
>> 80 length 2493606
>> RPC:       rpcrdma_event_process: recv WC status 5, connection lost
>> RPC:       rpcrdma_conn_upcall: disconnected: ec78dbccI4:20049 (ep 
>> 0xec78db40 event 0xa)
>> RPC:       rpcrdma_conn_upcall: disconnected
>> rpcrdma: connection to ec78dbccI4:20049 closed (-103)
>> RPC:       xprt_rdma_connect_worker: reconnect
>> ==
>>
>> On the server I see:
>>
>> Mar  3 17:45:16 elena-ar hermon: [ID 271130 kern.notice] NOTICE: 
>> hermon0: Device Error: CQE remote access error
>> Mar  3 17:45:16 elena-ar nfssrv: [ID 819430 kern.notice] NOTICE: NFS: 
>> bad sendreply
>> Mar  3 17:45:21 elena-ar hermon: [ID 271130 kern.notice] NOTICE: 
>> hermon0: Device Error: CQE remote access error
>> Mar  3 17:45:21 elena-ar nfssrv: [ID 819430 kern.notice] NOTICE: NFS: 
>> bad sendreply
>>
>> The remote access error is actually seen on RDMA_WRITE.
>> Doing some more debug on the server with DTrace, I see that
>> the destination address and length matches the write chunk
>> element in the Linux debug output above.
>>
>>
>>  0   9385                  rib_write:entry daddr 38536d000, len 4000, 
>> hdl a601
>>  0   9358         rib_init_sendwait:return ffffff44a715d308
>>  1   9296       rib_svc_scq_handler:return 1f7
>>  1   9356              rib_sendwait:return 14
>>  1   9386                 rib_write:return 14
>>
>> ^^^ that is RDMA_FAILED in
>>  1  63295    xdrrdma_send_read_data:return 0
>>  1   5969              xdr_READ3res:return
>>  1   5969              xdr_READ3res:return 0
>>
>> Is this a variation of the previously discussed issue or something new?
>>
>
> I think this is new. This seems to be some kind of base/bounds or 
> access violation or perhaps an invalid rkey.
>
Thanks for checking, Tom. I can file a new bug against this. The
test setup is a DDR HCA (client) connected to a DDR Voltaire Switch,
connected to a QDR HCA (server, but limited to PCI-gen1). I have
not seen this on a similar setup with both client/server configured with
QDR HCAs.

What type of debug info would you need to debug this further?

Thanks,
Mahesh
>> Thanks,
>> Mahesh
>>
>>> - Set the number of buffer credits small as follows "echo 4 > 
>>> /proc/sys/sunrpc/rdma_slot_table_entries"
>>> - Rerun your test and see if you can reproduce the problem?
>>>
>>> I did the above and was unable to reproduce, but I would like to see 
>>> if you can to convince ourselves that 5 is the right number.
>>>
>>> Thanks,
>>> Tom
>>>
>>>>  - R.
>>>>   
>>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
