From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2.6.36] RDMA/cxgb3: Don't exceed the max HW CQ depth.
Date: Sun, 29 Aug 2010 09:16:44 +0200
Message-ID: <AANLkTim96=HGH_WBaPAUV2zMG0HDgFmixtHE2xQaJMyS@mail.gmail.com>
References: <20100828133505.14439.81049.stgit@build.ogc.int>
	<4C7911B4.9070904@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C7911B4.9070904-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 28, 2010 at 3:40 PM, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+v7I7tHvgBF7@public.gmane.org=
m> wrote:
>
> =A0On 8/28/2010 8:35 AM, Steve Wise wrote:
>>
>> The max depth supported by T3 is 64K entries.
>>
>> This bug will cause stalls and possibly crashes in large MPI cluster=
s.
>>
>> Signed-off-by: Steve Wise<swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
>> ---
>
> I would also like to get this into 2.6.35 stable. =A0What's the proce=
ss for that?

The easiest way is to add "CC: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>" when submitting a
patch. An alternative is after the patch has been accepted in Linus'
tree to submit it to stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org with a reference to the commit
ID in Linus' tree. More information can be found in
Documentation/stable_kernel_rules.txt.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
