From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: back to back RDMA read fail?
Date: Wed, 11 Nov 2009 11:52:41 +0200
Message-ID: <4AFA8969.501@gmail.com>
References: <7d5928b30911092036v6d1196a8m53287dc5eebb654d@mail.gmail.com>	 <7d5928b30911092103r5b730091jd2ca2581f540ea3d@mail.gmail.com>	 <00ca01ca61d3$fd4dd290$f7e977b0$@com> <7d5928b30911100731o24941445wfb8be19e2b0cc1fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7d5928b30911100731o24941445wfb8be19e2b0cc1fb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: neutron <neutronsharc-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi.

how do you connect the QPs?
via CM/CMA or by sockets (and you actually call the ibv_modify_qp)?

Dotan

neutron wrote:
> Hi Paul, thanks a lot for your quick reply!
>
> In my test,  client informs the server of its local memory (rkey,
> addr, size) by sending 4 back to back messages,  each message elicits
> a RDMA read request (RR) from the server.
>
> In other words, client exposes its memory to the server, and server
> RDMA reads it.
>
> As far as RDMA read is concerned, server is a requester, and client is
> a responder, right?
>
> The error I encountered happens at the initial phase, when client
> sends 4 back to back messages to server(using ibv_post_send ),
> containing (rkey, addr, size) client's local memory.
>
> In these 4 ibv_post_send(), client will see one failure.   At server
> side, server has already posted enough WQs in the RQ.  The failures
> are included in my first email.
>
> Looking at the program output, it appears that, server gets messages
> 1, issues RR 1, gets message 2, issues RR 2.    But somehow client
> reports that "send message 2" fails.
>
> On the contrary, server reports "receive message 3" fails.
>
> As a result, server gets message 1,2,4, and succeeds with RR 1,2,4.
> But clients sees that message 2 fails, and succeed with message 1,3,4.
>   This inconsistency is the problem that puzzled me.
>
> ------------
> By the way, how to interpret the parameters for RDMA, and what are
> parameters that control RDMA behavior?  Below are something I can
> find, there must be more....
>
>    max_qp_rd_atom:                 4
>    max_res_rd_atom:                258048
>    max_qp_init_rd_atom:            128
>
>    qp_attr.max_dest_rd_atomic
>    qp_attr.max_rd_atomic
>
>
>
> -neutron
>
>
>
> On Tue, Nov 10, 2009 at 2:04 AM, Paul Grun <pgrun-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>   
>> Is it possible that you exceeded the number of available RDMA Read Resources
>> available on the server?  There is an expectation that the client knows how
>> many outstanding RDMA Read Requests the responder (server) is capable of
>> handling; if the requester (client) exceeds that number, the responder will
>> indeed return a NAK-Invalid Request.  Sounds like your server is configured
>> to accept three outstanding RDMA Read Requests.
>> This also explains why it works when you pause the program periodically...it
>> gives the responder time to generate the RDMA Read Responses and therefore
>> free up some resources to be used in receiving the next incoming RDMA Read
>> Request.
>>
>> -Paul
>>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of neutron
>> Sent: Monday, November 09, 2009 9:04 PM
>> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: back to back RDMA read fail?
>>
>> Hi all,
>>
>> I have a simple program that test back to back RDMA read performance.
>> However I encountered errors for unknown reasons.
>>
>> The basic flow of my program is:
>>
>> client:
>> ibv_post_send() to send 4 back to back messages to server (no delay
>> inbetween). Each message contains the (rkey, addr, size) of a local
>> buffer. The buffer is registered with remote-read/write/ permissions.
>> After that, ibv_poll_cq() is called to wait for completion.
>>
>> server:
>> First, enough receive WRs are posted to the RQ.  Upon receipt of each
>> message, immediately post a RDMA read request, using the (rkey, addr,
>> size) information contained in the originating message.
>>
>> --------------
>> Both client and server use RC QP.  Some errors are observed.
>>
>> On client side,  ibv_poll_cq() gets 4 CQE, one out of the 4 CQE is an error:
>> CQ::  wr_id=0x0, wc_opcode=IBV_WC_SEND, wc_status=remote invalid RD
>> request, wc_flag=0x3b
>>      byte_len=11338758, immdata=1110104528, qp_num=0x0, src_qp=2290530758
>>
>> The other 3 CQE are success.
>>
>> On server side,
>> 3 of the 4 messages are successfully received. One message produces an
>> error CQE:
>> CQ::  wr_id=0x8000000000, wc_opcode=Unknow-wc-opcode,
>> wc_status=unknown, wc_flag=0x0
>>      byte_len=9569287, immdata=0, qp_num=0x0, src_qp=265551872
>>
>> The 3 RDMA read corresponding to the successful receive all succeed.
>>
>> But, if I pause the client program for a short while( usleep(100) for
>> example ) after calling ibv_post_send(), then no error occurs.
>> Anyone can point out the pitfall here? Thanks!
>>
>>
>> -----------
>> On both client and server, I'm using  'mthca0' type MT25208.  The QPs
>> are initialized with "qp_attr.max_dest_rd_atomic=4,
>> qp_attr.max_rd_atomic = 4".  The QP's "devinfo -v" gives the
>> information:
>>
>> hca_id: mthca0
>>        fw_ver:                         5.1.400
>>        node_guid:                      0002:c902:0023:c04c
>>        sys_image_guid:                 0002:c902:0023:c04f
>>        vendor_id:                      0x02c9
>>        vendor_part_id:                 25218
>>        hw_ver:                         0xA0
>>        board_id:                       MT_0370130002
>>        phys_port_cnt:                  2
>>        max_mr_size:                    0xffffffffffffffff
>>        page_size_cap:                  0xfffff000
>>        max_qp:                         64512
>>        max_qp_wr:                      16384
>>        device_cap_flags:               0x00001c76
>>        max_sge:                        27
>>        max_sge_rd:                     0
>>        max_cq:                         65408
>>        max_cqe:                        131071
>>        max_mr:                         131056
>>        max_pd:                         32764
>>        max_qp_rd_atom:                 4
>>        max_ee_rd_atom:                 0
>>        max_res_rd_atom:                258048
>>        max_qp_init_rd_atom:            128
>>        max_ee_init_rd_atom:            0
>>        atomic_cap:                     ATOMIC_HCA (1)
>>        max_ee:                         0
>>        max_rdd:                        0
>>        max_mw:                         0
>>        max_raw_ipv6_qp:                0
>>        max_raw_ethy_qp:                0
>>        max_mcast_grp:                  8192
>>        max_mcast_qp_attach:            56
>>        max_total_mcast_qp_attach:      458752
>>        max_ah:                         0
>>        max_fmr:                        0
>>        max_srq:                        960
>>        max_srq_wr:                     16384
>>        max_srq_sge:                    27
>>        max_pkeys:                      64
>>        local_ca_ack_delay:             15
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
