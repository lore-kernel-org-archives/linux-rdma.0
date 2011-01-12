From: "J.L. Burr" <jlburr-vna1KIf7WgpBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 0/1] mthca: Modify to support embedded PowerPC platforms
Date: Tue, 11 Jan 2011 20:28:45 -0500
Message-ID: <4D2D03CD.6060802@cadence.com>
References: <ig5usq$tgi$1@dough.gmane.org> <adalj2xb6h0.fsf@cisco.com>	<ada4o9lb42k.fsf@cisco.com> <ig6m82$k8i$1@dough.gmane.org>	<adazkrcabt7.fsf@cisco.com> <4D293FFE.7000901@cadence.com> <ada4o9h9ueg.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada4o9h9ueg.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I found the problem:

"We have met the enemy and he is us."

> OK, that's very interesting information.  The effect of that flag is to
> have the driver write firmware commands into the doorbell region (BAR 2)
> instead of the command region (BAR 0).  And it seems writes to the
> doorbell region are getting lost on your system (that might also explain
> why there were no packets received without the fw_cmd_doorbell flag;
> receives are posted to the HCA by doorbell writes too).  I suspect if we
> could get fw_cmd_doorbell=1 working on your system then that would fix
> everything else too.

Your insight that BAR 2 was not working while BAR 0 was working was 
extremely helpful!

BAR 2 uses the prefetchable attribute and is the only prefetchable 
memory in my system.  Then I remembered that we use a quirk routine to 
allocate resources for a custom device.  This is needed because the 
custom device has a huge BAR (petabyte in size), much larger than can be 
mapped to the 440.

The quirk routine forcibly changes the parent bridges' prefetchable 
ranges to accommodate the custom device's petabyte BAR address value. 
This is because only prefetchable ranges in the bridges accommodate 
64-bit PCIe addresses.  But the quirk routine does this change without 
regard to any prefetchable ranges already established by Linux 
enumeration in the parent bridges.  That is, it implicitly assumes there 
are no other prefetchable devices in the system.

Therefore, the quirk routine left the system with no viable forwarding 
path through the PCIe hierarchy to the Infiniband card's BAR 2.

And (sheepishly), *I* am the quirk routine author.  The mirror reveals 
the culprit!

I've temporarily disabled the custom device from my system, which 
prevents the quirk routine from running.

Everything now works!

I'm still loading mthca with fw_cmd_doorbell=1.  Exactly as you 
surmised, once the system could work in that mode, the whole thing just 
works.  I've got both card LEDs on now and can configure IPoIB links OK. 
  The subnet manager log looks good on the host workstation.

I now need to work on an improved quirk routine as I need the custom 
device and Infiniband device to work together.  I've also got to try to 
get some of the Infiniband tools compiled for the PowerPC.  The subnet 
manager cross-compiled with a bit of coaxing, some of the other tools 
look like a fair bit of work may be involved.

I'm *very* sorry this turned out to be a "user error".  I really 
appreciate your patience in helping me as I swam in my "fetid backwater" 
as mentioned above.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
