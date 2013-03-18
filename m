From: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Add fix to  _do_madrpc to set the errno after umad_recv.
Date: Mon, 18 Mar 2013 12:03:55 -0700
Message-ID: <5147651B.5030309@oracle.com>
References: <5122A6D5.10400@oracle.com> <20130226142930.10c27daedb24b768fb979fe9@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130226142930.10c27daedb24b768fb979fe9-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Jia Shi (E-mail)" <JIA.SHI-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Ira,

Thanks for the review.

Sorry for the late reply. My answers are in-lined.

Sarat

On 2/26/2013 2:29 PM, Ira Weiny wrote:
> First, it is not documented that this function will set any errno value.
>
> umad_status is only documented to return ETIMEDOUT which will be returned in the p_error parameter (ib_rpc_t -> rstatus) value when an error occurs.  Is this not sufficient for your needs?

We are not invoking the _do_mad_rpc directly, we are invoking ib_resolve_portid_str_via that does not pass-back any of the ib_rpc_t contents, so we just depend on the return code 
and errno to determine whether a path can be resolved or not.
>
> Secondly, this patch does not apply cleanly.  Please create patches against the current master at:
>
> git://git.openfabrics.org/~iraweiny/libibmad.git

We are working on setting up the the GIT ..

>
> Thirdly, the patch below will set errno on each retry case.  I don't think this is necessary.

Ok I will change the code to return immediately after hitting the E_TIMEDOUT error.

 >>                 status = umad_status(rcvbuf);
 >> +               errno = status;
 >>
 >>                   if (!status)
 >>                      return length;  /* done */
 >>                   if (errno == E_TIMEDOUT)
 >>		        return length;
 >>                   if (status == ENOMEM)
			


>
> Thanks,
> Ira
>
> On Mon, 18 Feb 2013 14:10:29 -0800
> Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
>>    _do_madrpc() (in libibmad-1.3.3/src/rpc.c) sends the mad request through umad_send() and waits for a response from umad_recv() with the timeout passed  by caller. Linux error
>> number sent by peer in 'status' is not copied over to the process/thread local 'errno'.
>>
>> Signed-off-by: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> $diff -Naru rpc.c rpc_fix.c
>> --- rpc.c       2013-02-07 10:28:06.000000000 -0800
>> +++ rpc_fix.c   2013-02-18 13:57:15.000000000 -0800
>> @@ -175,6 +175,7 @@
>>                                            IB_MAD_TRID_F) != trid);
>>
>>                   status = umad_status(rcvbuf);
>> +               errno = status;
>>                   if (!status)
>>                           return length;  /* done */
>>                   if (status == ENOMEM)
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
