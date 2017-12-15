From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCHv2 rdma-core 1/2] srp_daemon: handle SM lid change
Date: Fri, 15 Dec 2017 13:41:12 +0100
Message-ID: <5c12ee61-22f3-239d-8fbb-59c381b8ce13@suse.com>
References: <001cdcfd-8ace-261f-ab86-a09ae3582dd8@suse.com>
 <be797b2f-0317-f9ac-d0ec-5284632790b9@suse.com>
 <a4b3d5e1-f611-9305-1ed2-d4a51ebe4611@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a4b3d5e1-f611-9305-1ed2-d4a51ebe4611-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, stable-Xl5UnYtxxKxKUA01WzcqbQ@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Le 15/12/2017 à 12:40, Dennis Dalessandro a écrit :
> On 12/13/2017 7:31 AM, Nicolas Morey-Chaisemartin wrote:
>> When srp_daemon was running and the master SM host changes,
>>   srp_daemon output these errors at every scan:
>> srp_daemon[25394]: No response to inform info registration
>> srp_daemon[25394]: Fail to register to traps, maybe there is no opensm
>>   running on fabric or IB port is down
>>
>> This was introduced by commit 4952e5f Fix a memory leak.
>> A side effect of this patch was that create_ah was only called when the
>>   port lid changes. Which meant register_to_traps used an older, obsolete,
>>   version of sm_lid and failed to connect to it.
>>
>> This patch fixes this behaviour by checking for both local lid changes and
>>   SM lid changes, and calling create_ah on any of these events.
>>
>> Fixes: 4952e5f7 (Fix a memory leak)
>
> Close. You are going to want 12 digits of the SHA, followed by the actual patch subject, the full thing in ("......").
>
> I tried to look at the commit to provide you the actual example but get the following. Make sure the SHA you are using is correct.
>
> $ git show 4952e5f7
> fatal: ambiguous argument '4952e5f7': unknown revision or path not in the working tree.
> Use '--' to separate paths from revisions, like this:
> 'git <command> [<revision>...] -- [<file>...]'

Weird it works for me...
$ git show 4952e5f7
commit 4952e5f7df0c93d6f3972975106c5e06623a301d
Author: Roi Dayan <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date:   Thu Mar 21 17:38:11 2013 +0200

    Fix a memory leak

I used this command  to generate the line
$ git  log -n1 --pretty='%h (%s)' 4952e5f7df0c93d6f3972975106c5e06623a301d
4952e5f7 (Fix a memory leak)

Isn't the abbreviated hash supposed to be enough ?

Nicolas
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
