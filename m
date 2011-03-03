From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ibdiagpath broken with TCL 8.5
Date: Thu, 03 Mar 2011 16:48:22 +0200
Message-ID: <4D6FAA36.5020502@dev.mellanox.co.il>
References: <4C8F9617.8010400@novell.com> <4CAC9620.9060609@dev.mellanox.co.il>	<4C2744E8AD2982428C5BFE523DF8CDCB4A20B28028@MNEXMB1.qlogic.org>	<4D611F90.5090701@dev.mellanox.co.il>  <4C2744E8AD2982428C5BFE523DF8CDCB4A20B28AFD@MNEXMB1.qlogic.org> <4C2744E8AD2982428C5BFE523DF8CDCB4A20BB3662@MNEXMB1.qlogic.org> <4D6F7133.4030101@dev.mellanox.co.il> <4C2744E8AD2982428C5BFE523DF8CDCB4A20BB37BE@MNEXMB1.qlogic.org>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A20BB37BE-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 03-Mar-11 4:22 PM, Mike Heinz wrote:
> If I get a chance, I'll take a look and see if I find an easy fix.  One simple thing that occurred to me was to modify ibdebug.tcl to  filter the field names out of the output string but I'm not sure what the side-effects would be.

That will probably work for ibdiagpath.
But still, if anyone has some script that uses
ibis, the fix won't resolve the problem for him.

-- YK

