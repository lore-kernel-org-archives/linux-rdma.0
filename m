From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: SRP automatic target discovery
Date: Wed, 02 Feb 2011 19:59:25 -0500
Message-ID: <4D49FDED.2050601@vlnb.net>
References: <4D49BE2B.3000503@hpc.ufl.edu> <1296693893.20674.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296693893.20674.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: Craig Prescott <prescott-rKMKKiNZRMeVc3sceRu5cw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

David Dillow, on 02/02/2011 07:44 PM wrote:
> On Wed, 2011-02-02 at 15:27 -0500, Craig Prescott wrote:
>> But if I add an additional target on the same target machine with, say:
>>
>> [root@hpcoss1 ~]# echo "add 7:0:1:0 3" 
>>  >/proc/scsi_tgt/groups/Default/devices
>>
>> the srp_daemon on the initiator never sees the new storage and 
>> restarting srp_daemon doesn't seem to help.
>>
>> If I remove the SRP scsi devices, unload the ib_srp module, and reload 
>> it, I can see the new LUN (and I don't need to restart srp_daemon, 
>> either).  But I don't think that is how it is supposed to work.
> 
> Sounds about right for the existing code. There's no notification to the
> initiator that you added a new LUN on an existing connection, so the LUN
> will not show up on the client. There is a mechanism in the SCSI
> standard for such things, but the Linux SCSI mid-layer does not
> currently implement it.

I'm sorry, but I need to correct you. There is notification to the
initiator that you added a new LUN on an existing connection. It is
REPORT LUNS DATA HAVE CHANGED Unit Attention. SCST sends it. But it
isn't processed anyhow on the initiator.

Vlad
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
