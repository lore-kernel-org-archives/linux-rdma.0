From: Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: Re: SDP: test bug 2027 and new error
Date: Wed, 28 Apr 2010 17:15:52 +0300
Message-ID: <4BD84318.7080506@mellanox.co.il>
References: <5464727.1272364442704.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
	<4BD6C9C3.6070905@mellanox.co.il>
	<2307255.1272463222662.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2307255.1272463222662.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

I think this is because sdp_add_device() require FMR to be supported.
I need to put a fix to disable ZCopy and not create FMR pool if doesn't
have support - I thought it would be part of BZ2027 fix.

As a workaround - you could comment out all the calls to
sdp_dev->fmr_pool. and make sure ZCopy is disabled by setting 0 in
sdp_zcopy_thresh.

- Amir

On 04/28/2010 05:00 PM, Andrea Gozzelino wrote:
> On Apr 27, 2010 01:25 PM, Amir Vadai <amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org> wrote:
>
>   
>> Andrea Hi,
>>
>> I am sorry - the commit missed the 24.4.2010 build which I asked you
>> to
>> test.
>> Please test this build (the latest): OFED-1.5.2-20100426-0600
>>
>> - Amir
>>
>>
>> On 04/27/2010 01:34 PM, Andrea Gozzelino wrote:
>>     
>>> Hi Amir, 
>>> I have checked the bug solution with OFED-1.5.2-20100425-0600
>>> version
>>> without success. 
>>>
>>> TEST LOG:
>>> client machine
>>> export LD_PRELOAD=/usr/lib64/libsdp.so
>>> netperf -H address -c -C -l 60 -- -m 65536
>>> tail -f /var/log/libsdp.log 
>>>
>>> OUTPUT
>>> Tue Apr 27 10:08:38 2010 netperf[19051] libsdp Error connect: failed
>>> for
>>> SDP
>>> fd:6 with error:Cannot allocate memory
>>> Tue Apr 27 11:47:55 2010 netperf[19081] libsdp Error connect: failed
>>> for
>>> SDP
>>> fd:6 with error:Cannot allocate memory
>>>
>>> dmesg
>>>
>>> OUTPUT
>>> client_script[13876]: segfault at 00007fffef8de000 rip
>>> 000000387d07ad8a
>>> rsp
>>> 00007fffef8d5648 error 6
>>> C_copiato[20437]: segfault at 00007ffff0257b3c rip 00000000004009e3
>>> rsp
>>> 00007ffff0257b30 error 6
>>> client_20[1539]: segfault at 00007fffa2acd85c rip 0000000000400a80
>>> rsp
>>> 00007fffa2acd850 error 6
>>> sdp_init_qp:95 sdp_sock( 2100:2 55190:0): recv sge's. capability: 4
>>> needed: 9
>>> sdp_init_qp:95 sdp_sock( 2100:2 41003:0): recv sge's. capability: 4
>>> needed: 9
>>> sdp_init_qp:95 sdp_sock( 2100:2 55192:0): recv sge's. capability: 4
>>> needed: 9
>>> sdp_init_qp:95 sdp_sock( 2100:2 38542:0): recv sge's. capability: 4
>>> needed: 9
>>>
>>> ------------------
>>>
>>> server machine
>>> export LD_PRELOAD=/usr/lib64/libsdp.so
>>> netserver 
>>>     Starting netserver at port 12865
>>> Starting netserver at hostname 0.0.0.0 port 12865 and family
>>> AF_UNSPEC
>>>
>>> ------------------
>>> Amir, I think that bug 2028 is also involved in NE020 SDP working. 
>>> Steve, is it possible? 
>>> If yes, I will check the bug 2027 and 2028 solutions in July 2010. 
>>> Is it correct?
>>>
>>> I reopen the bug 2027 because I don't see any changes.
>>> Please consider that the bug 2027 could be connected with the 2028
>>> one
>>> in Bugzilla.
>>>
>>> Keep in touch.
>>> Thank you very much.
>>> Regards,
>>> Andrea
>>>
>>>
>>>
>>>
>>> Andrea Gozzelino
>>>
>>> INFN - Laboratori Nazionali di Legnaro	(LNL)
>>> Viale dell'Universita' 2
>>> I-35020 - Legnaro (PD)- ITALIA
>>> Tel: +39 049 8068346
>>> Fax: +39 049 641925
>>> Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			
>>>   
>>>       
>>     
> Hi Amir,
>
> I have tested your solution of bug 2027 with OFED-1.5.2-20100426-0600.
> Netserver/netperf does not work with Socket Direct Protocol SDP.
>
> Now the error in the log file is:
> libsdp error connect: failed for SDP fd with error No such device
> sdp_init_qp:105 SDP not available on device nes0
>
> I have a look in sdp_cma.c file: I see the message text near the
> previous one about # SGE capability.
>
> Amir, could you please comment these error?
>
> Probably I can close the bug 2027 because the solution is OK and I will
> open another one about "SDP not available on device nes0".
>
> Steve, is there a connession with the Fast Memory Region (bug 2028)?
>
> At the end, #SGE capability is now OK but SDP on NE020 cards - driver
> iw_nes does not work yet properly.
> I will wait your suggestions.
>
> Regards,
> Andrea
>
>
> Andrea Gozzelino
>
> INFN - Laboratori Nazionali di Legnaro	(LNL)
> Viale dell'Universita' 2
> I-35020 - Legnaro (PD)- ITALIA
> Tel: +39 049 8068346
> Fax: +39 049 641925
> Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			
>
>
>   
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
