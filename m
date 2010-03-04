From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB issues
Date: Wed, 3 Mar 2010 16:38:30 -0800
Message-ID: <a72123c41003031638g11f0bae6kf4c79da755d52eb3@mail.gmail.com>
References: <a72123c41003021354y7880e74cud26d6010f23f9458@mail.gmail.com>
	 <20100303122937.GA1689@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100303122937.GA1689-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I've applied the patch and initial testing has not produced any
transmit timeout errors.  I'll be doing some heavier testing in the
next couple days, but it looks good so far.  Thanks for the quick
turn-around!

-JE

On Wed, Mar 3, 2010 at 4:29 AM, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrot=
e:
> I just posted a patch which might fix your problem. Please try it and
> let us know if it fixed anything.
>
> On Tue, Mar 02, 2010 at 01:54:09PM -0800, Josh England wrote:
>> Hello,
>>
>> I've been running into several issues using IPoIB. =A0The 2 primary =
uses
>> are for read-only NFS to the clients (over TCP) and access to an
>> ethernet-connected parallel filesystem (Panasas) through router node=
s
>> passing IPoIB<-->10GbE.
>>
>> All nodes are running CentOS 5.3 and OFED 1.4.2, although a have pla=
yed
>> with OFED 1.5 and seen similar results. =A0Client nodes mount their =
NFS root
>> from boot servers via IPoIB with a ratio of 80:1. =A0The boot server=
s are the
>> ones that seem to have issues. =A0The fabric itself consists of ~100=
0 nodes
>> interconnected such that their is 2:1 oversubscription within any si=
ngle rack,
>> and 20:1 oversubscription between racks (through the core switch). =A0=
I
>> don't know how much the oversubscription comes into play here as I c=
an
>> reproduce the error within a single rack.
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
>> The errors seem to hit only after NFS comes into play. =A0Once it
>> starts, the NETDEV WATCHDOG messages continue until I run
>> 'ifconfig ib0 down up'. =A0I've tried tuning send_queue_size and
>> recv_queue_size on both sides, the txqueuelen of the ib0 interface, =
the
>> NFS rsize/wsize. =A0None of it seems to help greatly. =A0Does anyone=
 have
>> any ideas about what can I do to try to fix
>> these problems?
>>
>> -JE
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma=
" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
