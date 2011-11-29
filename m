From: Kumar Sanghvi <kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] dapltest-server segfault seen on recent OFED-1.5.4 daily
 build
Date: Tue, 29 Nov 2011 16:07:31 +0530
Message-ID: <4ED4B5EB.8000203@chelsio.com>
References: <20111118090155.GB17346@kumars-PC.asicdesigners.com> <54347E5A035A054EAE9D05927FB467F916EA49A5@ORSMSX101.amr.corp.intel.com> <4ECA3402.8030203@chelsio.com> <54347E5A035A054EAE9D05927FB467F916EA4CE2@ORSMSX101.amr.corp.intel.com> <4ECB4B17.20407@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4ECB4B17.20407-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org" <divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Arlin,

Did you get a chance to look into this further?

Also, will you be releasing a new version of dapl with the two patches 
provided earlier to OFED-1.5.4 ?


Thanks,
Kumar.

On 11/22/2011 12:41 PM, Kumar Sanghvi wrote:
> Hi Arlin,
>
> On 11/22/2011 01:51 AM, Davis, Arlin R wrote:
>> Can you send me your scripts so I can attempt to duplicate?
> Find attached the script with this mail.
>
>> Did this test setup run successfully before OFED 1.5.4 RC3 release?
> I am not sure when it stopped working.
> However, we have been running this script on dapl for quite some time,
> and it used to work fine earlier.
>
>
> Thanks,
> Kumar.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