> -----Original Message-----
> From: Yevgeny Kliteynik [mailto:kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Thursday, March 03, 2011 5:45 AM
> To: Mike Heinz
> Cc: Linux RDMA; ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; Todd Rimmer
> Subject: Re: ibdiagpath broken with TCL 8.5
> 
> Mike,
> 
> On 01-Mar-11 11:13 PM, Mike Heinz wrote:
>> YK,
>>
>> I had a chance to go back and dig further into this. I just scratch-built the ibis executable on an RHEL6 system, and started running it in interactive mode. What I see is that results that return arrays are getting garbage pre-pended to them - it looks like the root problem that John tried to patch last fall, and that's causing problems for some of my systems here, is that ibis isn't interfacing with TCL 8.5 correctly:
>>
>> % puts [smLftBlockMad dump]
>> -lft 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 % puts [smVlArbTableMad
>> dump] -vl_entry {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00}
>> {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00}
>>
>> I do not see this behavior on systems running TCL 8.4:
>>
>> % ibis_init
>> 0
>> % ibis_set_port 0x00066a00a000707f
>> 0
>> % puts [smLftBlockMad dump]
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
>> 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 % puts [smVlArbTableMad dump]
>> {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0
>> 0x00} {0x0 0x00}
> 
> Interesting. I tried it, and I see same results as you.
> Looks like "dump" is supposed to include field names only if there are more than one field in the object.
> 
> With TCL 8.4, I see this:
> 
> % smVlArbTableMad dump
> {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} {0x0 0x00} % smSwitchInfoMad dump -lin_cap 0 -rand_cap 0 -mcast_cap 0 -lin_top 0 -def_port 0 -def_mcast_pri_port 0 -def_mcast_not_port 0 -life_state 0 -lids_per_port 0 -enforce_cap 0 -flags 0
> 
> So VLArb Table doesn't have field name, while SwitchInfo has all its fields. I see similar behavior with other objects.
> Ibis has an implementation of dump function for "non-trivial" objects (objects that are not just set of standard data types). VLArbTable would be one of them - it consists of VLArbTable Elements, that have their own dump function:
> 
>          %typemap(tcl8, out) ib_vl_arb_element_t[ANY] {
>              int i;
>              char buff[16];
>              for (i=0; i<$dim0 ; i++) {
>                  sprintf(buff, "{0x%x 0x%02x} ", $source[i].vl, $source[i].weight);
>                  Tcl_AppendResult(interp, buff, NULL);
>              }
>          }
> 
>          typedef struct _ibsm_vl_arb_table
>          {
>                  ib_vl_arb_element_t vl_entry[IB_NUM_VL_ARB_ELEMENTS_IN_BLOCK];
>          } smVlArbTable;
> 
> Looks like this behavior has been changed in TCL 8.5.
> IMHO, the TCL 8.5 behavior seems more consistent.
> However, it is clear that in order to support 8.5 and older version, that simple patch is not enough.
> Also, this new behavior will probably break any TCL script that was relaying on the old ibis output...
> 
> If I'm right, then you will see this problem also with smPkeyTableMad, smGuidInfoMad, smVlArbTableMad, smSlVlTableMad, smMftBlockMad, and smLftBlockMad MADs.
> And that's only SM MADs. There are also SA, CC, and others.
> 
> Bottom line, I'm reverting the fix to allow ibdiagpath work on all the distros with TCL 8.4.
> 
> For newer TCL some work needs to be done. To make ibis backward compatible, need to add dump wrapper for ALL the MADs with single field/array.
> 
> -- YK
> 
> 
> 
> 
> 
>>> -----Original Message-----
>>> From: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org [mailto:ewg-
>>> bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org] On Behalf Of Mike Heinz
>>> Sent: Monday, February 21, 2011 11:55 AM
>>> To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
>>> Cc: Linux RDMA; ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>> Subject: Re: [ewg] Patch breaks OFED 1.5.3: [PATCH] ibdiagpath:
>>> Properly index VlArbTable during QoS test
>>>
>>> YK,
>>>
>>> I just finished running an RC4 build on Redhat 6. I didn't get the
>>> same error - but ibdiagpath still failed:
>>>
>>> [root@ifs004 1]# ibdiagpath -l 0x1,0x2 Loading IBDIAGPATH from:
>>> /usr/lib64/ibdiagpath1.5.6
>>> -W- Topology file is not specified.
>>>       Reports regarding cluster links will use direct routes.
>>> Loading IBDM from: /usr/lib64/ibdm1.5.6
>>> -I- Using port 1 as the local port.
>>>
>>> -I---------------------------------------------------
>>> -I- Traversing the path from local to source
>>> -I---------------------------------------------------
>>>
>>> -I---------------------------------------------------
>>> -I- Traversing the path from source to destination
>>> -I---------------------------------------------------
>>> -I- From: lid=0x0001 guid=0x001175000078aca6 dev=29474 ifs004/P1
>>> -I- To:   lid=0x0003 guid=0x00066a01e5000108 dev=29472 Port=8
>>>
>>> -I- From: lid=0x0003 guid=0x00066a01e5000108 dev=29472 Port=8
>>> -I- To:   lid=0x0001 guid=0x001175000078aca6 dev=29474 ifs004/P1
>>>
>>> can't read "PATH(1)": no such element in array
>>> [root@ifs004 1]#
>>>
>>>
>>> The problem appears to be occurring in this code fragment:
>>>
>>>           if {[info exists NODE]} {
>>>               for {set i 0} {$i<   [llength [array names NODE
>>> *,PortGUID]]} {incr i} {
>>>                   set portGuid $NODE($i,PortGUID)
>>>                   set nodeGuid $G(data:NodeGuid.$portGuid)
>>>                   if {$i % 2} {
>>>                   set portNum $NODE($i,EntryPort)
>>>                   } else {
>>>                       set portNum [lindex [split $PATH([expr $i + 1])
>>> ,] end]<<   -- Bug here. Line 2381, ibdebug_if.tcl
>>>                   }
>>>                   lappend CSV_ERRORS
>>> $CSV_scope,$nodeGuid,$portGuid,$portNum,$desc,$msgBody,$CSV_severity,
>>> $e
>>> xid,$err_type
>>>               }
>>>           } else {
>>>               lappend CSV_ERRORS
>>> $CSV_scope,$nodeGuid,$portGuid,$portNum,$desc,$msgBody,$CSV_severity,
>>> $e
>>> xid,$err_type
>>>           }
>>>       }
>>>
>>> I don't know if it matters, but I'm testing with a one-port HCA. I
>>> added a puts in the offending code and got this:
>>>
>>> MHEINZ: i = 0. PATH(0) = 1
>>> can't read "PATH(1)": no such element in array
>>>
>>> Please let me know if there are any tests I can run for you.
>>>
>>> -----Original Message-----
>>> From: Mike Heinz
>>> Sent: Monday, February 21, 2011 10:40 AM
>>> To: 'kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org'; John Jolly
>>> Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; Linux RDMA; Todd Rimmer; Eli Dorfman
>>> (Voltaire)
>>> Subject: RE: Patch breaks OFED 1.5.3: [ewg] [PATCH] ibdiagpath:
>>> Properly index VlArbTable during QoS test
>>>
>>> Yevgeny,
>>>
>>> It did occur to me that this is a version issue; I tested with TCL
>>> 8.4, which is the version included in RHEL5 and SLES10. The newest
>>> version appears to be 8.5, skimming through the release notes I
>>> didn't see anything about languages changes, but if it's working for
>>> you then obviously the language has been changed.
>>>
>>> The thing is, I also noticed that John's original complaint - about
>>> an extra item in the array - did not seem to be true on the RHEL 5.x
>>> boxes I tried, which is why I suggested that the entire change should
>>> be rolled back.
>>>
>>> I'm building RC4 on a Red Hat 6 box now, I'll see if it makes a
>>> difference.
>>>
>>> -----Original Message-----
>>> From: Yevgeny Kliteynik [mailto:kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
>>> Sent: Sunday, February 20, 2011 9:05 AM
>>> To: Mike Heinz; John Jolly
>>> Cc: ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org; Linux RDMA; Todd Rimmer; Eli Dorfman
>>> (Voltaire)
>>> Subject: Re: Patch breaks OFED 1.5.3: [ewg] [PATCH] ibdiagpath:
>>> Properly index VlArbTable during QoS test
>>>
>>> Mike,
>>>
>>> This looks like a different tcl versions/implementation issue.
>>>
>>> I certainly can replace "$i+1" with "[expr $i+1]", but I'm not sure
>>> about reverting the patch.
>>>
>>> John,
>>>
>>> What tcl version have you used?
>>>
>>> -- YK
>>>
>>>
>>>
>>> On 07-Feb-11 6:44 PM, Mike Heinz wrote:
>>>> The version of  ibdiagpath included with OFED 1.5.3-rc3 contains
>>> syntax errors which prevent it from executing on the systems I've
>>> tested (using TCL 8.4).  Attempts to use ibdiagpath fail with an
>>> error
>>> message:
>>>>
>>>>> -I---------------------------------------------------
>>>>> -I- QoS on Path Check
>>>>> -I---------------------------------------------------
>>>>> bad index "0+1": must be integer or end?-integer?
>>>>
>>>> After doing some research and debugging, I traced the problem to a
>>> patch applied back in October:
>>>>
>>>> commit f3cf1f7c15ca24598fdf68b9ba71788b386b2f14
>>>> Author: John Jolly<jjolly-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
>>>> Date:   Wed Oct 6 17:29:48 2010 +0200
>>>>
>>>>        ibdiagpath: Properly index VlArbTable during QoS test
>>>>
>>>>        Description: ibdiagpath: Properly index VlArbTable during QoS
>>> test
>>>>        Symptom:     Error 'invalid bareword "vl_entry"' during "QoS on
>>>>                     Path Check"
>>>>        Problem:     The 'dump' command within the smVlArbTableMad
>>> command
>>>>                     appends '-vl_entry' to the beginning of the array.
>>>>                     The ibdebug.tcl script does not properly handle
>>> this
>>>>                     extra element at the beginning of the array.
>>>>        Solution:    Offset the index value by one when referencing the
>>>>                     array.
>>>>
>>>>        Signed-off-by: John Jolly<jjolly-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
>>>>        Signed-off-by: Yevgeny Kliteynik<kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
>>>>
>>>> Unfortunately, this patch isn't valid TCL code (at least not in TCL
>>> 8.4) and does not appear to be needed at all.
>>>>
>>>> For example:
>>>>
>>>>> set entry [lindex $values $i+1]
>>>>
>>>> Is not syntactically correct TCL.  In order for it to be correct it
>>> would have to be
>>>>
>>>>> set entry [lindex $values [expr $i+1]]
>>>>
>>>> However, the patch does not appear to be needed at all. Reverting
>>>> the
>>> patch, allows ibdiagpath to complete successfully:
>>>>
>>>>> -I---------------------------------------------------
>>>>> -I- QoS on Path Check
>>>>> -I---------------------------------------------------
>>>>> -W- Blocked VLs:3 4 5 at node:homer lid=0x0002
>>> guid=0x00066a00a000707f dev=25208>    port:1
>>>>> -W- SLs:3 4 5 6 7 8 9 10 11 12 13 14 15 are blocked due to VLArb
>>> node:homer
>>>>>        lid=0x0002 guid=0x00066a00a000707f dev=25208 in-port:0 out-
>>> port:1
>>>>> -W- Blocked VLs:3 4 5 at node: lid=0x0001 guid=0x00066a00d9000275
>>> dev=47396
>>>>>        port:21
>>>>> -W- SLs:3 4 5 6 7 8 9 10 11 12 13 14 15 mapped to VL>    5 at node:
>>> lid=0x0001
>>>>>        guid=0x00066a00d9000275 dev=47396 in-port:14 out-port:21
>>>>> -I- The following SLs can be used:0 1 2
>>>>
>>>> This message and any attached documents contain information from
>>> QLogic Corporation or its wholly-owned subsidiaries that may be
>>> confidential. If you are not the intended recipient, you may not
>>> read, copy, distribute, or use this information. If you have received
>>> this transmission in error, please notify the sender immediately by
>>> reply e- mail and then delete this message.
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>>> in
>>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>>>> info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>>
>>>
>>> This message and any attached documents contain information from
>>> QLogic Corporation or its wholly-owned subsidiaries that may be confidential.
>>> If you are not the intended recipient, you may not read, copy,
>>> distribute, or use this information. If you have received this
>>> transmission in error, please notify the sender immediately by reply
>>> e- mail and then delete this message.
>>>
>>> _______________________________________________
>>> ewg mailing list
>>> ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
>>> http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg
>>
>>
>> This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo
>> info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 
> 
> This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
