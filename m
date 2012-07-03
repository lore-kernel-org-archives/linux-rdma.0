From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Q] How to tranfer a file which is over 2GB(2^31) size in RDMA network?
Date: Wed, 4 Jul 2012 07:18:01 +0900
Message-ID: <CA+Tq-Rqm0vVnnvd6Zvtazs=qdwxKuC+9NwPt0LdbVS5HJa8=Ww@mail.gmail.com>
References: <CA+Tq-Rpk-Q74k2z=ToCK+eeDKuF_84fU2t0LwMBM==QG4P8XgA@mail.gmail.com>
	<5D6C0ABE6A236946864C45679362BBE20ACA83E1@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5D6C0ABE6A236946864C45679362BBE20ACA83E1-DWYeeINJQrxExQ8dmkPuX0M9+F4ksjoh@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hello Parav.Pandit

Thank you for your advice.

I'll try it.

--
Hiroyuki Sato

2012/7/3  <Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>:
>
>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
>> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Hiroyuki Sato
>> Sent: Monday, July 02, 2012 7:20 PM
>> To: linux-rdma
>> Subject: [Q] How to tranfer a file which is over 2GB(2^31) size in RDMA
>> network?
>>
>> Dear developers.
>>
>> I'm writing simple file transfer program.
>>
>> I would like to know about the following.
>> Q: How to tranfer a file which is over 2GB(2^31) size  in RDMA network?
>>
>> Please imagine to transfer whole DVD(4.7GB) file via RDMA networok.
>>
>> The maximum message size of RC is 2^31.
>> so I can't transfer it with one RDMA message.
>>
>> Maybe It must split multiple parts.
>> When I sent first part with the following sequence, how to transfer second
>> part?
>>
>> Do I have to call qp ibv_destroy_qp and recreate new qp?
>> Or can I reuse current qp?
>>
> You can use the same QP to send multiple messages of same or different size.
> Receive side needs to have sufficient memory to receive 2GB of data, which you should have posted using post_recv().
> Since you are going to divide a file/consumer application data to multiple RDMA messages, make sure sender and receiver agrees to a message size of interest.
> This is the simplest way to do via RDMA_SEND and RECV buffers.
>
> You can further do it via sharing the stag before invoking post_send/recv and use RDMA Write or READ operations and don't need to synchronize the message size.
> Sender can send/split data into one or more WRITE messages followed by ending it with write_immidiate or send_immidiate to notify the peer of file transfer done.
>
> In a third way, you can void writing the application and use SDP protocol to send your file via FTP/SFTP, in which FTP server and client application sockets use the SDP sockets instead of TCP sockets.
>
>
>> I'm looking for similar example but I can't find it.
>> Any information is welcome.
>>
>> Thank you for your advice.
>>
>> Sincerely
>>
>> --
>> Hiroyuki Sato.
>>
>>
>> File transfer sequence (1st part)
>>
>>   ibv_open_device
>>   ibv_alloc_pd
>>   ibv_reg_mr
>>   ibv_create_cq
>>   ibv_create_qp
>>   ibv_modify_qp(RESET->INIT)
>>   ibv_post_recv
>>   exchange lid, sid,qpn
>>   ibv_connect
>>   ibv_modify_qp(INIT->RTR)
>>   ibv_modify_qp(RTR->RTS)
>>   ibv_post_send
>>   ...
>>
>>
>>
>> Environment
>>  OS Scientific Linux 6.2
>>  OFED: 1.5.4.1
>>
>> --
>> Hiroyuki Sato
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the
>> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
>> http://vger.kernel.org/majordomo-info.html



-- 
Hiroyuki Sato
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
