From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] svcrdma: refactor marshalling logic
Date: Fri, 25 Apr 2014 08:34:46 -0500
Message-ID: <535A6476.8080207@opengridcomputing.com>
References: <20140410183723.29724.18665.stgit@build.ogc.int> <20140425105838.GE22295@fieldses.org> <6B12FA09-0E8C-497A-9145-E2B7CAB16C53@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6B12FA09-0E8C-497A-9145-E2B7CAB16C53-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Cc: Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tom-/Yg/VP3ZvrM@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/25/2014 8:24 AM, Chuck Lever wrote:
> Hi Bruce-
>
> On Apr 25, 2014, at 6:58 AM, J. Bruce Fields <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> w=
rote:
>
>> On Thu, Apr 10, 2014 at 01:37:23PM -0500, Steve Wise wrote:
>>> From: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
>>>
>>> This patch refactors the marshalling logic to remove the intermedia=
ry
>>> map structures.  It also fixes an existing bug where the NFSRDMA se=
rver
>>> was not minding the device fast register page list length limitatio=
ns.
>>>
>>> Signed-off-by: Tom Tucker <tom-/Yg/VP3ZvrM@public.gmane.org>
>>> ---
>>>
>>> include/linux/sunrpc/svc_rdma.h          |    3
>>> net/sunrpc/xprtrdma/svc_rdma_recvfrom.c  |  551 +++++++++----------=
-----------
>>> net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  230 +------------
>>> net/sunrpc/xprtrdma/svc_rdma_transport.c |   57 ++-
>>> 4 files changed, 222 insertions(+), 619 deletions(-)
>> Is it possible to make this change in more than one step?
>>
>> RDMA is pretty esoteric to most of us, so honestly this will probabl=
y
>> get merged based just on your having tested it, but if it was possib=
le
>> to break this up into smaller patches you might give us at least a
>> fighting chance of giving it some review=85.
> I agree it could be broken up.
>
> However, my testing revealed that the patch inadvertently breaks supp=
ort
> for HCAs that do not support FRMR.  I=92ve reported this to Steve and=
 Tom.
> IMO you should wait for a newer version of the refactoring patch.

I'll figure out the regression, and work with tom to repost this as a=20
series.

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
