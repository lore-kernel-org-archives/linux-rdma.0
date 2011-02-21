From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Patch breaks OFED 1.5.3: [ewg] [PATCH] ibdiagpath: Properly
 index VlArbTable during QoS test
Date: Mon, 21 Feb 2011 09:40:20 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28ADE@MNEXMB1.qlogic.org>
References: <4C8F9617.8010400@novell.com>
 <4CAC9620.9060609@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28028@MNEXMB1.qlogic.org>
 <4D611F90.5090701@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D611F90.5090701-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, John Jolly <jjolly-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Cc: "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yevgeny,

It did occur to me that this is a version issue; I tested with TCL 8.4, which is the version included in RHEL5 and SLES10. The newest version appears to be 8.5, skimming through the release notes I didn't see anything about languages changes, but if it's working for you then obviously the language has been changed.

The thing is, I also noticed that John's original complaint - about an extra item in the array - did not seem to be true on the RHEL 5.x boxes I tried, which is why I suggested that the entire change should be rolled back.

I'm building RC4 on a Red Hat 6 box now, I'll see if it makes a difference.

-----Original Message-----
From: Yevgeny Kliteynik [mailto:kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
Sent: Sunday, February 20, 2011 9:05 AM
To: Mike Heinz; John Jolly
Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; Linux RDMA; Todd Rimmer; Eli Dorfman (Voltaire)
Subject: Re: Patch breaks OFED 1.5.3: [ewg] [PATCH] ibdiagpath: Properly index VlArbTable during QoS test

Mike,

This looks like a different tcl versions/implementation issue.

I certainly can replace "$i+1" with "[expr $i+1]", but I'm not
sure about reverting the patch.

John,

What tcl version have you used?

-- YK



On 07-Feb-11 6:44 PM, Mike Heinz wrote:
> The version of  ibdiagpath included with OFED 1.5.3-rc3 contains syntax errors which prevent it from executing on the systems I've tested (using TCL 8.4).  Attempts to use ibdiagpath fail with an error message:
>
>> -I---------------------------------------------------
>> -I- QoS on Path Check
>> -I---------------------------------------------------
>> bad index "0+1": must be integer or end?-integer?
>
> After doing some research and debugging, I traced the problem to a patch applied back in October:
>
> commit f3cf1f7c15ca24598fdf68b9ba71788b386b2f14
> Author: John Jolly<jjolly-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
> Date:   Wed Oct 6 17:29:48 2010 +0200
>
>      ibdiagpath: Properly index VlArbTable during QoS test
>
>      Description: ibdiagpath: Properly index VlArbTable during QoS test
>      Symptom:     Error 'invalid bareword "vl_entry"' during "QoS on
>                   Path Check"
>      Problem:     The 'dump' command within the smVlArbTableMad command
>                   appends '-vl_entry' to the beginning of the array.
>                   The ibdebug.tcl script does not properly handle this
>                   extra element at the beginning of the array.
>      Solution:    Offset the index value by one when referencing the
>                   array.
>
>      Signed-off-by: John Jolly<jjolly-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
>      Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>
> Unfortunately, this patch isn't valid TCL code (at least not in TCL 8.4) and does not appear to be needed at all.
>
> For example:
>
>> set entry [lindex $values $i+1]
>
> Is not syntactically correct TCL.  In order for it to be correct it would have to be
>
>> set entry [lindex $values [expr $i+1]]
>
> However, the patch does not appear to be needed at all. Reverting the patch, allows ibdiagpath to complete successfully:
>
>> -I---------------------------------------------------
>> -I- QoS on Path Check
>> -I---------------------------------------------------
>> -W- Blocked VLs:3 4 5 at node:homer lid=0x0002 guid=0x00066a00a000707f dev=25208>  port:1
>> -W- SLs:3 4 5 6 7 8 9 10 11 12 13 14 15 are blocked due to VLArb node:homer
>>      lid=0x0002 guid=0x00066a00a000707f dev=25208 in-port:0 out-port:1
>> -W- Blocked VLs:3 4 5 at node: lid=0x0001 guid=0x00066a00d9000275 dev=47396
>>      port:21
>> -W- SLs:3 4 5 6 7 8 9 10 11 12 13 14 15 mapped to VL>  5 at node: lid=0x0001
>>      guid=0x00066a00d9000275 dev=47396 in-port:14 out-port:21
>> -I- The following SLs can be used:0 1 2
>
> This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
