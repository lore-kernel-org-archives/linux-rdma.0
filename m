From: Moni Shoua <monis-hKgKHo2Ms0F+cjeuK/JdrQ@public.gmane.org>
Subject: Re: IPoIB issues
Date: Wed, 10 Mar 2010 17:30:38 +0200
Message-ID: <4B97BB1E.7010900@Voltaire.COM>
References: <a72123c41003021354y7880e74cud26d6010f23f9458@mail.gmail.com> <20100303122937.GA1689@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100303122937.GA1689-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> I just posted a patch which might fix your problem. Please try it and
> let us know if it fixed anything.
> 
Hi Eli
Although Josh already reported that the patch seems to fix the issue I have a question though.

"post_send failed" prints were during work in datagram mode. I don't know if Josh verified 
that but I don't expect that these prints would go away, even with the patch. Am I right?

BTW, what could be the reason for UD QP post_send() failures?

>>
>> In datagram mode, I see errors on the boot servers of the form.
>>
>> ib0: post_send failed
>> ib0: post_send failed
>> ib0: post_send failed
>>
>>
>> When using connected mode, I hit a different error:
>>
>> NETDEV WATCHDOG: ib0: transmit timed out
>> ib0: transmit timeout: latency 1999 msecs
>> ib0: queue stopped 1, tx_head 2154042680, tx_tail 2154039464
>> NETDEV WATCHDOG: ib0: transmit timed out
>> ib0: transmit timeout: latency 2999 msecs
>> ib0: queue stopped 1, tx_head 2154042680, tx_tail 2154039464
>> ...
>> ...
>> NETDEV WATCHDOG: ib0: transmit timed out
>> ib0: transmit timeout: latency 61824999 msecs
>> ib0: queue stopped 1, tx_head 2154042680, tx_tail 2154039464
>>
>>
>> The errors seem to hit only after NFS comes into play.  Once it
>> starts, the NETDEV WATCHDOG messages continue until I run
>> 'ifconfig ib0 down up'.  I've tried tuning send_queue_size and
>> recv_queue_size on both sides, the txqueuelen of the ib0 interface, the
>> NFS rsize/wsize.  None of it seems to help greatly.  Does anyone have
>> any ideas about what can I do to try to fix
>> these problems?
>>
>> -JE
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
